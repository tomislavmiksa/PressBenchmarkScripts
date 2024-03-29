/*******************************************************************************/
/****** Creates Call Mode Table                                           ******/
/****** Author: Tomislav Miksa                                            ******/
/****** v2.00: Better Performance, G_Location removed brom basic script   ******/
/****** v3.00: Added Base Tables for Both Voice Sessions and Tests        ******/
/*******************************************************************************/

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execeution...')
-------------------------------------------------------------------------------------------------------
-- SYSTEM NAME TABLE (USER INPUT)
-------------------------------------------------------------------------------------------------------
-- set Zone --
update FileList set Zone ='System 55' where zone='Benchmarker 05' and ASideLocation like 'BM5%' 
update FileList set Zone ='System 22' where zone='Benchmarker 02' and ASideLocation like 'BM2%'
update FileList set Zone ='System 0' where zone='system 0' and ASideLocation like 'FR%'
update FileList set Zone ='System 0' where zone='Benchmarker 02' and ASideLocation like 'FR%'
update FileList set Zone ='System 0' where zone='Benchmarker 01' and ASideLocation like 'FR%'
update FileList set Zone ='System 55' where zone='BM05' and ASideLocation like 'BM5%' 
update FileList set Zone ='System 22' where zone='BM02' and ASideLocation like 'BM2%'
update filelist set CampaignName = 'DE Benchmark 2019 Q3' 

-- set Provider --
update filelist set provider = 'Vodafone' where provider = '262/02' and ASideLocation like '%vdf%'
update filelist set provider = 'o2 - de' where provider = '262/07' and ASideLocation like '%o2%'
update filelist set provider = 'o2 - de' where provider = '262/03' and ASideLocation like '%o2%'
update filelist set provider = 'Telekom.de' where provider = '262/01' and ASideLocation like '%tdg%'

IF OBJECT_ID ('tempdb..#SystemName' ) IS NOT NULL DROP TABLE #SystemName
	CREATE TABLE #SystemName (Zone_Name varchar(100),System_Type varchar(100), System_Name varchar(100))
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 0' ,'SwissQual Freerider III','SwissQual Freerider III'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 1' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (1)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 11','SwissQual Benchmarker II','SwissQual Benchmarker II (1)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 2' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (2)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 22','SwissQual Benchmarker II','SwissQual Benchmarker II (2)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 3' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (3)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 33','SwissQual Benchmarker II','SwissQual Benchmarker II (3)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 4' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (4)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 44','SwissQual Benchmarker II','SwissQual Benchmarker II (4)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 5' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (5)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 55','SwissQual Benchmarker II','SwissQual Benchmarker II (5)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 6' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (6)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 66','SwissQual Benchmarker II','SwissQual Benchmarker II (6)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 7' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (7)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 77','SwissQual Benchmarker II','SwissQual Benchmarker II (7)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 8' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (8)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 88','SwissQual Benchmarker II','SwissQual Benchmarker II (8)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 9' ,'SwissQual Benchmarker II','SwissQual Benchmarker II (9)'
	INSERT INTO  #SystemName (Zone_Name,System_Type,System_Name) SELECT 'System 99','SwissQual Benchmarker II','SwissQual Benchmarker II (9)'
-------------------------------------------------------------------------------------------------------
-- TEST TYPE TABLE
-------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('tempdb..#TestType' ) IS NOT NULL DROP TABLE #TestType
	CREATE TABLE #TestType (TypeOfTest varchar(100),TestName varchar(100))
	INSERT INTO  #TestType (TypeOfTest,TestName) SELECT 'Capacity'							,'httpTransfer'
	INSERT INTO  #TestType (TypeOfTest,TestName) SELECT 'httpTransfer'						,'httpTransfer'
	INSERT INTO  #TestType (TypeOfTest,TestName) SELECT 'httpBrowser'						,'httpBrowser'
	INSERT INTO  #TestType (TypeOfTest,TestName) SELECT 'YouTube No Reference Smartphone'	,'YouTube'
	INSERT INTO  #TestType (TypeOfTest,TestName) SELECT 'Ping'								,'ICMP Ping'
	INSERT INTO  #TestType (TypeOfTest,TestName) SELECT 'App%'								,'Application'
	INSERT INTO  #TestType (TypeOfTest,TestName) SELECT 'Speech-Wideband POLQA'				,'POLQA'

