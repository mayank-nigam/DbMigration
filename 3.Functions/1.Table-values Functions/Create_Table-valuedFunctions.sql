
/****** Object:  UserDefinedFunction [dbo].[fn_GetEntityDetails]    Script Date: 06-06-26 10:25:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_GetEntityDetails]
(
  @EmailID nvarchar(500),
  @ParenID bigint
 )    
RETURNS @tbl TABLE    
(    
   EntityName nvarchar(200),    
   EntityID bigint    
)    
    
AS    
    
BEGIN   
    --declare @ParenID bigint = 34594
    --declare @EmailID nvarchar(500) = 'Santosh.dev@Pelsoftlabs.in' 
	   
    if(exists( select 1 from Userleads_Mobile_Email with(nolock)
	         where isnull(email,'') <> '1' and Mobile = '0' and Parentid = @ParenID 
			                   and Email = @EmailID ))
         begin
		     insert into @tbl(EntityName,EntityID)
			  select top 1 'Lead',ulme_id from Userleads_Mobile_Email with(nolock)
	         where isnull(email,'') <> '1' and Mobile = '0' and Parentid = @ParenID 
			                   and Email = @EmailID        
		 end        
     else if(exists( select 1 from Userenquiry_Mobile_Email with(nolock)
	         where isnull(email,'') <> '1' and Mobile = '0' and Parentid = @ParenID 
			                   and Email = @EmailID ))
         begin
		     insert into @tbl(EntityName,EntityID)
			  select top 1 'Enquiry',enquiryid from Userenquiry_Mobile_Email with(nolock)
	         where isnull(email,'') <> '1' and Mobile = '0' and Parentid = @ParenID 
			                   and Email = @EmailID        
		 end
          


    return
 end
GO

/****** Object:  UserDefinedFunction [dbo].[fn_getIndiaStartEndTimefromUserTime]    Script Date: 06-06-26 10:25:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[fn_getIndiaStartEndTimefromUserTime]
(@user_id bigint, @dbdatetime datetime)        
RETURNS @table TABLE(
StartDateTime datetime,
EndDateTime datetime 
) 
BEGIN

Declare @dbdatetime1 DateTime = DATEADD(Day, 1, @dbdatetime);

insert into @table (StartDateTime, EndDateTime)	
select cast(convert(datetime,@dbdatetime) 
AT TIME zone 'India Standard Time' 
AT TIME ZONE cast(isnull(timezone, 'India Standard Time') as nvarchar(200)) 
as datetime), cast(convert(datetime,@dbdatetime1) 
AT TIME zone 'India Standard Time' 
AT TIME ZONE cast(isnull(timezone, 'India Standard Time') as nvarchar(200)) 
as datetime) from User_Detail u where user_id = @user_id 
 RETURN

END

GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetTBLUseridFromRole]    Script Date: 06-06-26 10:25:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_GetTBLUseridFromRole](@entity nvarchar(100),@activityid bigint,@role nvarchar(max)) 
returns @users table (roleuserid bigint) 
as 
begin 
--select [value] as rolename into #t from dbo.fn_split(@role,',') 
 
declare @userids nvarchar(max),@user bigint,@parentid bigint,@eventid int,@eventgroup nvarchar(100),@entityid bigint, 
@reftables nvarchar(max),@refids nvarchar(max),@seektable nvarchar(100),@context nvarchar(100) 
if @entity='lead' 
begin 
select @user=userid,@parentid=ParentID,@eventid=eventid,@entityid=LeadID,@reftables=reftables,@refids=refids,@seektable='tbl_LeadEventHistory' 
from tbl_LeadEventHistory(nolock) where historyid=@activityid 
end 
if @entity='enquiry' 
begin 
select @user=userid,@parentid=ParentID,@eventid=eventid,@entityid=EnquiryID,@reftables=reftables,@refids=refids,@seektable='tbl_enquiryEventHistory' from tbl_enquiryEventHistory(nolock) where historyid=@activityid 
end 
if @entity='user' 
begin 
select @user=userid,@parentid=ParentID,@eventid=eventid,@entityid=userid,@reftables=reftables,@refids=refids,@seektable='tbl_userEventHistory' from tbl_userEventHistory(nolock) where historyid=@activityid 
end 
 
select @eventgroup = eventtype,@context=context from activitymaster(nolock) where id=@eventid 
 
if @eventgroup is null 
begin 
select @role='' 
end 
 
if @role like '%Siteowner%' 
begin 
insert into @users(roleuserid) 
select 335 
end 
if @role like '%Partner%' 
begin 
insert into @users(roleuserid) 
select 0 
end 
if @role like '%SuperAdmin%' 
begin 
insert into @users(roleuserid) 
select @parentid 
end 
if @role like '%Admin%' 
begin 
insert into @users(roleuserid) 
select user_id from user_detail(nolock) where parentid=@parentid and IsAdmin=1 
end 
if @role like '%Manager%' 
begin 
if @eventgroup='TimeTracking' 
begin 
--select distinct manageruser_id into #mgr from mysmstimetrack.[dbo].[timetracking_roleusermapping](nolock) m 
insert into @users(roleuserid) 
select manageruser_id from mysmstimetrack.[dbo].[timetracking_roleusermapping] m with (nolock) 
join user_detail(nolock) u on u.user_id=manageruser_id and u.status=1 and m.user_id=@user 
end 
else 
begin 
insert into @users(roleuserid) 
select 0 
end 
end 
if @role like 'Owner%' or @role like '%,Owner%' 
begin 
if @context<>'lead' 
begin 
insert into @users(roleuserid) 
select @user 
end 
else if @eventgroup in ('Task','appointment') and @context='lead' 
begin 
insert into @users(roleuserid) 
select AssignedTo from tbl_tsk_TaskHistory(nolock) where id=@refids 
end 
else if @eventgroup in ('lifecycle','chat') and @context='lead' 
begin 
if @reftables='leadinteractionhistory' 
begin 
insert into @users(roleuserid) 
select assignedto from leadinteractionhistory(nolock) where id=@refids 
end 
else 
begin 
insert into @users(roleuserid) 
select assignedto from userleads(nolock) where id=@entityid 
end 
end 
else if @eventgroup='deal' and @context='lead' 
begin 
insert into @users(roleuserid) 
select DealOwner from LeadPipelineMapping(nolock) where id=@refids 
end 
else if @eventgroup='support' and @context='lead' 
begin 
insert into @users(roleuserid) 
select * from 
(select user_id_old from serv_user_detail (nolock) where ser_user_id = 
(select t.assignto from serv_ticketmaster t(nolock) 
left join Serv_TicketHistory h (nolock) on t.ticketid=h.TicketID 
left join Serv_ticket_feedback_tbl(nolock) f on f.TICKETID=t.ticketid 
where 
(h.tickethistoryid is null or 
cast(h.tickethistoryid as nvarchar)= 
case when @reftables='serv_ticketmaster' 
then (select max(tickethistoryid) from serv_tickethistory where ticketid=h.ticketid) 
when @reftables='Serv_ticket_feedback_tbl' then cast(f.TicketHistoryID as nvarchar) 
when @reftables='Serv_TicketHistory' then @refids end) 
and 
cast(f.id as nvarchar)=case when @reftables='Serv_ticket_feedback_tbl' then @refids else null end 
and cast(t.TicketID as nvarchar)=case when @reftables='serv_ticketmaster' 
then @refids else cast(t.TicketID as nvarchar) end 
)) a 
end 
else 
begin 
insert into @users(roleuserid) 
select assignedto from userleads(nolock) where id=@entityid 
end 
 
end 
if @role like '%Creator%' 
begin 
 
if @eventgroup in ('Task','appointment') and @context='lead' 
begin 
insert into @users(roleuserid) 
select CreatedBy from tbl_tsk_TaskHistory(nolock) where id=@refids 
end 
else if @eventgroup='lifecycle' and @context='lead' 
begin 
if @reftables='leadinteractionhistory' 
begin 
insert into @users(roleuserid) 
select CreatedBy from leadinteractionhistory(nolock) where id=@refids 
end 
else 
begin 
insert into @users(roleuserid) 
select CreatedBy from userleads(nolock) where id=@entityid 
end 
end 
else if @eventgroup='deal' and @context='lead' 
begin 
insert into @users(roleuserid) 
select CreatedBy from LeadPipelineMapping(nolock) where id=@refids 
end 
else if @eventgroup='support' and @context='lead' 
begin 
insert into @users(roleuserid) 
select * from 
(select user_id_old from serv_user_detail (nolock) where ser_user_id = 
(select h.raisedby from serv_ticketmaster t(nolock) 
left join Serv_TicketHistory h (nolock) on t.ticketid=h.TicketID 
left join Serv_ticket_feedback_tbl(nolock) f on f.TICKETID=t.ticketid 
where 
(h.tickethistoryid is null or 
cast(h.tickethistoryid as nvarchar)= 
case when @reftables='serv_ticketmaster' 
then (select max(tickethistoryid) from serv_tickethistory where ticketid=h.ticketid) 
when @reftables='Serv_ticket_feedback_tbl' then cast(f.TicketHistoryID as nvarchar) 
when @reftables='Serv_TicketHistory' then @refids end) 
and 
cast(f.id as nvarchar)=case when @reftables='Serv_ticket_feedback_tbl' then @refids else null end 
and cast(t.TicketID as nvarchar)=case when @reftables='serv_ticketmaster' 
then @refids else cast(t.TicketID as nvarchar) end 
)) a 
end 
else 
begin 
insert into @users(roleuserid) 
select @user 
end 
end 
if @role like '%Collaborator%' 
begin 
if @eventgroup in ('Task','appointment') and @context='lead' 
begin 
insert into @users(roleuserid) 
select user_id from tbl_tsk_CollaborationUserMapping (nolock) 
c join tbl_tsk_TaskHistory(nolock) t on t.id=c.TaskHistoryId 
where t.id=@refids 
end 
else if @eventgroup in ('lifecycle','chat') and @context='lead' 
begin 
if @reftables='leadinteractionhistory' 
begin 
insert into @users(roleuserid) 
select assignedto from leadinteractionhistory(nolock) where id=@refids 
end 
else 
begin 
insert into @users(roleuserid) 
select assignedto from userleads(nolock) where id=@entityid 
end 
end 
else if @eventgroup='deal' and @context='lead' 
begin 
insert into @users(roleuserid) 
select DealOwner from LeadPipelineMapping(nolock) where id=@refids 
end 
else if @eventgroup='support' and @context='lead' 
begin 
insert into @users(roleuserid) 
select user_id_old 
FROM [MySMS].[dbo].[Serv_Agent_Mast] where group_id= 
(select t.Assign_Group from serv_ticketmaster t(nolock) 
left join Serv_TicketHistory h (nolock) on t.ticketid=h.TicketID 
where 
(h.tickethistoryid is null or 
cast(h.tickethistoryid as nvarchar)= 
case when @reftables='serv_ticketmaster' 
then (select max(tickethistoryid) from serv_tickethistory where ticketid=h.ticketid) 
when @reftables='Serv_TicketHistory' then @refids end) 
and cast(t.TicketID as nvarchar)=case when @reftables='serv_ticketmaster' 
then @refids else cast(t.TicketID as nvarchar) end 
) 
end 
else 
begin 
insert into @users(roleuserid) 
select @user 
end 
end 
else 
begin 
insert into @users(roleuserid) 
select 0 
end 
 
return 
end 
 
 
 
--select top 10 * from tbl_tsk_CollaborationUserMapping 
--select * from tbl_LeadEventHistory(nolock) where eventid=53 reftables='LeadPipelineMapping' 
 
--569428 

GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetVoiceCreditCalculation]    Script Date: 06-06-26 10:25:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_GetVoiceCreditCalculation]  
(@AccTypeValue nvarchar(20),@userID bigint,@duration int,@mcount int)            
RETURNS @temptable TABLE (            
            
       balance numeric(18,4), --the ancestor objects delimited by a '/'            
            
       msg VARCHAR(20),            
            
       PulseRate numeric(18,4),            
            
       price numeric(18,4) )            
as             
begin             
            
--declare @tempt TABLE (            
            
--       balance numeric(18,4), --the ancestor objects delimited by a '/'            
            
--       msg VARCHAR(20),            
            
--       PulseRate numeric(18,4),            
            
--       price numeric(18,4) )            
                                     
declare @intdur as bigint                                  
, @fracdur as bigint                                  
,@Pulse_Rate as bigint            
,@price numeric(18,4)             
,@cr_amt numeric(18,4)               
,@Actualbalance numeric(18,4)             
   
   declare @ParentID bigint = ( select top 1 isnull(ParentID,0) from User_Detail with(nolock) where User_ID = @userID )
            
select top 1 @Actualbalance = Balance from dbo.IntCredit_Details with(nolock) where USER_ID = @ParentID order by Credit_ID desc                                                          
if exists(select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                                  
            when @AccTypeValue = 'MTIX_PRO'  or @AccTypeValue ='promo'  then LocalRPromo                                  
   when @AccTypeValue = 'MTIX_TRC'  or @AccTypeValue ='promo' then LocalRTrnsScurb                                  
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                                 
      from Price_Base_Voice_Rate_Exception with(nolock) where OriginCountryId=101 and USERID=@ParentID and destinationCountryid=101)    
begin                                  
set @price=                                  
(                                  
select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                                  
            when @AccTypeValue = 'MTIX_PRO'  or @AccTypeValue ='promo'  then LocalRPromo                                  
   when @AccTypeValue = 'MTIX_TRC'  or @AccTypeValue ='promo' then LocalRTrnsScurb                                  
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                                 
      from Price_Base_Voice_Rate_Exception with(nolock) where OriginCountryId=101 and USERID=@ParentID and destinationCountryid=101      
)    
end     
else    
begin                              
set @price=                                  
(                                      
select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                      
            when @AccTypeValue = 'MTIX_PRO' or @AccTypeValue ='promo'  then LocalRPromo                                  
   when @AccTypeValue = 'MTIX_TRC' or @AccTypeValue ='promo'  then LocalRTrnsScurb                                  
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                                   
         from Price_Base_Voice_Rate with(nolock) where OriginCountryId=101 and destinationCountryid=101                                  
)                                  
end    
    
set @Pulse_Rate=30                                  
                                  
select @intdur =Convert(int,@duration/@Pulse_Rate),                                  
 @fracdur= @duration%@Pulse_Rate                                   
                                  
if @fracdur >0                                  
 set @intdur = @intdur+1                                    
                                  
set @Cr_amt=@price * @mCount * @intdur              
            
insert into @temptable(balance,msg,PulseRate,price)             
select @Cr_amt as balance,case when @Actualbalance >= @Cr_amt then 'ok' else 'err' end as msg,@Pulse_Rate PulseRate,@Price Price             
            
            
return                  
            
end            
                                   
            
            
--select * from dbo.fn_GetVoiceCreditCalculation('MTIX_TR',30846,180,5548)
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetVoiceCreditCalculation_old20190619]    Script Date: 06-06-26 10:25:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_GetVoiceCreditCalculation_old20190619]        
(@AccTypeValue nvarchar(20),@userID bigint,@duration int,@mcount int)        
RETURNS @temptable TABLE (        
        
       balance numeric(18,4), --the ancestor objects delimited by a '/'        
        
       msg VARCHAR(20),        
        
       PulseRate numeric(18,4),        
        
       price numeric(18,4) )        
as         
begin         
        
--declare @tempt TABLE (        
        
--       balance numeric(18,4), --the ancestor objects delimited by a '/'        
        
--       msg VARCHAR(20),        
        
--       PulseRate numeric(18,4),        
        
--       price numeric(18,4) )        
                                 
declare @intdur as bigint                              
, @fracdur as bigint                              
,@Pulse_Rate as bigint        
,@price numeric(18,4)         
,@cr_amt numeric(18,4)           
,@Actualbalance numeric(18,4)         
        
select top 1 @Actualbalance = Balance from dbo.IntCredit_Details where USER_ID = @userid order by Credit_ID desc                                                      
                              
set @price=                              
(                              
select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                              
            when @AccTypeValue = 'MTIX_PRO'  or @AccTypeValue ='promo'  then LocalRPromo                              
   when @AccTypeValue = 'MTIX_TRC'  or @AccTypeValue ='promo' then LocalRTrnsScurb                              
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                             
      from Price_Base_Voice_Rate_Exception where OriginCountryId=101 and USERID=@userID and destinationCountryid=101                              
union                              
select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                  
            when @AccTypeValue = 'MTIX_PRO' or @AccTypeValue ='promo'  then LocalRPromo                              
   when @AccTypeValue = 'MTIX_TRC' or @AccTypeValue ='promo'  then LocalRTrnsScurb                              
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                               
         from Price_Base_Voice_Rate where OriginCountryId=101 and destinationCountryid=101                              
)                              
 set @Pulse_Rate=30                              
                              
select @intdur =Convert(int,@duration/@Pulse_Rate),                              
 @fracdur= @duration%@Pulse_Rate                               
                              
if @fracdur >0                              
 set @intdur = @intdur+1                                
                              
set @Cr_amt=@price * @mCount * @intdur          
        
insert into @temptable(balance,msg,PulseRate,price)         
select @Cr_amt as balance,case when @Actualbalance >= @Cr_amt then 'ok' else 'err' end as msg,@Pulse_Rate PulseRate,@Price Price         
        
        
return                        
        
end        
                               
        
        
--select * from dbo.fn_GetVoiceCreditCalculation('MTIX_TR',30846,180,5548)
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetVoiceCreditCalculation1]    Script Date: 06-06-26 10:25:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_GetVoiceCreditCalculation1]        
(@AccTypeValue nvarchar(20),@userID bigint,@duration int,@mcount int)        
RETURNS @temptable TABLE (        
        
       balance numeric(18,4), --the ancestor objects delimited by a '/'        
        
       msg VARCHAR(20),        
        
       PulseRate numeric(18,4),        
        
       price numeric(18,4) )        
as         
begin         
        
--declare @tempt TABLE (        
        
--       balance numeric(18,4), --the ancestor objects delimited by a '/'        
        
--       msg VARCHAR(20),        
        
--       PulseRate numeric(18,4),        
        
--       price numeric(18,4) )        
                                 
declare @intdur as bigint                              
, @fracdur as bigint                              
,@Pulse_Rate as bigint        
,@price numeric(18,4)         
,@cr_amt numeric(18,4)           
,@Actualbalance numeric(18,4)         
        
select top 1 @Actualbalance = Balance from dbo.IntCredit_Details where USER_ID = @userid order by Credit_ID desc                                                      
if exists(select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                              
            when @AccTypeValue = 'MTIX_PRO'  or @AccTypeValue ='promo'  then LocalRPromo                              
   when @AccTypeValue = 'MTIX_TRC'  or @AccTypeValue ='promo' then LocalRTrnsScurb                              
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                             
      from Price_Base_Voice_Rate_Exception where OriginCountryId=101 and USERID=@userID and destinationCountryid=101)
begin                              
set @price=                              
(                              
select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                              
            when @AccTypeValue = 'MTIX_PRO'  or @AccTypeValue ='promo'  then LocalRPromo                              
   when @AccTypeValue = 'MTIX_TRC'  or @AccTypeValue ='promo' then LocalRTrnsScurb                              
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                             
      from Price_Base_Voice_Rate_Exception where OriginCountryId=101 and USERID=@userID and destinationCountryid=101  
)
end 
else
begin                          
set @price=                              
(                                  
select case when @AccTypeValue = 'MTIX_TR' or @AccTypeValue = 'trans' then LocalRTrns                  
            when @AccTypeValue = 'MTIX_PRO' or @AccTypeValue ='promo'  then LocalRPromo                              
   when @AccTypeValue = 'MTIX_TRC' or @AccTypeValue ='promo'  then LocalRTrnsScurb                              
   when @AccTypeValue = 'CRITICAL' then LocalRCritical end as pprice                               
         from Price_Base_Voice_Rate where OriginCountryId=101 and destinationCountryid=101                              
)                              
end

set @Pulse_Rate=30                              
                              
select @intdur =Convert(int,@duration/@Pulse_Rate),                              
 @fracdur= @duration%@Pulse_Rate                               
                              
if @fracdur >0                              
 set @intdur = @intdur+1                                
                              
set @Cr_amt=@price * @mCount * @intdur          
        
insert into @temptable(balance,msg,PulseRate,price)         
select @Cr_amt as balance,case when @Actualbalance >= @Cr_amt then 'ok' else 'err' end as msg,@Pulse_Rate PulseRate,@Price Price         
        
        
return                        
        
end        
                               
        
        
--select * from dbo.fn_GetVoiceCreditCalculation('MTIX_TR',30846,180,5548)
GO

/****** Object:  UserDefinedFunction [dbo].[fn_separatecountrycodeandmobile]    Script Date: 06-06-26 10:25:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fn_separatecountrycodeandmobile]    
(@mobilewithcountrycode nvarchar(50))        
RETURNS @countrycodeseparated TABLE        
        
(        
  mobile nvarchar(20),        
  countrycode nvarchar(10),    
  country nvarchar(100),    
  countryid int        
)        
        
AS        
        
BEGIN        
        
DECLARE @countrycode nvarchar(10),  @cclen int,  
  @country nvarchar(100),    
  @countryid int,@mobilewithoutcountrycode nvarchar(20)  --,@mobilewithcountrycode nvarchar(50)='917840049991'         
    
select @mobilewithcountrycode=dbo.fn_trim0prefix(replace(replace(replace(@mobilewithcountrycode,'+',''),'-',''),' ',''))    
select top 1 @countrycode=countrycode,@country=Country_Name,@countryid=Country_ID    
from m_country1(nolock)    
where replace(ltrim(rtrim(countrycode)),'+','')=left(@mobilewithcountrycode,len(replace(ltrim(rtrim(countrycode)),'+','')))  
select @cclen=len(replace(@countrycode,'+',''))
select @mobilewithoutcountrycode=right(@mobilewithcountrycode,len(@mobilewithcountrycode)-@cclen)
--select top 1 @mobilewithoutcountrycode=replace(@mobilewithcountrycode,replace(@countrycode,'+',''),'')
--select @mobilewithcountrycode,@countrycode,@country,@countryid
--declare table @countrycodeseparated
insert into @countrycodeseparated(mobile,countrycode,country,countryid)    
select @mobilewithoutcountrycode,@countrycode,@country,@countryid    
        
 return       
        
END 
GO

/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 06-06-26 10:25:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[fn_Split](@text varchar(MAX), @delimiter varchar(20) = ' ')  
  
RETURNS @Strings TABLE  
  
(  
  position int IDENTITY PRIMARY KEY,  
  value varchar(4000)  
)  
  
AS  
  
BEGIN  
  
DECLARE @index int   
  
SET @index = -1   
WHILE (LEN(@text) > 0)   
  
  BEGIN    
  
    SET @index = CHARINDEX(@delimiter , @text)    
  
    IF (@index = 0) AND (LEN(@text) > 0)    
  
      BEGIN     
  
        INSERT INTO @Strings VALUES (@text)  
  
          BREAK    
  
      END    
  
    IF (@index > 1)    
  
      BEGIN     
  
        INSERT INTO @Strings VALUES (LEFT(@text, @index - 1))     
  
        SET @text = RIGHT(@text, (LEN(@text) - @index))    
  
      END    
  
    ELSE   
  
      SET @text = RIGHT(@text, (LEN(@text) - @index))   
  
    END  
  
  RETURN  
  
END


GO

/****** Object:  UserDefinedFunction [dbo].[fn_Split_SMS]    Script Date: 06-06-26 10:25:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[fn_Split_SMS](@text varchar(max),@U_ID Bigint,@Sender nvarchar(50),@message nvarchar(max),@date nvarchar(max),@BatchID Bigint)    
    
RETURNS @Strings TABLE    
    
(        
    
  position int IDENTITY PRIMARY KEY,    
    
  value varchar(max),    
  U_ID Bigint,
  Senderid nvarchar(50),    
  message nvarchar(max),    
  date nvarchar(max),
  BatchID Bigint    
)    
    
AS    
    
BEGIN    
    
     
    
DECLARE @index int     
    
SET @index = -1     
    
     
    
WHILE (LEN(@text) >=0)     
    
  BEGIN      
    
    SET @index = 1199     
    
    IF (LEN(@text) <= 1199)      
    
      BEGIN       
    
        INSERT INTO @Strings VALUES (@text,@U_ID,@Sender,@message,@date,@BatchID)    
    
          BREAK      
    
      END      
    
    IF (LEN(@text) > 1199)      
    
      BEGIN       
    
        INSERT INTO @Strings VALUES (LEFT(@text, 1199),@U_ID,@Sender,@message,@date,@BatchID)       
            
        SET @text = RIGHT(@text, (LEN(@text) - (@index+1)))      
        SET @U_ID=@U_ID   
        SET @Sender=@sender 
        SET @message=@message    
        SET @date=@date
        SET @BatchID=@BatchID    
            
      END      
    
    ELSE     
    
      SET @text = RIGHT(@text, (LEN(@text) - (@index+1)))     
      SET @U_ID=@U_ID
      SET @Sender=@sender
      SET @message=@message    
      SET @date=@date 
      SET @BatchID=@BatchID    
    END    
    
  RETURN    
    
END    
GO

/****** Object:  UserDefinedFunction [dbo].[fn_Split_SMS_New]    Script Date: 06-06-26 10:25:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[fn_Split_SMS_New](@text varchar(max),@U_ID Bigint,@message nvarchar(max),@date nvarchar(max),
@batchid Bigint)

RETURNS @Strings TABLE

(    
  position int IDENTITY PRIMARY KEY,
  value varchar(max),
  U_ID Bigint,
  message nvarchar(max),
  date nvarchar(max),
  batchid Bigint
)

AS

BEGIN

 

DECLARE @index int 

SET @index = -1 

 

WHILE (LEN(@text) >=0) 

  BEGIN  

    SET @index = 1199 

    IF (LEN(@text) <= 1199)  

      BEGIN   

        INSERT INTO @Strings VALUES (@text,@U_ID,@message,@date,@batchid)

          BREAK  

      END  

    IF (LEN(@text) > 1199)  

      BEGIN   

        INSERT INTO @Strings VALUES (LEFT(@text, 1199),@U_ID,@message,@date,@batchid)   
        
        SET @text = RIGHT(@text, (LEN(@text) - (@index+1)))  
        SET @U_ID=@U_ID
        SET @message=@message
        SET @date=@date
        SET @batchid=@batchid
      END  

    ELSE 

      SET @text = RIGHT(@text, (LEN(@text) - (@index+1))) 
      SET @U_ID=@U_ID
      SET @message=@message
      SET @date=@date
      SET @batchid=@batchid
    END

  RETURN

END
GO

/****** Object:  UserDefinedFunction [dbo].[fn_Split_SMS_Test]    Script Date: 06-06-26 10:25:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE   FUNCTION [dbo].[fn_Split_SMS_Test](@text varchar(max),@U_ID Bigint,@message nvarchar(max),@date nvarchar(max),@BatchID Bigint)    
    
RETURNS @Strings TABLE    
    
(        
    
  position int IDENTITY PRIMARY KEY,    
    
  value varchar(max),    
  U_ID Bigint,    
  message nvarchar(max),    
  date nvarchar(max),
  BatchID Bigint    
)    
    
AS    
    
BEGIN    
    
     
    
DECLARE @index int     
    
SET @index = -1     
    
     
    
WHILE (LEN(@text) >=0)     
    
  BEGIN      
    
    SET @index = 1199     
    
    IF (LEN(@text) <= 1199)      
    
      BEGIN       
    
        INSERT INTO @Strings VALUES (@text,@U_ID,@message,@date,@BatchID)    
    
          BREAK      
    
      END      
    
    IF (LEN(@text) > 1199)      
    
      BEGIN       
    
        INSERT INTO @Strings VALUES (LEFT(@text, 1199),@U_ID,@message,@date,@BatchID)       
            
        SET @text = RIGHT(@text, (LEN(@text) - (@index+1)))      
        SET @U_ID=@U_ID    
        SET @message=@message    
        SET @date=@date
        SET @BatchID=@BatchID    
            
      END      
    
    ELSE     
    
      SET @text = RIGHT(@text, (LEN(@text) - (@index+1)))     
      SET @U_ID=@U_ID    
      SET @message=@message    
      SET @date=@date 
      SET @BatchID=@BatchID    
    END    
    
  RETURN    
    
END    
    
    
GO

/****** Object:  UserDefinedFunction [dbo].[fnExtractPlaceholders]    Script Date: 06-06-26 10:25:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fnExtractPlaceholders]
(
    @input NVARCHAR(MAX)
)
RETURNS @Placeholders TABLE
(
    Placeholder NVARCHAR(200)
)
AS
BEGIN
    DECLARE @start INT, @end INT, @len INT;

    SET @start = CHARINDEX('#', @input);

    WHILE @start > 0
    BEGIN
        SET @end = CHARINDEX('#', @input, @start + 1);

        IF @end > 0
        BEGIN
            SET @len = @end - @start + 1;

            INSERT INTO @Placeholders(Placeholder)
            SELECT SUBSTRING(@input, @start, @len);

            -- Move past this placeholder
            SET @start = CHARINDEX('#', @input, @end + 1);
        END
        ELSE
        BEGIN
            BREAK;
        END
    END

    RETURN;
END;

GO

/****** Object:  UserDefinedFunction [dbo].[fu_SplitString]    Script Date: 06-06-26 10:25:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[fu_SplitString]  
(  
   @Input NVARCHAR(MAX),  
   @Character CHAR(1)  
)  
RETURNS @Output TABLE (  
   Item NVARCHAR(Max)  
)  
AS  
BEGIN  
DECLARE @StartIndex INT, @EndIndex INT  
SET @StartIndex = 1  
IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character  
BEGIN  
SET @Input = @Input + @Character  
END  
WHILE CHARINDEX(@Character, @Input) > 0  
BEGIN  
SET @EndIndex = CHARINDEX(@Character, @Input)  
INSERT INTO @Output(Item)  
SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)  
SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))  
END  
RETURN  
END
  

GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchCRMUnsubscribe]    Script Date: 06-06-26 10:25:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[funcGetCampaignSearchCRMUnsubscribe]
(
	@SearchID BIGINT
)
RETURNS @table TABLE(mobileno VARCHAR(50))          

          

BEGIN
	INSERT INTO @table
	SELECT DISTINCT fgun.mobileno
	FROM   SearchDetails AS sd
	       OUTER APPLY funcGetUnsubscribeNumbersCRM(sd.FromDate, sd.ToDate) AS 
	fgun
	WHERE  sd.ID = @SearchID
	       AND sd.IsCRMDB = 1
	       AND sd.IsUnsubscribe = 1
	
	
	
	RETURN
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchCRMUsers]    Script Date: 06-06-26 10:25:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
  
CREATE   FUNCTION [dbo].[funcGetCampaignSearchCRMUsers]  
(  
 @SearchID BIGINT  
)  
RETURNS @table TABLE(mobileno VARCHAR(50))      
      
BEGIN  
 INSERT INTO @table  
 SELECT A.Mobile  
 FROM   (  
            SELECT [USER_ID],  
                   User_Login,  
                   FName,  
                   LName,  
                   Email,  
                   Mobile,  
                   [ADDRESS],  
                   RoleName  
            FROM   [dbo].[funcToGetCRMDetails_InsertUsers_Users](@SearchID)   
            UNION       
            SELECT [USER_ID],  
                   User_Login,  
                   FName,  
                   LName,  
                   Email,  
                   Mobile,  
                   [ADDRESS],  
                   RoleName  
            FROM   [dbo].[funcToGetCRMDetails_InsertUsers_Role](@SearchID)  
        ) A  
 WHERE  A.[USER_ID] IS NOT NULL   
   
 RETURN  
END  
GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchCRMUsersMails]    Script Date: 06-06-26 10:25:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
  
CREATE   FUNCTION [dbo].[funcGetCampaignSearchCRMUsersMails]  
(  
 @SearchID BIGINT  
)  
RETURNS @table TABLE(Emails VARCHAR(200))      
      
BEGIN  
 INSERT INTO @table  
 SELECT A.Email as Emails  
 FROM   (  
            SELECT [USER_ID],  
                   User_Login,  
                   FName,  
                   LName,  
                   Email,  
                   Mobile,  
                   [ADDRESS],  
                   RoleName  
            FROM   [dbo].[funcToGetCRMDetails_InsertUsers_Users](@SearchID)   
            UNION       
            SELECT [USER_ID],  
                   User_Login,  
                   FName,  
                   LName,  
                   Email,  
                   Mobile,  
                   [ADDRESS],  
                   RoleName  
            FROM   [dbo].[funcToGetCRMDetails_InsertUsers_Role](@SearchID)  
        ) A  
 WHERE  A.[USER_ID] IS NOT NULL   
   
 RETURN  
END  
GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchKit19Leads]    Script Date: 06-06-26 10:25:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

     
    
CREATE   FUNCTION [dbo].[funcGetCampaignSearchKit19Leads]
(
	@SearchID BIGINT
)
RETURNS @table TABLE(mobileno VARCHAR(20))        
        
BEGIN
	INSERT INTO @table
	SELECT DISTINCT fgun3.Mobile
	FROM   SearchDetails AS sd
	       OUTER APPLY funcToGetLeadMicrosite_Datewise(sd.MicrositeName, sd.FromDate, sd.ToDate) AS 
	fgun3
	WHERE  sd.ID = @SearchID
	       AND sd.IsKit19 = 1
	       AND sd.IsLeads = 1
	       AND fgun3.MicrositeName IS NOT NULL 
	
	RETURN
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchKit19LeadsMails]    Script Date: 06-06-26 10:25:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

     
    
CREATE   FUNCTION [dbo].[funcGetCampaignSearchKit19LeadsMails]
(
	@SearchID BIGINT
)
RETURNS @table TABLE(Email VARCHAR(200))        
        
BEGIN
	INSERT INTO @table
	SELECT DISTINCT fgun3.Email as Email
	FROM   SearchDetails AS sd
	       OUTER APPLY funcToGetLeadMicrosite_Datewise(sd.MicrositeName, sd.FromDate, sd.ToDate) AS 
	fgun3
	WHERE  sd.ID = @SearchID
	       AND sd.IsKit19 = 1
	       AND sd.IsLeads = 1
	       AND fgun3.MicrositeName IS NOT NULL 
	
	RETURN
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchKit19User]    Script Date: 06-06-26 10:25:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

CREATE   FUNCTION [dbo].[funcGetCampaignSearchKit19User]
(
	@SearchID BIGINT
)
RETURNS @table TABLE(mobileno FLOAT)        
        
BEGIN
	DECLARE @UserName                     VARCHAR(MAX),
	        @UserFilter                   VARCHAR(MAX),
	        @UserType                     VARCHAR(MAX),
	        @Mobile                       VARCHAR(MAX),
	        @EmailID                      VARCHAR(MAX),
	        @LastLoginBeforeFrom          VARCHAR(MAX),
	        @LastLoginBeforeTo            VARCHAR(MAX),
	        @LastPurchaseDaysFrom         VARCHAR(MAX),
	        @LastPurchaseDaysTo           VARCHAR(MAX),
	        @LastPurchasePriceFrom        VARCHAR(MAX),
	        @LastPurchasePriceTo          VARCHAR(MAX),
	        @TotalCreditPurchasedFrom     VARCHAR(MAX),
	        @TotalCreditPurchasedTo       VARCHAR(MAX),
	        @TotalCreditConsumedFrom      VARCHAR(MAX),
	        @TotalCreditConsumedTo        VARCHAR(MAX),
	        @CreatedBetweenFrom           VARCHAR(MAX),
	        @CreatedBetweenTo             VARCHAR(MAX),
	        @BalanceFrom                  VARCHAR(MAX),
	        @BalanceTo                    VARCHAR(MAX),
	        @IsNewUser                    BIT,
	        @ID                           BIGINT,
	        @Valuecheck                   BIGINT      
	
	
	
	SELECT @Valuecheck = sd.ID,
	       @ID                           = sd.ID,
	       @IsNewUser                    = ISNULL(sd.IsNewUser, 0),
	       @BalanceFrom                  = ISNULL(sd.BalanceFrom, 0),
	       @BalanceTo                    = ISNULL(sd.BalanceTo, 0),
	       @UserName                     = ISNULL(sd.UserName, ''),
	       @UserFilter                   = ISNULL(sd.UserFilter, ''),
	       @UserType                     = ISNULL(sd.UserType, ''),
	       @Mobile                       = ISNULL(sd.Mobile, 0),
	       @EmailID                      = ISNULL(sd.EmailID, ''),
	       @LastLoginBeforeFrom          = ISNULL(sd.LastLoginBeforeFrom, 0),
	       @LastLoginBeforeTo            = ISNULL(sd.LastLoginBeforeTo, 0),
	       @LastPurchaseDaysFrom         = ISNULL(sd.LastPurchaseDaysFrom, 0),
	       @LastPurchaseDaysTo           = ISNULL(sd.LastPurchaseDaysTo, 0),
	       @LastPurchasePriceFrom        = ISNULL(sd.LastPurchasePriceFrom, 0),
	       @LastPurchasePriceTo          = ISNULL(sd.LastPurchasePriceTo, 0),
	       @TotalCreditPurchasedFrom     = ISNULL(sd.TotalCreditPurchasedFrom, 0),
	       @TotalCreditPurchasedTo       = ISNULL(sd.TotalCreditPurchasedTo, 0),
	       @TotalCreditConsumedFrom      = ISNULL(sd.TotalCreditConsumedFrom, 0),
	       @TotalCreditConsumedTo        = ISNULL(sd.TotalCreditConsumedTo, 0),
	       @CreatedBetweenFrom           = ISNULL(sd.CreatedBetweenFrom, ''),
	       @CreatedBetweenTo             = ISNULL(sd.CreatedBetweenTo, '')
	FROM   SearchDetails AS sd
	WHERE  sd.ID = @SearchID
	       AND sd.IsKit19 = 1    
	
	IF (ISNULL(@Valuecheck, '') <> '')
	BEGIN
	    INSERT INTO @table
	    SELECT CAST(A.Mobile AS FLOAT)
	    FROM   (
	               SELECT ud.[USER_ID],
	                      ud.M_ID,
	                      ud.User_Login,
	                      ud.FName + ' ' + ud.LName AS NAME,
	                      ud.Email,
	                      ud.Mobile,
	                      ud.[ADDRESS],
	                      ud.City,
	                      ud.[STATE],
	                      uf.Name      AS User_Filter
	               FROM   User_Detail  AS ud
	                      INNER JOIN User_Filter AS uf
	                           ON  uf.Code = ud.userfilter
	                      LEFT JOIN dbo.funcToGetUserDetails_UserNamewise(@UserName) AS 
	                           ftg
	                           ON  ftg.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_UserFilterwise(@UserFilter) AS 
	                           ftg2
	                           ON  ftg2.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_Balancewise(@BalanceFrom, @BalanceTo) AS 
	                           ftg3
	                           ON  ftg3.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_Creditwise(@TotalCreditPurchasedFrom, @TotalCreditPurchasedTo) AS 
	                           ftg4
	                           ON  ftg4.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_Debitwise(@TotalCreditConsumedFrom, @TotalCreditConsumedTo) AS 
	                           ftg5
	                           ON  ftg5.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_CreditBetweenwise(@CreatedBetweenFrom, @CreatedBetweenTo) AS 
	                           ftg6
	                           ON  ftg6.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGet_UserSearch_NewUserIDWise(@IsNewUser) AS 
	                           ftg7
	                           ON  ftg7.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_MobileNowise(@Mobile) AS 
	                           ftg8
	                           ON  ftg8.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_EmailIDwise(@EMailID) AS 
	                           ftg9
	                           ON  ftg9.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserDetails_UserTypewise(@UserType) AS 
	                           ftg10
	                           ON  ftg10.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserSearch_LastLoginBeforeFrom(@LastLoginBeforeFrom, @LastLoginBeforeTo) AS 
	                           ftg11
	                           ON  ftg11.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserSearch_LastPurchasedFrom(@LastPurchaseDaysFrom, @LastPurchaseDaysTo) AS 
	                           ftg12
	                           ON  ftg12.[User_ID] = ud.[User_ID]
	                      LEFT JOIN dbo.funcToGetUserSearch_PurchasePriceFrom(@LastPurchasePriceFrom, @LastPurchasePriceTo) AS 
	                           ftg13
	                           ON  ftg13.[User_ID] = ud.[User_ID]
	               WHERE  ud.[User_ID] IN (CASE 
	                                            WHEN (@UserName <> '') THEN ftg.USER_ID
	                                            ELSE ud.[User_ID]
	                                       END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@UserFilter <> '') THEN 
	                                                     ftg2.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@BalanceFrom <> 0 OR @BalanceTo <> 0) THEN 
	                                                     ftg3.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (
	                                                         @TotalCreditPurchasedFrom 
	                                                         <> 0
	                                                         OR @TotalCreditPurchasedTo 
	                                                            <>
	                                                            0
	                                                     ) THEN ftg4.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (
	                                                         @TotalCreditConsumedFrom 
	                                                         <> 0
	                                                         OR @TotalCreditConsumedTo 
	                                                            <> 0
	                                                     ) THEN ftg5.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@CreatedBetweenFrom <> 0 OR @CreatedBetweenTo <> 0) THEN 
	                                                     ftg6.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (ISNULL(@IsNewUser, '') <> '') THEN 
	                                                     ftg7.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@Mobile <> '') THEN 
	                                                     ftg8.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@EMailID <> '') THEN 
	                                                     ftg9.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@UserType <> '') THEN 
	                                                     ftg10.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@LastLoginBeforeFrom <> 0 OR @LastLoginBeforeTo < > 0) THEN 
	                                                     ftg11.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@LastPurchaseDaysFrom < > 0 OR @LastPurchaseDaysTo <> 0) THEN 
	                                                     ftg12.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	                      AND ud.[User_ID] IN (CASE 
	                                                WHEN (@LastPurchasePriceFrom <> 0 OR @LastPurchasePriceTo <> 0) THEN 
	                                                     ftg13.USER_ID
	                                                ELSE ud.[User_ID]
	                                           END)
	           )A
	END
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchKiteverLeads]    Script Date: 06-06-26 10:25:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcGetCampaignSearchKiteverLeads]
(
	@SearchID BIGINT
)
RETURNS @table TABLE 
(
	mobileno FLOAT
)    
    
BEGIN
	INSERT INTO @table
	SELECT DISTINCT fgun3.Mobile
	FROM   SearchDetails AS sd
	       OUTER APPLY funcToGet_Kitever_LeadMicrosite_Datewise(sd.MicrositeName, sd.FromDate, sd.ToDate) AS fgun3
	WHERE  sd.ID = @SearchID
	       AND sd.IsKitever = 1
	       AND sd.IsLeads = 1
	       AND fgun3.MicrositeName IS NOT NULL 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchKiteverLeadsMails]    Script Date: 06-06-26 10:25:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcGetCampaignSearchKiteverLeadsMails]
(
	@SearchID BIGINT
)
RETURNS @table TABLE 
(
	Email nvarchar(200)
)    
    
BEGIN
	INSERT INTO @table
	SELECT DISTINCT fgun3.Email
	FROM   SearchDetails AS sd
	       OUTER APPLY funcToGet_Kitever_LeadMicrosite_Datewise(sd.MicrositeName, sd.FromDate, sd.ToDate) AS fgun3
	WHERE  sd.ID = @SearchID
	       AND sd.IsKitever = 1
	       AND sd.IsLeads = 1
	       AND fgun3.MicrositeName IS NOT NULL 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcGetCampaignSearchKiteverUser]    Script Date: 06-06-26 10:25:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[funcGetCampaignSearchKiteverUser]
(
	@SearchID BIGINT
)
RETURNS @table TABLE(
            fname VARCHAR(200) NULL,
            Mobileno VARCHAR(200) NULL,
            CompnayName VARCHAR(200) NULL,
            EMail VARCHAR(200) NULL,
            state_name VARCHAR(200) NULL,
            city_name VARCHAR(200) NULL,
            DateCreated VARCHAR(200) NULL,
            LoginType VARCHAR(200) NULL,
            Merchant_Code VARCHAR(200) NULL,
            lastLoginDate VARCHAR(200) NULL,
            Balance VARCHAR(200) NULL,
            Consumption VARCHAR(200) NULL,
            SMSConsumption VARCHAR(200) NULL,
            MailConsumption VARCHAR(200) NULL,
            TimeonAppInMin VARCHAR(200) NULL,
            mCRMConfigured VARCHAR(200) NULL,
            OrdersCount VARCHAR(200) NULL,
            OrdersAmount VARCHAR(200) NULL,
            Micrositecreated VARCHAR(200) NULL,
            MicrositeEdited VARCHAR(200) NULL,
            VisitsCount VARCHAR(200) NULL,
            Leadscount VARCHAR(200) NULL,
            TopupAmount VARCHAR(200) NULL,
            Ismerchant VARCHAR(200) NULL,
            Usercategory VARCHAR(200) NULL,
            UserType VARCHAR(200) NULL
        ) 
  
BEGIN
	DECLARE @logindatefrom VARCHAR(20) = NULL    
	DECLARE @logindateto VARCHAR(20) = NULL          
	DECLARE @TimeSpentOnApp VARCHAR(20) = NULL          
	DECLARE @TimeOperator VARCHAR(20) = NULL          
	DECLARE @ConsumptionFrom VARCHAR(20) = NULL          
	DECLARE @ConsumptionTo VARCHAR(20) = NULL          
	DECLARE @SMSConsumptionFrom VARCHAR(20) = NULL          
	DECLARE @SMSConsumptionTo VARCHAR(20) = NULL          
	DECLARE @MailConsumptionFrom VARCHAR(20) = NULL          
	DECLARE @MailConsumptionTo VARCHAR(20) = NULL          
	DECLARE @BalanceUsed VARCHAR(50) = NULL          
	DECLARE @Operator VARCHAR(10) = NULL          
	DECLARE @SMSBalanceUsed VARCHAR(50) = NULL          
	DECLARE @SMSOperator VARCHAR(10) = NULL          
	DECLARE @MailBalanceUsed VARCHAR(50) = NULL          
	DECLARE @MailOperator VARCHAR(10) = NULL          
	DECLARE @OrderFrom VARCHAR(20) = NULL          
	DECLARE @OrderTo VARCHAR(20) = NULL          
	DECLARE @LeadsFrom VARCHAR(20) = NULL          
	DECLARE @LeadsTo VARCHAR(20) = NULL          
	DECLARE @TopUpFrom VARCHAR(20) = NULL          
	DECLARE @TopUpTo VARCHAR(20) = NULL          
	DECLARE @TopUpOperator VARCHAR(10) = NULL          
	DECLARE @TopUpAmount VARCHAR(10) = NULL          
	DECLARE @RegistrationDateFrom VARCHAR(20) = NULL          
	DECLARE @RegistrationDateTo VARCHAR(20) = NULL          
	
	
	SELECT @logindatefrom = logindatefrom,
	       @logindateto              = logindateto,
	       @TimeSpentOnApp           = TimeSpentOnApp,
	       @TimeOperator             = TimeOperator,
	       @ConsumptionFrom          = ConsumptionFrom,
	       @ConsumptionTo            = ConsumptionTo,
	       @SMSConsumptionFrom       = SMSConsumptionFrom,
	       @SMSConsumptionTo         = SMSConsumptionTo,
	       @MailConsumptionFrom      = MailConsumptionFrom,
	       @MailConsumptionTo        = MailConsumptionTo,
	       @BalanceUsed              = BalanceUsed,
	       @Operator                 = Operator,
	       @SMSBalanceUsed           = SMSBalanceUsed,
	       @SMSOperator              = SMSOperator,
	       @MailBalanceUsed          = MailBalanceUsed,
	       @MailOperator             = MailOperator,
	       @OrderFrom                = ORderFrom,
	       @OrderTo                  = OrderTo,
	       @LeadsFrom                = LeadsFrom,
	       @LeadsTo                  = LeadsTo,
	       @TopUpFrom                = TopUpFrom,
	       @TopUpTo                  = TopUpTo,
	       @TopUpOperator            = TopUpOperator,
	       @TopUpAmount              = TopUpAmount,
	       @RegistrationDateFrom     = RegistrationDateFrom,
	       @RegistrationDateTo       = RegistrationDateTo
	FROM   SearchDetails
	WHERE  ID                        = @SearchID 
	
	--set @logindatefrom = CONVERT(VARCHAR(10),  CONVERT(datetime,@logindatefrom,103), 101)
	-- set @logindateto = CONVERT(VARCHAR(10),  CONVERT(datetime,@logindateto,103), 101)  
	
	
	
	EXEC kitever.[dbo].AdvancedSearchUsers @logindatefrom,
	     @logindateto,
	     @TimeSpentOnApp,
	     @TimeOperator,
	     @ConsumptionFrom,
	     @ConsumptionTo,
	     @SMSConsumptionFrom,
	     @SMSConsumptionTo,
	     @MailConsumptionFrom,
	     @MailConsumptionTo,
	     @BalanceUsed,
	     @Operator,
	     @SMSBalanceUsed,
	     @SMSOperator,
	     @MailBalanceUsed,
	     @MailOperator,
	     @OrderFrom,
	     @OrderTo,
	     @LeadsFrom,
	     @LeadsTo,
	     @TopUpFrom,
	     @TopUpTo,
	     @TopUpOperator,
	     @TopUpAmount,
	     @RegistrationDateFrom,
	     @RegistrationDateTo
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcGetUnsubscribeNumbersCRM]    Script Date: 06-06-26 10:25:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--~ UserDefinedFunction [dbo].[funcGetUnsubscribeNumbersCRM] -- Deprecated feature 'Table hint without WITH'.  Automatically added WITH for you.
    
CREATE   FUNCTION [dbo].[funcGetUnsubscribeNumbersCRM]
(
	@Start     bigint,
	@To        bigint
)
RETURNS @table TABLE(mobileno VARCHAR(15))    
    
BEGIN
	INSERT INTO @table
	SELECT usd.MobileNo
	FROM   [CRM].CRMDB.dbo.UnSubscribeDetails AS usd WITH (NOLOCK)
	WHERE  datediff(d,usd.DateCreated,GETDATE()) BETWEEN @Start AND @To 
	
	RETURN
END 

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGet_Kitever_LeadMicrosite_Datewise]    Script Date: 06-06-26 10:25:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
    
     
    
CREATE   FUNCTION [dbo].[funcToGet_Kitever_LeadMicrosite_Datewise]    
(    
 @cname        NVARCHAR(1050) = NULL,    
 @FromDate     NVARCHAR(100) = NULL,    
 @Todate       NVARCHAR(100) = NULL    
)    
RETURNS @table TABLE(    
            MicrositeName VARCHAR(200) NULL,    
            FirstName VARCHAR(200) NULL,    
            LastName VARCHAR(200) NULL,    
            Email VARCHAR(200) NULL,    
            Mobile VARCHAR(20) NULL,    
            ADDRESS NVARCHAR(200) NULL,    
            City NVARCHAR(200) NULL,    
            Zip NVARCHAR(20) NULL,    
            Remarks NVARCHAR(500) NULL,    
            Source TINYINT NULL    
        )    
AS    
BEGIN    
 IF (ISNULL(@FromDate, '') = '' AND ISNULL(@cname, '') <> '')    
 BEGIN    
     INSERT @table    
     SELECT ISNULL(cld.cname, ''),    
            ISNULL(FirstName, ''),    
            ISNULL(LastName, ''),    
            ISNULL(Email, ''),    
            ISNULL(Mobile, ''),    
            ISNULL(ADDRESS, ''),    
            ISNULL(City, ''),    
            ISNULL(Zip, ''),    
            ISNULL(Remarks, ''),    
            ISNULL(Source, 0)    
     FROM   kitever.dbo.ClientLeadDetails cld    
     WHERE  cld.cname IN (SELECT fs.[value]    
                          FROM   dbo.fn_Split(@cname, ',') AS fs)    
 END    
 ELSE       
 IF (ISNULL(@FromDate, '') <> '' AND ISNULL(@cname, '') = '')    
 BEGIN    
     INSERT @table    
     SELECT ISNULL(cld.cname, ''),    
            ISNULL(FirstName, ''),    
            ISNULL(LastName, ''),    
            ISNULL(Email, ''),    
            ISNULL(Mobile, ''),    
            ISNULL(ADDRESS, ''),    
            ISNULL(City, ''),    
            ISNULL(Zip, ''),    
            ISNULL(Remarks, ''),    
            ISNULL(Source, 0)    
     FROM   kitever.dbo.ClientLeadDetails cld    
     WHERE  (    
                CONVERT(DATE, cld.Date) BETWEEN CONVERT(DATE, @FromDate)     
                AND     
                CONVERT(DATE, @Todate)    
            )    
 END    
 ELSE    
 BEGIN    
     INSERT @table    
     SELECT ISNULL(cld.cname, ''),    
            ISNULL(FirstName, ''),    
            ISNULL(LastName, ''),    
            ISNULL(Email, ''),    
            ISNULL(Mobile, ''),    
            ISNULL(ADDRESS, ''),    
            ISNULL(City, ''),    
            ISNULL(Zip, ''),    
            ISNULL(Remarks, ''),    
            ISNULL(Source, 0)    
     FROM   kitever.dbo.ClientLeadDetails cld    
     WHERE  (    
                CONVERT(DATE, cld.Date) BETWEEN CONVERT(DATE, @FromDate)     
                AND     
                CONVERT(DATE, @Todate)    
            )    
            AND cld.cname IN (SELECT fs.[value]    
                              FROM   dbo.fn_Split(@cname, ',') AS fs)    
 END     
 RETURN    
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGet_UserSearch_NewUserIDWise]    Script Date: 06-06-26 10:25:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
   
CREATE   FUNCTION [dbo].[funcToGet_UserSearch_NewUserIDWise]  
(  
 @IsNewUser BIT  
)  
RETURNS @table TABLE(  
            USER_ID INT,  
            User_Login VARCHAR(25),  
            FName VARCHAR(50) NULL,  
            LName VARCHAR(50) NULL,  
            Email VARCHAR(50) NULL,  
            Mobile FLOAT NULL,  
            ADDRESS VARCHAR(200) NULL,  
            City VARCHAR(50) NULL,  
            STATE VARCHAR(50) NULL  
        )  
AS  
BEGIN  
 IF (@IsNewUser = 1)  
 BEGIN  
     INSERT @table  
     SELECT USER_ID,  
            User_Login,  
            ISNULL(FName, ''),  
            ISNULL(LName, ''),  
            ISNULL(Email, ''),  
            Mobile,  
            ISNULL(ADDRESS, ''),  
            ISNULL(City, ''),  
            ISNULL(STATE, '')  
     FROM   User_Detail with(nolock) 
     WHERE  [User_ID] NOT IN (SELECT cd.[User_ID]  
                              FROM   [Credit_Details] cd with(nolock)  
                              GROUP BY  
                                     cd.[User_ID]  
                              HAVING COUNT([User_ID]) > 1)  
 END  
   
   
 RETURN  
END  
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGet_UserSearch_NewUserIDWise1]    Script Date: 06-06-26 10:25:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 
    
CREATE   FUNCTION [dbo].[funcToGet_UserSearch_NewUserIDWise1]
(
	@IsNewUser BIT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	IF (@IsNewUser = 1)
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           ISNULL(Mobile, ''),
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  [User_ID] NOT IN (SELECT [User_ID]
	                             FROM   [Credit_Details])
	END
	ELSE
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           ISNULL(Mobile, ''),
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  1 <> 1
	END
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_Role]    Script Date: 06-06-26 10:25:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE   FUNCTION [dbo].[funcToGetCRMDetails_InsertUsers_Role]  
(  
 @SearchID VARCHAR(MAX)  
)  
RETURNS @table TABLE(  
            USER_ID INT,  
            User_Login VARCHAR(25),  
            FName VARCHAR(50) NULL,  
            LName VARCHAR(50) NULL,  
            Email VARCHAR(50) NULL,  
            Mobile VARCHAR(20) NULL,  
            ADDRESS VARCHAR(200) NULL,  
            RoleName VARCHAR(200) NULL  
        )  
AS  
    
    
BEGIN  
 INSERT @table  
 SELECT DISTINCT ftg.[USER_ID],  
        ftg.User_Login,  
        ftg.FName,  
        ftg.LName,  
        ftg.Email,  
        ftg.Mobile,  
        ftg.[ADDRESS],  
        ftg.RoleName  
 FROM   SearchDetails AS sd  
        OUTER APPLY funcToGetCRMDetails_InsertUsers_RoleCRM(sd.CRMRoles) AS ftg  
 WHERE  sd.IsActive = 1  
        AND sd.IsCRMDB = 1  
        AND (sd.CRMRoles IS NOT NULL OR sd.CRMUsers IS NOT NULL)  
        AND ftg.[USER_ID] IS NOT NULL  
        AND sd.ID IN (SELECT fs.[value]  
                      FROM   dbo.fn_Split(@SearchID, '#') AS fs)  
 ORDER BY  
        ftg.FName   
   
   
 RETURN  
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_RoleCRM]    Script Date: 06-06-26 10:25:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--~ UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_RoleCRM] -- Deprecated feature 'Table hint without WITH'.  Automatically added WITH for you.
--~ UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_RoleCRM] -- Deprecated feature 'Table hint without WITH'.  Automatically added WITH for you.
    
    
CREATE   FUNCTION [dbo].[funcToGetCRMDetails_InsertUsers_RoleCRM]
(
	@RoleID VARCHAR(MAX)
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            RoleName VARCHAR(200) NULL
        )
AS
BEGIN
	INSERT @table
	SELECT ul.[User_ID],
	       ul.[User_Name],
	       ul.Name,
	       ul.Lastname,
	       ul.EmailID,
	       ul.ContactNo,
	       ul.[Address],
	       mr.[Role]
	FROM   [CRM].CRMDB.dbo.User_Login AS ul WITH (NOLOCK)
	       INNER JOIN [CRM].CRMDB.dbo.M_Role AS mr WITH (NOLOCK)
	            ON  mr.RoleID = ul.[Role]
	WHERE  ul.[Role] IN (SELECT fs.[value]
	                     FROM   dbo.fn_Split(@RoleID, '#') AS fs) 
	
	RETURN
END    

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_Users]    Script Date: 06-06-26 10:25:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
   
  
CREATE   FUNCTION [dbo].[funcToGetCRMDetails_InsertUsers_Users]  
(  
 @SearchID VARCHAR(MAX)  
)  
RETURNS @table TABLE(  
            USER_ID INT,  
            User_Login VARCHAR(25),  
            FName VARCHAR(50) NULL,  
            LName VARCHAR(50) NULL,  
            Email VARCHAR(50) NULL,  
            Mobile VARCHAR(20) NULL,  
            ADDRESS VARCHAR(200) NULL,  
            RoleName VARCHAR(200) NULL  
        )  
AS  
BEGIN  
 INSERT @table  
 SELECT DISTINCT ftg.[USER_ID],  
        ftg.User_Login,  
        ftg.FName,  
        ftg.LName,  
        ftg.Email,  
        ftg.Mobile,  
        ftg.[ADDRESS],  
        ftg.RoleName  
 FROM   SearchDetails AS sd  
        OUTER APPLY funcToGetCRMDetails_InsertUsers_UsersCRM(sd.CRMUsers) AS   
 ftg  
 WHERE  sd.IsActive = 1  
        AND sd.IsCRMDB = 1  
        AND (sd.CRMRoles IS NOT NULL OR sd.CRMUsers IS NOT NULL)  
        AND ftg.[USER_ID] IS NOT NULL  
        AND sd.ID IN (SELECT fs.[value]  
                      FROM   dbo.fn_Split(@SearchID, '#') AS fs)  
 ORDER BY  
        ftg.FName   
   
   
 RETURN  
END  
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_UsersCRM]    Script Date: 06-06-26 10:25:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--~ UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_UsersCRM] -- Deprecated feature 'Table hint without WITH'.  Automatically added WITH for you.
--~ UserDefinedFunction [dbo].[funcToGetCRMDetails_InsertUsers_UsersCRM] -- Deprecated feature 'Table hint without WITH'.  Automatically added WITH for you.
    
    
CREATE   FUNCTION [dbo].[funcToGetCRMDetails_InsertUsers_UsersCRM]
(
	@UserID VARCHAR(MAX)
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            RoleName VARCHAR(200) NULL
        )
AS



BEGIN
	INSERT @table
	SELECT ul.[User_ID],
	       ul.[User_Name],
	       ul.Name,
	       ul.Lastname,
	       ul.EmailID,
	       ul.ContactNo,
	       ul.[Address],
	       mr.[Role]
	FROM   [CRM].CRMDB.dbo.User_Login  AS ul WITH (NOLOCK)
	       LEFT
	JOIN [CRM].CRMDB.dbo.M_Role AS mr  WITH (NOLOCK)
	            ON  mr.RoleID = ul.[Role]
	WHERE  ul.[User_ID] IN (SELECT fs.[value]
	                        FROM   dbo.fn_Split(@UserID, '#') AS fs) 
	
	RETURN
END    

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetLeadDatewise]    Script Date: 06-06-26 10:25:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetLeadDatewise]
(
	@FromDate     NVARCHAR(100),
	@Todate       NVARCHAR(100)
)
RETURNS @table TABLE(
            MicrositeName VARCHAR(200) NULL,
            FirstName VARCHAR(200) NULL,
            LastName VARCHAR(200) NULL,
            Email VARCHAR(200) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS NVARCHAR(200) NULL,
            City NVARCHAR(200) NULL,
            Zip NVARCHAR(20) NULL,
            Remarks NVARCHAR(500) NULL,
            Source TINYINT NULL,
            DateCreated datetime
        )
AS
BEGIN
	INSERT @table
	SELECT ISNULL(cname, ''),
	       ISNULL(FirstName, ''),
	       ISNULL(LastName, ''),
	       ISNULL(Email, ''),
	       ISNULL(Mobile, ''),
	       ISNULL(ADDRESS, ''),
	       ISNULL(City, ''),
	       ISNULL(Zip, ''),
	       ISNULL(Remarks, ''),
	       ISNULL(Source, 0),DateCreated
	FROM   ClientLeadDetails
	WHERE  CONVERT(DATE, DateCreated) BETWEEN CONVERT(DATE, @FromDate) AND 
	       CONVERT(DATE, @Todate)
	
	RETURN
END


GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetLeadMicrosite_Datewise]    Script Date: 06-06-26 10:25:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 

CREATE   FUNCTION [dbo].[funcToGetLeadMicrosite_Datewise]
(
	@cname        NVARCHAR(1050) = NULL,
	@FromDate     NVARCHAR(100) = NULL,
	@Todate       NVARCHAR(100) = NULL
)
RETURNS @table TABLE(
            MicrositeName VARCHAR(200) NULL,
            FirstName VARCHAR(200) NULL,
            LastName VARCHAR(200) NULL,
            Email VARCHAR(200) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS NVARCHAR(200) NULL,
            City NVARCHAR(200) NULL,
            Zip NVARCHAR(20) NULL,
            Remarks NVARCHAR(500) NULL,
            Source TINYINT NULL,
            dateCreated DATETIME
        )
AS
BEGIN
	IF (ISNULL(@FromDate, '') = '' AND ISNULL(@cname, '') <> '')
	BEGIN
	    INSERT @table
	    SELECT ISNULL(cld.cname, ''),
	           ISNULL(FirstName, ''),
	           ISNULL(LastName, ''),
	           ISNULL(Email, ''),
	           ISNULL(Mobile, ''),
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(Zip, ''),
	           ISNULL(Remarks, ''),
	           ISNULL(Source, 0),
	           cld.DateCreated
	    FROM   ClientLeadDetails cld
	    WHERE  cld.cname IN (SELECT fs.[value]
	                         FROM   dbo.fn_Split(@cname, ',') AS fs)
	END
	ELSE     
	IF (ISNULL(@FromDate, '') <> '' AND ISNULL(@cname, '') = '')
	BEGIN
	    INSERT @table
	    SELECT ISNULL(cld.cname, ''),
	           ISNULL(FirstName, ''),
	           ISNULL(LastName, ''),
	           ISNULL(Email, ''),
	           ISNULL(Mobile, ''),
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(Zip, ''),
	           ISNULL(Remarks, ''),
	           ISNULL(Source, 0),
	           cld.DateCreated
	    FROM   ClientLeadDetails cld
	    WHERE  (
	               CONVERT(DATE, cld.DateCreated) BETWEEN CONVERT(DATE, @FromDate) 
	               AND 
	               CONVERT(DATE, @Todate)
	           )
	END
	ELSE
	BEGIN
	    INSERT @table
	    SELECT ISNULL(cld.cname, ''),
	           ISNULL(FirstName, ''),
	           ISNULL(LastName, ''),
	           ISNULL(Email, ''),
	           ISNULL(Mobile, ''),
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(Zip, ''),
	           ISNULL(Remarks, ''),
	           ISNULL(Source, 0),
	           cld.DateCreated
	    FROM   ClientLeadDetails cld
	    WHERE  (
	               CONVERT(DATE, cld.DateCreated) BETWEEN CONVERT(DATE, @FromDate) 
	               AND 
	               CONVERT(DATE, @Todate)
	           )
	           AND cld.cname IN (SELECT fs.[value]
	                             FROM   dbo.fn_Split(@cname, ',') AS fs)
	END 
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetLeadMicrositewise]    Script Date: 06-06-26 10:25:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
      
CREATE   FUNCTION [dbo].[funcToGetLeadMicrositewise]  
(  
 @cname VARCHAR(1050)  
)  
RETURNS @table TABLE(  
            MicrositeName VARCHAR(200) NULL,  
            FirstName VARCHAR(200) NULL,  
            LastName VARCHAR(200) NULL,  
            Email VARCHAR(200) NULL,  
            Mobile VARCHAR(20) NULL,  
            ADDRESS NVARCHAR(200) NULL,  
            City NVARCHAR(200) NULL,  
            Zip NVARCHAR(20) NULL,  
            Remarks NVARCHAR(500) NULL,  
            Source TINYINT NULL ,
            dateCreated DATETIME 
        )  
AS  
BEGIN  
 INSERT @table  
 SELECT ISNULL(cname, ''),  
        ISNULL(FirstName, ''),  
        ISNULL(LastName, ''),  
        ISNULL(Email, ''),  
        ISNULL(Mobile, ''),  
        ISNULL(ADDRESS, ''),  
        ISNULL(City, ''),  
        ISNULL(Zip, ''),  
        ISNULL(Remarks, ''),  
        ISNULL(Source, 0) ,DateCreated 
 FROM   ClientLeadDetails  
 WHERE  cname IN (SELECT fs.value  
                  FROM   dbo.fn_Split(@cname, ',') AS fs)  
   
 RETURN  
END  
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetNewUserIDWise]    Script Date: 06-06-26 10:25:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  CREATE   FUNCTION [dbo].[funcToGetNewUserIDWise]  --(@City nvarchar(15))  
  ()  RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)   AS  BEGIN  insert @table    select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where [User_ID] not in (select [User_ID] from [Credit_Details])  Return  End  
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetNewUserLastLogin]    Script Date: 06-06-26 10:25:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    CREATE   FUNCTION [dbo].[funcToGetNewUserLastLogin]    (@Days int)        RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)     AS    BEGIN    insert @table      select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where [User_ID]  in (select [User_ID] from [Credit_Details]   where [FromUser_ID]= [User_ID] group by USER_ID having DATEDIFF(DAY,MAX(LastModified),GETDATE())>=@Days  )    Return    End  
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetScoredetails]    Script Date: 06-06-26 10:25:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetScoredetails]      
(@LeadID bigint)              
RETURNS @tbl table (CurrentScore int,ThresholdColor nvarchar(200),Profit_Loss nvarchar(20))      
AS              
BEGIN              
declare @parentid bigint=(select parentid from userleads(nolock) where id=@leadid)              
declare @lastscoreupdate datetime,@lastscore int ,@ScoreStatus nvarchar(200) = 'Green_Up'       
declare @max int=(select (max(currentscore)*100)/99 from lead_score_history_latest(nolock) e where parentid=@parentid),@relativescore numeric(18,2)              
declare @hot int,@warm int,@cold int,@ThresholdColor nvarchar(200) = 'Cold'        
select @relativescore= round((currentscore/cast(@max as float)*99),2)   
,@lastscoreupdate=createdon,@lastscore=scoreadded  
from lead_score_history_latest(nolock) e               
where leadid=@leadid and parentid=@parentid              
             
--select top 1 @lastscoreupdate=createdon,@lastscore=scoreadded from lead_score_history(nolock) where leadid=@leadid and parentid=@parentid order by id desc              
select  @ScoreStatus  =isnull(( case                 
    when sum(case when datediff(dd,createdon,getdate())<=7 then ScoreAdded else 0 end)>0 then 'Green_Up'                 
    when sum(case when datediff(dd,createdon,getdate())<=7 then ScoreAdded else 0 end)<0 then 'Red_Down'                
    when sum(case when datediff(dd,createdon,getdate())<=7 then ScoreAdded else 0 end)=0 and @lastscore>0 then 'Green_Up'                
    when sum(case when datediff(dd,createdon,getdate())<=7 then ScoreAdded else 0 end)=0 and @lastscore<0 then 'Red_Down'                 
    when  datediff(dd,@lastscoreupdate,getdate()) > 7 and @lastscore>0 then 'Grey_Up'                
    when  datediff(dd,@lastscoreupdate,getdate()) > 7 and @lastscore<0 then 'Grey_Down'                
     end ),'' )          
   from lead_score_history_latest (nolock) where leadid=@leadid and parentid=@parentid            
      
select @hot=hot,@warm=warm,@cold=cold from lead_cateogy_thresholds(nolock) where parentid=@parentid      
if @hot is null      
begin      
select @hot=hot,@warm=warm,@cold=cold from lead_cateogy_thresholds(nolock) where parentid=0      
end      
            
select @ThresholdColor =case when @relativescore>@warm then 'Hot' when @relativescore between @Cold and @warm then 'Warm'       
else 'Cold' end            
      
--declare @tbl table (Currentscore int,Thresholdcolour nvarchar(200),Profit_Loss nvarchar(20))      
insert into @tbl(Currentscore,Profit_Loss,ThresholdColor)      
select isnull(@relativescore,0),@ScoreStatus,@ThresholdColor      
      
return       
End 

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_Balancewise]    Script Date: 06-06-26 10:25:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_Balancewise]
(
	@BalanceFrom     BIGINT,
	@BalanceTo       BIGINT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS 
BEGIN
	IF (@BalanceFrom <> 0 OR @BalanceTo <> 0)
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  USER_ID IN (SELECT USER_ID
	                       FROM   Credit_Details
	                       WHERE  Balance >= @BalanceFrom
	                              AND Balance <= @BalanceTo)
	END
	
	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_CreditBetweenwise]    Script Date: 06-06-26 10:25:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_CreditBetweenwise]  
(  
 @CreatedBetweenFrom     BIGINT,  
 @CreatedBetweenTo       BIGINT  
)  
RETURNS @table TABLE(  
            USER_ID INT,  
            User_Login VARCHAR(25),  
            FName VARCHAR(50) NULL,  
            LName VARCHAR(50) NULL,  
            Email VARCHAR(50) NULL,  
            Mobile FLOAT NULL,  
            ADDRESS VARCHAR(200) NULL,  
            City VARCHAR(50) NULL,  
            STATE VARCHAR(50) NULL  
        )  
AS  
    
    
    
BEGIN  
 IF (@CreatedBetweenFrom <> '' OR @CreatedBetweenTo <> '')  
 BEGIN  
     INSERT @table  
     SELECT [USER_ID],  
            User_Login,  
            ISNULL(FName, ''),  
            ISNULL(LName, ''),  
            ISNULL(Email, ''),  
            Mobile,  
            ISNULL(ADDRESS, ''),  
            ISNULL(City, ''),  
            ISNULL(STATE, '')  
     FROM   User_Detail tt  
     WHERE  tt.[USER_ID] IN (SELECT cd.[USER_ID]  
                             FROM   Credit_Details cd  
                             WHERE  DATEDIFF(d, DateCreated, GETDATE()) >= @CreatedBetweenFrom  
                                    AND DATEDIFF(d, DateCreated, GETDATE()) <=   
                                        @CreatedBetweenTo)  
 END  
   
 RETURN  
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_Creditwise]    Script Date: 06-06-26 10:25:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_Creditwise]
(
	@CreditPurchaseFrom     BIGINT,
	@CreditPurchaseTo       BIGINT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	IF (@CreditPurchaseFrom <> 0 OR @CreditPurchaseTo <> 0)
	BEGIN
	    INSERT @table
	    SELECT [USER_ID],
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail tt
	    WHERE  tt.[USER_ID] IN (SELECT cd.[USER_ID]
	                            FROM   Credit_Details cd
	                            GROUP BY
	                                   cd.[User_ID]
	                            HAVING (
	                                       SUM(ISNULL(Credits, 0)) >= @CreditPurchaseFROM
	                                       AND SUM(ISNULL(Credits, 0)) <= @CreditPurchaseTo
	                                   ))
	END
	
	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_Debitwise]    Script Date: 06-06-26 10:25:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_Debitwise]
(
	@CreditConsumedFrom     BIGINT,
	@CreditConsumedTo       BIGINT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS   
BEGIN
	IF (@CreditConsumedFrom <> 0 OR @CreditConsumedTo <> 0)
	BEGIN
	    INSERT @table
	    SELECT tt.[USER_ID],
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail tt
	    WHERE  tt.[USER_ID] IN (SELECT cd.[USER_ID]
	                            FROM   Credit_Details cd
	                            GROUP BY
	                                   cd.[User_ID]
	                            HAVING (
	                                       SUM(ISNULL(cd.Debits, 0)) >= @CreditConsumedFrom
	                                       AND SUM(ISNULL(cd.Debits, 0)) <= @CreditConsumedTo
	                                   ))
	END
	
	RETURN
END   
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_EmailIDwise]    Script Date: 06-06-26 10:25:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_EmailIDwise]
(
	@EmailID NVARCHAR(20)
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	IF @EmailID <> ''
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  EMail = @EmailID
	END
	
	RETURN
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_MobileNowise]    Script Date: 06-06-26 10:25:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_MobileNowise]
(
	@Mobile NVARCHAR(20)
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS

BEGIN
	IF (@Mobile <> 0)
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  Mobile = @Mobile
	END
	
	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_UserFilterwise]    Script Date: 06-06-26 10:25:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_UserFilterwise]
(
	@UserFilter NVARCHAR(200)
)
RETURNS @table TABLE(
            [USER_ID] INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            [ADDRESS] VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            [STATE] VARCHAR(50) NULL 
            --Userfilter VARCHAR(50) NULL
        )
AS
BEGIN
	IF @UserFilter <> ''
	BEGIN
	    INSERT @table
	    SELECT [USER_ID],
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL([ADDRESS], ''),
	           ISNULL(City, ''),
	           ISNULL([STATE], '') 
	           --@UserFilter
	    FROM   User_Detail tt
	           INNER JOIN dbo.fn_Split(@UserFilter, '#') AS fs
	                ON  tt.userfilter = fs.[value]
	END
	
	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_UserNamewise]    Script Date: 06-06-26 10:25:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_UserNamewise]
(
	@UserName NVARCHAR(MAX)
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	IF @UserName <> ''
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  [User_ID] IN (SELECT fs.value
	                         FROM   dbo.fn_Split(@UserName, '#') AS fs)
	END
	
	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserDetails_UserTypewise]    Script Date: 06-06-26 10:25:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserDetails_UserTypewise]
(
	@UserType VARCHAR(1050)
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile FLOAT NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	IF @UserType <> ''
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           Mobile,
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail ss
	           INNER JOIN dbo.fn_Split(@UserType, '#') AS fs
	                ON  ss.UserType = fs.[value]
	END
	
	RETURN
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserForGivenEmail]    Script Date: 06-06-26 10:25:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserForGivenEmail]  (@Email nvarchar(100))    RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)   AS  BEGIN  insert @table    select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where (Email like '%'+@Email+'%')   Return  End
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserForGivenMobile]    Script Date: 06-06-26 10:25:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserForGivenMobile]  (@Mobile nvarchar(100))    RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)   AS  BEGIN  insert @table    select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where (Mobile like '%'+@Mobile+'%')   Return  End  

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserForGivenUserFilter]    Script Date: 06-06-26 10:25:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserForGivenUserFilter]  (@UserFilter nvarchar(100))    RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)   AS  BEGIN  insert @table    select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where (userfilter = @UserFilter)   Return  End 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserForGivenUserName]    Script Date: 06-06-26 10:25:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserForGivenUserName]  (@UserName nvarchar(100))    RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)   AS  BEGIN  insert @table    select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where (User_Login like '%'+@UserName+'%') or(FName like '%'+@UserName+'%') or(LName like '%'+@UserName+'%')  Return  End  
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserForGivenUserType]    Script Date: 06-06-26 10:25:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserForGivenUserType]  (@UserType nvarchar(100))    RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)   AS  BEGIN  insert @table    select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where (UserType = @UserType)   Return  End  

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserLastLoginBefore]    Script Date: 06-06-26 10:25:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserLastLoginBefore]    (@Days int)        RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)     AS    BEGIN    insert @table      select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where [User_ID]  in (select [UserID] from [AddCreditDetails]      group by USERID having DATEDIFF(DAY,MAX(CreatedDate),GETDATE())<=@Days  )    Return    End  

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserLastLoginBefore1]    Script Date: 06-06-26 10:25:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserLastLoginBefore1](@Days int)    RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile float null,Route nvarchar(50),createddate datetime,status int)     AS    BEGIN    insert @table      select u.USER_ID,User_Login,FName,LName,Email,Mobile,userfilter,max(c.DateCreated),status  From User_Detail u join Credit_Details c on c.user_id=u.user_id where c.USER_ID=isnull(c.FromUser_ID,c.User_ID) and u.m_id=10043 group by c.USER_ID,status,userfilter,Mobile,u.USER_ID,User_Login,FName,LName,Email having DATEDIFF(DAY,MAX(c.datecreated),GETDATE())>=@Days    Return    End  

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserLastLoginBefore2]    Script Date: 06-06-26 10:25:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserLastLoginBefore2](@Days int)    RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile float null,Route nvarchar(50),createddate datetime,status int)     AS    BEGIN    insert @table      select u.USER_ID,User_Login,FName,LName,Email,Mobile,userfilter,max(c.DateCreated),status  From User_Detail u join Credit_Details c on c.user_id=u.user_id where c.USER_ID=isnull(c.FromUser_ID,c.User_ID) and u.m_id=10043 group by c.USER_ID,status,userfilter,Mobile,u.USER_ID,User_Login,FName,LName,Email having DATEDIFF(DAY,MAX(c.datecreated),GETDATE())>=@Days    Return    End  

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserLastLoginBefore3]    Script Date: 06-06-26 10:25:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserLastLoginBefore3]()    
RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile float null,Route nvarchar(50),createddate datetime,status int)     AS    BEGIN    insert @table      select u.USER_ID,User_Login,FName,LName,Email,Mobile,userfilter,max(c.DateCreated),status  From User_Detail u join Credit_Details c on c.user_id=u.user_id where c.USER_ID=c.FromUser_ID and u.m_id=10043 and u.user_id not in (select USER_ID from dbo.funcToGetUserLastLoginBefore1(180)) and u.user_id not in (select USER_ID from dbo.funcToGetUserLastLoginBefore2(180)) group by c.USER_ID,status,userfilter,Mobile,u.USER_ID,User_Login,FName,LName,Email   Return    End  

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserLastPurchased]    Script Date: 06-06-26 10:25:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      CREATE   FUNCTION [dbo].[funcToGetUserLastPurchased]    (@Days int)        RETURNS @table table(User_ID Bigint null,User_Login varchar(50) null,FName varchar(50) null,LName varchar(50) null,Email varchar(100) null,Mobile nvarchar(50) null)     AS    BEGIN    insert @table      select USER_ID,User_Login,FName,LName,Email,cast(Mobile as nvarchar) From User_Detail where [User_ID]  in (select [UserID] from [AddCreditDetails]      group by USERID having DATEDIFF(DAY,MAX(CreatedDate),GETDATE())>=@Days  )    Return    End 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_LastLogin]    Script Date: 06-06-26 10:25:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

    
CREATE   FUNCTION [dbo].[funcToGetUserSearch_LastLogin]
(
	@Days INT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	INSERT @table
	SELECT USER_ID,
	       User_Login,
	       ISNULL(FName, ''),
	       ISNULL(LName, ''),
	       ISNULL(Email, ''),
	       ISNULL(Mobile, ''),
	       ISNULL(ADDRESS, ''),
	       ISNULL(City, ''),
	       ISNULL(STATE, '')
	FROM   User_Detail
	WHERE  [User_ID]  IN (SELECT [User_ID]
	                      FROM   [Credit_Details]
	                      WHERE  [FromUser_ID] = [User_ID]
	                      GROUP BY
	                             USER_ID
	                      HAVING DATEDIFF(DAY, MAX(LastModified), GETDATE()) >=
	                             @Days)
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_LastLoginBefore]    Script Date: 06-06-26 10:25:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 

CREATE   FUNCTION [dbo].[funcToGetUserSearch_LastLoginBefore]
(
	@Days INT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	INSERT @table
	SELECT USER_ID,
	       User_Login,
	       ISNULL(FName, ''),
	       ISNULL(LName, ''),
	       ISNULL(Email, ''),
	       ISNULL(Mobile, ''),
	       ISNULL(ADDRESS, ''),
	       ISNULL(City, ''),
	       ISNULL(STATE, '')
	FROM   User_Detail
	WHERE  [User_ID]  IN (SELECT [UserID]
	                      FROM   [AddCreditDetails]
	                      GROUP BY
	                             USERID
	                      HAVING DATEDIFF(DAY, MAX(CreatedDate), GETDATE()) <= @Days)
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_LastLoginBeforeFrom]    Script Date: 06-06-26 10:25:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserSearch_LastLoginBeforeFrom]
(
	@FromDays     INT,
	@ToDays       INT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile NUMERIC(18, 0) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS

  
    
    
BEGIN
	IF (@FromDays <> 0 OR @ToDays <> 0)
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           CAST(Mobile AS NUMERIC(18, 0)),
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  [User_ID]  IN (SELECT cd.[User_ID]
	                          FROM   Credit_Details AS cd
	                          GROUP BY
	                                 cd.[User_ID]
	                          HAVING (
	                                     DATEDIFF(DAY, MAX(cd.DateCreated), GETDATE()) 
	                                     >= @FromDays
	                                     AND DATEDIFF(DAY, MAX(cd.DateCreated), GETDATE()) 
	                                         <= @ToDays
	                                 ))
	END
	
	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_LastLoginBeforeTo]    Script Date: 06-06-26 10:25:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 
CREATE   FUNCTION [dbo].[funcToGetUserSearch_LastLoginBeforeTo]
(
	@Days INT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	INSERT @table
	SELECT USER_ID,
	       User_Login,
	       ISNULL(FName, ''),
	       ISNULL(LName, ''),
	       ISNULL(Email, ''),
	       ISNULL(Mobile, ''),
	       ISNULL(ADDRESS, ''),
	       ISNULL(City, ''),
	       ISNULL(STATE, '')
	FROM   User_Detail
	WHERE  [User_ID]  IN (SELECT [UserID]
	                      FROM   [AddCreditDetails]
	                      GROUP BY
	                             USERID
	                      HAVING DATEDIFF(DAY, MAX(CreatedDate), GETDATE()) <= @Days)
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_LastPurchased]    Script Date: 06-06-26 10:25:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 

    
CREATE   FUNCTION [dbo].[funcToGetUserSearch_LastPurchased]
(
	@Days INT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	INSERT @table
	SELECT USER_ID,
	       User_Login,
	       ISNULL(FName, ''),
	       ISNULL(LName, ''),
	       ISNULL(Email, ''),
	       ISNULL(Mobile, ''),
	       ISNULL(ADDRESS, ''),
	       ISNULL(City, ''),
	       ISNULL(STATE, '')
	FROM   User_Detail
	WHERE  [User_ID]  IN (SELECT [UserID]
	                      FROM   [AddCreditDetails]
	                      GROUP BY
	                             USERID
	                      HAVING DATEDIFF(DAY, MAX(CreatedDate), GETDATE()) >= @Days)
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_LastPurchasedFrom]    Script Date: 06-06-26 10:25:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

                  
CREATE   FUNCTION [dbo].[funcToGetUserSearch_LastPurchasedFrom]
(
	@FromDays     INT,
	@ToDays       INT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile NUMERIC(18, 0) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
  
    
BEGIN
	IF (@FromDays <> 0 OR @ToDays <> 0)
	BEGIN
	    INSERT @table
	    SELECT USER_ID,
	           User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           CAST(Mobile AS NUMERIC(18, 0)),
	           ISNULL(ADDRESS, ''),
	           ISNULL(City, ''),
	           ISNULL(STATE, '')
	    FROM   User_Detail
	    WHERE  [User_ID]  IN (SELECT cd.[User_ID]
	                          FROM   Credit_Details AS cd
	                          GROUP BY
	                                 cd.[User_ID]
	                          HAVING (
	                                     DATEDIFF(DAY, MAX(cd.DateCreated), GETDATE()) 
	                                     >= @FromDays
	                                     AND DATEDIFF(DAY, MAX(cd.DateCreated), GETDATE()) 
	                                         <= @ToDays
	                                 ))
	END 
	
	RETURN
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_LastPurchasedTo]    Script Date: 06-06-26 10:25:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE   FUNCTION [dbo].[funcToGetUserSearch_LastPurchasedTo]
(
	@Days INT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	INSERT @table
	SELECT USER_ID,
	       User_Login,
	       ISNULL(FName, ''),
	       ISNULL(LName, ''),
	       ISNULL(Email, ''),
	       ISNULL(Mobile, ''),
	       ISNULL(ADDRESS, ''),
	       ISNULL(City, ''),
	       ISNULL(STATE, '')
	FROM   User_Detail
	WHERE  [User_ID]  IN (SELECT [UserID]
	                      FROM   [AddCreditDetails]
	                      GROUP BY
	                             USERID
	                      HAVING DATEDIFF(DAY, MAX(CreatedDate), GETDATE()) <= @Days)
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_PurchasePriceFrom]    Script Date: 06-06-26 10:25:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[funcToGetUserSearch_PurchasePriceFrom]
(
	@PurchasePriceFrom     BIGINT,
	@PurchasePriceTo       BIGINT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile NUMERIC(18, 0) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS

BEGIN
	IF (@PurchasePriceFrom <> 0 OR @PurchasePriceTo <> 0)
	BEGIN
	    INSERT @table
	    SELECT ud.[USER_ID],
	           ud.User_Login,
	           ISNULL(FName, ''),
	           ISNULL(LName, ''),
	           ISNULL(Email, ''),
	           CAST(Mobile AS NUMERIC(18, 0)),
	           ISNULL([ADDRESS], ''),
	           ISNULL(City, ''),
	           ISNULL([STATE], '')
	    FROM   User_Detail ud
	    WHERE  ud.[User_ID]   IN (SELECT DISTINCT acd.UserID
	                              FROM   AddCreditDetails AS acd
	                              WHERE  acd.PricePerSMS >= @PurchasePriceFrom
	                                     AND acd.PricePerSMS <= @PurchasePriceTo)
	END
	
	RETURN
END 
GO

/****** Object:  UserDefinedFunction [dbo].[funcToGetUserSearch_PurchasePriceTo]    Script Date: 06-06-26 10:25:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 

CREATE   FUNCTION [dbo].[funcToGetUserSearch_PurchasePriceTo]
(
	@PurchasePriceTo BIGINT
)
RETURNS @table TABLE(
            USER_ID INT,
            User_Login VARCHAR(25),
            FName VARCHAR(50) NULL,
            LName VARCHAR(50) NULL,
            Email VARCHAR(50) NULL,
            Mobile VARCHAR(20) NULL,
            ADDRESS VARCHAR(200) NULL,
            City VARCHAR(50) NULL,
            STATE VARCHAR(50) NULL
        )
AS
BEGIN
	INSERT @table
	SELECT USER_ID,
	       User_Login,
	       ISNULL(FName, ''),
	       ISNULL(LName, ''),
	       ISNULL(Email, ''),
	       ISNULL(Mobile, ''),
	       ISNULL(ADDRESS, ''),
	       ISNULL(City, ''),
	       ISNULL(STATE, '')
	FROM   User_Detail
	WHERE  [User_ID]  IN (SELECT DISTINCT UserID
	                      FROM   AddCreditDetails
	                      WHERE  Credits <= @PurchasePriceTo) 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquiryExecutive]    Script Date: 06-06-26 10:25:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 

CREATE   FUNCTION [dbo].[getCRMPreEnquiryExecutive]
(
	@Executive     VARCHAR(1050),
	@islast        BIT
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(50)
        )
AS
BEGIN
	IF @islast = 0
	BEGIN
	    INSERT @table
	    SELECT ISNULL(ed.EnqNo, ''),
	           ISNULL(ed.EnqDate, ''),
	           ISNULL(ed.Name, ''),
	           ISNULL(ed.Mobile_No, ''),
	           ISNULL(ed.Phone_No, ''),
	           ISNULL(ed.R_Address, ''),
	           ISNULL(ed.O_Address, ''),
	           ISNULL(ed.R_Zone, ''),
	           ISNULL(ed.O_Zone, ''),
	           ISNULL(ed.R_Area, ''),
	           ISNULL(ed.O_Area, ''),
	           ISNULL(ed.DateCreated, ''),
	           ed.[Status],
	           ed.MeetingStatus
	    FROM   [CRM].CRMDB.dbo.FollowUp_Details AS fud
	           INNER JOIN [CRM].CRMDB.dbo.Pre_Enquiry AS ed
	                ON  ed.EnqNo = fud.EnqNo
	           INNER JOIN (
	                    SELECT fs.[value]
	                    FROM   dbo.fn_Split(@Executive, ',') AS fs
	                ) AS fspl
	                ON  ed.Executive = fspl.[value]
	                AND fud.Executive = fspl.[value]
	END
	ELSE
	BEGIN
	    INSERT @table
	    SELECT ISNULL(ed.EnqNo, ''),
	           ISNULL(ed.EnqDate, ''),
	           ISNULL(ed.Name, ''),
	           ISNULL(ed.Mobile_No, ''),
	           ISNULL(ed.Phone_No, ''),
	           ISNULL(ed.R_Address, ''),
	           ISNULL(ed.O_Address, ''),
	           ISNULL(ed.R_Zone, ''),
	           ISNULL(ed.O_Zone, ''),
	           ISNULL(ed.R_Area, ''),
	           ISNULL(ed.O_Area, ''),
	           ISNULL(ed.DateCreated, ''),
	           ed.[Status],
	           ed.MeetingStatus
	    FROM   [CRM].CRMDB.dbo.Pre_Enquiry  AS ed
	           INNER JOIN (
	                    SELECT MAX(pe.Executive) AS Executive
	                    FROM   [CRM].CRMDB.dbo.Pre_Enquiry AS pe
	                    GROUP BY
	                           pe.Executive
	                )                 AS pe2
	                ON  pe2.Executive = ed.Executive
	    ORDER BY
	           ed.DateCreated DESC
	END 
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquiryIsEnrolled]    Script Date: 06-06-26 10:25:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 

CREATE   FUNCTION [dbo].[getCRMPreEnquiryIsEnrolled]
(
	@IsEnrolled BIT
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(50)
        )
AS
BEGIN
	IF (@IsEnrolled = 1)
	BEGIN
	    INSERT @table
	    SELECT ad.EnqNo,
	           ad.[Date],
	           ad.Executive,
	           '',
	           '',
	           ad.MAddress,
	           ad.MAddress,
	           ad.MZone,
	           ad.MZone,
	           ad.M_Area,
	           ad.M_Area,
	           ad.DateCreated,
	           '',
	           ad.V_MeetingStatus
	    FROM   [CRM].CRMDB.dbo.Appointment_details AS ad
	    WHERE  ad.MeetingStatus = 'Enrolled'
	END 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquiryLeadStatus]    Script Date: 06-06-26 10:25:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

CREATE   FUNCTION [dbo].[getCRMPreEnquiryLeadStatus]
(
	@LeadStatus           VARCHAR(1050),
	@isLastLeadStatus     BIT
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(50)
        )
AS
BEGIN
	IF @isLastLeadStatus = 0
	   AND ISNULL(@LeadStatus, '') <> ''
	BEGIN
	    INSERT @table
	    SELECT fud.EnqNo,
	           fud.FollowUpDate,
	           fud.Executive,
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           fud.DateCreated,
	           fud.VerificationStatus,
	           ''
	    FROM   [CRM].CRMDB.dbo.FollowUp_Details AS fud
	           INNER JOIN dbo.fn_Split(@LeadStatus, '#') AS fs
	                ON  fud.VerificationStatus = fs.[value]
	END
	ELSE   
	IF @isLastLeadStatus = 1
	BEGIN
	    INSERT @table
	    SELECT fud.EnqNo,
	           fud.FollowUpDate,
	           fud.Executive,
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           fud.DateCreated,
	           fud.VerificationStatus,
	           ''
	    FROM   [CRM].CRMDB.dbo.FollowUp_Details AS fud
	    WHERE  (
	               fud.VerificationStatus IN (SELECT MAX(aam2.VerificationStatus)
	                                          FROM   [CRM].CRMDB.dbo.FollowUp_Details AS 
	                                                 aam2)
	           )
	END 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquiryRetentionExecutive]    Script Date: 06-06-26 10:25:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[getCRMPreEnquiryRetentionExecutive]
(
	@RetentionExecutive     VARCHAR(1050),
	@isCurrentRetention     BIT
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(350)
        )
AS
BEGIN
	IF @isCurrentRetention = 0
	BEGIN
	    INSERT @table
	    SELECT 0,
	           '',
	           aam.Name,
	           aam.Mobile,
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           NULL,
	           '',
	           aam.Remark
	    FROM   [CRM].CRMDB.dbo.Assign_AccountManager AS aam
	           INNER JOIN dbo.fn_Split(@RetentionExecutive, '#') AS fs
	                ON  aam.AM_Name = fs.[value]
	END
	ELSE
	BEGIN
	    INSERT @table
	    SELECT aam.Refrence_No,
	           '',
	           aam.Name,
	           aam.Mobile,
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           NULL,
	           '',
	           aam.Remark
	    FROM   [CRM].CRMDB.dbo.Assign_AccountManager AS aam
	    WHERE  (
	               aam.AM_Name IN (SELECT MAX(aam2.AM_Name)
	                               FROM   [CRM].CRMDB.dbo.Assign_AccountManager AS 
	                                      aam2)
	           )
	END 
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquiryServices]    Script Date: 06-06-26 10:25:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

 

CREATE   FUNCTION [dbo].[getCRMPreEnquiryServices]
(
	@Services VARCHAR(1050)
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(50)
        )
AS
BEGIN
	INSERT @table
	SELECT ISNULL(fud.EnqNo, ''),
	       ISNULL(fud.FollowUpDate, ''),
	       ISNULL(fud.Executive, ''),
	       '',
	       '',
	       '',
	       '',
	       '',
	       '',
	       '',
	       '',
	       ISNULL(fud.DateCreated, ''),
	       ISNULL(fud.[Status], ''),
	       ISNULL(fud.MeetingStatus, '')
	FROM   [CRM].CRMDB.dbo.FollowUp_Details AS fud
	       INNER JOIN dbo.fn_Split(@Services, '#') AS fs
	            ON  fud.ServiceName = fs.[value] 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquirySpecificDates]    Script Date: 06-06-26 10:25:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 

CREATE   FUNCTION [dbo].[getCRMPreEnquirySpecificDates]
(
	@FromDate     DATETIME,
	@ToDate       DATETIME
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(50)
        )
AS
BEGIN
	INSERT @table
	SELECT ISNULL(ed.EnqNo, ''),
	       ISNULL(ed.EnqDate, ''),
	       ISNULL(ed.Name, ''),
	       ISNULL(ed.Mobile_No, ''),
	       ISNULL(ed.Phone_No, ''),
	       ISNULL(ed.R_Address, ''),
	       ISNULL(ed.O_Address, ''),
	       ISNULL(ed.R_Zone, ''),
	       ISNULL(ed.O_Zone, ''),
	       ISNULL(ed.R_Area, ''),
	       ISNULL(ed.O_Area, ''),
	       ISNULL(ed.DateCreated, ''),
	       ed.[Status],
	       ed.MeetingStatus
	FROM   [CRM].CRMDB.dbo.Pre_Enquiry AS ed
	WHERE  CONVERT(DATE, ed.DateCreated, 101) BETWEEN CONVERT(DATE, @FromDate, 101) 
	       AND CONVERT(DATE, @ToDate, 101) 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquirySpecificDays]    Script Date: 06-06-26 10:25:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

 

CREATE   FUNCTION [dbo].[getCRMPreEnquirySpecificDays]
(
	@FromDay     BIGINT,
	@ToDay       BIGINT
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(50)
        )
AS
BEGIN
	INSERT @table
	SELECT ISNULL(ed.EnqNo, ''),
	       ISNULL(ed.EnqDate, ''),
	       ISNULL(ed.Name, ''),
	       ISNULL(ed.Mobile_No, ''),
	       ISNULL(ed.Phone_No, ''),
	       ISNULL(ed.R_Address, ''),
	       ISNULL(ed.O_Address, ''),
	       ISNULL(ed.R_Zone, ''),
	       ISNULL(ed.O_Zone, ''),
	       ISNULL(ed.R_Area, ''),
	       ISNULL(ed.O_Area, ''),
	       ISNULL(ed.DateCreated, ''),
	       ed.[Status],
	       ed.MeetingStatus
	FROM   [CRM].CRMDB.dbo.Pre_Enquiry AS ed
	WHERE  DATEDIFF(DAY, ed.DateCreated, GETDATE()) > @FromDay
	       AND DATEDIFF(DAY, ed.DateCreated, GETDATE()) < @ToDay 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getCRMPreEnquiryStatus]    Script Date: 06-06-26 10:25:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 

CREATE   FUNCTION [dbo].[getCRMPreEnquiryStatus]
(
	@Status     VARCHAR(MAX),
	@islast     BIT
)
RETURNS @table TABLE (
            EnqNo INT,
            EnqDate VARCHAR(50),
            NAME VARCHAR(250),
            Mobile_No VARCHAR(200),
            Phone_No VARCHAR(50),
            R_Address VARCHAR(500),
            O_Address VARCHAR(500),
            R_Zone VARCHAR(50),
            O_Zone VARCHAR(50),
            R_Area VARCHAR(50),
            O_Area VARCHAR(50),
            DateCreated DATETIME,
            [Status] VARCHAR(50),
            MeetingStatus VARCHAR(50)
        )
AS
BEGIN
	IF @islast = 0
	   AND ISNULL(@Status, '') <> ''
	BEGIN
	    INSERT @table
	    SELECT fud.EnqNo,
	           fud.FollowUpDate,
	           fud.Executive,
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           '',
	           fud.DateCreated,
	           fud.[Status],
	           fud.MeetingStatus
	    FROM   [CRM].CRMDB.dbo.FollowUp_Details AS fud
	           INNER JOIN (
	                    SELECT fs.[value]
	                    FROM   dbo.fn_Split(@Status, ',') AS fs
	                ) AS fspl
	                ON  fud.[Status] = fspl.[value] OR fud.MeetingStatus = fspl.[value]
	END
	ELSE      
	IF @islast = 1
	BEGIN
	    INSERT @table
	    SELECT ISNULL(ed.EnqNo, ''),
	           ISNULL(ed.EnqDate, ''),
	           ISNULL(ed.Name, ''),
	           ISNULL(ed.Mobile_No, ''),
	           ISNULL(ed.Phone_No, ''),
	           ISNULL(ed.R_Address, ''),
	           ISNULL(ed.O_Address, ''),
	           ISNULL(ed.R_Zone, ''),
	           ISNULL(ed.O_Zone, ''),
	           ISNULL(ed.R_Area, ''),
	           ISNULL(ed.O_Area, ''),
	           ISNULL(ed.DateCreated, ''),
	           ed.[Status],
	           ed.MeetingStatus
	    FROM   [CRM].CRMDB.dbo.Pre_Enquiry  AS ed
	           INNER JOIN (
	                    SELECT MAX(pe.[Status]) AS EnqStatus,
	                           MAX(pe.MeetingStatus) AS MeetingStatus
	                    FROM   [CRM].CRMDB.dbo.Pre_Enquiry AS pe
	                    GROUP BY
	                           pe.[Status],
	                           pe.MeetingStatus
	                )                 AS pe2
	                ON  pe2.EnqStatus = ed.[Status]
	                AND pe2.MeetingStatus = ed.MeetingStatus
	    ORDER BY
	           ed.DateCreated DESC
	END 
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[getLinksFromText]    Script Date: 06-06-26 10:25:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[getLinksFromText]
(
	@Tekstas NVARCHAR(MAX)
)
RETURNS @Data TABLE(TheLink NVARCHAR(500))
AS
BEGIN
	DECLARE @FirstIndexOfChar               INT,
	        @LastIndexOfChar                INT,
	        @LengthOfStringBetweenChars     INT,
	        @String                         VARCHAR(MAX)
	
	SET @FirstIndexOfChar = CHARINDEX('http://', @Tekstas, 0) 
	
	WHILE @FirstIndexOfChar > 0
	BEGIN
	    SET @String = ''
	    SET @LastIndexOfChar = CHARINDEX('"', @Tekstas, @FirstIndexOfChar + 7)
	    SET @LengthOfStringBetweenChars = @LastIndexOfChar - @FirstIndexOfChar  
	    
	    SET @String = SUBSTRING(@Tekstas, @FirstIndexOfChar, @LengthOfStringBetweenChars)
	    INSERT INTO @Data
	      (
	        TheLink
	      )
	    VALUES
	      (
	        @String
	      );
	    
	    SET @Tekstas = SUBSTRING(@Tekstas, @LastIndexOfChar, LEN(@Tekstas))
	    SET @FirstIndexOfChar = CHARINDEX('http://', @Tekstas, 0)
	END 
	
	RETURN
END
GO

/****** Object:  UserDefinedFunction [dbo].[It_Depends]    Script Date: 06-06-26 10:25:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 

CREATE   FUNCTION [dbo].[It_Depends] (@ObjectName Varchar(200), @ObjectsOnWhichItDepends bit)

RETURNS @References TABLE (

       ThePath VARCHAR(MAX), --the ancestor objects delimited by a '/'

       TheFullEntityName VARCHAR(200),

       TheType VARCHAR(20),

       iteration INT )

 

/**

summary:   >

 This Table function returns a a table giving the dependencies of the object whose name

 is supplied as a parameter.

 At the moment, only objects are allowed as a parameter, You can specify whether you

 want those objects that rely on the object, or those on whom the object relies.

compatibility: SQL Server 2005 - SQL Server 2012

 Revisions:

 - Author: Phil Factor

   Version: 1.1

   Modification: Allowed both types of dependencies, returned full detail table

   date: 20 Sep 2015

ToDo: Must add assemblies, must allow entities such as types to be specified

example:

     - code: |

Use AdventureWorks

SELECT  space(iteration * 4) + TheFullEntityName + ' (' + rtrim(TheType) + ')'

FROM    dbo.It_Depends('Employee',0)

ORDER BY ThePath

     - code: |

Select * from dbo.It_Depends('Employee',1)

Select * from dbo.It_Depends('Employee',0)

returns:   >

@references table, which has the name, the type, the display order and th

e 'path' of each dependent object

 

**/

