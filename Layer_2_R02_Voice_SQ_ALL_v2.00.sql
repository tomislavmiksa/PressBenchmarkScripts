/*
============================================================================================================================================================================
Projekt: Press Measurements
   Name: Layer_ 2_R01_CREATE_NEW_RESULTS_SQ_Test_2018_v2.00.sql
  Autor: Tomislav Miksa - NET CHECK GmbH

History:
v1.0x : Initial Scripts in new format
		  - Integrate EVS Codec
		  - Integrate with POLQA Results
		  - Integrate with Expanded POLQA Results
		  - Add Location Information
		  - Per Session Table Created NEW_RESULTS_SQ_Session_2018
		  - Repaired Some records missing in final CDR due issue in JOIN
		  - Repaired Invalid Tests where Swissqual fails in POLQA evaluation present in Speech CDR
v2.00 : Improved in performance and major expansion
		  - not so many joins anymore (improves performance)
============================================================================================================================================================================
*/
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execeution...')
------------------------------------
-- DELETE Table if already exists --
------------------------------------
IF OBJECT_ID('dbo.NEW_RESULTS_SQ_Test_2018', 'U') IS NOT NULL 
  DROP TABLE dbo.NEW_RESULTS_SQ_Test_2018; 

IF OBJECT_ID('dbo.NEW_RESULTS_SQ_Session_2018', 'U') IS NOT NULL 
  DROP TABLE dbo.NEW_RESULTS_SQ_Session_2018;

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Creating NEW_RESULTS_SQ_Test_2018 Table...')
SELECT 
	[SessionId]            			AS      [SessionIdA]
	,CAST(null as bigint)			AS      [SessionIdB]
	,[TestId]						AS      [TestId]
	,CAST(null as varchar(20 ))     AS      [direction]
	,CAST(null as float)            AS      [SpeedAvg]
	,CAST(null as datetime2(3))     AS      [TestStart]
	,CAST(null as datetime2(3))     AS      [TestEnd]
	,[LQ08]     					AS      [LQ08]
	,[LQ]							AS      [LQ]
	,[LQFloat]						AS      [LQFloat]
	,[timeClipping]					AS      [timeClipping]
	,[posFreqShift]					AS      [posFreqShift]
	,[negFreqShift]					AS      [negFreqShift]
	,[refDCOffset]					AS      [refDCOffset]
	,[codedDcOffset]				AS      [codedDcOffset]
	,[delaySpread]					AS      [delaySpread]
	,[codedLevel]					AS      [codedLevel]
	,[delayDeviation]				AS      [delayDeviation]
	,[aSLrcvP56]					AS      [aSLrcvP56]
	,[activityRcvP56]				AS      [activityRcvP56]
	,[noiseRcv]						AS      [noiseRcv]
	,[staticSNR]					AS      [staticSNR]
	,[P863]							AS      [P863]
	,[P863Float]					AS      [P863Float]
	,[qualityCode]    				AS      [qualityCode]
	,[appl]							AS      [appl]
	,[ReceiveDelay]					AS      [ReceiveDelay]
	,[AmplClipping]					AS      [AmplClipping]
	,[LQCat]						AS      [LQCat]
	,[MissedVoice]					AS      [MissedVoice]
	,[LowerFilterLimit]				AS      [LowerFilterLimit]
	,[UpperFilterLimit]				AS      [UpperFilterLimit]
	,[ErrCode]         			 	AS      [ErrCode]
	,CASE WHEN [Bandwidth] like 'super wideband%' THEN 'SWB'
		  WHEN [Bandwidth] like 'wideband%' THEN 'WB'
		  WHEN [Bandwidth] like 'narrowband%' THEN 'NB'
		  ELSE 'Unknown'
		  END AS BW
	,[Resampling]      				AS      [Resampling]
	,CAST(null as nvarchar(1000))	AS      [Playing_Technology]
	,CAST(null as nvarchar(1000))	AS      [Playing_Technology_Detailed]
	,CAST(null as nvarchar(1000))	AS      [Playing_Codec]
	,CAST(null as nvarchar(1000))	AS      [Playing_Codec_Detailed]
	,CAST(null as int)          	AS      [Playing_AMR_NB_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_ms]
	,CAST(null as int)          	AS      [Playing_EVS_ms]
	,CAST(null as int)          	AS      [Playing_Unknown_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_1.8_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_4.75_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_5.15_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_5.9_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_6.7_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_7.4_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_7.95_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_10.2_ms]
	,CAST(null as int)          	AS      [Playing_AMR_NB_12.2_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_6.6_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_8.85_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_12.65_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_14.25_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_15.85_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_18.25_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_19.85_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_23.05_ms]
	,CAST(null as int)          	AS      [Playing_AMR_WB_23.85_ms]
	,CAST(null as int)          	AS      [Playing_EVS_5.9_ms]
	,CAST(null as int)          	AS      [Playing_EVS_7.2_ms]
	,CAST(null as int)          	AS      [Playing_EVS_8_ms]
	,CAST(null as int)          	AS      [Playing_EVS_9.6_ms]
	,CAST(null as int)          	AS      [Playing_EVS_13.2_ms]
	,CAST(null as int)          	AS      [Playing_EVS_16.4_ms]
	,CAST(null as int)          	AS      [Playing_EVS_24.4_ms]
	,CAST(null as int)          	AS      [Playing_EVS_32_ms]
	,CAST(null as int)          	AS      [Playing_EVS_48_ms]
	,CAST(null as int)          	AS      [Playing_EVS_64_ms]
	,CAST(null as int)          	AS      [Playing_EVS_96_ms]
	,CAST(null as int)          	AS      [Playing_EVS_128_ms]
	,CAST(null as int)          	AS      [Playing_Speed_kmh]
	,CAST(null as int)          	AS      [Playing_SatelitesCount]
	,CAST(null as int)          	AS      [Playing_NavigationMode]
	,CAST(null as float)        	AS      [Playing_Longitude]
	,CAST(null as float)        	AS      [Playing_Latitude]
	,CAST(null as nvarchar(1000))   AS      [Recording Technology]
	,CAST(null as nvarchar(1000))   AS      [Recording Technology Detailed]
	,CAST(null as nvarchar(1000))   AS      [Recording Codec]
	,CAST(null as nvarchar(1000))   AS      [Recording Codec Detailed]
	,CAST(null as int)          	AS      [Recording_AMR_NB_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_ms]
	,CAST(null as int)          	AS      [Recording_EVS_ms]
	,CAST(null as int)          	AS      [Recording_Unknown_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_1.8_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_4.75_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_5.15_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_5.9_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_6.7_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_7.4_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_7.95_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_10.2_ms]
	,CAST(null as int)          	AS      [Recording_AMR_NB_12.2_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_6.6_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_8.85_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_12.65_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_14.25_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_15.85_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_18.25_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_19.85_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_23.05_ms]
	,CAST(null as int)          	AS      [Recording_AMR_WB_23.85_ms]
	,CAST(null as int)          	AS      [Recording_EVS_5.9_ms]
	,CAST(null as int)          	AS      [Recording_EVS_7.2_ms]
	,CAST(null as int)          	AS      [Recording_EVS_8_ms]
	,CAST(null as int)          	AS      [Recording_EVS_9.6_ms]
	,CAST(null as int)          	AS      [Recording_EVS_13.2_ms]
	,CAST(null as int)          	AS      [Recording_EVS_16.4_ms]
	,CAST(null as int)          	AS      [Recording_EVS_24.4_ms]
	,CAST(null as int)          	AS      [Recording_EVS_32_ms]
	,CAST(null as int)          	AS      [Recording_EVS_48_ms]
	,CAST(null as int)          	AS      [Recording_EVS_64_ms]
	,CAST(null as int)          	AS      [Recording_EVS_96_ms]
	,CAST(null as int)          	AS      [Recording_EVS_128_ms]
	,CAST(null as int)          	AS      [Recording_Speed_kmh]
	,CAST(null as int)          	AS      [Recording_SatelitesCount]
	,CAST(null as int)          	AS      [Recording_NavigationMode]
	,CAST(null as float)        	AS      [Recording_Longitude]
	,CAST(null as float)        	AS      [Recording_Latitude]
	,CAST(null as int)          	AS      [Sample_Count_A]
	,CAST(null as int)          	AS      [Sample_Count_B]
	,CAST(null as int)          	AS      [Sample_Count]
	,CAST(null as int)          	AS      [LQ >=1.0 and < 1.1]
	,CAST(null as int)          	AS      [LQ >=1.1 and < 1.2]
	,CAST(null as int)          	AS      [LQ >=1.2 and < 1.3]
	,CAST(null as int)          	AS      [LQ >=1.3 and < 1.4]
	,CAST(null as int)          	AS      [LQ >=1.4 and < 1.5]
	,CAST(null as int)          	AS      [LQ >=1.5 and < 1.6]
	,CAST(null as int)          	AS      [LQ >=1.6 and < 1.7]
	,CAST(null as int)          	AS      [LQ >=1.7 and < 1.8]
	,CAST(null as int)          	AS      [LQ >=1.8 and < 1.9]
	,CAST(null as int)          	AS      [LQ >=1.9 and < 2.0]
	,CAST(null as int)          	AS      [LQ >=2.0 and < 2.1]
	,CAST(null as int)          	AS      [LQ >=2.1 and < 2.2]
	,CAST(null as int)          	AS      [LQ >=2.2 and < 2.3]
	,CAST(null as int)          	AS      [LQ >=2.3 and < 2.4]
	,CAST(null as int)          	AS      [LQ >=2.4 and < 2.5]
	,CAST(null as int)          	AS      [LQ >=2.5 and < 2.6]
	,CAST(null as int)          	AS      [LQ >=2.6 and < 2.7]
	,CAST(null as int)          	AS      [LQ >=2.7 and < 2.8]
	,CAST(null as int)          	AS      [LQ >=2.8 and < 2.9]
	,CAST(null as int)          	AS      [LQ >=2.9 and < 3.0]
	,CAST(null as int)          	AS      [LQ >=3.0 and < 3.1]
	,CAST(null as int)          	AS      [LQ >=3.1 and < 3.2]
	,CAST(null as int)          	AS      [LQ >=3.2 and < 3.3]
	,CAST(null as int)          	AS      [LQ >=3.3 and < 3.4]
	,CAST(null as int)          	AS      [LQ >=3.4 and < 3.5]
	,CAST(null as int)          	AS      [LQ >=3.5 and < 3.6]
	,CAST(null as int)          	AS      [LQ >=3.6 and < 3.7]
	,CAST(null as int)          	AS      [LQ >=3.7 and < 3.8]
	,CAST(null as int)          	AS      [LQ >=3.8 and < 3.9]
	,CAST(null as int)          	AS      [LQ >=3.9 and < 4.0]
	,CAST(null as int)          	AS      [LQ >=4.0 and < 4.1]
	,CAST(null as int)          	AS      [LQ >=4.1 and < 4.2]
	,CAST(null as int)          	AS      [LQ >=4.2 and < 4.3]
	,CAST(null as int)          	AS      [LQ >=4.3 and < 4.4]
	,CAST(null as int)          	AS      [LQ >=4.4 and < 4.5]
	,CAST(null as int)          	AS      [LQ >=4.5 and < 4.6]
	,CAST(null as int)          	AS      [LQ >=4.6 and < 4.7]
	,CAST(null as int)          	AS      [LQ >=4.7 and < 4.8]
	,CAST(null as int)          	AS      [LQ >=4.8 and < 4.9]
	,CAST(null as int)          	AS      [LQ >=4.9 and < 5.0]
