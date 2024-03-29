PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Script Execution starting ...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CREATING TABLE: NEW_CDR_SPEECH_2018...')
IF OBJECT_ID (N'dbo.NEW_CDR_SPEECH_2018', N'U') IS NOT NULL DROP table [NEW_CDR_SPEECH_2018]
		SELECT   cdr.Validity
				,cdr.Invalid_Reason
				,CASE WHEN cdr.Campaign_A is not null THEN cdr.Campaign_A
					  ELSE cdr.Campaign_B
					  END AS [Campaign]
				,cdr.ASideFileName												AS [File_Name_A]
				,cdr.ASideFileName												AS [File_Name_B]
				,cdr.[FileID_A]
				,cdr.[FileId_B]
				,cdr.[SessionID_A]
				,cdr.[SessionId_B]
				,cdr.[Sequenz_ID_per_File_A]
				,cdr.[Call_Status]
				,cdr.[MO:Dial]													AS [Call_Start_Time]
				,cdr.Call_End_Trigger										    AS [Call_End_Time]
				,cdr.System_Name_A												AS System_A
				,cdr.SW_A														AS System_Software_A 
				,cdr.[Channel_A]
				,cdr.[Channel_Description_A]
				,cdr.System_Name_B												AS System_B
				,cdr.SW_B														AS System_Software_B
				,cdr.[Channel_B]
				,cdr.[Channel_Description_B]
				,cdr.[Operator]
				,cdr.[Session_Type]
				,cdr.callDir													AS [Call_Direction]
				,cdr.Dialed_Number												AS [DialedNumber]
				,cdr.Call_Mode_L1_A												AS [L1_callMode_A]
				,cdr.Call_Mode_L2_A												AS [L2_callMode_A]
				,cdr.Call_Mode_L1_B												AS [L1_callMode_B]
				,cdr.Call_Mode_L2_B												AS [L2_callMode_B]
				,datepart(year,[MO:Dial])										AS [Year]
				,datepart(week,[MO:Dial])										AS [Week]
				,datepart(month,[MO:Dial])										AS [Month]
				,datepart(day,[MO:Dial])										AS [Day]
				,datepart(hour,[MO:Dial])										AS [Hour]
				,cdr.[G_Level_1_A]		AS [G_Level_1]
				,cdr.[G_Level_2_A]		AS [G_Level_2]
				,cdr.[G_Level_3_A]		AS [G_Level_3]
				,cdr.[G_Level_4_A]		AS [G_Level_4]
				,cdr.[G_Level_5_A]		AS [G_Level_5]
				,cdr.[G_Remarks_A]		AS [G_Remarks]
				,cdr.[TrainType_A]		AS [TrainType]
				,cdr.[TrainName_A]		AS [Fleet]
				,cdr.[WagonNumber_A]	AS [WagonNumber]
				,cdr.[WagonRepeter_A]	AS [WagonRepeter]
				,cdr.Vendor_A			AS Vendor
				,cdr.Region_A			AS Region
				,cdr.[UE_A]
				,cdr.[FW_A]
				,cdr.[IMEI_A]
				,cdr.[IMSI_A]
				,cdr.[MSISDN_A]
				,cdr.[UE_B]
				,cdr.[FW_B]
				,cdr.[IMEI_B]
				,cdr.[IMSI_B]
				,cdr.[MSISDN_B]
				,cdr.POLQA_LQ_AVG
				,sq.[TestId]
				,sq.[direction]
				,sq.[SpeedAvg]
				,sq.[TestStart]
				,sq.[TestEnd]
				,sq.[LQ]
				,CASE WHEN Call_Mode_L1_A like 'VoLTE' and Call_Mode_L1_B like 'VoLTE' THEN LQ
					  ELSE null
					  END AS L1_VoLTE_Call_Mode_LQ
				,CASE WHEN Call_Mode_L2_A like 'VoLTE' and Call_Mode_L2_B like 'VoLTE' THEN LQ
					  ELSE null
					  END AS L2_VoLTE_Call_Mode_LQ
				,sq.[qualityCode]
				,sq.[LQCat]
				,sq.[timeClipping]
				,sq.[posFreqShift]
				,sq.[negFreqShift]
				,sq.[refDCOffset]
				,sq.[codedDcOffset]
				,sq.[delaySpread]
				,sq.[codedLevel]
				,sq.[delayDeviation]
				,sq.[aSLrcvP56]
				,sq.[activityRcvP56]
				,sq.[noiseRcv]
				,sq.[staticSNR]
				,sq.[appl]
				,sq.[ReceiveDelay]
				,sq.[AmplClipping]
				,sq.[MissedVoice]
				,sq.[LowerFilterLimit]
				,sq.[UpperFilterLimit]
				,sq.[ErrCode]
				,sq.[BW] AS [WideBand]
				,sq.[BW]
				,sq.[Resampling]
				,sq.[Playing_Technology]
				,sq.[Playing_Technology_Detailed]
				,sq.[Playing_Codec]
				,sq.[Playing_Codec_Detailed]
				,sq.[Playing_AMR_NB_ms]
				,sq.[Playing_AMR_WB_ms]
				,sq.[Playing_EVS_ms]
				,sq.[Playing_AMR_NB_1.8_ms]
				,sq.[Playing_AMR_NB_4.75_ms]
				,sq.[Playing_AMR_NB_5.15_ms]
				,sq.[Playing_AMR_NB_5.9_ms]
				,sq.[Playing_AMR_NB_6.7_ms]
				,sq.[Playing_AMR_NB_7.4_ms]
				,sq.[Playing_AMR_NB_7.95_ms]
				,sq.[Playing_AMR_NB_10.2_ms]
				,sq.[Playing_AMR_NB_12.2_ms]
				,sq.[Playing_AMR_WB_6.6_ms]
				,sq.[Playing_AMR_WB_8.85_ms]
				,sq.[Playing_AMR_WB_12.65_ms]
				,sq.[Playing_AMR_WB_14.25_ms]
				,sq.[Playing_AMR_WB_15.85_ms]
				,sq.[Playing_AMR_WB_18.25_ms]
				,sq.[Playing_AMR_WB_19.85_ms]
				,sq.[Playing_AMR_WB_23.05_ms]
				,sq.[Playing_AMR_WB_23.85_ms]
				,sq.[Playing_EVS_5.9_ms]
				,sq.[Playing_EVS_7.2_ms]
				,sq.[Playing_EVS_8_ms]
				,sq.[Playing_EVS_9.6_ms]
				,sq.[Playing_EVS_13.2_ms]
				,sq.[Playing_EVS_16.4_ms]
				,sq.[Playing_EVS_24.4_ms]
				,sq.[Playing_EVS_32_ms]
				,sq.[Playing_EVS_48_ms]
				,sq.[Playing_EVS_64_ms]
				,sq.[Playing_EVS_96_ms]
				,sq.[Playing_EVS_128_ms]
				,CAST(null as decimal(10,2))					AS      Playing_MinRxLev
				,CAST(null as decimal(10,2))					AS      Playing_AvgRxLev
				,CAST(null as decimal(10,2))					AS      Playing_MaxRxLev
				,CAST(null as decimal(10,2))					AS      Playing_MinRxQual
				,CAST(null as decimal(10,2))					AS      Playing_AvgRxQual
				,CAST(null as decimal(10,2))					AS      Playing_MaxRxQual
				,CAST(null as decimal(10,2))					AS      Playing_MinRSCP
				,CAST(null as decimal(10,2))					AS      Playing_AvgRSCP
				,CAST(null as decimal(10,2))					AS      Playing_MaxRSCP
				,CAST(null as decimal(10,2))					AS      Playing_MinEcIo
				,CAST(null as decimal(10,2))					AS      Playing_AvgEcIo
				,CAST(null as decimal(10,2))					AS      Playing_MaxEcIo
				,CAST(null as decimal(10,2))					AS      Playing_MinTxPwr3G
				,CAST(null as decimal(10,2))					AS      Playing_AvgTxPwr3G
				,CAST(null as decimal(10,2))					AS      Playing_MaxTxPwr3G
				,CAST(null as decimal(10,2))					AS      Playing_MinRSRP
				,CAST(null as decimal(10,2))					AS      Playing_AvgRSRP
				,CAST(null as decimal(10,2))					AS      Playing_MaxRSRP
				,CAST(null as decimal(10,2))					AS      Playing_MinRSRQ
				,CAST(null as decimal(10,2))					AS      Playing_AvgRSRQ
				,CAST(null as decimal(10,2))					AS      Playing_MaxRSRQ
				,CAST(null as decimal(10,2))					AS      Playing_MinSINR
				,CAST(null as decimal(10,2))					AS      Playing_AvgSINR
				,CAST(null as decimal(10,2))					AS      Playing_MaxSINR
				,CAST(null as decimal(10,2))					AS      Playing_MinTxPwr4G
				,CAST(null as decimal(10,2))					AS      Playing_AvgTxPwr4G
				,CAST(null as decimal(10,2))					AS      Playing_MaxTxPwr4G
				,CAST(null as varchar(5000))					AS      Playing_Handovers
				,sq.[Playing_Speed_kmh]
				,sq.[Playing_Longitude]
				,sq.[Playing_Latitude]
				,sq.[Recording Technology]
				,sq.[Recording Technology Detailed]
				,sq.[Recording Codec]
				,sq.[Recording Codec Detailed]
				,sq.[Recording_AMR_NB_ms]
				,sq.[Recording_AMR_WB_ms]
				,sq.[Recording_EVS_ms]
				,sq.[Recording_AMR_NB_1.8_ms]
				,sq.[Recording_AMR_NB_4.75_ms]
				,sq.[Recording_AMR_NB_5.15_ms]
				,sq.[Recording_AMR_NB_5.9_ms]
				,sq.[Recording_AMR_NB_6.7_ms]
				,sq.[Recording_AMR_NB_7.4_ms]
				,sq.[Recording_AMR_NB_7.95_ms]
				,sq.[Recording_AMR_NB_10.2_ms]
				,sq.[Recording_AMR_NB_12.2_ms]
				,sq.[Recording_AMR_WB_6.6_ms]
				,sq.[Recording_AMR_WB_8.85_ms]
				,sq.[Recording_AMR_WB_12.65_ms]
				,sq.[Recording_AMR_WB_14.25_ms]
				,sq.[Recording_AMR_WB_15.85_ms]
				,sq.[Recording_AMR_WB_18.25_ms]
				,sq.[Recording_AMR_WB_19.85_ms]
				,sq.[Recording_AMR_WB_23.05_ms]
				,sq.[Recording_AMR_WB_23.85_ms]
				,sq.[Recording_EVS_5.9_ms]
				,sq.[Recording_EVS_7.2_ms]
				,sq.[Recording_EVS_8_ms]
				,sq.[Recording_EVS_9.6_ms]
				,sq.[Recording_EVS_13.2_ms]
				,sq.[Recording_EVS_16.4_ms]
				,sq.[Recording_EVS_24.4_ms]
				,sq.[Recording_EVS_32_ms]
				,sq.[Recording_EVS_48_ms]
				,sq.[Recording_EVS_64_ms]
				,sq.[Recording_EVS_96_ms]
				,sq.[Recording_EVS_128_ms]
				,CAST(null as decimal(10,2))					AS      Recording_MinRxLev
				,CAST(null as decimal(10,2))					AS      Recording_AvgRxLev
				,CAST(null as decimal(10,2))					AS      Recording_MaxRxLev
				,CAST(null as decimal(10,2))					AS      Recording_MinRxQual
				,CAST(null as decimal(10,2))					AS      Recording_AvgRxQual
				,CAST(null as decimal(10,2))					AS      Recording_MaxRxQual
				,CAST(null as decimal(10,2))					AS      Recording_MinRSCP
				,CAST(null as decimal(10,2))					AS      Recording_AvgRSCP
				,CAST(null as decimal(10,2))					AS      Recording_MaxRSCP
				,CAST(null as decimal(10,2))					AS      Recording_MinEcIo
				,CAST(null as decimal(10,2))					AS      Recording_AvgEcIo
				,CAST(null as decimal(10,2))					AS      Recording_MaxEcIo
				,CAST(null as decimal(10,2))					AS      Recording_MinTxPwr3G
				,CAST(null as decimal(10,2))					AS      Recording_AvgTxPwr3G
				,CAST(null as decimal(10,2))					AS      Recording_MaxTxPwr3G
				,CAST(null as decimal(10,2))					AS      Recording_MinRSRP
				,CAST(null as decimal(10,2))					AS      Recording_AvgRSRP
				,CAST(null as decimal(10,2))					AS      Recording_MaxRSRP
				,CAST(null as decimal(10,2))					AS      Recording_MinRSRQ
				,CAST(null as decimal(10,2))					AS      Recording_AvgRSRQ
				,CAST(null as decimal(10,2))					AS      Recording_MaxRSRQ
				,CAST(null as decimal(10,2))					AS      Recording_MinSINR
				,CAST(null as decimal(10,2))					AS      Recording_AvgSINR
				,CAST(null as decimal(10,2))					AS      Recording_MaxSINR
				,CAST(null as decimal(10,2))					AS      Recording_MinTxPwr4G
				,CAST(null as decimal(10,2))					AS      Recording_AvgTxPwr4G
				,CAST(null as decimal(10,2))					AS      Recording_MaxTxPwr4G
				,CAST(null as varchar(5000))					AS      Recording_Handovers
				,sq.[Recording_Speed_kmh]
				,sq.[Recording_Longitude]
				,sq.[Recording_Latitude]
		  INTO NEW_CDR_SPEECH_2018
		  FROM NEW_RESULTS_SQ_Test_2018 sq
		  LEFT OUTER JOIN NEW_CDR_VOICE_2018 cdr on cdr.SessionId_A = sq.SessionIdA
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_SPEECH_2018 with RF Values...')
		UPDATE NEW_CDR_SPEECH_2018
		 SET    Playing_MinRxLev	  = MinRxLev	
			   ,Playing_AvgRxLev	  = AvgRxLev	
			   ,Playing_MaxRxLev	  = MaxRxLev	
			   ,Playing_MinRxQual	  = MinRxQual
			   ,Playing_AvgRxQual	  = AvgRxQual
			   ,Playing_MaxRxQual	  = MaxRxQual
			   ,Playing_MinRSCP		  = MinRSCP		
			   ,Playing_AvgRSCP		  = AvgRSCP		
			   ,Playing_MaxRSCP		  = MaxRSCP		
			   ,Playing_MinEcIo		  = MinEcIo		
			   ,Playing_AvgEcIo		  = AvgEcIo		
			   ,Playing_MaxEcIo		  = MaxEcIo		
			   ,Playing_MinTxPwr3G	  = MinTxPwr3G
			   ,Playing_AvgTxPwr3G	  = AvgTxPwr3G
			   ,Playing_MaxTxPwr3G	  = MaxTxPwr3G
			   ,Playing_MinRSRP		  = MinRSRP		
			   ,Playing_AvgRSRP		  = AvgRSRP		
			   ,Playing_MaxRSRP		  = MaxRSRP		
			   ,Playing_MinRSRQ		  = MinRSRQ		
			   ,Playing_AvgRSRQ		  = AvgRSRQ		
			   ,Playing_MaxRSRQ		  = MaxRSRQ		
			   ,Playing_MinSINR		  = MinSINR		
			   ,Playing_AvgSINR		  = AvgSINR		
			   ,Playing_MaxSINR		  = MaxSINR		
			   ,Playing_MinTxPwr4G	  = MinTxPwr4G
			   ,Playing_AvgTxPwr4G	  = AvgTxPwr4G
			   ,Playing_MaxTxPwr4G	  = MaxTxPwr4G
		  FROM NEW_CDR_SPEECH_2018 a
		  LEFT OUTER JOIN NEW_RF_Test_2018 b on a.SessionId_A = b.SessionId and a.TestId = b.TestId
		  where a.[Call_Direction] like 'A->%'

		UPDATE NEW_CDR_SPEECH_2018
		 SET    Playing_MinRxLev	  = MinRxLev	
			   ,Playing_AvgRxLev	  = AvgRxLev	
			   ,Playing_MaxRxLev	  = MaxRxLev	
			   ,Playing_MinRxQual	  = MinRxQual
			   ,Playing_AvgRxQual	  = AvgRxQual
			   ,Playing_MaxRxQual	  = MaxRxQual
			   ,Playing_MinRSCP		  = MinRSCP		
			   ,Playing_AvgRSCP		  = AvgRSCP		
			   ,Playing_MaxRSCP		  = MaxRSCP		
			   ,Playing_MinEcIo		  = MinEcIo		
			   ,Playing_AvgEcIo		  = AvgEcIo		
			   ,Playing_MaxEcIo		  = MaxEcIo		
			   ,Playing_MinTxPwr3G	  = MinTxPwr3G
			   ,Playing_AvgTxPwr3G	  = AvgTxPwr3G
			   ,Playing_MaxTxPwr3G	  = MaxTxPwr3G
			   ,Playing_MinRSRP		  = MinRSRP		
			   ,Playing_AvgRSRP		  = AvgRSRP		
			   ,Playing_MaxRSRP		  = MaxRSRP		
			   ,Playing_MinRSRQ		  = MinRSRQ		
			   ,Playing_AvgRSRQ		  = AvgRSRQ		
			   ,Playing_MaxRSRQ		  = MaxRSRQ		
			   ,Playing_MinSINR		  = MinSINR		
			   ,Playing_AvgSINR		  = AvgSINR		
			   ,Playing_MaxSINR		  = MaxSINR		
			   ,Playing_MinTxPwr4G	  = MinTxPwr4G
			   ,Playing_AvgTxPwr4G	  = AvgTxPwr4G
			   ,Playing_MaxTxPwr4G	  = MaxTxPwr4G
		  FROM NEW_CDR_SPEECH_2018 a
		  LEFT OUTER JOIN NEW_RF_Test_2018 b on a.SessionId_B = b.SessionId and a.TestId = b.TestId
		  where a.[Call_Direction] like 'B->%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_SPEECH_2018 with RF Values...')
		UPDATE NEW_CDR_SPEECH_2018
		 SET    Recording_MinRxLev		  = MinRxLev	
			   ,Recording_AvgRxLev		  = AvgRxLev	
			   ,Recording_MaxRxLev		  = MaxRxLev	
			   ,Recording_MinRxQual		  = MinRxQual
			   ,Recording_AvgRxQual		  = AvgRxQual
			   ,Recording_MaxRxQual		  = MaxRxQual
			   ,Recording_MinRSCP		  = MinRSCP		
			   ,Recording_AvgRSCP		  = AvgRSCP		
			   ,Recording_MaxRSCP		  = MaxRSCP		
			   ,Recording_MinEcIo		  = MinEcIo		
			   ,Recording_AvgEcIo		  = AvgEcIo		
			   ,Recording_MaxEcIo		  = MaxEcIo		
			   ,Recording_MinTxPwr3G	  = MinTxPwr3G
			   ,Recording_AvgTxPwr3G	  = AvgTxPwr3G
			   ,Recording_MaxTxPwr3G	  = MaxTxPwr3G
			   ,Recording_MinRSRP		  = MinRSRP		
			   ,Recording_AvgRSRP		  = AvgRSRP		
			   ,Recording_MaxRSRP		  = MaxRSRP		
			   ,Recording_MinRSRQ		  = MinRSRQ		
			   ,Recording_AvgRSRQ		  = AvgRSRQ		
			   ,Recording_MaxRSRQ		  = MaxRSRQ		
			   ,Recording_MinSINR		  = MinSINR		
			   ,Recording_AvgSINR		  = AvgSINR		
			   ,Recording_MaxSINR		  = MaxSINR		
			   ,Recording_MinTxPwr4G	  = MinTxPwr4G
			   ,Recording_AvgTxPwr4G	  = AvgTxPwr4G
			   ,Recording_MaxTxPwr4G	  = MaxTxPwr4G
		  FROM NEW_CDR_SPEECH_2018 a
		  LEFT OUTER JOIN NEW_RF_Test_2018 b on a.SessionId_A = b.SessionId and a.TestId = b.TestId
		  where a.[Call_Direction] like '%->A'

		UPDATE NEW_CDR_SPEECH_2018
		 SET    Recording_MinRxLev	      = MinRxLev	
			   ,Recording_AvgRxLev	      = AvgRxLev	
			   ,Recording_MaxRxLev	      = MaxRxLev	
			   ,Recording_MinRxQual	      = MinRxQual
			   ,Recording_AvgRxQual	      = AvgRxQual
			   ,Recording_MaxRxQual	      = MaxRxQual
			   ,Recording_MinRSCP		  = MinRSCP		
			   ,Recording_AvgRSCP		  = AvgRSCP		
			   ,Recording_MaxRSCP		  = MaxRSCP		
			   ,Recording_MinEcIo		  = MinEcIo		
			   ,Recording_AvgEcIo		  = AvgEcIo		
			   ,Recording_MaxEcIo		  = MaxEcIo		
			   ,Recording_MinTxPwr3G	  = MinTxPwr3G
			   ,Recording_AvgTxPwr3G	  = AvgTxPwr3G
			   ,Recording_MaxTxPwr3G	  = MaxTxPwr3G
			   ,Recording_MinRSRP		  = MinRSRP		
			   ,Recording_AvgRSRP		  = AvgRSRP		
			   ,Recording_MaxRSRP		  = MaxRSRP		
			   ,Recording_MinRSRQ		  = MinRSRQ		
			   ,Recording_AvgRSRQ		  = AvgRSRQ		
			   ,Recording_MaxRSRQ		  = MaxRSRQ		
			   ,Recording_MinSINR		  = MinSINR		
			   ,Recording_AvgSINR		  = AvgSINR		
			   ,Recording_MaxSINR		  = MaxSINR		
			   ,Recording_MinTxPwr4G	  = MinTxPwr4G
			   ,Recording_AvgTxPwr4G	  = AvgTxPwr4G
			   ,Recording_MaxTxPwr4G	  = MaxTxPwr4G
		  FROM NEW_CDR_SPEECH_2018 a
		  LEFT OUTER JOIN NEW_RF_Test_2018 b on a.SessionId_B = b.SessionId and a.TestId = b.TestId
		  where a.[Call_Direction] like '%->B'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_SPEECH_2018 with Handover Values...')
		UPDATE NEW_CDR_SPEECH_2018
		 SET    Playing_Handovers	  = HandoversInfo
		 FROM NEW_CDR_SPEECH_2018 a
		 LEFT OUTER JOIN NEW_RAN_TEST_2019 b on a.SessionId_A = b.SessionId and a.TestId = b.TestId
		 where a.[Call_Direction] like 'A->%'

		UPDATE NEW_CDR_SPEECH_2018
		 SET    Playing_Handovers	  = HandoversInfo
		 FROM NEW_CDR_SPEECH_2018 a
		 LEFT OUTER JOIN NEW_RAN_TEST_2019 b on a.SessionId_B = b.SessionId and a.TestId = b.TestId
		 where a.[Call_Direction] like 'B->%'

		UPDATE NEW_CDR_SPEECH_2018
		 SET    Recording_Handovers	  = HandoversInfo
		 FROM NEW_CDR_SPEECH_2018 a
		 LEFT OUTER JOIN NEW_RAN_TEST_2019 b on a.SessionId_A = b.SessionId and a.TestId = b.TestId
		 where a.[Call_Direction] like '%->A'

		UPDATE NEW_CDR_SPEECH_2018
		 SET    Recording_Handovers	  = HandoversInfo
		 FROM NEW_CDR_SPEECH_2018 a
		 LEFT OUTER JOIN NEW_RAN_TEST_2019 b on a.SessionId_B = b.SessionId and a.TestId = b.TestId
		 where a.[Call_Direction] like '%->B'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_SPEECH_2018 invalidate all failed and dropped samples...')
		UPDATE NEW_CDR_SPEECH_2018
		SET Validity = 0 
		WHERE Call_Status not like 'Completed%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script execution completed...')