AS

BEGIN

DECLARE   @DatabaseDependencies TABLE (

       EntityName VARCHAR(200),

       EntityType CHAR(5),

       DependencyType CHAR(4),

       TheReferredEntity VARCHAR(200),

       TheReferredType CHAR(5) )

 

INSERT  INTO @DatabaseDependencies ( EntityName, EntityType, DependencyType, TheReferredEntity, TheReferredType )

              -- tables that reference udts

        SELECT  object_schema_name(o.object_id) + '.' + o.name, o.type, 'hard', ty.name, 'UDT'

        FROM    sys.objects o

                INNER JOIN sys.columns AS c ON c.object_ID = o.object_id

                INNER JOIN sys.types ty ON ty.user_type_id = c.user_type_id

        WHERE   is_user_defined = 1

        UNION ALL

              -- udtts that reference udts

        SELECT  object_schema_name(tt.type_table_object_id) + '.' + tt.name, 'UDTT', 'hard', ty.name, 'UDT'

        FROM    sys.table_types tt

                INNER JOIN sys.columns AS c ON c.object_id = tt.type_table_object_id

                INNER JOIN sys.types ty ON ty.user_type_id = c.user_type_id

        WHERE   ty.is_user_defined = 1

         UNION ALL

              --tables/views that reference triggers         

        SELECT  object_schema_name(o.object_id) + '.' + o.name, o.type, 'hard', object_schema_name(t.object_id) + '.' + t.name, t.type

        FROM    sys.objects t

                INNER JOIN sys.objects AS o ON o.parent_object_id = t.object_id

        WHERE   o.type = 'TR'

        UNION ALL

              -- tables that reference defaults via columns (only default objects)

        SELECT  object_schema_name(clmns.object_id) + '.' + object_name(clmns.object_id), 'U', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.objects o

                INNER JOIN sys.columns AS clmns ON clmns.default_object_id = o.object_id

        WHERE   o.parent_object_id = 0

        UNION ALL

              -- types that reference defaults (only default objects)

        SELECT  types.name, 'UDT', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.objects o

                INNER JOIN sys.types AS types ON types.default_object_id = o.object_id

        WHERE   o.parent_object_id = 0

        UNION ALL

              -- tables that reference rules via columns

        SELECT  object_schema_name(clmns.object_id) + '.' + object_name(clmns.object_id), 'U', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.objects o

                INNER JOIN sys.columns AS clmns ON clmns.rule_object_id = o.object_id

        UNION ALL          

              -- types that reference rules

        SELECT  types.name, 'UDT', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.objects o

                INNER JOIN sys.types AS types ON types.rule_object_id = o.object_id

        UNION ALL

              -- tables that reference XmlSchemaCollections

        SELECT  object_schema_name(clmns.object_id) + '.' + object_name(clmns.object_id), 'U', 'hard', xml_schema_collections.name, 'XMLC'

        FROM    sys.columns clmns --should we eliminate views?

                INNER JOIN sys.xml_schema_collections ON xml_schema_collections.xml_collection_id = clmns.xml_collection_id

        UNION ALL

              -- table types that reference XmlSchemaCollections

        SELECT  object_schema_name(clmns.object_id) + '.' + object_name(clmns.object_id), 'UDTT', 'hard', xml_schema_collections.name, 'XMLC'

        FROM    sys.columns AS clmns

                INNER JOIN sys.table_types AS tt ON tt.type_table_object_id = clmns.object_id

                INNER JOIN sys.xml_schema_collections ON xml_schema_collections.xml_collection_id = clmns.xml_collection_id

        UNION ALL

              -- procedures that reference XmlSchemaCollections

        SELECT  object_schema_name(params.object_id) + '.' + o.name, o.type, 'hard', xml_schema_collections.name, 'XMLC'

        FROM    sys.parameters AS params

                INNER JOIN sys.xml_schema_collections ON xml_schema_collections.xml_collection_id = params.xml_collection_id

                INNER JOIN sys.objects o ON o.object_id = params.object_id

        UNION ALL

              -- table references table

        SELECT  object_schema_name(tbl.object_id) + '.' + tbl.name, tbl.type, 'hard', object_schema_name(referenced_object_id) + '.' + object_name(referenced_object_id), 'U'

        FROM    sys.foreign_keys AS fk

                INNER JOIN sys.tables AS tbl ON tbl.object_id = fk.parent_object_id

        UNION ALL                

 

              -- uda references types

        SELECT  object_schema_name(params.object_id) + '.' + o.name, o.type, 'hard', types.name, 'UDT'

        FROM    sys.parameters AS params

                INNER JOIN sys.types ON types.user_type_id = params.user_type_id

                INNER JOIN sys.objects o ON o.object_id = params.object_id

        WHERE   is_user_defined <> 0

        UNION ALL

 

              -- table,view references partition scheme

        SELECT  object_schema_name(o.object_id) + '.' + o.name, o.type, 'hard', ps.name, 'PS'

        FROM    sys.indexes AS idx

                INNER JOIN sys.partitions p ON idx.object_id = p.object_id AND idx.index_id = p.index_id

                INNER JOIN sys.partition_schemes ps ON idx.data_space_id = ps.data_space_id

                INNER JOIN sys.objects AS o ON o.object_id = idx.object_id

        UNION ALL

 

              -- partition scheme references partition function

        SELECT  ps.name, 'PS', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.partition_schemes ps

                INNER JOIN sys.objects AS o ON ps.function_id = o.object_id

        UNION ALL         

 

              -- plan guide references sp, udf, triggers

        SELECT  pg.name, 'PG', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.objects o

                INNER JOIN sys.plan_guides AS pg ON pg.scope_object_id = o.object_id

        UNION ALL

 

              -- synonym refrences object

        SELECT  s.name, 'SYN', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.objects o

                INNER JOIN sys.synonyms AS s ON object_id(s.base_object_name) = o.object_id

        UNION ALL                       

             

              --  sequences that reference uddts

        SELECT  s.name, 'SYN', 'hard', object_schema_name(o.object_id) + '.' + o.name, o.type

        FROM    sys.objects o

                INNER JOIN sys.sequences AS s ON s.user_type_id = o.object_id

        UNION ALL

        SELECT DISTINCT

                coalesce(object_schema_name(Referencing_ID) + '.', '') + object_name(Referencing_ID), referencer.type, 'soft', coalesce(referenced_schema_name + '.', '') + --likely schema name

         coalesce(referenced_entity_name, ''), --very likely entity name

                referenced.type

        FROM    sys.sql_expression_dependencies

                INNER JOIN sys.objects referencer ON referencing_id = referencer.object_ID

                INNER JOIN sys.objects referenced ON referenced_id = referenced.object_ID

        WHERE   referencing_Class = 1 AND referenced_class = 1 AND referencer.type IN ( 'v', 'tf', 'fn', 'p', 'tr', 'u' )

 