-------------------------------------------------------------------------------------------------------
-- CREATE VOICE CALLS TABLE WITH BASIC INFORMATION
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Creating Table: NEW_Call_Info_2018')
		IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_Call_Info_2018' AND type = 'U')	DROP TABLE [NEW_Call_Info_2018]
		SELECT
			 sb.SessionIdA     				AS      SessionId
			,sb.sessionType					AS		Session_Type
			,CASE WHEN caa.callStatus like 'System%'  or cab.callStatus like 'System%'  THEN 'System Release'
				  WHEN caa.callStatus like 'Faile%'   or cab.callStatus like 'Faile%'   THEN 'Failed'
				  WHEN caa.callStatus like 'Drop%'    or cab.callStatus like 'Drop%'    THEN 'Dropped'
				  ELSE caa.callStatus
					END AS [Call_Status]
			,caa.callDir     				AS      callDir
			,sb.SessionIdA     				AS      SessionId_A
			,CAST(null as varchar(100 ))    AS      Campaign_A
			,CAST(null as varchar(100 ))    AS      Collection_A
			,CAST(null as varchar(100 ))    AS      Test_Description_A
			,CAST(null as varchar(100 ))    AS      System_Name_A
			,CAST(null as varchar(100 ))    AS      System_Type_A
			,CAST(null as varchar(50 ))     AS      Zone_A
			,CAST(null as varchar(100 ))    AS      Location_A
			,CAST(null as varchar(20 ))    	AS      SW_A
			,CAST(null as varchar(50 ))     AS      UE_A
			,CAST(null as varchar(255 ))    AS      FW_A
			,CAST(null as varchar(100 ))    AS      IMEI_A
			,CAST(null as varchar(100 ))    AS      IMSI_A
			,CAST(null as varchar(100 ))    AS      MSISDN_A
			,caa.FileId     				AS      FileId_A
			,CAST(null as int)     			AS      Sequenz_ID_per_File_A
			,CAST(null as varchar(100 ))    AS      ASideFileName
			,caa.callStatus     			AS      callStatus_A
			,caa.setupTime     				AS      SQ_CST_A
			,caa.callStartTimeStamp     	AS      callStartTimeStamp_A
			,CASE
					WHEN caa.connAckTimeStamp is not null THEN caa.connAckTimeStamp
					ELSE caa.callSetupEndTimeStamp
					END AS callSetupEndTimestamp_A
			,caa.callDisconnectTimeStamp    AS      callDisconnectTimeStamp_A
			,caa.callEndTimeStamp     		AS      callEndTimeStamp_A
			,caa.callDuration     			AS      callDuaration_A
			,caa.NetworkId     				AS      startNetId_A
			,CAST(null as varchar(100 ))    AS      startTechnology_A
			,CAST(null as int)     			AS      numSatelites_A
			,CAST(null as float)     		AS      Altitude_A
			,CAST(null as float)     		AS      Distance_A
			,CAST(null as int)     			AS      minSpeed_A
			,CAST(null as int)     			AS      maxSpeed_A
			,caa.PosId     					AS      startPosId_A
			,CAST(null as float)     		AS      startLongitude_A
			,CAST(null as float)     		AS      startLatitude_A
			,caa.PosId     					AS      endPosId_A
			,CAST(null as float)     		AS      endLongitude_A
			,CAST(null as float)     		AS      endLatitude_A
			,sb.SessionId     				AS      SessionId_B
			,CAST(null as varchar(100 ))    AS      Campaign_B
			,CAST(null as varchar(100 ))    AS      Collection_B
			,CAST(null as varchar(100 ))    AS      Test_Description_B
			,CAST(null as varchar(100 ))    AS      System_Name_B
			,CAST(null as varchar(100 ))    AS      System_Type_B
			,CAST(null as varchar(50 ))     AS      Zone_B
			,CAST(null as varchar(100 ))    AS      Location_B
			,CAST(null as varchar(20 ))     AS      SW_B
			,CAST(null as varchar(50 ))     AS      UE_B
			,CAST(null as varchar(255 ))    AS      FW_B
			,CAST(null as varchar(100 ))    AS      IMEI_B
			,CAST(null as varchar(100 ))    AS      IMSI_B
			,CAST(null as varchar(100 ))    AS      MSISDN_B
			,cab.FileId     				AS      FileId_B
			,CAST(null as int)     			AS      Sequenz_ID_per_File_B
			,CAST(null as varchar(100 ))    AS      BSideFileName
			,cab.callStatus     			AS      callStatus_B
			,cab.setupTime     				AS      SQ_CST_B
			,cab.callStartTimeStamp     	AS      callStartTimeStamp_B
			,CASE
					WHEN cab.connAckTimeStamp is not null THEN cab.connAckTimeStamp
					ELSE cab.callSetupEndTimeStamp
					END AS callSetupEndTimestamp_B
			,cab.callDisconnectTimeStamp    AS      callDisconnectTimeStamp_B
			,cab.callEndTimeStamp     		AS      callEndTimeStamp_B
			,cab.callDuration     			AS      callDuaration_B
			,cab.NetworkId     				AS      startNetId_B
			,CAST(null as varchar(100 ))    AS      startTechnology_B
			,CAST(null as int)     			AS      numSatelites_B
			,CAST(null as float)     		AS      Altitude_B
			,CAST(null as float)     		AS      Distance_B
			,CAST(null as int)     			AS      minSpeed_B
			,CAST(null as int)     			AS      maxSpeed_B
			,cab.PosId     					AS      startPosId_B
			,CAST(null as float)     		AS      startLongitude_B
			,CAST(null as float)     		AS      startLatitude_B
			,cab.PosId     					AS      endPosId_B
			,CAST(null as float)     		AS      endLongitude_B
			,CAST(null as float)     		AS      endLatitude_B
		INTO [NEW_Call_Info_2018]
		FROM [SessionsB] sb
		LEFT OUTER JOIN [CallAnalysis] caa ON sb.SessionIdA = caa.SessionId
		LEFT OUTER JOIN [CallAnalysis] cab ON sb.SessionId  = cab.SessionId
		WHERE sb.sessionType like 'CALL'
		ORDER BY sb.SessionIdA
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table successfully created!')