INTO NEW_RESULTS_SQ_Test_2018
FROM vResultsLQAvg
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Test_2018 Table successfully created...')

-- UPDATE SessionId_B
---------------------------------------------------------------------------------------------------------------------------------------------------------------
		UPDATE NEW_RESULTS_SQ_Test_2018
		SET
			SessionIdB = sb.SessionId
		FROM [SessionsB] sb
		RIGHT OUTER JOIN NEW_RESULTS_SQ_Test_2018 sq ON sq.SessionIdA = sb.SessionIdA
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Test_2018 Table updated with SessionB Information')

-- UPDATE TEST INFORMATION FROM TEST INFO TABLE
---------------------------------------------------------------------------------------------------------------------------------------------------------------
		UPDATE NEW_RESULTS_SQ_Test_2018
		SET  direction			= ti.direction
			,SpeedAvg			= ti.SpeedAvg
			,TestStart			= ti.startTime
			,TestEnd			= DATEADD(ms,ti.Duration,ti.startTime)
		FROM [TestInfo] ti
		RIGHT OUTER JOIN NEW_RESULTS_SQ_Test_2018 sq ON sq.TestId = ti.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Test_2018 Table updated with Test Information (test duration, direction, start time, end time...')

-- UPDATE DETAILED CODEC INFORMATION
---------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Detailed Codec Information preprocessing...')
		IF OBJECT_ID ('tempdb..#CodecRaw1' ) IS NOT NULL DROP TABLE #CodecRaw1
		SELECT a.[MsgId]
			  ,a.[SessionId]
			  ,a.[TestId]
			  ,b.HomeOperator
			  ,b.Operator
			  ,b.technology
			  ,a.[MsgTime] as TestStart
			  ,a.[PosId]
			  ,a.[NetworkId]
			  ,b.MsgTime
			  ,a.[Direction]
			  ,CASE WHEN a.[Codec] = 13 THEN 'EVS'
					WHEN a.[Codec] > 0 THEN [dbo].[GetCodec](a.[Codec])	
					ELSE 'Unknown'
				END AS TextCodec
			  ,a.[Codec]
			  ,a.[CodecRate]
			  ,a.[Duration]
			  ,c.speed
			  ,c.numSat
			  ,c.navMode
			  ,c.longitude
			  ,c.latitude
		  INTO #CodecRaw1
		  FROM [VoiceCodecTest] a
		  LEFT OUTER JOIN [NetworkInfo] b on a.NetworkId = b.NetworkId
		  LEFT OUTER JOIN Position c ON a.SessionId = c.SessionId and a.TestId = c.TestId and a.PosId = c.PosId
		  WHERE a.Duration > 0 
		  ORDER BY a.TestID,a.MsgTime

		  UPDATE #CodecRaw1
		  SET speed		= b.speed		
		     ,numSat	= b.numSat	
			 ,navMode	= b.navMode	
			 ,longitude	= b.longitude	
			 ,latitude	= b.latitude	
		  -- select * 
		  FROM #CodecRaw1 a
		  LEFT OUTER JOIN Position b on a.PosId = b.PosId
		  WHERE a.longitude is null or a.latitude is null
		  -- select * from Position where PosId = 14491219657806
		  -- select * from Position where SessionId = 14491219656714 and TestId = 14486924689452

		IF OBJECT_ID ('tempdb..#CodecAggr' ) IS NOT NULL DROP TABLE #CodecAggr
		SELECT DISTINCT CR1.SessionId,CR1.TestId,CR1.Direction
						,(SELECT CR2.technology + ' [' + CAST(CR2.Duration as varchar(50)) + ']' + ',' 
								FROM #CodecRaw1 CR2 
								WHERE CR1.TestId = CR2.TestId and CR1.SessionId = CR2.SessionId and CR1.Direction = CR2.Direction 
								For XML PATH ('')) AS TechTimlineDetailed
						,(SELECT DISTINCT CR2.technology + ',' 
								FROM #CodecRaw1 CR2 
								WHERE CR1.TestId = CR2.TestId and CR1.SessionId = CR2.SessionId and CR1.Direction = CR2.Direction 
								For XML PATH ('')) AS TechTimline
						,(SELECT CR2.TextCodec + '-' + CAST(CodecRate as varchar(10)) + ' [' + CAST(CR2.Duration as varchar(50)) + ']' + ',' 
								FROM #CodecRaw1 CR2 
								WHERE CR1.TestId = CR2.TestId and CR1.SessionId = CR2.SessionId and CR1.Direction = CR2.Direction 
								For XML PATH ('')) AS CodecTimlineDetailed
						,(SELECT DISTINCT CR2.TextCodec + ',' 
							FROM #CodecRaw1 CR2 
							WHERE CR1.TestId = CR2.TestId and CR1.SessionId = CR2.SessionId and CR1.Direction = CR2.Direction 
							For XML PATH ('')) AS CodecTimline
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate in  ('12.2', '10.2', '7.95', '7.4', '6.7', '5.9', '5.15', '4.75', '1.8')	THEN Duration ELSE 0 END) AS "AMR_NB_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate in  ('23.85', '23.05', '19.85', '18.25', '15.85', '14.25', '12.65', '8.85', '6.6')	THEN Duration ELSE 0 END) AS "AMR_WB_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and CodecRate in  ('0' , '5.9', '7.2', '8', '9.6', '13.2', '16.4', '24.4', '32', '48', '64', '96', '128') THEN Duration 
									ELSE 0 END) AS "EVS_ms"
						,SUM(CASE WHEN (Codec = 0 or Codec < 0) THEN Duration 
									ELSE 0 END) AS "Unknown_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  1.8		THEN Duration ELSE 0 END) AS "AMR_NB_1.8_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  4.75	THEN Duration ELSE 0 END) AS "AMR_NB_4.75_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  5.15	THEN Duration ELSE 0 END) AS "AMR_NB_5.15_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  5.9		THEN Duration ELSE 0 END) AS "AMR_NB_5.9_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  6.7		THEN Duration ELSE 0 END) AS "AMR_NB_6.7_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  7.4		THEN Duration ELSE 0 END) AS "AMR_NB_7.4_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  7.95	THEN Duration ELSE 0 END) AS "AMR_NB_7.95_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 10.2		THEN Duration ELSE 0 END) AS "AMR_NB_10.2_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 12.2		THEN Duration ELSE 0 END) AS "AMR_NB_12.2_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  6.6  	THEN Duration ELSE 0 END) AS "AMR_WB_6.6_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate =  8.85 	THEN Duration ELSE 0 END) AS "AMR_WB_8.85_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 12.65 	THEN Duration ELSE 0 END) AS "AMR_WB_12.65_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 14.25 	THEN Duration ELSE 0 END) AS "AMR_WB_14.25_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 15.85 	THEN Duration ELSE 0 END) AS "AMR_WB_15.85_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 18.25 	THEN Duration ELSE 0 END) AS "AMR_WB_18.25_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 19.85 	THEN Duration ELSE 0 END) AS "AMR_WB_19.85_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 23.05 	THEN Duration ELSE 0 END) AS "AMR_WB_23.05_ms"
						,SUM(CASE WHEN Codec != 12 and Codec != 13 and CodecRate = 23.85 	THEN Duration ELSE 0 END) AS "AMR_WB_23.85_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  5.9	THEN Duration ELSE 0 END) AS "EVS_5.9_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  7.2	THEN Duration ELSE 0 END) AS "EVS_7.2_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  8		THEN Duration ELSE 0 END) AS "EVS_8_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  9.6	THEN Duration ELSE 0 END) AS "EVS_9.6_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  13.2	THEN Duration ELSE 0 END) AS "EVS_13.2_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  16.4	THEN Duration ELSE 0 END) AS "EVS_16.4_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  24.4	THEN Duration ELSE 0 END) AS "EVS_24.4_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  32		THEN Duration ELSE 0 END) AS "EVS_32_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  48		THEN Duration ELSE 0 END) AS "EVS_48_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  64		THEN Duration ELSE 0 END) AS "EVS_64_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  96		THEN Duration ELSE 0 END) AS "EVS_96_ms"
						,SUM(CASE WHEN (Codec = 12 or Codec = 13)  and  CodecRate =  128	THEN Duration ELSE 0 END) AS "EVS_128_ms"
						,MAX(speed)			AS Speed_kmh
						,MIN(numSat)		AS SatelitesCount
						,MIN(navMode)		AS NavigationMode
						,MIN(longitude)		AS Longitude
						,MIN(latitude)		AS Latitude
					INTO #CodecAggr
					FROM #CodecRaw1 CR1
					GROUP BY CR1.TestId,CR1.SessionId,CR1.Direction
					ORDER BY CR1.TestId,CR1.SessionId,CR1.Direction
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Detailed Codec Information preprocessing successfully completed...')