DECLARE @RowCount INT

DECLARE @ii INT

-- firstly we put in the object as a seed.

INSERT  INTO @References ( ThePath, TheFullEntityName, theType, iteration )

        SELECT  coalesce(object_schema_name(object_ID) + '.', '') + name, coalesce(object_schema_name(object_ID) + '.', '') + name, type, 1

        FROM    sys.objects WHERE name LIKE @ObjectName

-- then we just pull out the dependencies at each level. watching out for

-- self-references and circular references

SELECT  @rowcount = @@ROWCOUNT, @ii = 2

IF @ObjectsOnWhichItDepends<>0 --if we are looking for objects on which it depends

WHILE @ii < 20 AND @rowcount > 0

  BEGIN

    INSERT  INTO @References ( ThePath, TheFullEntityName, theType, iteration )

            SELECT DISTINCT

                    ThePath + '/' + TheReferredEntity, TheReferredEntity, TheReferredType, @ii

            FROM    @DatabaseDependencies DatabaseDependencies

                    INNER JOIN @References previousReferences

                                   ON previousReferences.TheFullEntityName = EntityName

                                    AND previousReferences.iteration = @ii - 1

                     WHERE TheReferredEntity<>EntityName

                     AND TheReferredEntity NOT IN (SELECT TheFullEntityName FROM @References)

    SELECT  @rowcount = @@rowcount

    SELECT  @ii = @ii + 1

  END