-- UPDATE CALL INFO TABLE FOR WHATSAPP CALLS
	IF OBJECT_ID ('tempdb..#WhatsAppCall' ) IS NOT NULL DROP TABLE #WhatsAppCall
	select SessionId,
		   callStatus,
		   startTime,
		   cast(null as datetime2(3))	  as ServiceRequest,
		   cast(null as datetime2(3))	  as Alerting,
		   cast(null as datetime2(3))	  as callSetupEndTimestamp,
		   cast(null as datetime2(3))	  as callEndTimestamp,
		   dateadd(ms,duration,startTime) as endTime
	into #WhatsAppCall
	from
		(
		select a.SessionId,startTime,duration,b.callStatus from sessions  a left outer join CallSession b on a.SessionId  = b.SessionId where b.JobName like 'WhatsApp%'
		union all
		select a.SessionId,startTime,duration,b.callStatus from sessionsB a left outer join CallSession b on a.SessionIdA = b.SessionId where b.JobName like 'WhatsApp%'
		) a
	order by SessionId

	update #WhatsAppCall
	set ServiceRequest = b.startTime,
		callSetupEndTimestamp = b.EndTime
	from #WhatsAppCall a
	left outer join (SELECT * FROM ResultsKPI WHERE KPIId = 10103) as b on a.SessionId = b.SessionId 

	update #WhatsAppCall
	set Alerting		= b.EndTime
	from #WhatsAppCall a
	left outer join (SELECT * FROM ResultsKPI WHERE KPIId = 10106) as b on a.SessionId = b.SessionId 

	update #WhatsAppCall
	set ServiceRequest	= case when a.ServiceRequest is null then b.startTime else a.ServiceRequest end,
		Alerting		= case when a.Alerting       is null then b.EndTime   else a.Alerting end
	from #WhatsAppCall a
	left outer join (SELECT * FROM ResultsKPI WHERE KPIId = 10113) as b on a.SessionId = b.SessionId 

	update #WhatsAppCall
	set callEndTimestamp		= b.EndTime,
		callSetupEndTimestamp	= case when a.callSetupEndTimestamp is null then b.startTime else a.callSetupEndTimestamp end
	from #WhatsAppCall a
	left outer join (SELECT * FROM ResultsKPI WHERE KPIId = 20104) as b on a.SessionId = b.SessionId 

	update #WhatsAppCall
	set callEndTimestamp		= b.EndTime,
		callSetupEndTimestamp	= case when a.callSetupEndTimestamp is null then b.startTime else a.callSetupEndTimestamp end
	from #WhatsAppCall a
	left outer join (SELECT * FROM ResultsKPI WHERE KPIId = 20106) as b on a.SessionId = b.SessionId 

