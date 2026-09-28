USE [MySMS_34594]
GO

/****** Object:  UserDefinedTableType [dbo].[AdDocTBLType]    Script Date: 06-06-26 11:00:17 ******/
CREATE TYPE [dbo].[AdDocTBLType] AS TABLE(
	[DocPath] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[BroadcastFieldTBLType]    Script Date: 06-06-26 11:00:18 ******/
CREATE TYPE [dbo].[BroadcastFieldTBLType] AS TABLE(
	[TemplateFieldId] [bigint] NULL,
	[FieldValue] [nvarchar](4000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[BroadcastFieldTBLType1]    Script Date: 06-06-26 11:00:18 ******/
CREATE TYPE [dbo].[BroadcastFieldTBLType1] AS TABLE(
	[TemplateFieldId] [bigint] NULL,
	[FieldValue] [nvarchar](4000) NULL,
	[FileName] [nvarchar](255) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[BroadcastFieldTBLTypeNew]    Script Date: 06-06-26 11:00:18 ******/
CREATE TYPE [dbo].[BroadcastFieldTBLTypeNew] AS TABLE(
	[TemplateFieldId] [bigint] NULL,
	[FieldValue] [nvarchar](4000) NULL,
	[FileName] [nvarchar](255) NULL,
	[MediaId] [nvarchar](255) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[CloneMessage_TBLType]    Script Date: 06-06-26 11:00:19 ******/
CREATE TYPE [dbo].[CloneMessage_TBLType] AS TABLE(
	[BatchID] [nvarchar](50) NULL,
	[U_ID] [bigint] NULL,
	[Mobile] [nvarchar](50) NULL,
	[Message] [nvarchar](max) NULL,
	[ScheduledDate] [nvarchar](50) NULL,
	[ScheduledTime] [nvarchar](50) NULL,
	[SenderID] [nvarchar](50) NULL,
	[IsPrority] [nvarchar](20) NULL,
	[IsAllowDND] [nvarchar](20) NULL,
	[IsUniCode] [int] NULL,
	[SmppID] [int] NULL,
	[MobileSubSet] [nvarchar](50) NULL,
	[MessageStatus] [nvarchar](50) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[clOutcomes]    Script Date: 06-06-26 11:00:19 ******/
CREATE TYPE [dbo].[clOutcomes] AS TABLE(
	[Id] [bigint] NULL,
	[OutcomeId] [bigint] NULL,
	[OutcomeName] [nvarchar](255) NULL,
	[OutcomeIndent] [nvarchar](20) NULL,
	[Sequence] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[CollaboratorTableType]    Script Date: 06-06-26 11:00:19 ******/
CREATE TYPE [dbo].[CollaboratorTableType] AS TABLE(
	[TypeId] [bigint] NULL,
	[AssignType] [nvarchar](100) NULL,
	[CollaboratorId] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customEnquiry]    Script Date: 06-06-26 11:00:20 ******/
CREATE TYPE [dbo].[customEnquiry] AS TABLE(
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [varchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customEnquiry1]    Script Date: 06-06-26 11:00:20 ******/
CREATE TYPE [dbo].[customEnquiry1] AS TABLE(
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [nvarchar](4000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customEnquiry2]    Script Date: 06-06-26 11:00:20 ******/
CREATE TYPE [dbo].[customEnquiry2] AS TABLE(
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [nvarchar](4000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customEnquiry3]    Script Date: 06-06-26 11:00:21 ******/
CREATE TYPE [dbo].[customEnquiry3] AS TABLE(
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [nvarchar](4000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customEnquiry4]    Script Date: 06-06-26 11:00:21 ******/
CREATE TYPE [dbo].[customEnquiry4] AS TABLE(
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [nvarchar](4000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customleads1]    Script Date: 06-06-26 11:00:22 ******/
CREATE TYPE [dbo].[customleads1] AS TABLE(
	[LeadID] [bigint] NULL,
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [varchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customleads2]    Script Date: 06-06-26 11:00:22 ******/
CREATE TYPE [dbo].[customleads2] AS TABLE(
	[LeadID] [bigint] NULL,
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [nvarchar](200) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[customleads3]    Script Date: 06-06-26 11:00:22 ******/
CREATE TYPE [dbo].[customleads3] AS TABLE(
	[LeadID] [bigint] NULL,
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [nvarchar](4000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[dtEmailAttachment]    Script Date: 06-06-26 11:00:23 ******/
CREATE TYPE [dbo].[dtEmailAttachment] AS TABLE(
	[FileName] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[dtFbPageToken]    Script Date: 06-06-26 11:00:23 ******/
CREATE TYPE [dbo].[dtFbPageToken] AS TABLE(
	[Id] [bigint] NULL,
	[FbPageLongToken] [nvarchar](max) NULL,
	[FbPageId] [nvarchar](max) NULL,
	[AuthError] [nvarchar](max) NULL,
	[IsValid] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[dtIvrDesignContact]    Script Date: 06-06-26 11:00:23 ******/
CREATE TYPE [dbo].[dtIvrDesignContact] AS TABLE(
	[Id] [bigint] NULL,
	[MobileNo] [nvarchar](25) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[dtIvrMobileNos]    Script Date: 06-06-26 11:00:24 ******/
CREATE TYPE [dbo].[dtIvrMobileNos] AS TABLE(
	[id] [bigint] NULL,
	[mobileno] [nvarchar](25) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[dtProductFreeBee]    Script Date: 06-06-26 11:00:24 ******/
CREATE TYPE [dbo].[dtProductFreeBee] AS TABLE(
	[ParentId] [bigint] NULL,
	[ProductName] [nvarchar](max) NULL,
	[OrderId] [bigint] NULL,
	[MinQty] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[dtUserLogins]    Script Date: 06-06-26 11:00:24 ******/
CREATE TYPE [dbo].[dtUserLogins] AS TABLE(
	[UserLogin] [nvarchar](255) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Email]    Script Date: 06-06-26 11:00:25 ******/
CREATE TYPE [dbo].[Email] AS TABLE(
	[Mail_Id] [bigint] NULL,
	[Mail_FromEmail] [varchar](100) NOT NULL,
	[Mail_ToEmail] [varchar](100) NOT NULL,
	[Mail_Subject] [nvarchar](200) NULL,
	[Mail_TempleteName] [varchar](100) NULL,
	[Messages] [nvarchar](max) NULL,
	[Mail_InsertedDate] [datetime] NOT NULL,
	[Mail_UserID] [int] NOT NULL,
	[Mail_ParentID] [int] NULL,
	[ReplyTo] [varchar](100) NULL,
	[Mail_BatchID] [bigint] NULL,
	[Mail_Priority] [int] NULL,
	[Mail_ScheduleDate] [varchar](50) NULL,
	[Mail_ScheduledTime] [varchar](50) NULL,
	[Mail_Attechement] [varchar](500) NULL,
	[Mail_TempleteBody] [nvarchar](max) NULL,
	[IsMonitor] [bit] NOT NULL,
	[TemplateID] [bigint] NULL,
	[Count] [int] NOT NULL,
	[Source] [nvarchar](20) NOT NULL,
	[mailroute] [nvarchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[EmailSendTableTypeWebApi]    Script Date: 06-06-26 11:00:25 ******/
CREATE TYPE [dbo].[EmailSendTableTypeWebApi] AS TABLE(
	[Email] [varchar](50) NULL,
	[Subjects] [varchar](max) NULL,
	[CONTENT] [nvarchar](max) NULL,
	[ReplyTo] [varchar](50) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[emailssent_new]    Script Date: 06-06-26 11:00:25 ******/
CREATE TYPE [dbo].[emailssent_new] AS TABLE(
	[Mail_GUID] [nvarchar](50) NULL,
	[Mail_ID] [nvarchar](50) NULL,
	[Mail_BatchID] [nvarchar](50) NOT NULL,
	[Mail_FromEmail] [nvarchar](250) NULL,
	[Mail_ToEmail] [nvarchar](250) NULL,
	[ReplyTo] [nvarchar](250) NULL,
	[Mail_Subject] [nvarchar](250) NULL,
	[Mail_Attechement] [varchar](100) NULL,
	[Mail_TempleteName] [nvarchar](100) NULL,
	[Mail_InsertedDate] [nvarchar](50) NULL,
	[Mail_Delivered] [nvarchar](50) NULL,
	[Mail_DeliveredDate] [nvarchar](50) NULL,
	[Mail_Invalid] [nvarchar](50) NULL,
	[Mail_UserID] [nvarchar](50) NULL,
	[Mail_ScheduleDate] [nvarchar](50) NULL,
	[Mail_Error] [nvarchar](max) NULL,
	[smtpserver] [nvarchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[enquirieswithleadno]    Script Date: 06-06-26 11:00:26 ******/
CREATE TYPE [dbo].[enquirieswithleadno] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[entity] [nvarchar](50) NULL,
	[enquiryid] [bigint] NULL,
	[leadno] [bigint] NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[EnquiryDetailsType]    Script Date: 06-06-26 11:00:27 ******/
CREATE TYPE [dbo].[EnquiryDetailsType] AS TABLE(
	[PersonName] [varchar](100) NULL,
	[CompanyName] [varchar](100) NULL,
	[MobileNo] [varchar](100) NULL,
	[MobileNo1] [varchar](100) NULL,
	[MobileNo2] [varchar](100) NULL,
	[EmailID] [varchar](100) NULL,
	[EmailID1] [varchar](100) NULL,
	[EmailID2] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](100) NULL,
	[Country] [varchar](100) NULL,
	[CountryCode] [varchar](50) NULL,
	[CountryCode1] [varchar](50) NULL,
	[CountryCode2] [varchar](50) NULL,
	[PinCode] [varchar](50) NULL,
	[ResidentialAddress] [varchar](500) NULL,
	[OfficeAddress] [varchar](500) NULL,
	[SourceName] [varchar](50) NULL,
	[MediumName] [varchar](50) NULL,
	[CampaignName] [varchar](50) NULL,
	[InitialRemarks] [varchar](1000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[enquiryforla]    Script Date: 06-06-26 11:00:27 ******/
CREATE TYPE [dbo].[enquiryforla] AS TABLE(
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[EnquiryID] [bigint] NULL,
	[parentID] [bigint] NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[EnquiryMessageTbltype]    Script Date: 06-06-26 11:00:28 ******/
CREATE TYPE [dbo].[EnquiryMessageTbltype] AS TABLE(
	[BatchID] [bigint] NOT NULL,
	[leadid] [bigint] NULL,
	[U_ID] [int] NOT NULL,
	[Mobile] [varchar](20) NULL,
	[Message] [nvarchar](2500) NULL,
	[ScheduledDate] [varchar](50) NULL,
	[ScheduledTime] [varchar](50) NULL,
	[SenderID] [nchar](20) NULL,
	[IsPrority] [tinyint] NULL,
	[IsAllowDND] [tinyint] NULL,
	[IsUniCode] [bit] NOT NULL,
	[SmppID] [tinyint] NOT NULL,
	[MobileSubSet] [bigint] NULL,
	[MessageStatus] [varchar](20) NULL,
	[isflash] [bit] NULL,
	[sms_source] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[EnquiryMessageTbltype1]    Script Date: 06-06-26 11:00:29 ******/
CREATE TYPE [dbo].[EnquiryMessageTbltype1] AS TABLE(
	[TemplateID] [bigint] NOT NULL,
	[BatchID] [bigint] NOT NULL,
	[leadid] [bigint] NULL,
	[U_ID] [int] NOT NULL,
	[Mobile] [varchar](20) NULL,
	[Message] [nvarchar](2500) NULL,
	[ScheduledDate] [varchar](50) NULL,
	[ScheduledTime] [varchar](50) NULL,
	[SenderID] [nchar](20) NULL,
	[IsPrority] [tinyint] NULL,
	[IsAllowDND] [tinyint] NULL,
	[IsUniCode] [bit] NOT NULL,
	[SmppID] [tinyint] NOT NULL,
	[MobileSubSet] [bigint] NULL,
	[MessageStatus] [varchar](20) NULL,
	[isflash] [bit] NULL,
	[sms_source] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[EnquiryScoreAttributes]    Script Date: 06-06-26 11:00:29 ******/
CREATE TYPE [dbo].[EnquiryScoreAttributes] AS TABLE(
	[EventAttribute] [nvarchar](100) NULL,
	[Operator] [nvarchar](50) NULL,
	[ComparisonValue] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[EnquiryScoreRules_TblType]    Script Date: 06-06-26 11:00:29 ******/
CREATE TYPE [dbo].[EnquiryScoreRules_TblType] AS TABLE(
	[SNo] [bigint] NULL,
	[RuleID] [bigint] NULL,
	[EventName] [nvarchar](100) NULL,
	[CategoryName] [nvarchar](100) NULL,
	[RuleDescription] [nvarchar](255) NULL,
	[Operation] [nvarchar](50) NULL,
	[Points] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[entities]    Script Date: 06-06-26 11:00:30 ******/
CREATE TYPE [dbo].[entities] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[entity] [nvarchar](20) NULL,
	[entityid] [bigint] NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[entities_withcontent]    Script Date: 06-06-26 11:00:31 ******/
CREATE TYPE [dbo].[entities_withcontent] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[entity] [nvarchar](20) NULL,
	[entityid] [bigint] NULL,
	[actiondetails] [nvarchar](max) NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[ExporterAPILeadTableType]    Script Date: 06-06-26 11:00:32 ******/
CREATE TYPE [dbo].[ExporterAPILeadTableType] AS TABLE(
	[ExporterKey] [nvarchar](500) NULL,
	[Exporter_inq_id] [nvarchar](50) NULL,
	[Exporter_enq_date] [nvarchar](50) NULL,
	[name] [nvarchar](200) NULL,
	[mobile] [nvarchar](50) NULL,
	[email] [nvarchar](500) NULL,
	[subject] [nvarchar](500) NULL,
	[product] [nvarchar](500) NULL,
	[detail_req] [nvarchar](max) NULL,
	[company] [nvarchar](500) NULL,
	[country] [nvarchar](200) NULL,
	[state] [nvarchar](200) NULL,
	[city] [nvarchar](200) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[FacebookLeadgen]    Script Date: 06-06-26 11:00:32 ******/
CREATE TYPE [dbo].[FacebookLeadgen] AS TABLE(
	[Id] [bigint] NULL,
	[LeadgenId] [nvarchar](255) NULL,
	[JsonData] [nvarchar](max) NULL,
	[ParentId] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[fbFieldMap]    Script Date: 06-06-26 11:00:32 ******/
CREATE TYPE [dbo].[fbFieldMap] AS TABLE(
	[FbQuetions] [nvarchar](max) NULL,
	[FbFieldType] [nvarchar](max) NULL,
	[FbFieldName] [nvarchar](max) NULL,
	[EnquiryFieldName] [nvarchar](500) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[FbFieldMappingData]    Script Date: 06-06-26 11:00:33 ******/
CREATE TYPE [dbo].[FbFieldMappingData] AS TABLE(
	[RowNo] [bigint] NULL,
	[Id] [bigint] NULL,
	[fbFieldName] [nvarchar](1000) NULL,
	[enquiryFieldName] [nvarchar](1000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[fbLeadEnquiry]    Script Date: 06-06-26 11:00:33 ******/
CREATE TYPE [dbo].[fbLeadEnquiry] AS TABLE(
	[Id] [int] NOT NULL,
	[colName] [nvarchar](500) NULL,
	[colValue] [nvarchar](500) NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[fbSourceMapping]    Script Date: 06-06-26 11:00:34 ******/
CREATE TYPE [dbo].[fbSourceMapping] AS TABLE(
	[LeadSource] [varchar](200) NULL,
	[EnquiryField] [varchar](200) NULL,
	[EnquiryFieldValue] [varchar](200) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[funcParamValueType]    Script Date: 06-06-26 11:00:35 ******/
CREATE TYPE [dbo].[funcParamValueType] AS TABLE(
	[id] [int] NULL,
	[fParamId] [bigint] NULL,
	[ParamName] [nvarchar](255) NULL,
	[ParamType] [nvarchar](255) NULL,
	[ParamValue] [nvarchar](max) NULL,
	[fieldId] [bigint] NULL,
	[ParentId] [bigint] NULL,
	[created_on] [datetime] NULL,
	[isProcess] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[GoogleFieldMapping]    Script Date: 06-06-26 11:00:35 ******/
CREATE TYPE [dbo].[GoogleFieldMapping] AS TABLE(
	[Id] [int] NULL,
	[GoogleFieldName] [nvarchar](1000) NULL,
	[LdFieldName] [nvarchar](1000) NULL,
	[IsProccessed] [bit] NULL DEFAULT ((0))
)
GO

/****** Object:  UserDefinedTableType [dbo].[IndiaMartLeadTableType]    Script Date: 06-06-26 11:00:36 ******/
CREATE TYPE [dbo].[IndiaMartLeadTableType] AS TABLE(
	[DATE_R] [nvarchar](100) NULL,
	[QUERY_ID] [nvarchar](200) NULL,
	[QTYPE] [nvarchar](200) NULL,
	[SENDERNAME] [nvarchar](200) NULL,
	[SENDEREMAIL] [nvarchar](200) NULL,
	[MOB] [nvarchar](50) NULL,
	[GLUSR_USR_COMPANYNAME] [nvarchar](500) NULL,
	[ENQ_ADDRESS] [nvarchar](max) NULL,
	[ENQ_CITY] [nvarchar](100) NULL,
	[ENQ_STATE] [nvarchar](100) NULL,
	[COUNTRY_ISO] [nvarchar](50) NULL,
	[PRODUCT_NAME] [nvarchar](500) NULL,
	[ENQ_MESSAGE] [nvarchar](max) NULL,
	[SUBJECT] [nvarchar](500) NULL,
	[DATE_TIME_RE] [nvarchar](100) NULL,
	[LOG_TIME] [nvarchar](100) NULL,
	[ENQ_CALL_DURATION] [nvarchar](50) NULL,
	[ENQ_RECEIVER_MOB] [nvarchar](50) NULL,
	[EMAIL_ALT] [nvarchar](200) NULL,
	[MOBILE_ALT] [nvarchar](50) NULL,
	[PHONE] [nvarchar](50) NULL,
	[PHONE_ALT] [nvarchar](50) NULL,
	[INDIAMARTKEY] [nvarchar](200) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[larcCondition]    Script Date: 06-06-26 11:00:36 ******/
CREATE TYPE [dbo].[larcCondition] AS TABLE(
	[sr] [int] NULL,
	[Id] [bigint] NULL,
	[FieldName] [nvarchar](255) NULL,
	[FieldOpText] [nvarchar](255) NULL,
	[FieldValue] [nvarchar](max) NULL,
	[FieldOpId] [nvarchar](255) NULL,
	[FieldPlaceholder] [nvarchar](255) NULL,
	[FieldOpSign] [nvarchar](255) NULL,
	[larcRulesId] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LeadActivity_Tbltype]    Script Date: 06-06-26 11:00:36 ******/
CREATE TYPE [dbo].[LeadActivity_Tbltype] AS TABLE(
	[LeadID] [bigint] NULL,
	[UserID] [bigint] NULL,
	[ParentID] [bigint] NULL,
	[EventDescription] [nvarchar](max) NULL,
	[EventName] [nvarchar](500) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LeadActivitywithid_Tbltype]    Script Date: 06-06-26 11:00:37 ******/
CREATE TYPE [dbo].[LeadActivitywithid_Tbltype] AS TABLE(
	[LeadID] [bigint] NULL,
	[UserID] [bigint] NULL,
	[ParentID] [bigint] NULL,
	[EventDescription] [nvarchar](max) NULL,
	[EventName] [nvarchar](500) NULL,
	[RefTable] [nvarchar](100) NULL,
	[refid] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LeadMessageTbltype]    Script Date: 06-06-26 11:00:37 ******/
CREATE TYPE [dbo].[LeadMessageTbltype] AS TABLE(
	[BatchID] [bigint] NOT NULL,
	[leadid] [bigint] NULL,
	[U_ID] [int] NOT NULL,
	[Mobile] [varchar](20) NULL,
	[Message] [nvarchar](2500) NULL,
	[ScheduledDate] [varchar](50) NULL,
	[ScheduledTime] [varchar](50) NULL,
	[SenderID] [nchar](20) NULL,
	[IsPrority] [tinyint] NULL,
	[IsAllowDND] [tinyint] NULL,
	[IsUniCode] [bit] NOT NULL,
	[SmppID] [tinyint] NOT NULL,
	[MobileSubSet] [bigint] NULL,
	[MessageStatus] [varchar](20) NULL,
	[isflash] [bit] NULL,
	[sms_source] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LeadMessageTbltype1]    Script Date: 06-06-26 11:00:37 ******/
CREATE TYPE [dbo].[LeadMessageTbltype1] AS TABLE(
	[TemplateID] [bigint] NOT NULL,
	[BatchID] [bigint] NOT NULL,
	[leadid] [bigint] NULL,
	[U_ID] [int] NOT NULL,
	[Mobile] [varchar](20) NULL,
	[Message] [nvarchar](2500) NULL,
	[ScheduledDate] [varchar](50) NULL,
	[ScheduledTime] [varchar](50) NULL,
	[SenderID] [nchar](20) NULL,
	[IsPrority] [tinyint] NULL,
	[IsAllowDND] [tinyint] NULL,
	[IsUniCode] [bit] NOT NULL,
	[SmppID] [tinyint] NOT NULL,
	[MobileSubSet] [bigint] NULL,
	[MessageStatus] [varchar](20) NULL,
	[isflash] [bit] NULL,
	[sms_source] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LeadScoreAttributes]    Script Date: 06-06-26 11:00:38 ******/
CREATE TYPE [dbo].[LeadScoreAttributes] AS TABLE(
	[SNo] [int] NULL,
	[EventAttribute] [nvarchar](100) NULL,
	[Operator] [nvarchar](50) NULL,
	[ComparisonValue] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LeadScoreRules_TblType]    Script Date: 06-06-26 11:00:38 ******/
CREATE TYPE [dbo].[LeadScoreRules_TblType] AS TABLE(
	[SNo] [int] NULL,
	[RuleID] [bigint] NULL,
	[EventName] [nvarchar](200) NULL,
	[CategoryName] [nvarchar](200) NULL,
	[RuleDescription] [nvarchar](max) NULL,
	[Operation] [nvarchar](50) NULL,
	[Points] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Leadsinserted]    Script Date: 06-06-26 11:00:38 ******/
CREATE TYPE [dbo].[Leadsinserted] AS TABLE(
	[leadsinserted] [bigint] IDENTITY(1,1) NOT NULL,
	[LeadID] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Mail_EmailsReport]    Script Date: 06-06-26 11:00:39 ******/
CREATE TYPE [dbo].[Mail_EmailsReport] AS TABLE(
	[Mail_GUID] [nvarchar](50) NOT NULL,
	[Mail_ID] [bigint] NOT NULL,
	[Mail_FromEmail] [varchar](100) NOT NULL,
	[Mail_ToEmail] [varchar](100) NOT NULL,
	[Mail_Subject] [nvarchar](250) NULL,
	[Mail_TempleteName] [nvarchar](100) NULL,
	[Messages] [nvarchar](max) NULL,
	[Mail_InsertedDate] [nvarchar](50) NULL,
	[Mail_UserID] [int] NULL,
	[ReplyTo] [varchar](100) NULL,
	[Mail_BatchID] [bigint] NULL,
	[Mail_Priority] [int] NULL,
	[Mail_ScheduleDate] [nvarchar](50) NULL,
	[Mail_Attechement] [varchar](500) NULL,
	[Mail_TempleteBody] [nvarchar](max) NULL,
	[smtpserver] [nvarchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Mail_Parse_again]    Script Date: 06-06-26 11:00:39 ******/
CREATE TYPE [dbo].[Mail_Parse_again] AS TABLE(
	[ID] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Massfollowup]    Script Date: 06-06-26 11:00:40 ******/
CREATE TYPE [dbo].[Massfollowup] AS TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[entityid] [bigint] NULL,
	[AssignedTo] [bigint] NULL,
	[FollowUpStatus] [int] NULL,
	[NextStatusDate] [varchar](50) NULL,
	[Products] [nvarchar](1000) NULL,
	[AmountPaid] [numeric](18, 2) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[ModifiedBy] [bigint] NULL,
	[modifiedon] [datetime] NULL,
	[IsReAssign] [bit] NULL DEFAULT ((0)),
	[Productsjson] [nvarchar](4000) NULL,
	[followupdate] [datetime] NULL,
	[actiontype] [varchar](50) NULL,
	PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[Multi_lihid]    Script Date: 06-06-26 11:00:41 ******/
CREATE TYPE [dbo].[Multi_lihid] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[lihid] [bigint] NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[multiactivity]    Script Date: 06-06-26 11:00:42 ******/
CREATE TYPE [dbo].[multiactivity] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ActivityID] [bigint] NULL,
	[Context] [nvarchar](20) NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[MultiActivity_lih]    Script Date: 06-06-26 11:00:43 ******/
CREATE TYPE [dbo].[MultiActivity_lih] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[leadno] [bigint] NULL,
	[parentid] [bigint] NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[ObdSaveType]    Script Date: 06-06-26 11:00:44 ******/
CREATE TYPE [dbo].[ObdSaveType] AS TABLE(
	[Id] [bigint] NULL,
	[MobileNos] [nvarchar](20) NULL,
	[is_processed] [bit] NULL DEFAULT ((0))
)
GO

/****** Object:  UserDefinedTableType [dbo].[OfflineCustFieldsType]    Script Date: 06-06-26 11:00:45 ******/
CREATE TYPE [dbo].[OfflineCustFieldsType] AS TABLE(
	[EnquiryID] [bigint] NULL,
	[fieldID] [bigint] NULL,
	[fieldvalue] [nvarchar](4000) NULL,
	[mobileno] [nvarchar](100) NULL,
	[emailid] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[OfflineEnquiryType]    Script Date: 06-06-26 11:00:45 ******/
CREATE TYPE [dbo].[OfflineEnquiryType] AS TABLE(
	[EnquiryId] [bigint] NULL,
	[PersonName] [nvarchar](200) NULL,
	[PersonImage] [nvarchar](500) NULL,
	[CompanyName] [nvarchar](200) NULL,
	[MobileNo] [nvarchar](50) NULL,
	[MobileNo1] [nvarchar](50) NULL,
	[MobileNo2] [nvarchar](50) NULL,
	[EmailId] [nvarchar](200) NULL,
	[EmailId1] [nvarchar](200) NULL,
	[EmailId2] [nvarchar](200) NULL,
	[CountryCode] [nvarchar](100) NULL,
	[CountryCode1] [nvarchar](100) NULL,
	[CountryCode2] [nvarchar](100) NULL,
	[SourceName] [bigint] NULL,
	[Medium] [bigint] NULL,
	[Campaign] [bigint] NULL,
	[InitialRemarks] [nvarchar](1000) NULL,
	[CountryName] [nvarchar](100) NULL,
	[State] [nvarchar](100) NULL,
	[City] [nvarchar](100) NULL,
	[Pincode] [nvarchar](20) NULL,
	[WhereAddress] [nvarchar](500) NULL,
	[WhereLatitude] [nvarchar](50) NULL,
	[WhereLongitude] [nvarchar](50) NULL,
	[ResidentialAddress] [nvarchar](500) NULL,
	[OfficeAddress] [nvarchar](500) NULL,
	[EntityId] [bigint] NULL,
	[EntityType] [nvarchar](50) NULL,
	[PageCode] [nvarchar](50) NULL,
	[CreatedTimeStamp] [bigint] NULL,
	[UpdatedTimeStamp] [bigint] NULL,
	[ActionType] [nvarchar](50) NULL,
	[Stage] [nvarchar](50) NULL,
	[ReminderDate] [datetime] NULL,
	[Remark] [nvarchar](1000) NULL,
	[Owner] [bigint] NULL,
	[ParentID] [bigint] NULL,
	[CreatedBy] [bigint] NULL,
	[EnquiryTags] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[OfflineLeadFollowupType]    Script Date: 06-06-26 11:00:46 ******/
CREATE TYPE [dbo].[OfflineLeadFollowupType] AS TABLE(
	[LeadId] [bigint] NULL,
	[AssignedTo] [bigint] NULL,
	[FollowUpStatus] [varchar](50) NULL,
	[NextStatusDate] [varchar](50) NULL,
	[Products] [varchar](1000) NULL,
	[AmountPaid] [numeric](18, 2) NULL,
	[Remarks] [nvarchar](2000) NULL,
	[UserId] [bigint] NULL,
	[IsReassign] [bit] NULL,
	[ParentId] [bigint] NULL,
	[NotifyBySMS] [bit] NULL,
	[NotifyByEmail] [bit] NULL,
	[SmsScheduelDateTime] [varchar](50) NULL,
	[EmailScheduelDateTime] [varchar](50) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[OfflineLeadType]    Script Date: 06-06-26 11:00:46 ******/
CREATE TYPE [dbo].[OfflineLeadType] AS TABLE(
	[LeadId] [bigint] NULL,
	[ParentID] [bigint] NULL,
	[PersonName] [nvarchar](200) NULL,
	[PersonImage] [nvarchar](max) NULL,
	[CompanyName] [nvarchar](500) NULL,
	[MobileNo] [varchar](100) NULL,
	[MobileNo1] [varchar](100) NULL,
	[MobileNo2] [varchar](100) NULL,
	[EmailID] [varchar](100) NULL,
	[EmailID1] [varchar](100) NULL,
	[EmailID2] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](100) NULL,
	[Country] [varchar](100) NULL,
	[CountryCode] [varchar](50) NULL,
	[CountryCode1] [varchar](50) NULL,
	[CountryCode2] [varchar](50) NULL,
	[PinCode] [bigint] NULL,
	[ResidentialAddress] [nvarchar](500) NULL,
	[OfficialAddress] [nvarchar](500) NULL,
	[SourceName] [bigint] NULL,
	[MediumName] [bigint] NULL,
	[CampaignName] [bigint] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[CreatedBy] [bigint] NULL,
	[AssignedTo] [bigint] NULL,
	[FollowUpStatus] [int] NULL,
	[NextStatusDate] [varchar](50) NULL,
	[Products] [varchar](1000) NULL,
	[AmountPaid] [numeric](18, 2) NULL,
	[FollowUpRemarks] [varchar](1000) NULL,
	[WhereAddress] [nvarchar](255) NULL,
	[WhereLatitude] [nvarchar](255) NULL,
	[WhereLongitude] [nvarchar](255) NULL,
	[LeadTags] [nvarchar](max) NULL,
	[IsReassign] [int] NULL,
	[FollowupDate] [datetime] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[OfflineTaskType]    Script Date: 06-06-26 11:00:46 ******/
CREATE TYPE [dbo].[OfflineTaskType] AS TABLE(
	[Id] [bigint] NULL,
	[Title] [varchar](255) NULL,
	[Description] [varchar](1000) NULL,
	[Remarks] [varchar](500) NULL,
	[Address] [varchar](500) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[LeadId] [bigint] NULL,
	[AssignedTo] [bigint] NULL,
	[IsActive] [bit] NULL,
	[TaskId] [bigint] NULL,
	[Status] [varchar](255) NULL,
	[CreatedBy] [bigint] NULL,
	[OutcomesId] [bigint] NULL,
	[CollabratoerUserIds] [varchar](1000) NULL,
	[IsSMS] [bit] NULL,
	[IsEmail] [bit] NULL,
	[IsTask] [bit] NULL,
	[IsAppointment] [bit] NULL,
	[IsCompleted] [bit] NULL,
	[TaskType] [varchar](100) NULL,
	[CompleteAddress] [varchar](500) NULL,
	[Latitude] [varchar](50) NULL,
	[Longitude] [varchar](50) NULL,
	[SmsSchedule] [varchar](50) NULL,
	[EmailSchedule] [varchar](50) NULL,
	[NotifyMe] [bit] NULL,
	[DLTTemplateIDForSMSReminder] [nvarchar](200) NULL,
	[DLTTemplateIDForNotification] [nvarchar](200) NULL,
	[AppVersion] [nvarchar](100) NULL,
	[CreatedTimeStamp] [bigint] NULL,
	[UpdatedTimeStamp] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[PageDocTBLType]    Script Date: 06-06-26 11:00:47 ******/
CREATE TYPE [dbo].[PageDocTBLType] AS TABLE(
	[DocPath] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[parentids]    Script Date: 06-06-26 11:00:47 ******/
CREATE TYPE [dbo].[parentids] AS TABLE(
	[parentid] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[PermissionStageType]    Script Date: 06-06-26 11:00:47 ******/
CREATE TYPE [dbo].[PermissionStageType] AS TABLE(
	[UserId] [int] NULL,
	[ParentId] [int] NULL,
	[TeamCode] [varchar](50) NULL,
	[TeamName] [varchar](200) NULL,
	[RoleCode] [varchar](50) NULL,
	[RoleName] [varchar](200) NULL,
	[ModuleCode] [varchar](50) NULL,
	[ModuleName] [varchar](200) NULL,
	[ScopeCode] [varchar](50) NULL,
	[Add] [bit] NULL,
	[Edit] [bit] NULL,
	[View] [bit] NULL,
	[Delete] [bit] NULL,
	[Search] [bit] NULL,
	[Import] [bit] NULL,
	[Export] [bit] NULL,
	[MassUpdate] [bit] NULL,
	[MassDelete] [bit] NULL,
	[Standard1] [bit] NULL,
	[Standard2] [bit] NULL,
	[Standard3] [bit] NULL,
	[Standard4] [bit] NULL,
	[Standard5] [bit] NULL,
	[Download] [bit] NULL,
	[Print] [bit] NULL,
	[AddTask] [bit] NULL,
	[AddAppointment] [bit] NULL,
	[AddFollowup] [bit] NULL,
	[AddNote] [bit] NULL,
	[SendSms] [bit] NULL,
	[SendMail] [bit] NULL,
	[Special1] [bit] NULL,
	[Special2] [bit] NULL,
	[Special3] [bit] NULL,
	[Special4] [bit] NULL,
	[Special5] [bit] NULL,
	[SendVoice] [bit] NULL,
	[MergeLead] [bit] NULL,
	[SendWhatsapp] [bit] NULL,
	[UploadDocument] [bit] NULL,
	[DeleteDocument] [bit] NULL,
	[AddDeal] [bit] NULL,
	[AddTax] [bit] NULL,
	[AddQuotation] [bit] NULL,
	[AddInvoice] [bit] NULL,
	[AddWebform] [bit] NULL,
	[AddCustomField] [bit] NULL,
	[MassAssign] [bit] NULL,
	[MassSMS] [bit] NULL,
	[MassEmail] [bit] NULL,
	[MassBroadcast] [bit] NULL,
	[Type] [varchar](50) NULL,
	[EntityActionMappingCode] [varchar](100) NULL,
	[EntitySpActionMappingCode] [varchar](100) NULL,
	[EntitySpAction2MappingCode] [varchar](100) NULL,
	[IsInternal] [bit] NULL,
	[URL] [varchar](500) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[pipelinelostreasonTbl_type]    Script Date: 06-06-26 11:00:48 ******/
CREATE TYPE [dbo].[pipelinelostreasonTbl_type] AS TABLE(
	[Reason] [nvarchar](150) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[pipelinelostreasonTbl_types]    Script Date: 06-06-26 11:00:48 ******/
CREATE TYPE [dbo].[pipelinelostreasonTbl_types] AS TABLE(
	[ID] [bigint] NULL,
	[Reason] [nvarchar](150) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[pipelineTbl_type]    Script Date: 06-06-26 11:00:49 ******/
CREATE TYPE [dbo].[pipelineTbl_type] AS TABLE(
	[Name] [nvarchar](500) NULL,
	[Probability] [numeric](5, 2) NULL,
	[Sequence] [int] NULL,
	[IsDefault] [bit] NULL,
	[IsEditable] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[pipelineTbl_type_ForUpdate]    Script Date: 06-06-26 11:00:49 ******/
CREATE TYPE [dbo].[pipelineTbl_type_ForUpdate] AS TABLE(
	[Name] [nvarchar](500) NULL,
	[Probability] [numeric](5, 2) NULL,
	[Sequence] [int] NULL,
	[IsDefault] [bit] NULL,
	[IsEditable] [bit] NULL,
	[StageID] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[ProductFileURL_Type]    Script Date: 06-06-26 11:00:49 ******/
CREATE TYPE [dbo].[ProductFileURL_Type] AS TABLE(
	[ID] [int] NULL,
	[FileURL] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[ProductImport]    Script Date: 06-06-26 11:00:50 ******/
CREATE TYPE [dbo].[ProductImport] AS TABLE(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IsGoods] [bit] NULL,
	[IsServices] [bit] NULL,
	[IsDigitalService] [bit] NULL,
	[ProductName] [nvarchar](100) NULL,
	[SKU] [nvarchar](50) NULL,
	[Unit] [nvarchar](100) NULL,
	[HSNCode] [nvarchar](50) NULL,
	[SACCode] [nvarchar](50) NULL,
	[IsTaxable] [bit] NULL,
	[HomeStateTax] [nvarchar](max) NULL,
	[OtherTax] [nvarchar](max) NULL,
	[SalesPrice] [numeric](18, 2) NULL,
	[CastPrice] [numeric](18, 2) NULL,
	[DecimalRateQuantity] [int] NULL,
	[Description] [nvarchar](200) NULL,
	[ProductTags] [nvarchar](max) NULL,
	[Category] [nvarchar](200) NULL,
	[IsPublished] [bit] NULL,
	[IsFeatured] [bit] NULL,
	[IsActive] [bit] NULL,
	[UserID] [bigint] NULL,
	[IsSaleable] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[RecursiveReplace]    Script Date: 06-06-26 11:00:50 ******/
CREATE TYPE [dbo].[RecursiveReplace] AS TABLE(
	[displaykey] [nvarchar](200) NULL,
	[value] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[RulePriorityType]    Script Date: 06-06-26 11:00:50 ******/
CREATE TYPE [dbo].[RulePriorityType] AS TABLE(
	[SRNo] [int] NULL,
	[RuleId] [bigint] NULL,
	[PriorityNo] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Rulesparsed]    Script Date: 06-06-26 11:00:51 ******/
CREATE TYPE [dbo].[Rulesparsed] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ruleid] [bigint] NULL,
	[Attribute] [nvarchar](200) NULL,
	[operator] [nvarchar](50) NULL,
	[value] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[SaleActivityQueueType]    Script Date: 06-06-26 11:00:51 ******/
CREATE TYPE [dbo].[SaleActivityQueueType] AS TABLE(
	[EntityName] [nvarchar](255) NULL,
	[EntityId] [bigint] NULL,
	[ActivityId] [bigint] NULL,
	[IsProcessed] [int] NULL,
	[ErrorDescription] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[SalesTargetChild_Tbltypes]    Script Date: 06-06-26 11:00:51 ******/
CREATE TYPE [dbo].[SalesTargetChild_Tbltypes] AS TABLE(
	[SalesTargetId] [bigint] NULL,
	[TeamCode] [nvarchar](50) NULL,
	[UserId] [bigint] NULL,
	[Target] [numeric](18, 2) NULL,
	[IsActive] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[SendMassVoiceTblType]    Script Date: 06-06-26 11:00:52 ******/
CREATE TYPE [dbo].[SendMassVoiceTblType] AS TABLE(
	[row_no] [int] NOT NULL,
	[LeadId] [bigint] NOT NULL,
	[BatchID] [bigint] NOT NULL,
	[country_code] [nvarchar](5) NULL,
	[didno] [nvarchar](100) NOT NULL,
	[Mobile] [varchar](20) NULL,
	[voiceDuration] [bigint] NULL,
	[AppId] [bigint] NULL,
	[IsDnd] [int] NULL,
	[IsPrority] [int] NULL,
	[price] [decimal](8, 2) NULL,
	[user_id] [bigint] NOT NULL,
	[voice_type] [int] NOT NULL,
	[route] [nvarchar](max) NULL,
	[parentid] [bigint] NULL,
	[voice_source] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Serv_Dispatch_Act_Type]    Script Date: 06-06-26 11:00:52 ******/
CREATE TYPE [dbo].[Serv_Dispatch_Act_Type] AS TABLE(
	[TResp_Rule_Id] [bigint] NULL,
	[Parentid] [bigint] NULL,
	[Action] [nvarchar](20) NULL,
	[Act_Value] [nvarchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Serv_Dispatch_Filt_Type]    Script Date: 06-06-26 11:00:52 ******/
CREATE TYPE [dbo].[Serv_Dispatch_Filt_Type] AS TABLE(
	[TResp_Rule_Id] [bigint] NULL,
	[ParentID] [bigint] NULL,
	[Filter_Field] [nvarchar](20) NULL,
	[Filter_Cond] [nvarchar](20) NULL,
	[Filter_Value] [nvarchar](20) NULL,
	[Filter_FldType] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[Serv_tickttbl_Order]    Script Date: 06-06-26 11:00:53 ******/
CREATE TYPE [dbo].[Serv_tickttbl_Order] AS TABLE(
	[ID] [bigint] NULL,
	[ord_no] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[SMSUrl_Link]    Script Date: 06-06-26 11:00:53 ******/
CREATE TYPE [dbo].[SMSUrl_Link] AS TABLE(
	[user_id] [bigint] NULL,
	[long_url] [nvarchar](max) NULL,
	[short_url] [nvarchar](200) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[SMSUrl_Link_auth]    Script Date: 06-06-26 11:00:53 ******/
CREATE TYPE [dbo].[SMSUrl_Link_auth] AS TABLE(
	[Parentid] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[SMSUrl_Link_new]    Script Date: 06-06-26 11:00:54 ******/
CREATE TYPE [dbo].[SMSUrl_Link_new] AS TABLE(
	[user_id] [bigint] NULL,
	[long_url] [nvarchar](max) NULL,
	[short_url] [nvarchar](200) NULL,
	[lAction] [varchar](50) NULL,
	[CMobile] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[subject] [varchar](100) NULL,
	[Body] [varchar](max) NULL,
	[wmobile] [varchar](20) NULL,
	[wtext] [varchar](max) NULL,
	[ccall] [int] NULL,
	[wcall] [int] NULL,
	[ecall] [int] NULL,
	[ocall] [int] NULL,
	[P_url] [varchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TabSortOrder]    Script Date: 06-06-26 11:00:54 ******/
CREATE TYPE [dbo].[TabSortOrder] AS TABLE(
	[Id] [int] NOT NULL,
	[CustomDashboardOrder] [int] NOT NULL,
	[IsVisible] [bit] NOT NULL,
	[CustomDashboard] [nvarchar](500) NOT NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TawkToMapping]    Script Date: 06-06-26 11:00:54 ******/
CREATE TYPE [dbo].[TawkToMapping] AS TABLE(
	[Id] [int] NULL,
	[TtcFieldName] [nvarchar](1000) NULL,
	[EnFieldName] [nvarchar](1000) NULL,
	[DefaultValue] [nvarchar](1000) NULL,
	[IsProccessed] [bit] NULL DEFAULT ((0))
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_BatchIDs]    Script Date: 06-06-26 11:00:55 ******/
CREATE TYPE [dbo].[tbl_BatchIDs] AS TABLE(
	[Mail_BatchID] [nvarchar](200) NULL,
	[Count] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_cd_TilesMaster]    Script Date: 06-06-26 11:00:55 ******/
CREATE TYPE [dbo].[tbl_cd_TilesMaster] AS TABLE(
	[SectionID] [int] NULL,
	[ReportName] [nvarchar](255) NULL,
	[PositionX] [int] NULL,
	[PositionY] [int] NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[Value] [int] NULL,
	[UserId] [int] NULL,
	[CustomDashboardId] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_Cloud_Notification]    Script Date: 06-06-26 11:00:56 ******/
CREATE TYPE [dbo].[tbl_Cloud_Notification] AS TABLE(
	[NotificationId] [int] NOT NULL,
	[Activity] [varchar](100) NULL,
	[Notification_Type] [varchar](100) NULL,
	[Active] [bit] NULL,
	[Alert_Duration] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_Cloud_phpurch]    Script Date: 06-06-26 11:00:56 ******/
CREATE TYPE [dbo].[tbl_Cloud_phpurch] AS TABLE(
	[User_id] [bigint] NOT NULL,
	[Phone_no] [varchar](100) NULL,
	[Cost] [int] NULL,
	[PhoneType] [varchar](100) NULL,
	[Category] [varchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_Cloud_Plan_Coupen]    Script Date: 06-06-26 11:00:56 ******/
CREATE TYPE [dbo].[tbl_Cloud_Plan_Coupen] AS TABLE(
	[CoupenCode] [varchar](50) NULL,
	[Planid] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_Cloud_subs_trn]    Script Date: 06-06-26 11:00:57 ******/
CREATE TYPE [dbo].[tbl_Cloud_subs_trn] AS TABLE(
	[id] [int] NULL,
	[Trans_id] [int] NULL,
	[TransDate] [datetime] NULL,
	[Trans_Type] [varchar](100) NULL,
	[Sub_Amount] [int] NULL,
	[Add_onUser] [int] NULL,
	[Add_onPhone] [int] NULL,
	[qty] [int] NULL,
	[months] [int] NULL,
	[Amount] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_CloudManualUser]    Script Date: 06-06-26 11:00:57 ******/
CREATE TYPE [dbo].[tbl_CloudManualUser] AS TABLE(
	[User_id] [bigint] NULL,
	[group_id] [int] NULL,
	[User_login] [varchar](100) NULL,
	[Pwd] [varchar](100) NULL,
	[Fname] [varchar](100) NULL,
	[Lname] [varchar](100) NULL,
	[Mobile] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[Active] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_CloudUser]    Script Date: 06-06-26 11:00:57 ******/
CREATE TYPE [dbo].[tbl_CloudUser] AS TABLE(
	[User_id] [bigint] NULL,
	[User_login] [varchar](100) NULL,
	[Pwd] [varchar](100) NULL,
	[Fname] [varchar](100) NULL,
	[Lname] [varchar](100) NULL,
	[Mobile] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[Active] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_Intexcp]    Script Date: 06-06-26 11:00:58 ******/
CREATE TYPE [dbo].[tbl_Intexcp] AS TABLE(
	[User_id] [bigint] NULL,
	[country_code] [varchar](20) NULL,
	[Price] [varchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_IntMobtbl]    Script Date: 06-06-26 11:00:58 ******/
CREATE TYPE [dbo].[tbl_IntMobtbl] AS TABLE(
	[row_no] [int] NOT NULL,
	[user_id] [bigint] NULL,
	[message] [nvarchar](max) NULL,
	[unicode] [bit] NULL,
	[credit] [float] NULL,
	[BatchID] [bigint] NOT NULL,
	[Country_code] [varchar](10) NULL,
	[Mobile] [varchar](20) NULL,
	[MessageStatus] [varchar](20) NULL,
	[SenderID] [nchar](20) NULL,
	[ScheduledDate] [varchar](50) NULL,
	[ScheduledTime] [varchar](50) NULL,
	[SmppID] [tinyint] NOT NULL,
	[U_ID] [int] NOT NULL,
	[IsUniCode] [bit] NOT NULL,
	[IsDnd] [bit] NOT NULL,
	[MobileSubSet] [bigint] NULL,
	[IsPrority] [tinyint] NULL,
	[IsAllowDND] [tinyint] NULL,
	[price] [float] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_PrdSqlType5]    Script Date: 06-06-26 11:00:58 ******/
CREATE TYPE [dbo].[tbl_PrdSqlType5] AS TABLE(
	[ProductID] [bigint] NULL,
	[Qty] [bigint] NULL,
	[Total] [varchar](10) NULL,
	[Price] [numeric](18, 2) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_Response]    Script Date: 06-06-26 11:00:59 ******/
CREATE TYPE [dbo].[tbl_Response] AS TABLE(
	[ScopeId] [varchar](20) NULL,
	[ResponseId] [varchar](10) NULL,
	[ResponseText] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_SenderIDs]    Script Date: 06-06-26 11:00:59 ******/
CREATE TYPE [dbo].[tbl_SenderIDs] AS TABLE(
	[Sender_ID] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_sm_UserDetails]    Script Date: 06-06-26 11:00:59 ******/
CREATE TYPE [dbo].[tbl_sm_UserDetails] AS TABLE(
	[UserId] [bigint] NULL,
	[kuser_name] [varchar](500) NULL,
	[user_img] [varchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_type_sm_UserDetails]    Script Date: 06-06-26 11:01:00 ******/
CREATE TYPE [dbo].[tbl_type_sm_UserDetails] AS TABLE(
	[UserId] [bigint] NULL,
	[kuser_name] [varchar](500) NULL,
	[user_img] [varchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_updtwebapiType]    Script Date: 06-06-26 11:01:00 ******/
CREATE TYPE [dbo].[tbl_updtwebapiType] AS TABLE(
	[WebAPIentryid] [bigint] NULL,
	[api_processed] [tinyint] NULL,
	[api_resp] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_UserUrlType5]    Script Date: 06-06-26 11:01:00 ******/
CREATE TYPE [dbo].[tbl_UserUrlType5] AS TABLE(
	[urlID] [bigint] NULL,
	[url_dtl] [varchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_webapiType]    Script Date: 06-06-26 11:01:01 ******/
CREATE TYPE [dbo].[tbl_webapiType] AS TABLE(
	[apiid] [bigint] NULL,
	[webapi] [nvarchar](max) NULL,
	[baseapi] [nvarchar](max) NULL,
	[method] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_webctrlType]    Script Date: 06-06-26 11:01:01 ******/
CREATE TYPE [dbo].[tbl_webctrlType] AS TABLE(
	[urlID] [bigint] NULL,
	[ctrl_dtl] [nvarchar](max) NULL,
	[ctrl_lbl] [nvarchar](max) NULL,
	[ctrl_type] [nvarchar](max) NULL,
	[opt_label] [nvarchar](max) NULL,
	[main_id] [nvarchar](max) NULL,
	[usrctrl_dtl] [varchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_webctrlTypeNew]    Script Date: 06-06-26 11:01:02 ******/
CREATE TYPE [dbo].[tbl_webctrlTypeNew] AS TABLE(
	[urlID] [bigint] NULL,
	[ctrl_dtl] [nvarchar](max) NULL,
	[ctrl_lbl] [nvarchar](max) NULL,
	[ctrl_type] [nvarchar](max) NULL,
	[opt_label] [nvarchar](max) NULL,
	[main_id] [nvarchar](max) NULL,
	[usrctrl_dtl] [varchar](max) NULL,
	[ctrltype] [varchar](10) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbl_workDays]    Script Date: 06-06-26 11:01:02 ******/
CREATE TYPE [dbo].[tbl_workDays] AS TABLE(
	[Applet_id] [int] NULL,
	[flowid] [int] NOT NULL,
	[wk_days] [varchar](20) NULL,
	[Start_hour] [varchar](20) NULL,
	[End_hour] [varchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblFileRemarks]    Script Date: 06-06-26 11:01:02 ******/
CREATE TYPE [dbo].[tblFileRemarks] AS TABLE(
	[FileName] [nvarchar](500) NULL,
	[Remarks] [nvarchar](500) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblFilterCoupon]    Script Date: 06-06-26 11:01:03 ******/
CREATE TYPE [dbo].[tblFilterCoupon] AS TABLE(
	[CouponCode] [nvarchar](255) NULL,
	[UserId] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblLeadField]    Script Date: 06-06-26 11:01:03 ******/
CREATE TYPE [dbo].[tblLeadField] AS TABLE(
	[id] [bigint] NULL,
	[field_name] [nvarchar](255) NULL,
	[filed_value] [nvarchar](512) NULL,
	[is_process] [bit] NULL DEFAULT ((0))
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblObdReportType]    Script Date: 06-06-26 11:01:04 ******/
CREATE TYPE [dbo].[tblObdReportType] AS TABLE(
	[Phone] [nvarchar](255) NULL,
	[Campaign] [nvarchar](255) NULL,
	[Leadset] [nvarchar](255) NULL,
	[CallStatus] [nvarchar](255) NULL,
	[CallStartTime] [datetime] NULL,
	[CallAnsdTime] [datetime] NULL,
	[CallEndTime] [datetime] NULL,
	[RingTime] [int] NULL,
	[TalkTime] [int] NULL,
	[CallerID] [nvarchar](255) NULL,
	[RetryNo] [int] NULL,
	[HangupReason] [nvarchar](255) NULL,
	[DTMFKeyPress] [nvarchar](255) NULL,
	[DTMFPressTime] [nvarchar](255) NULL,
	[SMS1Status] [nvarchar](255) NULL,
	[SMS2Status] [nvarchar](255) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblObdStatus]    Script Date: 06-06-26 11:01:04 ******/
CREATE TYPE [dbo].[tblObdStatus] AS TABLE(
	[ObdId] [bigint] NULL,
	[Processed] [tinyint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblRequestIds]    Script Date: 06-06-26 11:01:04 ******/
CREATE TYPE [dbo].[tblRequestIds] AS TABLE(
	[Id] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblScheduleIds]    Script Date: 06-06-26 11:01:05 ******/
CREATE TYPE [dbo].[tblScheduleIds] AS TABLE(
	[ScheduledId] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblStringList]    Script Date: 06-06-26 11:01:05 ******/
CREATE TYPE [dbo].[tblStringList] AS TABLE(
	[strValue] [nvarchar](255) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_Acres99]    Script Date: 06-06-26 11:01:06 ******/
CREATE TYPE [dbo].[tblType_Acres99] AS TABLE(
	[Acres_Username] [nvarchar](500) NULL,
	[RcvdOn] [nvarchar](100) NULL,
	[ResType] [nvarchar](100) NULL,
	[QueryID] [nvarchar](200) NULL,
	[Address] [nvarchar](max) NULL,
	[QryInfo] [nvarchar](500) NULL,
	[ProjID] [nvarchar](100) NULL,
	[ProjName] [nvarchar](500) NULL,
	[PhoneVerificationStatus] [nvarchar](100) NULL,
	[EmailVerificationStatus] [nvarchar](100) NULL,
	[Acres_IDENTITY] [nvarchar](100) NULL,
	[PROPERTY_CODE] [nvarchar](100) NULL,
	[SubUserName] [nvarchar](200) NULL,
	[ProdId] [nvarchar](100) NULL,
	[ProductStatus] [nvarchar](100) NULL,
	[ProductType] [nvarchar](100) NULL,
	[Name] [nvarchar](500) NULL,
	[Email] [nvarchar](500) NULL,
	[Phone] [nvarchar](200) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_MagicBricks]    Script Date: 06-06-26 11:01:06 ******/
CREATE TYPE [dbo].[tblType_MagicBricks] AS TABLE(
	[MagicBricksKey] [nvarchar](500) NULL,
	[Name] [nvarchar](500) NULL,
	[RefID] [bigint] NULL,
	[ISD] [nvarchar](20) NULL,
	[Mobile] [nvarchar](50) NULL,
	[EmailID] [nvarchar](500) NULL,
	[MSG] [ntext] NULL,
	[Locality] [nvarchar](500) NULL,
	[City] [nvarchar](200) NULL,
	[Loginid] [nvarchar](50) NULL,
	[ph] [nvarchar](100) NULL,
	[pid] [nvarchar](50) NULL,
	[Project] [nvarchar](100) NULL,
	[Subject] [nvarchar](100) NULL,
	[DateOfContact] [nvarchar](50) NULL,
	[TimeOfContact] [nvarchar](50) NULL,
	[TranType] [nvarchar](50) NULL,
	[VTime] [nvarchar](50) NULL,
	[VDate] [nvarchar](50) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_MailTriggerReplacement]    Script Date: 06-06-26 11:01:06 ******/
CREATE TYPE [dbo].[tblType_MailTriggerReplacement] AS TABLE(
	[Mail_BatchID] [nvarchar](50) NULL,
	[Mail_UserID] [bigint] NULL,
	[Mail_ToEmail] [nvarchar](500) NULL,
	[Messages] [ntext] NULL,
	[Mail_ScheduleDate] [nvarchar](50) NULL,
	[Mail_ScheduledTime] [nvarchar](50) NULL,
	[Mail_FromEmail] [nvarchar](500) NULL,
	[Mail_Priority] [nvarchar](10) NULL,
	[TemplateID] [nvarchar](50) NULL,
	[ReplyTo] [nvarchar](500) NULL,
	[Mail_ParentID] [bigint] NULL,
	[Mail_Subject] [nvarchar](500) NULL,
	[Mail_InsertedDate] [nvarchar](50) NULL,
	[IsMonitor] [nvarchar](10) NULL,
	[Mail_TempleteName] [nvarchar](500) NULL,
	[Count] [int] NULL,
	[Source] [nvarchar](50) NULL,
	[Mail_TempleteBody] [ntext] NULL,
	[mailroute] [nvarchar](50) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_MSG_XMLAPI_Resp]    Script Date: 06-06-26 11:01:07 ******/
CREATE TYPE [dbo].[tblType_MSG_XMLAPI_Resp] AS TABLE(
	[transactionId] [nvarchar](100) NULL,
	[state] [nvarchar](100) NULL,
	[description] [nvarchar](max) NULL,
	[pdu] [nvarchar](50) NULL,
	[corelationId] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_MSG_XMLAPI_Resp_new]    Script Date: 06-06-26 11:01:07 ******/
CREATE TYPE [dbo].[tblType_MSG_XMLAPI_Resp_new] AS TABLE(
	[transactionId] [nvarchar](100) NULL,
	[state] [nvarchar](100) NULL,
	[description] [nvarchar](max) NULL,
	[pdu] [nvarchar](50) NULL,
	[corelationId] [nvarchar](100) NULL,
	[SenderID] [nvarchar](100) NULL,
	[Mobile] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_MSG_XMLAPI_Resp_new1]    Script Date: 06-06-26 11:01:07 ******/
CREATE TYPE [dbo].[tblType_MSG_XMLAPI_Resp_new1] AS TABLE(
	[transactionId] [nvarchar](100) NULL,
	[state] [nvarchar](100) NULL,
	[description] [nvarchar](max) NULL,
	[pdu] [nvarchar](50) NULL,
	[corelationId] [nvarchar](100) NULL,
	[SenderID] [nvarchar](100) NULL,
	[Mobile] [nvarchar](100) NULL,
	[DLT_TemplateID] [nvarchar](100) NULL,
	[DLT_PEID] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_MSG_XMLAPI_Resp_new2]    Script Date: 06-06-26 11:01:08 ******/
CREATE TYPE [dbo].[tblType_MSG_XMLAPI_Resp_new2] AS TABLE(
	[transactionId] [nvarchar](100) NULL,
	[state] [nvarchar](100) NULL,
	[statusCode] [nvarchar](100) NULL,
	[description] [nvarchar](max) NULL,
	[pdu] [nvarchar](50) NULL,
	[corelationId] [nvarchar](100) NULL,
	[SenderID] [nvarchar](100) NULL,
	[Mobile] [nvarchar](100) NULL,
	[DLT_TemplateID] [nvarchar](100) NULL,
	[DLT_PEID] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tbltype_SearchCriteriaCondition]    Script Date: 06-06-26 11:01:08 ******/
CREATE TYPE [dbo].[tbltype_SearchCriteriaCondition] AS TABLE(
	[ID] [int] NULL,
	[FieldName] [nvarchar](200) NULL,
	[FieldType] [nvarchar](200) NULL,
	[Operator] [nvarchar](200) NULL,
	[Value] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblType_VoiceBroadCast]    Script Date: 06-06-26 11:01:08 ******/
CREATE TYPE [dbo].[tblType_VoiceBroadCast] AS TABLE(
	[isVoice] [bit] NULL,
	[AppID] [bigint] NULL,
	[Duration] [int] NULL,
	[DNID] [nvarchar](100) NULL,
	[Frequency] [int] NULL,
	[Latency] [int] NULL,
	[Route] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblTypeForVoiceBroadCast]    Script Date: 06-06-26 11:01:09 ******/
CREATE TYPE [dbo].[tblTypeForVoiceBroadCast] AS TABLE(
	[IsVoice] [bit] NULL,
	[AppID] [bigint] NULL,
	[Duration] [int] NULL,
	[DNID] [nvarchar](20) NULL,
	[Frequency] [int] NULL,
	[Latency] [int] NULL,
	[Route] [nvarchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tblTypeSearchCriteria]    Script Date: 06-06-26 11:01:09 ******/
CREATE TYPE [dbo].[tblTypeSearchCriteria] AS TABLE(
	[ID] [int] NULL,
	[ColumnName] [nvarchar](100) NULL,
	[Operator] [nvarchar](100) NULL,
	[Value] [nvarchar](100) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TicketMails_Tbltype]    Script Date: 06-06-26 11:01:09 ******/
CREATE TYPE [dbo].[TicketMails_Tbltype] AS TABLE(
	[Ser_User_Id] [bigint] NULL,
	[parentid] [bigint] NULL,
	[FromMail] [nvarchar](500) NULL,
	[MailDate] [datetime] NULL,
	[MailSubject] [nvarchar](max) NULL,
	[MailContent] [nvarchar](max) NULL,
	[DateCreated] [datetime] NULL,
	[ToEmail] [nvarchar](max) NULL,
	[requester] [nvarchar](500) NULL,
	[ticketNo] [nvarchar](50) NULL,
	[msgid] [nvarchar](2000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tpGoalMileStoneReq]    Script Date: 06-06-26 11:01:10 ******/
CREATE TYPE [dbo].[tpGoalMileStoneReq] AS TABLE(
	[entityName] [nvarchar](25) NULL,
	[entityId] [bigint] NULL,
	[eventName] [nvarchar](25) NULL,
	[eventId] [bigint] NULL,
	[agentId] [bigint] NULL,
	[eventFullname] [nvarchar](255) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TradeIndiaDataTableType]    Script Date: 06-06-26 11:01:10 ******/
CREATE TYPE [dbo].[TradeIndiaDataTableType] AS TABLE(
	[TradeIndiaKey] [nvarchar](1000) NULL,
	[Trade_UserID] [nvarchar](100) NULL,
	[Trade_ProfileID] [nvarchar](100) NULL,
	[address] [nvarchar](max) NULL,
	[ago_time] [nvarchar](100) NULL,
	[att_data] [nvarchar](max) NULL,
	[attachment_cnt] [nvarchar](100) NULL,
	[fax_number] [nvarchar](100) NULL,
	[generated] [nvarchar](200) NULL,
	[generated_date] [nvarchar](200) NULL,
	[generated_time] [nvarchar](100) NULL,
	[inquiry_type] [nvarchar](200) NULL,
	[landline_number] [nvarchar](100) NULL,
	[member_since] [nvarchar](200) NULL,
	[message] [ntext] NULL,
	[month_slot] [nvarchar](200) NULL,
	[order_value_min] [nvarchar](100) NULL,
	[pref_supp_location] [nvarchar](max) NULL,
	[product_id] [nvarchar](100) NULL,
	[product_name] [nvarchar](500) NULL,
	[product_source] [nvarchar](200) NULL,
	[quantity] [nvarchar](200) NULL,
	[receiver_co] [nvarchar](500) NULL,
	[receiver_mobile] [nvarchar](100) NULL,
	[receiver_name] [nvarchar](200) NULL,
	[receiver_uid] [nvarchar](100) NULL,
	[responded] [nvarchar](100) NULL,
	[rfi_id] [nvarchar](100) NULL,
	[sender] [nvarchar](200) NULL,
	[sender_city] [nvarchar](200) NULL,
	[sender_co] [nvarchar](500) NULL,
	[sender_country] [nvarchar](200) NULL,
	[sender_email] [nvarchar](500) NULL,
	[sender_mobile] [nvarchar](100) NULL,
	[sender_name] [nvarchar](200) NULL,
	[sender_other_emails] [nvarchar](500) NULL,
	[sender_other_mobiles] [nvarchar](100) NULL,
	[sender_state] [nvarchar](200) NULL,
	[sender_uid] [nvarchar](100) NULL,
	[source] [nvarchar](200) NULL,
	[subject] [nvarchar](500) NULL,
	[unread_res_cnt] [nvarchar](100) NULL,
	[view_status] [nvarchar](100) NULL,
	[website] [nvarchar](500) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TradeIndiaDataTableType_1]    Script Date: 06-06-26 11:01:11 ******/
CREATE TYPE [dbo].[TradeIndiaDataTableType_1] AS TABLE(
	[TradeIndiaKey] [nvarchar](1000) NULL,
	[Trade_UserID] [nvarchar](200) NULL,
	[Trade_ProfileID] [nvarchar](200) NULL,
	[address] [nvarchar](max) NULL,
	[ago_time] [nvarchar](200) NULL,
	[att_data] [nvarchar](max) NULL,
	[attachment_cnt] [nvarchar](200) NULL,
	[fax_number] [nvarchar](200) NULL,
	[generated] [nvarchar](400) NULL,
	[generated_date] [nvarchar](400) NULL,
	[generated_time] [nvarchar](200) NULL,
	[inquiry_type] [nvarchar](400) NULL,
	[landline_number] [nvarchar](200) NULL,
	[member_since] [nvarchar](400) NULL,
	[message] [ntext] NULL,
	[month_slot] [nvarchar](400) NULL,
	[order_value_min] [nvarchar](200) NULL,
	[pref_supp_location] [nvarchar](max) NULL,
	[product_id] [nvarchar](200) NULL,
	[product_name] [nvarchar](1000) NULL,
	[product_source] [nvarchar](400) NULL,
	[quantity] [nvarchar](400) NULL,
	[receiver_co] [nvarchar](1000) NULL,
	[receiver_mobile] [nvarchar](200) NULL,
	[receiver_name] [nvarchar](400) NULL,
	[receiver_uid] [nvarchar](200) NULL,
	[responded] [nvarchar](200) NULL,
	[rfi_id] [nvarchar](200) NULL,
	[sender] [nvarchar](400) NULL,
	[sender_city] [nvarchar](400) NULL,
	[sender_co] [nvarchar](1000) NULL,
	[sender_country] [nvarchar](400) NULL,
	[sender_email] [nvarchar](1000) NULL,
	[sender_mobile] [nvarchar](200) NULL,
	[sender_name] [nvarchar](400) NULL,
	[sender_other_emails] [nvarchar](1000) NULL,
	[sender_other_mobiles] [nvarchar](200) NULL,
	[sender_state] [nvarchar](400) NULL,
	[sender_uid] [nvarchar](200) NULL,
	[source] [nvarchar](400) NULL,
	[subject] [nvarchar](1000) NULL,
	[unread_res_cnt] [nvarchar](200) NULL,
	[view_status] [nvarchar](200) NULL,
	[website] [nvarchar](1000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TradeIndiaDataTableType_2]    Script Date: 06-06-26 11:01:11 ******/
CREATE TYPE [dbo].[TradeIndiaDataTableType_2] AS TABLE(
	[TradeIndiaKey] [nvarchar](max) NULL,
	[Trade_UserID] [nvarchar](max) NULL,
	[Trade_ProfileID] [nvarchar](max) NULL,
	[address] [nvarchar](max) NULL,
	[ago_time] [nvarchar](max) NULL,
	[att_data] [nvarchar](max) NULL,
	[attachment_cnt] [nvarchar](max) NULL,
	[fax_number] [nvarchar](max) NULL,
	[generated] [nvarchar](max) NULL,
	[generated_date] [nvarchar](max) NULL,
	[generated_time] [nvarchar](max) NULL,
	[inquiry_type] [nvarchar](max) NULL,
	[landline_number] [nvarchar](max) NULL,
	[member_since] [nvarchar](max) NULL,
	[message] [ntext] NULL,
	[month_slot] [nvarchar](max) NULL,
	[order_value_min] [nvarchar](max) NULL,
	[pref_supp_location] [nvarchar](max) NULL,
	[product_id] [nvarchar](max) NULL,
	[product_name] [nvarchar](max) NULL,
	[product_source] [nvarchar](max) NULL,
	[quantity] [nvarchar](max) NULL,
	[receiver_co] [nvarchar](max) NULL,
	[receiver_mobile] [nvarchar](max) NULL,
	[receiver_name] [nvarchar](max) NULL,
	[receiver_uid] [nvarchar](max) NULL,
	[responded] [nvarchar](max) NULL,
	[rfi_id] [nvarchar](max) NULL,
	[sender] [nvarchar](max) NULL,
	[sender_city] [nvarchar](max) NULL,
	[sender_co] [nvarchar](max) NULL,
	[sender_country] [nvarchar](max) NULL,
	[sender_email] [nvarchar](max) NULL,
	[sender_mobile] [nvarchar](max) NULL,
	[sender_name] [nvarchar](max) NULL,
	[sender_other_emails] [nvarchar](max) NULL,
	[sender_other_mobiles] [nvarchar](max) NULL,
	[sender_state] [nvarchar](max) NULL,
	[sender_uid] [nvarchar](max) NULL,
	[source] [nvarchar](max) NULL,
	[subject] [nvarchar](max) NULL,
	[unread_res_cnt] [nvarchar](max) NULL,
	[view_status] [nvarchar](max) NULL,
	[website] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TradeIndiaDataTableType_3]    Script Date: 06-06-26 11:01:11 ******/
CREATE TYPE [dbo].[TradeIndiaDataTableType_3] AS TABLE(
	[TradeIndiaKey] [nvarchar](1000) NULL,
	[Trade_UserID] [nvarchar](200) NULL,
	[Trade_ProfileID] [nvarchar](200) NULL,
	[address] [nvarchar](max) NULL,
	[ago_time] [nvarchar](200) NULL,
	[att_data] [nvarchar](max) NULL,
	[attachment_cnt] [nvarchar](200) NULL,
	[fax_number] [nvarchar](200) NULL,
	[generated] [nvarchar](400) NULL,
	[generated_date] [nvarchar](400) NULL,
	[generated_time] [nvarchar](200) NULL,
	[inquiry_type] [nvarchar](400) NULL,
	[landline_number] [nvarchar](200) NULL,
	[member_since] [nvarchar](400) NULL,
	[message] [ntext] NULL,
	[month_slot] [nvarchar](400) NULL,
	[order_value_min] [nvarchar](200) NULL,
	[pref_supp_location] [nvarchar](max) NULL,
	[product_id] [nvarchar](200) NULL,
	[product_name] [nvarchar](1000) NULL,
	[product_source] [nvarchar](400) NULL,
	[quantity] [nvarchar](400) NULL,
	[receiver_co] [nvarchar](1000) NULL,
	[receiver_mobile] [nvarchar](200) NULL,
	[receiver_name] [nvarchar](400) NULL,
	[receiver_uid] [nvarchar](200) NULL,
	[responded] [nvarchar](200) NULL,
	[rfi_id] [nvarchar](200) NULL,
	[sender] [nvarchar](400) NULL,
	[sender_city] [nvarchar](400) NULL,
	[sender_co] [nvarchar](1000) NULL,
	[sender_country] [nvarchar](400) NULL,
	[sender_email] [nvarchar](1000) NULL,
	[sender_mobile] [nvarchar](200) NULL,
	[sender_name] [nvarchar](400) NULL,
	[sender_other_emails] [nvarchar](1000) NULL,
	[sender_other_mobiles] [nvarchar](max) NULL,
	[sender_state] [nvarchar](400) NULL,
	[sender_uid] [nvarchar](200) NULL,
	[source] [nvarchar](400) NULL,
	[subject] [nvarchar](1000) NULL,
	[unread_res_cnt] [nvarchar](200) NULL,
	[view_status] [nvarchar](200) NULL,
	[website] [nvarchar](1000) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TradeIndiaResponseTableType]    Script Date: 06-06-26 11:01:12 ******/
CREATE TYPE [dbo].[TradeIndiaResponseTableType] AS TABLE(
	[ResponseDate] [datetime] NULL,
	[TradeIndiaKey] [nvarchar](1000) NULL,
	[TradeIndiaUserID] [nvarchar](100) NULL,
	[TradeIndiaProfileID] [nvarchar](100) NULL,
	[Response] [nvarchar](500) NULL,
	[Message] [nvarchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tsk_FollowUpType_List]    Script Date: 06-06-26 11:01:12 ******/
CREATE TYPE [dbo].[tsk_FollowUpType_List] AS TABLE(
	[Id] [int] NULL,
	[FollowupStatus] [varchar](100) NULL,
	[OrderNumber] [int] NULL,
	[Intent] [varchar](50) NULL,
	[IsCallback] [bit] NULL,
	[IsConvert] [bit] NULL,
	[IsDisabled] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tsk_Operend_List]    Script Date: 06-06-26 11:01:12 ******/
CREATE TYPE [dbo].[tsk_Operend_List] AS TABLE(
	[Id] [int] NULL,
	[TypeofForm] [varchar](200) NULL,
	[Operand1] [varchar](200) NULL,
	[Operator] [varchar](200) NULL,
	[Operand2] [varchar](150) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tsk_Outcome_List]    Script Date: 06-06-26 11:01:13 ******/
CREATE TYPE [dbo].[tsk_Outcome_List] AS TABLE(
	[Id] [int] NULL,
	[Name] [varchar](255) NULL,
	[Sequence] [int] NULL,
	[Indent] [varchar](50) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tsk_UserAction_List]    Script Date: 06-06-26 11:01:13 ******/
CREATE TYPE [dbo].[tsk_UserAction_List] AS TABLE(
	[userType] [varchar](30) NULL,
	[hasView] [bit] NULL,
	[hasEdit] [bit] NULL,
	[hasRemove] [bit] NULL,
	[hasCompletion] [bit] NULL,
	[hasComment] [bit] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TVP_ml_StorageInformation]    Script Date: 06-06-26 11:01:13 ******/
CREATE TYPE [dbo].[TVP_ml_StorageInformation] AS TABLE(
	[Parentid] [bigint] NULL,
	[UserStorage] [decimal](18, 2) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[tyLocationData]    Script Date: 06-06-26 11:01:14 ******/
CREATE TYPE [dbo].[tyLocationData] AS TABLE(
	[UserLocationTrackingId] [bigint] IDENTITY(1,1) NOT NULL,
	[MovementCode] [varchar](20) NULL,
	[Remarks] [varchar](1000) NULL,
	[UserId] [bigint] NULL,
	[LocationDateTime] [datetime] NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[Address] [nvarchar](500) NULL,
	[BatteryPerc] [float] NULL,
	[NetworkPerc] [float] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsMock] [bit] NULL,
	[IsBulk] [bit] NULL,
	[Speed] [varchar](50) NULL,
	[Distance] [varchar](50) NULL,
	[LocationMetaData] [nvarchar](max) NULL DEFAULT (N'{}'),
	[IsDistanceCalc] [bit] NULL DEFAULT ((0))
)
GO

/****** Object:  UserDefinedTableType [dbo].[TypeAdwordsAD_PERFORMANCE_REPORT]    Script Date: 06-06-26 11:01:15 ******/
CREATE TYPE [dbo].[TypeAdwordsAD_PERFORMANCE_REPORT] AS TABLE(
	[CampaignId] [varchar](50) NULL,
	[CampaignName] [varchar](250) NULL,
	[AdGroupId] [varchar](50) NULL,
	[AdGroupName] [varchar](500) NULL,
	[Status] [varchar](50) NULL,
	[Impressions] [float] NULL,
	[Interactions] [float] NULL,
	[InteractionRate] [float] NULL,
	[AverageCost] [money] NULL,
	[Cost] [money] NULL,
	[AverageCpc] [money] NULL,
	[AverageCpm] [money] NULL,
	[Conversions] [float] NULL,
	[CostPerAllConversion] [float] NULL,
	[ConversionRate] [float] NULL,
	[CampaignStatus] [varchar](50) NULL,
	[Clicks] [bigint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TypeAdwordsAdgroup_PERFORMANCE_REPORT]    Script Date: 06-06-26 11:01:15 ******/
CREATE TYPE [dbo].[TypeAdwordsAdgroup_PERFORMANCE_REPORT] AS TABLE(
	[AdGroupId] [bigint] NULL,
	[AdGroupName] [varchar](500) NULL,
	[AdGroupStatus] [varchar](50) NULL,
	[AverageCost] [money] NULL,
	[AverageCpc] [money] NULL,
	[AverageCpe] [float] NULL,
	[AverageCpm] [float] NULL,
	[CampaignId] [varchar](50) NULL,
	[CampaignName] [varchar](250) NULL,
	[CampaignStatus] [varchar](50) NULL,
	[Clicks] [bigint] NULL,
	[ConversionRate] [float] NULL,
	[Conversions] [float] NULL,
	[ConversionValue] [float] NULL,
	[Cost] [money] NULL,
	[CpcBid] [varchar](50) NULL,
	[CpmBid] [varchar](50) NULL,
	[CpvBid] [varchar](50) NULL,
	[Ctr] [float] NULL,
	[Impressions] [float] NULL,
	[InteractionRate] [float] NULL,
	[Interactions] [float] NULL,
	[InteractionTypes] [varchar](500) NULL,
	[TargetCpa] [varchar](50) NULL,
	[TargetCpaBidSource] [varchar](500) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TypeAdwordsBUDGET_PERFORMANCE_REPORT]    Script Date: 06-06-26 11:01:15 ******/
CREATE TYPE [dbo].[TypeAdwordsBUDGET_PERFORMANCE_REPORT] AS TABLE(
	[Amount] [money] NULL,
	[AssociatedCampaignId] [bigint] NULL,
	[AssociatedCampaignName] [varchar](250) NULL,
	[AssociatedCampaignStatus] [varchar](50) NULL,
	[AverageCost] [money] NULL,
	[AverageCpc] [varchar](50) NULL,
	[AverageCpe] [varchar](50) NULL,
	[AverageCpm] [varchar](50) NULL,
	[AverageCpv] [varchar](50) NULL,
	[BudgetId] [bigint] NULL,
	[BudgetName] [varchar](50) NULL,
	[BudgetStatus] [varchar](50) NULL,
	[Clicks] [bigint] NULL,
	[ConversionRate] [float] NULL,
	[Conversion] [float] NULL,
	[Cost] [float] NULL,
	[Ctr] [varchar](50) NULL,
	[Impressions] [float] NULL,
	[InteractionRate] [float] NULL,
	[Interactions] [float] NULL,
	[InteractionTypes] [varchar](250) NULL,
	[RecommendedBudgetAmount] [float] NULL,
	[RecommendedBudgetEstimatedChangeInWeeklyClicks] [float] NULL,
	[RecommendedBudgetEstimatedChangeInWeeklyCost] [float] NULL,
	[RecommendedBudgetEstimatedChangeInWeeklyInteractions] [float] NULL,
	[RecommendedBudgetEstimatedChangeInWeeklyViews] [float] NULL,
	[TotalAmount] [float] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TypeAdwordsCampaign_PERFORMANCE_REPORT]    Script Date: 06-06-26 11:01:16 ******/
CREATE TYPE [dbo].[TypeAdwordsCampaign_PERFORMANCE_REPORT] AS TABLE(
	[AverageCost] [money] NULL,
	[AverageCpc] [money] NULL,
	[CampaignGroupId] [bigint] NULL,
	[CampaignId] [varchar](50) NULL,
	[CampaignName] [varchar](250) NULL,
	[CampaignStatus] [varchar](50) NULL,
	[Clicks] [bigint] NULL,
	[ConversionRate] [float] NULL,
	[Conversions] [float] NULL,
	[ConversionValue] [float] NULL,
	[Cost] [money] NULL,
	[CostPerConversion] [money] NULL,
	[Ctr] [float] NULL,
	[Impressions] [float] NULL,
	[InteractionRate] [float] NULL,
	[Interactions] [float] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[TypeAdwordsCriteriaPerformenceReport]    Script Date: 06-06-26 11:01:16 ******/
CREATE TYPE [dbo].[TypeAdwordsCriteriaPerformenceReport] AS TABLE(
	[CampAd_id] [varchar](50) NULL,
	[AdwordGroupId] [varchar](50) NULL,
	[AdwordKeywordId] [bigint] NULL,
	[CriteriaType] [varchar](500) NULL,
	[Keyword_Placement] [varchar](2500) NULL,
	[FinalURL] [nvarchar](max) NULL,
	[Clicks] [bigint] NULL,
	[Impressions] [bigint] NULL,
	[Cost] [float] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[typeFieldSequence]    Script Date: 06-06-26 11:01:17 ******/
CREATE TYPE [dbo].[typeFieldSequence] AS TABLE(
	[fieldId] [bigint] NULL,
	[sequenceNo] [int] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[updSMSUrl_Link]    Script Date: 06-06-26 11:01:17 ******/
CREATE TYPE [dbo].[updSMSUrl_Link] AS TABLE(
	[mobile_url_id] [bigint] NULL,
	[long_url] [nvarchar](max) NULL,
	[Mobile] [varchar](20) NULL,
	[status] [tinyint] NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[UserMessagesType]    Script Date: 06-06-26 11:01:18 ******/
CREATE TYPE [dbo].[UserMessagesType] AS TABLE(
	[msisdn] [nvarchar](14) NOT NULL,
	[msg] [nvarchar](320) NOT NULL,
	[Msgdate] [nvarchar](20) NOT NULL,
	[Msgtime] [nvarchar](20) NULL,
	[status] [nvarchar](3) NOT NULL,
	[userName] [nvarchar](30) NOT NULL,
	[emailflag] [nvarchar](10) NOT NULL,
	[grp_name] [nvarchar](50) NOT NULL,
	[retry_attempt_count] [int] NULL,
	[status_update_datetime] [nvarchar](100) NULL,
	[emailid] [nvarchar](50) NULL,
	[sender_flag] [nvarchar](5) NULL,
	[receiver_name] [nvarchar](50) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[UT_Link]    Script Date: 06-06-26 11:01:18 ******/
CREATE TYPE [dbo].[UT_Link] AS TABLE(
	[IsVoice] [bit] NOT NULL,
	[AppID] [bigint] NULL,
	[Duration] [int] NULL,
	[DNID] [nvarchar](20) NULL,
	[Frequency] [int] NULL,
	[Latency] [int] NULL,
	[Route] [nvarchar](20) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[wa_recipients]    Script Date: 06-06-26 11:01:18 ******/
CREATE TYPE [dbo].[wa_recipients] AS TABLE(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parentID] [bigint] NULL,
	[waid] [nvarchar](50) NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/****** Object:  UserDefinedTableType [dbo].[WixFieldMapping]    Script Date: 06-06-26 11:01:20 ******/
CREATE TYPE [dbo].[WixFieldMapping] AS TABLE(
	[Id] [int] NULL,
	[wixFieldName] [nvarchar](1000) NULL,
	[EnFieldName] [nvarchar](1000) NULL,
	[DefaultValue] [nvarchar](1000) NULL,
	[IsProccessed] [bit] NULL DEFAULT ((0))
)
GO