ELSE --we are looking for objects that depend on it.

WHILE @ii < 20 AND @rowcount > 0

  BEGIN

    INSERT  INTO @References ( ThePath, TheFullEntityName, theType, iteration )

            SELECT DISTINCT

                    ThePath + '/' + EntityName, EntityName, TheType, @ii

            FROM    @DatabaseDependencies DatabaseDependencies

                    INNER JOIN @References previousReferences

                                   ON previousReferences.TheFullEntityName = TheReferredEntity

                                   AND previousReferences.iteration = @ii - 1

                     WHERE TheReferredEntity<>EntityName

                     AND EntityName NOT IN (SELECT TheFullEntityName FROM @References)

    SELECT  @rowcount = @@rowcount

    SELECT  @ii = @ii + 1

  END

RETURN

 END

 

 

 

 

GO

/****** Object:  UserDefinedFunction [dbo].[LongestCommonSubstring]    Script Date: 06-06-26 10:25:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE   FUNCTION [dbo].[LongestCommonSubstring]
/**
summary:   >
 The longest common subSubstring (LCS) tells you the longest common substring between two strings.
	 If you, for example, were to compare 'And the Dish ran away with the Spoon' with 'away', you'd 
	 get 'away' as being the string in common. Likewise, comparing '465932859472109683472' with 
	 '697834859472135348' would give you  '8594721'. This returns a one-row table that gives you the 
	 length and location of the string as well as the string itself. It can easily be modified to give
	  you all the substrings (whatever your criteria for the smallest substring. E.g. two characters? 
 
Author: Phil Factor
Revision: 1.0
date: 05 Dec 2014
example:
code: |
     Select * from dbo.LongestCommonSubstring ('1234', '1224533324')
     Select * from dbo.LongestCommonSubstring ('thisisatest', 'testing123testing')
     Select * from dbo.LongestCommonSubstring ( 'findthishere', 'where is this?') 
     Select * from dbo.LongestCommonSubstring ( null, 'xab') 
     Select * from dbo.LongestCommonSubstring ( 'not beginning-middle-ending',
       'beginning-diddle-dum-ending')
returns:   >
  the longest common subString as a string
**/    
(
@firstString VARCHAR(MAX),
@SecondString VARCHAR(MAX)
)
RETURNS @hit TABLE --returns a single row table 
--(it is easy to change to return a string but I wanted the location of the match)
(
MatchLength INT,--the length of the match. Not necessarily the length of input 
FirstCharInMatch INT,--first character of match in first string
FirstCharInString INT,--first character of match in second string
CommonString VARCHAR(8000) --the part of the FirstString successfully matched
)
 
