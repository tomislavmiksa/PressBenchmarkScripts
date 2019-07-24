/*******************************************************************************/
/****** Creates Call Mode Table                                           ******/
/****** Author: Tomislav Miksa                                            ******/
/****** v1.00: CREATE                                                     ******/
/*******************************************************************************/

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execeution...')
-------------------------------------------------------------------------------------------------------
-- !!! USER INPUT
-- OPERATOR NAMES
-------------------------------------------------------------------------------------------------------
DECLARE @operator1 varchar(20) = 'Telekom%'
DECLARE @operator2 varchar(20) = 'Vodafone%'
DECLARE @operator3 varchar(20) = 'o2%'
DECLARE @operator4 varchar(20) = null
DECLARE @operator5 varchar(20) = null

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_OPERATORS_PRIORITY_2018 creating...')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_OPERATORS_PRIORITY_2018' AND type = 'U')	DROP TABLE NEW_OPERATORS_PRIORITY_2018
	CREATE TABLE NEW_OPERATORS_PRIORITY_2018 (SequenceNumber int,Operator varchar(20))
	IF @operator1 is not null INSERT INTO  NEW_OPERATORS_PRIORITY_2018 (SequenceNumber,Operator) SELECT 1,@operator1
	IF @operator2 is not null INSERT INTO  NEW_OPERATORS_PRIORITY_2018 (SequenceNumber,Operator) SELECT 2,@operator2
	IF @operator3 is not null INSERT INTO  NEW_OPERATORS_PRIORITY_2018 (SequenceNumber,Operator) SELECT 3,@operator3
	IF @operator4 is not null INSERT INTO  NEW_OPERATORS_PRIORITY_2018 (SequenceNumber,Operator) SELECT 4,@operator4
	IF @operator5 is not null INSERT INTO  NEW_OPERATORS_PRIORITY_2018 (SequenceNumber,Operator) SELECT 5,@operator5

-------------------------------------------------------------------------------------------------------
-- !!! USER INPUT
-- IMSI - MSISDN RELATION (USER INPUT)
-- 1st Column: IMSI in form of wildcard '%232015030056332%'
-- 2nd Column: MSISDN to be used
-- 3rd Column: Beginning when relation is valid (in case when provisioning in middle of camaping)
-- 4th Column: End when relation is valid (in case when provisioning in middle of camaping)
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_ImsiMsisdn_2018 creating...')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_ImsiMsisdn_2018' AND type = 'U')	DROP TABLE NEW_ImsiMsisdn_2018
	CREATE TABLE NEW_ImsiMsisdn_2018 (IMSI varchar(17),MSISDN varchar(15), Start_Time datetime2(3), End_Time datetime2(3))
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182729%','4917622758332',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182728%','4917622758478',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182727%','4917622758487',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182726%','4917622758492',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182725%','4917622758500',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182724%','4917622758654',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182723%','4917622758662',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182722%','4917622758666',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262073985182721%','4917622758675',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689191%','491728659690',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262021708738057%','491737026609',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262021708738021%','491724093626',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262021607960225%','491735231510',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262021607960223%','491735232764',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689204%','491728658420',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689201%','491728659187',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689200%','491728659452',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689190%','491728659733',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011403482627%','491712244898',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011205239081%','491709689434',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011403482623%','491712266382',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011202989052%','4915117947869',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011202989043%','4915117944252',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011202989045%','4915117944947',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011202989044%','4915117944456',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011205239082%','491709692287',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011202989051%','4915117947257',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')

	
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011403482624%','491712221375',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011403482626%','491712281402',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262011202986319%','4915151502907',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262021607960224%','491735231703',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689189%','491728659887',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689202%','491728659090',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')

	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689186%','491728660318',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689184%','491728660438',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262029923689194%','491728659676',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')
	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262021607960230%','491735270853',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')

	INSERT INTO  NEW_ImsiMsisdn_2018 (IMSI,MSISDN,Start_Time,End_Time) SELECT '%262021607960229%','491735270868',CONVERT(datetime,'Jan 01 12:00:00 2017'),CONVERT(datetime,'Jan 01 12:00:00 2020')

GO
-------------------------------------------------------------------------------------------------------
-- TRANSLATING PROTOCOL TO SQL INPUT
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Translating Protocol to #TempProtocol...')
	IF OBJECT_ID ('tempdb..#TempProtocol' ) IS NOT NULL     DROP TABLE #TempProtocol
	SELECT C.ID,
		   C.[ProtocolID]
		  ,C.[Task]
		  ,C.[Actions]
		  ,C.[Start_Time]
		  ,C.[End_Time]
		  ,C.[Duration(m)]
		  ,[Level_1] AS Level_1
		  ,REPLACE(Level_2,'_',' ') AS Level_2    
		  ,REPLACE(Level_3,'_',' ') AS Level_3
		  ,[Level_4] AS Level_4
		  ,[Level_5] AS Level_5      
		  ,C.[Remarks]
		  ,C.[Train_Type]
		  ,C.[Train_Name]
		  ,C.[Wagon_Number]
		  ,C.[Repeater_Wagon]
		  ,B.[System_Name]
		  ,B.[System_Type]
		  ,B.[Operator]
		  ,B.[Channel]
		  ,B.[Channel_description]
		  ,B.[UE]
		  ,B.[IMEI]
		  ,B.[IMSI]
		  ,A.[FileName]
		  ,A.[Project]
	  INTO #TempProtocol
	  FROM [NC_Protocol] C
	  LEFT OUTER JOIN [NC_Protocol_Daily]  A ON A.ProtocolID = C.ProtocolID
	  LEFT OUTER JOIN [NC_Protocol_System] B ON B.ProtocolID = C.ProtocolID