-- A->B Playing Codec Update
		UPDATE NEW_RESULTS_SQ_Test_2018
		SET  [Playing_Technology]    				   = CAST(ca.TechTimline	        AS nvarchar(1000))
			,[Playing_Technology_Detailed] 			   = CAST(ca.TechTimlineDetailed  	AS nvarchar(1000))
			,[Playing_Codec]  						   = CAST(ca.CodecTimline         	AS nvarchar(1000))
			,[Playing_Codec_Detailed]				   = CAST(ca.CodecTimlineDetailed	AS nvarchar(1000))
			,"Playing_AMR_NB_ms"	      			   = ca.AMR_NB_ms			
			,"Playing_AMR_WB_ms"	   				   = ca.AMR_WB_ms			
			,"Playing_EVS_ms" 						   = ca.EVS_ms				
			,"Playing_Unknown_ms"   				   = ca.Unknown_ms			
			,"Playing_AMR_NB_1.8_ms"				   = ca."AMR_NB_1.8_ms"		
			,"Playing_AMR_NB_4.75_ms"				   = ca."AMR_NB_4.75_ms"		
			,"Playing_AMR_NB_5.15_ms"				   = ca."AMR_NB_5.15_ms"		
			,"Playing_AMR_NB_5.9_ms"				   = ca."AMR_NB_5.9_ms"		
			,"Playing_AMR_NB_6.7_ms"				   = ca."AMR_NB_6.7_ms"		
			,"Playing_AMR_NB_7.4_ms"				   = ca."AMR_NB_7.4_ms"		
			,"Playing_AMR_NB_7.95_ms"				   = ca."AMR_NB_7.95_ms"		
			,"Playing_AMR_NB_10.2_ms"				   = ca."AMR_NB_10.2_ms"		
			,"Playing_AMR_NB_12.2_ms"				   = ca."AMR_NB_12.2_ms"		
			,"Playing_AMR_WB_6.6_ms"				   = ca."AMR_WB_6.6_ms"		
			,"Playing_AMR_WB_8.85_ms"				   = ca."AMR_WB_8.85_ms"		
			,"Playing_AMR_WB_12.65_ms"				   = ca."AMR_WB_12.65_ms"	
			,"Playing_AMR_WB_14.25_ms"				   = ca."AMR_WB_14.25_ms"	
			,"Playing_AMR_WB_15.85_ms"				   = ca."AMR_WB_15.85_ms"	
			,"Playing_AMR_WB_18.25_ms"				   = ca."AMR_WB_18.25_ms"	
			,"Playing_AMR_WB_19.85_ms"				   = ca."AMR_WB_19.85_ms"	
			,"Playing_AMR_WB_23.05_ms"				   = ca."AMR_WB_23.05_ms"	
			,"Playing_AMR_WB_23.85_ms" 				   = ca."AMR_WB_23.85_ms"	
			,"Playing_EVS_5.9_ms"					   = ca."EVS_5.9_ms"			
			,"Playing_EVS_7.2_ms"					   = ca."EVS_7.2_ms"			
			,"Playing_EVS_8_ms"						   = ca."EVS_8_ms"			
			,"Playing_EVS_9.6_ms"					   = ca."EVS_9.6_ms"			
			,"Playing_EVS_13.2_ms"					   = ca."EVS_13.2_ms"		
			,"Playing_EVS_16.4_ms"					   = ca."EVS_16.4_ms"		
			,"Playing_EVS_24.4_ms"					   = ca."EVS_24.4_ms"		
			,"Playing_EVS_32_ms"					   = ca."EVS_32_ms"			
			,"Playing_EVS_48_ms"					   = ca."EVS_48_ms"			
			,"Playing_EVS_64_ms"					   = ca."EVS_64_ms"			
			,"Playing_EVS_96_ms"					   = ca."EVS_96_ms"			
			,"Playing_EVS_128_ms"					   = ca."EVS_128_ms"			
			,"Playing_Speed_kmh"					   = ca."Speed_kmh"			
			,"Playing_SatelitesCount"				   = ca."SatelitesCount"		
			,"Playing_NavigationMode"				   = ca."NavigationMode"		
			,"Playing_Longitude"					   = ca."Longitude"			
			,"Playing_Latitude"						   = ca."Latitude"			
		FROM #CodecAggr ca
		RIGHT OUTER JOIN NEW_RESULTS_SQ_Test_2018 sq ON sq.SessionIdA = ca.SessionId and sq.TestId = ca.TestId and ca.Direction like 'U'
		WHERE sq.direction like 'A->B' 