AS BEGIN
DECLARE @Order INT, @TheGroup INT, @Sequential INT
--this table is used to do a quirky update to enable a grouping only on sequential characters
DECLARE  @Scratch TABLE (TheRightOrder INT IDENTITY PRIMARY KEY,TheGroup smallint, Sequential INT,
        FirstOrder smallint, SecondOrder smallint, ch CHAR(1))
--first we reduce the amount of data to those characters in the first string that have a match 
--in the second, and where they were.       
INSERT INTO @Scratch ( TheGroup , firstorder,  secondorder, ch)
   SELECT Thefirst.number-TheSecond.number AS TheGroup,Thefirst.number, TheSecond.number, TheSecond.ch 
   FROM --divide up the first string into a table of characters/sequence
    (SELECT number, SUBSTRING(@FirstString,number,1) AS ch
       FROM numbers WHERE number <= LEN(@FirstString)) TheFirst 
   INNER JOIN --divide up the second string into a table of characters/sequence
    (SELECT number, SUBSTRING(@SecondString,number,1) AS ch
       FROM numbers WHERE number <= LEN(@SecondString))  TheSecond
   ON Thefirst.ch= Thesecond.ch --do all valid matches
   ORDER BY Thefirst.number-TheSecond.number, TheSecond.number
--now @scratch has all matches in the correct order for checking unbroken sequence   
SELECT @Order=-1, @TheGroup=-1, @Sequential=0 --initialise everything
UPDATE @Scratch --now check by incrementing a value every time a sequence is broken
  SET @Sequential=Sequential = 
         CASE --if it is not a sequence from the one before increment the variable
           WHEN secondorder=@order+1 AND TheGroup=@TheGroup 
           THEN @Sequential ELSE @Sequential+1 END,
   @Order=secondorder, 
   @TheGroup=TheGroup