UPDATE NEW_Call_Info_2018
SET Session_Type = 'WhatsApp CALL'
WHERE SessionId_A in (select SessionId from #WhatsAppCall) or SessionId_B in (select SessionId from #WhatsAppCall)

UPDATE NEW_Call_Info_2018
SET callStartTimeStamp_A	   = CASE WHEN a.callStartTimeStamp_A	 	is null THEN b.ServiceRequest					ELSE a.callStartTimeStamp_A	 	 END
   ,callSetupEndTimestamp_A	   = CASE WHEN a.callSetupEndTimestamp_A	is null THEN b.callSetupEndTimestamp			ELSE a.callSetupEndTimestamp_A	 END 
   ,callDisconnectTimeStamp_A  = CASE WHEN a.callDisconnectTimeStamp_A	is null THEN b.callEndTimestamp					ELSE a.callDisconnectTimeStamp_A END
   ,callEndTimeStamp_A		   = CASE WHEN a.callEndTimeStamp_A		 	is null THEN b.endTime							ELSE a.callEndTimeStamp_A		 END	
FROM NEW_Call_Info_2018 a
LEFT OUTER JOIN #WhatsAppCall b on a.SessionId_A = b.SessionId

UPDATE NEW_Call_Info_2018
SET callStartTimeStamp_B	   = CASE WHEN a.callStartTimeStamp_B	 	is null THEN b.ServiceRequest					ELSE a.callStartTimeStamp_B	 	 END
   ,callSetupEndTimestamp_B	   = CASE WHEN a.callSetupEndTimestamp_B	is null THEN b.callSetupEndTimestamp			ELSE a.callSetupEndTimestamp_B	 END 
   ,callDisconnectTimeStamp_B  = CASE WHEN a.callDisconnectTimeStamp_B	is null THEN b.callEndTimestamp					ELSE a.callDisconnectTimeStamp_B END
   ,callEndTimeStamp_B		   = CASE WHEN a.callEndTimeStamp_B		 	is null THEN b.endTime							ELSE a.callEndTimeStamp_B		 END	
FROM NEW_Call_Info_2018 a
LEFT OUTER JOIN #WhatsAppCall b on a.SessionId_B = b.SessionId

UPDATE NEW_Call_Info_2018
SET callDuaration_A = case when callDuaration_A is null then datediff(ms,callSetupEndTimestamp_A,callEndTimeStamp_A) ELSE callDuaration_A END,
    callDuaration_B = case when callDuaration_B is null then datediff(ms,callSetupEndTimestamp_B,callEndTimeStamp_B) ELSE callDuaration_B END

-------------------------------------------------------------------------------------------------------
-- UPDATE SYSTEM NAMES, SYSTEM TYPE, SYTEM PROPERTIES
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Table: NEW_Call_Info_2018 updated with System Name')
		UPDATE NEW_Call_Info_2018
		SET Campaign_A 			= fi.CampaignName				,
			Collection_A		= fi.CollectionName				,
			Test_Description_A	= fi.TestDescription			,
			Zone_A				= fi.Zone						,
			Location_A			= fi.ASideLocation				,
			SW_A				= fi.SWVersion					,
			UE_A				= fi.ASideDevice				,
			FW_A				= fi.FirmwareV					,
			IMEI_A				= CAST(fi.IMEI AS varchar(100))	,
			IMSI_A				= CAST(fi.IMSI AS varchar(100))	,
			MSISDN_A			= fi.ASideNumber				,
			ASideFileName		= fi.ASideFileName
		FROM FileList fi  
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.FileId_A	= fi.FileId

		UPDATE NEW_Call_Info_2018
		SET System_Type_A = fi.System_Type,
			System_Name_A = fi.System_Name
		FROM #SystemName fi  
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.Zone_A	= fi.Zone_Name

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table A Side System Information successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET Campaign_B 			= fi.CampaignName				,
			Collection_B		= fi.CollectionName				,
			Test_Description_B	= fi.TestDescription			,
			Zone_B				= fi.Zone						,
			Location_B			= fi.BSideLocation				,
			SW_B				= fi.SWVersion					,
			UE_B				= fi.ASideDevice				,
			FW_B				= fi.FirmwareV					,
			IMEI_B				= CAST(fi.IMEI AS varchar(100))	,
			IMSI_B				= CAST(fi.IMSI AS varchar(100))	,
			MSISDN_B			= fi.BSideNumber				,
			BSideFileName		= fi.BSideFileName
		FROM FileList fi  
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.FileId_B	= fi.FileId

		UPDATE NEW_Call_Info_2018
		SET System_Type_B = fi.System_Type,
			System_Name_B = fi.System_Name
		FROM #SystemName fi  
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.Zone_B	= fi.Zone_Name
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table B Side System Information successfully updated!')

-------------------------------------------------------------------------------------------------------
-- UPDATE SEQUENCE WITHING FILE
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table updated with file sequence of the session')
		IF OBJECT_ID ('tempdb..#filesequence' ) IS NOT NULL DROP TABLE #filesequence
		Select SessionId_A
			  ,FileId_A
			  ,callStartTimeStamp_A
			  ,ROW_NUMBER() over (partition by FileId_A ORDER BY callStartTimeStamp_A) as Seq_id_A
			  ,SessionId_B
			  ,FileId_B
			  ,callStartTimeStamp_B
			  ,ROW_NUMBER() over (partition by FileId_B ORDER BY callStartTimeStamp_A) as Seq_id_B
		into #filesequence
		From NEW_Call_Info_2018

		UPDATE [NEW_Call_Info_2018]
		SET Sequenz_ID_per_File_A	= fs.Seq_id_A				,
			Sequenz_ID_per_File_B	= fs.Seq_id_B
		FROM #filesequence fs  
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on fs.SessionId_A	= ci.SessionId_A
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table File Sequence ID-s updated!')

-------------------------------------------------------------------------------------------------------
-- UPDATE POSITION INFORMATION
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table updated with position information')
		IF OBJECT_ID ('tempdb..#TempPosition' ) IS NOT NULL     DROP TABLE #TempPosition
		SELECT  SessionId
			   ,AVG(numSat)		AS numSatelites
			   ,MIN(PosId)		AS Min_PosId
			   ,MAX(PosId)		AS Max_PosId
			   ,MIN(speed)		AS Min_Speed
			   ,MAX(speed)		AS Max_Speed
			   ,AVG(altitude)	AS Altitude
			   ,SUM(distance)	AS Distance
		INTO #TempPosition
		FROM position p1
		GROUP BY SessionId
		ORDER BY SessionId
PRINT('Determining correct Position Id-s (temp table)...')
		UPDATE [NEW_Call_Info_2018]
		SET  numSatelites_A = tp.numSatelites,	
			 Altitude_A	= 	  tp.Altitude,	
			 Distance_A	= 	  tp.Distance,	
			 minSpeed_A	= 	  tp.Min_Speed,
			 maxSpeed_A	= 	  tp.Max_Speed,
			 startPosId_A = (CASE WHEN tp.Min_PosId is not null then Min_PosId ELSE ci.startPosId_A END),
			 endPosId_A   = (CASE WHEN tp.Max_PosId is not null then Max_PosId ELSE ci.endPosId_A END)
		FROM #TempPosition tp
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.SessionId_A = tp.SessionId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table A Side Position Id-s successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET  numSatelites_B = tp.numSatelites,	
			 Altitude_B	= 	  tp.Altitude,	
			 Distance_B	= 	  tp.Distance,	
			 minSpeed_B	= 	  tp.Min_Speed,
			 maxSpeed_B	= 	  tp.Max_Speed,
			 startPosId_B = (CASE WHEN tp.Min_PosId is not null then Min_PosId ELSE ci.startPosId_B END),
			 endPosId_B   = (CASE WHEN tp.Max_PosId is not null then Max_PosId ELSE ci.endPosId_B END)
		FROM #TempPosition tp
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.SessionId_B = tp.SessionId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table B Side Position Id-s successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET startLongitude_A = p.longitude	,
			startLatitude_A	 = p.latitude	
		FROM position p
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.startPosId_A = p.PosId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table A Side Start Latitude/Longitude successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET endLongitude_A   = p.longitude	,
			endLatitude_A	 = p.latitude	
		FROM position p
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.endPosId_A = p.PosId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table A Side End Latitude/Longitude successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET startLongitude_B = p.longitude	,
			startLatitude_B	 = p.latitude	
		FROM position p
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.startPosId_B = p.PosId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table B Side Start Latitude/Longitude successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET endLongitude_B   = p.longitude	,
			endLatitude_B	 = p.latitude	
		FROM position p
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.endPosId_B = p.PosId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table B Side End Latitude/Longitude successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET endLongitude_B   = p.longitude	,
			endLatitude_B	 = p.latitude	
		FROM position p
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.endPosId_B = p.PosId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table B Side End Latitude/Longitude successfully updated!')

-------------------------------------------------------------------------------------------------------
-- UPDATE TECHNOLOGY INFORMATION
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table updated with technology information')
		UPDATE NEW_Call_Info_2018
		SET startTechnology_A = ni.technology
		FROM NetworkInfo ni
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.startNetId_A = ni.NetworkId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table B Side End Latitude/Longitude successfully updated!')
		UPDATE [NEW_Call_Info_2018]
		SET startTechnology_B = ni.technology
		FROM NetworkInfo ni
		RIGHT OUTER JOIN NEW_Call_Info_2018 ci on ci.startNetId_B = ni.NetworkId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Call_Info_2018 Table B Side End Latitude/Longitude successfully updated!')

-------------------------------------------------------------------------------------------------------
-- CREATE SWISSQUAL CENTRAL TEST TABLE WITH BASIC INFORMATION
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_Test_Info_2018 creating...')
		IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_Test_Info_2018' AND type = 'U')	DROP TABLE [NEW_Test_Info_2018]
		SELECT [SessionId]							AS		SessionId_A
			  ,CAST(NULL as bigint)					AS		SessionId_B
			  ,[TestId]								AS		TestId
			  ,CAST(null as varchar(100 ))			AS      Test_Description
			  ,[startTime]							AS      Test_Start_Time
			  ,DATEADD(ms,[duration],StartTime)		AS      Test_End_Time
			  ,[duration]							AS      Test_Duration_ms
			  ,[typeoftest]							AS		Type_Of_Test
			  ,[TestName]							AS		Test_Name
			  ,CAST(null as varchar(200 ))			AS      Host
			  ,CAST(null as varchar(100 ))			AS      Throughput_kbit_s
			  ,CAST(null as varchar(100 ))			AS      RTT_ms
			  ,CAST(null as float)					AS      POLQA_MOS
			  ,[direction]							AS		direction
			  ,[qualityIndication]					AS		qualityIndication

			  -- A SIDE INFORMATION
			  ,CAST(null as varchar(100 ))			AS      Campaign_A
			  ,CAST(null as varchar(100 ))			AS      Collection_A
			  ,CAST(null as varchar(100 ))			AS      System_Name_A
			  ,CAST(null as varchar(100 ))			AS      System_Type_A
			  ,CAST(null as varchar(50 ))			AS      Zone_A
			  ,CAST(null as varchar(100 ))			AS      Location_A
			  ,CAST(null as varchar(20 ))    		AS      SW_A
			  ,CAST(null as varchar(50 ))			AS      UE_A
			  ,CAST(null as varchar(255 ))			AS      FW_A
			  ,CAST(null as varchar(100 ))			AS      IMEI_A
			  ,CAST(null as varchar(100 ))			AS      IMSI_A
			  ,CAST(null as varchar(100 ))			AS      MSISDN_A
			  ,CAST(null as varchar(100 ))			AS      FileId_A
			  ,CAST(null as varchar(100 ))			AS      FileName_A
			  ,CAST(null as int)     				AS      Sequenz_ID_per_File_A
			  ,StartNetworkId						AS 		StartNetworkId_A
			  ,CAST(null as varchar(100 ))			AS      startTechnology_A
			  ,StartPosId							AS 		StartPosId_A
			  ,CAST(null as float)     				AS      startLongitude_A
			  ,CAST(null as float)     				AS      startLatitude_A
			  ,CAST(null as int)     				AS      numSatelites_A
			  ,CAST(null as float)     				AS      Altitude_A
			  ,CAST(null as float)     				AS      Distance_A
			  ,CAST(null as int)     				AS      minSpeed_A
			  ,CAST(null as int)     				AS      maxSpeed_A
			  -- B SIDE INFORMATION
			  ,CAST(null as varchar(100 ))			AS      Campaign_B
			  ,CAST(null as varchar(100 ))			AS      Collection_B
			  ,CAST(null as varchar(100 ))			AS      System_Name_B
			  ,CAST(null as varchar(100 ))			AS      System_Type_B
			  ,CAST(null as varchar(50 ))			AS      Zone_B
			  ,CAST(null as varchar(100 ))			AS      Location_B
			  ,CAST(null as varchar(20 ))    		AS      SW_B
			  ,CAST(null as varchar(50 ))			AS      UE_B
			  ,CAST(null as varchar(255 ))			AS      FW_B
			  ,CAST(null as varchar(100 ))			AS      IMEI_B
			  ,CAST(null as varchar(100 ))			AS      IMSI_B
			  ,CAST(null as varchar(100 ))			AS      MSISDN_B
			  ,CAST(null as varchar(100 ))			AS      FileId_B
			  ,CAST(null as varchar(100 ))			AS      FileName_B
			  ,CAST(null as int)     				AS      Sequenz_ID_per_File_B
			  ,CAST(null as bigint)					AS 		StartNetworkId_B
			  ,CAST(null as varchar(100 ))			AS      startTechnology_B
			  ,CAST(null as bigint)					AS 		StartPosId_B
			  ,CAST(null as float)     				AS      startLongitude_B
			  ,CAST(null as float)     				AS      startLatitude_B
			  ,CAST(null as int)     				AS      numSatelites_B
			  ,CAST(null as float)     				AS      Altitude_B
			  ,CAST(null as float)     				AS      Distance_B
			  ,CAST(null as int)     				AS      minSpeed_B
			  ,CAST(null as int)     				AS      maxSpeed_B
		  INTO NEW_Test_Info_2018
		  FROM [TestInfo] ti
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_Test_Info_2018 created...')

-------------------------------------------------------------------------------------------------------
-- UPDATE BASIC TEST INFORMATION
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 with SessionId on B_Side')
		UPDATE NEW_Test_Info_2018
		SET SessionId_B = b.SessionId
		FROM NEW_Test_Info_2018 a
		LEFT OUTER JOIN SessionsB b on a.SessionId_A = b.SessionIdA
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 with SessionId on B_Side COMPLETED!')

-------------------------------------------------------------------------------------------------------
-- UPDATE FILE ID AND FILE SEQUENCE INFORMATION
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 with FileId_s')
		UPDATE NEW_Test_Info_2018
		SET FileId_A = b.FileId,
			FileId_B = b.FileId
		FROM NEW_Test_Info_2018 a
		LEFT OUTER JOIN Sessions b on a.SessionId_A = b.SessionId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 with SessionId on FileId_s COMPLETED!')

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 updated with file sequence of the session')
		IF OBJECT_ID ('tempdb..#filesequence1' ) IS NOT NULL DROP TABLE #filesequence1
		Select SessionId_A
			  ,TestId
			  ,FileId_A
			  ,Test_Start_Time
			  ,ROW_NUMBER() over (partition by FileId_A ORDER BY Test_Start_Time) as Seq_id_A
			  ,SessionId_B
			  ,FileId_B
			  ,ROW_NUMBER() over (partition by FileId_B ORDER BY Test_Start_Time) as Seq_id_B
		into #filesequence1
		From NEW_Test_Info_2018
		-- select * from #filesequence1
		UPDATE NEW_Test_Info_2018
		SET Sequenz_ID_per_File_A	= fs.Seq_id_A				,
			Sequenz_ID_per_File_B	= fs.Seq_id_B
		FROM #filesequence1 fs  
		RIGHT OUTER JOIN NEW_Test_Info_2018 ci on fs.SessionId_A	= ci.SessionId_A and fs.TestId = ci.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 Table File Sequence ID-s updated!')

-------------------------------------------------------------------------------------------------------
-- UPDATE SYSTEM NAME, SYSTEM TYPE, SYSTEM PROPERTIES
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 updated with System Name on A Side')
		UPDATE NEW_Test_Info_2018
		SET Campaign_A 			= fi.CampaignName				,
			Collection_A		= fi.CollectionName				,
			Test_Description	= fi.TestDescription			,
			Zone_A				= fi.Zone						,
			Location_A			= fi.ASideLocation				,
			SW_A				= fi.SWVersion					,
			UE_A				= fi.ASideDevice				,
			FW_A				= fi.FirmwareV					,
			IMEI_A				= CAST(fi.IMEI AS varchar(100))	,
			IMSI_A				= CAST(fi.IMSI AS varchar(100))	,
			MSISDN_A			= fi.ASideNumber				,
			FileName_A			= fi.ASideFileName
		FROM FileList fi  
		RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.FileId_A	= fi.FileId

		UPDATE NEW_Test_Info_2018
		SET System_Type_A = fi.System_Type,
			System_Name_A = fi.System_Name
		FROM #SystemName fi  
		RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.Zone_A	= fi.Zone_Name
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 updated with System Name on A Side COMPLETED!')

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 updated with System Name on B Side')
		UPDATE NEW_Test_Info_2018
		SET Campaign_B 			= fi.CampaignName				,
			Collection_B		= fi.CollectionName				,
			Zone_B				= fi.Zone						,
			Location_B			= fi.BSideLocation				,
			SW_B				= fi.SWVersion					,
			UE_B				= fi.ASideDevice				,
			FW_B				= fi.FirmwareV					,
			IMEI_B				= CAST(fi.IMEI AS varchar(100))	,
			IMSI_B				= CAST(fi.IMSI AS varchar(100))	,
			MSISDN_B			= fi.BSideNumber				,
			FileName_B			= fi.BSideFileName
		FROM FileList fi  
		RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.FileId_B = fi.FileId

		UPDATE NEW_Test_Info_2018
		SET System_Type_B = fi.System_Type,
			System_Name_B = fi.System_Name
		FROM #SystemName fi  
		RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.Zone_B	= fi.Zone_Name
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 updated with System Name on B Side COMPLETED!')

-------------------------------------------------------------------------------------------------------
-- UPDATE TECHNOLOGY INFORMATION
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 Table with Technology Info')
IF OBJECT_ID ('tempdb..#TestNet' ) IS NOT NULL DROP TABLE #TestNet
		select SessionId,TestId
			,MIN(NetworkId) as minNetId
		into #TestNet
		from NetworkIdRelation
		WHERE TestId <> 0
		group by SessionId,TestId

		UPDATE NEW_Test_Info_2018
		SET StartNetworkId_B = tn.minNetId
		FROM NEW_Test_Info_2018 ti
		LEFT OUTER JOIN #TestNet tn on tn.SessionId = ti.SessionId_B

		UPDATE NEW_Test_Info_2018
		SET startTechnology_A = ni.technology
		FROM NetworkInfo ni
		RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.startNetworkId_A = ni.NetworkId

		UPDATE NEW_Test_Info_2018
		SET startTechnology_B = ni.technology
		FROM NetworkInfo ni
		RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.startNetworkId_B = ni.NetworkId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATE: NEW_Test_Info_2018 Start Technology Updated!')

-------------------------------------------------------------------------------------------------------
-- UPDATE LOCATION INFORMATION
-------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_Test_Info_2018 Start Position Updates!')
	IF OBJECT_ID ('tempdb..#TempPositionT' ) IS NOT NULL     DROP TABLE #TempPositionT
	SELECT  SessionId,TestId
		   ,AVG(numSat)		AS numSatelites
		   ,MIN(PosId)		AS Min_PosId
		   ,MAX(PosId)		AS Max_PosId
		   ,MIN(speed)		AS Min_Speed
		   ,MAX(speed)		AS Max_Speed
		   ,AVG(altitude)	AS Altitude
		   ,SUM(distance)	AS Distance
	INTO #TempPositionT
	FROM position p1
	GROUP BY SessionId,TestId
	PRINT('Determining correct Position Id-s (temp table)...')

	UPDATE NEW_Test_Info_2018
	SET  numSatelites_A		=	  tp.numSatelites,	
		 Altitude_A			= 	  tp.Altitude,	
		 Distance_A			= 	  tp.Distance,	
		 minSpeed_A			= 	  tp.Min_Speed,
		 maxSpeed_A			= 	  tp.Max_Speed
	FROM #TempPositionT tp
	RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.TestId = tp.TestId and ci.SessionId_A = tp.SessionId

	UPDATE NEW_Test_Info_2018
	SET  numSatelites_B		=	  tp.numSatelites,	
		 Altitude_B			= 	  tp.Altitude,	
		 Distance_B			= 	  tp.Distance,	
		 minSpeed_B			= 	  tp.Min_Speed,
		 maxSpeed_B			= 	  tp.Max_Speed,
		 StartPosId_B		=	  tp.Min_PosId
	FROM #TempPositionT tp
	RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.TestId = tp.TestId and ci.SessionId_B = tp.SessionId
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table A Side Position Id-s successfully updated!')

	UPDATE NEW_Test_Info_2018
	SET startLongitude_A   = p.longitude,
		startLatitude_A	 = p.latitude	
	FROM position p
	RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.StartPosId_A = p.PosId

	UPDATE NEW_Test_Info_2018
	SET startLongitude_B   = p.longitude,
		startLatitude_B	   = p.latitude	
	FROM position p
	RIGHT OUTER JOIN NEW_Test_Info_2018 ci on ci.StartPosId_B = p.PosId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table Start Latitude/Longitude successfully updated!')

-------------------------------------------------------------------------------------------------------
-- UPDATE TEST NAMES AND TYPE
-------------------------------------------------------------------------------------------------------
	UPDATE NEW_Test_Info_2018
	SET  Type_Of_Test = 	b.TestName
	FROM NEW_Test_Info_2018 a
	LEFT OUTER JOIN #TestType b ON a.Type_Of_Test like b.TypeOfTest collate SQL_Latin1_General_CP1_CI_AS
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table Type_Of_Test Collumn successfully updated!')

-------------------------------------------------------------------------------------------------------
-- UPDATE EXTRACT INFORMATION FROM QoS COLUMS
-------------------------------------------------------------------------------------------------------
-- COLUMN: Host
		IF OBJECT_ID ('tempdb..#temp_host' ) IS NOT NULL DROP TABLE #temp_host
        select SessionId,TestId,Host into #temp_host from vResultsHTTPTransferTestGet
			union all
			select SessionId,TestId,Host from vResultsHTTPTransferTestPut
			union all
			select SessionId,TestId,Host from vResultsCapacityTestGet
			union all
			select SessionId,TestId,Host from vResultsCapacityTestPut
			union all
			select SessionId,TestId,URL from vETSIYouTubeKPIs
			
		update #temp_host
		set Host = REPLACE(Host,'http://','')
		where Host like 'http://%'

		update #temp_host
		set Host = REPLACE(Host,'https://','')
		where Host like 'https://%'

		update #temp_host
		set Host = SUBSTRING(Host, 0, PATINDEX('%/%',Host) )

		UPDATE NEW_Test_Info_2018
		SET Host = b.Host
		FROM NEW_Test_Info_2018 a
		LEFT OUTER JOIN #temp_host b on a.TestId = b.TestId

		UPDATE NEW_Test_Info_2018
		SET Host = SUBSTRING(qualityIndication, PATINDEX('%Host=%',qualityIndication) + 5 , LEN(qualityIndication) )
		WHERE qualityIndication like '%Host=%' and Host is null

		UPDATE NEW_Test_Info_2018
		SET Host = LEFT(Host, CHARINDEX(' ',Host)-1 )
		WHERE qualityIndication like '%Host=%' and Host like '% %'

		update NEW_Test_Info_2018
		set Host = REPLACE(Host,'http://','')
		where Host like 'http://%'

		update NEW_Test_Info_2018
		set Host = REPLACE(Host,'https://','')
		where Host like 'https://%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table Host Collumn successfully extracted!')