-- B->A Playing Codec Update
		UPDATE NEW_RESULTS_SQ_Test_2018
		SET  [Playing_Technology]    				   = CAST(ca.TechTimline	        AS nvarchar(1000))
			,[Playing_Technology_Detailed] 			   = CAST(ca.TechTimlineDetailed  	AS nvarchar(1000))
			,[Playing_Codec]  						   = CAST(ca.CodecTimline         	AS nvarchar(1000))
			,[Playing_Codec_Detailed]				   = CAST(ca.CodecTimlineDetailed	AS nvarchar(1000))
			,"Playing_AMR_NB_ms"	      			   = ca.AMR_NB_ms			
			,"Playing_AMR_WB_ms"	   				   = ca.AMR_WB_ms			
			,"Playing_EVS_ms" 						   = ca.EVS_ms				
			,"Playing_Unknown_ms"   				   = ca.Unknown_ms			
			,"Playing_AMR_NB_1.8_ms"				   = ca."AMR_NB_1.8_ms"		
			,"Playing_AMR_NB_4.75_ms"				   = ca."AMR_NB_4.75_ms"		
			,"Playing_AMR_NB_5.15_ms"				   = ca."AMR_NB_5.15_ms"		
			,"Playing_AMR_NB_5.9_ms"				   = ca."AMR_NB_5.9_ms"		
			,"Playing_AMR_NB_6.7_ms"				   = ca."AMR_NB_6.7_ms"		
			,"Playing_AMR_NB_7.4_ms"				   = ca."AMR_NB_7.4_ms"		
			,"Playing_AMR_NB_7.95_ms"				   = ca."AMR_NB_7.95_ms"		
			,"Playing_AMR_NB_10.2_ms"				   = ca."AMR_NB_10.2_ms"		
			,"Playing_AMR_NB_12.2_ms"				   = ca."AMR_NB_12.2_ms"		
			,"Playing_AMR_WB_6.6_ms"				   = ca."AMR_WB_6.6_ms"		
			,"Playing_AMR_WB_8.85_ms"				   = ca."AMR_WB_8.85_ms"		
			,"Playing_AMR_WB_12.65_ms"				   = ca."AMR_WB_12.65_ms"	
			,"Playing_AMR_WB_14.25_ms"				   = ca."AMR_WB_14.25_ms"	
			,"Playing_AMR_WB_15.85_ms"				   = ca."AMR_WB_15.85_ms"	
			,"Playing_AMR_WB_18.25_ms"				   = ca."AMR_WB_18.25_ms"	
			,"Playing_AMR_WB_19.85_ms"				   = ca."AMR_WB_19.85_ms"	
			,"Playing_AMR_WB_23.05_ms"				   = ca."AMR_WB_23.05_ms"	
			,"Playing_AMR_WB_23.85_ms" 				   = ca."AMR_WB_23.85_ms"	
			,"Playing_EVS_5.9_ms"					   = ca."EVS_5.9_ms"			
			,"Playing_EVS_7.2_ms"					   = ca."EVS_7.2_ms"			
			,"Playing_EVS_8_ms"						   = ca."EVS_8_ms"			
			,"Playing_EVS_9.6_ms"					   = ca."EVS_9.6_ms"			
			,"Playing_EVS_13.2_ms"					   = ca."EVS_13.2_ms"		
			,"Playing_EVS_16.4_ms"					   = ca."EVS_16.4_ms"		
			,"Playing_EVS_24.4_ms"					   = ca."EVS_24.4_ms"		
			,"Playing_EVS_32_ms"					   = ca."EVS_32_ms"			
			,"Playing_EVS_48_ms"					   = ca."EVS_48_ms"			
			,"Playing_EVS_64_ms"					   = ca."EVS_64_ms"			
			,"Playing_EVS_96_ms"					   = ca."EVS_96_ms"			
			,"Playing_EVS_128_ms"					   = ca."EVS_128_ms"			
			,"Playing_Speed_kmh"					   = ca."Speed_kmh"			
			,"Playing_SatelitesCount"				   = ca."SatelitesCount"		
			,"Playing_NavigationMode"				   = ca."NavigationMode"		
			,"Playing_Longitude"					   = ca."Longitude"			
			,"Playing_Latitude"						   = ca."Latitude"			
		FROM #CodecAggr ca
		RIGHT OUTER JOIN NEW_RESULTS_SQ_Test_2018 sq ON sq.SessionIdB = ca.SessionId and sq.TestId = ca.TestId and ca.Direction like 'U'
		WHERE sq.direction like 'B->A'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Test_2018 Table updated with Playing Codec Information...')


-- A->B Recording Codec Update
		UPDATE NEW_RESULTS_SQ_Test_2018
		SET  [Recording Technology]					   = CAST(ca.TechTimline	        AS nvarchar(1000))
			,[Recording Technology Detailed]		   = CAST(ca.TechTimlineDetailed  	AS nvarchar(1000))
			,[Recording Codec]						   = CAST(ca.CodecTimline         	AS nvarchar(1000))
			,[Recording Codec Detailed]				   = CAST(ca.CodecTimlineDetailed	AS nvarchar(1000))
			,"Recording_AMR_NB_ms"	      			   = ca.AMR_NB_ms			
			,"Recording_AMR_WB_ms"	   				   = ca.AMR_WB_ms			
			,"Recording_EVS_ms" 					   = ca.EVS_ms				
			,"Recording_Unknown_ms"   				   = ca.Unknown_ms			
			,"Recording_AMR_NB_1.8_ms"				   = ca."AMR_NB_1.8_ms"		
			,"Recording_AMR_NB_4.75_ms"				   = ca."AMR_NB_4.75_ms"		
			,"Recording_AMR_NB_5.15_ms"				   = ca."AMR_NB_5.15_ms"		
			,"Recording_AMR_NB_5.9_ms"				   = ca."AMR_NB_5.9_ms"		
			,"Recording_AMR_NB_6.7_ms"				   = ca."AMR_NB_6.7_ms"		
			,"Recording_AMR_NB_7.4_ms"				   = ca."AMR_NB_7.4_ms"		
			,"Recording_AMR_NB_7.95_ms"				   = ca."AMR_NB_7.95_ms"		
			,"Recording_AMR_NB_10.2_ms"				   = ca."AMR_NB_10.2_ms"		
			,"Recording_AMR_NB_12.2_ms"				   = ca."AMR_NB_12.2_ms"		
			,"Recording_AMR_WB_6.6_ms"				   = ca."AMR_WB_6.6_ms"		
			,"Recording_AMR_WB_8.85_ms"				   = ca."AMR_WB_8.85_ms"		
			,"Recording_AMR_WB_12.65_ms"			   = ca."AMR_WB_12.65_ms"	
			,"Recording_AMR_WB_14.25_ms"			   = ca."AMR_WB_14.25_ms"	
			,"Recording_AMR_WB_15.85_ms"			   = ca."AMR_WB_15.85_ms"	
			,"Recording_AMR_WB_18.25_ms"			   = ca."AMR_WB_18.25_ms"	
			,"Recording_AMR_WB_19.85_ms"			   = ca."AMR_WB_19.85_ms"	
			,"Recording_AMR_WB_23.05_ms"			   = ca."AMR_WB_23.05_ms"	
			,"Recording_AMR_WB_23.85_ms" 			   = ca."AMR_WB_23.85_ms"	
			,"Recording_EVS_5.9_ms"					   = ca."EVS_5.9_ms"			
			,"Recording_EVS_7.2_ms"					   = ca."EVS_7.2_ms"			
			,"Recording_EVS_8_ms"					   = ca."EVS_8_ms"			
			,"Recording_EVS_9.6_ms"					   = ca."EVS_9.6_ms"			
			,"Recording_EVS_13.2_ms"				   = ca."EVS_13.2_ms"		
			,"Recording_EVS_16.4_ms"				   = ca."EVS_16.4_ms"		
			,"Recording_EVS_24.4_ms"				   = ca."EVS_24.4_ms"		
			,"Recording_EVS_32_ms"					   = ca."EVS_32_ms"			
			,"Recording_EVS_48_ms"					   = ca."EVS_48_ms"			
			,"Recording_EVS_64_ms"					   = ca."EVS_64_ms"			
			,"Recording_EVS_96_ms"					   = ca."EVS_96_ms"			
			,"Recording_EVS_128_ms"					   = ca."EVS_128_ms"			
			,"Recording_Speed_kmh"					   = ca."Speed_kmh"			
			,"Recording_SatelitesCount"				   = ca."SatelitesCount"		
			,"Recording_NavigationMode"				   = ca."NavigationMode"		
			,"Recording_Longitude"					   = ca."Longitude"			
			,"Recording_Latitude"					   = ca."Latitude"			
		FROM #CodecAggr ca
		RIGHT OUTER JOIN NEW_RESULTS_SQ_Test_2018 sq ON sq.SessionIdB = ca.SessionId and sq.TestId = ca.TestId and ca.Direction like 'D'
		WHERE sq.direction like 'A->B' 