--now we just aggregate it, and choose the first longest match. Easy   
INSERT INTO @hit (MatchLength,FirstCharInMatch, FirstCharInString,CommonString)
SELECT  TOP 1 ---just the first. You may want more so feel free to change
    COUNT(*) AS MatchLength, 
    MIN(firstorder) FirstCharInMatch,
    MIN(secondorder) AS FirstCharInString,
    SUBSTRING(@SecondString, 
    MIN(secondorder), 
    COUNT(*)) AS CommonString
  FROM @scratch GROUP BY TheGroup,Sequential 
  ORDER BY COUNT(*) DESC, MIN(firstOrder) ASC, MIN(SecondOrder) ASC
RETURN 
END--and we do a test run
 

GO

/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 06-06-26 10:25:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE   FUNCTION [dbo].[SplitString]  (            @Input NVARCHAR(MAX),        @Character CHAR(1)  )  RETURNS @Output TABLE (        Item NVARCHAR(1000)  )  AS  BEGIN        DECLARE @StartIndex INT, @EndIndex INT           SET @StartIndex = 1        IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character        BEGIN              SET @Input = @Input + @Character        END           WHILE CHARINDEX(@Character, @Input) > 0        BEGIN              SET @EndIndex = CHARINDEX(@Character, @Input)                           INSERT INTO @Output(Item)              SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)                           SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))        END           RETURN  END
GO

/****** Object:  UserDefinedFunction [dbo].[udf_Get_ModuleSettingJSON]    Script Date: 06-06-26 10:25:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[udf_Get_ModuleSettingJSON](
	@ParentId bigint,
	@ModuleId bigint
)
RETURNS @CustomFieldsTable TABLE
(
    Id INT identity(1,1),
	ModuleId bigint,
    TableName NVARCHAR(255),
	DisplayName NVARCHAR(255),
	RowJson NVARCHAR(max)
)
begin
	
	if(@ModuleId = 1)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName,DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.customfields', 'Custom Fields' , (select fieldname as DisplayRowName, *  from Mysms.dbo.customfields(nolock) where parentid = @ParentId and isActive = 1 for json path);
	end

	if(@ModuleId = 2)
	begin
		insert into @CustomFieldsTable(ModuleId,  TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.UserSourceSettings', 'Source Names', 
			(select Name as DisplayRowName, *  from Mysms.dbo.UserSourceSettings(nolock) where UserID = @ParentId and isActive = 1 for json path);

	end
	if(@ModuleId = 3)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.UserMediumSettings', 'Medium Names', (select Name as DisplayRowName, *  from MYSMS.dbo.UserMediumSettings
(nolock) where UserID = @ParentId and IsActive=1 for json path);
	end
	if(@ModuleId = 4)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.UserCampaignSettings', 'Campaign Names', (select Name as DisplayRowName, *  from MYSMS.dbo.UserCampaignSettings(nolock) where UserID = @ParentId and IsActive=1 for json path);
	end
	if(@ModuleId = 5)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'MysmsInvoicing.dbo.Settings', 'Invoice Setting', (select [key] as DisplayRowName, *  from MYSMSInvoicing.dbo.settings(nolock) where parentid = @ParentId and section = 'invoice' for json path);
	end
	if(@ModuleId = 6)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'MysmsInvoicing.dbo.Settings', 'Quotation Setting', (select [key] as DisplayRowName, *  from MYSMSInvoicing.dbo.settings(nolock) where parentid = @ParentId and section = 'quotation' for json path);
	end
	if(@ModuleId = 7)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'MysmsInvoicing.dbo.Settings', 'Credit Note Setting', (select [key] as DisplayRowName, *  from MYSMSInvoicing.dbo.settings(nolock) where parentid = @ParentId and section = 'creditnote' for json path);
	end
	if(@ModuleId = 8)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.tbl_CallLogOutcomeMaster', 'Call Log Outcome Master', (select OutcomeName as DisplayRowName, *  from MYSMS.dbo.tbl_CallLogOutcomeMaster(nolock) where parentid = @ParentId and IsDeleted=0 for json path);
	end
	if(@ModuleId = 10)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.TBL_ET_ExpenseHead', 'Expense Head', (select ExpenseHeadName as DisplayRowName, *  from MYSMS.dbo.TBL_ET_ExpenseHead(nolock) where parentid = @ParentId and IsActive = 1 for json path);
	end
	if(@ModuleId = 11)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.TBL_ET_HolidayMaster','Holiday Master', (select HolidayName as DisplayRowName, *  from MYSMS.dbo.TBL_ET_HolidayMaster(nolock) where parentid = @ParentId and IsActive = 1 for json path);
	end
	if(@ModuleId = 12)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.TBL_ET_ShiftMaster', 'Shift Master', (select ShiftName as DisplayRowName, *  from MYSMS.dbo.TBL_ET_ShiftMaster(nolock) where parentid = @ParentId and IsActive =1 for json path);
	end
	if(@ModuleId = 13)
	begin
		insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
		select @ModuleId, 'Mysms.dbo.UserQuickLinks', 'Quick Links', (select QuickLinkName as DisplayRowName, *  from MYSMS.dbo.UserQuickLinks(nolock) where parentid = @ParentId  for json path);
	end
	--if(@ModuleId = 16)
	--begin
	--declare @ParentConvChannelId bigint=0
	--select top 1 @ParentConvChannelId=id from MyCTest.dbo.channeltokens(nolock) where parentId=@ParentId and channelId=2 and isactive=1 order by id desc
	--	insert into @CustomFieldsTable(ModuleId, TableName, DisplayName, RowJson)
	--	select @ModuleId, 'MyCTest.dbo.convtemplates', 'Whatsapp templates', (select templatename as DisplayRowName, *  from MyCTest.dbo.convtemplates(nolock) where channeltokenId=@ParentConvChannelId and is_deleted=0 and templatestatus='approved' for json path);
	--end
	return;
end

GO

/****** Object:  UserDefinedFunction [dbo].[ufn_CountOccurrence]    Script Date: 06-06-26 10:25:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[ufn_CountOccurrence]   
(  
@txt varchar(max),  
@Pat varchar(max)  
)  
RETURNS   
@tab TABLE   
(  
 ID int  
)  
AS  
BEGIN  
Declare @pos int  
Declare @oldpos int  
Select @oldpos=0  
select @pos=patindex(@pat,@txt)   
while @pos > 0 and @oldpos<>@pos  
 begin  
   insert into @tab Values (@pos)  
   Select @oldpos=@pos  
   select @pos=patindex(@pat,Substring(@txt,@pos + 1,len(@txt))) + @pos  
end  
  
RETURN   
END  
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_CountOccurrence_new]    Script Date: 06-06-26 10:25:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[ufn_CountOccurrence_new]     
(    
   @txt VARCHAR(8000),    
   @Pat VARCHAR(8000)    
)
RETURNS     
@tab TABLE     
(    
   ID INT    
)
AS    
BEGIN    
   DECLARE @pos INT    
   DECLARE @oldpos INT    
   SELECT @oldpos = 0    
   SELECT @pos = PATINDEX(@pat, @txt)     
   WHILE @pos > 0 AND @oldpos <> @pos    
   BEGIN    
      INSERT INTO @tab VALUES (@pos)    
      SELECT @oldpos = @pos    
      SELECT @pos = PATINDEX(@pat, SUBSTRING(@txt, @pos + 1, LEN(@txt))) + @pos    
   END    
   RETURN     
END

GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetUserRoleScope]    Script Date: 06-06-26 10:25:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------

CREATE   FUNCTION [dbo].[ufn_GetUserRoleScope]      -------latest running function on dev
(      
 @UserId BIGINT      
)      
RETURNS @tblUserLst TABLE      
(      
 [UserId]           BIGINT,      
 [ParentId]         BIGINT,      
 [RoleCode]         VARCHAR(50),      
 [RoleName]         VARCHAR(50),      
 [ScopeCode]        VARCHAR(50),      
 [TeamCode]         VARCHAR(50),      
 [TeamName]         VARCHAR(50),      
 [UserIdTeamLst]    VARCHAR(MAX),      
 [UserLoginTeamLst] VARCHAR(MAX)      
)      
AS      
BEGIN      
 -- declare @UserId bigint=45410--32222--36931--42840          
 DECLARE @ParentId BIGINT=0, @UserIdTeamLst VARCHAR(MAX)='', @UserIdHierarchyLst VARCHAR(MAX)='',      
 @UserLoginTeamLst nvarchar(MAX)='', @TeamCode VARCHAR(10)='', @ScopeCode VARCHAR(10)='', @RoleCode      
 VARCHAR(10)='', @RoleName VARCHAR(50)='', @TeamName VARCHAR(50)='', @IsAdmin BIT=0;      
  
 declare @RoleId bigint = 0, @bAddPeerUser bit = 0, @HierarchyJSON varchar(Max) = '', @bAddPeerPermissionMapping varchar(10) = ''  
       
 DECLARE @tbl_tmp_Hierarchy TABLE      
 (      
  [user_id]    BIGINT,      
  [team_name]  VARCHAR(50),      
  [user_login] VARCHAR(50),      
  [username]   VARCHAR(50),      
  [parentid]   BIGINT      
 );      
   
 DECLARE @tbl_tmp_RoleHierarchy TABLE      
 (      
  [roleid]    BIGINT,      
  [rolename]  VARCHAR(50),      
  [rolecode]   VARCHAR(50),      
  [parentid]   BIGINT      
 );      
      
 SELECT @ParentId=[ParentID], @IsAdmin=[IsAdmin] FROM User_Detail(NOLOCK) WHERE User_ID = @UserId;     
   
  --Select @RoleId=tuRolem.RoleId,@bAddPeerUser=tuRolem.PeerView, @bAddPeerPermissionMapping= tuUserrm.PeerViewRoleMappingCode   
  --FROM TBL_UA_UserRoleMappingMaster(NOLOCK) tuUserrm LEFT JOIN TBL_UA_RoleMaster(NOLOCK)  tuRolem    
  --ON tuUserrm.RoleCode = tuRolem.RoleCode and tuRolem.Active=1 and tuUserrm.Active=1  
  --WHERE [tuUserrm].[UserId] = @UserId and [tuUserrm].PeerViewRoleMappingCode = '1'

  SELECT 
    @RoleId = COALESCE(tuRolem.RoleId, sysRolem.id),  @bAddPeerPermissionMapping = tuUserrm.PeerViewRoleMappingCode   
FROM TBL_UA_UserRoleMappingMaster(NOLOCK) tuUserrm 
LEFT JOIN TBL_UA_RoleMaster(NOLOCK) tuRolem   ON tuUserrm.RoleCode = tuRolem.RoleCode 
    AND tuRolem.Active = 1  AND tuUserrm.Active = 1
LEFT JOIN systemRoles(NOLOCK) sysRolem   ON tuUserrm.RoleCode = sysRolem.SysRoleCode
    AND sysRolem.isactive = 1    AND tuUserrm.Active = 1  
WHERE 
    tuUserrm.UserId = @UserId   AND tuUserrm.PeerViewRoleMappingCode = '1';

     
   --print '@bAddPeerUser=' + @bAddPeerUser   
     
 SELECT @TeamCode=[t].[TeamCode], @ScopeCode=[t].[ScopeCode], @RoleCode=[t].[RoleCode], @RoleName=        
 [RoleName], @TeamName=[TeamName],         
 @UserLoginTeamLst=(SELECT STRING_AGG(CAST([udd].[User_Login] AS NVARCHAR(MAX)), ',') FROM [User_Detail](NOLOCK) AS [udd] WHERE User_Id IN(SELECT value FROM [dbo].[fn_Split]([t].[UserIdTeamLst], ','))),        
 @UserIdTeamLst=(SELECT STRING_AGG(CAST([udd].User_Id AS NVARCHAR(MAX)),',') FROM [User_Detail](NOLOCK) AS [udd] WHERE User_Id IN(SELECT value FROM [dbo].[fn_Split]([t].[UserIdTeamLst],',')))        
 FROM      
 (      
  SELECT top 1 [tuUserrm].[UserId], [tuUserrm].[ParentId], [tuUserrm].[RoleCode],       
  [tuRolem].[RoleName], [tuRolepm].[ScopeCode], [tuTeamum].[TeamCode], [TeamName],      
  CASE WHEN TBUS.[ScopeCode] = 'GLOBAL' THEN (SELECT STUFF((SELECT DISTINCT ',' + CAST([UserId] AS VARCHAR(4000)) FROM [TBL_UA_TeamUserMappingMaster](NOLOCK) AS [tuTeamMm] WHERE [tuTeamMm].[TeamCode] = [tuTeamum].[TeamCode] FOR XML PATH('')),1, 1, ''))   
  
   
  WHEN TBUS.[ScopeCode] = 'USER' THEN CAST([tuUserrm].[UserId] AS VARCHAR(50))      
  WHEN TBUS.[ScopeCode] = 'TEAM' and TBUS.[ScopeCode] != 'HIERARCHY' THEN(SELECT STUFF((SELECT DISTINCT ',' + CAST([UserId] AS VARCHAR(4000)) FROM [TBL_UA_TeamUserMappingMaster](NOLOCK) AS [tuTeamMm] WHERE [tuTeamMm].[TeamCode] = [tuTeamum].[TeamCode] FOR
  
 XML PATH('')),1, 1, ''))      
  WHEN TBUS.[ScopeCode] = 'HIERARCHY' THEN ''    
  ELSE CAST([tuUserrm].[UserId] AS VARCHAR(50)) END AS [UserIdTeamLst]      
  FROM TBL_UA_UserRoleMappingMaster(NOLOCK) tuUserrm LEFT JOIN TBL_UA_RoleMaster(NOLOCK)  tuRolem      
  ON tuUserrm.RoleCode = tuRolem.RoleCode  LEFT JOIN TBL_UA_RolePermissionMappingMaster(NOLOCK) AS tuRolepm      
  ON tuUserrm.RoleCode = tuRolepm.RoleCode and tuRolepm.ParentId = dbo.ufn_GetUserParentId([tuUserrm].[UserId]) LEFT JOIN TBL_UA_TeamUserMappingMaster(NOLOCK) AS      
  tuTeamum      
  ON tuUserrm.UserId = tuTeamum.UserId LEFT JOIN TBL_UA_TeamMaster(NOLOCK) AS tutm      
  ON tuTeamum.TeamCode = tutm.TeamCode      
   Left Join TBL_UA_ScopeMaster(nolock) as TBUS    
   on tuRolepm.ScopeCode = TBUS.ScopeCode    
  WHERE [tuUserrm].[UserId] = @UserId and  [tuUserrm].PeerViewRoleMappingCode = '1'    
 ) AS t;      
      
 IF EXISTS(SELECT 1 FROM tbl_UA_RoleHierarchy(NOLOCK) WHERE [ParentId] = @ParentId and IsActive=1)      
 BEGIN      
  --print 'Role Hierarchy exists'      
  --Select @HierarchyJSON = HierarchyJSON, @bAddPeerUser=bAddPeerUser from tbl_UA_RoleHierarchy(nolock) where ParentId = @ParentId and IsActive=1  
  Select @HierarchyJSON = HierarchyJSON from tbl_UA_RoleHierarchy(nolock) where ParentId = @ParentId and IsActive=1  
  
   ---print '@HierarchyJSON=' + @HierarchyJSON   
  
  INSERT INTO @tbl_tmp_RoleHierarchy  
  SELECT [roleid], [rolename], [rolecode], [parentid]      
  FROM OPENJSON(@HierarchyJSON)       
  WITH([roleid] BIGINT, [rolename] VARCHAR(100), [rolecode] VARCHAR(100), [parentid] BIGINT);      
      
/* IF(@bAddPeerUser=1 or @bAddPeerPermissionMapping='1')  
 Begin  
    ;WITH CTE(roleid)  
    AS       
    (      
     SELECT roleid FROM @tbl_tmp_RoleHierarchy WHERE( roleid = @RoleId OR [parentid] = @RoleId )      
     UNION ALL      
     -- recursively add children          
     SELECT [c].roleid FROM @tbl_tmp_RoleHierarchy AS c JOIN CTE ON c.parentid = CTE.roleid      
    )      
  
  
  SELECT @UserIdHierarchyLst=string_agg(CAST(ud.[User_ID] AS NVARCHAR(MAX)), ',')           
  FROM User_Detail(nolock) AS ud inner join TBL_UA_UserRoleMappingMaster(NOLOCK) tuUserrm  
  ON ud.user_id =tuUserrm.UserId inner JOIN TBL_UA_RoleMaster(NOLOCK)  tuRolem    
  ON tuUserrm.RoleCode = tuRolem.RoleCode and tuRolem.Active=1 and tuUserrm.Active=1 and tuUserrm.PeerViewRoleMappingCode='1' inner join CTE    
  ON tuRolem.roleid=CTE.roleid    
  WHERE ud.status = 1  
 End  
 Else  
 Begin  
    ;WITH CTE(roleid)  
    AS       
    (      
     SELECT roleid FROM @tbl_tmp_RoleHierarchy WHERE( roleid = @RoleId OR [parentid] = @RoleId )      
     UNION ALL      
     -- recursively add children          
     SELECT [c].roleid FROM @tbl_tmp_RoleHierarchy AS c JOIN CTE ON c.parentid = CTE.roleid      
    )      
  
   SELECT @UserIdHierarchyLst=string_agg(CAST(ud.[User_ID] AS NVARCHAR(MAX)), ',')  
  FROM User_Detail(nolock) AS ud inner join TBL_UA_UserRoleMappingMaster(NOLOCK) tuUserrm  
  ON ud.user_id =tuUserrm.UserId inner JOIN TBL_UA_RoleMaster(NOLOCK)  tuRolem    
  ON tuUserrm.RoleCode = tuRolem.RoleCode and tuRolem.Active=1 and tuUserrm.Active=1 and tuUserrm.PeerViewRoleMappingCode='1' inner join CTE    
  ON tuRolem.roleid=CTE.roleid    
  WHERE ud.status = 1 and  ud.User_ID not in (Select tuUserrm1.UserId  
   FROM TBL_UA_UserRoleMappingMaster(NOLOCK) tuUserrm1 LEFT JOIN TBL_UA_RoleMaster(NOLOCK)  tuRolem1    
   ON tuUserrm1.RoleCode = tuRolem1.RoleCode and tuRolem1.Active=1 and tuUserrm1.Active=1  
   WHERE [tuUserrm1].[UserId] != @UserId and tuRolem1.RoleId=@RoleId and tuUserrm1.PeerViewRoleMappingCode='1' )  
  
 End  */
  IF (@bAddPeerPermissionMapping = '1')  
BEGIN  
    ;WITH CTE(roleid) AS       
    (      
        SELECT roleid 
        FROM @tbl_tmp_RoleHierarchy 
        WHERE roleid = @RoleId OR parentid = @RoleId      
        UNION ALL      
        SELECT c.roleid 
        FROM @tbl_tmp_RoleHierarchy AS c 
        JOIN CTE 
        ON c.parentid = CTE.roleid      
    )      
    SELECT 
        @UserIdHierarchyLst = STRING_AGG(ud.[User_ID], ',')           
    FROM User_Detail (NOLOCK) AS ud 
    INNER JOIN TBL_UA_UserRoleMappingMaster (NOLOCK) tuUserrm  
        ON ud.user_id = tuUserrm.UserId 
    LEFT JOIN TBL_UA_RoleMaster (NOLOCK) tuRolem    
        ON tuUserrm.RoleCode = tuRolem.RoleCode 
        AND tuRolem.Active = 1 
        AND tuUserrm.Active = 1 
        AND tuUserrm.PeerViewRoleMappingCode = '1'
    LEFT JOIN systemRoles (NOLOCK) sysRolem
        ON tuUserrm.RoleCode = sysRolem.SysRoleCode 
        AND sysRolem.isactive = 1
    INNER JOIN CTE    
        ON (tuRolem.roleid = CTE.roleid OR sysRolem.id = CTE.roleid)    
    WHERE ud.status = 1;  