-------------------------------------------------------------------------------------------------------
-- TESTS
-- Table: Sessions
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting All Sessions...')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_GLEVEL_Sessions_2018' AND type = 'U')	DROP TABLE NEW_GLEVEL_Sessions_2018
	SELECT DISTINCT 
	     SessionId
		,CAST(null as bigint)		 AS FileId
		,CAST(null as datetime2(3))  AS Session_Start
		,CAST(null as int          ) AS ProtocolID				
		,CAST(null as varchar(200) ) AS FileName				
		,CAST(null as varchar(100) ) AS Actions					
		,CAST(null as varchar(200) ) AS Project					
		,CAST(null as varchar(100) ) AS System_Name				
		,CAST(null as varchar(100) ) AS System_Type				
		,CAST(null as varchar(100) ) AS Channel					
		,CAST(null as varchar(100) ) AS Channel_description		
		,CAST(null as varchar(100) ) AS UE						
		,CAST(null as varchar(100) ) AS IMEI					
		,CAST(null as varchar(100) ) AS IMSI
		,CAST(null as varchar(15) )  AS MSISDN					
		,CAST(null as varchar(100) ) AS Level_1					
		,CAST(null as varchar(8000)) AS Level_2					
		,CAST(null as varchar(8000)) AS Level_3					
		,CAST(null as varchar(100) ) AS Level_4					
		,CAST(null as varchar(100) ) AS Level_5					
		,CAST(null as varchar(8000)) AS Remarks
		,CAST(null as varchar(100) ) AS Train_Type				
		,CAST(null as varchar(100) ) AS Train_Name				
		,CAST(null as varchar(100) ) AS Wagon_Number			
		,CAST(null as varchar(100) ) AS Repeater_Wagon	
	INTO NEW_GLEVEL_Sessions_2018
	FROM
	(select SessionId from Sessions 
	 union all
	 select SessionId from SessionsB) AS INPUT

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update FileId...')
	UPDATE NEW_GLEVEL_Sessions_2018
	SET FileId = b.FileId
	FROM NEW_GLEVEL_Sessions_2018 a
	LEFT OUTER JOIN Sessions b on a.SessionId = b.SessionId
	WHERE b.SessionId is not null

	UPDATE NEW_GLEVEL_Sessions_2018
	SET FileId = b.FileId
	FROM NEW_GLEVEL_Sessions_2018 a
	LEFT OUTER JOIN SessionsB b on a.SessionId = b.SessionId
	WHERE b.SessionId is not null

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update Session Timestamps...')
	UPDATE NEW_GLEVEL_Sessions_2018
	SET Session_Start = b.startTime
	FROM NEW_GLEVEL_Sessions_2018 a
	LEFT OUTER JOIN Sessions b on a.SessionId = b.SessionId
	WHERE b.SessionId is not null

	UPDATE NEW_GLEVEL_Sessions_2018
	SET Session_Start = b.startTime
	FROM NEW_GLEVEL_Sessions_2018 a
	LEFT OUTER JOIN SessionsB b on a.SessionId = b.SessionId
	WHERE b.SessionId is not null

GO
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update IMSI...')
	UPDATE NEW_GLEVEL_Sessions_2018
	SET  IMSI = b.IMSI
	FROM NEW_GLEVEL_Sessions_2018 a
	LEFT OUTER JOIN filelist b on a.FileId like b.FileId

GO
 PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update G_Levels...')
 	UPDATE NEW_GLEVEL_Sessions_2018
 	SET
		 ProtocolID          = b.ProtocolID
		,FileName            = b.FileName
		,Actions             = b.Actions
		,Project             = b.Project
		,Repeater_Wagon      = b.Repeater_Wagon
		,System_Name         = b.System_Name
		,System_Type         = b.System_Type
		,Channel             = b.Channel
		,Channel_description = b.Channel_description
		,UE                  = b.UE
		,IMEI                = b.IMEI
		,Level_1             = b.Level_1
		,Level_2             = b.Level_2
		,Level_3             = b.Level_3
		,Level_4             = b.Level_4
		,Level_5             = b.Level_5
		,Remarks             = b.Remarks
		,Train_Type          = b.Train_Type
		,Train_Name          = b.Train_Name
		,Wagon_Number        = b.Wagon_Number
 	FROM NEW_GLEVEL_Sessions_2018 a
 	LEFT OUTER JOIN #TempProtocol b on a.IMSI like b.IMSI and a.Session_Start between b.Start_Time and b.End_Time

GO
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update MSISDN...')
	UPDATE NEW_GLEVEL_Sessions_2018
	SET  MSISDN = b.MSISDN
	FROM NEW_GLEVEL_Sessions_2018 a
	LEFT OUTER JOIN NEW_ImsiMsisdn_2018 b on a.IMSI like b.IMSI

GO
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CLEANUP...')
	UPDATE NEW_GLEVEL_Sessions_2018 
	SET Level_5 = ''
	FROM NEW_GLEVEL_Sessions_2018
	WHERE Level_1 LIKE 'Walk' AND Level_2 LIKE 'Train'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script Execution COMPLETED!')

-- SELECT * FROM NEW_GLEVEL_Sessions_2018 ORDER BY SessionId