-- COLUMN: Throughput
		UPDATE NEW_Test_Info_2018
		SET Throughput_kbit_s = SUBSTRING(qualityIndication, PATINDEX('%Throughput=%' ,qualityIndication) +11 , LEN(qualityIndication) )
		WHERE qualityIndication like '%Throughput=%'

		UPDATE NEW_Test_Info_2018
		SET Throughput_kbit_s = SUBSTRING(qualityIndication, PATINDEX('%Get=%' ,qualityIndication) +4 , LEN(qualityIndication) )
		WHERE qualityIndication like '%Get=%' and Throughput_kbit_s is null

		UPDATE NEW_Test_Info_2018
		SET Throughput_kbit_s = SUBSTRING(qualityIndication, PATINDEX('%Put=%' ,qualityIndication) +4 , LEN(qualityIndication) )
		WHERE qualityIndication like '%Put=%' and Throughput_kbit_s is null

		UPDATE NEW_Test_Info_2018
		SET Throughput_kbit_s = LEFT(Throughput_kbit_s, CHARINDEX(' ',Throughput_kbit_s)-1 )
		WHERE Throughput_kbit_s like ' kbit/s%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table Throughput Collumn successfully extracted!')

-- COLUMN: Round Trip Time
		UPDATE NEW_Test_Info_2018
		SET RTT_ms = SUBSTRING(qualityIndication, PATINDEX('%RTT=%'  ,qualityIndication) + 4 , LEN(qualityIndication) )
		WHERE qualityIndication like '%RTT=%'

		UPDATE NEW_Test_Info_2018
		SET RTT_ms = LEFT(RTT_ms, CHARINDEX(' ',RTT_ms)-1 )
		WHERE RTT_ms is not null and RTT_ms like '% %'

		UPDATE NEW_Test_Info_2018
		SET RTT_ms = REPLACE(RTT_ms,'msec','')
		WHERE RTT_ms is not null
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table Throughput Collumn successfully extracted!')