END  
ELSE  
BEGIN  
    ;WITH CTE(roleid) AS       
    (      
        SELECT roleid 
        FROM @tbl_tmp_RoleHierarchy 
        WHERE roleid = @RoleId OR parentid = @RoleId      
        UNION ALL      
        SELECT c.roleid 
        FROM @tbl_tmp_RoleHierarchy AS c 
        JOIN CTE 
        ON c.parentid = CTE.roleid      
    )      
    SELECT 
        @UserIdHierarchyLst = STRING_AGG(ud.[User_ID], ',')  
    FROM User_Detail (NOLOCK) AS ud 
    INNER JOIN TBL_UA_UserRoleMappingMaster (NOLOCK) tuUserrm  
        ON ud.user_id = tuUserrm.UserId 
    LEFT JOIN TBL_UA_RoleMaster (NOLOCK) tuRolem    
        ON tuUserrm.RoleCode = tuRolem.RoleCode 
        AND tuRolem.Active = 1 
        AND tuUserrm.Active = 1 
        AND tuUserrm.PeerViewRoleMappingCode = '1'
    LEFT JOIN systemRoles (NOLOCK) sysRolem
        ON tuUserrm.RoleCode = sysRolem.SysRoleCode 
        AND sysRolem.isactive = 1
    INNER JOIN CTE    
        ON (tuRolem.roleid = CTE.roleid OR sysRolem.id = CTE.roleid)    
    WHERE 
        ud.status = 1 
        AND ud.User_ID NOT IN (
            SELECT DISTINCT tuUserrm1.UserId  
            FROM TBL_UA_UserRoleMappingMaster (NOLOCK) tuUserrm1 
            LEFT JOIN TBL_UA_RoleMaster (NOLOCK) tuRolem1    
                ON tuUserrm1.RoleCode = tuRolem1.RoleCode 
                AND tuRolem1.Active = 1 
                AND tuUserrm1.Active = 1  
            LEFT JOIN systemRoles (NOLOCK) sysRolem1
                ON tuUserrm1.RoleCode = sysRolem1.SysRoleCode 
                AND sysRolem1.isactive = 1
            WHERE 
                tuUserrm1.UserId != @UserId 
                AND (tuRolem1.RoleId = @RoleId OR sysRolem1.id = @RoleId) 
                AND tuUserrm1.PeerViewRoleMappingCode = '1'
        );  
END

  --select @UserIdHierarchyLst, @UserIdTeamLst      
        
  IF( ISNULL(@UserIdHierarchyLst, '') = '' )      
  BEGIN      
   --print 'A'      
   IF( ISNULL(@UserIdTeamLst, '') = '' )      
   BEGIN      
    --print 'B'      
    SELECT @UserIdTeamLst=@UserId;      
   SELECT @UserLoginTeamLst=CAST([udd].[User_Login] AS NVARCHAR(MAX))      
    FROM User_Detail(NOLOCK) AS udd      
    WHERE User_Id = @UserId;      
   END;      
  END;      
  ELSE      
  BEGIN      
   --print 'C'      
    SELECT @UserLoginTeamLst=(SELECT STRING_AGG(CAST([udd].[User_Login] AS NVARCHAR(MAX)), ',')      
         FROM [User_Detail](NOLOCK) AS [udd]      
         WHERE User_Id IN(SELECT value FROM [dbo].[fn_Split](      
         @UserIdHierarchyLst, ','))), @UserIdTeamLst=@UserIdHierarchyLst;      
  END;      
      
  -- print '@UserLoginTeamLst: ' + @UserLoginTeamLst      
      
 END   
 --select @UserIdTeamLst, @UserLoginTeamLst          
 Else IF EXISTS(SELECT 1 FROM tbl_UA_UserHierarchy(NOLOCK) WHERE [ParentId] = @ParentId and IsActive=1)      
 BEGIN      
  --print 'Hierarchy exists'      
  INSERT INTO @tbl_tmp_Hierarchy      
  SELECT [user_id], '' AS [team_name], [user_login], [username], [parentid]      
  FROM OPENJSON((SELECT TOP 1 [HierarchyJSON] FROM tbl_UA_UserHierarchy(NOLOCK) WHERE [ParentId]= @ParentId and IsActive=1))       
  WITH([user_id] BIGINT, user_login VARCHAR(100), username VARCHAR(100), [parentid] BIGINT);      
      
  --declare @UserId bigint=36931          
  --update @tbl_tmp_Hierarchy set parentid=36931 where user_id=39831          
  --update @tbl_tmp_Hierarchy set parentid=36931 where user_id=39768          
  --update @tbl_tmp_Hierarchy set parentid=36932 where user_id=39307          
  --update @tbl_tmp_Hierarchy set parentid=36932 where user_id=39305          
  --update @tbl_tmp_Hierarchy set parentid=39831 where user_id=38993          
  --update @tbl_tmp_Hierarchy set parentid=39768 where user_id=38997          
  --update @tbl_tmp_Hierarchy set parentid=39307 where user_id=39834          
  --update @tbl_tmp_Hierarchy set parentid=39305 where user_id=38990          
  WITH CTE(user_id)      
  AS       
  (      
   SELECT user_id FROM @tbl_tmp_Hierarchy WHERE( User_id = @UserId OR [parentid] = @UserId )      
   UNION ALL      
   -- recursively add children          
   SELECT [c].user_id FROM @tbl_tmp_Hierarchy AS c JOIN CTE ON c.parentid = CTE.User_id      
  )      
  SELECT @UserIdHierarchyLst=STUFF((SELECT DISTINCT ',' + CAST([a].user_id AS VARCHAR(MAX)) FROM @tbl_tmp_Hierarchy AS [a] JOIN [CTE] ON [CTE].user_id = [a].User_id FOR XML PATH('')), 1, 1,'');      
      
  --select @UserIdHierarchyLst, @UserIdTeamLst      
        
  IF( ISNULL(@UserIdHierarchyLst, '') = '' )      
  BEGIN      
   --print 'A'      
   IF( ISNULL(@UserIdTeamLst, '') = '' )      
   BEGIN      
    --print 'B'      
    SELECT @UserIdTeamLst=@UserId;      
    SELECT @UserLoginTeamLst=CAST([udd].[User_Login] AS NVARCHAR(MAX))    
    FROM User_Detail(NOLOCK) AS udd      
    WHERE User_Id = @UserId;      
   END;      
  END;      
  ELSE      
  BEGIN      
   --print 'C'      
   SELECT @UserLoginTeamLst=(SELECT STRING_AGG(CAST([udd].[User_Login] AS NVARCHAR(MAX)), ',')      
         FROM [User_Detail](NOLOCK) AS [udd]      
         WHERE User_Id IN(SELECT value FROM [dbo].[fn_Split](      
         @UserIdHierarchyLst, ','))), @UserIdTeamLst=@UserIdHierarchyLst;      
  END;      
      
  --print '@UserLoginTeamLst: ' + @UserLoginTeamLst      
      
 END;      
      
 IF( ( @ParentId = @UserId ) OR ( @IsAdmin = 1 ) )      
 BEGIN      
  --print 'D'      
  SELECT @UserIdTeamLst=STRING_AGG(CAST([udd].User_Id AS NVARCHAR(max)), ',')       
  FROM User_Detail(NOLOCK) AS udd      
  WHERE [ParentID] = @ParentId;      
  SELECT @UserLoginTeamLst=STRING_AGG(CAST([udd].[User_Login] AS NVARCHAR(MAX)), ',')     
  FROM User_Detail(NOLOCK) AS udd      
  WHERE [ParentID] = @ParentId;      
 END;      
      
 IF( ( @ParentId != @UserId ) AND ( @IsAdmin = 0 ) and @UserIdTeamLst='')      
 BEGIN      
  --print 'E'      
  SELECT @UserIdTeamLst=STRING_AGG(CAST([udd].User_Id AS NVARCHAR(MAX)), ',')     
  FROM User_Detail(NOLOCK) AS udd      
  WHERE [User_ID] = @UserId;      
  SELECT @UserLoginTeamLst=STRING_AGG(CAST([udd].[User_Login] AS NVARCHAR(MAX)), ',')      
  FROM User_Detail(NOLOCK) AS udd      
  WHERE [User_ID] = @UserId;      
 END;      
      
 --select @UserId,@ParentId,@RoleCode,@RoleName,@ScopeCode,@TeamCode,@TeamName,@UserIdTeamLst,@UserLoginTeamLst          
 INSERT INTO @tblUserLst      
 VALUES(@UserId, @ParentId, @RoleCode, @RoleName, @ScopeCode, @TeamCode, @TeamName, @UserIdTeamLst,      
 @UserLoginTeamLst);      
      
 RETURN;      
END; 


GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetUserRoleScope$]    Script Date: 06-06-26 10:25:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- select * from dbo.ufn_GetUserRoleScope$(32222)
-- select * from dbo.ufn_GetUserRoleScope$(36931)
-- select * from dbo.ufn_GetUserRoleScope$(34594)
CREATE   FUNCTION [dbo].[ufn_GetUserRoleScope$](@UserId bigint)       
returns @tblUserLst table       
(	
	UserId				bigint,
	ParentId			bigint,
	RoleCode			varchar(50),
	RoleName			varchar(50),
	ScopeCode			varchar(50),
	TeamCode			varchar(50),
	TeamName			varchar(50),
	UserIdTeamLst		varchar(max),
	UserLoginTeamLst	varchar(max)
)
As 
Begin
	-- declare @UserId bigint=36931
	declare @ParentId bigint = 0, @UserIdTeamLst varchar(max)='', @UserIdHierarchyLst varchar(max)='',
			@UserLoginTeamLst varchar(max)='', 	@TeamCode varchar(10) = '', @ScopeCode varchar(10) = '',
			@RoleCode varchar(10) = '', @RoleName varchar(50) = '',	@TeamName varchar(50) = ''
	declare @tbl_tmp_Hierarchy table 
	(
		[user_id] bigint, 
		team_name Varchar(50), 
		user_login varchar(50), 
		username varchar(50), 
		[parentid] bigint
	)

	Select @ParentId=ParentID from User_Detail(nolock) Where User_ID=@UserId

	select @TeamCode=t.TeamCode, @ScopeCode=t.ScopeCode, @RoleCode=t.RoleCode, @RoleName=RoleName, @TeamName=TeamName, @UserLoginTeamLst=(select STRING_AGG(cast(udd.User_Login as varchar),',') from User_Detail(nolock) udd where User_Id in (select value from dbo.fn_Split(t.UserIdTeamLst,','))), @UserIdTeamLst=(select STRING_AGG(cast(udd.User_Id as varchar),',') from User_Detail(nolock) udd where User_Id in (select value from dbo.fn_Split(t.UserIdTeamLst,','))) 
	from 
	(
		select distinct tuUserrm.UserId, tuUserrm.ParentId, tuUserrm.RoleCode, tuRolem.RoleName, tuRolepm.ScopeCode, tuTeamum.TeamCode, TeamName,
		Case
			When ScopeCode = 'GLOBAL' Then Cast(0 as varchar(50))
			When ScopeCode = 'USER' Then Cast(tuUserrm.UserId as varchar(50))
			When ScopeCode = 'TEAM' Then (SELECT STUFF((SELECT distinct ',' + Cast(UserId as varchar(4000)) 
					FROM TBL_UA_TeamUserMappingMaster(nolock) tuTeamMm
					where tuTeamMm.TeamCode = tuTeamum.TeamCode FOR XML PATH('')),1,1,''))
			Else Cast(tuUserrm.UserId as varchar(50))
		End as UserIdTeamLst
		from TBL_UA_UserRoleMappingMaster(nolock) tuUserrm left join TBL_UA_RoleMaster(nolock) tuRolem 
		on tuUserrm.RoleCode = tuRolem.RoleCode left join TBL_UA_RolePermissionMappingMaster(nolock) tuRolepm 
		on tuUserrm.RoleCode = tuRolepm.RoleCode left join TBL_UA_TeamUserMappingMaster(nolock) tuTeamum 
		on tuUserrm.UserId = tuTeamum.UserId left join TBL_UA_TeamMaster(nolock) tutm 
		on tuTeamum.TeamCode = tutm.TeamCode
		where tuUserrm.UserId = @UserId
	)t

	--select @UserIdTeamLst, @UserLoginTeamLst
	
	If Exists(select 1 from tbl_UA_UserHierarchy(nolock) where ParentId = @ParentId) 
	Begin
	  insert into @tbl_tmp_Hierarchy
	  Select [user_id], '' as team_name, user_login, username, [parentid] 
	  from OPENJSON((select top 1 HierarchyJSON from tbl_UA_UserHierarchy(nolock) where ParentId = @ParentId))
	  with ([user_id] bigint, user_login Varchar(100), username Varchar(100), [parentid] bigint)

	  --declare @UserId bigint=36931
		--update @tbl_tmp_Hierarchy set parentid=36931 where user_id=39831
		--update @tbl_tmp_Hierarchy set parentid=36931 where user_id=39768
		--update @tbl_tmp_Hierarchy set parentid=36932 where user_id=39307
		--update @tbl_tmp_Hierarchy set parentid=36932 where user_id=39305
		--update @tbl_tmp_Hierarchy set parentid=39831 where user_id=38993
		--update @tbl_tmp_Hierarchy set parentid=39768 where user_id=38997
		--update @tbl_tmp_Hierarchy set parentid=39307 where user_id=39834
		--update @tbl_tmp_Hierarchy set parentid=39305 where user_id=38990

		;with CTE(user_id) 
		 as 
		 ( 
			  select user_id 
			  from @tbl_tmp_Hierarchy where (User_id = @UserId or parentid = @UserId)
			  union all 
			  -- recursively add children
			  select c.user_id
			  from @tbl_tmp_Hierarchy c 
			  join CTE on c.parentid = CTE.User_id
		 ) 
		SELECT @UserIdHierarchyLst = STUFF((SELECT distinct ',' + Cast(a.user_id as varchar(max)) from @tbl_tmp_Hierarchy a join CTE on CTE.user_id = a.User_id FOR XML PATH('')),1,1,'')

		--select @UserIdHierarchyLst

		If (isnull(@UserIdHierarchyLst,'') = '')
		Begin
			If(isnull(@UserIdTeamLst,'') = '')
			Begin
				select @UserIdTeamLst=@UserId 
				select @UserLoginTeamLst=cast(udd.User_Login as varchar) from User_Detail(nolock) udd where User_Id = @UserId
			End
		End
		Else
		Begin
			select @UserLoginTeamLst=(select STRING_AGG(cast(udd.User_Login as varchar),',') from User_Detail(nolock) udd where User_Id in (select value from dbo.fn_Split(@UserIdHierarchyLst,','))), @UserIdTeamLst=@UserIdHierarchyLst
		End
		
	End

	--select @UserId,@ParentId,@RoleCode,@RoleName,@ScopeCode,@TeamCode,@TeamName,@UserIdTeamLst,@UserLoginTeamLst

	insert into @tblUserLst
	values(@UserId,@ParentId,@RoleCode,@RoleName,@ScopeCode,@TeamCode,@TeamName,@UserIdTeamLst,@UserLoginTeamLst)

	Return;
End

GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetUserRoleScope_21052024]    Script Date: 06-06-26 10:25:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- select * from dbo.ufn_GetUserRoleScope(32222)        
-- select * from dbo.ufn_GetUserRoleScope(36931)        
-- select * from dbo.ufn_GetUserRoleScope(34594)       
CREATE   FUNCTION [dbo].[ufn_GetUserRoleScope_21052024]    
(    
 @UserId BIGINT    
)    
RETURNS @tblUserLst TABLE    
(    
 [UserId]           BIGINT,    
 [ParentId]         BIGINT,    
 [RoleCode]         VARCHAR(50),    
 [RoleName]         VARCHAR(50),    
 [ScopeCode]        VARCHAR(50),    
 [TeamCode]         VARCHAR(50),    
 [TeamName]         VARCHAR(50),    
 [UserIdTeamLst]    VARCHAR(MAX),    
 [UserLoginTeamLst] VARCHAR(MAX)    
)    
AS    
BEGIN    
 -- declare @UserId bigint=32222--36931--42840        
 DECLARE @ParentId BIGINT=0, @UserIdTeamLst VARCHAR(MAX)='', @UserIdHierarchyLst VARCHAR(MAX)='',    
 @UserLoginTeamLst VARCHAR(MAX)='', @TeamCode VARCHAR(10)='', @ScopeCode VARCHAR(10)='', @RoleCode    
 VARCHAR(10)='', @RoleName VARCHAR(50)='', @TeamName VARCHAR(50)='', @IsAdmin BIT=0;    
     
 DECLARE @tbl_tmp_Hierarchy TABLE    
 (    
  [user_id]    BIGINT,    
  [team_name]  VARCHAR(50),    
  [user_login] VARCHAR(50),    
  [username]   VARCHAR(50),    
  [parentid]   BIGINT    
 );    
    
 SELECT @ParentId=[ParentID], @IsAdmin=[IsAdmin] FROM User_Detail(NOLOCK) WHERE User_ID = @UserId;    
    
 SELECT @TeamCode=[t].[TeamCode], @ScopeCode=[t].[ScopeCode], @RoleCode=[t].[RoleCode], @RoleName=    
 [RoleName], @TeamName=[TeamName],     
 @UserLoginTeamLst=(SELECT STRING_AGG(CAST([udd].[User_Login] AS VARCHAR), ',') FROM [User_Detail](NOLOCK) AS [udd] WHERE User_Id IN(SELECT value FROM [dbo].[fn_Split]([t].[UserIdTeamLst], ','))),    
 @UserIdTeamLst=(SELECT STRING_AGG(CAST([udd].User_Id AS VARCHAR),',') FROM [User_Detail](NOLOCK) AS [udd] WHERE User_Id IN(SELECT value FROM [dbo].[fn_Split]([t].[UserIdTeamLst],',')))    
 FROM    
 (    
  SELECT top 1 [tuUserrm].[UserId], [tuUserrm].[ParentId], [tuUserrm].[RoleCode],     
  [tuRolem].[RoleName], [tuRolepm].[ScopeCode], [tuTeamum].[TeamCode], [TeamName],    
  CASE WHEN TBUS.[ScopeCode] = 'GLOBAL' THEN (SELECT STUFF((SELECT DISTINCT ',' + CAST([UserId] AS VARCHAR(4000)) FROM [TBL_UA_TeamUserMappingMaster](NOLOCK) AS [tuTeamMm] WHERE [tuTeamMm].[TeamCode] = [tuTeamum].[TeamCode] FOR XML PATH('')),1, 1, ''))   
 
  WHEN TBUS.[ScopeCode] = 'USER' THEN CAST([tuUserrm].[UserId] AS VARCHAR(50))    
  WHEN TBUS.[ScopeCode] = 'TEAM' and TBUS.[ScopeCode] != 'HIERARCHY' THEN(SELECT STUFF((SELECT DISTINCT ',' + CAST([UserId] AS VARCHAR(4000)) FROM [TBL_UA_TeamUserMappingMaster](NOLOCK) AS [tuTeamMm] WHERE [tuTeamMm].[TeamCode] = [tuTeamum].[TeamCode] FOR
 XML PATH('')),1, 1, ''))    
  WHEN TBUS.[ScopeCode] = 'HIERARCHY' THEN ''  
  ELSE CAST([tuUserrm].[UserId] AS VARCHAR(50)) END AS [UserIdTeamLst]    
  FROM TBL_UA_UserRoleMappingMaster(NOLOCK) tuUserrm LEFT JOIN TBL_UA_RoleMaster(NOLOCK)  tuRolem    
  ON tuUserrm.RoleCode = tuRolem.RoleCode LEFT JOIN TBL_UA_RolePermissionMappingMaster(NOLOCK) AS tuRolepm    
  ON tuUserrm.RoleCode = tuRolepm.RoleCode LEFT JOIN TBL_UA_TeamUserMappingMaster(NOLOCK) AS    
  tuTeamum    
  ON tuUserrm.UserId = tuTeamum.UserId LEFT JOIN TBL_UA_TeamMaster(NOLOCK) AS tutm    
  ON tuTeamum.TeamCode = tutm.TeamCode    
   Left Join TBL_UA_ScopeMaster(nolock) as TBUS  
   on tuRolepm.ScopeCode = TBUS.ScopeCode  
  WHERE [tuUserrm].[UserId] = @UserId    
 ) AS t;    
    
 --select @UserIdTeamLst, @UserLoginTeamLst        
 IF EXISTS(SELECT 1 FROM tbl_UA_UserHierarchy(NOLOCK) WHERE [ParentId] = @ParentId)    
 BEGIN    
  --print 'Hierarchy exists'    
  INSERT INTO @tbl_tmp_Hierarchy    
  SELECT [user_id], '' AS [team_name], [user_login], [username], [parentid]    
  FROM OPENJSON((SELECT TOP 1 [HierarchyJSON] FROM tbl_UA_UserHierarchy(NOLOCK) WHERE [ParentId]= @ParentId))     
  WITH([user_id] BIGINT, user_login VARCHAR(100), username VARCHAR(100), [parentid] BIGINT);    
    
  --declare @UserId bigint=36931        
  --update @tbl_tmp_Hierarchy set parentid=36931 where user_id=39831        
  --update @tbl_tmp_Hierarchy set parentid=36931 where user_id=39768        
  --update @tbl_tmp_Hierarchy set parentid=36932 where user_id=39307        
  --update @tbl_tmp_Hierarchy set parentid=36932 where user_id=39305        
  --update @tbl_tmp_Hierarchy set parentid=39831 where user_id=38993        
  --update @tbl_tmp_Hierarchy set parentid=39768 where user_id=38997        
  --update @tbl_tmp_Hierarchy set parentid=39307 where user_id=39834        
  --update @tbl_tmp_Hierarchy set parentid=39305 where user_id=38990        
  WITH CTE(user_id)    
  AS     
  (    
   SELECT user_id FROM @tbl_tmp_Hierarchy WHERE( User_id = @UserId OR [parentid] = @UserId )    
   UNION ALL    
   -- recursively add children        
   SELECT [c].user_id FROM @tbl_tmp_Hierarchy AS c JOIN CTE ON c.parentid = CTE.User_id    
  )    
  SELECT @UserIdHierarchyLst=STUFF((SELECT DISTINCT ',' + CAST([a].user_id AS VARCHAR(MAX)) FROM @tbl_tmp_Hierarchy AS [a] JOIN [CTE] ON [CTE].user_id = [a].User_id FOR XML PATH('')), 1, 1,'');    
    
  --select @UserIdHierarchyLst, @UserIdTeamLst    
      
  IF( ISNULL(@UserIdHierarchyLst, '') = '' )    
  BEGIN    
   --print 'A'    
   IF( ISNULL(@UserIdTeamLst, '') = '' )    
   BEGIN    
    --print 'B'    
    SELECT @UserIdTeamLst=@UserId;    
    SELECT @UserLoginTeamLst=CAST([udd].[User_Login] AS VARCHAR)    
    FROM User_Detail(NOLOCK) AS udd    
    WHERE User_Id = @UserId;    
   END;    
  END;    
  ELSE    
  BEGIN    
   --print 'C'    
   SELECT @UserLoginTeamLst=(SELECT STRING_AGG(CAST([udd].[User_Login] AS VARCHAR), ',')    
         FROM [User_Detail](NOLOCK) AS [udd]    
         WHERE User_Id IN(SELECT value FROM [dbo].[fn_Split](    
         @UserIdHierarchyLst, ','))), @UserIdTeamLst=@UserIdHierarchyLst;    
  END;    
    
  --print '@UserLoginTeamLst: ' + @UserLoginTeamLst    
    
 END;    
    
 IF( ( @ParentId = @UserId ) OR ( @IsAdmin = 1 ) )    
 BEGIN    
  --print 'D'    
  SELECT @UserIdTeamLst=STRING_AGG(CAST([udd].User_Id AS VARCHAR), ',')    
  FROM User_Detail(NOLOCK) AS udd    
  WHERE [ParentID] = @ParentId;    
  SELECT @UserLoginTeamLst=STRING_AGG(CAST([udd].[User_Login] AS VARCHAR), ',')    
  FROM User_Detail(NOLOCK) AS udd    
  WHERE [ParentID] = @ParentId;    
 END;    
    
 IF( ( @ParentId != @UserId ) AND ( @IsAdmin = 0 ) and @UserIdTeamLst='')    
 BEGIN    
  --print 'E'    
  SELECT @UserIdTeamLst=STRING_AGG(CAST([udd].User_Id AS VARCHAR), ',')    
  FROM User_Detail(NOLOCK) AS udd    
  WHERE [User_ID] = @UserId;    
  SELECT @UserLoginTeamLst=STRING_AGG(CAST([udd].[User_Login] AS VARCHAR), ',')    
  FROM User_Detail(NOLOCK) AS udd    
  WHERE [User_ID] = @UserId;    
 END;    
    
 --select @UserId,@ParentId,@RoleCode,@RoleName,@ScopeCode,@TeamCode,@TeamName,@UserIdTeamLst,@UserLoginTeamLst        
 INSERT INTO @tblUserLst    
 VALUES(@UserId, @ParentId, @RoleCode, @RoleName, @ScopeCode, @TeamCode, @TeamName, @UserIdTeamLst,    
 @UserLoginTeamLst);    
    
 RETURN;    