-- B->A Recording Codec Update
		UPDATE NEW_RESULTS_SQ_Test_2018
		SET  [Recording Technology]					   = CAST(ca.TechTimline	        AS nvarchar(1000))
			,[Recording Technology Detailed]		   = CAST(ca.TechTimlineDetailed  	AS nvarchar(1000))
			,[Recording Codec]						   = CAST(ca.CodecTimline         	AS nvarchar(1000))
			,[Recording Codec Detailed]				   = CAST(ca.CodecTimlineDetailed	AS nvarchar(1000))
			,"Recording_AMR_NB_ms"	      			   = ca.AMR_NB_ms			
			,"Recording_AMR_WB_ms"	   				   = ca.AMR_WB_ms			
			,"Recording_EVS_ms" 					   = ca.EVS_ms				
			,"Recording_Unknown_ms"   				   = ca.Unknown_ms			
			,"Recording_AMR_NB_1.8_ms"				   = ca."AMR_NB_1.8_ms"		
			,"Recording_AMR_NB_4.75_ms"				   = ca."AMR_NB_4.75_ms"		
			,"Recording_AMR_NB_5.15_ms"				   = ca."AMR_NB_5.15_ms"		
			,"Recording_AMR_NB_5.9_ms"				   = ca."AMR_NB_5.9_ms"		
			,"Recording_AMR_NB_6.7_ms"				   = ca."AMR_NB_6.7_ms"		
			,"Recording_AMR_NB_7.4_ms"				   = ca."AMR_NB_7.4_ms"		
			,"Recording_AMR_NB_7.95_ms"				   = ca."AMR_NB_7.95_ms"		
			,"Recording_AMR_NB_10.2_ms"				   = ca."AMR_NB_10.2_ms"		
			,"Recording_AMR_NB_12.2_ms"				   = ca."AMR_NB_12.2_ms"		
			,"Recording_AMR_WB_6.6_ms"				   = ca."AMR_WB_6.6_ms"		
			,"Recording_AMR_WB_8.85_ms"				   = ca."AMR_WB_8.85_ms"		
			,"Recording_AMR_WB_12.65_ms"			   = ca."AMR_WB_12.65_ms"	
			,"Recording_AMR_WB_14.25_ms"			   = ca."AMR_WB_14.25_ms"	
			,"Recording_AMR_WB_15.85_ms"			   = ca."AMR_WB_15.85_ms"	
			,"Recording_AMR_WB_18.25_ms"			   = ca."AMR_WB_18.25_ms"	
			,"Recording_AMR_WB_19.85_ms"			   = ca."AMR_WB_19.85_ms"	
			,"Recording_AMR_WB_23.05_ms"			   = ca."AMR_WB_23.05_ms"	
			,"Recording_AMR_WB_23.85_ms" 			   = ca."AMR_WB_23.85_ms"	
			,"Recording_EVS_5.9_ms"					   = ca."EVS_5.9_ms"			
			,"Recording_EVS_7.2_ms"					   = ca."EVS_7.2_ms"			
			,"Recording_EVS_8_ms"					   = ca."EVS_8_ms"			
			,"Recording_EVS_9.6_ms"					   = ca."EVS_9.6_ms"			
			,"Recording_EVS_13.2_ms"				   = ca."EVS_13.2_ms"		
			,"Recording_EVS_16.4_ms"				   = ca."EVS_16.4_ms"		
			,"Recording_EVS_24.4_ms"				   = ca."EVS_24.4_ms"		
			,"Recording_EVS_32_ms"					   = ca."EVS_32_ms"			
			,"Recording_EVS_48_ms"					   = ca."EVS_48_ms"			
			,"Recording_EVS_64_ms"					   = ca."EVS_64_ms"			
			,"Recording_EVS_96_ms"					   = ca."EVS_96_ms"			
			,"Recording_EVS_128_ms"					   = ca."EVS_128_ms"			
			,"Recording_Speed_kmh"					   = ca."Speed_kmh"			
			,"Recording_SatelitesCount"				   = ca."SatelitesCount"		
			,"Recording_NavigationMode"				   = ca."NavigationMode"		
			,"Recording_Longitude"					   = ca."Longitude"			
			,"Recording_Latitude"					   = ca."Latitude"				
		FROM #CodecAggr ca
		RIGHT OUTER JOIN NEW_RESULTS_SQ_Test_2018 sq ON sq.SessionIdA = ca.SessionId and sq.TestId = ca.TestId and ca.Direction like 'D'
		WHERE sq.direction like 'B->A'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Test_2018 Table updated with Recording Codec Information...')

-- CLEANUP OF ',' at end of string, setting pivots for Speech Samples
---------------------------------------------------------------------------------------------------------------------------------------------------------------
		UPDATE NEW_RESULTS_SQ_Test_2018
		SET
				 "Playing_Technology"				= CASE WHEN LEN("Playing_Technology"			) > 0	THEN	LEFT("Playing_Technology"			, LEN("Playing_Technology"			) - 1 )	ELSE  NULL END  
				,"Playing_Technology_Detailed"		= CASE WHEN LEN("Playing_Technology_Detailed"	) > 0	THEN	LEFT("Playing_Technology_Detailed"	, LEN("Playing_Technology_Detailed"	) - 1 )	ELSE  NULL END  
				,"Playing_Codec"					= CASE WHEN LEN("Playing_Codec"					) > 0	THEN	LEFT("Playing_Codec"				, LEN("Playing_Codec"				) - 1 )	ELSE  NULL END  
				,"Playing_Codec_Detailed"			= CASE WHEN LEN("Playing_Codec_Detailed"		) > 0	THEN	LEFT("Playing_Codec_Detailed"		, LEN("Playing_Codec_Detailed"		) - 1 )	ELSE  NULL END  
				,"Recording Technology"				= CASE WHEN LEN("Recording Technology"			) > 0	THEN	LEFT("Recording Technology"			, LEN("Recording Technology"			) - 1 )	ELSE  NULL END  
				,"Recording Technology Detailed"	= CASE WHEN LEN("Recording Technology Detailed"	) > 0	THEN	LEFT("Recording Technology Detailed", LEN("Recording Technology Detailed") - 1 )	ELSE  NULL END  
				,"Recording Codec"					= CASE WHEN LEN("Recording Codec"				) > 0	THEN	LEFT("Recording Codec"				, LEN("Recording Codec"				) - 1 )	ELSE  NULL END 
				,"Recording Codec Detailed"			= CASE WHEN LEN("Recording Codec Detailed"		) > 0	THEN	LEFT("Recording Codec Detailed"		, LEN("Recording Codec Detailed"		) - 1 ) ELSE  NULL END 
				,"Sample_Count_A" = CASE WHEN ((LQ >=1.0 AND LQ < 5.0) OR ErrCode = -5)  AND direction LIKE 'B->A'  THEN 1 ELSE NULL END 
				,"Sample_Count_B" = CASE WHEN ((LQ >=1.0 AND LQ < 5.0) OR ErrCode = -5)  AND direction LIKE 'A->B'  THEN 1 ELSE NULL END 
				,"Sample_Count" = CASE WHEN  (LQ >=1.0 AND LQ < 5.0) OR ErrCode = -5								 THEN 1 ELSE NULL END 
				,"LQ >=1.0 and < 1.1" = CASE WHEN LQ >=1.0 AND LQ < 1.1 THEN 1 ELSE 0 END 
				,"LQ >=1.1 and < 1.2" = CASE WHEN LQ >=1.1 AND LQ < 1.2 THEN 1 ELSE 0 END 
				,"LQ >=1.2 and < 1.3" = CASE WHEN LQ >=1.2 AND LQ < 1.3 THEN 1 ELSE 0 END 
				,"LQ >=1.3 and < 1.4" = CASE WHEN LQ >=1.3 AND LQ < 1.4 THEN 1 ELSE 0 END 
				,"LQ >=1.4 and < 1.5" = CASE WHEN LQ >=1.4 AND LQ < 1.5 THEN 1 ELSE 0 END 
				,"LQ >=1.5 and < 1.6" = CASE WHEN LQ >=1.5 AND LQ < 1.6 THEN 1 ELSE 0 END 
				,"LQ >=1.6 and < 1.7" = CASE WHEN LQ >=1.6 AND LQ < 1.7 THEN 1 ELSE 0 END 
				,"LQ >=1.7 and < 1.8" = CASE WHEN LQ >=1.7 AND LQ < 1.8 THEN 1 ELSE 0 END 
				,"LQ >=1.8 and < 1.9" = CASE WHEN LQ >=1.8 AND LQ < 1.9 THEN 1 ELSE 0 END 
				,"LQ >=1.9 and < 2.0" = CASE WHEN LQ >=1.9 AND LQ < 2.0 THEN 1 ELSE 0 END 
				,"LQ >=2.0 and < 2.1" = CASE WHEN LQ >=2.0 AND LQ < 2.1 THEN 1 ELSE 0 END 
				,"LQ >=2.1 and < 2.2" = CASE WHEN LQ >=2.1 AND LQ < 2.2 THEN 1 ELSE 0 END 
				,"LQ >=2.2 and < 2.3" = CASE WHEN LQ >=2.2 AND LQ < 2.3 THEN 1 ELSE 0 END 
				,"LQ >=2.3 and < 2.4" = CASE WHEN LQ >=2.3 AND LQ < 2.4 THEN 1 ELSE 0 END 
				,"LQ >=2.4 and < 2.5" = CASE WHEN LQ >=2.4 AND LQ < 2.5 THEN 1 ELSE 0 END 
				,"LQ >=2.5 and < 2.6" = CASE WHEN LQ >=2.5 AND LQ < 2.6 THEN 1 ELSE 0 END 
				,"LQ >=2.6 and < 2.7" = CASE WHEN LQ >=2.6 AND LQ < 2.7 THEN 1 ELSE 0 END 
				,"LQ >=2.7 and < 2.8" = CASE WHEN LQ >=2.7 AND LQ < 2.8 THEN 1 ELSE 0 END 
				,"LQ >=2.8 and < 2.9" = CASE WHEN LQ >=2.8 AND LQ < 2.9 THEN 1 ELSE 0 END 
				,"LQ >=2.9 and < 3.0" = CASE WHEN LQ >=2.9 AND LQ < 3.0 THEN 1 ELSE 0 END 
				,"LQ >=3.0 and < 3.1" = CASE WHEN LQ >=3.0 AND LQ < 3.1 THEN 1 ELSE 0 END 
				,"LQ >=3.1 and < 3.2" = CASE WHEN LQ >=3.1 AND LQ < 3.2 THEN 1 ELSE 0 END 
				,"LQ >=3.2 and < 3.3" = CASE WHEN LQ >=3.2 AND LQ < 3.3 THEN 1 ELSE 0 END 
				,"LQ >=3.3 and < 3.4" = CASE WHEN LQ >=3.3 AND LQ < 3.4 THEN 1 ELSE 0 END 
				,"LQ >=3.4 and < 3.5" = CASE WHEN LQ >=3.4 AND LQ < 3.5 THEN 1 ELSE 0 END 
				,"LQ >=3.5 and < 3.6" = CASE WHEN LQ >=3.5 AND LQ < 3.6 THEN 1 ELSE 0 END 
				,"LQ >=3.6 and < 3.7" = CASE WHEN LQ >=3.6 AND LQ < 3.7 THEN 1 ELSE 0 END 
				,"LQ >=3.7 and < 3.8" = CASE WHEN LQ >=3.7 AND LQ < 3.8 THEN 1 ELSE 0 END 
				,"LQ >=3.8 and < 3.9" = CASE WHEN LQ >=3.8 AND LQ < 3.9 THEN 1 ELSE 0 END 
				,"LQ >=3.9 and < 4.0" = CASE WHEN LQ >=3.9 AND LQ < 4.0 THEN 1 ELSE 0 END 
				,"LQ >=4.0 and < 4.1" = CASE WHEN LQ >=4.0 AND LQ < 4.1 THEN 1 ELSE 0 END 
				,"LQ >=4.1 and < 4.2" = CASE WHEN LQ >=4.1 AND LQ < 4.2 THEN 1 ELSE 0 END 
				,"LQ >=4.2 and < 4.3" = CASE WHEN LQ >=4.2 AND LQ < 4.3 THEN 1 ELSE 0 END 
				,"LQ >=4.3 and < 4.4" = CASE WHEN LQ >=4.3 AND LQ < 4.4 THEN 1 ELSE 0 END 
				,"LQ >=4.4 and < 4.5" = CASE WHEN LQ >=4.4 AND LQ < 4.5 THEN 1 ELSE 0 END 
				,"LQ >=4.5 and < 4.6" = CASE WHEN LQ >=4.5 AND LQ < 4.6 THEN 1 ELSE 0 END 
				,"LQ >=4.6 and < 4.7" = CASE WHEN LQ >=4.6 AND LQ < 4.7 THEN 1 ELSE 0 END 
				,"LQ >=4.7 and < 4.8" = CASE WHEN LQ >=4.7 AND LQ < 4.8 THEN 1 ELSE 0 END 
				,"LQ >=4.8 and < 4.9" = CASE WHEN LQ >=4.8 AND LQ < 4.9 THEN 1 ELSE 0 END 
				,"LQ >=4.9 and < 5.0" = CASE WHEN LQ >=4.9 AND LQ < 5.0 THEN 1 ELSE 0 END 

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Test_2018 Table updated with PIVOT Information...')