-- COLUMN: POLQA_MOS
		UPDATE NEW_Test_Info_2018
		SET POLQA_MOS = SUBSTRING(qualityIndication, PATINDEX('%LQ=%'  ,qualityIndication) + 3 , LEN(qualityIndication) )
		WHERE qualityIndication like '%LQ=%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table POLQA_MOS Collumn successfully extracted!')

-- COLUMN: Direction 
		UPDATE NEW_Test_Info_2018
		SET direction = CASE WHEN direction    like 'Downlink%'																															THEN 'DL'
							 WHEN direction    like 'Uplink%'																															THEN 'UL'
							 WHEN Type_Of_Test like 'httpBrowser'																														THEN 'DL'
							 WHEN Type_Of_Test like 'YouTube'																															THEN 'DL'
							 WHEN Type_Of_Test like 'Application'																														THEN 'UL'
							 WHEN Type_Of_Test like 'ICMP Ping'																															THEN 'RT'
							 WHEN Type_Of_Test like 'POLQA'																																THEN 'RT'
							 WHEN Test_Name     like '%Receive'																															THEN 'DL'
							 END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_Test_Info_2018 Table Direction Collumn successfully extracted!')

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script executed successfully!')

/* VERIFICATION SECTION
SELECT * FROM NEW_Call_Info_2018 order by SessionId
SELECT * FROM NEW_Test_Info_2018 where TestId = 4294967377
SELECT * FROM NEW_Test_Info_2018 where Test_Name not like '%Call%' and Test_Name not like '%Whats%' ORDER BY TestId 
*/