END; 
GO

/****** Object:  UserDefinedFunction [dbo].[usp_Tbl_UA_ModuleMasterModuleCodeList]    Script Date: 06-06-26 10:25:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[usp_Tbl_UA_ModuleMasterModuleCodeList] 
(    
@UserId bigint,            
@ScopeCode varchar(20), --= 'TEAM'    
@RoleCode varchar(20), --= 'ROLE2099'    
@ModuleCode varchar(20)            
)            
returns @T table(ModuleCode varchar(20))              
as            
Begin            
Declare @ParentId as bigint            
 set @ParentId = (select top 1 ParentId from User_Detail where User_Id = @UserId)            
            
insert into @T(ModuleCode)             
select ModuleCode from (            
select tumm2.ModuleId, tumm2.ModuleCode, Type from TBL_UA_ModuleMaster tumm2 where             
tumm2.ParentModuleId in (select tumm.ModuleId from TBL_UA_RolePermissionMappingMaster turp             
inner join TBL_UA_EntityActionMappingMaster ent on ent.EntityActionMappingCode = turp.EntityActionMappingCode      
 inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode            
 where turp.ModuleCode like 'Mod%' and ent.[View] = 1 and turp.ParentId = @ParentId and turp.ScopeCode = @ScopeCode and turp.RoleCode = @RoleCode  )            
Union All            
select tumm3.ModuleId, tumm3.ModuleCode, Type from TBL_UA_ModuleMaster tumm3 where             
tumm3.ParentModuleId in (            
select tumm2.ModuleId from TBL_UA_ModuleMaster tumm2 where             
tumm2.ParentModuleId in (select tumm.ModuleId from TBL_UA_RolePermissionMappingMaster turp             
inner join TBL_UA_EntityActionMappingMaster ent on ent.EntityActionMappingCode = turp.EntityActionMappingCode      
 inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode            
 where turp.ModuleCode like 'Mod%' and ent.[View] = 1 and turp.ParentId = @ParentId and turp.ScopeCode = @ScopeCode and turp.RoleCode = @RoleCode  ))            
Union All            
select tumm.ModuleId, tumm.ModuleCode, Type from TBL_UA_RolePermissionMappingMaster turp     
inner join TBL_UA_EntityActionMappingMaster ent on ent.EntityActionMappingCode = turp.EntityActionMappingCode    
inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode     
 where turp.ModuleCode like 'Pag%' and turp.ScopeCode = @ScopeCode and turp.RoleCode = @RoleCode    
and ent.[View] = 1     
and turp.ParentId = @ParentId    
    
 )t where ModuleCode= @ModuleCode and Type = 'Page'        
 return             
End 
GO

/****** Object:  UserDefinedFunction [dbo].[usp_Tbl_UA_ModuleMasterModuleCodeListNew]    Script Date: 06-06-26 10:25:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[usp_Tbl_UA_ModuleMasterModuleCodeListNew]          
(    
@UserId bigint,    
@ModuleCode varchar(20)    
)    
returns @T table(ModuleCode varchar(20))      
as    
Begin    
  
--Declare @UserId bigint = 31885--27053  
--Declare @ModuleCode varchar(20) = 'PAG10031'  
--select @ParentId = ParentId from User_Detail Where User_ID = @UserId  
insert into @T(ModuleCode)     
select ModuleCode from (  
select ModuleCode, ter.[View]  
--tm.UserId, tmm.ParentId, ter.[View], tur.RoleCode   
from TBL_UA_TeamUserMappingMaster tm   
inner join TBL_UA_TeamMaster tmm on tmm.TeamCode = tm.TeamCode   
inner join TBL_UA_UserRoleMappingMaster tr on tr.UserId = tm.UserId  
inner join TBL_UA_RolePermissionMappingMaster tur on tur.ParentId = tmm.ParentId and tur.RoleCode = tr.RoleCode   
inner join TBL_UA_EntityActionMappingMaster ter on ter.EntityActionMappingCode = tur.EntityActionMappingCode  
where tm.UserId = @UserId --and ScopeCode = 'TEAM'   
and tur.ModuleCode = @ModuleCode  
)t where [View] = 1 return     
End    
GO

/****** Object:  UserDefinedFunction [dbo].[usp_Tbl_UA_ModuleMasterModuleCodeListTest]    Script Date: 06-06-26 10:25:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE   FUNCTION [dbo].[usp_Tbl_UA_ModuleMasterModuleCodeListTest]  
(    
@UserId bigint,            
@ScopeCode varchar(20), --= 'TEAM'    
@RoleCode varchar(20), --= 'ROLE2099'    
@ModuleCode varchar(20)            
)            
returns @T table(ModuleCode varchar(20))              
as            
Begin            
Declare @ParentId as bigint            
 set @ParentId = (select top 1 ParentId from User_Detail where User_Id = @UserId)            
            
insert into @T(ModuleCode)             
select ModuleCode from (            
select tumm2.ModuleId, tumm2.ModuleCode, Type from TBL_UA_ModuleMaster tumm2 where             
tumm2.ParentModuleId in (select tumm.ModuleId from TBL_UA_RolePermissionMappingMaster turp             
inner join TBL_UA_EntityActionMappingMaster ent on ent.EntityActionMappingCode = turp.EntityActionMappingCode      
 inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode            
 where turp.ModuleCode like 'Mod%' and ent.[View] = 1 and turp.ParentId = @ParentId and turp.ScopeCode = @ScopeCode and turp.RoleCode = @RoleCode  )            
Union All            
select tumm3.ModuleId, tumm3.ModuleCode, Type from TBL_UA_ModuleMaster tumm3 where             
tumm3.ParentModuleId in (            
select tumm2.ModuleId from TBL_UA_ModuleMaster tumm2 where             
tumm2.ParentModuleId in (select tumm.ModuleId from TBL_UA_RolePermissionMappingMaster turp             
inner join TBL_UA_EntityActionMappingMaster ent on ent.EntityActionMappingCode = turp.EntityActionMappingCode      
 inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode            
 where turp.ModuleCode like 'Mod%' and ent.[View] = 1 and turp.ParentId = @ParentId and turp.ScopeCode = @ScopeCode and turp.RoleCode = @RoleCode  ))            
Union All            
select tumm.ModuleId, tumm.ModuleCode, Type from TBL_UA_RolePermissionMappingMaster turp     
inner join TBL_UA_EntityActionMappingMaster ent on ent.EntityActionMappingCode = turp.EntityActionMappingCode    
inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode     
 where turp.ModuleCode like 'Pag%' and turp.ScopeCode = @ScopeCode and turp.RoleCode = @RoleCode    
and ent.[View] = 1     
and turp.ParentId = @ParentId    
    
 )t where ModuleCode= @ModuleCode and Type = 'Page'        
 return             
End 

GO

/****** Object:  UserDefinedFunction [dbo].[Fn_GroupWiseContactDetails]    Script Date: 06-06-26 10:25:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[Fn_GroupWiseContactDetails](@gid int)
returns table 
As return(select cd.contact_id,cd.m_id,cgd.group_id,cd.user_id,cd.contact_name,cd.contact_mobile,cd.contact_email,cd.Contact_BG,cd.Contact_DOB,cd.Contact_Anniversary from contact_detail cd        
left join contact_group_detail cgd on cd.contact_id=cgd.contact_id and cd.m_id=cgd.m_id and cd.user_id= cgd.user_id        
left join group_detail gd on cgd.m_id=gd.m_id and cgd.user_id=gd.user_id and cgd.group_id=gd.group_id        
where cgd.group_id=@gid)

GO

/****** Object:  UserDefinedFunction [dbo].[Fn_CustPaging]    Script Date: 06-06-26 10:25:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[Fn_CustPaging](@gid int,@pageIndex int,@PageSize int=2)
returns table 
As return
(
select * from (SELECT  *, ROW_NUMBER()   OVER(ORDER BY contact_id ASC) AS rownum from  Fn_GroupWiseContactDetails(@gid)) as TempTable                       
where rownum between (@pageIndex-1)*@PageSize+1 AND @pageIndex*@PageSize     
)

GO

/****** Object:  UserDefinedFunction [dbo].[FindJsonKey]    Script Date: 06-06-26 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[FindJsonKey]
(
    @json NVARCHAR(MAX),
    @searchKey NVARCHAR(200)
)
RETURNS TABLE
AS
RETURN
(
    WITH JsonTree AS
    (
        SELECT 
            [key],
            value,
            type,
            CAST([key] AS NVARCHAR(MAX)) AS FullPath
        FROM OPENJSON(@json)

        UNION ALL

        SELECT 
            j.[key],
            j.value,
            j.type,
            CAST(t.FullPath + '.' + j.[key] AS NVARCHAR(MAX))
        FROM JsonTree t
        CROSS APPLY OPENJSON(t.value) j
        WHERE t.type IN (4,5)
    )

    SELECT *
    FROM JsonTree
    WHERE [key] = @searchKey
)

GO

/****** Object:  UserDefinedFunction [dbo].[fn_Tbl_ET_CheckInOutNumberByUserIdDate]    Script Date: 06-06-26 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[fn_Tbl_ET_CheckInOutNumberByUserIdDate]
(
@UserId bigint,
@ActivityDate datetime
)
returns table 
as 
return(select sum(DefaultCount) TotalDefaultCount, sum(CountCheckIn) TotalCountCheckIn, sum(CountCheckOut) TotalCountCheckOut, StartDate, EndDate
	from (
	select 1 DefaultCount, (case when chin.CheckIn != '' then 1 else 0 End) CountCheckIn, (case when chin.CheckOut != '' then 1 else 0 End) CountCheckOut, chin.CheckIn, chin.CheckOut, cast(phyapt.StartDate as date) StartDate,  cast(phyapt.EndDate as date) EndDate from TBL_ET_PhysicalAppointment (nolock) phyapt 
	inner join TBL_ET_PhyAppointUserMapping (nolock) phyUM on phyapt.PhysicalAppointmentId = phyUM.PhysicalAppointmentId 
	inner join TBL_ET_GeoEntityCheckInOut (nolock) chin on phyapt.PhysicalAppointmentId = chin.PhysicalAppointmentId 
	where (cast(@ActivityDate as date) between cast(chin.CheckIn as date) and cast(chin.CheckOut as Date)) 
	and phyUM.UserId = @UserId 
) tt 
group by DefaultCount, CountCheckIn, CountCheckOut, StartDate, EndDate) 

GO

/****** Object:  UserDefinedFunction [dbo].[Minimum_Func]    Script Date: 06-06-26 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[Minimum_Func]
(@Param1 Integer, @Param2 Integer)
Returns Table As
Return(Select Case When @Param1 < @Param2 
                   Then @Param1 Else @Param2 End MinValue)
GO

/****** Object:  UserDefinedFunction [dbo].[udf_tsk_GetCollaboratersLeadEditView1]    Script Date: 06-06-26 10:25:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 -- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   FUNCTION  [dbo].[udf_tsk_GetCollaboratersLeadEditView1]  
(   
 @TaskHistoryId bigint,@Userid bigint ,@parentid bigint  
)  
RETURNS TABLE   
AS  
	
RETURN   
(  
  
Select @TaskHistoryId TaskHistoryId, iif (th.Assignedto=@Userid,1, ISNULL( usp.Has_viewLead,0)) Has_viewLead, iif (th.Assignedto=@Userid,1, ISNULL(usp.Has_editLead,0)) Has_editLead,  
  iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldviewLead,0)) Has_fieldviewLead,iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldeditLead,0)) Has_fieldeditLead  
 from   
 tbl_tsk_TaskHistory th (NOLOCK)  
 JOIN User_Detail(NOLOCK) UD ON TH.CreatedBy = UD.User_ID AND th.taskid <> 4    
 join tbl_tsk_UserTaskMaster utm (NOLOCK) on th.TaskId=utm.ID  
 join tbl_tsk_TaskActionPermission (NOLOCK) usp on usp.task_type_id=utm.id  
 join tbl_tsk_CollaborationUserMapping (NOLOCK) clb ON th.Id=clb.TaskHistoryId   
 where th.id=@TaskHistoryId and (th.Assignedto=@Userid OR clb.User_Id=@Userid )and th.STATUS <> 'completed'  and usp.parent_id=@parentid
   
 UNION  
   
 Select @TaskHistoryId TaskHistoryId, iif (th.Assignedto=@Userid,1, ISNULL( usp.Has_viewLead,0)) Has_viewLead, iif (th.Assignedto=@Userid,1, ISNULL(usp.Has_editLead,0)) Has_editLead,  
  iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldviewLead,0)) Has_fieldviewLead,iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldeditLead,0)) Has_fieldeditLead  
 from   
 TBL_ET_PhysicalAppointment th (NOLOCK)  
 join tbl_tsk_TaskActionPermission (NOLOCK) usp on usp.task_type_id=th.TaskTypeId  
 left join TBL_ET_PhyAppointCollaboratorUserMapping (NOLOCK) clb ON th.PhysicalAppointmentId=clb.PhysicalAppointmentId   
 left join TBL_ET_PhyAppointUserMapping pur on pur.PhysicalAppointmentId= th.PhysicalAppointmentId  
 where th.PhysicalAppointmentId=@TaskHistoryId and pur.UserId = @Userid   and usp.parent_id=@parentid
  
 -- Add the SELECT statement with parameter references here  
 --SELECT 0 sas  
)  
GO

/****** Object:  UserDefinedFunction [dbo].[udf_tsk_GetCollaboratersLeadEditView1_test]    Script Date: 06-06-26 10:25:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 -- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   FUNCTION  [dbo].[udf_tsk_GetCollaboratersLeadEditView1_test]  
(   
 @TaskHistoryId bigint,@Userid bigint ,@parentid bigint  
)  
RETURNS TABLE   
AS  
	
RETURN   
(  
  
Select @TaskHistoryId TaskHistoryId, iif (th.Assignedto=@Userid,1, ISNULL( usp.Has_viewLead,0)) Has_viewLead, iif (th.Assignedto=@Userid,1, ISNULL(usp.Has_editLead,0)) Has_editLead,  
  iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldviewLead,0)) Has_fieldviewLead,iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldeditLead,0)) Has_fieldeditLead  
 from   
 tbl_tsk_TaskHistory th (NOLOCK)  
 JOIN User_Detail(NOLOCK) UD ON TH.CreatedBy = UD.User_ID AND th.taskid <> 4    
 join tbl_tsk_UserTaskMaster utm (NOLOCK) on th.TaskId=utm.ID  
 join tbl_tsk_TaskActionPermission (NOLOCK) usp on usp.task_type_id=utm.id  
 join tbl_tsk_CollaborationUserMapping (NOLOCK) clb ON th.Id=clb.TaskHistoryId   
 where th.id=@TaskHistoryId and (th.Assignedto=@Userid OR clb.User_Id=@Userid )and th.STATUS <> 'completed'  and usp.parent_id=@parentid
   
 UNION  
   
 Select @TaskHistoryId TaskHistoryId, iif (th.Assignedto=@Userid,1, ISNULL( usp.Has_viewLead,0)) Has_viewLead, iif (th.Assignedto=@Userid,1, ISNULL(usp.Has_editLead,0)) Has_editLead,  
  iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldviewLead,0)) Has_fieldviewLead,iif (th.Assignedto=@Userid,1,ISNULL(usp.Has_fieldeditLead,0)) Has_fieldeditLead  
 from   
 TBL_ET_PhysicalAppointment th (NOLOCK)  
 join tbl_tsk_TaskActionPermission (NOLOCK) usp on usp.task_type_id=th.TaskTypeId  
 left join TBL_ET_PhyAppointCollaboratorUserMapping (NOLOCK) clb ON th.PhysicalAppointmentId=clb.PhysicalAppointmentId   
 left join TBL_ET_PhyAppointUserMapping pur on pur.PhysicalAppointmentId= th.PhysicalAppointmentId  
 where th.PhysicalAppointmentId=@TaskHistoryId and pur.UserId = @Userid   and usp.parent_id=@parentid
  
 -- Add the SELECT statement with parameter references here  
 --SELECT 0 sas  
)  
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_tp_ExtractNoteField]    Script Date: 06-06-26 10:25:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Select * From dbo.ufn_tp_ExtractNoteField(11397,5,335,'Updated  TicketStatus ,TicketPriority ,TicketAgent','Updated ','')
CREATE   FUNCTION [dbo].[ufn_tp_ExtractNoteField]
(
    @TicketHistoryId BIGINT,
	@TicketId BIGINT,
	@ParentId BIGINT,
	@ActivityDescription nvarchar(max),
	@SearchText nvarchar(1000)='Updated ',
	@ReplacementText nvarchar(1000)=''
)
RETURNS TABLE
AS
RETURN
	-- declare @TicketHistoryId BIGINT=11397,@TicketId BIGINT=5,@ParentId BIGINT=335,@ActivityDescription nvarchar(max)='Updated  TicketStatus ,TicketPriority ,TicketAgent', @SearchText nvarchar(1000)='Updated ', @ReplacementText nvarchar(1000)=''
    SELECT @TicketHistoryId as TicketHistoryId, trim(Value) as FieldName, @TicketId as TicketId, @ParentId as ParentId,
	Case when trim(Value)='TicketStatus' then (Select top 1 TicketStatusId From tbl_tp_TicketHistory(nolock) Where TicketHistoryId<@TicketHistoryId and TicketId=@TicketId order by TicketHistoryId desc) 
		when trim(Value)='TicketPriority' then (Select top 1 TicketPriority From tbl_tp_TicketHistory(nolock) Where TicketHistoryId<@TicketHistoryId and TicketId=@TicketId order by TicketHistoryId desc)
		when trim(Value)='TicketAgent' then (Select top 1 AssignedUser From tbl_tp_TicketHistory(nolock) Where TicketHistoryId<@TicketHistoryId and TicketId=@TicketId order by TicketHistoryId desc) 
		when trim(Value)='TicketGroups' then (Select top 1 AssignedGroup From tbl_tp_TicketHistory(nolock) Where TicketHistoryId<@TicketHistoryId and TicketId=@TicketId order by TicketHistoryId desc) 
		End as OldValue,
	Case when trim(Value)='TicketStatus' then (Select top 1 TicketStatusId From tbl_tp_TicketHistory(nolock) Where TicketHistoryId=@TicketHistoryId) 
		when trim(Value)='TicketPriority' then (Select top 1 TicketPriority From tbl_tp_TicketHistory(nolock) Where TicketHistoryId=@TicketHistoryId)
		when trim(Value)='TicketAgent' then (Select top 1 AssignedUser From tbl_tp_TicketHistory(nolock) Where TicketHistoryId=@TicketHistoryId) 
		when trim(Value)='TicketGroups' then (Select top 1 AssignedGroup From tbl_tp_TicketHistory(nolock) Where TicketHistoryId=@TicketHistoryId) 
		End as NewValue		
    FROM dbo.fn_Split(replace(@ActivityDescription,@SearchText,@ReplacementText),',')

GO

/****** Object:  UserDefinedFunction [dbo].[use_Tbl_UA_ModuleMaster_ModuleCodeList]    Script Date: 06-06-26 10:25:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[use_Tbl_UA_ModuleMaster_ModuleCodeList]      
(
@UserId bigint
)
returns table       
as      
return(select ModuleCode from (
select tumm2.ModuleId, tumm2.ModuleCode from TBL_UA_ModuleMaster tumm2 where 
tumm2.ParentModuleId in (select tumm.ModuleId from TBL_UA_RolePermissionMappingMaster turp 
 inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode
 where turp.ModuleCode like 'Mod%' and turp.ParentId = @UserId)
Union All
select tumm3.ModuleId, tumm3.ModuleCode from TBL_UA_ModuleMaster tumm3 where 
tumm3.ParentModuleId in (
select tumm2.ModuleId from TBL_UA_ModuleMaster tumm2 where 
tumm2.ParentModuleId in (select tumm.ModuleId from TBL_UA_RolePermissionMappingMaster turp 
 inner join TBL_UA_ModuleMaster tumm on tumm.ModuleCode = turp.ModuleCode
 where turp.ModuleCode like 'Mod%' and turp.ParentId = @UserId))
 )t)


GO


