
/****** Object:  View [dbo].[View_GetCost]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE   VIEW [dbo].[View_GetCost]  
As  
select Sum(camrep.Cost) as Cost,  cam.CampAd_id,cam.User_ID from tblCampaign cam  
left join tblAdwordsCampaignPerformanceRep camrep on cam.CampAd_id=camrep.CampaignId  
 GROUP BY cam.CampAd_id,cam.User_ID WITH CUBE HAVING cam.CampAd_id IS NUll  
GO

/****** Object:  View [dbo].[View_AdwordsCalculate]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[View_AdwordsCalculate]
 As
select intd.Credit_ID,intd.Credits,intd.Debits,intd.Balance,intd.User_ID,intd.ID, gc.Cost from View_GetCost gc
left join IntCredit_Details intd on gc.User_ID=intd.User_ID

GO

/****** Object:  View [dbo].[VW_ShowLeadInfo]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_ShowLeadInfo]
as


Select  isnull(LeadImage,'') as LeadImage,Serv_User_Detail.ParentId,Serv_User_Detail.ser_user_id from userleads inner join Serv_User_Detail
on userleads.ParentId=Serv_User_Detail.ParentId
and (userleads.EmailID=Serv_User_Detail.Email or userleads.EmailID1=Serv_User_Detail.Email or userleads.EmailID2=Serv_User_Detail.Email)

GO

/****** Object:  View [dbo].[VW_Serv_TicketMaster]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_Serv_TicketMaster]                                  
 as                     
 SELECT Serv_TicketMaster.TicketID,Serv_TicketMaster.User_id,Serv_TicketMaster.ParentID,TicketNo,Requester,Subject,Description,               
 MAX(SERV_TICKETHISTORY.TICKETHISTORYID) TICKETHISTORYID,
 CASE                  
    WHEN Serv_TicketMaster.Status= 0 THEN -1                  
    ELSE Serv_TicketMaster.Status                  
END AS Status, Serv_TicketMaster.Remarks,Serv_TicketMaster.Note,Serv_TicketMaster.Date_Created,Serv_TicketMaster.Priority,Serv_TicketMaster.AssignTo,Serv_TicketMaster.Assign_Group,UserResponse,              
Serv_TicketMaster.Active,Serv_TicketMaster.Ticket_type,ARemindRSPNSSent,ARemindResolveSent,ARSPSent,A1RSLSent,A2RSLSent,A3RSLSent,A4RSLSent,agrp_unassigned,              
Serv_TicketMaster.Source,Product,Serv_TicketMaster.Company,EmailId,Serv_TicketMaster.domain,spam,deleted,skip_nticketmail,tkt_tag,resolved_dt,Assignedby,AssignedDateTime,update_date, Serv_Priority_Mast.Priority_Desc,Type_Desc,                        
 Serv_User_Detail.Name,                         
Serv_User_Detail.Email, Serv_User_Detail.Mobile,      
--isnull(REPLACE(image, '~/', '../../../'),'../../../UserProfile/defaultimage.png') as userimage,          
isnull(REPLACE(COALESCE(NULLIF (LeadImage, '') , '../../../UserProfile/defaultimage.png'), '~/', '../../../'),'../../../UserProfile/defaultimage.png') as LeadImage         
FROM Serv_TicketMaster 
INNER JOIN SERV_TICKETHISTORY ON Serv_TicketMaster.TICKETID = SERV_TICKETHISTORY.TICKETID
LEFT OUTER JOIN  Serv_Priority_Mast ON Serv_TicketMaster.Priority = Serv_Priority_Mast.Priority_ID                        
 LEFT OUTER JOIN Serv_TicketType_Mast on Serv_TicketMaster.Ticket_type=Serv_TicketType_Mast.Type_ID                        
 INNER JOIN Serv_User_Detail on Serv_User_Detail.ser_user_id = dbo.Serv_TicketMaster.Assignedby                          
  LEFT OUTER JOIN User_Detail on Serv_User_Detail.User_id_old=User_Detail.User_ID ---131          
  LEFT OUTER JOIN VW_ShowLeadInfo on Serv_TicketMaster.user_id=VW_ShowLeadInfo.ser_user_id      
  GROUP BY Serv_TicketMaster.TicketID,Serv_TicketMaster.User_id,Serv_TicketMaster.ParentID,TicketNo,Requester,Subject,Description,Serv_TicketMaster.Status,
  Serv_TicketMaster.Remarks,Serv_TicketMaster.Note,Serv_TicketMaster.Date_Created,Serv_TicketMaster.Priority,Serv_TicketMaster.AssignTo,Serv_TicketMaster.Assign_Group,UserResponse,              
Serv_TicketMaster.Active,Serv_TicketMaster.Ticket_type,ARemindRSPNSSent,ARemindResolveSent,ARSPSent,A1RSLSent,A2RSLSent,A3RSLSent,A4RSLSent,agrp_unassigned,              
Serv_TicketMaster.Source,Product,Serv_TicketMaster.Company,EmailId,Serv_TicketMaster.domain,spam,deleted,skip_nticketmail,tkt_tag,resolved_dt,Assignedby,AssignedDateTime,update_date, Serv_Priority_Mast.Priority_Desc,Type_Desc,                        
 Serv_User_Detail.Name, Serv_User_Detail.Email, Serv_User_Detail.Mobile,LeadImage

GO

/****** Object:  View [dbo].[credit_details_all]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[credit_details_all]
AS
select ID,Credit_ID,M_ID,FromUser_ID,User_ID,Debits,Credits,Balance,Validity,Default_Credit,FromDate,ToDate,DateCreated,DateUpdated,EmpUpdated,MachineName,LastModified,typecredit
,batchid,CreatedBy from credit_details
union
select ID,Credit_ID,M_ID,FromUser_ID,User_ID,Debits,Credits,Balance,Validity,Default_Credit,FromDate,ToDate,DateCreated,DateUpdated,EmpUpdated,MachineName,LastModified,typecredit
,batchid,CreatedBy from mysmsreport.dbo.credit_detailshistory 

GO

/****** Object:  View [dbo].[enquiry_score_history_latest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[enquiry_score_history_latest]
AS
SELECT 
    id, 
    parentid, 
    enquiryid, 
    rule_id, 
    ScoreAdded, 
    CurrentScore, 
    createdon, 
    enquiry_activity_id
    
FROM 
    dbo.enquiry_score_history AS e
WHERE 
    id = (SELECT MAX(id) AS Expr1 
          FROM dbo.enquiry_score_history 
          WHERE enquiryid = e.enquiryid)
GO

/****** Object:  View [dbo].[eV_UserLeads]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[eV_UserLeads]     
AS     
SELECT --TOP 10    
  UL.ID,     
  UL.LeadNo,     
  UL.PersonName,     
  UL.img_ext,     
  UL.CompanyName,     
  UL.CreatedOn as [LeadCreatedOn],     
  ISNULL(UL.CountryCode, '') AS CountryCode,     
  ISNULL(UL.MobileNo, '') AS MobileNo,     
  ISNULL(UL.Countrycode1, '') AS Countrycode1,     
  ISNULL(UL.Countrycode2, '') as Countrycode2,     
  ISNULL(UL.Mobileno1, '') AS MobileNo1,     
  ISNULL(UL.Mobileno2, '') AS MobileNo2,     
  ISNULL(UL.Emailid, '') AS Emailid,     
  ISNULL(UL.EmailID1, '') AS EmailID1,     
  ISNULL(UL.EmailID2, '') AS EmailID2,     
  UL.City,     
  UL.State,     
  UL.Country,     
  UL.PinCode,     
  UL.ResidentialAddress,     
  UL.OfficeAddress,     
  UL.AssignedTo,     
  USS.Name AS SourceName,     
  UMS.Name AS MediumName,     
  UCS.Name AS CampaignName,     
  UL.InitialRemarks,     
  UL.ParentID,     
  FUS.FollowupStatus,     
  UL.FollowupDate,    
  UL.NextStatusDate as [LeadNextStatusDate],    
  UL.Remarks AS [LeadRemarks],     
  ISNULL(UL.AmountPaid, 0) AS AmountPaid,     
  CONVERT( VARCHAR(10), UL.CreatedOn, 101) + STUFF(RIGHT(CONVERT(VARCHAR(26), UL.CreatedOn, 109), 15), 7, 7, ' ') AS FollowupCreatedDate,     
  UL.CreatedBy,     
  UL.ModifiedOn,     
  UL.ModifiedBy,     
  UD1.User_Login AS FollowupBy,     
  UD.User_Login AS assigneduser,     
  
  --( SELECT STUFF(( SELECT N', ' + ss.Name FROM ProductMaster(NOLOCK) AS ss      
  --INNER JOIN dbo.fn_Split(ul.Products, '#') AS fs ON ss.ProductID = fs.value FOR XML PATH(''),     
    --    TYPE ).value('text()[1]', 'nvarchar(max)'), 1, 2, N'' ) ) AS Products, 
  (select isnull((select STRING_AGG(isnull(ProductName,''),', ') from openjson(ul.productsJson)
	               with(ProductName nvarchar(max) '$.ProductName' )
			       where isnull(ul.productsJson,'') != '') , '') ) AS Products ,

  UL.LastFollowupCreatedOn,    
  UL.latitude AS [Latitude],    
  UL.longitude AS [Longitude],    
  UL.whereAddress AS [WhereAddress],    
  concat(UD.FName, '', UD.LName )  AS[AssignedToName],    
  UD.Mobile AS[AssignedToPhone],    
  UD.EMail  AS[AssignedToEmail]    
  FROM UserLeads AS UL(NOLOCK)     
  LEFT JOIN UserSourceSettings AS USS(NOLOCK) ON UL.SourceName = USS.SourceID     
  LEFT JOIN UserMediumSettings AS UMS(NOLOCK) ON UL.MediumName = UMS.MediumID     
  LEFT JOIN UserCampaignSettings AS UCS(NOLOCK) ON UL.CampaignName = UCS.CampaignID     
  LEFT JOIN User_Detail AS UD(NOLOCK) ON UL.AssignedTo = UD.User_ID     
  LEFT JOIN User_Detail AS UD1(NOLOCK) ON UL.CreatedBy = UD1.User_ID     
  LEFT JOIN FollowUp_Status AS FUS(NOLOCK) ON UL.FollowUpStatus = FUS.id    
 -- WHERE Ul.ParentId = 34594    
  
GO

/****** Object:  View [dbo].[eV_UserLeads_Temp]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[eV_UserLeads_Temp]     
AS     
SELECT --TOP 10    
  UL.ID,     
  UL.LeadNo,     
  UL.PersonName,     
  UL.img_ext,     
  UL.CompanyName,     
  UL.CreatedOn as [LeadCreatedOn],     
  ISNULL(UL.CountryCode, '') AS CountryCode,     
  ISNULL(UL.MobileNo, '') AS MobileNo,     
  ISNULL(UL.Countrycode1, '') AS Countrycode1,     
  ISNULL(UL.Countrycode2, '') as Countrycode2,     
  ISNULL(UL.Mobileno1, '') AS MobileNo1,     
  ISNULL(UL.Mobileno2, '') AS MobileNo2,     
  ISNULL(UL.Emailid, '') AS Emailid,     
  ISNULL(UL.EmailID1, '') AS EmailID1,     
  ISNULL(UL.EmailID2, '') AS EmailID2,     
  UL.City,     
  UL.State,     
  UL.Country,     
  UL.PinCode,     
  UL.ResidentialAddress,     
  UL.OfficeAddress,     
  UL.AssignedTo,     
  USS.Name AS SourceName,     
  UMS.Name AS MediumName,     
  UCS.Name AS CampaignName,     
  UL.InitialRemarks,     
  UL.ParentID,     
  FUS.FollowupStatus,     
  UL.FollowupDate,    
  UL.NextStatusDate as [LeadNextStatusDate],    
  UL.Remarks AS [LeadRemarks],     
  ISNULL(UL.AmountPaid, 0) AS AmountPaid,     
  CONVERT( VARCHAR(10), UL.CreatedOn, 101) + STUFF(RIGHT(CONVERT(VARCHAR(26), UL.CreatedOn, 109), 15), 7, 7, ' ') AS FollowupCreatedDate,     
  UL.CreatedBy,     
  UL.ModifiedOn,     
  UL.ModifiedBy,     
  UD1.User_Login AS FollowupBy,     
  UD.User_Login AS assigneduser,     
  
  --( SELECT STUFF(( SELECT N', ' + ss.Name FROM ProductMaster(NOLOCK) AS ss      
  --INNER JOIN dbo.fn_Split(ul.Products, '#') AS fs ON ss.ProductID = fs.value FOR XML PATH(''),     
    --    TYPE ).value('text()[1]', 'nvarchar(max)'), 1, 2, N'' ) ) AS Products, 
  (select isnull((select STRING_AGG(isnull(ProductName,''),', ') from openjson(ul.productsJson)
	               with(ProductName nvarchar(max) '$.ProductName' )
			       where isnull(ul.productsJson,'') != '') , '') ) AS Products ,

  UL.LastFollowupCreatedOn,    
  UL.latitude AS [Latitude],    
  UL.longitude AS [Longitude],    
  UL.whereAddress AS [WhereAddress],    
  concat(UD.FName, '', UD.LName )  AS[AssignedToName],    
  UD.Mobile AS[AssignedToPhone],    
  UD.EMail  AS[AssignedToEmail]    
  FROM UserLeads AS UL(NOLOCK)     
  LEFT JOIN UserSourceSettings AS USS(NOLOCK) ON UL.SourceName = USS.SourceID     
  LEFT JOIN UserMediumSettings AS UMS(NOLOCK) ON UL.MediumName = UMS.MediumID     
  LEFT JOIN UserCampaignSettings AS UCS(NOLOCK) ON UL.CampaignName = UCS.CampaignID     
  LEFT JOIN User_Detail AS UD(NOLOCK) ON UL.AssignedTo = UD.User_ID     
  LEFT JOIN User_Detail AS UD1(NOLOCK) ON UL.CreatedBy = UD1.User_ID     
  LEFT JOIN FollowUp_Status AS FUS(NOLOCK) ON UL.FollowUpStatus = FUS.id    
 -- WHERE Ul.ParentId = 34594    
  
GO

/****** Object:  View [dbo].[lead_score_history_latest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[lead_score_history_latest]
AS
SELECT     id, parentid, leadid, rule_id, ScoreAdded, CurrentScore, createdon, lead_activity_id
FROM        dbo.lead_score_history AS l
WHERE     (id =
                      (SELECT     MAX(id) AS Expr1
                       FROM        dbo.lead_score_history
                       WHERE     (leadid = l.leadid)))

GO

/****** Object:  View [dbo].[Leadinteractionhistory_latest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[Leadinteractionhistory_latest]
AS
SELECT ID, LeadNo, FollowUpStatus, NextStatusDate, Remarks, Products, AmountPaid, AssignedTo, ParentID, CreatedOn, CreatedBy, FollowupDate, IsReassign, IsAutoEntry,Id_Lead
FROM     dbo.LeadInteractionHistory AS l WITH (nolock)
WHERE  (ID =
                      (SELECT MAX(ID) AS Expr1
                       FROM      dbo.LeadInteractionHistory WITH (nolock)
                       WHERE   (LeadNo = l.LeadNo) AND (ParentID = l.ParentID)))

GO

/****** Object:  View [dbo].[Leadinteractionhistory_latest_leadid]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[Leadinteractionhistory_latest_leadid]
AS
SELECT ID, LeadNo, FollowUpStatus, NextStatusDate, Remarks, Products, AmountPaid, AssignedTo, ParentID, CreatedOn, CreatedBy, FollowupDate, IsReassign, IsAutoEntry,Id_Lead
FROM     dbo.LeadInteractionHistory AS l WITH (nolock)
WHERE  (ID =
                      (SELECT MAX(ID) AS Expr1
                       FROM      dbo.LeadInteractionHistory WITH (nolock)
                       WHERE   (Id_Lead = l.Id_Lead) /*AND (ParentID = l.ParentID)*/ ))

