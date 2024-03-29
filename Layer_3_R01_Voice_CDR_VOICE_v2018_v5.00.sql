------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING TABLES IF THEY DO NOT EXIST
-- Table: NEW_CDR_VOICE_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Script Execution starting ...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CREATING TABLE: NEW_CDR_VOICE_2018...')
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_CDR_VOICE_2018')	DROP Table NEW_CDR_VOICE_2018
	SELECT 1 as Validity
		  ,CAST(null as varchar(100))	   AS		Invalid_Reason
		  ,CAST(null as varchar(103 ))	   AS       Operator
		  ,[SessionId_A]				   AS		SessionId_PRIM_KEY
		  ,[Session_Type]
		  ,[Call_Status]
		  ,CAST(null as varchar(12 ))      AS      FAILURE_PHASE
		  ,CAST(null as varchar(2 ))       AS      FAILURE_SIDE
		  ,CAST(null as varchar(8 ))       AS      FAILURE_TECHNOLOGY
		  ,CAST(null as varchar(200 ))     AS      FAILURE_CLASS
		  ,CAST(null as varchar(200 ))     AS      FAILURE_CATEGORY
		  ,CAST(null as varchar(200 ))     AS      FAILURE_SUBCATEGORY
		  ,CAST(null as text)              AS      COMMENT
		  ,[callDir]
		  ,CAST(null as int)			   AS	   VoLTE_to_VoLTE_Call_Mode
		  ,CAST(null as int)			   AS	   VoLTE_to_VoLTE_Call_Mode_Call_End
		  ,CAST(null as varchar(10))       AS      Dialed_Number
		  ,CAST(null as datetime2(3))      AS      [MO:Dial]
		  ,CAST(null as float)             AS      [CallSetupTime(MO:Dial->MO:Alerting)]
		  ,CAST(null as float)             AS      [CallSetupTime(MO:Dial->MO:ConnectAck)]
		  ,CAST(null as float)             AS      [CallSetupTime(MT:Alerting->MT:Connect)]
		  ,CAST(null as datetime2(3))      AS      [MO:CSFB-ExtendedServiceRequest]
		  ,CAST(null as datetime2(3))      AS      [MO:CmServiceRequest]
		  ,CAST(null as datetime2(3))      AS      [MO:SipInvite/CC:Setup]
		  ,CAST(null as datetime2(3))      AS      [MO:SipTrying/CC:CallProceeding]
		  ,CAST(null as datetime2(3))      AS      [MO:SipRinging/CC:Alerting]
		  ,CAST(null as datetime2(3))      AS      [MO:Sip200Ok/CC:Connect]
		  ,CAST(null as datetime2(3))      AS      [MO:SipAck/CC:ConnectAck]
		  ,CAST(null as datetime2(3))      AS      [MO-CC:Disconnect/SIPBye]
		  ,CAST(null as datetime2(3))      AS      [MT:CSFB-ExtendedServiceRequest]
		  ,CAST(null as datetime2(3))      AS      [MT:Paging]
		  ,CAST(null as datetime2(3))      AS      [MT:SipInvite/CC:Setup]
		  ,CAST(null as datetime2(3))      AS      [MT:SipTrying/CC:CallProceeding]
		  ,CAST(null as datetime2(3))      AS      [MT:SipRinging/CC:Alerting]
		  ,CAST(null as datetime2(3))      AS      [MT:Sip200Ok/CC:Connect]
		  ,CAST(null as datetime2(3))      AS      [MT:SipAck/CC:ConnectAck]
		  ,CAST(null as datetime2(3))      AS      [MT-CC:Disconnect/SIPBye]
		  ,CAST(null as datetime2(3))      AS      [Call_Setup_End_Trigger]
		  ,CAST(null as datetime2(3))      AS      [Call_End_Trigger]
		  ,CAST(null as int)               AS      [A->B Samples Count]
		  ,CAST(null as int)               AS      [B->A Samples Count]
		  ,CAST(null as int)               AS      [Total Samples Count]
		  ,CAST(null as decimal(6,2))      AS      [POLQA_LQ_MIN]
		  ,CAST(null as decimal(6,2))      AS      [POLQA_LQ_AVG]
		  ,CAST(null as float)             AS      [POLQA_LQ_MEAN]
		  ,CAST(null as decimal(6,2))      AS      [POLQA_LQ_MAX]
		  ,CAST(null as decimal(6,2))      AS      [POLQA_LQ_SUM]
		  ,CAST(null as int)               AS      [SilenceDistortionCount]
		  ,CAST(null as int)               AS      [1.0>=Bad<1.6]
		  ,CAST(null as int)               AS      [1.6>=Poor<2.3]
		  ,CAST(null as int)               AS      [2.3>=Fair<3.2]
		  ,CAST(null as int)               AS      [3.2>=Good<3.7]
		  ,CAST(null as int)               AS      [3.7>=Excellent<5.0]
		  ,CAST(null as int)               AS      [1.0>=BadCustom<1.4]
		  ,CAST(null as int)               AS      [1.0>=BadCustom<1.8]
		  ,CAST(null as decimal(6,2))      AS      [MinTimeClipping]
		  ,CAST(null as decimal(6,2))      AS      [AvgTimeClipping]
		  ,CAST(null as float)			   AS      [MedianTimeClipping]
		  ,CAST(null as decimal(6,2))	   AS      [MaxTimeClipping]
		  ,CAST(null as decimal(6,2))	   AS      [SumTimeClipping]
		  ,CAST(null as decimal(6,2))	   AS      [MinDelaySpread]
		  ,CAST(null as decimal(6,2))	   AS      [AvgDelaySpread]
		  ,CAST(null as float)             AS      [MedianDelaySpread]
		  ,CAST(null as decimal(6,2))      AS      [MaxDelaySpread]
		  ,CAST(null as decimal(6,2))      AS      [SumDelaySpread]
		  ,CAST(null as decimal(6,2))      AS      [MindelayDeviation]
		  ,CAST(null as decimal(6,2))      AS      [AvgdelayDeviation]
		  ,CAST(null as float)			   AS      [MediandelayDeviation]
		  ,CAST(null as decimal(6,2))      AS      [MaxdelayDeviation]
		  ,CAST(null as decimal(6,2))      AS      [SumdelayDeviation]
		  ,CAST(null as decimal(6,2))      AS      [MinnoiseRcv]
		  ,CAST(null as decimal(6,2))      AS      [AvgnoiseRcv]
		  ,CAST(null as float)			   AS      [MediannoiseRcv]
		  ,CAST(null as decimal(6,2))      AS      [MaxnoiseRcv]
		  ,CAST(null as decimal(6,2))      AS      [SumnoiseRcv]
		  ,CAST(null as decimal(6,2))      AS      [MinstaticSNR]
		  ,CAST(null as decimal(6,2))      AS      [AvgstaticSNR]
		  ,CAST(null as float)			   AS      [MedianstaticSNR]
		  ,CAST(null as decimal(6,2))      AS      [MaxstaticSNR]
		  ,CAST(null as decimal(6,2))      AS      [SumstaticSNR]
		  ,CAST(null as real)              AS      [MinReceiveDelay]
		  ,CAST(null as float)             AS      [AvgReceiveDelay]
		  ,CAST(null as float)             AS      [MedianReceiveDelay]
		  ,CAST(null as real)              AS      [MaxReceiveDelay]
		  ,CAST(null as float)             AS      [SumReceiveDelay]
		  ,CAST(null as decimal(6,2))      AS      [MinAmplClipping]
		  ,CAST(null as decimal(6,2))      AS      [AvgAmplClipping]
		  ,CAST(null as float)			   AS      [MedianAmplClipping]
		  ,CAST(null as decimal(6,2))      AS      [MaxAmplClipping]
		  ,CAST(null as decimal(6,2))      AS      [SumAmplClipping]
		  ,CAST(null as decimal(6,2))      AS      [MinMissedVoice]
		  ,CAST(null as decimal(6,2))      AS      [AvgMissedVoice]
		  ,CAST(null as float)			   AS      [MedianMissedVoice]
		  ,CAST(null as decimal(6,2))      AS      [MaxMissedVoice]
		  ,CAST(null as decimal(6,2))      AS      [SumMissedVoice]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_Unknown_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_1.8_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_4.75_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_5.15_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_5.9_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_6.7_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_7.4_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_7.95_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_10.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_NB_12.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_6.6_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_8.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_12.65_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_14.25_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_15.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_18.25_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_19.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_23.05_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_AMR_WB_23.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_5.9_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_7.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_8_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_9.6_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_13.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_16.4_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_24.4_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_32_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_48_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_64_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_96_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Playing_EVS_128_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Unknown_EVS_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_1.8_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_4.75_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_5.15_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_5.9_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_6.7_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_7.4_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_7.95_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_10.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_NB_12.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_6.6_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_8.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_12.65_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_14.25_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_15.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_18.25_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_19.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_23.05_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_AMR_WB_23.85_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_5.9_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_7.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_8_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_9.6_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_13.2_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_16.4_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_24.4_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_32_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_48_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_64_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_96_ms]
		  ,CAST(null as int)			   AS      [TOTAL_Recording_EVS_128_ms]
		  ,CAST(null as int)			   AS      [LQ >=1.0 and < 1.1]
		  ,CAST(null as int)			   AS      [LQ >=1.1 and < 1.2]
		  ,CAST(null as int)			   AS      [LQ >=1.2 and < 1.3]
		  ,CAST(null as int)			   AS      [LQ >=1.3 and < 1.4]
		  ,CAST(null as int)			   AS      [LQ >=1.4 and < 1.5]
		  ,CAST(null as int)			   AS      [LQ >=1.5 and < 1.6]
		  ,CAST(null as int)			   AS      [LQ >=1.6 and < 1.7]
		  ,CAST(null as int)			   AS      [LQ >=1.7 and < 1.8]
		  ,CAST(null as int)			   AS      [LQ >=1.8 and < 1.9]
		  ,CAST(null as int)			   AS      [LQ >=1.9 and < 2.0]
		  ,CAST(null as int)			   AS      [LQ >=2.0 and < 2.1]
		  ,CAST(null as int)			   AS      [LQ >=2.1 and < 2.2]
		  ,CAST(null as int)			   AS      [LQ >=2.2 and < 2.3]
		  ,CAST(null as int)			   AS      [LQ >=2.3 and < 2.4]
		  ,CAST(null as int)			   AS      [LQ >=2.4 and < 2.5]
		  ,CAST(null as int)			   AS      [LQ >=2.5 and < 2.6]
		  ,CAST(null as int)			   AS      [LQ >=2.6 and < 2.7]
		  ,CAST(null as int)			   AS      [LQ >=2.7 and < 2.8]
		  ,CAST(null as int)			   AS      [LQ >=2.8 and < 2.9]
		  ,CAST(null as int)			   AS      [LQ >=2.9 and < 3.0]
		  ,CAST(null as int)			   AS      [LQ >=3.0 and < 3.1]
		  ,CAST(null as int)			   AS      [LQ >=3.1 and < 3.2]
		  ,CAST(null as int)			   AS      [LQ >=3.2 and < 3.3]
		  ,CAST(null as int)			   AS      [LQ >=3.3 and < 3.4]
		  ,CAST(null as int)			   AS      [LQ >=3.4 and < 3.5]
		  ,CAST(null as int)			   AS      [LQ >=3.5 and < 3.6]
		  ,CAST(null as int)			   AS      [LQ >=3.6 and < 3.7]
		  ,CAST(null as int)			   AS      [LQ >=3.7 and < 3.8]
		  ,CAST(null as int)			   AS      [LQ >=3.8 and < 3.9]
		  ,CAST(null as int)			   AS      [LQ >=3.9 and < 4.0]
		  ,CAST(null as int)			   AS      [LQ >=4.0 and < 4.1]
		  ,CAST(null as int)			   AS      [LQ >=4.1 and < 4.2]
		  ,CAST(null as int)			   AS      [LQ >=4.2 and < 4.3]
		  ,CAST(null as int)			   AS      [LQ >=4.3 and < 4.4]
		  ,CAST(null as int)			   AS      [LQ >=4.4 and < 4.5]
		  ,CAST(null as int)			   AS      [LQ >=4.5 and < 4.6]
		  ,CAST(null as int)			   AS      [LQ >=4.6 and < 4.7]
		  ,CAST(null as int)			   AS      [LQ >=4.7 and < 4.8]
		  ,CAST(null as int)			   AS      [LQ >=4.8 and < 4.9]
		  ,CAST(null as int)			   AS      [LQ >=4.9 and < 5.0]
		  ,[SessionId_A]
		  ,[Campaign_A]
		  ,[Collection_A]
		  ,[Test_Description_A]
		  ,[System_Name_A]
		  ,[System_Type_A]
		  ,[Zone_A]
		  ,[Location_A]
		  ,CAST(null as varchar(100 ))      AS      Channel_A
		  ,CAST(null as varchar(100 ))      AS      Channel_Description_A
		  ,[SW_A]
		  ,[UE_A]
		  ,[FW_A]
		  ,[IMEI_A]
		  ,[IMSI_A]
		  ,[MSISDN_A]
		  ,[FileId_A]
		  ,[Sequenz_ID_per_File_A]
		  ,[ASideFileName]
		  ,CAST(null as varchar(200 ))      AS      [ASideFileNamePCAP]
		  ,CAST(null as int)				AS      ProtocolID_A
		  ,CAST(null as varchar(100 ))      AS      G_Level_1_A
		  ,CAST(null as varchar(8000 ))     AS      G_Level_2_A
		  ,CAST(null as varchar(8000 ))     AS      G_Level_3_A
		  ,CAST(null as varchar(100 ))      AS      G_Level_4_A
		  ,CAST(null as varchar(100 ))      AS      G_Level_5_A
		  ,CAST(null as text)				AS      G_Remarks_A
		  ,CAST(null as varchar(100 ))      AS      TrainType_A
		  ,CAST(null as varchar(100 ))      AS      TrainName_A
		  ,CAST(null as varchar(100 ))      AS      WagonNumber_A
		  ,CAST(null as varchar(100 ))      AS      WagonRepeter_A
		  ,CAST(null as varchar(20 ))       AS      Vendor_A
		  ,CAST(null as varchar(20 ))       AS      Region_A
		  ,[callStatus_A]
		  ,CAST(null as varchar(100 ))      AS      Call_Mode_L1_A
		  ,CAST(null as varchar(100 ))      AS      Call_Mode_L2_A
		  ,[SQ_CST_A]
		  ,CAST(null as datetime2(3))       AS      callStartTimeStamp_A
		  ,CAST(null as datetime2(3))       AS      callSetupEndTimestamp_A
		  ,CAST(null as datetime2(3))       AS      callDisconnectTimeStamp_A
		  ,CAST(null as datetime2(3))       AS      callEndTimeStamp_A
		  ,CAST(null as datetime2(3))       AS      CSFB_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      Paging_Timestamp_A
		  ,CAST(null as varchar(100 ))      AS      Paging_Technology_A
		  ,CAST(null as datetime2(3))       AS      CMService_Timestamp_1st_A
		  ,CAST(null as datetime2(3))       AS      CCSetup_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      CCCallProceeding_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      CCAlerting_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      CCConnect_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      CCConnectAck_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      CCDisconnect_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      SipInvite_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      SipTrying_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      SipSessProgress_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      SipRinging_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      Sip200Ok_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      SipAck_Timestamp_A
		  ,CAST(null as datetime2(3))       AS      SipByeCancel_Timestamp_A
		  ,CAST(null as varchar(200 ))      AS      SipByeCancel_Reason_A
		  ,[callDuaration_A]
		  ,[startNetId_A]
		  ,[startTechnology_A]
		  ,CAST(null as varchar(20))     	AS      RAT_A
		  ,CAST(null as decimal(6,2))     	AS      RAT_Technology_Duration_s_A
		  ,CAST(null as varchar(500))     	AS      RAT_Timeline_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_GSM_900_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_GSM_1800_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_GSM_1900_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_850_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_900_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_1700_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_1900_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_2100_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_700_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_800_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_900_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_1700_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_1800_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_1900_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_2100_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_2600_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_TDD_2300_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_TDD_2500_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_WiFi_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_No_Service_s_A
		  ,CAST(null as decimal(6,2))     	AS      TIME_Unknown_s_A
		  ,CAST(null as varchar(50 ))		AS      HomeOperator_A
		  ,CAST(null as int)				AS      HomeMCC_A
		  ,CAST(null as int)				AS      HomeMNC_A
		  ,CAST(null as varchar(500 ))		AS      A_MCC
		  ,CAST(null as varchar(500 ))		AS      A_MNC
		  ,CAST(null as varchar(500 ))		AS      A_LAC
		  ,CAST(null as varchar(500 ))		AS      A_CellID
		  ,CAST(null as varchar(500 ))		AS      A_BCCH
		  ,CAST(null as varchar(500 ))		AS      A_SC1
		  ,CAST(null as varchar(500 ))		AS      A_SC2
		  ,CAST(null as varchar(500 ))		AS      A_SC3
		  ,CAST(null as varchar(500 ))		AS      A_SC4
		  ,CAST(null as varchar(2000 ))		AS      A_CGI
		  ,CAST(null as varchar(500 ))		AS      A_BSIC
		  ,CAST(null as varchar(2000 ))		AS      A_PCI
		  ,CAST(null as varchar(2000 ))		AS      A_LAC_CId_BCCH
		  ,CAST(null as varchar(2000 ))		AS      A_CGI_Disconnect
		  ,CAST(null as varchar(2000 ))		AS      A_Disconnect_LAC_CId_BCCH
		  ,CAST(null as varchar(2000 ))		AS      A_VDF_CELL_NAME
		  ,CAST(null as int)     			AS      A_MinRxLev
		  ,CAST(null as int)     			AS      A_AvgRxLev
		  ,CAST(null as int)     			AS      A_MaxRxLev
		  ,CAST(null as float)				AS      A_StDevRxLev
		  ,CAST(null as int)     			AS      A_MinRxQual
		  ,CAST(null as int)     			AS      A_AvgRxQual
		  ,CAST(null as int)     			AS      A_MaxRxQual
		  ,CAST(null as float)				AS      A_StDevRxQual
		  ,cast(null as bigint)				AS		A_AvgTA2G
		  ,cast(null as bigint)				AS		A_MaxTA2G
		  ,CAST(null as float)				AS      A_MinRSCP
		  ,CAST(null as float)				AS      A_AvgRSCP
		  ,CAST(null as float)				AS      A_MaxRSCP
		  ,CAST(null as float)				AS      A_StDevRSCP
		  ,CAST(null as float)				AS      A_MinEcIo
		  ,CAST(null as float)				AS      A_AvgEcIo
		  ,CAST(null as float)				AS      A_MaxEcIo
		  ,CAST(null as float)				AS      A_StDevEcIo
		  ,CAST(null as float)				AS      A_MinTxPwr3G
		  ,CAST(null as float)				AS      A_AvgTxPwr3G
		  ,CAST(null as float)				AS      A_MaxTxPwr3G
		  ,CAST(null as float)				AS      A_StDevTxPwr3G
		  ,cast(null as bigint)				AS		A_CQI_HSDPA_Min
		  ,cast(null as bigint)				AS		A_CQI_HSDPA
		  ,cast(null as bigint)				AS		A_CQI_HSDPA_Max
		  ,cast(null as float)				AS		A_CQI_HSDPA_StDev
		  ,cast(null as bigint)				AS		A_ACK3G
		  ,cast(null as bigint)				AS		A_NACK3G
		  ,cast(null as bigint)				AS		A_ACKNACK3G_Total
		  ,cast(null as float)				AS		A_ACK3G_Percent
		  ,cast(null as float)				AS		A_NACK3G_Percent
		  ,cast(null as float)				AS		A_BLER3G
		  ,cast(null as bigint)				AS		A_BLER3GSamples
		  ,cast(null as float)				AS		A_StDevBLER3G
		  ,CAST(null as float)				AS      A_MinRSRP
		  ,CAST(null as float)				AS      A_AvgRSRP
		  ,CAST(null as float)				AS      A_MaxRSRP
		  ,CAST(null as float)				AS      A_StDevRSRP
		  ,CAST(null as float)				AS      A_MinRSRQ
		  ,CAST(null as float)				AS      A_AvgRSRQ
		  ,CAST(null as float)				AS      A_MaxRSRQ
		  ,CAST(null as float)				AS      A_StDevRSRQ
		  ,CAST(null as float)				AS      A_MinSINR
		  ,CAST(null as float)				AS      A_AvgSINR
		  ,CAST(null as float)				AS      A_MaxSINR
		  ,CAST(null as float)				AS      A_StDevSINR
		  ,CAST(null as float)				AS      A_MinSINR0
		  ,CAST(null as float)				AS      A_AvgSINR0
		  ,CAST(null as float)				AS      A_MaxSINR0
		  ,CAST(null as float)				AS      A_StDevSINR0
		  ,CAST(null as float)				AS      A_MinSINR1
		  ,CAST(null as float)				AS      A_AvgSINR1
		  ,CAST(null as float)				AS      A_MaxSINR1
		  ,CAST(null as float)				AS      A_StDevSINR1
		  ,CAST(null as float)				AS      A_MinTxPwr4G
		  ,CAST(null as float)				AS      A_AvgTxPwr4G
		  ,CAST(null as float)				AS      A_MaxTxPwr4G
		  ,CAST(null as float)				AS      A_StDevTxPwr4G
		  ,cast(null as float)				AS		A_CQI_LTE_Min
		  ,cast(null as float)				AS		A_CQI_LTE_Avg
		  ,cast(null as float)				AS		A_CQI_LTE_Max
		  ,cast(null as float)				AS		A_CQI_LTE_StDev
		  ,cast(null as bigint)				AS		A_ACK4G
		  ,cast(null as bigint)				AS		A_NACK4G
		  ,cast(null as bigint)				AS		A_ACKNACK4G_Total
		  ,cast(null as float)				AS		A_ACK4G_Percent
		  ,cast(null as float)				AS		A_NACK4G_Percent
		  ,cast(null as bigint)				AS		A_AvgDLTA4G
		  ,cast(null as bigint)				AS		A_MaxDLTA4G
		  ,cast(null as float)				AS		A_MinDLNumCarriers
		  ,cast(null as float)				AS		A_AvgDLNumCarriers
		  ,cast(null as float)				AS		A_MaxDLNumCarriers
		  ,cast(null as float)				AS		A_MinDLRB
		  ,cast(null as float)				AS		A_AvgDLRB
		  ,cast(null as float)				AS		A_MaxDLRB
		  ,cast(null as float)				AS		A_MinDLMCS
		  ,cast(null as float)				AS		A_AvgDLMCS
		  ,cast(null as float)				AS		A_MaxDLMCS
		  ,cast(null as bigint)				AS		A_CountDLNumQPSK
		  ,cast(null as bigint)				AS		A_CountDLNum16QAM
		  ,cast(null as bigint)				AS		A_CountDLNum64QAM
		  ,cast(null as bigint)				AS		A_CountDLNum256QAM
		  ,cast(null as bigint)				AS		A_CountDLModulation
		  ,cast(null as float)				AS		A_MinScheduledPDSCHThroughput
		  ,cast(null as float)				AS		A_AvgScheduledPDSCHThroughput
		  ,cast(null as float)				AS		A_MaxScheduledPDSCHThroughput
		  ,cast(null as float)				AS		A_MinNetPDSCHThroughput
		  ,cast(null as float)				AS		A_AvgNetPDSCHThroughput
		  ,cast(null as float)				AS		A_MaxNetPDSCHThroughput
		  ,cast(null as bigint)				AS		A_PDSCHBytesTransfered
		  ,cast(null as float)				AS		A_MinDLBLER
		  ,cast(null as float)				AS		A_AvgDLBLER
		  ,cast(null as float)				AS		A_MaxDLBLER
		  ,cast(null as float)				AS		A_MinDLTBSize
		  ,cast(null as float)				AS		A_AvgDLTBSize
		  ,cast(null as float)				AS		A_MaxDLTBSize
		  ,cast(null as float)				AS		A_MinDLTBRate
		  ,cast(null as float)				AS		A_AvgDLTBRate
		  ,cast(null as float)				AS		A_MaxDLTBRate
		  ,cast(null as float)				AS		A_MinULNumCarriers
		  ,cast(null as float)				AS		A_AvgULNumCarriers
		  ,cast(null as float)				AS		A_MaxULNumCarriers
		  ,cast(null as bigint)				AS		A_CountULNumBPSK
		  ,cast(null as bigint)				AS		A_CountULNumQPSK
		  ,cast(null as bigint)				AS		A_CountULNum16QAM
		  ,cast(null as bigint)				AS		A_CountULNum64QAM
		  ,cast(null as bigint)				AS		A_CountULModulation
		  ,cast(null as float)				AS		A_MinScheduledPUSCHThroughput
		  ,cast(null as float)				AS		A_AvgScheduledPUSCHThroughput
		  ,cast(null as float)				AS		A_MaxScheduledPUSCHThroughput
		  ,cast(null as float)				AS		A_MinNetPUSCHThroughput
		  ,cast(null as float)				AS		A_AvgNetPUSCHThroughput
		  ,cast(null as float)				AS		A_MaxNetPUSCHThroughput
		  ,cast(null as bigint)				AS		A_PUSCHBytesTransfered
		  ,cast(null as float)				AS		A_MinULTBSize
		  ,cast(null as float)				AS		A_AvgULTBSize
		  ,cast(null as float)				AS		A_MaxULTBSize
		  ,cast(null as float)				AS		A_MinULTBRate
		  ,cast(null as float)				AS		A_AvgULTBRate
		  ,cast(null as float)				AS		A_MaxULTBRate
		  ,cast(null as varchar(5000))		AS		A_CA_PCI
		  ,cast(null as varchar(5000))		AS		A_HandoversInfo
		  ,cast(null as varchar(500))		AS		A_RRCState
		  ,[numSatelites_A]
		  ,[Altitude_A]
		  ,[Distance_A]
		  ,[minSpeed_A]
		  ,[maxSpeed_A]
		  ,[startPosId_A]
		  ,[startLongitude_A]
		  ,[startLatitude_A]
		  ,[endPosId_A]
		  ,[endLongitude_A]
		  ,[endLatitude_A]
		  ,[SessionId_B]
		  ,[Campaign_B]
		  ,[Collection_B]
		  ,[Test_Description_B]
		  ,[System_Name_B]
		  ,[System_Type_B]
		  ,[Zone_B]
		  ,[Location_B]
		  ,CAST(null as varchar(100 ))      AS      Channel_B
		  ,CAST(null as varchar(100 ))      AS      Channel_Description_B
		  ,[SW_B]
		  ,[UE_B]
		  ,[FW_B]
		  ,[IMEI_B]
		  ,[IMSI_B]
		  ,[MSISDN_B]
		  ,[FileId_B]
		  ,[Sequenz_ID_per_File_B]
		  ,[BSideFileName]
		  ,CAST(null as varchar(200 ))      AS      [BSideFileNamePCAP]
		  ,CAST(null as int)				AS      ProtocolID_B
		  ,CAST(null as varchar(100 ))		AS      G_Level_1_B
		  ,CAST(null as varchar(8000 ))     AS      G_Level_2_B
		  ,CAST(null as varchar(8000 ))     AS      G_Level_3_B
		  ,CAST(null as varchar(100 ))		AS      G_Level_4_B
		  ,CAST(null as varchar(100 ))		AS      G_Level_5_B
		  ,CAST(null as text)				AS      G_Remarks_B
		  ,CAST(null as varchar(100 ))      AS      TrainType_B
		  ,CAST(null as varchar(100 ))      AS      TrainName_B
		  ,CAST(null as varchar(100 ))      AS      WagonNumber_B
		  ,CAST(null as varchar(100 ))      AS      WagonRepeter_B
		  ,CAST(null as varchar(20 ))       AS      Vendor_B
		  ,CAST(null as varchar(20 ))       AS      Region_B
		  ,[callStatus_B]
		  ,CAST(null as varchar(100 ))     AS      Call_Mode_L1_B
		  ,CAST(null as varchar(100 ))     AS      Call_Mode_L2_B
		  ,[SQ_CST_B]
		  ,CAST(null as datetime2(3))      AS      callStartTimeStamp_B
		  ,CAST(null as datetime2(3))      AS      callSetupEndTimestamp_B
		  ,CAST(null as datetime2(3))      AS      callDisconnectTimeStamp_B
		  ,CAST(null as datetime2(3))      AS      callEndTimeStamp_B
		  ,CAST(null as datetime2(3))      AS      CSFB_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      Paging_Timestamp_B
		  ,CAST(null as varchar(100 ))     AS      Paging_Technology_B
		  ,CAST(null as datetime2(3))      AS      CMService_Timestamp_1st_B
		  ,CAST(null as datetime2(3))      AS      CCSetup_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      CCCallProceeding_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      CCAlerting_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      CCConnect_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      CCConnectAck_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      CCDisconnect_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      SipInvite_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      SipTrying_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      SipSessProgress_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      SipRinging_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      Sip200Ok_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      SipAck_Timestamp_B
		  ,CAST(null as datetime2(3))      AS      SipByeCancel_Timestamp_B
		  ,CAST(null as varchar(200 ))     AS      SipByeCancel_Reason_B
		  ,[callDuaration_B]
		  ,[startNetId_B]
		  ,[startTechnology_B]
		  ,CAST(null as varchar(20 ))     	AS      RAT_B
		  ,CAST(null as decimal(6,2))     	AS      RAT_Technology_Duration_s_B
		  ,CAST(null as varchar(500 ))     	AS      RAT_Timeline_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_GSM_900_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_GSM_1800_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_GSM_1900_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_850_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_900_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_1700_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_1900_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_UMTS_2100_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_700_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_800_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_900_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_1700_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_1800_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_1900_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_2100_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_2600_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_TDD_2300_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_LTE_TDD_2500_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_WiFi_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_No_Service_s_B
		  ,CAST(null as decimal(6,2))     	AS      TIME_Unknown_s_B
		  ,CAST(null as varchar(50 ))		AS      HomeOperator_B
		  ,CAST(null as int)				AS      HomeMCC_B
		  ,CAST(null as int)				AS      HomeMNC_B
		  ,CAST(null as varchar(500 ))		AS      B_MCC
		  ,CAST(null as varchar(500 ))		AS      B_MNC
		  ,CAST(null as varchar(500 ))		AS      B_LAC
		  ,CAST(null as varchar(500 ))		AS      B_CellID
		  ,CAST(null as varchar(500 ))		AS      B_BCCH
		  ,CAST(null as varchar(500 ))		AS      B_SC1
		  ,CAST(null as varchar(500 ))		AS      B_SC2
		  ,CAST(null as varchar(500 ))		AS      B_SC3
		  ,CAST(null as varchar(500 ))		AS      B_SC4
		  ,CAST(null as varchar(2000 ))		AS      B_CGI
		  ,CAST(null as varchar(500 ))		AS      B_BSIC
		  ,CAST(null as varchar(2000 ))		AS      B_PCI
		  ,CAST(null as varchar(2000 ))		AS      B_LAC_CId_BCCH
		  ,CAST(null as varchar(2000 ))		AS      B_CGI_Disconnect
		  ,CAST(null as varchar(2000 ))		AS      B_Disconnect_LAC_CId_BCCH
		  ,CAST(null as varchar(2000 ))		AS      B_VDF_CELL_NAME
		  ,CAST(null as int)     			AS      B_MinRxLev
		  ,CAST(null as int)     			AS      B_AvgRxLev
		  ,CAST(null as int)     			AS      B_MaxRxLev
		  ,CAST(null as float)				AS      B_StDevRxLev
		  ,CAST(null as int)     			AS      B_MinRxQual
		  ,CAST(null as int)     			AS      B_AvgRxQual
		  ,CAST(null as int)     			AS      B_MaxRxQual
		  ,CAST(null as float)				AS      B_StDevRxQual
		  ,cast(null as bigint)				AS		B_AvgTA2G
		  ,cast(null as bigint)				AS		B_MaxTA2G
		  ,CAST(null as float)				AS      B_MinRSCP
		  ,CAST(null as float)				AS      B_AvgRSCP
		  ,CAST(null as float)				AS      B_MaxRSCP
		  ,CAST(null as float)				AS      B_StDevRSCP
		  ,CAST(null as float)				AS      B_MinEcIo
		  ,CAST(null as float)				AS      B_AvgEcIo
		  ,CAST(null as float)				AS      B_MaxEcIo
		  ,CAST(null as float)				AS      B_StDevEcIo
		  ,CAST(null as float)				AS      B_MinTxPwr3G
		  ,CAST(null as float)				AS      B_AvgTxPwr3G
		  ,CAST(null as float)				AS      B_MaxTxPwr3G
		  ,CAST(null as float)				AS      B_StDevTxPwr3G
		  ,cast(null as bigint)				AS		B_CQI_HSDPA_Min
		  ,cast(null as bigint)				AS		B_CQI_HSDPA
		  ,cast(null as bigint)				AS		B_CQI_HSDPA_Max
		  ,cast(null as float)				AS		B_CQI_HSDPA_StDev
		  ,cast(null as bigint)				AS		B_ACK3G
		  ,cast(null as bigint)				AS		B_NACK3G
		  ,cast(null as bigint)				AS		B_ACKNACK3G_Total
		  ,cast(null as float)				AS		B_ACK3G_Percent
		  ,cast(null as float)				AS		B_NACK3G_Percent
		  ,cast(null as float)				AS		B_BLER3G
		  ,cast(null as bigint)				AS		B_BLER3GSamples
		  ,cast(null as float)				AS		B_StDevBLER3G
		  ,CAST(null as float)				AS      B_MinRSRP
		  ,CAST(null as float)				AS      B_AvgRSRP
		  ,CAST(null as float)				AS      B_MaxRSRP
		  ,CAST(null as float)				AS      B_StDevRSRP
		  ,CAST(null as float)				AS      B_MinRSRQ
		  ,CAST(null as float)				AS      B_AvgRSRQ
		  ,CAST(null as float)				AS      B_MaxRSRQ
		  ,CAST(null as float)				AS      B_StDevRSRQ
		  ,CAST(null as float)				AS      B_MinSINR
		  ,CAST(null as float)				AS      B_AvgSINR
		  ,CAST(null as float)				AS      B_MaxSINR
		  ,CAST(null as float)				AS      B_StDevSINR
		  ,CAST(null as float)				AS      B_MinSINR0
		  ,CAST(null as float)				AS      B_AvgSINR0
		  ,CAST(null as float)				AS      B_MaxSINR0
		  ,CAST(null as float)				AS      B_StDevSINR0
		  ,CAST(null as float)				AS      B_MinSINR1
		  ,CAST(null as float)				AS      B_AvgSINR1
		  ,CAST(null as float)				AS      B_MaxSINR1
		  ,CAST(null as float)				AS      B_StDevSINR1
		  ,CAST(null as float)				AS      B_MinTxPwr4G
		  ,CAST(null as float)				AS      B_AvgTxPwr4G
		  ,CAST(null as float)				AS      B_MaxTxPwr4G
		  ,CAST(null as float)				AS      B_StDevTxPwr4G
		  ,cast(null as float)				AS		B_CQI_LTE_Min
		  ,cast(null as float)				AS		B_CQI_LTE_Avg
		  ,cast(null as float)				AS		B_CQI_LTE_Max
		  ,cast(null as float)				AS		B_CQI_LTE_StDev
		  ,cast(null as bigint)				AS		B_ACK4G
		  ,cast(null as bigint)				AS		B_NACK4G
		  ,cast(null as bigint)				AS		B_ACKNACK4G_Total
		  ,cast(null as float)				AS		B_ACK4G_Percent
		  ,cast(null as float)				AS		B_NACK4G_Percent
		  ,cast(null as bigint)				AS		B_AvgDLTA4G
		  ,cast(null as bigint)				AS		B_MaxDLTA4G
		  ,cast(null as float)				AS		B_MinDLNumCarriers
		  ,cast(null as float)				AS		B_AvgDLNumCarriers
		  ,cast(null as float)				AS		B_MaxDLNumCarriers
		  ,cast(null as float)				AS		B_MinDLRB
		  ,cast(null as float)				AS		B_AvgDLRB
		  ,cast(null as float)				AS		B_MaxDLRB
		  ,cast(null as float)				AS		B_MinDLMCS
		  ,cast(null as float)				AS		B_AvgDLMCS
		  ,cast(null as float)				AS		B_MaxDLMCS
		  ,cast(null as bigint)				AS		B_CountDLNumQPSK
		  ,cast(null as bigint)				AS		B_CountDLNum16QAM
		  ,cast(null as bigint)				AS		B_CountDLNum64QAM
		  ,cast(null as bigint)				AS		B_CountDLNum256QAM
		  ,cast(null as bigint)				AS		B_CountDLModulation
		  ,cast(null as float)				AS		B_MinScheduledPDSCHThroughput
		  ,cast(null as float)				AS		B_AvgScheduledPDSCHThroughput
		  ,cast(null as float)				AS		B_MaxScheduledPDSCHThroughput
		  ,cast(null as float)				AS		B_MinNetPDSCHThroughput
		  ,cast(null as float)				AS		B_AvgNetPDSCHThroughput
		  ,cast(null as float)				AS		B_MaxNetPDSCHThroughput
		  ,cast(null as bigint)				AS		B_PDSCHBytesTransfered
		  ,cast(null as float)				AS		B_MinDLBLER
		  ,cast(null as float)				AS		B_AvgDLBLER
		  ,cast(null as float)				AS		B_MaxDLBLER
		  ,cast(null as float)				AS		B_MinDLTBSize
		  ,cast(null as float)				AS		B_AvgDLTBSize
		  ,cast(null as float)				AS		B_MaxDLTBSize
		  ,cast(null as float)				AS		B_MinDLTBRate
		  ,cast(null as float)				AS		B_AvgDLTBRate
		  ,cast(null as float)				AS		B_MaxDLTBRate
		  ,cast(null as float)				AS		B_MinULNumCarriers
		  ,cast(null as float)				AS		B_AvgULNumCarriers
		  ,cast(null as float)				AS		B_MaxULNumCarriers
		  ,cast(null as bigint)				AS		B_CountULNumBPSK
		  ,cast(null as bigint)				AS		B_CountULNumQPSK
		  ,cast(null as bigint)				AS		B_CountULNum16QAM
		  ,cast(null as bigint)				AS		B_CountULNum64QAM
		  ,cast(null as bigint)				AS		B_CountULModulation
		  ,cast(null as float)				AS		B_MinScheduledPUSCHThroughput
		  ,cast(null as float)				AS		B_AvgScheduledPUSCHThroughput
		  ,cast(null as float)				AS		B_MaxScheduledPUSCHThroughput
		  ,cast(null as float)				AS		B_MinNetPUSCHThroughput
		  ,cast(null as float)				AS		B_AvgNetPUSCHThroughput
		  ,cast(null as float)				AS		B_MaxNetPUSCHThroughput
		  ,cast(null as bigint)				AS		B_PUSCHBytesTransfered
		  ,cast(null as float)				AS		B_MinULTBSize
		  ,cast(null as float)				AS		B_AvgULTBSize
		  ,cast(null as float)				AS		B_MaxULTBSize
		  ,cast(null as float)				AS		B_MinULTBRate
		  ,cast(null as float)				AS		B_AvgULTBRate
		  ,cast(null as float)				AS		B_MaxULTBRate
		  ,cast(null as varchar(5000))		AS		B_CA_PCI
		  ,cast(null as varchar(5000))		AS		B_HandoversInfo
		  ,cast(null as varchar(500))		AS		B_RRCState
		  ,[numSatelites_B]
		  ,[Altitude_B]
		  ,[Distance_B]
		  ,[minSpeed_B]
		  ,[maxSpeed_B]
		  ,[startPosId_B]
		  ,[startLongitude_B]
		  ,[startLatitude_B]
		  ,[endPosId_B]
		  ,[endLongitude_B]
		  ,[endLatitude_B]
		  ,CAST(null as varbinary)			AS      JOIN_ID 
	  INTO NEW_CDR_VOICE_2018
	  FROM [NEW_Call_Info_2018]
	  WHERE Session_Type like '%CALL'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with Dialed Number...')
	UPDATE NEW_CDR_VOICE_2018
	SET Dialed_Number = CASE WHEN callDir like '%->B' THEN CAST(MSISDN_B as varchar(10))
							 WHEN callDir like '%->A' THEN CAST(MSISDN_A as varchar(10))
							 END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with Call Mode and Timestamps Information...')
	UPDATE NEW_CDR_VOICE_2018
	SET 
		       [MO:Dial]								 = b.[MO:Dial]								
		      ,[CallSetupTime(MO:Dial->MO:Alerting)]	 = b.[CallSetupTime(MO:Dial->MO:Alerting)]	
		      ,[CallSetupTime(MO:Dial->MO:ConnectAck)]	 = b.[CallSetupTime(MO:Dial->MO:ConnectAck)]	
		      ,[CallSetupTime(MT:Alerting->MT:Connect)]	 = b.[CallSetupTime(MT:Alerting->MT:Connect)]	
		      ,[MO:CSFB-ExtendedServiceRequest]			 = b.[MO:CSFB-ExtendedServiceRequest]			
		      ,[MO:CmServiceRequest]					 = b.[MO:CmServiceRequest]					
		      ,[MO:SipInvite/CC:Setup]					 = b.[MO:SipInvite/CC:Setup]					
		      ,[MO:SipTrying/CC:CallProceeding]			 = b.[MO:SipTrying/CC:CallProceeding]			
		      ,[MO:SipRinging/CC:Alerting]				 = b.[MO:SipRinging/CC:Alerting]				
		      ,[MO:Sip200Ok/CC:Connect]					 = b.[MO:Sip200Ok/CC:Connect]					
		      ,[MO:SipAck/CC:ConnectAck]				 = b.[MO:SipAck/CC:ConnectAck]	
			  ,[MO-CC:Disconnect/SIPBye]				 = CASE WHEN a.callDir like 'A->%' THEN b.[SipByeCancel_Timestamp_A]
																ELSE b.[SipByeCancel_Timestamp_B]
																END			
		      ,[MT:CSFB-ExtendedServiceRequest]			 = b.[MT:CSFB-ExtendedServiceRequest]			
		      ,[MT:Paging]								 = b.[MT:Paging]								
		      ,[MT:SipInvite/CC:Setup]					 = b.[MT:SipInvite/CC:Setup]					
		      ,[MT:SipTrying/CC:CallProceeding]			 = b.[MT:SipTrying/CC:CallProceeding]			
		      ,[MT:SipRinging/CC:Alerting]				 = b.[MT:SipRinging/CC:Alerting]				
		      ,[MT:Sip200Ok/CC:Connect]					 = b.[MT:Sip200Ok/CC:Connect]					
		      ,[MT:SipAck/CC:ConnectAck]				 = b.[MT:SipAck/CC:ConnectAck]
			  ,[MT-CC:Disconnect/SIPBye]				 = CASE WHEN a.callDir like 'A->%' THEN b.[SipByeCancel_Timestamp_B]
																ELSE b.[SipByeCancel_Timestamp_A]
																END				
		      ,[Call_Setup_End_Trigger]					 = b.[Call_Setup_End_Trigger]					
		      ,[Call_End_Trigger]						 = b.[Call_End_Trigger]	
			  ,Call_Mode_L1_A				  = b.Call_Mode_L1_A
			  ,Call_Mode_L2_A				  = b.Call_Mode_L2_A
			  ,Call_Mode_L1_B				  = b.Call_Mode_L1_B
			  ,Call_Mode_L2_B				  = b.Call_Mode_L2_B
			  ,callStartTimeStamp_A			  = b.callStartTimeStamp_A			  
			  ,callSetupEndTimestamp_A		  = b.callSetupEndTimestamp_A		  
			  ,callDisconnectTimeStamp_A	  = b.callDisconnectTimeStamp_A	  
			  ,callEndTimeStamp_A			  = b.callEndTimeStamp_A			  
			  ,CSFB_Timestamp_A				  = b.CSFB_Timestamp_A				  
			  ,Paging_Timestamp_A			  = b.Paging_Timestamp_A			  
			  ,Paging_Technology_A			  = b.Paging_Technology_A			  
			  ,CMService_Timestamp_1st_A	  = b.CMService_Timestamp_1st_A	  
			  ,CCSetup_Timestamp_A			  = b.CCSetup_Timestamp_A			  
			  ,CCCallProceeding_Timestamp_A	  = b.CCCallProceeding_Timestamp_A	  
			  ,CCAlerting_Timestamp_A		  = b.CCAlerting_Timestamp_A		  
			  ,CCConnect_Timestamp_A		  = b.CCConnect_Timestamp_A		  
			  ,CCConnectAck_Timestamp_A		  = b.CCConnectAck_Timestamp_A		  
			  ,CCDisconnect_Timestamp_A		  = b.CCDisconnect_Timestamp_A		  
			  ,SipInvite_Timestamp_A		  = b.SipInvite_Timestamp_A		  
			  ,SipTrying_Timestamp_A		  = b.SipTrying_Timestamp_A		  
			  ,SipSessProgress_Timestamp_A	  = b.SipSessProgress_Timestamp_A	  
			  ,SipRinging_Timestamp_A		  = b.SipRinging_Timestamp_A		  
			  ,Sip200Ok_Timestamp_A			  = b.Sip200Ok_Timestamp_A			  
			  ,SipAck_Timestamp_A			  = b.SipAck_Timestamp_A			  
			  ,SipByeCancel_Timestamp_A		  = b.SipByeCancel_Timestamp_A		  
			  ,SipByeCancel_Reason_A		  = b.SipByeCancel_Reason_A		  
			  ,callStartTimeStamp_B			  = b.callStartTimeStamp_B			  
			  ,callSetupEndTimestamp_B		  = b.callSetupEndTimestamp_B		  
			  ,callDisconnectTimeStamp_B	  = b.callDisconnectTimeStamp_B	  
			  ,callEndTimeStamp_B			  = b.callEndTimeStamp_B			  
			  ,CSFB_Timestamp_B				  = b.CSFB_Timestamp_B				  
			  ,Paging_Timestamp_B			  = b.Paging_Timestamp_B			  
			  ,Paging_Technology_B			  = b.Paging_Technology_B			  
			  ,CMService_Timestamp_1st_B	  = b.CMService_Timestamp_1st_B	  
			  ,CCSetup_Timestamp_B			  = b.CCSetup_Timestamp_B			  
			  ,CCCallProceeding_Timestamp_B	  = b.CCCallProceeding_Timestamp_B	  
			  ,CCAlerting_Timestamp_B		  = b.CCAlerting_Timestamp_B		  
			  ,CCConnect_Timestamp_B		  = b.CCConnect_Timestamp_B		  
			  ,CCConnectAck_Timestamp_B		  = b.CCConnectAck_Timestamp_B		  
			  ,CCDisconnect_Timestamp_B		  = b.CCDisconnect_Timestamp_B		  
			  ,SipInvite_Timestamp_B		  = b.SipInvite_Timestamp_B		  
			  ,SipTrying_Timestamp_B		  = b.SipTrying_Timestamp_B		  
			  ,SipSessProgress_Timestamp_B	  = b.SipSessProgress_Timestamp_B	  
			  ,SipRinging_Timestamp_B		  = b.SipRinging_Timestamp_B		  
			  ,Sip200Ok_Timestamp_B			  = b.Sip200Ok_Timestamp_B			  
			  ,SipAck_Timestamp_B			  = b.SipAck_Timestamp_B			  
			  ,SipByeCancel_Timestamp_B		  = b.SipByeCancel_Timestamp_B		  
			  ,SipByeCancel_Reason_B		  = b.SipByeCancel_Reason_B		  
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_Call_Mode_2018 b on a.SessionId_A = b.SessionId_A

	UPDATE NEW_CDR_VOICE_2018
	SET VoLTE_to_VoLTE_Call_Mode = CASE WHEN Call_Mode_L1_A like 'VoLTE%' and Call_Mode_L1_B like 'VoLTE%' THEN 1
						ELSE 0
						END
		,VoLTE_to_VoLTE_Call_Mode_Call_End = CASE WHEN Call_Mode_L2_A like 'VoLTE' and Call_Mode_L2_B like 'VoLTE' THEN 1
						ELSE 0
						END

	UPDATE NEW_CDR_VOICE_2018
	SET [MO:SipAck/CC:ConnectAck] = null 
	WHERE ([MO:SipAck/CC:ConnectAck] < [MO:Dial] and [MO:SipAck/CC:ConnectAck] > [Call_Setup_End_Trigger])

	UPDATE NEW_CDR_VOICE_2018
	SET [MO:Sip200Ok/CC:Connect] = null 
	WHERE ([MO:Sip200Ok/CC:Connect] < [MO:Dial] and [MO:Sip200Ok/CC:Connect] > [Call_Setup_End_Trigger]) or
		  ([MO:Sip200Ok/CC:Connect] > [MO:SipAck/CC:ConnectAck])

	UPDATE NEW_CDR_VOICE_2018
	SET [MO:SipRinging/CC:Alerting] = null 
	WHERE ([MO:SipRinging/CC:Alerting] < [MO:Dial] and [MO:SipRinging/CC:Alerting] > [Call_Setup_End_Trigger]) or
		  ([MO:SipRinging/CC:Alerting] > [MO:SipAck/CC:ConnectAck]) or
		  ([MO:SipRinging/CC:Alerting] > [MO:Sip200Ok/CC:Connect])

	UPDATE NEW_CDR_VOICE_2018
	SET [MO:SipTrying/CC:CallProceeding] = null 
	WHERE ([MO:SipTrying/CC:CallProceeding] < [MO:Dial] and [MO:SipTrying/CC:CallProceeding] > [Call_Setup_End_Trigger]) or
		  ([MO:SipTrying/CC:CallProceeding] > [MO:SipAck/CC:ConnectAck]) or
		  ([MO:SipTrying/CC:CallProceeding] > [MO:Sip200Ok/CC:Connect]) or
		  ([MO:SipTrying/CC:CallProceeding] > [MO:SipRinging/CC:Alerting])

	UPDATE NEW_CDR_VOICE_2018
	SET [MO:SipInvite/CC:Setup] = null 
	WHERE ([MO:SipInvite/CC:Setup] < [MO:Dial] and [MO:SipInvite/CC:Setup] > [Call_Setup_End_Trigger]) or
		  ([MO:SipInvite/CC:Setup] > [MO:SipAck/CC:ConnectAck]) or
		  ([MO:SipInvite/CC:Setup] > [MO:Sip200Ok/CC:Connect]) or
		  ([MO:SipInvite/CC:Setup] > [MO:SipRinging/CC:Alerting]) or
		  ([MO:SipInvite/CC:Setup] > [MO:SipTrying/CC:CallProceeding])

	UPDATE NEW_CDR_VOICE_2018
	SET [MO:CmServiceRequest] = null 
	WHERE ([MO:CmServiceRequest] < [MO:Dial] and [MO:CmServiceRequest] > [Call_Setup_End_Trigger]) or
		  ([MO:CmServiceRequest] > [MO:SipAck/CC:ConnectAck]) or
		  ([MO:CmServiceRequest] > [MO:Sip200Ok/CC:Connect]) or
		  ([MO:CmServiceRequest] > [MO:SipRinging/CC:Alerting]) or
		  ([MO:CmServiceRequest] > [MO:SipTrying/CC:CallProceeding]) or
		  ([MO:CmServiceRequest] > [MO:SipInvite/CC:Setup])

	UPDATE NEW_CDR_VOICE_2018
	SET [MO:CSFB-ExtendedServiceRequest] = null 
	WHERE ([MO:CSFB-ExtendedServiceRequest] < [MO:Dial] and [MO:CSFB-ExtendedServiceRequest] > [Call_Setup_End_Trigger]) or
		  ([MO:CSFB-ExtendedServiceRequest] > [MO:SipAck/CC:ConnectAck]) or
		  ([MO:CSFB-ExtendedServiceRequest] > [MO:Sip200Ok/CC:Connect]) or
		  ([MO:CSFB-ExtendedServiceRequest] > [MO:SipRinging/CC:Alerting]) or
		  ([MO:CSFB-ExtendedServiceRequest] > [MO:SipTrying/CC:CallProceeding]) or
		  ([MO:CSFB-ExtendedServiceRequest] > [MO:SipInvite/CC:Setup]) or
		  ([MO:CSFB-ExtendedServiceRequest] > [MO:CmServiceRequest])

	UPDATE NEW_CDR_VOICE_2018
	SET [MT:Sip200Ok/CC:Connect] = null 
	WHERE ([MT:Sip200Ok/CC:Connect] > [MT:SipAck/CC:ConnectAck])

	UPDATE NEW_CDR_VOICE_2018
	SET [MT:SipRinging/CC:Alerting] = null 
	WHERE ([MT:SipRinging/CC:Alerting] > [MT:SipAck/CC:ConnectAck]) or
		  ([MT:SipRinging/CC:Alerting] > [MT:Sip200Ok/CC:Connect])

	UPDATE NEW_CDR_VOICE_2018
	SET [MT:SipTrying/CC:CallProceeding] = null 
	WHERE ([MT:SipTrying/CC:CallProceeding] > [MT:SipAck/CC:ConnectAck]) or
		  ([MT:SipTrying/CC:CallProceeding] > [MT:Sip200Ok/CC:Connect]) or
		  ([MT:SipTrying/CC:CallProceeding] > [MT:SipRinging/CC:Alerting])

	UPDATE NEW_CDR_VOICE_2018
	SET [MT:SipInvite/CC:Setup] = null 
	WHERE ([MT:SipInvite/CC:Setup] > [MT:SipAck/CC:ConnectAck]) or
		  ([MT:SipInvite/CC:Setup] > [MT:Sip200Ok/CC:Connect]) or
		  ([MT:SipInvite/CC:Setup] > [MT:SipRinging/CC:Alerting]) or
		  ([MT:SipInvite/CC:Setup] > [MT:SipTrying/CC:CallProceeding])

	UPDATE NEW_CDR_VOICE_2018
	SET [MT:Paging] = null 
	WHERE ([MT:Paging] > [MT:SipAck/CC:ConnectAck]) or
		  ([MT:Paging] > [MT:Sip200Ok/CC:Connect]) or
		  ([MT:Paging] > [MT:SipRinging/CC:Alerting]) or
		  ([MT:Paging] > [MT:SipTrying/CC:CallProceeding]) or
		  ([MT:Paging] > [MT:SipInvite/CC:Setup])

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with aggregated Speech Quality (POLQA) Information...')
	UPDATE NEW_CDR_VOICE_2018
	SET 
		 [A->B Samples Count]				   = b.[A->B Samples Count]
		,[B->A Samples Count]				   = b.[B->A Samples Count]
		,[Total Samples Count]				   = b.[Total Samples Count]
		,[POLQA_LQ_MIN]						   = b.[POLQA_LQ_MIN]
		,[POLQA_LQ_AVG]						   = b.[POLQA_LQ_AVG]
		,[POLQA_LQ_MEAN]					   = b.[POLQA_LQ_MEAN]
		,[POLQA_LQ_MAX]						   = b.[POLQA_LQ_MAX]
		,[POLQA_LQ_SUM]						   = b.[POLQA_LQ_SUM]
		,[SilenceDistortionCount]			   = b.[SilenceDistortionCount]
		,[1.0>=Bad<1.6]						   = b.[1.0>=Bad<1.6]
		,[1.6>=Poor<2.3]					   = b.[1.6>=Poor<2.3]
		,[2.3>=Fair<3.2]					   = b.[2.3>=Fair<3.2]
		,[3.2>=Good<3.7]					   = b.[3.2>=Good<3.7]
		,[3.7>=Excellent<5.0]				   = b.[3.7>=Excellent<5.0]
		,[1.0>=BadCustom<1.4]				   = b.[1.0>=BadCustom<1.4]
		,[1.0>=BadCustom<1.8]				   = b.[1.0>=BadCustom<1.8]
		,[MinTimeClipping]					   = b.[MinTimeClipping]
		,[AvgTimeClipping]					   = b.[AvgTimeClipping]
		,[MedianTimeClipping]				   = b.[MedianTimeClipping]
		,[MaxTimeClipping]					   = b.[MaxTimeClipping]
		,[SumTimeClipping]					   = b.[SumTimeClipping]
		,[MinDelaySpread]					   = b.[MinDelaySpread]
		,[AvgDelaySpread]					   = b.[AvgDelaySpread]
		,[MedianDelaySpread]				   = b.[MedianDelaySpread]
		,[MaxDelaySpread]					   = b.[MaxDelaySpread]
		,[SumDelaySpread]					   = b.[SumDelaySpread]
		,[MindelayDeviation]				   = b.[MindelayDeviation]
		,[AvgdelayDeviation]				   = b.[AvgdelayDeviation]
		,[MediandelayDeviation]				   = b.[MediandelayDeviation]
		,[MaxdelayDeviation]				   = b.[MaxdelayDeviation]
		,[SumdelayDeviation]				   = b.[SumdelayDeviation]
		,[MinnoiseRcv]						   = b.[MinnoiseRcv]
		,[AvgnoiseRcv]						   = b.[AvgnoiseRcv]
		,[MediannoiseRcv]					   = b.[MediannoiseRcv]
		,[MaxnoiseRcv]						   = b.[MaxnoiseRcv]
		,[SumnoiseRcv]						   = b.[SumnoiseRcv]
		,[MinstaticSNR]						   = b.[MinstaticSNR]
		,[AvgstaticSNR]						   = b.[AvgstaticSNR]
		,[MedianstaticSNR]					   = b.[MedianstaticSNR]
		,[MaxstaticSNR]						   = b.[MaxstaticSNR]
		,[SumstaticSNR]						   = b.[SumstaticSNR]
		,[MinReceiveDelay]					   = b.[MinReceiveDelay]
		,[AvgReceiveDelay]					   = b.[AvgReceiveDelay]
		,[MedianReceiveDelay]				   = b.[MedianReceiveDelay]
		,[MaxReceiveDelay]					   = b.[MaxReceiveDelay]
		,[SumReceiveDelay]					   = b.[SumReceiveDelay]
		,[MinAmplClipping]					   = b.[MinAmplClipping]
		,[AvgAmplClipping]					   = b.[AvgAmplClipping]
		,[MedianAmplClipping]				   = b.[MedianAmplClipping]
		,[MaxAmplClipping]					   = b.[MaxAmplClipping]
		,[SumAmplClipping]					   = b.[SumAmplClipping]
		,[MinMissedVoice]					   = b.[MinMissedVoice]
		,[AvgMissedVoice]					   = b.[AvgMissedVoice]
		,[MedianMissedVoice]				   = b.[MedianMissedVoice]
		,[MaxMissedVoice]					   = b.[MaxMissedVoice]
		,[SumMissedVoice]					   = b.[SumMissedVoice]
		,[TOTAL_Playing_AMR_NB_ms]			   = b.[TOTAL_Playing_AMR_NB_ms]
		,[TOTAL_Playing_AMR_WB_ms]			   = b.[TOTAL_Playing_AMR_WB_ms]
		,[TOTAL_Playing_EVS_ms]				   = b.[TOTAL_Playing_EVS_ms]
		,[TOTAL_Playing_Unknown_ms]			   = b.[TOTAL_Playing_Unknown_ms]
		,[TOTAL_Playing_AMR_NB_1.8_ms]		   = b.[TOTAL_Playing_AMR_NB_1.8_ms]
		,[TOTAL_Playing_AMR_NB_4.75_ms]		   = b.[TOTAL_Playing_AMR_NB_4.75_ms]
		,[TOTAL_Playing_AMR_NB_5.15_ms]		   = b.[TOTAL_Playing_AMR_NB_5.15_ms]
		,[TOTAL_Playing_AMR_NB_5.9_ms]		   = b.[TOTAL_Playing_AMR_NB_5.9_ms]
		,[TOTAL_Playing_AMR_NB_6.7_ms]		   = b.[TOTAL_Playing_AMR_NB_6.7_ms]
		,[TOTAL_Playing_AMR_NB_7.4_ms]		   = b.[TOTAL_Playing_AMR_NB_7.4_ms]
		,[TOTAL_Playing_AMR_NB_7.95_ms]		   = b.[TOTAL_Playing_AMR_NB_7.95_ms]
		,[TOTAL_Playing_AMR_NB_10.2_ms]		   = b.[TOTAL_Playing_AMR_NB_10.2_ms]
		,[TOTAL_Playing_AMR_NB_12.2_ms]		   = b.[TOTAL_Playing_AMR_NB_12.2_ms]
		,[TOTAL_Playing_AMR_WB_6.6_ms]		   = b.[TOTAL_Playing_AMR_WB_6.6_ms]
		,[TOTAL_Playing_AMR_WB_8.85_ms]		   = b.[TOTAL_Playing_AMR_WB_8.85_ms]
		,[TOTAL_Playing_AMR_WB_12.65_ms]	   = b.[TOTAL_Playing_AMR_WB_12.65_ms]
		,[TOTAL_Playing_AMR_WB_14.25_ms]	   = b.[TOTAL_Playing_AMR_WB_14.25_ms]
		,[TOTAL_Playing_AMR_WB_15.85_ms]	   = b.[TOTAL_Playing_AMR_WB_15.85_ms]
		,[TOTAL_Playing_AMR_WB_18.25_ms]	   = b.[TOTAL_Playing_AMR_WB_18.25_ms]
		,[TOTAL_Playing_AMR_WB_19.85_ms]	   = b.[TOTAL_Playing_AMR_WB_19.85_ms]
		,[TOTAL_Playing_AMR_WB_23.05_ms]	   = b.[TOTAL_Playing_AMR_WB_23.05_ms]
		,[TOTAL_Playing_AMR_WB_23.85_ms]	   = b.[TOTAL_Playing_AMR_WB_23.85_ms]
		,[TOTAL_Playing_EVS_5.9_ms]			   = b.[TOTAL_Playing_EVS_5.9_ms]
		,[TOTAL_Playing_EVS_7.2_ms]			   = b.[TOTAL_Playing_EVS_7.2_ms]
		,[TOTAL_Playing_EVS_8_ms]			   = b.[TOTAL_Playing_EVS_8_ms]
		,[TOTAL_Playing_EVS_9.6_ms]			   = b.[TOTAL_Playing_EVS_9.6_ms]
		,[TOTAL_Playing_EVS_13.2_ms]		   = b.[TOTAL_Playing_EVS_13.2_ms]
		,[TOTAL_Playing_EVS_16.4_ms]		   = b.[TOTAL_Playing_EVS_16.4_ms]
		,[TOTAL_Playing_EVS_24.4_ms]		   = b.[TOTAL_Playing_EVS_24.4_ms]
		,[TOTAL_Playing_EVS_32_ms]			   = b.[TOTAL_Playing_EVS_32_ms]
		,[TOTAL_Playing_EVS_48_ms]			   = b.[TOTAL_Playing_EVS_48_ms]
		,[TOTAL_Playing_EVS_64_ms]			   = b.[TOTAL_Playing_EVS_64_ms]
		,[TOTAL_Playing_EVS_96_ms]			   = b.[TOTAL_Playing_EVS_96_ms]
		,[TOTAL_Playing_EVS_128_ms]			   = b.[TOTAL_Playing_EVS_128_ms]
		,[TOTAL_Recording_AMR_NB_ms]		   = b.[TOTAL_Recording_AMR_NB_ms]
		,[TOTAL_Recording_AMR_WB_ms]		   = b.[TOTAL_Recording_AMR_WB_ms]
		,[TOTAL_Recording_EVS_ms]			   = b.[TOTAL_Recording_EVS_ms]
		,[TOTAL_Unknown_EVS_ms]				   = b.[TOTAL_Unknown_EVS_ms]
		,[TOTAL_Recording_AMR_NB_1.8_ms]	   = b.[TOTAL_Recording_AMR_NB_1.8_ms]
		,[TOTAL_Recording_AMR_NB_4.75_ms]	   = b.[TOTAL_Recording_AMR_NB_4.75_ms]
		,[TOTAL_Recording_AMR_NB_5.15_ms]	   = b.[TOTAL_Recording_AMR_NB_5.15_ms]
		,[TOTAL_Recording_AMR_NB_5.9_ms]	   = b.[TOTAL_Recording_AMR_NB_5.9_ms]
		,[TOTAL_Recording_AMR_NB_6.7_ms]	   = b.[TOTAL_Recording_AMR_NB_6.7_ms]
		,[TOTAL_Recording_AMR_NB_7.4_ms]	   = b.[TOTAL_Recording_AMR_NB_7.4_ms]
		,[TOTAL_Recording_AMR_NB_7.95_ms]	   = b.[TOTAL_Recording_AMR_NB_7.95_ms]
		,[TOTAL_Recording_AMR_NB_10.2_ms]	   = b.[TOTAL_Recording_AMR_NB_10.2_ms]
		,[TOTAL_Recording_AMR_NB_12.2_ms]	   = b.[TOTAL_Recording_AMR_NB_12.2_ms]
		,[TOTAL_Recording_AMR_WB_6.6_ms]	   = b.[TOTAL_Recording_AMR_WB_6.6_ms]
		,[TOTAL_Recording_AMR_WB_8.85_ms]	   = b.[TOTAL_Recording_AMR_WB_8.85_ms]
		,[TOTAL_Recording_AMR_WB_12.65_ms]	   = b.[TOTAL_Recording_AMR_WB_12.65_ms]
		,[TOTAL_Recording_AMR_WB_14.25_ms]	   = b.[TOTAL_Recording_AMR_WB_14.25_ms]
		,[TOTAL_Recording_AMR_WB_15.85_ms]	   = b.[TOTAL_Recording_AMR_WB_15.85_ms]
		,[TOTAL_Recording_AMR_WB_18.25_ms]	   = b.[TOTAL_Recording_AMR_WB_18.25_ms]
		,[TOTAL_Recording_AMR_WB_19.85_ms]	   = b.[TOTAL_Recording_AMR_WB_19.85_ms]
		,[TOTAL_Recording_AMR_WB_23.05_ms]	   = b.[TOTAL_Recording_AMR_WB_23.05_ms]
		,[TOTAL_Recording_AMR_WB_23.85_ms]	   = b.[TOTAL_Recording_AMR_WB_23.85_ms]
		,[TOTAL_Recording_EVS_5.9_ms]		   = b.[TOTAL_Recording_EVS_5.9_ms]
		,[TOTAL_Recording_EVS_7.2_ms]		   = b.[TOTAL_Recording_EVS_7.2_ms]
		,[TOTAL_Recording_EVS_8_ms]			   = b.[TOTAL_Recording_EVS_8_ms]
		,[TOTAL_Recording_EVS_9.6_ms]		   = b.[TOTAL_Recording_EVS_9.6_ms]
		,[TOTAL_Recording_EVS_13.2_ms]		   = b.[TOTAL_Recording_EVS_13.2_ms]
		,[TOTAL_Recording_EVS_16.4_ms]		   = b.[TOTAL_Recording_EVS_16.4_ms]
		,[TOTAL_Recording_EVS_24.4_ms]		   = b.[TOTAL_Recording_EVS_24.4_ms]
		,[TOTAL_Recording_EVS_32_ms]		   = b.[TOTAL_Recording_EVS_32_ms]
		,[TOTAL_Recording_EVS_48_ms]		   = b.[TOTAL_Recording_EVS_48_ms]
		,[TOTAL_Recording_EVS_64_ms]		   = b.[TOTAL_Recording_EVS_64_ms]
		,[TOTAL_Recording_EVS_96_ms]		   = b.[TOTAL_Recording_EVS_96_ms]
		,[TOTAL_Recording_EVS_128_ms]		   = b.[TOTAL_Recording_EVS_128_ms]
		,[LQ >=1.0 and < 1.1]				   = b.[LQ >=1.0 and < 1.1]
		,[LQ >=1.1 and < 1.2]				   = b.[LQ >=1.1 and < 1.2]
		,[LQ >=1.2 and < 1.3]				   = b.[LQ >=1.2 and < 1.3]
		,[LQ >=1.3 and < 1.4]				   = b.[LQ >=1.3 and < 1.4]
		,[LQ >=1.4 and < 1.5]				   = b.[LQ >=1.4 and < 1.5]
		,[LQ >=1.5 and < 1.6]				   = b.[LQ >=1.5 and < 1.6]
		,[LQ >=1.6 and < 1.7]				   = b.[LQ >=1.6 and < 1.7]
		,[LQ >=1.7 and < 1.8]				   = b.[LQ >=1.7 and < 1.8]
		,[LQ >=1.8 and < 1.9]				   = b.[LQ >=1.8 and < 1.9]
		,[LQ >=1.9 and < 2.0]				   = b.[LQ >=1.9 and < 2.0]
		,[LQ >=2.0 and < 2.1]				   = b.[LQ >=2.0 and < 2.1]
		,[LQ >=2.1 and < 2.2]				   = b.[LQ >=2.1 and < 2.2]
		,[LQ >=2.2 and < 2.3]				   = b.[LQ >=2.2 and < 2.3]
		,[LQ >=2.3 and < 2.4]				   = b.[LQ >=2.3 and < 2.4]
		,[LQ >=2.4 and < 2.5]				   = b.[LQ >=2.4 and < 2.5]
		,[LQ >=2.5 and < 2.6]				   = b.[LQ >=2.5 and < 2.6]
		,[LQ >=2.6 and < 2.7]				   = b.[LQ >=2.6 and < 2.7]
		,[LQ >=2.7 and < 2.8]				   = b.[LQ >=2.7 and < 2.8]
		,[LQ >=2.8 and < 2.9]				   = b.[LQ >=2.8 and < 2.9]
		,[LQ >=2.9 and < 3.0]				   = b.[LQ >=2.9 and < 3.0]
		,[LQ >=3.0 and < 3.1]				   = b.[LQ >=3.0 and < 3.1]
		,[LQ >=3.1 and < 3.2]				   = b.[LQ >=3.1 and < 3.2]
		,[LQ >=3.2 and < 3.3]				   = b.[LQ >=3.2 and < 3.3]
		,[LQ >=3.3 and < 3.4]				   = b.[LQ >=3.3 and < 3.4]
		,[LQ >=3.4 and < 3.5]				   = b.[LQ >=3.4 and < 3.5]
		,[LQ >=3.5 and < 3.6]				   = b.[LQ >=3.5 and < 3.6]
		,[LQ >=3.6 and < 3.7]				   = b.[LQ >=3.6 and < 3.7]
		,[LQ >=3.7 and < 3.8]				   = b.[LQ >=3.7 and < 3.8]
		,[LQ >=3.8 and < 3.9]				   = b.[LQ >=3.8 and < 3.9]
		,[LQ >=3.9 and < 4.0]				   = b.[LQ >=3.9 and < 4.0]
		,[LQ >=4.0 and < 4.1]				   = b.[LQ >=4.0 and < 4.1]
		,[LQ >=4.1 and < 4.2]				   = b.[LQ >=4.1 and < 4.2]
		,[LQ >=4.2 and < 4.3]				   = b.[LQ >=4.2 and < 4.3]
		,[LQ >=4.3 and < 4.4]				   = b.[LQ >=4.3 and < 4.4]
		,[LQ >=4.4 and < 4.5]				   = b.[LQ >=4.4 and < 4.5]
		,[LQ >=4.5 and < 4.6]				   = b.[LQ >=4.5 and < 4.6]
		,[LQ >=4.6 and < 4.7]				   = b.[LQ >=4.6 and < 4.7]
		,[LQ >=4.7 and < 4.8]				   = b.[LQ >=4.7 and < 4.8]
		,[LQ >=4.8 and < 4.9]				   = b.[LQ >=4.8 and < 4.9]
		,[LQ >=4.9 and < 5.0]				   = b.[LQ >=4.9 and < 5.0]
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_RESULTS_SQ_Session_2018 b on a.SessionId_A = b.SessionIdA

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with aggregated RAN Information...')
	UPDATE NEW_CDR_VOICE_2018
	SET 
		 A_MCC                                = b.MCC
		,A_MNC                                = b.MNC
		,A_CellID                             = b.CID
		,A_LAC                                = b.LAC
		,A_BCCH                               = b.BCCH
		,A_SC1                                = b.SC1
		,A_SC2                                = b.SC2
		,A_SC3                                = b.SC3
		,A_SC4                                = b.SC4
		,A_CGI                                = b.CGI
		,A_BSIC                               = b.BSIC
		,A_PCI                                = b.PCI
		,A_CGI_Disconnect                     = b.Disconnect_CGI
		,A_Disconnect_LAC_CId_BCCH            = b.Disconnect_LAC_CId_BCCH
		,A_VDF_CELL_NAME					  = b.VDF_CELL
		,A_LAC_CId_BCCH                       = b.LAC_CId_BCCH
		,A_AvgTA2G                            = b.AvgTA2G
		,A_MaxTA2G                            = b.MaxTA2G
		,A_CQI_HSDPA_Min                      = b.CQI_HSDPA_Min
		,A_CQI_HSDPA                          = b.CQI_HSDPA
		,A_CQI_HSDPA_Max                      = b.CQI_HSDPA_Max
		,A_CQI_HSDPA_StDev                    = b.CQI_HSDPA_StDev
		,A_ACK3G                              = b.ACK3G
		,A_NACK3G                             = b.NACK3G
		,A_ACKNACK3G_Total                    = b.ACKNACK3G_Total
		,A_ACK3G_Percent                      = CASE WHEN b.ACKNACK3G_Total > 0 THEN b.ACK3G  / b.ACKNACK3G_Total ELSE NULL END
		,A_NACK3G_Percent                     = CASE WHEN b.ACKNACK3G_Total > 0 THEN b.NACK3G / b.ACKNACK3G_Total ELSE NULL END
		,A_BLER3G                             = b.BLER3G
		,A_BLER3GSamples                      = b.BLER3GSamples
		,A_StDevBLER3G                        = b.StDevBLER3G
		,A_CQI_LTE_Min                        = b.CQI_LTE_Min
		,A_CQI_LTE_Avg                        = b.CQI_LTE_Avg
		,A_CQI_LTE_Max                        = b.CQI_LTE_Max
		,A_CQI_LTE_StDev                      = b.CQI_LTE_StDev
		,A_ACK4G                              = b.ACK4G
		,A_NACK4G                             = b.NACK4G
		,A_ACKNACK4G_Total                    = b.ACKNACK4G_Total
		,A_ACK4G_Percent                      = CASE WHEN b.ACKNACK4G_Total > 0 THEN b.ACK4G  / b.ACKNACK4G_Total ELSE NULL END
		,A_NACK4G_Percent                     = CASE WHEN b.ACKNACK4G_Total > 0 THEN b.NACK4G / b.ACKNACK4G_Total ELSE NULL END
		,A_AvgDLTA4G                          = b.AvgDLTA4G
		,A_MaxDLTA4G                          = b.MaxDLTA4G
		,A_MinDLNumCarriers                   = b.LTE_DL_MinDLNumCarriers
		,A_AvgDLNumCarriers                   = b.LTE_DL_AvgDLNumCarriers
		,A_MaxDLNumCarriers                   = b.LTE_DL_MaxDLNumCarriers
		,A_MinDLRB                            = b.LTE_DL_MinRB
		,A_AvgDLRB                            = b.LTE_DL_AvgRB
		,A_MaxDLRB                            = b.LTE_DL_MaxRB
		,A_MinDLMCS                           = b.LTE_DL_MinMCS
		,A_AvgDLMCS                           = b.LTE_DL_AvgMCS
		,A_MaxDLMCS                           = b.LTE_DL_MaxMCS
		,A_CountDLNumQPSK                     = b.LTE_DL_CountNumQPSK		
		,A_CountDLNum16QAM                    = b.LTE_DL_CountNum16QAM	
		,A_CountDLNum64QAM                    = b.LTE_DL_CountNum64QAM	
		,A_CountDLNum256QAM                   = b.LTE_DL_CountNum256QAM
		,A_CountDLModulation                  = b.LTE_DL_CountModulation
		,A_MinScheduledPDSCHThroughput        = b.LTE_DL_MinScheduledPDSCHThroughput
		,A_AvgScheduledPDSCHThroughput        = b.LTE_DL_AvgScheduledPDSCHThroughput
		,A_MaxScheduledPDSCHThroughput        = b.LTE_DL_MaxScheduledPDSCHThroughput
		,A_MinNetPDSCHThroughput              = b.LTE_DL_MinNetPDSCHThroughput
		,A_AvgNetPDSCHThroughput              = b.LTE_DL_AvgNetPDSCHThroughput
		,A_MaxNetPDSCHThroughput              = b.LTE_DL_MaxNetPDSCHThroughput
		,A_PDSCHBytesTransfered               = b.LTE_DL_PDSCHBytesTransfered
		,A_MinDLBLER                          = b.LTE_DL_MinBLER
		,A_AvgDLBLER                          = b.LTE_DL_AvgBLER
		,A_MaxDLBLER                          = b.LTE_DL_MaxBLER
		,A_MinDLTBSize                        = b.LTE_DL_MinTBSize
		,A_AvgDLTBSize                        = b.LTE_DL_AvgTBSize
		,A_MaxDLTBSize                        = b.LTE_DL_MaxTBSize
		,A_MinDLTBRate                        = b.LTE_DL_MinTBRate
		,A_AvgDLTBRate                        = b.LTE_DL_AvgTBRate
		,A_MaxDLTBRate                        = b.LTE_DL_MaxTBRate
		,A_MinULNumCarriers                   = b.LTE_UL_MinULNumCarriers
		,A_AvgULNumCarriers                   = b.LTE_UL_AvgULNumCarriers
		,A_MaxULNumCarriers                   = b.LTE_UL_MaxULNumCarriers
		,A_CountULNumBPSK                     = b.LTE_UL_CountNumBPSK 
		,A_CountULNumQPSK                     = b.LTE_UL_CountNumQPSK 
		,A_CountULNum16QAM                    = b.LTE_UL_CountNum16QAM
		,A_CountULNum64QAM                    = b.LTE_UL_CountNum64QAM
		,A_CountULModulation                  = b.LTE_UL_CountModulation
		,A_MinScheduledPUSCHThroughput        = b.LTE_UL_MinScheduledPUSCHThroughput
		,A_AvgScheduledPUSCHThroughput        = b.LTE_UL_AvgScheduledPUSCHThroughput
		,A_MaxScheduledPUSCHThroughput        = b.LTE_UL_MaxScheduledPUSCHThroughput
		,A_MinNetPUSCHThroughput              = b.LTE_UL_MinNetPUSCHThroughput      
		,A_AvgNetPUSCHThroughput              = b.LTE_UL_AvgNetPUSCHThroughput      
		,A_MaxNetPUSCHThroughput              = b.LTE_UL_MaxNetPUSCHThroughput      
		,A_PUSCHBytesTransfered               = b.LTE_UL_PUSCHBytesTransfered       
		,A_MinULTBSize                        = b.LTE_UL_MinTBSize
		,A_AvgULTBSize                        = b.LTE_UL_AvgTBSize
		,A_MaxULTBSize                        = b.LTE_UL_MaxTBSize
		,A_MinULTBRate                        = b.LTE_UL_MinTBRate
		,A_AvgULTBRate                        = b.LTE_UL_AvgTBRate
		,A_MaxULTBRate                        = b.LTE_UL_MaxTBRate
		,A_CA_PCI                             = b.CA_PCI
		,A_HandoversInfo                      = b.HandoversInfo
		,A_RRCState                           = null
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_RAN_SESSION_2019 b on a.SessionId_A = b.SessionId

	UPDATE NEW_CDR_VOICE_2018
	SET 
		 B_MCC                                = b.MCC
		,B_MNC                                = b.MNC
		,B_CellID                             = b.CID
		,B_LAC                                = b.LAC
		,B_BCCH                               = b.BCCH
		,B_SC1                                = b.SC1
		,B_SC2                                = b.SC2
		,B_SC3                                = b.SC3
		,B_SC4                                = b.SC4
		,B_CGI                                = b.CGI
		,B_BSIC                               = b.BSIC
		,B_PCI                                = b.PCI
		,B_CGI_Disconnect                     = b.Disconnect_CGI
		,B_Disconnect_LAC_CId_BCCH            = b.Disconnect_LAC_CId_BCCH
		,B_VDF_CELL_NAME					  = b.VDF_CELL
		,B_LAC_CId_BCCH                       = b.LAC_CId_BCCH
		,B_AvgTA2G                            = b.AvgTA2G
		,B_MaxTA2G                            = b.MaxTA2G
		,B_CQI_HSDPA_Min                      = b.CQI_HSDPA_Min
		,B_CQI_HSDPA                          = b.CQI_HSDPA
		,B_CQI_HSDPA_Max                      = b.CQI_HSDPA_Max
		,B_CQI_HSDPA_StDev                    = b.CQI_HSDPA_StDev
		,B_ACK3G                              = b.ACK3G
		,B_NACK3G                             = b.NACK3G
		,B_ACKNACK3G_Total                    = b.ACKNACK3G_Total
		,B_ACK3G_Percent                      = CASE WHEN b.ACKNACK3G_Total > 0 THEN b.ACK3G  / b.ACKNACK3G_Total ELSE NULL END
		,B_NACK3G_Percent                     = CASE WHEN b.ACKNACK3G_Total > 0 THEN b.NACK3G / b.ACKNACK3G_Total ELSE NULL END
		,B_BLER3G                             = b.BLER3G
		,B_BLER3GSamples                      = b.BLER3GSamples
		,B_StDevBLER3G                        = b.StDevBLER3G
		,B_CQI_LTE_Min                        = b.CQI_LTE_Min
		,B_CQI_LTE_Avg                        = b.CQI_LTE_Avg
		,B_CQI_LTE_Max                        = b.CQI_LTE_Max
		,B_CQI_LTE_StDev                      = b.CQI_LTE_StDev
		,B_ACK4G                              = b.ACK4G
		,B_NACK4G                             = b.NACK4G
		,B_ACKNACK4G_Total                    = b.ACKNACK4G_Total
		,B_ACK4G_Percent                      = CASE WHEN b.ACKNACK4G_Total > 0 THEN b.ACK4G  / b.ACKNACK4G_Total ELSE NULL END
		,B_NACK4G_Percent                     = CASE WHEN b.ACKNACK4G_Total > 0 THEN b.NACK4G / b.ACKNACK4G_Total ELSE NULL END
		,B_AvgDLTA4G                          = b.AvgDLTA4G
		,B_MaxDLTA4G                          = b.MaxDLTA4G
		,B_MinDLNumCarriers                   = b.LTE_DL_MinDLNumCarriers
		,B_AvgDLNumCarriers                   = b.LTE_DL_AvgDLNumCarriers
		,B_MaxDLNumCarriers                   = b.LTE_DL_MaxDLNumCarriers
		,B_MinDLRB                            = b.LTE_DL_MinRB
		,B_AvgDLRB                            = b.LTE_DL_AvgRB
		,B_MaxDLRB                            = b.LTE_DL_MaxRB
		,B_MinDLMCS                           = b.LTE_DL_MinMCS
		,B_AvgDLMCS                           = b.LTE_DL_AvgMCS
		,B_MaxDLMCS                           = b.LTE_DL_MaxMCS
		,B_CountDLNumQPSK                     = b.LTE_DL_CountNumQPSK		
		,B_CountDLNum16QAM                    = b.LTE_DL_CountNum16QAM	
		,B_CountDLNum64QAM                    = b.LTE_DL_CountNum64QAM	
		,B_CountDLNum256QAM                   = b.LTE_DL_CountNum256QAM
		,B_CountDLModulation                  = b.LTE_DL_CountModulation
		,B_MinScheduledPDSCHThroughput        = b.LTE_DL_MinScheduledPDSCHThroughput
		,B_AvgScheduledPDSCHThroughput        = b.LTE_DL_AvgScheduledPDSCHThroughput
		,B_MaxScheduledPDSCHThroughput        = b.LTE_DL_MaxScheduledPDSCHThroughput
		,B_MinNetPDSCHThroughput              = b.LTE_DL_MinNetPDSCHThroughput
		,B_AvgNetPDSCHThroughput              = b.LTE_DL_AvgNetPDSCHThroughput
		,B_MaxNetPDSCHThroughput              = b.LTE_DL_MaxNetPDSCHThroughput
		,B_PDSCHBytesTransfered               = b.LTE_DL_PDSCHBytesTransfered
		,B_MinDLBLER                          = b.LTE_DL_MinBLER
		,B_AvgDLBLER                          = b.LTE_DL_AvgBLER
		,B_MaxDLBLER                          = b.LTE_DL_MaxBLER
		,B_MinDLTBSize                        = b.LTE_DL_MinTBSize
		,B_AvgDLTBSize                        = b.LTE_DL_AvgTBSize
		,B_MaxDLTBSize                        = b.LTE_DL_MaxTBSize
		,B_MinDLTBRate                        = b.LTE_DL_MinTBRate
		,B_AvgDLTBRate                        = b.LTE_DL_AvgTBRate
		,B_MaxDLTBRate                        = b.LTE_DL_MaxTBRate
		,B_MinULNumCarriers                   = b.LTE_UL_MinULNumCarriers
		,B_AvgULNumCarriers                   = b.LTE_UL_AvgULNumCarriers
		,B_MaxULNumCarriers                   = b.LTE_UL_MaxULNumCarriers
		,B_CountULNumBPSK                     = b.LTE_UL_CountNumBPSK 
		,B_CountULNumQPSK                     = b.LTE_UL_CountNumQPSK 
		,B_CountULNum16QAM                    = b.LTE_UL_CountNum16QAM
		,B_CountULNum64QAM                    = b.LTE_UL_CountNum64QAM
		,B_CountULModulation                  = b.LTE_UL_CountModulation
		,B_MinScheduledPUSCHThroughput        = b.LTE_UL_MinScheduledPUSCHThroughput
		,B_AvgScheduledPUSCHThroughput        = b.LTE_UL_AvgScheduledPUSCHThroughput
		,B_MaxScheduledPUSCHThroughput        = b.LTE_UL_MaxScheduledPUSCHThroughput
		,B_MinNetPUSCHThroughput              = b.LTE_UL_MinNetPUSCHThroughput      
		,B_AvgNetPUSCHThroughput              = b.LTE_UL_AvgNetPUSCHThroughput      
		,B_MaxNetPUSCHThroughput              = b.LTE_UL_MaxNetPUSCHThroughput      
		,B_PUSCHBytesTransfered               = b.LTE_UL_PUSCHBytesTransfered       
		,B_MinULTBSize                        = b.LTE_UL_MinTBSize
		,B_AvgULTBSize                        = b.LTE_UL_AvgTBSize
		,B_MaxULTBSize                        = b.LTE_UL_MaxTBSize
		,B_MinULTBRate                        = b.LTE_UL_MinTBRate
		,B_AvgULTBRate                        = b.LTE_UL_AvgTBRate
		,B_MaxULTBRate                        = b.LTE_UL_MaxTBRate
		,B_CA_PCI                             = b.CA_PCI
		,B_HandoversInfo                      = b.HandoversInfo
		,B_RRCState                           = null
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_RAN_SESSION_2019 b on a.SessionId_B = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with aggregated Technology Information...')
	UPDATE NEW_CDR_VOICE_2018
	SET 
		 RAT_A                       = b.RAT                     
		,RAT_Technology_Duration_s_A = b.RAT_Technology_Duration_s
		,RAT_Timeline_A              = b.RAT_Timeline         
		,TIME_GSM_900_s_A            = b.TIME_GSM_900_s           
		,TIME_GSM_1800_s_A           = b.TIME_GSM_1800_s
		,TIME_GSM_1900_s_A           = b.TIME_GSM_1900_s
		,TIME_UMTS_850_s_A           = b.TIME_UMTS_850_s
		,TIME_UMTS_900_s_A           = b.TIME_UMTS_900_s
		,TIME_UMTS_1700_s_A          = b.TIME_UMTS_1700_s
		,TIME_UMTS_1900_s_A          = b.TIME_UMTS_1900_s
		,TIME_UMTS_2100_s_A          = b.TIME_UMTS_2100_s
		,TIME_LTE_700_s_A            = b.TIME_LTE_700_s
		,TIME_LTE_800_s_A            = b.TIME_LTE_800_s
		,TIME_LTE_900_s_A            = b.TIME_LTE_900_s
		,TIME_LTE_1700_s_A           = b.TIME_LTE_1700_s
		,TIME_LTE_1800_s_A           = b.TIME_LTE_1800_s
		,TIME_LTE_1900_s_A           = b.TIME_LTE_1900_s
		,TIME_LTE_2100_s_A           = b.TIME_LTE_2100_s
		,TIME_LTE_2600_s_A           = b.TIME_LTE_2600_s
		,TIME_LTE_TDD_2300_s_A       = b.TIME_LTE_TDD_2300_s
		,TIME_LTE_TDD_2500_s_A       = b.TIME_LTE_TDD_2500_s
		,TIME_WiFi_s_A               = b.TIME_WiFi_s
		,TIME_No_Service_s_A         = b.TIME_No_Service_s
		,TIME_Unknown_s_A            = b.TIME_Unknown_s
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_TECH_Session_2018 b on a.SessionId_A = b.SessionId

	UPDATE NEW_CDR_VOICE_2018
	SET 
		 RAT_B                       = b.RAT                     
		,RAT_Technology_Duration_s_B = b.RAT_Technology_Duration_s
		,RAT_Timeline_B              = b.RAT_Timeline         
		,TIME_GSM_900_s_B            = b.TIME_GSM_900_s           
		,TIME_GSM_1800_s_B           = b.TIME_GSM_1800_s
		,TIME_GSM_1900_s_B           = b.TIME_GSM_1900_s
		,TIME_UMTS_850_s_B           = b.TIME_UMTS_850_s
		,TIME_UMTS_900_s_B           = b.TIME_UMTS_900_s
		,TIME_UMTS_1700_s_B          = b.TIME_UMTS_1700_s
		,TIME_UMTS_1900_s_B          = b.TIME_UMTS_1900_s
		,TIME_UMTS_2100_s_B          = b.TIME_UMTS_2100_s
		,TIME_LTE_700_s_B            = b.TIME_LTE_700_s
		,TIME_LTE_800_s_B            = b.TIME_LTE_800_s
		,TIME_LTE_900_s_B            = b.TIME_LTE_900_s
		,TIME_LTE_1700_s_B           = b.TIME_LTE_1700_s
		,TIME_LTE_1800_s_B           = b.TIME_LTE_1800_s
		,TIME_LTE_1900_s_B           = b.TIME_LTE_1900_s
		,TIME_LTE_2100_s_B           = b.TIME_LTE_2100_s
		,TIME_LTE_2600_s_B           = b.TIME_LTE_2600_s
		,TIME_LTE_TDD_2300_s_B       = b.TIME_LTE_TDD_2300_s
		,TIME_LTE_TDD_2500_s_B       = b.TIME_LTE_TDD_2500_s
		,TIME_WiFi_s_B               = b.TIME_WiFi_s
		,TIME_No_Service_s_B         = b.TIME_No_Service_s
		,TIME_Unknown_s_B            = b.TIME_Unknown_s
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_TECH_Session_2018 b on a.SessionId_B = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with aggregated Radio Information...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with aggregated Technology Information...')
	UPDATE NEW_CDR_VOICE_2018
	SET 
		 A_MinRxLev           = b.MinRxLev           
		,A_AvgRxLev           = b.AvgRxLev           
		,A_MaxRxLev           = b.MaxRxLev           
		,A_StDevRxLev         = b.StDevRxLev         
		,A_MinRxQual          = b.MinRxQual          
		,A_AvgRxQual          = b.AvgRxQual          
		,A_MaxRxQual          = b.MaxRxQual          
		,A_StDevRxQual        = b.StDevRxQual        
		,A_MinRSCP            = b.MinRSCP            
		,A_AvgRSCP            = b.AvgRSCP            
		,A_MaxRSCP            = b.MaxRSCP            
		,A_StDevRSCP          = b.StDevRSCP          
		,A_MinEcIo            = b.MinEcIo            
		,A_AvgEcIo            = b.AvgEcIo            
		,A_MaxEcIo            = b.MaxEcIo            
		,A_StDevEcIo          = b.StDevEcIo          
		,A_MinTxPwr3G         = b.MinTxPwr3G         
		,A_AvgTxPwr3G         = b.AvgTxPwr3G         
		,A_MaxTxPwr3G         = b.MaxTxPwr3G         
		,A_StDevTxPwr3G       = b.StDevTxPwr3G       
		,A_MinRSRP            = b.MinRSRP            
		,A_AvgRSRP            = b.AvgRSRP            
		,A_MaxRSRP            = b.MaxRSRP            
		,A_StDevRSRP          = b.StDevRSRP          
		,A_MinRSRQ            = b.MinRSRQ            
		,A_AvgRSRQ            = b.AvgRSRQ            
		,A_MaxRSRQ            = b.MaxRSRQ            
		,A_StDevRSRQ          = b.StDevRSRQ          
		,A_MinSINR            = b.MinSINR            
		,A_AvgSINR            = b.AvgSINR            
		,A_MaxSINR            = b.MaxSINR            
		,A_StDevSINR          = b.StDevSINR          
		,A_MinSINR0           = b.MinSINR0           
		,A_AvgSINR0           = b.AvgSINR0           
		,A_MaxSINR0           = b.MaxSINR0           
		,A_StDevSINR0         = b.StDevSINR0         
		,A_MinSINR1           = b.MinSINR1           
		,A_AvgSINR1           = b.AvgSINR1           
		,A_MaxSINR1           = b.MaxSINR1           
		,A_StDevSINR1         = b.StDevSINR1         
		,A_MinTxPwr4G         = b.MinTxPwr4G         
		,A_AvgTxPwr4G         = b.AvgTxPwr4G         
		,A_MaxTxPwr4G         = b.MaxTxPwr4G         
		,A_StDevTxPwr4G       = b.StDevTxPwr4G       
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_RF_Session_2018 b on a.SessionId_A = b.SessionId

	UPDATE NEW_CDR_VOICE_2018
	SET 
		 B_MinRxLev           = b.MinRxLev           
		,B_AvgRxLev           = b.AvgRxLev           
		,B_MaxRxLev           = b.MaxRxLev           
		,B_StDevRxLev         = b.StDevRxLev         
		,B_MinRxQual          = b.MinRxQual          
		,B_AvgRxQual          = b.AvgRxQual          
		,B_MaxRxQual          = b.MaxRxQual          
		,B_StDevRxQual        = b.StDevRxQual        
		,B_MinRSCP            = b.MinRSCP            
		,B_AvgRSCP            = b.AvgRSCP            
		,B_MaxRSCP            = b.MaxRSCP            
		,B_StDevRSCP          = b.StDevRSCP          
		,B_MinEcIo            = b.MinEcIo            
		,B_AvgEcIo            = b.AvgEcIo            
		,B_MaxEcIo            = b.MaxEcIo            
		,B_StDevEcIo          = b.StDevEcIo          
		,B_MinTxPwr3G         = b.MinTxPwr3G         
		,B_AvgTxPwr3G         = b.AvgTxPwr3G         
		,B_MaxTxPwr3G         = b.MaxTxPwr3G         
		,B_StDevTxPwr3G       = b.StDevTxPwr3G       
		,B_MinRSRP            = b.MinRSRP            
		,B_AvgRSRP            = b.AvgRSRP            
		,B_MaxRSRP            = b.MaxRSRP            
		,B_StDevRSRP          = b.StDevRSRP          
		,B_MinRSRQ            = b.MinRSRQ            
		,B_AvgRSRQ            = b.AvgRSRQ            
		,B_MaxRSRQ            = b.MaxRSRQ            
		,B_StDevRSRQ          = b.StDevRSRQ          
		,B_MinSINR            = b.MinSINR            
		,B_AvgSINR            = b.AvgSINR            
		,B_MaxSINR            = b.MaxSINR            
		,B_StDevSINR          = b.StDevSINR          
		,B_MinSINR0           = b.MinSINR0           
		,B_AvgSINR0           = b.AvgSINR0           
		,B_MaxSINR0           = b.MaxSINR0           
		,B_StDevSINR0         = b.StDevSINR0         
		,B_MinSINR1           = b.MinSINR1           
		,B_AvgSINR1           = b.AvgSINR1           
		,B_MaxSINR1           = b.MaxSINR1           
		,B_StDevSINR1         = b.StDevSINR1         
		,B_MinTxPwr4G         = b.MinTxPwr4G         
		,B_AvgTxPwr4G         = b.AvgTxPwr4G         
		,B_MaxTxPwr4G         = b.MaxTxPwr4G         
		,B_StDevTxPwr4G       = b.StDevTxPwr4G       
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_RF_Session_2018 b on a.SessionId_B = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with PCAP Files...')
	IF OBJECT_ID ('tempdb..#pcap' ) IS NOT NULL DROP TABLE #pcap
	SELECT SessionID,
		   CASE WHEN MAX(CASE WHEN RNK = 2 THEN FILENAME ELSE NULL END) is null THEN MAX(CASE WHEN RNK = 1 THEN FILENAME ELSE NULL END)
				WHEN MAX(CASE WHEN RNK = 1 THEN FILENAME ELSE NULL END) is null THEN MAX(CASE WHEN RNK = 2 THEN FILENAME ELSE NULL END)
				ELSE  MAX(CASE WHEN RNK = 1 THEN FILENAME ELSE NULL END) + '/' + MAX(CASE WHEN RNK = 2 THEN FILENAME ELSE NULL END)
				END AS Filename
	INTO #pcap
	FROM (SELECT 
		RANK () OVER (PARTITION BY SessionID ORDER BY Filename) AS RNK,
		SessionID,
		FileName
	FROM PCAPData ) AS Input
	GROUP BY SessionID

	UPDATE NEW_CDR_VOICE_2018
	SET  NEW_CDR_VOICE_2018.[ASideFileNamePCAP] = rtrim(convert(nvarchar(200),(SELECT TOP 1 Filename FROM #pcap WHERE #pcap.SessionId = NEW_CDR_VOICE_2018.SessionId_A)))
		,NEW_CDR_VOICE_2018.[BSideFileNamePCAP] = rtrim(convert(nvarchar(200),(SELECT TOP 1 Filename FROM #pcap WHERE #pcap.SessionId = NEW_CDR_VOICE_2018.SessionId_B)))

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with SwissQual Releases...')
	UPDATE NEW_CDR_VOICE_2018
	SET  Validity = 0
		,Invalid_Reason = 'SwissQual System Release'
	WHERE Call_Status like 'System%' or Call_Status like 'not%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with JOIN_ID...')
	UPDATE NEW_CDR_VOICE_2018
	SET JOIN_ID = HashBytes('MD5',[ASideFileName]+'_'+IMEI_A+'_'+cast([MO:Dial] as varchar(100)))

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with Operator Information ...')
	UPDATE NEW_CDR_VOICE_2018
	SET
		   [HomeOperator_A]	= [HomeOperator]	
		  ,[HomeMCC_A]		= [HomeMCC]		
		  ,[HomeMNC_A]		= [HomeMNC]		
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_Operator b ON a.SessionId_A = b.SessionId

	UPDATE NEW_CDR_VOICE_2018
	SET
		   [HomeOperator_B]	= [HomeOperator]	
		  ,[HomeMCC_B]		= [HomeMCC]		
		  ,[HomeMNC_B]		= [HomeMNC]		
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_Operator b ON a.SessionId_B = b.SessionId

	UPDATE NEW_CDR_VOICE_2018
	SET Operator = CASE WHEN [HomeOperator_A] like [HomeOperator_B] THEN [HomeOperator_A]
						ELSE [HomeOperator_A] + ' - ' + [HomeOperator_B]
						END

	UPDATE NEW_CDR_VOICE_2018
	SET
		 [CallSetupTime(MO:Dial->MO:Alerting)]        = null
		,[CallSetupTime(MO:Dial->MO:ConnectAck)]      = null
		,[CallSetupTime(MT:Alerting->MT:Connect)]     = null
		,[MO:Sip200Ok/CC:Connect]                     = null
		,[MO:SipAck/CC:ConnectAck]                    = null
		,[A->B Samples Count]                         = null
		,[B->A Samples Count]                         = null
		,[Total Samples Count]                        = null
		,[POLQA_LQ_MIN]                               = null
		,[POLQA_LQ_AVG]                               = null
		,[POLQA_LQ_MEAN]                              = null
		,[POLQA_LQ_MAX]                               = null
		,[POLQA_LQ_SUM]                               = null
		,[SilenceDistortionCount]                     = null
		,[1.0>=Bad<1.6]                               = null
		,[1.6>=Poor<2.3]                              = null
		,[2.3>=Fair<3.2]                              = null
		,[3.2>=Good<3.7]                              = null
		,[3.7>=Excellent<5.0]                         = null
		,[1.0>=BadCustom<1.4]                         = null
		,[1.0>=BadCustom<1.8]                         = null
		,[MinTimeClipping]                            = null
		,[AvgTimeClipping]                            = null
		,[MedianTimeClipping]                         = null
		,[MaxTimeClipping]                            = null
		,[SumTimeClipping]                            = null
		,[MinDelaySpread]                             = null
		,[AvgDelaySpread]                             = null
		,[MedianDelaySpread]                          = null
		,[MaxDelaySpread]                             = null
		,[SumDelaySpread]                             = null
		,[MindelayDeviation]                          = null
		,[AvgdelayDeviation]                          = null
		,[MediandelayDeviation]                       = null
		,[MaxdelayDeviation]                          = null
		,[SumdelayDeviation]                          = null
		,[MinnoiseRcv]                                = null
		,[AvgnoiseRcv]                                = null
		,[MediannoiseRcv]                             = null
		,[MaxnoiseRcv]                                = null
		,[SumnoiseRcv]                                = null
		,[MinstaticSNR]                               = null
		,[AvgstaticSNR]                               = null
		,[MedianstaticSNR]                            = null
		,[MaxstaticSNR]                               = null
		,[SumstaticSNR]                               = null
		,[MinReceiveDelay]                            = null
		,[AvgReceiveDelay]                            = null
		,[MedianReceiveDelay]                         = null
		,[MaxReceiveDelay]                            = null
		,[SumReceiveDelay]                            = null
		,[MinAmplClipping]                            = null
		,[AvgAmplClipping]                            = null
		,[MedianAmplClipping]                         = null
		,[MaxAmplClipping]                            = null
		,[SumAmplClipping]                            = null
		,[MinMissedVoice]                             = null
		,[AvgMissedVoice]                             = null
		,[MedianMissedVoice]                          = null
		,[MaxMissedVoice]                             = null
		,[SumMissedVoice]                             = null
		,[TOTAL_Playing_AMR_NB_ms]                    = null
		,[TOTAL_Playing_AMR_WB_ms]                    = null
		,[TOTAL_Playing_EVS_ms]                       = null
		,[TOTAL_Playing_Unknown_ms]                   = null
		,[TOTAL_Playing_AMR_NB_1.8_ms]                = null
		,[TOTAL_Playing_AMR_NB_4.75_ms]               = null
		,[TOTAL_Playing_AMR_NB_5.15_ms]               = null
		,[TOTAL_Playing_AMR_NB_5.9_ms]                = null
		,[TOTAL_Playing_AMR_NB_6.7_ms]                = null
		,[TOTAL_Playing_AMR_NB_7.4_ms]                = null
		,[TOTAL_Playing_AMR_NB_7.95_ms]               = null
		,[TOTAL_Playing_AMR_NB_10.2_ms]               = null
		,[TOTAL_Playing_AMR_NB_12.2_ms]               = null
		,[TOTAL_Playing_AMR_WB_6.6_ms]                = null
		,[TOTAL_Playing_AMR_WB_8.85_ms]               = null
		,[TOTAL_Playing_AMR_WB_12.65_ms]              = null
		,[TOTAL_Playing_AMR_WB_14.25_ms]              = null
		,[TOTAL_Playing_AMR_WB_15.85_ms]              = null
		,[TOTAL_Playing_AMR_WB_18.25_ms]              = null
		,[TOTAL_Playing_AMR_WB_19.85_ms]              = null
		,[TOTAL_Playing_AMR_WB_23.05_ms]              = null
		,[TOTAL_Playing_AMR_WB_23.85_ms]              = null
		,[TOTAL_Playing_EVS_5.9_ms]                   = null
		,[TOTAL_Playing_EVS_7.2_ms]                   = null
		,[TOTAL_Playing_EVS_8_ms]                     = null
		,[TOTAL_Playing_EVS_9.6_ms]                   = null
		,[TOTAL_Playing_EVS_13.2_ms]                  = null
		,[TOTAL_Playing_EVS_16.4_ms]                  = null
		,[TOTAL_Playing_EVS_24.4_ms]                  = null
		,[TOTAL_Playing_EVS_32_ms]                    = null
		,[TOTAL_Playing_EVS_48_ms]                    = null
		,[TOTAL_Playing_EVS_64_ms]                    = null
		,[TOTAL_Playing_EVS_96_ms]                    = null
		,[TOTAL_Playing_EVS_128_ms]                   = null
		,[TOTAL_Recording_AMR_NB_ms]                  = null
		,[TOTAL_Recording_AMR_WB_ms]                  = null
		,[TOTAL_Recording_EVS_ms]                     = null
		,[TOTAL_Unknown_EVS_ms]                       = null
		,[TOTAL_Recording_AMR_NB_1.8_ms]              = null
		,[TOTAL_Recording_AMR_NB_4.75_ms]             = null
		,[TOTAL_Recording_AMR_NB_5.15_ms]             = null
		,[TOTAL_Recording_AMR_NB_5.9_ms]              = null
		,[TOTAL_Recording_AMR_NB_6.7_ms]              = null
		,[TOTAL_Recording_AMR_NB_7.4_ms]              = null
		,[TOTAL_Recording_AMR_NB_7.95_ms]             = null
		,[TOTAL_Recording_AMR_NB_10.2_ms]             = null
		,[TOTAL_Recording_AMR_NB_12.2_ms]             = null
		,[TOTAL_Recording_AMR_WB_6.6_ms]              = null
		,[TOTAL_Recording_AMR_WB_8.85_ms]             = null
		,[TOTAL_Recording_AMR_WB_12.65_ms]            = null
		,[TOTAL_Recording_AMR_WB_14.25_ms]            = null
		,[TOTAL_Recording_AMR_WB_15.85_ms]            = null
		,[TOTAL_Recording_AMR_WB_18.25_ms]            = null
		,[TOTAL_Recording_AMR_WB_19.85_ms]            = null
		,[TOTAL_Recording_AMR_WB_23.05_ms]            = null
		,[TOTAL_Recording_AMR_WB_23.85_ms]            = null
		,[TOTAL_Recording_EVS_5.9_ms]                 = null
		,[TOTAL_Recording_EVS_7.2_ms]                 = null
		,[TOTAL_Recording_EVS_8_ms]                   = null
		,[TOTAL_Recording_EVS_9.6_ms]                 = null
		,[TOTAL_Recording_EVS_13.2_ms]                = null
		,[TOTAL_Recording_EVS_16.4_ms]                = null
		,[TOTAL_Recording_EVS_24.4_ms]                = null
		,[TOTAL_Recording_EVS_32_ms]                  = null
		,[TOTAL_Recording_EVS_48_ms]                  = null
		,[TOTAL_Recording_EVS_64_ms]                  = null
		,[TOTAL_Recording_EVS_96_ms]                  = null
		,[TOTAL_Recording_EVS_128_ms]                 = null
		,[LQ >=1.0 and < 1.1]                         = null
		,[LQ >=1.1 and < 1.2]                         = null
		,[LQ >=1.2 and < 1.3]                         = null
		,[LQ >=1.3 and < 1.4]                         = null
		,[LQ >=1.4 and < 1.5]                         = null
		,[LQ >=1.5 and < 1.6]                         = null
		,[LQ >=1.6 and < 1.7]                         = null
		,[LQ >=1.7 and < 1.8]                         = null
		,[LQ >=1.8 and < 1.9]                         = null
		,[LQ >=1.9 and < 2.0]                         = null
		,[LQ >=2.0 and < 2.1]                         = null
		,[LQ >=2.1 and < 2.2]                         = null
		,[LQ >=2.2 and < 2.3]                         = null
		,[LQ >=2.3 and < 2.4]                         = null
		,[LQ >=2.4 and < 2.5]                         = null
		,[LQ >=2.5 and < 2.6]                         = null
		,[LQ >=2.6 and < 2.7]                         = null
		,[LQ >=2.7 and < 2.8]                         = null
		,[LQ >=2.8 and < 2.9]                         = null
		,[LQ >=2.9 and < 3.0]                         = null
		,[LQ >=3.0 and < 3.1]                         = null
		,[LQ >=3.1 and < 3.2]                         = null
		,[LQ >=3.2 and < 3.3]                         = null
		,[LQ >=3.3 and < 3.4]                         = null
		,[LQ >=3.4 and < 3.5]                         = null
		,[LQ >=3.5 and < 3.6]                         = null
		,[LQ >=3.6 and < 3.7]                         = null
		,[LQ >=3.7 and < 3.8]                         = null
		,[LQ >=3.8 and < 3.9]                         = null
		,[LQ >=3.9 and < 4.0]                         = null
		,[LQ >=4.0 and < 4.1]                         = null
		,[LQ >=4.1 and < 4.2]                         = null
		,[LQ >=4.2 and < 4.3]                         = null
		,[LQ >=4.3 and < 4.4]                         = null
		,[LQ >=4.4 and < 4.5]                         = null
		,[LQ >=4.5 and < 4.6]                         = null
		,[LQ >=4.6 and < 4.7]                         = null
		,[LQ >=4.7 and < 4.8]                         = null
		,[LQ >=4.8 and < 4.9]                         = null
		,[LQ >=4.9 and < 5.0]                         = null
	WHERE Call_Status like 'Failed'


PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script Execution COMPLETED!')

-- SELECT * FROM NEW_CDR_VOICE_2018 Where Call_Status like 'System%' ORDER BY SessionId_PRIM_KEY