-- CLEANUP OF INVALID SPEECH SAMPLES
---------------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#CodecFailure' ) IS NOT NULL DROP TABLE #CodecFailure
		SELECT 
			   TestID,
			   count(TestID) as TestID_COUNT
		INTO #CodecFailure
		FROM NEW_RESULTS_SQ_Test_2018
		GROUP BY TestID
		HAVING COUNT(TestID) > 1
		ORDER BY TestID
		DELETE FROM NEW_RESULTS_SQ_Test_2018
		WHERE TestId in (SELECT DISTINCT TestId FROM #CodecFailure)
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Test_2018 Table CLEANUP OF TESTING SYSTEM FAILURES...')

-- CREATING AGGREGATION BY SESSION FOR VOICE CDR
---------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Session_2018 Table crattion starting...')
		SELECT  [SessionIdA]
			   ,[SessionIdB]
			   ,SUM(CASE WHEN [direction] like 'A->B' THEN 1 ELSE 0 END)					 AS 'A->B Samples Count'
			   ,SUM(CASE WHEN [direction] like 'B->A' THEN 1 ELSE 0 END)					 AS 'B->A Samples Count'
			   ,COUNT(TestId)																 AS 'Total Samples Count'
			   ,MIN([LQ])																	 AS POLQA_LQ_MIN
			   ,AVG([LQ])																	 AS POLQA_LQ_AVG
			   ,master.dbo.Quantil([LQ],0.5)												 AS POLQA_LQ_MEAN
			   ,MAX([LQ])																	 AS POLQA_LQ_MAX
			   ,SUM([LQ])																	 AS POLQA_LQ_SUM
			   ,SUM(CASE WHEN ErrCode = -5 THEN 1 ELSE NULL END)							 AS 'SilenceDistortionCount'
			   ,SUM(CASE WHEN [LQ] >=1.0 AND [LQ] < 1.6 THEN 1 ELSE NULL END)				 AS '1.0>=Bad<1.6'
			   ,SUM(CASE WHEN [LQ] >=1.6 AND [LQ] < 2.3 THEN 1 ELSE NULL END)				 AS '1.6>=Poor<2.3'
			   ,SUM(CASE WHEN [LQ] >=2.3 AND [LQ] < 3.2 THEN 1 ELSE NULL END)				 AS '2.3>=Fair<3.2'
			   ,SUM(CASE WHEN [LQ] >=3.2 AND [LQ] < 3.7 THEN 1 ELSE NULL END)				 AS '3.2>=Good<3.7'
			   ,SUM(CASE WHEN [LQ] >=3.7 AND [LQ] < 5.0 THEN 1 ELSE NULL END)				 AS '3.7>=Excellent<5.0'
			   ,SUM(CASE WHEN [LQ] >=1.0 AND [LQ] < 1.4 THEN 1 ELSE NULL END)				 AS '1.0>=BadCustom<1.4'
			   ,SUM(CASE WHEN [LQ] >=1.0 AND [LQ] < 1.4 THEN 1 ELSE NULL END)				 AS '1.0>=BadCustom<1.8'
			   ,MIN([timeClipping])															 AS 'MinTimeClipping'
			   ,AVG([timeClipping])															 AS 'AvgTimeClipping'
			   ,master.dbo.Quantil([timeClipping],0.5)										 AS 'MedianTimeClipping'
			   ,MAX([timeClipping])															 AS 'MaxTimeClipping'
			   ,SUM([timeClipping])															 AS 'SumTimeClipping'
			   ,MIN([delaySpread])															 AS 'MinDelaySpread'
			   ,AVG([delaySpread])															 AS 'AvgDelaySpread'
			   ,master.dbo.Quantil([delaySpread],0.5)										 AS 'MedianDelaySpread'
			   ,MAX([delaySpread])															 AS 'MaxDelaySpread'
			   ,SUM([delaySpread])															 AS 'SumDelaySpread'
			   ,MIN([delayDeviation])														 AS 'MindelayDeviation'
			   ,AVG([delayDeviation])														 AS 'AvgdelayDeviation'
			   ,master.dbo.Quantil([delayDeviation],0.5)									 AS 'MediandelayDeviation'
			   ,MAX([delayDeviation])														 AS 'MaxdelayDeviation'
			   ,SUM([delayDeviation])														 AS 'SumdelayDeviation'
			   ,MIN([noiseRcv])																 AS 'MinnoiseRcv'
			   ,AVG([noiseRcv])																 AS 'AvgnoiseRcv'
			   ,master.dbo.Quantil([noiseRcv],0.5)											 AS 'MediannoiseRcv'
			   ,MAX([noiseRcv])																 AS 'MaxnoiseRcv'
			   ,SUM([noiseRcv])																 AS 'SumnoiseRcv'
			   ,MIN([staticSNR])															 AS 'MinstaticSNR'
			   ,AVG([staticSNR])															 AS 'AvgstaticSNR'
			   ,master.dbo.Quantil([staticSNR],0.5)											 AS 'MedianstaticSNR'
			   ,MAX([staticSNR])															 AS 'MaxstaticSNR'
			   ,SUM([staticSNR])															 AS 'SumstaticSNR'
			   ,MIN([ReceiveDelay])															 AS 'MinReceiveDelay'
			   ,AVG([ReceiveDelay])															 AS 'AvgReceiveDelay'
			   ,master.dbo.Quantil([ReceiveDelay],0.5)										 AS 'MedianReceiveDelay'
			   ,MAX([ReceiveDelay])															 AS 'MaxReceiveDelay'
			   ,SUM([ReceiveDelay])															 AS 'SumReceiveDelay'
			   ,MIN([AmplClipping])															 AS 'MinAmplClipping'
			   ,AVG([AmplClipping])															 AS 'AvgAmplClipping'
			   ,master.dbo.Quantil([AmplClipping],0.5)										 AS 'MedianAmplClipping'
			   ,MAX([AmplClipping])															 AS 'MaxAmplClipping'
			   ,SUM([AmplClipping])															 AS 'SumAmplClipping'
			   ,MIN([MissedVoice])															 AS 'MinMissedVoice'
			   ,AVG([MissedVoice])															 AS 'AvgMissedVoice'
			   ,master.dbo.Quantil([MissedVoice],0.5)										 AS 'MedianMissedVoice'
			   ,MAX([MissedVoice])															 AS 'MaxMissedVoice'
			   ,SUM([MissedVoice])															 AS 'SumMissedVoice'
			   ,SUM([Playing_AMR_NB_ms])													 AS [TOTAL_Playing_AMR_NB_ms]
			   ,SUM([Playing_AMR_WB_ms])													 AS [TOTAL_Playing_AMR_WB_ms]
			   ,SUM([Playing_EVS_ms])														 AS [TOTAL_Playing_EVS_ms]
			   ,SUM([Playing_Unknown_ms])													 AS [TOTAL_Playing_Unknown_ms]
			   ,SUM([Playing_AMR_NB_1.8_ms])												 AS [TOTAL_Playing_AMR_NB_1.8_ms]
			   ,SUM([Playing_AMR_NB_4.75_ms])												 AS [TOTAL_Playing_AMR_NB_4.75_ms]
			   ,SUM([Playing_AMR_NB_5.15_ms])												 AS [TOTAL_Playing_AMR_NB_5.15_ms]
			   ,SUM([Playing_AMR_NB_5.9_ms])												 AS [TOTAL_Playing_AMR_NB_5.9_ms]
			   ,SUM([Playing_AMR_NB_6.7_ms])												 AS [TOTAL_Playing_AMR_NB_6.7_ms]
			   ,SUM([Playing_AMR_NB_7.4_ms])												 AS [TOTAL_Playing_AMR_NB_7.4_ms]
			   ,SUM([Playing_AMR_NB_7.95_ms])												 AS [TOTAL_Playing_AMR_NB_7.95_ms]
			   ,SUM([Playing_AMR_NB_10.2_ms])												 AS [TOTAL_Playing_AMR_NB_10.2_ms]
			   ,SUM([Playing_AMR_NB_12.2_ms])												 AS [TOTAL_Playing_AMR_NB_12.2_ms]
			   ,SUM([Playing_AMR_WB_6.6_ms])												 AS [TOTAL_Playing_AMR_WB_6.6_ms]
			   ,SUM([Playing_AMR_WB_8.85_ms])												 AS [TOTAL_Playing_AMR_WB_8.85_ms]
			   ,SUM([Playing_AMR_WB_12.65_ms])												 AS [TOTAL_Playing_AMR_WB_12.65_ms]
			   ,SUM([Playing_AMR_WB_14.25_ms])												 AS [TOTAL_Playing_AMR_WB_14.25_ms]
			   ,SUM([Playing_AMR_WB_15.85_ms])												 AS [TOTAL_Playing_AMR_WB_15.85_ms]
			   ,SUM([Playing_AMR_WB_18.25_ms])												 AS [TOTAL_Playing_AMR_WB_18.25_ms]
			   ,SUM([Playing_AMR_WB_19.85_ms])												 AS [TOTAL_Playing_AMR_WB_19.85_ms]
			   ,SUM([Playing_AMR_WB_23.05_ms])												 AS [TOTAL_Playing_AMR_WB_23.05_ms]
			   ,SUM([Playing_AMR_WB_23.85_ms])												 AS [TOTAL_Playing_AMR_WB_23.85_ms]
			   ,SUM([Playing_EVS_5.9_ms])													 AS [TOTAL_Playing_EVS_5.9_ms]
			   ,SUM([Playing_EVS_7.2_ms])													 AS [TOTAL_Playing_EVS_7.2_ms]
			   ,SUM([Playing_EVS_8_ms])														 AS [TOTAL_Playing_EVS_8_ms]
			   ,SUM([Playing_EVS_9.6_ms])													 AS [TOTAL_Playing_EVS_9.6_ms]
			   ,SUM([Playing_EVS_13.2_ms])													 AS [TOTAL_Playing_EVS_13.2_ms]
			   ,SUM([Playing_EVS_16.4_ms])													 AS [TOTAL_Playing_EVS_16.4_ms]
			   ,SUM([Playing_EVS_24.4_ms])													 AS [TOTAL_Playing_EVS_24.4_ms]
			   ,SUM([Playing_EVS_32_ms])													 AS [TOTAL_Playing_EVS_32_ms]
			   ,SUM([Playing_EVS_48_ms])													 AS [TOTAL_Playing_EVS_48_ms]
			   ,SUM([Playing_EVS_64_ms])													 AS [TOTAL_Playing_EVS_64_ms]
			   ,SUM([Playing_EVS_96_ms])													 AS [TOTAL_Playing_EVS_96_ms]
			   ,SUM([Playing_EVS_128_ms])													 AS [TOTAL_Playing_EVS_128_ms]
			   ,SUM([Recording_AMR_NB_ms])													 AS [TOTAL_Recording_AMR_NB_ms]
			   ,SUM([Recording_AMR_WB_ms])													 AS [TOTAL_Recording_AMR_WB_ms]
			   ,SUM([Recording_EVS_ms])														 AS [TOTAL_Recording_EVS_ms]
			   ,SUM([Recording_Unknown_ms])													 AS [TOTAL_Unknown_EVS_ms]
			   ,SUM([Recording_AMR_NB_1.8_ms])												 AS [TOTAL_Recording_AMR_NB_1.8_ms]
			   ,SUM([Recording_AMR_NB_4.75_ms])												 AS [TOTAL_Recording_AMR_NB_4.75_ms]
			   ,SUM([Recording_AMR_NB_5.15_ms])												 AS [TOTAL_Recording_AMR_NB_5.15_ms]
			   ,SUM([Recording_AMR_NB_5.9_ms])												 AS [TOTAL_Recording_AMR_NB_5.9_ms]
			   ,SUM([Recording_AMR_NB_6.7_ms])												 AS [TOTAL_Recording_AMR_NB_6.7_ms]
			   ,SUM([Recording_AMR_NB_7.4_ms])												 AS [TOTAL_Recording_AMR_NB_7.4_ms]
			   ,SUM([Recording_AMR_NB_7.95_ms])												 AS [TOTAL_Recording_AMR_NB_7.95_ms]
			   ,SUM([Recording_AMR_NB_10.2_ms])												 AS [TOTAL_Recording_AMR_NB_10.2_ms]
			   ,SUM([Recording_AMR_NB_12.2_ms])												 AS [TOTAL_Recording_AMR_NB_12.2_ms]
			   ,SUM([Recording_AMR_WB_6.6_ms])												 AS [TOTAL_Recording_AMR_WB_6.6_ms]
			   ,SUM([Recording_AMR_WB_8.85_ms])												 AS [TOTAL_Recording_AMR_WB_8.85_ms]
			   ,SUM([Recording_AMR_WB_12.65_ms])											 AS [TOTAL_Recording_AMR_WB_12.65_ms]
			   ,SUM([Recording_AMR_WB_14.25_ms])											 AS [TOTAL_Recording_AMR_WB_14.25_ms]
			   ,SUM([Recording_AMR_WB_15.85_ms])											 AS [TOTAL_Recording_AMR_WB_15.85_ms]
			   ,SUM([Recording_AMR_WB_18.25_ms])											 AS [TOTAL_Recording_AMR_WB_18.25_ms]
			   ,SUM([Recording_AMR_WB_19.85_ms])											 AS [TOTAL_Recording_AMR_WB_19.85_ms]
			   ,SUM([Recording_AMR_WB_23.05_ms])											 AS [TOTAL_Recording_AMR_WB_23.05_ms]
			   ,SUM([Recording_AMR_WB_23.85_ms])											 AS [TOTAL_Recording_AMR_WB_23.85_ms]
			   ,SUM([Recording_EVS_5.9_ms])													 AS [TOTAL_Recording_EVS_5.9_ms]
			   ,SUM([Recording_EVS_7.2_ms])													 AS [TOTAL_Recording_EVS_7.2_ms]
			   ,SUM([Recording_EVS_8_ms])													 AS [TOTAL_Recording_EVS_8_ms]
			   ,SUM([Recording_EVS_9.6_ms])													 AS [TOTAL_Recording_EVS_9.6_ms]
			   ,SUM([Recording_EVS_13.2_ms])												 AS [TOTAL_Recording_EVS_13.2_ms]
			   ,SUM([Recording_EVS_16.4_ms])												 AS [TOTAL_Recording_EVS_16.4_ms]
			   ,SUM([Recording_EVS_24.4_ms])												 AS [TOTAL_Recording_EVS_24.4_ms]
			   ,SUM([Recording_EVS_32_ms])													 AS [TOTAL_Recording_EVS_32_ms]
			   ,SUM([Recording_EVS_48_ms])													 AS [TOTAL_Recording_EVS_48_ms]
			   ,SUM([Recording_EVS_64_ms])													 AS [TOTAL_Recording_EVS_64_ms]
			   ,SUM([Recording_EVS_96_ms])													 AS [TOTAL_Recording_EVS_96_ms]
			   ,SUM([Recording_EVS_128_ms])													 AS [TOTAL_Recording_EVS_128_ms]
			   ,SUM(CASE WHEN LQ >=1.0 AND LQ < 1.1 THEN 1 ELSE 0 END)						 AS 'LQ >=1.0 and < 1.1'
			   ,SUM(CASE WHEN LQ >=1.1 AND LQ < 1.2 THEN 1 ELSE 0 END)						 AS 'LQ >=1.1 and < 1.2'
			   ,SUM(CASE WHEN LQ >=1.2 AND LQ < 1.3 THEN 1 ELSE 0 END)						 AS 'LQ >=1.2 and < 1.3'
			   ,SUM(CASE WHEN LQ >=1.3 AND LQ < 1.4 THEN 1 ELSE 0 END)						 AS 'LQ >=1.3 and < 1.4'
			   ,SUM(CASE WHEN LQ >=1.4 AND LQ < 1.5 THEN 1 ELSE 0 END)						 AS 'LQ >=1.4 and < 1.5'
			   ,SUM(CASE WHEN LQ >=1.5 AND LQ < 1.6 THEN 1 ELSE 0 END)						 AS 'LQ >=1.5 and < 1.6'
			   ,SUM(CASE WHEN LQ >=1.6 AND LQ < 1.7 THEN 1 ELSE 0 END)						 AS 'LQ >=1.6 and < 1.7'
			   ,SUM(CASE WHEN LQ >=1.7 AND LQ < 1.8 THEN 1 ELSE 0 END)						 AS 'LQ >=1.7 and < 1.8'
			   ,SUM(CASE WHEN LQ >=1.8 AND LQ < 1.9 THEN 1 ELSE 0 END)						 AS 'LQ >=1.8 and < 1.9'
			   ,SUM(CASE WHEN LQ >=1.9 AND LQ < 2.0 THEN 1 ELSE 0 END)						 AS 'LQ >=1.9 and < 2.0'
			   ,SUM(CASE WHEN LQ >=2.0 AND LQ < 2.1 THEN 1 ELSE 0 END)						 AS 'LQ >=2.0 and < 2.1'
			   ,SUM(CASE WHEN LQ >=2.1 AND LQ < 2.2 THEN 1 ELSE 0 END)						 AS 'LQ >=2.1 and < 2.2'
			   ,SUM(CASE WHEN LQ >=2.2 AND LQ < 2.3 THEN 1 ELSE 0 END)						 AS 'LQ >=2.2 and < 2.3'
			   ,SUM(CASE WHEN LQ >=2.3 AND LQ < 2.4 THEN 1 ELSE 0 END)						 AS 'LQ >=2.3 and < 2.4'
			   ,SUM(CASE WHEN LQ >=2.4 AND LQ < 2.5 THEN 1 ELSE 0 END)						 AS 'LQ >=2.4 and < 2.5'
			   ,SUM(CASE WHEN LQ >=2.5 AND LQ < 2.6 THEN 1 ELSE 0 END)						 AS 'LQ >=2.5 and < 2.6'
			   ,SUM(CASE WHEN LQ >=2.6 AND LQ < 2.7 THEN 1 ELSE 0 END)						 AS 'LQ >=2.6 and < 2.7'
			   ,SUM(CASE WHEN LQ >=2.7 AND LQ < 2.8 THEN 1 ELSE 0 END)						 AS 'LQ >=2.7 and < 2.8'
			   ,SUM(CASE WHEN LQ >=2.8 AND LQ < 2.9 THEN 1 ELSE 0 END)						 AS 'LQ >=2.8 and < 2.9'
			   ,SUM(CASE WHEN LQ >=2.9 AND LQ < 3.0 THEN 1 ELSE 0 END)						 AS 'LQ >=2.9 and < 3.0'
			   ,SUM(CASE WHEN LQ >=3.0 AND LQ < 3.1 THEN 1 ELSE 0 END)						 AS 'LQ >=3.0 and < 3.1'
			   ,SUM(CASE WHEN LQ >=3.1 AND LQ < 3.2 THEN 1 ELSE 0 END)						 AS 'LQ >=3.1 and < 3.2'
			   ,SUM(CASE WHEN LQ >=3.2 AND LQ < 3.3 THEN 1 ELSE 0 END)						 AS 'LQ >=3.2 and < 3.3'
			   ,SUM(CASE WHEN LQ >=3.3 AND LQ < 3.4 THEN 1 ELSE 0 END)						 AS 'LQ >=3.3 and < 3.4'
			   ,SUM(CASE WHEN LQ >=3.4 AND LQ < 3.5 THEN 1 ELSE 0 END)						 AS 'LQ >=3.4 and < 3.5'
			   ,SUM(CASE WHEN LQ >=3.5 AND LQ < 3.6 THEN 1 ELSE 0 END)						 AS 'LQ >=3.5 and < 3.6'
			   ,SUM(CASE WHEN LQ >=3.6 AND LQ < 3.7 THEN 1 ELSE 0 END)						 AS 'LQ >=3.6 and < 3.7'
			   ,SUM(CASE WHEN LQ >=3.7 AND LQ < 3.8 THEN 1 ELSE 0 END)						 AS 'LQ >=3.7 and < 3.8'
			   ,SUM(CASE WHEN LQ >=3.8 AND LQ < 3.9 THEN 1 ELSE 0 END)						 AS 'LQ >=3.8 and < 3.9'
			   ,SUM(CASE WHEN LQ >=3.9 AND LQ < 4.0 THEN 1 ELSE 0 END)						 AS 'LQ >=3.9 and < 4.0'
			   ,SUM(CASE WHEN LQ >=4.0 AND LQ < 4.1 THEN 1 ELSE 0 END)						 AS 'LQ >=4.0 and < 4.1'
			   ,SUM(CASE WHEN LQ >=4.1 AND LQ < 4.2 THEN 1 ELSE 0 END)						 AS 'LQ >=4.1 and < 4.2'
			   ,SUM(CASE WHEN LQ >=4.2 AND LQ < 4.3 THEN 1 ELSE 0 END)						 AS 'LQ >=4.2 and < 4.3'
			   ,SUM(CASE WHEN LQ >=4.3 AND LQ < 4.4 THEN 1 ELSE 0 END)						 AS 'LQ >=4.3 and < 4.4'
			   ,SUM(CASE WHEN LQ >=4.4 AND LQ < 4.5 THEN 1 ELSE 0 END)						 AS 'LQ >=4.4 and < 4.5'
			   ,SUM(CASE WHEN LQ >=4.5 AND LQ < 4.6 THEN 1 ELSE 0 END)						 AS 'LQ >=4.5 and < 4.6'
			   ,SUM(CASE WHEN LQ >=4.6 AND LQ < 4.7 THEN 1 ELSE 0 END)						 AS 'LQ >=4.6 and < 4.7'
			   ,SUM(CASE WHEN LQ >=4.7 AND LQ < 4.8 THEN 1 ELSE 0 END)						 AS 'LQ >=4.7 and < 4.8'
			   ,SUM(CASE WHEN LQ >=4.8 AND LQ < 4.9 THEN 1 ELSE 0 END)						 AS 'LQ >=4.8 and < 4.9'
			   ,SUM(CASE WHEN LQ >=4.9 AND LQ < 5.0 THEN 1 ELSE 0 END)						 AS 'LQ >=4.9 and < 5.0'
		  INTO NEW_RESULTS_SQ_Session_2018
		  FROM NEW_RESULTS_SQ_Test_2018
		  GROUP BY [SessionIdA],[SessionIdB]
		  ORDER BY [SessionIdA],[SessionIdB]
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_RESULTS_SQ_Session_2018 Table Successfully created...')
-- Drop Temporary Tables
IF OBJECT_ID ('tempdb..#ExistingTests' ) IS NOT NULL DROP TABLE #ExistingTests
IF OBJECT_ID ('tempdb..#CodecRaw' ) IS NOT NULL DROP TABLE #CodecRaw
IF OBJECT_ID ('tempdb..#CodecAggr' ) IS NOT NULL DROP TABLE #CodecAggr
IF OBJECT_ID ('tempdb..#CodecFinal' ) IS NOT NULL DROP TABLE #CodecFinal

----------------
-- VALIDATION --
----------------
-- select * from NEW_RESULTS_SQ_Test_2018 where Playing_longitude is null or Recording_longitude is null
-- select * from NEW_RESULTS_SQ_Session_2018 where TestId =
-- select * from [VoiceCodecTest] where TestId = 60904