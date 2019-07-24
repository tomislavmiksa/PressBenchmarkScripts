
/*****************************************************************************************************************************************************************************
============================================================================================================================================================================
 Project: Press Benchmark 2016
  Script: Layer_1_R05_CREATE_NEW_APPLICATION_PING
  Author: AST @ NET CHECK GmbH
============================================================================================================================================================================
*****************************************************************************************************************************************************************************/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- History 
-- v01. -> 01.11.2016	/	AST		/	CREATED		/	
-- v02. -> 13.12.2016	/	AN		/	Changed		/ Part 1: cngd 0 to NULL; Part 2: Formular chng. 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING TABLES IF THEY DO NOT EXIST
-- Table: NEW_RESULTS_ICMP_RAW_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_ICMP_RAW_2018 beeing created...')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RESULTS_ICMP_RAW_2018' AND type = 'U')	DROP TABLE NEW_RESULTS_ICMP_RAW_2018
	SELECT r.SessionId
		  ,r.TestId
		  ,r.MsgTime
		  ,r.NetworkId
		  ,CASE WHEN r.errorCode <> 0 THEN 'Failed'
				ELSE 'Success'
				END AS Test_Result
		  ,CASE WHEN r.errorCode <> 0 THEN 1
				ELSE 0
				END AS errCount
		  ,r.errorCode
		  ,dbo.GetErrorMsg(r.errorCode,0) AS errMessage
		  ,r.seqNumber
		  ,r.RTT
		  ,r.host
		  ,r.packetSize
		  ,n.[HomeOperator]
		  ,n.[HOMCC]
		  ,n.[HOMNC]
		  ,n.[Operator]
		  ,n.[MCC]
		  ,n.[MNC]
		  ,n.[LAC]
		  ,n.[CId]
		  ,n.[BCCH]
		  ,n.[technology]
		  ,n.[CGI]
		  ,n.[SC1]
		  ,n.[SC2]
		  ,n.[SC3]
		  ,n.[BSIC]
		  ,p.longitude
		  ,p.latitude
	INTO NEW_RESULTS_ICMP_RAW_2018
	FROM ResultsPingTest r
	LEFT OUTER JOIN Position p on r.PosId = p.PosId
	LEFT OUTER JOIN NetworkInfo n on r.NetworkId = n.NetworkId