GO

/****** Object:  View [dbo].[LeadPipelineMapping_earliest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[LeadPipelineMapping_earliest]  
AS  
SELECT   distinct id, LeadID, PipelineID, PipeLineStage, Probability, Amount, Remarks, CreatedDate, CreatedBy, EstimatedClosureDate, DealOwner, IsDeleted, DeletedOn  
FROM            dbo.LeadPipelineMapping AS l WITH (nolock)  
WHERE        (ID =  
                             (SELECT      min(ID) AS Expr1  
                               FROM            dbo.LeadPipelineMapping  
                               WHERE    (LeadID = l.LeadID)
							        -- AND (PipelineID = l.PipelineID)
							   
							   ))  

GO

/****** Object:  View [dbo].[LeadPipelineMapping_latest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[LeadPipelineMapping_latest]        
AS  
SELECT   distinct l.ID, l.LeadID, l.PipelineID, l.PipeLineStage, l.Probability, l.Amount, l.Remarks, l.CreatedDate,   
l.CreatedBy, l.EstimatedClosureDate, l.DealOwner, l.IsDeleted, l.DeletedOn, l.LostId,l.LostRemark,T2.Reason        
FROM            dbo.LeadPipelineMapping  AS l WITH (nolock)       
left join PipelineStages_Reason T2 on T2.Id=l.LostID and T2.PipelineID=l.PipelineID  
WHERE        (l.ID =        
                             (SELECT      MAX(ID) AS Expr1        
                               FROM            dbo.LeadPipelineMapping        
                               WHERE    (LeadID = l.LeadID)      
               -- AND (PipelineID = l.PipelineID)      
                
          ))        



GO

/****** Object:  View [dbo].[LeadPipelineMapping_latest_PipelineGrouping]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[LeadPipelineMapping_latest_PipelineGrouping]      
AS      
SELECT   distinct id, LeadID, PipelineID, PipeLineStage, Probability, Amount, Remarks, CreatedDate, CreatedBy, EstimatedClosureDate, DealOwner, IsDeleted, DeletedOn, LostId      
FROM            dbo.LeadPipelineMapping AS l WITH (nolock)      
WHERE        (ID =      
                             (SELECT      MAX(ID) AS Expr1      
                               FROM            dbo.LeadPipelineMapping      
                               WHERE    (LeadID = l.LeadID)    
                                        AND (PipelineID = l.PipelineID)
										--And (PipeLineStage = l.PipeLineStage)
										     
              
                      ))      
		  
		           and isnull(IsDeleted,0) = 0 --leadID = 3132750


GO

/****** Object:  View [dbo].[Price_UserSubscriptionDetails_latest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[Price_UserSubscriptionDetails_latest]
AS
SELECT        UserID, PlanId, PlanStartDate, PlanEndDate, Cost, IsTrailPlan, IsNewPlan, IsKYCRequired, id, created_date
FROM            dbo.Price_UserSubscriptionDetails AS p WITH (nolock)
WHERE        (id =
                             (SELECT        MAX(id) AS Expr1
                               FROM            dbo.Price_UserSubscriptionDetails WITH (nolock)
                               WHERE        (UserID = p.UserID)))

GO

/****** Object:  View [dbo].[Userenquiry_Mobile_Email]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[Userenquiry_Mobile_Email]
AS
SELECT        enquiryid, isnull(CountryCode, '0') CountryCode, isnull(NULLIF (mobileno, ''), '0') Mobile, '1' AS email, Parentid
FROM            Userenquiry(nolock)
WHERE        ISNULL(MobileNo, '') <> ''
UNION
SELECT        enquiryid, isnull(CountryCode1, '0'), isnull(NULLIF (mobileno1, ''), '0'), '1', Parentid
FROM            Userenquiry(nolock)
WHERE        isnull(MobileNo1, '') <> ''
UNION
SELECT        enquiryid, isnull(CountryCode2, '0'), isnull(NULLIF (mobileno2, ''), '0'), '1', Parentid
FROM            Userenquiry(nolock)
WHERE        isnull(MobileNo2, '') <> ''
UNION
SELECT        enquiryid, '0', '0', isnull(NULLIF (emailid, ''), '1'), Parentid
FROM            Userenquiry(nolock)
WHERE        isnull(emailid, '') <> ''
UNION
SELECT        enquiryid, '0', '0', isnull(NULLIF (emailid1, ''), '1'), Parentid
FROM            Userenquiry(nolock)
WHERE        isnull(emailid1, '') <> ''
UNION
SELECT        enquiryid, '0', '0', isnull(NULLIF (emailid2, ''), '1'), Parentid
FROM            Userenquiry(nolock)
WHERE        isnull(emailid2, '') <> ''      

GO

/****** Object:  View [dbo].[Userleads_Mobile_Email]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[Userleads_Mobile_Email]
AS
SELECT id as ulme_id, leadno, isnull(CountryCode, '0') CountryCode, isnull(NULLIF (mobileno, ''), '0') Mobile, '1' AS email, Parentid, createdon AS leadcreateddate, enquirysource AS sourceofenquiry

FROM            UserLeads(nolock)
WHERE        ISNULL(MobileNo, '') <> ''
UNION
SELECT id as ulme_id, leadno, isnull(CountryCode1, '0'), isnull(NULLIF (mobileno1, ''), '0'), '1', Parentid, createdon AS leadcreateddate, enquirysource AS sourceofenquiry

FROM            UserLeads(nolock)
WHERE        isnull(MobileNo1, '') <> ''
UNION
SELECT id as ulme_id, leadno, isnull(CountryCode2, '0'), isnull(NULLIF (mobileno2, ''), '0'), '1', Parentid, createdon AS leadcreateddate, enquirysource AS sourceofenquiry

FROM            UserLeads(nolock)
WHERE        isnull(MobileNo2, '') <> ''
UNION
SELECT id as ulme_id, leadno, '0', '0', isnull(NULLIF (emailid, ''), '1'), Parentid, createdon AS leadcreateddate, enquirysource AS sourceofenquiry

FROM            UserLeads(nolock)
WHERE        isnull(emailid, '') <> ''
UNION
SELECT id as ulme_id, leadno, '0', '0', isnull(NULLIF (emailid1, ''), '1'), Parentid, createdon AS leadcreateddate, enquirysource AS sourceofenquiry

FROM            UserLeads(nolock)
WHERE        isnull(emailid1, '') <> ''
UNION
SELECT id as ulme_id, leadno, '0', '0', isnull(NULLIF (emailid2, ''), '1'), Parentid, createdon AS leadcreateddate, enquirysource AS sourceofenquiry

FROM            UserLeads(nolock)
WHERE        isnull(emailid2, '') <> ''

GO

/****** Object:  View [dbo].[Usermailsview]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[Usermailsview] as select top 10 * from UserMails where UserID=27741 order by ID desc
GO

/****** Object:  View [dbo].[V_BatchMail]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[V_BatchMail]
AS
SELECT	BE.BatchID, BE.UserID, BE.SenderName as FromAddr, BE.Message, BE.TotalRecords, BE.TotalProcessed, BE.IsProcess, BE.Priority_Level,
		BE.BatchInsertTime, BE.BatchProcessTime, BE.ScheduledDate, BE.ScheduledTime, BE.IsScheduled, BE.Email_Subject, BE.ReplyTo,
		BE.mail_source, isnull(CE.Email_Id,TDCE.Email_Id) as Email_Id, CE.SentDateTime, CE.Status
FROM	BatchEmail_Infos AS BE WITH (nolock) LEFT JOIN ClientEmails AS CE WITH (nolock) 
ON		BE.BatchID = CE.BatchID LEFT JOIN ThirtyDaysClientEmails(nolock) TDCE
ON		BE.BatchID = TDCE.BatchID
--WHERE   (BE.BatchID IN (75413735, 75448055, 75448036))


GO

/****** Object:  View [dbo].[V_CliclktocallWebHookCount]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_CliclktocallWebHookCount] AS
SELECT
    requestid,
    COUNT(*) AS sentrequest_count
FROM
    tbl_VOIP_History_CallDetails
GROUP BY
    requestid;

GO

/****** Object:  View [dbo].[V_customfieldLeadvalue]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_customfieldLeadvalue]
as
Select recordID,LeadID,EnquiryID,fieldID,cast(fieldvalue as nvarchar(max)) as fieldvalue,CreatedDate
From customfieldLeadvalue(nolock)

GO

/****** Object:  View [dbo].[v_dc_UserEnquiry]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_dc_UserEnquiry]
as
select 
 'Enquiry' as [EntityName], ue.EnquiryID as EntityId, ue.PersonName, ue.CompanyName, ue.MobileNo, ue.MobileNo1, ue.MobileNo2, ue.EmailID, ue.EmailID1, ue.EmailID2, ue.City, ue.State, ue.Country, ue.CountryCode, ue.CountryCode1, ue.CountryCode2, ue.PinCode, ue.ResidentialAddress, ue.OfficeAddress, ss.Name as [SourceName], ms.Name as [MediumName], cm.Name as [CampaignName], ue.InitialRemarks, ue.ParentID, 
 isnull(Format(ue.CreatedDate,'dd-MMM-yyyy hh:mm:ss'),'') as CreatedDate,  isnull(Format(ue.CreatedDate,'dd-MMM-yyyy hh:mm:ss'),'') as [CreatedOn], cr.User_Login as [CreatedBy], ue.IsOpen, ue.LeadNo, ue.latitude, ue.longitude, cast(0 as decimal(18,2)) as 'AmountPaid', '' as [AssignedTo], '' as FollowupDate, '' as FollowUpStatus,  '' as LastFollowupCreatedBy, '' as LastFollowupCreatedOn, '' as ModifiedBy, '' as ModifiedOn, '' as NextStatusDate, '' as Remarks
 
from UserEnquiry(nolock) ue
	left join UserSourceSettings(nolock) ss on ue.SourceName = ss.SourceID
	left join UserCampaignSettings(nolock) cm on ue.CampaignName = cm.CampaignID
	left join UserMediumSettings(nolock) ms on ue.MediumName = ms.MediumID
	left join User_Detail(nolock) cr on ue.CreatedBy = cr.User_ID

GO

/****** Object:  View [dbo].[v_dc_UserLead]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE   VIEW [dbo].[v_dc_UserLead]
as
select 
 'Lead' as [EntityName], ul.ID as EntityId, ul.PersonName, ul.CompanyName, ul.MobileNo, ul.MobileNo1, ul.MobileNo2, ul.EmailID, ul.EmailID1, ul.EmailID2, ul.City, ul.State, ul.Country, ul.CountryCode, ul.CountryCode1, ul.CountryCode2, ul.PinCode, ul.ResidentialAddress, ul.OfficeAddress, ss.Name as [SourceName], ms.Name as [MediumName], cm.Name as [CampaignName], ul.InitialRemarks, ul.ParentID,
 isnull(Format(ul.CreatedOn,'dd-MMM-yyyy hh:mm:ss'),'') as  [CreatedDate],   isnull(Format(ul.CreatedOn,'dd-MMM-yyyy hh:mm:ss'),'') as  CreatedOn, cr.User_Login as [CreatedBy],  0 as [IsOpen], ul.LeadNo, ul.latitude, ul.longitude, ul.AmountPaid, ar.User_Login as [AssignedTo], isnull(Format(ul.FollowupDate,'dd-MMM-yyyy hh:mm:ss'),'') as FollowupDate, isnull(fs.FollowUpStatus,'') as FollowUpStatus, concat(lc.FName,' ', lc.LName) as LastFollowupCreatedBy, isnull(Format(ul.LastFollowupCreatedOn,'dd-MMM-yyyy hh:mm:ss'),'') as LastFollowupCreatedOn, ul.ModifiedBy, isnull(Format(ul.ModifiedOn,'dd-MMM-yyyy hh:mm:ss'),'') as ModifiedOn, ul.NextStatusDate, ul.Remarks
 
from UserLeads(nolock) ul
	left join UserSourceSettings(nolock) ss on ul.SourceName = ss.SourceID
	left join UserCampaignSettings(nolock) cm on ul.CampaignName = cm.CampaignID
	left join UserMediumSettings(nolock) ms on ul.MediumName = ms.MediumID
	left join User_Detail(nolock) cr on ul.CreatedBy = cr.User_ID
	left join User_Detail(nolock) ar on ul.CreatedBy = ar.User_ID
	left join User_Detail(nolock) lc on ul.LastFollowupCreatedBy = lc.User_ID
	left join FollowUp_Status(nolock) fs on fs.ID=ul.FollowUpStatus


GO

/****** Object:  View [dbo].[v_FacebookLeadgenSummary]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_FacebookLeadgenSummary]
as
WITH LastRowCTE AS
(
    SELECT 
        FbFormId,
        isProcessed,
        RecordCount,
        ROW_NUMBER() OVER(PARTITION BY FbFormId ORDER BY CreatedOn DESC) AS rn
    FROM 
        tbl_fb_FacebookLeadgenRequest (NOLOCK)
)
SELECT 
    F.FbFormId, 
    COUNT(F.FbFormId) AS [RequestCount], 
    SUM(F.RecordCount) AS [TotalFetchRecord], 
    LR.isProcessed AS [LastIsProcessed], 
    LR.RecordCount AS [LastRecordCount]
FROM 
    tbl_fb_FacebookLeadgenRequest F (NOLOCK)
    INNER JOIN LastRowCTE LR ON F.FbFormId = LR.FbFormId AND LR.rn = 1
GROUP BY 
    F.FbFormId, 
    LR.isProcessed, 
    LR.RecordCount;


GO

/****** Object:  View [dbo].[v_GetAppointmentForDaySchedule]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[v_GetAppointmentForDaySchedule]
as
select PhysicalAppointmentId, AssignedTo as UserId
	from  TBL_ET_PhysicalAppointment(nolock) where AssignedTo = 43973
		and CAST(StartDate as date) = CAST(N'28-Apr-2024 20:37' as date)
union
select pa.PhysicalAppointmentId, um.UserId as UserId 
	from  TBL_ET_PhysicalAppointment(nolock) pa 
		inner join TBL_ET_PhyAppointCollaboratorUserMapping(nolock) um on pa.PhysicalAppointmentId = um.PhysicalAppointmentId
union
select pa.PhysicalAppointmentId, um.UserId as UserId 
	from  TBL_ET_PhysicalAppointment(nolock) pa 
		inner join TBL_ET_PhyAppointCollaboratorUserMapping(nolock) um on pa.PhysicalAppointmentId = um.PhysicalAppointmentId

GO

/****** Object:  View [dbo].[V_IMSSchedule]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Dependency of this V_IMSSchedule


--1.MySMSConversations.dbo.conversations       -- called by clr
--2 MySMSConversations.dbo.channeltokens      -- called by clr
--3. MySMSConversations.dbo.tbl_ims_schedule_message  -- called by clr
--4. MySMSConversations.dbo.channels  -- called by clr
--5. MySMSConversations.dbo.convtemplates  -- called by clr




-------------------------------------



CREATE   VIEW [dbo].[V_IMSSchedule]
AS
SELECT ISM.id, ISM.createdby, ActivityObjectCreatedOn=isnull(ISM.CreatedDate,ISM.scheduledon), CONV.bodytext, 
SubBodyText=left(CONV.bodytext,30), CONV.messagetype, CH.Channelname, COVT.templatetype, COVT.templatename, COVT.templatebody
FROM [10.0.0.135].MySMSConversations.dbo.tbl_ims_schedule_message AS ISM WITH (nolock) INNER JOIN [10.0.0.135].MySMSConversations.dbo.conversations AS CONV WITH (nolock) 
ON ISM.wa_message_id = CONV.messageid INNER JOIN [10.0.0.135].MySMSConversations.dbo.channeltokens AS CT WITH (nolock) 
ON ISM.channeltokenid = CT.id INNER JOIN [10.0.0.135].MySMSConversations.dbo.channels AS CH WITH (nolock) 
ON ISM.channelid = CH.id LEFT OUTER JOIN [10.0.0.135].MySMSConversations.dbo.convtemplates AS COVT WITH (nolock) 
ON CONV.templateid = COVT.id


GO

/****** Object:  View [dbo].[V_LastFollowup]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_LastFollowup]
AS
	Select * 
	From
	(
		Select ROW_NUMBER()over(partition by parentID,leadno order by Id desc) Sno,*
		From leadinteractionhistory(nolock)
	)T
	Where T.Sno=1


GO

/****** Object:  View [dbo].[v_LastLeadEvent]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_LastLeadEvent]
AS
Select *
From
(
	Select ROW_NUMBER()over(partition by LeadId order by HistoryId desc) SNo,* 
	from tbl_LeadEventHistory(nolock)
)V
Where V.SNo=1

GO

/****** Object:  View [dbo].[v_LastRealTimeLocation]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_LastRealTimeLocation]
AS
	select ID,UserID,DeviceID,Longitude,Latitude,MeaningfulAddress,Reason,CreatedDate
	From
	(
		select ROW_NUMBER()over(partition by UserId order by CreatedDate desc) as SNo, *
		From Realtimelocation(nolock)
		Where isnull(MeaningfulAddress,'') !='' and MeaningfulAddress != 'Object reference not set to an instance of an object.'
	) B
	Where B.SNo=1

GO

/****** Object:  View [dbo].[v_LatestKit19Webhook]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_LatestKit19Webhook]
as
select w.UniqueIdentity, w.UqSNO from ( 
	select UniqueIdentity, ROW_NUMBER() over(partition by UniqueIdentity order by id desc) [UqSNO] 
	from tbl_voip_Kit19Webhooks(nolock)
) w where w.UqSNO = 1

GO

/****** Object:  View [dbo].[V_LeadInteractionHistory]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_LeadInteractionHistory]      
AS      
  Select LIH.*,FUS.FollowupStatus as FollowupStatusName, isnull(UDA.User_Login,'') as UserAssignTo, isnull(UDC.User_Login,'') as UserCreatedBy, isnull((SELECT STUFF((SELECT N', ' + ss.Name FROM ProductMaster(NOLOCK) AS ss INNER JOIN dbo.fn_Split(LIH.Products, '#') AS fs ON ss.ProductID = fs.value FOR XML PATH(''), TYPE).value('text()[1]', 'nvarchar(max)'), 1, 2, N'')),'') AS ProductsName      
  From leadinteractionhistory(nolock) LIH left join FollowUp_Status(nolock) FUS    
  On LIH.FollowUpStatus=FUS.ID left join User_Detail(nolock) UDA    
  On LIH.AssignedTo=UDA.User_ID  left join User_Detail(nolock) UDC    
  ON LIH.CreatedBy=UDC.User_ID
GO

/****** Object:  View [dbo].[V_LeadsbyParent]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[V_LeadsbyParent]
AS
select ROW_NUMBER()over(partition by ParentID order by ParentID) Sno,* from UserLeads(nolock)

GO

/****** Object:  View [dbo].[V_PhysicalAppointmentCount]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[V_PhysicalAppointmentCount]
AS
		select p.UserId, p.PhyDate, count(*) as TotalPhy ,
			sum( case when isnull(p.Status, '') = 'completed' then 1 else 0 end) as [PhyCompleted]
		from ( 
		select pa.PhysicalAppointmentId, cast(pa.StartDate as date) [PhyDate], Status, pa.AssignedTo as UserId  from TBL_ET_PhysicalAppointment(nolock) pa
			where isnull(pa.AssignedTo, 0) > 0
		union 
		select pa.PhysicalAppointmentId, cast(pa.StartDate as date) [PhyDate], Status, pac.UserId  from TBL_ET_PhysicalAppointment(nolock) pa
			inner join TBL_ET_PhyAppointCollaboratorUserMapping(nolock) pac on pa.PhysicalAppointmentId = pac.PhysicalAppointmentId
				where isnull(pac.UserId, 0) > 0
		union
		select pa.PhysicalAppointmentId, cast(pa.StartDate as date) [PhyDate], Status, paf.UserId  from TBL_ET_PhysicalAppointment(nolock) pa	
			inner join TBL_ET_PhyAppointUserMapping(nolock) paf on pa.PhysicalAppointmentId = paf.PhysicalAppointmentId
				where isnull(paf.UserId, 0) > 0
		) p group by UserId, PhyDate

GO

/****** Object:  View [dbo].[V_PipelineMapping]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_PipelineMapping]
As
SELECT	LPM.ID, LPM.LeadID, LPM.PipelineID, LPM.PipeLineStage, LPM.Probability, LPM.Amount, LPM.Remarks,
		LPM.CreatedDate, LPM.CreatedBy, LPM.EstimatedClosureDate, LPM.DealOwner, LPM.IsDeleted, LPM.DeletedOn,
		PM.Name as PipelineName, PM.DealExpiry, PM.IsDefault, PS.Name AS StageName, PS.Sequence, PS.IsEditable
FROM	LeadPipelineMapping AS LPM WITH (nolock) INNER JOIN Pipeline_Master AS PM WITH (nolock) 
ON		LPM.PipelineID = PM.ID INNER JOIN PipelineStages AS PS WITH (nolock) 
ON		LPM.PipeLineStage = PS.ID

GO

/****** Object:  View [dbo].[V_sm_Serv_TicketHistory]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[V_sm_Serv_TicketHistory]
As
	Select *
	From
	(
		select Row_number()over(partition by TicketID order by TicketHistoryID desc) as Sno,* 
		from Serv_TicketHistory
	)T
	Where T.Sno=1

GO

/****** Object:  View [dbo].[V_sm_Serv_User_Domain]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[V_sm_Serv_User_Domain]
AS
	select	Id, ParentId, VDomain_Name, virtual_domain, 
			VDomain=Left(virtual_domain, iif(dbo.CHARINDEX2('/',virtual_domain,3)>0,dbo.CHARINDEX2('/',virtual_domain,3)-1,0)), 
			VDomainPath=SUBSTRING(virtual_domain, dbo.CHARINDEX2('/',virtual_domain,3),len(virtual_domain)), 
			VEmailID_Name, virtual_mail, link_Account, SMS_Link_Account, virtual_sms 
	from	serv_user_domain(nolock)

GO

/****** Object:  View [dbo].[V_TaskAppointment]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_TaskAppointment]
AS
(
SELECT     TH.Id, TH.Title, TH.Description, TH.Address, TH.StartDate, TH.EndDate, TH.LeadId, TH.AssignedTo, TH.IsActive, TH.CreatedOn, TH.TaskId, TH.CreatedBy, TH.OutcomesId, TH.Status, TH.IsTask, TH.IsAppointment, TH.TaskType, TH.CompletedOn, TH.CompleteAddress, TH.Latitude, 
                  TH.Longitude, TH.SmsBatchId, TH.EmailBatchId, TH.UpdatedOn, TH.Remarks, TH.gCalendarId, TH.task_deletedOn, OutcomeName=isnull(OM.OutcomeName,''), OM.ParentId, OM.IsDeleted, OM.IsPredefined, OM.Indent
FROM        tbl_tsk_TaskHistory AS TH WITH (NOLOCK) LEFT OUTER JOIN
                  tbl_tsk_UserOutcomeMaster AS OM WITH (NOLOCK) ON TH.OutcomesId = OM.Id
)

GO

/****** Object:  View [dbo].[V_TBL_ET_Attendance]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_TBL_ET_Attendance]
AS
select * From
(
select ROW_NUMBER()over(partition by userId,cast(AttendanceIn as date) order by AttendanceId) as Sno,* 
from TBL_ET_Attendance(nolock)
) T
Where T.Sno=1

GO

/****** Object:  View [dbo].[v_tbl_et_GetUserBreakSummary]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[v_tbl_et_GetUserBreakSummary] 
as
SELECT 
    UserId,
    YEAR(StartDate) AS Year,
    MONTH(StartDate) AS Month,
    COUNT(*) AS TotalBreaks,
    SUM(datEDIFF(SECOND, StartDate, EndDate)) / 3600 AS TotalBreakHours
FROM 
    TBL_ET_BreakTransaction
GROUP BY 
    UserId, YEAR(StartDate), MONTH(StartDate);

GO

/****** Object:  View [dbo].[v_tbl_et_GetUserTotalDistanceAndHours]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[v_tbl_et_GetUserTotalDistanceAndHours]  
as  
WITH AllLocationTracking AS (  
    SELECT UserId, MovementCode, LocationDateTime, Latitude, Longitude, Distance  
    FROM TBL_ET_UserLocationTracking (nolock) --where UserId = 46002 and cast(LocationDateTime as date) between '01-Aug-2024' and '31-Aug-2024'
    UNION ALL  
    SELECT UserId, MovementCode, LocationDateTime, Latitude, Longitude, Distance  
    FROM TBL_ET_UserLocationTracking_Archived (nolock) --where UserId = 46002 and cast(LocationDateTime as date) between '01-Aug-2024' and '31-Aug-2024'
),  
SignIns AS (  
    SELECT   
        UserId,  
        MIN(CASE WHEN MovementCode = 'SIGN_IN' THEN LocationDateTime END) AS sign_in,  
        MAX(CASE WHEN MovementCode = 'SIGN_OUT' THEN LocationDateTime END) AS sign_out  
    FROM   
        AllLocationTracking  
    GROUP BY   
        UserId, CONVERT(date, LocationDateTime)  
),  
DistanceCalculation AS (  
    SELECT   
        s.UserId,  
        s.sign_in,  
        s.sign_out,  
        (TRY_CONVERT(decimal(18, 3), curr.Distance) - TRY_CONVERT(decimal(18, 3), prev.Distance)) AS distance  
    FROM   
        SignIns s  
    JOIN   
        AllLocationTracking curr ON s.UserId = curr.UserId AND curr.LocationDateTime = s.sign_out  
    JOIN   
        AllLocationTracking prev ON s.UserId = prev.UserId AND prev.LocationDateTime = s.sign_in  
    WHERE   
        s.sign_out IS NOT NULL  
)  
SELECT   
    UserId,  
    MONTH(sign_in) AS month,  
    YEAR(sign_in) AS year,  
    SUM(distance) AS total_travel_distance,  
    --CONCAT(  
    --    isnull(CAST(SUM(DATEDIFF(MINUTE, sign_in, sign_out) / 60) AS VARCHAR), '00'),
    --    ':',   
    --    isnull(CAST((SUM(DATEDIFF(MINUTE, sign_in, sign_out) % 60) / 60) AS VARCHAR), '00'),  
    --    ' Hrs'  
    --) AS total_hours  
	SUM(DATEDIFF(SECOND, sign_in, sign_out)) calcSec,
	concat(dbo.ConvertSecondsToHHmm(isnull(SUM(DATEDIFF(SECOND, sign_in, sign_out)), 0)), ' Hrs' ) as total_hours  
FROM   
    DistanceCalculation  
GROUP BY   
    MONTH(sign_in), YEAR(sign_in), UserId;  

GO

/****** Object:  View [dbo].[v_tbl_et_UserAppointmentSummary]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_tbl_et_UserAppointmentSummary] AS
SELECT 
    UserId,
    YEAR(CheckIn) AS Year,
    MONTH(CheckIn) AS Month,
    COUNT(PhysicalAppointmentId) AS TotalAppointments,
    SUM(DATEDIFF(SECOND, CheckIn, CheckOut)) / 3600.0 AS TotalHoursSpent
FROM 
    TBL_ET_GeoEntityCheckInOut
GROUP BY 
    UserId, YEAR(CheckIn), MONTH(CheckIn);

GO

/****** Object:  View [dbo].[V_TBL_ET_UserLocationGpsHistory]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_TBL_ET_UserLocationGpsHistory]
as
select id, UserLocationTrackingId, MovementCode, CreatedOn, UserId, ParentId from ( 
	select id, UserLocationTrackingId, MovementCode, CreatedOn, UserId, ParentId,
		ROW_NUMBER() OVER (partition by cast(CreatedOn as date), UserId order by CreatedOn desc) as   rno
		from TBL_ET_UserLocationGpsHistory(nolock)
	) t where t.rno = 1

GO

/****** Object:  View [dbo].[V_TBL_ET_UserLocationTracking]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_TBL_ET_UserLocationTracking]
AS
select UserLocationTrackingId, MovementCode, Remarks, UserId, LocationDateTime, Latitude, Longitude, Address, BatteryPerc,
		NetworkPerc, CreatedDate, CreatedBy, IsActive, IsMock, IsBulk, Speed, Distance, LocationMetaData, IsDistanceCalc From
(
	select ROW_NUMBER()over(partition by userId,cast(LocationDateTime as date) order by UserLocationTrackingId) as Sno,
		UserLocationTrackingId, MovementCode, Remarks, UserId, LocationDateTime, Latitude, Longitude, Address, BatteryPerc,
		NetworkPerc, CreatedDate, CreatedBy, IsActive, IsMock, IsBulk, Speed, Distance, LocationMetaData, IsDistanceCalc
	from TBL_ET_UserLocationTracking(nolock)
	union
	select ROW_NUMBER()over(partition by userId,cast(LocationDateTime as date) order by UserLocationTrackingId) as Sno,
		UserLocationTrackingId, MovementCode, Remarks, UserId, LocationDateTime, Latitude, Longitude, Address, BatteryPerc,
		NetworkPerc, CreatedDate, CreatedBy, IsActive, IsMock, IsBulk, Speed, Distance, LocationMetaData, IsDistanceCalc
	FROM TBL_ET_UserLocationTracking_Archived WITH (NOLOCK)
) T
where T.Sno=1

GO

/****** Object:  View [dbo].[V_TBL_ET_UserLocationTrackingDesc]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_TBL_ET_UserLocationTrackingDesc]  
as
select UserLocationTrackingId, MovementCode, Remarks, UserId, LocationDateTime, Latitude, Longitude, Address, BatteryPerc,
		NetworkPerc, CreatedDate, CreatedBy, IsActive, IsMock, IsBulk, Speed, Distance, LocationMetaData, IsDistanceCalc From
(
	select ROW_NUMBER()over(partition by userId,cast(LocationDateTime as date) order by LocationDateTime desc) as Sno,
		UserLocationTrackingId, MovementCode, Remarks, UserId, LocationDateTime, Latitude, Longitude, Address, BatteryPerc,
		NetworkPerc, CreatedDate, CreatedBy, IsActive, IsMock, IsBulk, Speed, Distance, LocationMetaData, IsDistanceCalc
	from TBL_ET_UserLocationTracking(nolock)
	union
	select ROW_NUMBER()over(partition by userId,cast(LocationDateTime as date) order by LocationDateTime desc) as Sno,
		UserLocationTrackingId, MovementCode, Remarks, UserId, LocationDateTime, Latitude, Longitude, Address, BatteryPerc,
		NetworkPerc, CreatedDate, CreatedBy, IsActive, IsMock, IsBulk, Speed, Distance, LocationMetaData, IsDistanceCalc
	FROM TBL_ET_UserLocationTracking_Archived WITH (NOLOCK)
) T
where T.Sno=1

GO

/****** Object:  View [dbo].[v_ul]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[v_ul]
AS
SELECT 
  UL.ID, 
  UL.LeadNo, 
  UL.PersonName, 
  UL.img_ext, 
  UL.CompanyName, 
  UL.CreatedOn as [LeadCreatedOn], 
  ISNULL(UL.CountryCode, '') AS CountryCode, 
  ISNULL(UL.MobileNo, '') AS MobileNo, 
  ISNULL(UL.Countrycode1, '') AS Countrycode1, 
  ISNULL(UL.Countrycode2, '') as Countrycode2, 
  ISNULL(UL.Mobileno1, '') AS MobileNo1, 
  ISNULL(UL.Mobileno2, '') AS MobileNo2, 
  ISNULL(UL.Emailid, '') AS Emailid, 
  ISNULL(UL.EmailID1, '') AS EmailID1, 
  ISNULL(UL.EmailID2, '') AS EmailID2, 
  UL.City, 
  UL.State, 
  UL.Country, 
  UL.PinCode, 
  UL.ResidentialAddress, 
  UL.OfficeAddress, 
  UL.AssignedTo, 
  USS.Name AS SourceName, 
  UMS.Name AS MediumName, 
  UCS.Name AS CampaignName, 
  UL.InitialRemarks, 
  UL.ParentID, 
  FUS.FollowupStatus, 
  UL.FollowupDate,
  UL.NextStatusDate as [LeadNextStatusDate],
  UL.Remarks AS [LeadRemarks], 
  ISNULL(UL.AmountPaid, 0) AS AmountPaid, 
  CONVERT(VARCHAR(10), UL.CreatedOn, 101) + STUFF(RIGHT(CONVERT(VARCHAR(26), UL.CreatedOn, 109), 15), 7, 7, ' ') AS FollowupCreatedDate, 
  UL.CreatedBy, 
  UL.ModifiedOn, 
  UL.ModifiedBy, 
  UD1.User_Login AS FollowupBy, 
  UD.User_Login AS assigneduser, 
  STRING_AGG(j.ProductName, ', ')  AS Products,
  UL.LastFollowupCreatedOn,
  UL.latitude AS [Latitude],
  UL.longitude AS [Longitude],
  UL.whereAddress AS [WhereAddress],
  CONCAT(UD.FName, '', UD.LName) AS [AssignedToName],
  UD.Mobile AS [AssignedToPhone],
  UD.EMail AS [AssignedToEmail]
FROM 
  UserLeads AS UL (NOLOCK) 
  LEFT JOIN UserSourceSettings AS USS (NOLOCK) ON UL.SourceName = USS.SourceID 
  LEFT JOIN UserMediumSettings AS UMS (NOLOCK) ON UL.MediumName = UMS.MediumID 
  LEFT JOIN UserCampaignSettings AS UCS (NOLOCK) ON UL.CampaignName = UCS.CampaignID 
  LEFT JOIN User_Detail AS UD (NOLOCK) ON UL.AssignedTo = UD.User_ID 
  LEFT JOIN User_Detail AS UD1 (NOLOCK) ON UL.CreatedBy = UD1.User_ID 
  LEFT JOIN FollowUp_Status AS FUS (NOLOCK) ON UL.FollowUpStatus = FUS.id
  outer APPLY OPENJSON(ISNULL(nullif(UL.ProductsJson,''), '[]')) WITH (ProductName NVARCHAR(MAX) '$.ProductName') AS j
  --where ul.parentid=34594
GROUP BY 
  UL.ID, 
  UL.LeadNo, 
  UL.PersonName, 
  UL.img_ext, 
  UL.CompanyName, 
  UL.CreatedOn, 
  UL.CountryCode, 
  UL.MobileNo, 
  UL.Countrycode1, 
  UL.Countrycode2, 
  UL.Mobileno1, 
  UL.Mobileno2, 
  UL.Emailid, 
  UL.EmailID1, 
  UL.EmailID2, 
  UL.City, 
  UL.State, 
  UL.Country, 
  UL.PinCode, 
  UL.ResidentialAddress, 
  UL.OfficeAddress, 
  UL.AssignedTo, 
  USS.Name, 
  UMS.Name, 
  UCS.Name, 
  UL.InitialRemarks, 
  UL.ParentID, 
  FUS.FollowupStatus, 
  UL.FollowupDate, 
  UL.NextStatusDate, 
  UL.Remarks, 
  UL.AmountPaid, 
  CONVERT(VARCHAR(10), UL.CreatedOn, 101) + STUFF(RIGHT(CONVERT(VARCHAR(26), UL.CreatedOn, 109), 15), 7, 7, ' '), 
  UL.CreatedBy, 
  UL.ModifiedOn, 
  UL.ModifiedBy, 
  UD1.User_Login, 
  UD.User_Login, 
  UL.LastFollowupCreatedOn,
  UL.latitude, 
  UL.longitude, 
  UL.whereAddress,
  CONCAT(UD.FName, '', UD.LName),
  UD.Mobile,
  UD.EMail


GO

/****** Object:  View [dbo].[V_UserEnquiry]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[V_UserEnquiry]  
AS  
SELECT UL.EnquiryID, UL.LeadNo, UL.PersonName, UL.img_ext, UL.CompanyName, UL.CreatedDate, 
ISNULL(UL.CountryCode, '') AS CountryCode, ISNULL(UL.MobileNo, '') AS MobileNo, 
ISNULL(UL.Countrycode1, '') AS Countrycode1, ISNULL(UL.Countrycode2, '') as Countrycode2,
ISNULL(UL.Mobileno1, '') AS MobileNo1, ISNULL(UL.Mobileno2, '') AS MobileNo2, ISNULL(UL.Emailid, '') AS Emailid,
ISNULL(UL.EmailID1, '') AS EmailID1, ISNULL(UL.EmailID2, '') AS EmailID2, UL.City, UL.State, UL.Country,
UL.PinCode, UL.ResidentialAddress, UL.OfficeAddress,USS.Name AS SourceName, 
UMS.Name AS MediumName, UCS.Name AS CampaignName, UL.InitialRemarks, UL.ParentID, 
UL.CreatedBy
-- select top 100 *   
FROM userenquiry AS UL(NOLOCK) LEFT JOIN UserSourceSettings AS USS(NOLOCK)   
ON  UL.SourceName = USS.SourceID LEFT JOIN UserMediumSettings AS UMS(NOLOCK)   
ON  UL.MediumName = UMS.MediumID LEFT JOIN UserCampaignSettings AS UCS(NOLOCK)   
ON  UL.CampaignName = UCS.CampaignID LEFT JOIN User_Detail AS UD1(NOLOCK)   
ON  UL.CreatedBy = UD1.User_ID ;  

GO

/****** Object:  View [dbo].[V_UserLeads]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[V_UserLeads]  
AS  
SELECT UL.ID, UL.LeadNo, UL.PersonName, UL.img_ext, UL.CompanyName, UL.CreatedOn, 
ISNULL(UL.CountryCode, '') AS CountryCode, ISNULL(UL.MobileNo, '') AS MobileNo, 
ISNULL(UL.Countrycode1, '') AS Countrycode1, ISNULL(UL.Countrycode2, '') as Countrycode2,
ISNULL(UL.Mobileno1, '') AS MobileNo1, ISNULL(UL.Mobileno2, '') AS MobileNo2, ISNULL(UL.Emailid, '') AS Emailid,
ISNULL(UL.EmailID1, '') AS EmailID1, ISNULL(UL.EmailID2, '') AS EmailID2, UL.City, UL.State, UL.Country,
UL.PinCode, UL.ResidentialAddress, UL.OfficeAddress, UL.AssignedTo, USS.Name AS SourceName, 
UMS.Name AS MediumName, UCS.Name AS CampaignName, UL.InitialRemarks, UL.ParentID, FUS.FollowupStatus,
UL.FollowupDate, UL.Remarks, ISNULL(UL.AmountPaid, 0) AS AmountPaid, CONVERT(VARCHAR(10), UL.CreatedOn, 101) + STUFF(RIGHT(CONVERT(VARCHAR(26), UL.CreatedOn, 109), 15), 7, 7, ' ') AS FollowupCreatedDate,
UL.CreatedBy, UL.ModifiedOn, UL.ModifiedBy, UD1.User_Login AS FollowupBy, UD.User_Login AS assigneduser,
(SELECT STUFF((SELECT N', ' + ss.Name FROM ProductMaster(NOLOCK) AS ss INNER JOIN dbo.fn_Split(ul.Products, '#') AS fs ON ss.ProductID = fs.value FOR XML PATH(''), TYPE).value('text()[1]', 'nvarchar(max)'), 1, 2, N'')) AS Products  
-- select top 100 *   
FROM UserLeads AS UL(NOLOCK) LEFT JOIN UserSourceSettings AS USS(NOLOCK)   
ON  UL.SourceName = USS.SourceID LEFT JOIN UserMediumSettings AS UMS(NOLOCK)   
ON  UL.MediumName = UMS.MediumID LEFT JOIN UserCampaignSettings AS UCS(NOLOCK)   
ON  UL.CampaignName = UCS.CampaignID LEFT JOIN User_Detail AS UD(NOLOCK)   
ON  UL.AssignedTo = UD.User_ID LEFT JOIN User_Detail AS UD1(NOLOCK)   
ON  UL.CreatedBy = UD1.User_ID LEFT JOIN FollowUp_Status AS FUS(NOLOCK)   
ON  UL.FollowUpStatus = FUS.id;  
GO

/****** Object:  View [dbo].[v_VRACheckInOutCount]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_VRACheckInOutCount]
as
select 
	coalesce(cast(ic.CheckIn as date), cast(ic.CheckOut as date)) as [CheckInOutDate], 
	UserId,
	sum(case when isnull(ic.CheckIn, '') <> '' then 1 else 0 end ) as [CheckInCount],	
	sum(case when isnull(ic.CheckOut, '') <> '' then 1 else 0 end ) as [CheckOutCount]
from TBL_ET_GeoEntityCheckInOut(nolock) ic 
group by coalesce(cast(ic.CheckIn as date), cast(ic.CheckOut as date)), UserId

GO

/****** Object:  View [dbo].[v_VRAttendance]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[v_VRAttendance]
as
select 
	coalesce(cast(ia.AttendanceIn as date), cast(ia.AttendanceOut as date)) as [AttandanceDate],
	ia.ParentId,
	ia.UserId,
	min(ia.AttendanceIn) as [SignIn],
	max(ia.AttendanceOut) as [SignOut]
	from TBL_ET_Attendance(nolock) ia 
group by coalesce(cast(ia.AttendanceIn as date), cast(ia.AttendanceOut as date)), ia.ParentId, ia.UserId 

GO

/****** Object:  View [dbo].[ve_UserSubscriptionDetails]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[ve_UserSubscriptionDetails]
AS
	WITH UserCounts AS 
	(
		SELECT [ParentID] AS [UserID], 
                SUM(CASE WHEN STATUS = 1 THEN 1 ELSE 0 END) AS [NoOfActiveUser], 
                SUM(CASE WHEN STATUS = 1 THEN 0 ELSE 1 END) AS [NoOfInActiveUser]
         FROM User_Detail(NOLOCK)
         GROUP BY [ParentID]
	)
    
	SELECT [ud].User_ID, 
            [u].[NoOfActiveUser], 
            [u].[NoOfInActiveUser], 
            [s].[SubscriptionType], 
            [s].[SubscriptionEndDate], 
            [s].[SubscriptionEndingInDay], 
            [ib].[Balance] AS [WalletBalance], 
            [mb].[Balance] AS [MailBalance], 
            [sb].[Balance] AS [SmsBalance]
     FROM User_Detail(NOLOCK) AS ud
          LEFT JOIN UserCounts AS u ON ud.User_ID = u.UserID
          OUTER APPLY -- LatestSubscription
     (
         SELECT [t].[UserID], 
                (CASE WHEN [IsTrailPlan] = 1 AND [IsNewPlan] = 0 THEN 'Trail' ELSE 'New' END) AS [SubscriptionType], 
                [PlanEndDate] AS [SubscriptionEndDate], 
                DATEDIFF(DAY, GETDATE(), [PlanEndDate]) AS [SubscriptionEndingInDay]
         FROM
         (
             SELECT TOP 1 [b].[UserID], 
                          [b].[PlanId], 
                          [b].[PlanStartDate], 
                          [b].[PlanEndDate], 
                          [b].[IsTrailPlan], 
                          [b].[IsNewPlan]
             FROM Price_UserSubscriptionDetails AS b WITH(NOLOCK)
             WHERE [ud].User_ID = [b].[UserID]
             ORDER BY [b].[ID] DESC
         ) AS t
     ) AS s
          OUTER APPLY -- LatestIntCreditBalance
     (
         SELECT TOP 1 User_ID,  [b].[Balance]
         FROM IntCredit_Details AS b WITH(NOLOCK)
         WHERE [b].User_ID = [ud].User_ID
         ORDER BY [b].[Credit_ID] DESC
     ) AS ib
          OUTER APPLY -- LatestMailCreditBalance
     (
         SELECT [t].User_ID AS [UserId], [t].[Balance]
         FROM
         (
             SELECT TOP 1 User_ID, 
                          [Balance]
             FROM MailCreditDetails AS b WITH(NOLOCK)
             WHERE [b].User_ID = [ud].User_ID
             ORDER BY [b].[Credit_ID] DESC
         ) AS t
     ) AS mb
          OUTER APPLY -- LatestCreditBalance
     (
         SELECT [t].User_ID AS [UserId], [t].[Balance]
         FROM
         (
             SELECT TOP 1 User_ID, [Balance]
             FROM Credit_Details AS b WITH(NOLOCK)
             WHERE [ud].User_ID = [b].User_ID
             ORDER BY [b].[Credit_ID] DESC
         ) AS t
     ) AS sb;


GO

/****** Object:  View [dbo].[view_mk_PersonNameMobileNo]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[view_mk_PersonNameMobileNo]
AS
SELECT PersonName, ProfileImgFileName, MobileNo, MobileNo1, MobileNo2 FROM UserLeads
UNION
SELECT PersonName, ProfileImgFileName, MobileNo, MobileNo1, MobileNo2 FROM UserEnquiry


GO

/****** Object:  View [dbo].[VTBL_ET_UserLocationTrackingGPS]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[VTBL_ET_UserLocationTrackingGPS]
as
	select distinct MovementCode,
		LocationDateTime,
		UserId,
		Remarks
	from(
		select 
		MovementCode,
		LocationDateTime,
		UserId,
		Remarks,
		RANK() over (partition by UserId, cast(LocationDateTime as date), MovementCode  order by LocationDateTime) as [mRank]
	from tbl_et_UserLocationTrackingBulkRequest(nolock)	where MovementCode in ('GPS_ON', 'GPS_OFF')
	) t where t.mRank = 1 



GO

/****** Object:  View [dbo].[vw_active_agents_summary]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_active_agents_summary] AS
SELECT 
    a.AgentId,
    a.Name AS AgentName,
    a.Status,
    a.ParentId,
    c.Name AS CompanyName,
    a.total_executions_today,
    a.last_execution_at,
    a.avg_cost_per_execution,
    a.success_rate,
    COUNT(DISTINCT e.entityid) AS pending_leads,
    a.dormant_till,
    CASE 
        WHEN a.dormant_till > GETUTCDATE() THEN 'Dormant'
        WHEN a.Status = 'active' THEN 'Active'
        ELSE a.Status
    END AS current_status
FROM [dbo].[tbl_ai_Agents] a WITH (NOLOCK)
LEFT JOIN [dbo].[tbl_ai_Companies] c WITH (NOLOCK) ON a.CompanyId = c.CompanyId
LEFT JOIN [dbo].[tbl_ai_agent_entity_for_execution] e WITH (NOLOCK) 
    ON a.AgentId = e.agentid AND e.isprocessed = 0
WHERE a.IsDeleted = 0
GROUP BY 
    a.AgentId, a.Name, a.Status, a.ParentId, c.Name,
    a.total_executions_today, a.last_execution_at, 
    a.avg_cost_per_execution, a.success_rate, a.dormant_till;

GO

/****** Object:  View [dbo].[vw_getlatestenquiryconversation_withid]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE   VIEW [dbo].[vw_getlatestenquiryconversation_withid]
AS
SELECT TOP (100) PERCENT leh.historyid as activityid,leh.EnquiryID AS EntityId, leh.EventDescription AS Text, 'text' AS Type, '' AS Direction, CAST(leh.EventDate AS datetime) AS CreatedOn, ud.User_ID AS AgentId, ud.User_Login AS AgentName, 
                         ud.Image AS AgentImage, leh.ParentID AS PID, 'lead' AS EntityName
FROM            dbo.tbl_EnquiryEventHistory AS leh WITH (nolock) RIGHT OUTER JOIN
                         dbo.Userenquiry AS ul WITH (nolock) ON leh.EnquiryID = ul.enquiryID LEFT OUTER JOIN
                         dbo.User_Detail AS ud WITH (nolock) ON ul.CreatedBy = ud.User_ID
WHERE        (leh.HistoryID =
                             (SELECT        MAX(HistoryID) AS Expr1
                               FROM            dbo.tbl_LeadEventHistory WITH (nolock)
                               WHERE        (LeadID = leh.EnquiryID)))
ORDER BY ISNULL(leh.EventDate, ul.CreatedDate) DESC

GO

/****** Object:  View [dbo].[vw_getlatestleadconversation]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_getlatestleadconversation]
AS
SELECT        TOP (100) PERCENT leh.LeadID AS EntityId, leh.EventDescription AS Text, 'text' AS Type, '' AS Direction, CAST(leh.EventDate AS datetime) AS CreatedOn, ud.User_ID AS AgentId, ud.User_Login AS AgentName, 
                         ud.Image AS AgentImage, leh.ParentID AS PID, 'lead' AS EntityName
FROM            dbo.tbl_LeadEventHistory AS leh WITH (nolock) RIGHT OUTER JOIN
                         dbo.UserLeads AS ul WITH (nolock) ON leh.LeadID = ul.ID LEFT OUTER JOIN
                         dbo.User_Detail AS ud WITH (nolock) ON ul.AssignedTo = ud.User_ID
WHERE        (leh.HistoryID =
                             (SELECT        MAX(HistoryID) AS Expr1
                               FROM            dbo.tbl_LeadEventHistory WITH (nolock)
                               WHERE        (LeadID = leh.LeadID)))
ORDER BY ISNULL(leh.EventDate, ul.CreatedOn) DESC

GO

/****** Object:  View [dbo].[vw_getlatestleadconversation_only]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_getlatestleadconversation_only]
AS
SELECT leh.LeadID AS EntityId, CAST(leh.EventDate AS datetime) AS CreatedOn, historyid as id,'event' as tbl
FROM            dbo.tbl_LeadEventHistory AS leh WITH (nolock) RIGHT OUTER JOIN
                         dbo.UserLeads AS ul WITH (nolock) ON leh.LeadID = ul.ID LEFT OUTER JOIN
                         dbo.User_Detail AS ud WITH (nolock) ON ul.AssignedTo = ud.User_ID
WHERE        (leh.HistoryID =
                             (SELECT        MAX(HistoryID) AS Expr1
                               FROM            dbo.tbl_LeadEventHistory WITH (nolock)
                               WHERE        (LeadID = leh.LeadID)))


GO

/****** Object:  View [dbo].[vw_getlatestleadconversation_withid]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_getlatestleadconversation_withid]
AS
SELECT TOP (100) PERCENT leh.historyid as activityid,leh.LeadID AS EntityId, leh.EventDescription AS Text, 'text' AS Type, '' AS Direction, CAST(leh.EventDate AS datetime) AS CreatedOn, ud.User_ID AS AgentId, ud.User_Login AS AgentName, 
                         ud.Image AS AgentImage, leh.ParentID AS PID, 'lead' AS EntityName
FROM            dbo.tbl_LeadEventHistory AS leh WITH (nolock) RIGHT OUTER JOIN
                         dbo.UserLeads AS ul WITH (nolock) ON leh.LeadID = ul.ID LEFT OUTER JOIN
                         dbo.User_Detail AS ud WITH (nolock) ON ul.AssignedTo = ud.User_ID
WHERE        (leh.HistoryID =
                             (SELECT        MAX(HistoryID) AS Expr1
                               FROM            dbo.tbl_LeadEventHistory WITH (nolock)
                               WHERE        (LeadID = leh.LeadID)))
ORDER BY ISNULL(leh.EventDate, ul.CreatedOn) DESC

GO

/****** Object:  View [dbo].[vw_GetResellerDomainCount]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_GetResellerDomainCount]
AS
    SELECT 
        Reseller_ID,
        ROW_NUMBER() OVER(PARTITION BY Domain ORDER BY LastModified DESC ) AS [DomainCount]
    FROM reseller_detail(nolock) where len(Domain)  > 0

GO

/****** Object:  View [dbo].[vw_human_alerts]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- View: Leads Requiring Human Intervention
CREATE   VIEW [dbo].[vw_human_alerts] AS
SELECT 
    s.agentid,
    a.Name AS AgentName,
    s.entityname,
    s.entityid,
    s.ai_status,
    s.metadata,
    s.last_contacted,
    s.createdon,
    DATEDIFF(HOUR, s.createdon, GETUTCDATE()) AS hours_pending
FROM [dbo].[tbl_ai_agent_entity_status] s WITH (NOLOCK)
INNER JOIN [dbo].[tbl_ai_Agents] a WITH (NOLOCK) ON s.agentid = a.AgentId
WHERE s.human_alert = 1
    AND a.IsDeleted = 0;

GO

/****** Object:  View [dbo].[vw_latestleadevent]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_latestleadevent]
AS
SELECT        HistoryID, UserID, LeadID, ParentID, EventDescription, EventDate, IPAddress, EventID, reftables, refids
FROM            dbo.tbl_LeadEventHistory AS t WITH (nolock)
WHERE        (HistoryID =
                             (SELECT        MAX(HistoryID) AS Expr1
                               FROM            dbo.tbl_LeadEventHistory WITH (nolock)
                               WHERE        (LeadID = t.LeadID)))

GO

/****** Object:  View [dbo].[vw_partnerdetails]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_partnerdetails]
AS
SELECT u.M_ID AS PartnerID,r.reseller_id, u.User_ID, u.User_Login, u.FName AS Firstname, u.LName AS LastName, u.EMail, u.Mobile, u.City, u.State, u.Country, 
                  CASE WHEN Type = 0 THEN 'User' WHEN type = 1 THEN 'Reseller' WHEN type = 2 THEN 'Subreseller' WHEN type IN (3, 4) AND u.user_id <> 335 THEN 'Partner' WHEN u.user_id = 335 THEN 'Site Owner' END AS UserType, 
                  u.Status AS IsActive, u.DateCreated, u.Gender, u.Pincode, u.Address, u.User_DOB, u.ProfilePicturePath, u.CompnayName AS CompanyName, u.CountryCode, u.IsAdmin, u.ParentID, u.LastLogin2, u.isverify AS IsMailVerified, u.Source, 
                  u.Medium, u.Campaign, u.Timezone, u.onduty, u.Support_Access, u.Cloudrole, u.wa_country_code, u.wa_mobile_no, u.wa_profile_id, 
				  ISNULL(r.Partner_Type, 0) AS partner_type, CASE WHEN r.reseller_id IS NULL 
                  THEN 0 ELSE 1 END AS IsPartner, CASE WHEN u.user_id = u.parentid THEN 1 ELSE 0 END AS IsParent, dbo.fn_parent_getsubscriptionexpiry(u.User_ID) AS SubscriptionEndDate,
				  isnull(json_value(t.jsondata,'$.DomainName'),'') as Url,
				  dbo.fn_getsignin_url(u.user_id) as ParentPartnerUrl,
				  case when u.user_id<>335 and json_value(t.jsondata,'$.DomainName') is null then '' 
				  when u.user_id<>335 then 'https://'+replace(replace(json_value(t.jsondata,'$.DomainName'),'https://',''),
				  'http://','')+'/assets/custom/partner/resource/'+cast(reseller_id as nvarchar)+'/'+json_value(t.jsondata,'$.LogoUrl') 
else 'https://kit19.com/assets/custom/img/logobig.png' end as Logo, coalesce(json_value(jsonmobiledata,'$.DisplayNmae'),'') as DisplayName,
isnull(json_value(jsonEmailData,'$.Email'),'') FromMail,
isnull(json_value(jsonEmailData,'$.AltNm'),'') Ph1,
isnull(json_value(jsonEmailData,'$.Mobile2'),'') Ph2,
isnull(json_value(jsonEmailData,'$.Address'),'') add1,
isnull(json_value(jsonEmailData,'$.Address1'),'') add2,
isnull(json_value(jsonEmailData,'$.FbUrl'),'') fburl,
isnull(json_value(jsonEmailData,'$.TwtUrl'),'') TwtUrl,
isnull(json_value(jsonEmailData,'$.LnkUrl'),'') LnkUrl,
isnull(json_value(jsonEmailData,'$.Signature'),'') Signature,
isnull(json_value(jsonData,'$.Termurl'),'') Termurl,
isnull(json_value(jsonEmailData,'$.PolicyUrl'),'') PolicyUrl

FROM     dbo.User_Detail AS u WITH (nolock) 
JOIN dbo.reseller_detail AS r WITH (nolock) ON r.User_ID = u.User_ID
left join tbl_pt_CustomizationMetadata as t with (nolock) on t.userid=r.User_ID


GO

/****** Object:  View [dbo].[vw_PhysicalAppoitment]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW  [dbo].[vw_PhysicalAppoitment]
as
	select p.PhysicalAppointmentId, p.Title, p.StartDate, p.EndDate, p.GeoEntitySiteId, p.OutcomesId, p.CreatedBy as AgentId,
		p.CreatedBy, p.AssignedTo, p.Status, p.TaskTypeId, p.ParentId as [vParentId]
	from TBL_ET_PhysicalAppointment(nolock) p where p.IsActive = 1
	union
	select p.PhysicalAppointmentId, p.Title, p.StartDate, p.EndDate, p.GeoEntitySiteId, p.OutcomesId, p.AssignedTo as AgentId,
		p.CreatedBy, p.AssignedTo, p.Status, p.TaskTypeId, p.ParentId as [vParentId]
	from TBL_ET_PhysicalAppointment(nolock) p where p.IsActive = 1 		
	union
	select p.PhysicalAppointmentId, p.Title, p.StartDate, p.EndDate, p.GeoEntitySiteId, p.OutcomesId, m.UserId as AgentId,
		p.CreatedBy, p.AssignedTo, p.Status, p.TaskTypeId, p.ParentId as [vParentId]
	from TBL_ET_PhysicalAppointment(nolock) p 
	inner join	TBL_ET_PhyAppointCollaboratorUserMapping(nolock) m on p.PhysicalAppointmentId = m.PhysicalAppointmentId and m.IsActive = 1
	where p.IsActive = 1 
	union
	select p.PhysicalAppointmentId, p.Title, p.StartDate, p.EndDate, p.GeoEntitySiteId, p.OutcomesId, m.UserId as AgentId,
		p.CreatedBy, p.AssignedTo, p.Status, p.TaskTypeId, p.ParentId as [vParentId]
	from TBL_ET_PhysicalAppointment(nolock) p 
	inner join	TBL_ET_PhyAppointUserMapping(nolock) m on p.PhysicalAppointmentId = m.PhysicalAppointmentId and m.IsActive = 1
	where p.IsActive = 1 


GO

/****** Object:  View [dbo].[vw_pm_GetKycDocumentStatusCounts]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_pm_GetKycDocumentStatusCounts]
as
	select KycId,
		sum(case when DocStatus = 'Submitted' then 1 else 0 end ) as [PendingCount],
		sum(case when DocStatus = 'approved' then 1 else 0 end ) as [ApprovedCount],
		sum(case when DocStatus = 'rejected' then 1 else 0 end ) as [RejectedCount]
	from tbl_uploadDocumentation(nolock) where IsActive = 1 group by KycId

GO

/****** Object:  View [dbo].[vw_pt_ActionUserCount]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_pt_ActionUserCount]
as
	select ParentID, count(1) as TotalActiveUser 
	from User_Detail(nolock) where [Status] = 1
		group by ParentID 

GO

/****** Object:  View [dbo].[vw_pt_AllowUserTransactionsLatest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_pt_AllowUserTransactionsLatest]
as
select Id, UserId, CreatedOn, CreatedBy, ModifiedOn, IsActive, AllowUserCount, SubscriptionId, TransactionId, UserAdded, LicenceType 
from (
	select Id, UserId, CreatedOn, CreatedBy, ModifiedOn, IsActive, AllowUserCount, SubscriptionId, TransactionId, UserAdded, LicenceType,
	row_number() over (partition by UserId order by id desc) as rno
	from tbl_pt_AllowUserTransactions(nolock) 
) aut where aut.rno = 1

GO

/****** Object:  View [dbo].[VW_Serv_Ticket_Stat_Mast]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_Serv_Ticket_Stat_Mast]      
as      
      
 SELECT   
 CASE      
    WHEN Stat_ID= 0 THEN -1      
    ELSE Stat_ID      
END AS Stat_ID,   
 Stat_Desc,      
CASE      
    WHEN Stat_ID in (2,4) THEN 2      
    ELSE 1      
END AS VW_Stat_ID      
FROM Serv_Ticket_Stat_Mast

  
GO

/****** Object:  View [dbo].[VW_Serv_User_Detail]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_Serv_User_Detail]  
  as  
  select ParentId,ISNULL( Name,'' ) as name,  
  ISNULL( Email,'' ) as EmailID,  
   ISNULL( str(Mobile),'' ) as MobileNo  
    
   From Serv_User_Detail

GO

/****** Object:  View [dbo].[VW_Serv_User_Detail_Support]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_Serv_User_Detail_Support]
AS
SELECT        ISNULL(dbo.Serv_User_Detail.Name, '') AS Name, ISNULL(dbo.Serv_User_Detail.Email, '') AS EmailID, ISNULL(STR(dbo.Serv_User_Detail.Mobile), '') AS MobileNo, 
                         ISNULL(dbo.User_Detail.Image, '') AS leadimage, dbo.Serv_User_Detail.ParentId
FROM            dbo.Serv_User_Detail LEFT OUTER JOIN
                         dbo.User_Detail ON dbo.Serv_User_Detail.User_id_old = dbo.User_Detail.User_ID

GO

/****** Object:  View [dbo].[VW_serv_user_domain]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  CREATE   VIEW [dbo].[VW_serv_user_domain]      
AS      
SELECT id,ParentId,VDomain_Name,virtual_domain,VEmailID_Name,virtual_mail,link_Account,SMS_Link_Account,virtual_sms,      
REPLACE(REPLACE(REPLACE(REPLACE(virtual_domain, 'https://', ''),'www.',''),'http://',''),'localhost:1082','') as Map_virtual_domain      
  FROM [serv_user_domain]

GO

/****** Object:  View [dbo].[vw_SmsMessageDelivery]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_SmsMessageDelivery]
AS
SELECT        MessageID, MessageRefID, BatchID, Mobile, Message, SenderID, MessageStatus, Priority, MessageInsertDate, U_ID, LastError, StatusDescription, IsDND,  Operator,  Isallowdnd, DbType, IsUniCode,  StatusCompletedTime, StatusCompletedTimeSecs, ProviderReference
FROM            MessageDeliveryStatus WITH (nolock)
UNION
SELECT        MessageID, MessageRefID, BatchID, Mobile, Message, SenderID, MessageStatus, Priority, MessageInsertDate, U_ID, LastError,  StatusDescription, IsDND, Operator, Isallowdnd,  Dbtype, isunicode, StatusCompletedTime, StatusCompletedTimeSecs, ProviderReference
FROM            ThirtyDaysHistory WITH (nolock)

GO

/****** Object:  View [dbo].[VW_SystemRole_RoleMaster]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_SystemRole_RoleMaster] AS  
  
select RoleId, RoleName, RoleCode, IsInternal, ParentId, TP, IsActive from (  
select Id RoleId, RoleName, SysRoleCode RoleCode, IsInternal, 0 ParentId, 'S' TP, IsActive from systemroles  
  
Union All  
  
select RoleId, RoleName, RoleCode, IsInternal, ParentId, 'D' TP, Active as IsActive  
from tbl_UA_RoleMaster(nolock)   
)t  
GO

/****** Object:  View [dbo].[vw_tp_LastTicketHistory]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_tp_LastTicketHistory]  
As  
 Select *    
 From    
 (    
  select Row_number()over(partition by ParentID,TicketID order by TicketHistoryID desc) as Sno,*     
  from tbl_tp_TicketHistory(nolock)    
 )T    
 Where T.Sno=1    
GO

/****** Object:  View [dbo].[vw_tp_TicketHistory]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_tp_TicketHistory]
As
 Select *  
 From  
 (  
  select Row_number()over(partition by ParentID,TicketID order by TicketHistoryID desc) as Sno,*   
  from tbl_tp_TicketHistory(nolock)  
 )T  

GO

/****** Object:  View [dbo].[vw_userdetail]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_userdetail]
AS
SELECT u.M_ID AS PartnerID, u.User_ID, u.User_Login, u.FName AS Firstname, u.LName AS LastName, u.EMail, u.Mobile, u.City, u.State, u.Country, 
                  CASE WHEN Type = 0 THEN 'User' WHEN type = 1 THEN 'Reseller' WHEN type = 2 THEN 'Subreseller' WHEN type IN (3, 4) AND u.user_id <> 335 THEN 'Partner' WHEN u.user_id = 335 THEN 'Site Owner' END AS UserType, 
                  u.Status AS IsActive, u.DateCreated, u.Gender, u.Pincode, u.Address, u.User_DOB, u.ProfilePicturePath, u.CompnayName AS CompanyName, u.CountryCode, u.IsAdmin, u.ParentID, u.LastLogin2, u.isverify AS IsMailVerified, u.Source, 
                  u.Medium, u.Campaign, u.Timezone, u.onduty, u.Support_Access, u.Cloudrole, u.wa_country_code, u.wa_mobile_no, u.wa_profile_id, ISNULL(r.Partner_Type, 0) AS partner_type, CASE WHEN r.reseller_id IS NULL 
                  THEN 0 ELSE 1 END AS IsPartner, CASE WHEN u.user_id = u.parentid THEN 1 ELSE 0 END AS IsParent, dbo.fn_parent_getsubscriptionexpiry(u.User_ID) AS SubscriptionEndDate
FROM     dbo.User_Detail AS u WITH (nolock) LEFT OUTER JOIN
                  dbo.reseller_detail AS r WITH (nolock) ON r.User_ID = u.User_ID

GO

/****** Object:  View [dbo].[VW_UserLead]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_UserLead]
as

select ParentID,isnull(LeadImage,'https://www.w3schools.com/bootstrap4/img_avatar3.png')  LeadImage from UserLeads

GO

/****** Object:  View [dbo].[VW_UserLeads1]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_UserLeads1]  
  as  
  select id,ParentID, ISNULL( PersonName,'' ) as Name,ISNULL( EmailID,'' ) as EmailID,  
  ISNULL( MobileNo,'' ) as MobileNo,  ISNULL( MobileNo1,'' ) as MobileNo1,  
  ISNULL( MobileNo2,'' ) as MobileNo2,isnull(leadimage,'') as leadimage  
    
   From UserLeads 

GO

/****** Object:  View [dbo].[VW_UserLeads2]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_UserLeads2]    
  as    
  select id,ParentID, ISNULL( PersonName,'' ) as Name,ISNULL( EmailID1,'' ) as EmailID,    
  ISNULL( MobileNo,'' ) as MobileNo,  ISNULL( MobileNo1,'' ) as MobileNo1,    
  ISNULL( MobileNo2,'' ) as MobileNo2,isnull(leadimage,'') as leadimage    
      
   From UserLeads 

GO

/****** Object:  View [dbo].[VW_UserLeads3]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_UserLeads3]    
  as    
  select id,ParentID, ISNULL( PersonName,'' ) as Name,ISNULL( EmailID2,'' ) as EmailID,    
  ISNULL( MobileNo,'' ) as MobileNo,  ISNULL( MobileNo1,'' ) as MobileNo1,    
  ISNULL( MobileNo2,'' ) as MobileNo2 ,
  isnull(leadimage,'') as leadimage   
      
   From UserLeads 

GO

/****** Object:  View [dbo].[Vw_userlocationtracking_latest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[Vw_userlocationtracking_latest]
AS
SELECT id, user_id, lastlocationtracked, laststatus, modelname, Currentlytrackable, createdon, lastlocationreason
FROM     dbo.UserLocationTracking AS u
WHERE  (id =
                      (SELECT MAX(id) AS Expr1
                       FROM      dbo.UserLocationTracking WITH (nolock)
                       WHERE   (user_id = u.user_id)))

GO

/****** Object:  View [dbo].[vw_UserSubscriptionLatest]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_UserSubscriptionLatest]
as
select UserId, PlanId, PlanStartDate, PlanEndDate from
( select UserId, PlanId, PlanStartDate, PlanEndDate,
	ROW_NUMBER() over (partition by UserID order by id desc ) as rNo
	from Price_usersubscriptiondetails(nolock) ) p where p.rNo = 1

GO

/****** Object:  View [dbo].[vw_vb_call_costs]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_vb_call_costs] AS
SELECT 
    cl.Id AS CallLogId,
    cl.CallSid,
    cl.dnid,
    cl.Callstarttime,
    cl.Callendtime,
    DATEDIFF(SECOND, cl.Callstarttime, cl.Callendtime) AS CallDurationSeconds,
    SUM(tu.ChatAgentInputTokens) AS TotalChatAgentInputTokens,
    SUM(tu.ChatAgentOutputTokens) AS TotalChatAgentOutputTokens,
    SUM(tu.TTSCharacters) AS TotalTTSCharacters,
    SUM(tu.STTDurationSeconds) AS TotalSTTSeconds,
    SUM(tu.TotalCostUSD) AS TotalCostUSD,
    SUM(tu.ChatAgentCostUSD) AS ChatAgentCostUSD,
    SUM(tu.TTSCostUSD) AS TTSCostUSD,
    SUM(tu.STTCostUSD) AS STTCostUSD
FROM calllog cl
LEFT JOIN vb_token_usage tu ON cl.Id = tu.CallLogId
left join tbl_voip_ServiceProvider t on t.id=cl.gatewayid
GROUP BY 
    cl.Id, cl.CallSid, cl.dnid, 
    cl.Callstarttime, cl.Callendtime;

GO

/****** Object:  View [dbo].[vw_vb_current_pricing]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Usage Examples:
-- Update ChatAgent pricing when provider changes rates:
-- EXEC usp_vb_update_pricing 'ChatAgent', 'Bedrock', 'anthropic.claude-3-5-sonnet-20241022-v2:0', 0.003, 0.015
-- 
-- Update TTS pricing:
-- EXEC usp_vb_update_pricing 'TTS', 'Polly', NULL, NULL, NULL, 4.0, NULL
--
-- Update STT pricing:
-- EXEC usp_vb_update_pricing 'STT', 'Deepgram', 'nova-2', NULL, NULL, NULL, 0.000072

-- View to see current active pricing
CREATE   VIEW [dbo].[vw_vb_current_pricing] AS
SELECT 
    ServiceType,
    ProviderName,
    ModelId,
    InputTokenCostPer1K,
    OutputTokenCostPer1K,
    CharacterCostPer1M,
    DurationCostPerSecond,
    EffectiveFrom
FROM vb_pricing_config
WHERE IsActive = 1;

GO

/****** Object:  View [dbo].[vw_vb_customer_usage]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- View for customer billing aggregation
CREATE   VIEW [dbo].[vw_vb_customer_usage] AS
SELECT 
    cl.ParentId,  -- Your customer/tenant ID
    CAST(cl.callstarttime AS DATE) AS UsageDate,
    COUNT(DISTINCT cl.Id) AS TotalCalls,
    SUM(DATEDIFF(SECOND, cl.Callstarttime, cl.Callendtime)) AS TotalCallSeconds,
    SUM(tu.ChatAgentInputTokens) AS TotalChatAgentInputTokens,
    SUM(tu.ChatAgentOutputTokens) AS TotalChatAgentOutputTokens,
    SUM(tu.TTSCharacters) AS TotalTTSCharacters,
    SUM(tu.STTDurationSeconds) AS TotalSTTSeconds,
    SUM(tu.TotalCostUSD) AS TotalCostUSD
FROM calllog cl
LEFT JOIN vb_token_usage tu ON cl.Id = tu.CallLogId
GROUP BY cl.ParentId, CAST(cl.Callstarttime AS DATE);

GO

/****** Object:  View [dbo].[vwUC_LeadInteractionSummary]    Script Date: 06-06-26 10:18:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vwUC_LeadInteractionSummary]
as
	SELECT 
		lih.ParentID,
		lih.leadno,
		SUM(lih.AmountPaid) AS TotalAmount,
		COUNT(*) AS TotalOrders,
		MAX(lih.FollowupDate) AS OrderDate,
		latest.AssignedTo
	FROM LeadInteractionHistory (NOLOCK) lih
	INNER JOIN FollowUp_Status (NOLOCK) fs 
		ON lih.FollowUpStatus = fs.ID 
		AND ISNULL(fs.ParentID, 0) IN (lih.ParentID, 0)
		AND fs.IsConvert = 1 
		AND CAST(lih.FollowupDate AS date) <= CAST(GETDATE() AS date)
	OUTER APPLY (
		SELECT TOP 1 AssignedTo 
		FROM LeadInteractionHistory (NOLOCK) lih2
		WHERE lih2.ParentID = lih.ParentID AND lih2.leadno = lih.leadno
		ORDER BY lih2.FollowupDate DESC, lih2.ID DESC
	) latest
	GROUP BY lih.ParentID, lih.leadno, latest.AssignedTo


GO