-- select * from NEW_CDR_SPEECH_2018 WHERE Validity = 1 ORDER BY Call_Start_Time,TestStart
 

-- invalidate playing/recording codec for WhatsApp calls -- will be fixed with start of Q2 --
update NEW_CDR_SPEECH_2018
	set  [Playing_Codec]				=	'Unknown'
		,[Playing_Codec_Detailed]		=	'Unknown-0 [7999]'
		,[Playing_AMR_NB_ms]			=	0
		,[Playing_AMR_WB_ms]			=	0
		,[Playing_EVS_ms]				=	0
		,[Playing_AMR_NB_1.8_ms]		=	0
		,[Playing_AMR_NB_4.75_ms]		=	0
		,[Playing_AMR_NB_5.15_ms]		=	0
		,[Playing_AMR_NB_5.9_ms]		=	0
		,[Playing_AMR_NB_6.7_ms]		=	0
		,[Playing_AMR_NB_7.4_ms]		=	0
		,[Playing_AMR_NB_7.95_ms]		=	0
		,[Playing_AMR_NB_10.2_ms]		=	0
		,[Playing_AMR_NB_12.2_ms]		=	0
		,[Playing_AMR_WB_6.6_ms]		=	0
		,[Playing_AMR_WB_8.85_ms]		=	0
		,[Playing_AMR_WB_12.65_ms]		=	0
		,[Playing_AMR_WB_14.25_ms]		=	0
		,[Playing_AMR_WB_15.85_ms]		=	0
		,[Playing_AMR_WB_18.25_ms]		=	0
		,[Playing_AMR_WB_19.85_ms]		=	0
		,[Playing_AMR_WB_23.05_ms]		=	0
		,[Playing_AMR_WB_23.85_ms]		=	0
		,[Playing_EVS_5.9_ms]			=	0
		,[Playing_EVS_7.2_ms]			=	0
		,[Playing_EVS_8_ms]				=	0
		,[Playing_EVS_9.6_ms]			=	0
		,[Playing_EVS_13.2_ms]			=	0
		,[Playing_EVS_16.4_ms]			=	0
		,[Playing_EVS_24.4_ms]			=	0
		,[Playing_EVS_32_ms]			=	0
		,[Playing_EVS_48_ms]			=	0
		,[Playing_EVS_64_ms]			=	0
		,[Playing_EVS_96_ms]			=	0
		,[Playing_EVS_128_ms]			=	0
		,[Recording Codec]				=	'Unknown'
		,[Recording Codec Detailed]		=	'Unknown-0 [8000]'
		,[Recording_AMR_NB_ms]			=	0
		,[Recording_AMR_WB_ms]			=	0
		,[Recording_EVS_ms]				=	0
		,[Recording_AMR_NB_1.8_ms]		=	0
		,[Recording_AMR_NB_4.75_ms]		=	0
		,[Recording_AMR_NB_5.15_ms]		=	0
		,[Recording_AMR_NB_5.9_ms]		=	0
		,[Recording_AMR_NB_6.7_ms]		=	0
		,[Recording_AMR_NB_7.4_ms]		=	0
		,[Recording_AMR_NB_7.95_ms]		=	0
		,[Recording_AMR_NB_10.2_ms]		=	0
		,[Recording_AMR_NB_12.2_ms]		=	0
		,[Recording_AMR_WB_6.6_ms]		=	0
		,[Recording_AMR_WB_8.85_ms]		=	0
		,[Recording_AMR_WB_12.65_ms]	=	0
		,[Recording_AMR_WB_14.25_ms]	=	0
		,[Recording_AMR_WB_15.85_ms]	=	0
		,[Recording_AMR_WB_18.25_ms]	=	0
		,[Recording_AMR_WB_19.85_ms]	=	0
		,[Recording_AMR_WB_23.05_ms]	=	0
		,[Recording_AMR_WB_23.85_ms]	=	0
		,[Recording_EVS_5.9_ms]			=	0
		,[Recording_EVS_7.2_ms]			=	0
		,[Recording_EVS_8_ms]			=	0
		,[Recording_EVS_9.6_ms]			=	0
		,[Recording_EVS_13.2_ms]		=	0
		,[Recording_EVS_16.4_ms]		=	0
		,[Recording_EVS_24.4_ms]		=	0
		,[Recording_EVS_32_ms]			=	0
		,[Recording_EVS_48_ms]			=	0
		,[Recording_EVS_64_ms]			=	0
		,[Recording_EVS_96_ms]			=	0
		,[Recording_EVS_128_ms]			=	0


 where Session_Type = 'WhatsApp CALL'