-- select * from NEW_RESULTS_ICMP_RAW_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING TABLES IF THEY DO NOT EXIST
-- Table: NEW_RESULTS_ICMP_Tests_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_ICMP_Tests_2018 beeing created...')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RESULTS_ICMP_Tests_2018' AND type = 'U')	DROP TABLE NEW_RESULTS_ICMP_Tests_2018
	SELECT	1 as Validity,
			cast(null as varchar(50))	as InvalidReason,
			SessionId AS SessionId,
			TestId,
			'ICMP Ping'													AS Test_Type,
			'Ping ' + CAST (MAX(packetSize) as varchar(4))				AS Test_Name,
			CASE WHEN MAX(packetSize) <= 100	THEN 'Small Payload'
				 WHEN MAX(packetSize) >  100	THEN 'Big Payload'
				 END AS Test_Info,
			CASE WHEN MAX(seqNumber) > 0 and SUM(errCount) = MAX(seqNumber) THEN 'Failed'
				 WHEN MAX(seqNumber) > 0 and SUM(errCount) = 0 THEN 'Completed'
				 ELSE 'Failed'
				 END AS Test_Result,
			-- SUMMARY INFORMATION
			MAX(seqNumber)												AS PING_Samples,
			SUM(errCount)												AS PING_Failure_Samples,
			MIN(Host)													AS Host,
			CAST(NULL AS bigint)										AS RTT_SUM_ms, 
			MIN(RTT)													AS RTT_MIN_ms,
			CAST(NULL AS bigint)										AS RTT_AVG_ms,
			CAST(NULL AS bigint)										AS RTT_AVG_no_1st_ms,
			MAX(RTT)													AS RTT_MAX_ms,
			-- EACH TEST
			AVG(CASE WHEN seqNumber = 1 THEN packetSize ELSE NULL END)	AS PacketSize_01,
			AVG(CASE WHEN seqNumber = 1 THEN errorCode	ELSE NULL END)	AS ErrorCode_01,
			CAST(NULL AS varchar(100))									AS ErrorMessage_01,
			AVG(CASE WHEN seqNumber = 1 THEN RTT		ELSE NULL END)	AS RTT_01,					-- v.02 chgd by an 2016-12-14: chngd 0 to NULL
			AVG(CASE WHEN seqNumber = 2 THEN packetSize ELSE NULL END)	AS PacketSize_02,
			AVG(CASE WHEN seqNumber = 2 THEN errorCode	ELSE NULL END)	AS ErrorCode_02,
			CAST(NULL AS varchar(100))									AS ErrorMessage_02,
			AVG(CASE WHEN seqNumber = 2 THEN RTT		ELSE NULL END)	AS RTT_02,					-- v.02 chgd by an 2016-12-14: chngd 0 to NULL
			AVG(CASE WHEN seqNumber = 3 THEN packetSize ELSE NULL END)	AS PacketSize_03,
			AVG(CASE WHEN seqNumber = 3 THEN errorCode	ELSE NULL END)	AS ErrorCode_03,
			CAST(NULL AS varchar(100))									AS ErrorMessage_03,
			AVG(CASE WHEN seqNumber = 3 THEN RTT		ELSE NULL END)	AS RTT_03,					-- v.02 chgd by an 2016-12-14: chngd 0 to NULL
			AVG(CASE WHEN seqNumber = 4 THEN packetSize ELSE NULL END)	AS PacketSize_04,
			AVG(CASE WHEN seqNumber = 4 THEN errorCode	ELSE NULL END)	AS ErrorCode_04,
			CAST(NULL AS varchar(100))									AS ErrorMessage_04,
			AVG(CASE WHEN seqNumber = 4 THEN RTT		ELSE NULL END)	AS RTT_04,					-- v.02 chgd by an 2016-12-14: chngd 0 to NULL
			AVG(CASE WHEN seqNumber = 5 THEN packetSize ELSE NULL END)	AS PacketSize_05,
			AVG(CASE WHEN seqNumber = 5 THEN errorCode	ELSE NULL END)	AS ErrorCode_05,
			CAST(NULL AS varchar(100))									AS ErrorMessage_05,
			AVG(CASE WHEN seqNumber = 5 THEN RTT		ELSE NULL END)	AS RTT_05					-- v.02 chgd by an 2016-12-14: chngd 0 to NULL
	INTO NEW_RESULTS_ICMP_Tests_2018
	FROM NEW_RESULTS_ICMP_RAW_2018
	GROUP BY SessionId,TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_ICMP_Tests_2018 beeing updated...')
UPDATE NEW_RESULTS_ICMP_Tests_2018
SET  RTT_SUM_ms		   = CAST(ISNULL(RTT_01,0) + ISNULL(RTT_02,0) + ISNULL(RTT_03,0) + ISNULL(RTT_04,0) + ISNULL(RTT_05,0) AS INT)
    ,RTT_AVG_ms		   = CAST(ROUND((ISNULL(RTT_01,0) + ISNULL(RTT_02,0) + ISNULL(RTT_03,0) + ISNULL(RTT_04,0) + ISNULL(RTT_05,0) * 1.0) / NULLIF (PING_Samples ,0),0) as int)
    ,RTT_AVG_no_1st_ms  = CAST(ROUND((ISNULL(RTT_02,0) + ISNULL(RTT_03,0) + ISNULL(RTT_04,0) + ISNULL(RTT_05,0) * 1.0) / NULLIF (PING_Samples - 1,0),0) AS INT)

UPDATE NEW_RESULTS_ICMP_Tests_2018
SET  ErrorMessage_01		   = dbo.GetErrorMsg(ErrorCode_01,0)
    ,ErrorMessage_02		   = dbo.GetErrorMsg(ErrorCode_02,0)
    ,ErrorMessage_03		   = dbo.GetErrorMsg(ErrorCode_03,0)
	,ErrorMessage_04		   = dbo.GetErrorMsg(ErrorCode_04,0)
	,ErrorMessage_05		   = dbo.GetErrorMsg(ErrorCode_05,0)

UPDATE NEW_RESULTS_ICMP_Tests_2018
SET Validity = CASE WHEN b.valid is not null then b.valid
					ELSE 0
					END
   ,InvalidReason = CASE WHEN b.valid = 0  then 'SwissQual System Release'
					ELSE null
					END
FROM NEW_RESULTS_ICMP_Tests_2018 a
LEFT OUTER JOIN TestInfo b on a.SessionId = b.SessionId and a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script Execution Completed!...')

-- SELECT * FROM NEW_RESULTS_ICMP_RAW_2018 ORDER BY SessionId,TestId
-- SELECT * FROM NEW_RESULTS_ICMP_Tests_2018 ORDER BY SessionId,TestId

