------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING TABLES IF THEY DO NOT EXIST
-- Table: NEW_CDR_DATA_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Script Execution starting ...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CREATING TABLE: NEW_CDR_DATA_2018...')
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_CDR_DATA_2018')	DROP Table NEW_CDR_DATA_2018
	SELECT 1									AS		Validity
		  ,CAST(null as varchar(100))			AS		InvalidReason

		  ,'TEST INFORMATION >>'				AS		SECTION_TEST_INFORMATION
		  ,[SessionId_A]						AS		Sessionid
		  ,[TestId]
		  ,CAST(null as varchar(20))			AS		Test_Status
		  ,CAST(null as varchar(100))			AS		ErrorCode_Message
		  ,[qualityIndication]
		  ,[Type_Of_Test]						AS		Test_Type
		  ,[Test_Name]
		  ,[Test_Description]					AS		Test_Info
		  ,[direction]
		  ,[Host]
		  ,CAST(null as varchar(200 ))			AS      URL
		  ,CAST(null as varchar(50 ))			AS      APN
		  ,CAST(null as varchar(50 ))			AS      APN_Name
		  ,CAST(null as varchar(50 ))			AS      AndroidApp
		  ,CAST(null as varchar(50 ))			AS      AppProtocol

		  ,'FAILURE CLASSIFICATION >>'			AS		SECTION_FAILURE_CLASSIFICATION
		  ,CAST(NULL AS varchar(200))			AS		FAILURE_PHASE
		  ,CAST(NULL AS varchar(200))			AS		FAILURE_TECHNOLOGY
		  ,CAST(NULL AS varchar(200))			AS		FAILURE_CLASS
		  ,CAST(NULL AS varchar(200))			AS		FAILURE_CATEGORY
		  ,CAST(NULL AS varchar(200))			AS		FAILURE_SUBCATEGORY
		  ,CAST(NULL AS varchar(max))			AS		FAILURE_COMMENT

		  ,'MEASUREMENT SYSTEM INFORMATION >>'	AS		SECTION_MEASUREMENT_SYSTEM
		  ,[Campaign_A]
		  ,[Collection_A]
		  ,[System_Name_A]
		  ,[System_Type_A]
		  ,[Zone_A]
		  ,[Location_A]
		  ,[SW_A]
		  ,[UE_A]
		  ,[FW_A]
		  ,[IMEI_A]
		  ,[IMSI_A]
		  ,[MSISDN_A]
		  ,[FileId_A]
		  ,[FileName_A]
		  ,[Sequenz_ID_per_File_A]
		  ,CAST(null as varchar(200)) as [PCAP_File_Name]
		  ,[StartNetworkId_A]
		  ,[startTechnology_A]
		  ,[StartPosId_A]
		  ,[startLongitude_A]
		  ,[startLatitude_A]
		  ,[numSatelites_A]
		  ,[Altitude_A]
		  ,[Distance_A]
		  ,[minSpeed_A]
		  ,[maxSpeed_A]

		  ,'G_LEVEL INFORMATION >>'				AS		GEOLEVEL_INFORMATION
		  ,CAST(null as bigint)					AS      ProtocolID
		  ,CAST(null as varchar(100 ))			AS      Channel
		  ,CAST(null as varchar(100 ))			AS      Channel_Description
		  ,CAST(null as varchar(15))			AS      MSISDN
		  ,CAST(null as varchar(500 ))			AS      Region
		  ,CAST(null as varchar(500 ))			AS      Vendor
		  ,CAST(null as varchar(100 ))			AS      G_Level_1
		  ,CAST(null as varchar(100 ))			AS      G_Level_2
		  ,CAST(null as varchar(100 ))			AS      G_Level_3
		  ,CAST(null as varchar(100 ))			AS      G_Level_4
		  ,CAST(null as varchar(100 ))			AS      G_Level_5
		  ,CAST(null as varchar(500 ))			AS      Remark
		  ,CAST(null as varchar(100 ))			AS      Train_Type
		  ,CAST(null as varchar(100 ))			AS      Train_Name
		  ,CAST(null as varchar(100 ))			AS      Wagon_Number
		  ,CAST(null as varchar(100 ))			AS      Repeater_Wagon

		  ,'EVENTS INFORMATION >>'				AS		SECTION_EVENT_INFORMATION
		  ,[Test_Start_Time]
		  ,cast(null as datetime2(3))			AS DNS_1st_Request
		  ,cast(null as datetime2(3))			AS DNS_1st_Response
		  ,cast(null as datetime2(3))			AS TCP_1st_SYN
		  ,cast(null as datetime2(3))			AS TCP_1st_SYN_ACK
		  ,cast(null as datetime2(3))			AS Player_1st_Packet
		  ,cast(null as datetime2(3))			AS Player_End_of_Download
		  ,cast(null as datetime2(3))			AS Video_Start_Download
		  ,cast(null as datetime2(3))			AS Video_Start_Transfer
		  ,cast(null as datetime2(3))			AS Data_1st_recieved
		  ,cast(null as datetime2(3))			AS Data_Last_Recieved
		  ,[Test_End_Time]
		  ,[Test_Duration_ms]

		  ,'TCP/IP INFORMATION >>'				AS		SECTION_TCP_IP_INFO
		  ,CAST(null as varchar(50 ))			AS      IP_Service_Access_Result
		  ,CAST(null as bigint)					AS      IP_Service_Access_Delay_ms
		  ,CAST(null as bigint)					AS      DNS_Delay_ms
		  ,CAST(null as bigint)					AS      RTT_Delay_ms
		  ,CAST(null as varchar(max))			AS      Client_IPs
		  ,CAST(null as nvarchar(max))			AS      Server_IPs
		  ,CAST(null as int)					AS      TCP_Threads_Count
		  ,CAST(null as varchar(max))			AS      TCP_Threads_Per_Server
		  ,CAST(null as varchar(200 ))			AS      DNS_Server_IPs
		  ,CAST(null as int)					AS      DNS_Resolution_Attempts
		  ,CAST(null as int)					AS      DNS_Resolution_Success
		  ,CAST(null as int)					AS      DNS_Resolution_Failures
		  ,CAST(null as int)					AS      DNS_Resolution_Time_Minimum_ms
		  ,CAST(null as int)					AS      DNS_Resolution_Time_Average_ms
		  ,CAST(null as int)					AS      DNS_Resolution_Time_Maximum_ms
		  ,CAST(null as varchar(max))			AS      DNS_Hosts_List
		  ,CAST(null as bigint)					AS      IP_Layer_Transferred_Bytes_DL	
		  ,CAST(null as bigint)					AS      IP_Layer_Transferred_Bytes_UL

		  ,'QoS TRANSFERS >>'					AS		SECTION_QOS_TRANSFERS
		  ,CAST(null as float)					AS      Application_Layer_MDR_kbit_s
		  ,CAST(null as float)					AS      Content_Transfered_Size_Bytes
		  ,CAST(null as float)					AS      Content_Transfered_Time_ms
		  ,CAST(null as varchar(100 ))			AS      Local_Filename
		  ,CAST(null as varchar(100 ))			AS      Remote_Filename
		  ,CAST(null as int)					AS      Page_Images_Count

		  ,'QoS VIDEO STREAM >>'				AS		SECTION_QOS_VIDEO_STREAM
		  ,CAST(null as real)     				AS      MIN_VMOS
		  ,CAST(null as real)     				AS      AVG_VMOS
		  ,CAST(null as real)     				AS      MAX_VMOS
		  ,CAST(null as int)     				AS      TimeToFirstPicture_ms
		  ,CAST(null as real)     				AS      FrameRateCalc
		  ,CAST(null as real)     				AS      Black
		  ,CAST(null as int)					AS      Video_Freeze_Count
		  ,CAST(null as real)     				AS      Freezing_Proportion
		  ,CAST(null as decimal(10,2))			AS      Longest_Single_Freezing_Time_s
		  ,CAST(null as decimal(10,2))			AS      Accumulated_Freezing_Time_s
		  ,CAST(null as int)					AS      Video_Skips_Count
		  ,CAST(null as int)					AS      Video_Skips_Duration_Time_s
		  ,CAST(null as real)     				AS      Jerkiness
		  ,CAST(null as varchar(63 ))     		AS      ImageSizeInPixels
		  ,CAST(null as int)     				AS      HorResolution
		  ,CAST(null as int)     				AS      VerResolution
		  ,CAST(null as varchar(1000 ))			AS      Resolution_Timeline
		  ,CAST(null as varchar(50 ))     		AS      ApplicationResolutionOptions
		  ,CAST(null as real)     				AS      StreamedVideoTime
		  ,CAST(null as int)     				AS      StreamedVideoTotalTime
		  -- VIDEO STREAM DETAILED STATUS FOR EACH PHASE IF AVAILABLE
		  ,CAST(null as varchar(100 ))			AS      Video_Stream_Result_Detailed
		  ,CAST(null as varchar(10 ))			AS      Player_IP_Service_Access_Status
		  ,CAST(null as varchar(10 ))			AS      Player_Download_Status
		  ,CAST(null as varchar(10 ))			AS      Player_Session_Status
		  ,CAST(null as varchar(10 ))			AS      Video_IP_Service_Access_Status
		  ,CAST(null as varchar(10 ))			AS      Video_Reproduction_Start_Status
		  ,CAST(null as varchar(10 ))			AS      Video_Play_Start_Status
		  ,CAST(null as varchar(10 ))			AS      Video_Transfer_Status
		  ,CAST(null as varchar(10 ))			AS      Video_Playout_Status
		  ,CAST(null as varchar(10 ))			AS      Video_Session_Status
		  -- VIDEO STREAM TIMERS FOR EACH ETSI DEFINED TRIGGER IF AVAILBLE
		  ,CAST(null as decimal(10,2))			AS      Player_IP_Service_Access_Time_s
		  ,CAST(null as decimal(10,2))			AS      Player_Download_Time_s
		  ,CAST(null as decimal(10,2))			AS      Player_Session_Time_s
		  ,CAST(null as decimal(10,2))			AS      Test_Video_Stream_Duration_s
		  ,CAST(null as decimal(10,2))			AS      Video_IP_Service_Access_Time_s
		  ,CAST(null as decimal(10,2))			AS      Video_Reproduction_Start_Delay_s
		  ,CAST(null as decimal(10,2))			AS      Video_Play_Start_Time_s
		  ,CAST(null as decimal(10,2))			AS      Time_To_First_Picture_s
		  ,CAST(null as decimal(10,2))			AS      Video_Transfer_Time_s
		  ,CAST(null as decimal(10,2))			AS      Video_Expected_Duration_Time_s
		  ,CAST(null as decimal(10,2))			AS      Video_Playout_Duration_Time_s
		  ,CAST(null as decimal(10,2))			AS      Video_Playout_Cutoff_Time_s
		  ,CAST(null as decimal(10,2))			AS      Video_Session_Time_s
		  ,CAST(null as numeric)				AS      Video_Downloaded_Size_kbit

		  ,'QoS ICMP PING >>'					AS		SECTION_QOS_ICMP
		  ,CAST(null as int)					AS      PING_Samples
		  ,CAST(null as int)					AS      PING_Failure_Samples
		  ,CAST(null as bigint)					AS      RTT_SUM_ms
		  ,CAST(null as int)					AS      RTT_MIN_ms
		  ,CAST(null as bigint)					AS      RTT_AVG_ms
		  ,CAST(null as bigint)					AS      RTT_AVG_no_1st_ms
		  ,CAST(null as int)					AS      RTT_MAX_ms
		  ,CAST(null as int)					AS      PacketSize_01
		  ,CAST(null as int)					AS      ErrorCode_01
		  ,CAST(null as varchar(100 ))			AS      ErrorMessage_01
		  ,CAST(null as int)					AS      RTT_01
		  ,CAST(null as int)					AS      PacketSize_02
		  ,CAST(null as int)					AS      ErrorCode_02
		  ,CAST(null as varchar(100 ))			AS      ErrorMessage_02
		  ,CAST(null as int)					AS      RTT_02
		  ,CAST(null as int)					AS      PacketSize_03
		  ,CAST(null as int)					AS      ErrorCode_03
		  ,CAST(null as varchar(100 ))			AS      ErrorMessage_03
		  ,CAST(null as int)					AS      RTT_03
		  ,CAST(null as int)					AS      PacketSize_04
		  ,CAST(null as int)					AS      ErrorCode_04
		  ,CAST(null as varchar(100 ))			AS      ErrorMessage_04
		  ,CAST(null as int)					AS      RTT_04
		  ,CAST(null as int)					AS      PacketSize_05
		  ,CAST(null as int)					AS      ErrorCode_05
		  ,CAST(null as varchar(100 ))			AS      ErrorMessage_05
		  ,CAST(null as int)					AS      RTT_05

		  ,'TECHNOLOGY EXTRACTED INFORMATION >>'		AS		SECTION_TECH_DATA
		  ,CAST(null as varchar(20 ))			AS      RAT
		  ,CAST(null as decimal(10,2))			AS      TIME_GSM_900_s
		  ,CAST(null as decimal(10,2))			AS      TIME_GSM_1800_s
		  ,CAST(null as decimal(10,2))			AS      TIME_GSM_1900_s
		  ,CAST(null as decimal(10,2))			AS      TIME_UMTS_850_s
		  ,CAST(null as decimal(10,2))			AS      TIME_UMTS_900_s
		  ,CAST(null as decimal(10,2))			AS      TIME_UMTS_1700_s
		  ,CAST(null as decimal(10,2))			AS      TIME_UMTS_1900_s
		  ,CAST(null as decimal(10,2))			AS      TIME_UMTS_2100_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_700_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_800_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_900_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_1700_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_1800_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_1900_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_2100_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_2600_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_TDD_2300_s
		  ,CAST(null as decimal(10,2))			AS      TIME_LTE_TDD_2500_s
		  ,CAST(null as decimal(10,2))			AS      TIME_No_Service_s
		  ,CAST(null as decimal(10,2))			AS      TIME_Unknown_s
		  ,CAST(null as decimal(10,2))			AS      Test_RAT_Duration_s
		  ,CAST(null as varchar(500 ))			AS      RAT_Timeline
		  ,CAST(null as decimal(10,2))			AS      GPRS_s
		  ,CAST(null as decimal(10,2))			AS      EDGE_s
		  ,CAST(null as decimal(10,2))			AS      UMTS_R99_s
		  ,CAST(null as decimal(10,2))			AS      HSDPA_s
		  ,CAST(null as decimal(10,2))			AS      HSUPA_s
		  ,CAST(null as decimal(10,2))			AS      HSDPA_Plus_s
		  ,CAST(null as decimal(10,2))			AS      HSPA_s
		  ,CAST(null as decimal(10,2))			AS      HSPA_Plus_s
		  ,CAST(null as decimal(10,2))			AS      HSPA_DC_s
		  ,CAST(null as decimal(10,2))			AS      LTE_s
		  ,CAST(null as decimal(10,2))			AS      LTE_CA_s
		  ,CAST(null as decimal(10,2))			AS      Wifi_s
		  ,CAST(null as decimal(10,2))			AS      Unknown_s
		  ,CAST(null as decimal(10,2))			AS      Test_TEC_Duration_s
		  ,CAST(null as varchar(500 ))			AS      TEC_Timeline

		  ,'RF EXTRACTED INFORMATION >>'		AS		SECTION_RF_DATA
		  ,CAST(null as decimal(10,2))			AS      MinRxLev
		  ,CAST(null as decimal(10,2))			AS      AvgRxLev
		  ,CAST(null as decimal(10,2))			AS      MaxRxLev
		  ,CAST(null as decimal(10,2))			AS      StDevRxLev
		  ,CAST(null as decimal(10,2))			AS      MinRxQual
		  ,CAST(null as decimal(10,2))			AS      AvgRxQual
		  ,CAST(null as decimal(10,2))			AS      MaxRxQual
		  ,CAST(null as decimal(10,2))			AS      StDevRxQual
		  ,CAST(null as decimal(10,2))			AS      MinRSCP
		  ,CAST(null as decimal(10,2))			AS      AvgRSCP
		  ,CAST(null as decimal(10,2))			AS      MaxRSCP
		  ,CAST(null as decimal(10,2))			AS      StDevRSCP
		  ,CAST(null as decimal(10,2))			AS      MinEcIo
		  ,CAST(null as decimal(10,2))			AS      AvgEcIo
		  ,CAST(null as decimal(10,2))			AS      MaxEcIo
		  ,CAST(null as decimal(10,2))			AS      StDevEcIo
		  ,CAST(null as decimal(10,2))			AS      MinTxPwr3G
		  ,CAST(null as decimal(10,2))			AS      AvgTxPwr3G
		  ,CAST(null as decimal(10,2))			AS      MaxTxPwr3G
		  ,CAST(null as decimal(10,2))			AS      StDevTxPwr3G
		  ,CAST(null as decimal(10,2))			AS      MinRSRP
		  ,CAST(null as decimal(10,2))			AS      AvgRSRP
		  ,CAST(null as decimal(10,2))			AS      MaxRSRP
		  ,CAST(null as decimal(10,2))			AS      StDevRSRP
		  ,CAST(null as decimal(10,2))			AS      MinRSRQ
		  ,CAST(null as decimal(10,2))			AS      AvgRSRQ
		  ,CAST(null as decimal(10,2))			AS      MaxRSRQ
		  ,CAST(null as decimal(10,2))			AS      StDevRSRQ
		  ,CAST(null as decimal(10,2))			AS      MinSINR
		  ,CAST(null as decimal(10,2))			AS      AvgSINR
		  ,CAST(null as decimal(10,2))			AS      MaxSINR
		  ,CAST(null as decimal(10,2))			AS      StDevSINR
		  ,CAST(null as decimal(10,2))			AS      MinSINR0
		  ,CAST(null as decimal(10,2))			AS      AvgSINR0
		  ,CAST(null as decimal(10,2))			AS      MaxSINR0
		  ,CAST(null as decimal(10,2))			AS      StDevSINR0
		  ,CAST(null as decimal(10,2))			AS      MinSINR1
		  ,CAST(null as decimal(10,2))			AS      AvgSINR1
		  ,CAST(null as decimal(10,2))			AS      MaxSINR1
		  ,CAST(null as decimal(10,2))			AS      StDevSINR1
		  ,CAST(null as decimal(10,2))			AS      MinTxPwr4G
		  ,CAST(null as decimal(10,2))			AS      AvgTxPwr4G
		  ,CAST(null as decimal(10,2))			AS      MaxTxPwr4G
		  ,CAST(null as decimal(10,2))			AS      StDevTxPwr4G

		  ,'RAN EXTRACTED INFORMATION >>'		AS		SECTION_RAN_DATA
		  ,CAST(null as varchar(50 ))			AS      HomeOperator
		  ,CAST(null as int)					AS      HomeMCC
		  ,CAST(null as int)					AS      HomeMNC
		  ,CAST(null as varchar(500 ))     		AS      MCC
		  ,CAST(null as varchar(500 ))     		AS      MNC
		  ,CAST(null as varchar(500 ))     		AS      CellID
		  ,CAST(null as varchar(500 ))     		AS      LAC
		  ,CAST(null as varchar(500 ))     		AS      BCCH
		  ,CAST(null as varchar(500 ))     		AS      SC1
		  ,CAST(null as varchar(500 ))     		AS      SC2
		  ,CAST(null as varchar(500 ))     		AS      SC3
		  ,CAST(null as varchar(500 ))     		AS      SC4
		  ,CAST(null as varchar(2000 ))     	AS      CGI
		  ,CAST(null as varchar(500 ))     		AS      BSIC
		  ,CAST(null as varchar(2000 ))     	AS      PCI
		  ,CAST(null as varchar(2000 ))     	AS      LAC_CId_BCCH
		  ,CAST(null as varchar(2000 ))     	AS      VDF_CELL_NAME
		  ,CAST(null as bigint)     			AS      AvgTA2G
		  ,CAST(null as bigint)     			AS      MaxTA2G
		  ,CAST(null as bigint)     			AS      CQI_HSDPA_Min
		  ,CAST(null as bigint)     			AS      CQI_HSDPA
		  ,CAST(null as bigint)     			AS      CQI_HSDPA_Max
		  ,CAST(null as float)      			AS      CQI_HSDPA_StDev
		  ,CAST(null as bigint)     			AS      ACK3G
		  ,CAST(null as bigint)     			AS      NACK3G
		  ,CAST(null as bigint)     			AS      ACKNACK3G_Total
		  ,CAST(null as float)      			AS      BLER3G
		  ,CAST(null as bigint)     			AS      BLER3GSamples
		  ,CAST(null as float)      			AS      StDevBLER3G
		  ,CAST(null as float)      			AS      CQI_LTE_Min
		  ,CAST(null as float)      			AS      CQI0
		  ,CAST(null as float)      			AS      CQI_LTE
		  ,CAST(null as float)      			AS      CQI_LTE_Max
		  ,CAST(null as float)      			AS      CQI_LTE_StDev
		  ,CAST(null as bigint)     			AS      ACK4G
		  ,CAST(null as bigint)     			AS      NACK4G
		  ,CAST(null as bigint)     			AS      ACKNACK4G_Total
		  ,CAST(null as bigint)     			AS      AvgDLTA4G
		  ,CAST(null as bigint)     			AS      MaxDLTA4G
		  ,CAST(null as float)      			AS      LTE_DL_MinDLNumCarriers
		  ,CAST(null as float)      			AS      LTE_DL_AvgDLNumCarriers
		  ,CAST(null as float)      			AS      LTE_DL_MaxDLNumCarriers
		  ,CAST(null as float)      			AS      LTE_DL_MinRB
		  ,CAST(null as float)      			AS      LTE_DL_AvgRB
		  ,CAST(null as float)      			AS      LTE_DL_MaxRB
		  ,CAST(null as float)      			AS      LTE_DL_MinMCS
		  ,CAST(null as float)      			AS      LTE_DL_AvgMCS
		  ,CAST(null as float)      			AS      LTE_DL_MaxMCS
		  ,CAST(null as bigint)     			AS      LTE_DL_CountNumQPSK
		  ,CAST(null as bigint)     			AS      LTE_DL_CountNum16QAM
		  ,CAST(null as bigint)     			AS      LTE_DL_CountNum64QAM
		  ,CAST(null as bigint)     			AS      LTE_DL_CountNum256QAM
		  ,CAST(null as bigint)     			AS      LTE_DL_CountModulation
		  ,CAST(null as float)      			AS      LTE_DL_MinScheduledPDSCHThroughput
		  ,CAST(null as float)      			AS      LTE_DL_AvgScheduledPDSCHThroughput
		  ,CAST(null as float)      			AS      LTE_DL_MaxScheduledPDSCHThroughput
		  ,CAST(null as float)      			AS      LTE_DL_MinNetPDSCHThroughput
		  ,CAST(null as float)      			AS      LTE_DL_AvgNetPDSCHThroughput
		  ,CAST(null as float)      			AS      LTE_DL_MaxNetPDSCHThroughput
		  ,CAST(null as bigint)     			AS      LTE_DL_PDSCHBytesTransfered
		  ,CAST(null as float)      			AS      LTE_DL_MinBLER
		  ,CAST(null as float)      			AS      LTE_DL_AvgBLER
		  ,CAST(null as float)      			AS      LTE_DL_MaxBLER
		  ,CAST(null as float)      			AS      LTE_DL_MinTBSize
		  ,CAST(null as float)      			AS      LTE_DL_AvgTBSize
		  ,CAST(null as float)      			AS      LTE_DL_MaxTBSize
		  ,CAST(null as float)      			AS      LTE_DL_MinTBRate
		  ,CAST(null as float)      			AS      LTE_DL_AvgTBRate
		  ,CAST(null as float)      			AS      LTE_DL_MaxTBRate
		  ,CAST(null as varchar(100 ))     		AS      LTE_DL_TransmissionMode
		  ,CAST(null as float)     				AS      LTE_UL_MinULNumCarriers
		  ,CAST(null as float)     				AS      LTE_UL_AvgULNumCarriers
		  ,CAST(null as float)     				AS      LTE_UL_MaxULNumCarriers
		  ,CAST(null as bigint)     			AS      LTE_UL_CountNumBPSK
		  ,CAST(null as bigint)     			AS      LTE_UL_CountNumQPSK
		  ,CAST(null as bigint)     			AS      LTE_UL_CountNum16QAM
		  ,CAST(null as bigint)     			AS      LTE_UL_CountNum64QAM
		  ,CAST(null as bigint)     			AS      LTE_UL_CountModulation
		  ,CAST(null as float)      			AS      LTE_UL_MinScheduledPUSCHThroughput
		  ,CAST(null as float)      			AS      LTE_UL_AvgScheduledPUSCHThroughput
		  ,CAST(null as float)      			AS      LTE_UL_MaxScheduledPUSCHThroughput
		  ,CAST(null as float)      			AS      LTE_UL_MinNetPUSCHThroughput
		  ,CAST(null as float)      			AS      LTE_UL_AvgNetPUSCHThroughput
		  ,CAST(null as float)      			AS      LTE_UL_MaxNetPUSCHThroughput
		  ,CAST(null as bigint)     			AS      LTE_UL_PUSCHBytesTransfered
		  ,CAST(null as float)      			AS      LTE_UL_MinTBSize
		  ,CAST(null as float)      			AS      LTE_UL_AvgTBSize
		  ,CAST(null as float)      			AS      LTE_UL_MaxTBSize
		  ,CAST(null as float)      			AS      LTE_UL_MinTBRate
		  ,CAST(null as float)      			AS      LTE_UL_AvgTBRate
		  ,CAST(null as float)      			AS      LTE_UL_MaxTBRate
		  ,CAST(null as varchar(5000 ))     	AS      CA_PCI
		  ,CAST(null as varchar(5000 ))     	AS      HandoversInfo

		  ,'LTE CARRIER AGGREGATION INFORMATION >>'		AS		SECTION_LTE_CA
		  ,CAST(null as datetime2(3))     		AS      CA_STARTTIME
		  ,CAST(null as real)     				AS      CA_duration
		  ,CAST(null as bigint)     			AS      CA_PosId
		  ,CAST(null as int)     				AS      CA_PDSCHThroughput
		  ,CAST(null as int)     				AS      CA_PUSCHThroughput
		  ,CAST(null as real)     				AS      CA_AvgNRBDL
		  ,CAST(null as real)     				AS      CA_AvgNRBUL
		  ,CAST(null as real)     				AS      CA_PCellAvgCQI
		  ,CAST(null as int)     				AS      CA_PCellPDSCHThroughput
		  ,CAST(null as bigint)     			AS      CA_PCellTransferredDL
		  ,CAST(null as int)     				AS      CA_PCellPUSCHThroughput
		  ,CAST(null as bigint)     			AS      CA_PCellTransferredUL
		  ,CAST(null as int)     				AS      CA_PCellTBRateDL
		  ,CAST(null as real)     				AS      CA_PCellRank2Ratio
		  ,CAST(null as real)     				AS      CA_PCellRank3Ratio
		  ,CAST(null as real)     				AS      CA_PCellRank4Ratio
		  ,CAST(null as real)     				AS      CA_PCell4ANTRatio
		  ,CAST(null as real)     				AS      CA_PCellAvgMCSDL
		  ,CAST(null as real)     				AS      CA_PCellAvgNRBDL
		  ,CAST(null as int)     				AS      CA_PCellTBRateUL
		  ,CAST(null as real)     				AS      CA_PCellAvgMCSUL
		  ,CAST(null as real)     				AS      CA_PCellAvgNRBUL
		  ,CAST(null as real)     				AS      CA_SCellAvgCQI
		  ,CAST(null as int)     				AS      CA_SCellPDSCHThroughput
		  ,CAST(null as bigint)     			AS      CA_SCellTransferredDL
		  ,CAST(null as int)     				AS      CA_SCellPUSCHThroughput
		  ,CAST(null as bigint)     			AS      CA_SCellTransferredUL
		  ,CAST(null as int)      				AS      CA_SCellTBRateDL
		  ,CAST(null as real)     				AS      CA_SCellRank2Ratio
		  ,CAST(null as real)     				AS      CA_SCellRank3Ratio
		  ,CAST(null as real)     				AS      CA_SCellRank4Ratio
		  ,CAST(null as real)     				AS      CA_SCell4ANTRatio
		  ,CAST(null as real)     				AS      CA_SCellAvgMCSDL
		  ,CAST(null as real)     				AS      CA_SCellAvgNRBDL
		  ,CAST(null as real)     				AS      CA_SCellAvgNRBDL2
		  ,CAST(null as int)      				AS      CA_SCellTBRateUL
		  ,CAST(null as real)     				AS      CA_SCellAvgMCSUL
		  ,CAST(null as real)     				AS      CA_SCellAvgNRBUL
		  ,CAST(null as int)      				AS      CA_PCellDLEARFCN
		  ,CAST(null as int)      				AS      CA_PCellDLBW
		  ,CAST(null as real)     				AS      CA_PCellRSRP
		  ,CAST(null as real)     				AS      CA_PCellRSRQ
		  ,CAST(null as real)     				AS      CA_PCellSINR
		  ,CAST(null as int)      				AS      CA_SCell1DLEARFCN
		  ,CAST(null as int)      				AS      CA_SCell1DLBW
		  ,CAST(null as real)     				AS      CA_SCell1RSRP
		  ,CAST(null as real)     				AS      CA_SCell1RSRQ
		  ,CAST(null as real)     				AS      CA_SCell1SINR
		  ,CAST(null as int)      				AS      CA_SCell2DLEARFCN
		  ,CAST(null as int)      				AS      CA_SCell2DLBW
		  ,CAST(null as real)     				AS      CA_SCell2RSRP
		  ,CAST(null as real)     				AS      CA_SCell2RSRQ
		  ,CAST(null as real)     				AS      CA_SCell2SINR
		  ,CAST(null as int)      				AS      CA_SCell3DLEARFCN
		  ,CAST(null as int)      				AS      CA_SCell3DLBW
		  ,CAST(null as real)     				AS      CA_SCell3RSRP
		  ,CAST(null as real)     				AS      CA_SCell3RSRQ
		  ,CAST(null as real)     				AS      CA_SCell3SINR
		  ,CAST(null as int)      				AS      CA_UNUSUAL
		  ,HashBytes('MD5',FileName_A+'_'+IMEI_A+'_'+cast(Test_Start_Time as varchar(100))) AS JOIN_ID
	  INTO NEW_CDR_DATA_2018
	  FROM [NEW_Test_Info_2018] where Type_Of_Test not like 'POLQA'
	  Order by TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with TCP/IP Information...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_IP_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET
		   [Server_IPs]				= b.[HTTP_Server_IPs]	
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RESULTS_IP_2018 b ON a.TestId = b.TestId and a.SessionId = b.SessionId
	END

IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_IP_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET
		   [Client_IPs]				= b.[CLIENT_IPs]			
		  ,[Server_IPs]				= CASE WHEN a.[Server_IPs] is not null then a.[Server_IPs] else b.[Server_IPs] end
		  ,[TCP_Threads_Count]		= b.[Threads_Count]		
		  ,[TCP_Threads_Per_Server]	= b.[Threads_Per_Server]
		  ,IP_Layer_Transferred_Bytes_DL = b.IP_Layer_Transferred_Bytes_DL
		  ,IP_Layer_Transferred_Bytes_UL = b.IP_Layer_Transferred_Bytes_UL			
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RESULTS_IP_2018 b ON a.TestId = b.TestId and a.SessionId = b.SessionId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with DNS Information...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_DNS_PER_TEST_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET
		   [DNS_Server_IPs]					= b.[DNS_Server_IPs]					
		  ,[DNS_Resolution_Attempts]		= b.[DNS_Resolution_Attempts]		
		  ,[DNS_Resolution_Success]			= b.[DNS_Resolution_Success]			
		  ,[DNS_Resolution_Failures]		= b.[DNS_Resolution_Failures]		
		  ,[DNS_Resolution_Time_Minimum_ms]	= b.[DNS_Resolution_Time_Minimum_ms]	
		  ,[DNS_Resolution_Time_Average_ms]	= b.[DNS_Resolution_Time_Average_ms]	
		  ,[DNS_Resolution_Time_Maximum_ms]	= b.[DNS_Resolution_Time_Maximum_ms]	
		  ,[DNS_Hosts_List]					= b.[DNS_Hosts_List]					
		  ,[DNS_1st_Request]				= b.[DNS_1st_Request]				
		  ,[DNS_1st_Response]				= b.[DNS_1st_Response]				
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_DNS_PER_TEST_2018 b ON a.TestId = b.TestId and a.SessionId = b.SessionId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with ICMP Ping Test Results...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_ICMP_Tests_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET		
			  Validity					   = case when b.Validity is not null THEN b.Validity
												  else a.Validity
												  end
			  ,InvalidReason				   = case when b.InvalidReason is not null THEN b.InvalidReason
		  										  else a.InvalidReason
		  										  end
			  ,Test_Type				       = CASE WHEN b.Test_Type is not null THEN b.Test_Type collate Latin1_General_CI_AS
		  										  ELSE a.Test_Type
		  										  END
			  ,Test_Name					   = CASE WHEN b.Test_Name is not null THEN b.Test_Name collate Latin1_General_CI_AS
		  										  ELSE a.Test_Name
		  										  END
			  ,Test_Info					   = CASE WHEN b.Test_Info is not null THEN b.Test_Info collate Latin1_General_CI_AS
		  										  ELSE a.Test_Info
		  										  END
			  ,Test_Status			  = b.[Test_Result]
			  ,Host					  = CASE WHEN b.Host is not null then b.Host collate SQL_Latin1_General_CP1_CI_AS else a.Host end
			  ,direction			  = 'RT'
			  ,[PING_Samples]		  = b.[PING_Samples]		  
			  ,[PING_Failure_Samples] = b.[PING_Failure_Samples] 
			  ,[RTT_SUM_ms]			  = b.[RTT_SUM_ms]			  
			  ,[RTT_MIN_ms]			  = b.[RTT_MIN_ms]			  
			  ,[RTT_AVG_ms]			  = b.[RTT_AVG_ms]			  
			  ,[RTT_AVG_no_1st_ms]	  = b.[RTT_AVG_no_1st_ms]	  
			  ,[RTT_MAX_ms]			  = b.[RTT_MAX_ms]			  
			  ,[PacketSize_01]		  = b.[PacketSize_01]		  
			  ,[ErrorCode_01]		  = b.[ErrorCode_01]		  
			  ,[ErrorMessage_01]	  = b.[ErrorMessage_01]	  
			  ,[RTT_01]				  = b.[RTT_01]				  
			  ,[PacketSize_02]		  = b.[PacketSize_02]		  
			  ,[ErrorCode_02]		  = b.[ErrorCode_02]		  
			  ,[ErrorMessage_02]	  = b.[ErrorMessage_02]	  
			  ,[RTT_02]				  = b.[RTT_02]				  
			  ,[PacketSize_03]		  = b.[PacketSize_03]		  
			  ,[ErrorCode_03]		  = b.[ErrorCode_03]		  
			  ,[ErrorMessage_03]	  = b.[ErrorMessage_03]	  
			  ,[RTT_03]				  = b.[RTT_03]				  
			  ,[PacketSize_04]		  = b.[PacketSize_04]		  
			  ,[ErrorCode_04]		  = b.[ErrorCode_04]		  
			  ,[ErrorMessage_04]	  = b.[ErrorMessage_04]	  
			  ,[RTT_04]				  = b.[RTT_04]				  
			  ,[PacketSize_05]		  = b.[PacketSize_05]		  
			  ,[ErrorCode_05]		  = b.[ErrorCode_05]		  
			  ,[ErrorMessage_05]	  = b.[ErrorMessage_05]	  
			  ,[RTT_05]				  = b.[RTT_05]
			  ,AppProtocol			  = 'ICMP'	
			  ,AndroidApp								= CASE WHEN b.[Test_Result] is not null THEN 'SQ Ping' ELSE a.AndroidApp	END	
			  ,ErrorCode_Message	  = CASE WHEN b.[ErrorCode_01] > 0 THEN b.[ErrorMessage_01]
											 WHEN b.[ErrorCode_02] > 0 THEN b.[ErrorMessage_02]
											 WHEN b.[ErrorCode_03] > 0 THEN b.[ErrorMessage_03]
											 WHEN b.[ErrorCode_04] > 0 THEN b.[ErrorMessage_04]
											 WHEN b.[ErrorCode_05] > 0 THEN b.[ErrorMessage_05]
											 WHEN a.Test_Type like 'ICMP%'	THEN 'OK'
											 ELSE a.ErrorCode_Message
											 END
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RESULTS_ICMP_Tests_2018 b ON a.TestId = b.TestId and a.SessionId = b.SessionId
		WHERE b.PING_Samples is not null
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with Social Media Test Results...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_SOCIAL_MEDIA_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET
			 Validity					   = case when b.Validity is not null THEN b.Validity
												  else a.Validity
												  end
			,InvalidReason				   = case when b.InvalidReason is not null THEN b.InvalidReason
												  else a.InvalidReason
												  end
			  ,Test_Status				     = CASE WHEN b.Test_Result is not null THEN b.[Test_Result] ELSE a.Test_Status END
			  ,Test_Type				     = CASE WHEN b.Test_Type is not null THEN b.Test_Type collate Latin1_General_CI_AS ELSE a.Test_Type END
			  ,Test_Name				     = CASE WHEN b.Test_Name is not null THEN b.Test_Name collate Latin1_General_CI_AS ELSE a.Test_Name END
			  ,Test_Info				     = CASE WHEN b.Test_Info is not null THEN b.Test_Info collate Latin1_General_CI_AS ELSE a.Test_Info END
			  ,direction				     = CASE WHEN b.direction is not null THEN b.direction collate Latin1_General_CI_AS ELSE a.direction END
			  ,IP_Service_Access_Result      = CASE WHEN b.IP_Server_Access_Result is not null THEN b.IP_Server_Access_Result collate Latin1_General_CI_AS
												  ELSE a.IP_Service_Access_Result
												  END
			  ,IP_Service_Access_Delay_ms    = CASE WHEN b.IP_Service_Access_Time_ms is not null THEN b.IP_Service_Access_Time_ms
												  ELSE a.IP_Service_Access_Delay_ms
												  END
			  ,TCP_1st_SYN_ACK                 = CASE WHEN b.IP_Serv_End is not null THEN b.IP_Serv_End
		  										  ELSE a.TCP_1st_SYN_ACK
		  										  END
			  ,DNS_Delay_ms                  = CASE WHEN b.DNS_1st_Service_Delay_ms is not null THEN b.DNS_1st_Service_Delay_ms
												  ELSE a.DNS_Delay_ms
												  END
			  ,RTT_Delay_ms                  = CASE WHEN b.RTT_ms is not null THEN b.RTT_ms
												  ELSE a.RTT_Delay_ms
												  END
			,Content_Transfered_Size_Bytes			= CASE WHEN b.File_Size_bytes is not null THEN b.File_Size_bytes
															ELSE a.Content_Transfered_Size_Bytes
															END
			,[Local_Filename]						 = CASE WHEN b.FileName is not null THEN b.FileName  collate Latin1_General_CI_AS
															ELSE a.Local_Filename
															END
			,Content_Transfered_Time_ms				= CASE WHEN b.Transfer_Time_ms is not null THEN b.Transfer_Time_ms
															ELSE a.Content_Transfered_Time_ms
															END
			,AndroidApp								= CASE
														   WHEN a.AndroidApp is null and b.Test_Name like '%Facebook%'	THEN 'Facebook App'
														   WHEN a.AndroidApp is null and b.Test_Name like '%Instagram%'	THEN 'Instagram App'
														   WHEN a.AndroidApp is null and b.Test_Name like '%WhatsApp%'	THEN 'WhatsApp'
														   else a.AndroidApp
														   END
			,AppProtocol							= CASE WHEN b.[Test_Result] is not null THEN 'HTTPS'		ELSE a.AppProtocol	END
			,host									= CASE  
														   WHEN a.host is null and b.Test_Name like '%Facebook%'	THEN 'https://facebook.com'
														   WHEN a.host is null and b.Test_Name like '%Instagram%'	THEN 'https://instagram.com'
														   WHEN a.host is null and b.Test_Name like '%WhatsApp%'	THEN 'https://whatsapp.com'
														   ELSE a.host
														   END
			,url									= CASE
														   WHEN a.url  is null and b.Test_Name like '%Facebook%'	THEN 'https://facebook.com'
														   WHEN a.url  is null and b.Test_Name like '%Instagram%'	THEN 'https://instagram.com'
														   WHEN a.url  is null and b.Test_Name like '%WhatsApp%'	THEN 'https://whatsapp.com'
														   else a.url
														   END
			,ErrorCode_Message						= CASE WHEN b.ErrorCode_Message is not null THEN b.ErrorCode_Message
														   ELSE a.ErrorCode_Message
														   END
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RESULTS_SOCIAL_MEDIA_2018 b ON a.TestId = b.TestId and a.SessionId = b.SessionId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with HTTP TRANSFER Test Results...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_http_Transfers_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET 
			 Validity					   = case when b.Validity is not null THEN b.Validity
												  else a.Validity
												  end
			,InvalidReason				   = case when b.InvalidReason is not null THEN b.InvalidReason
												  else a.InvalidReason
												  end
			,Test_Status				   = CASE WHEN b.Status is not null THEN b.Status
												  ELSE a.Test_Status
												  END
			,Test_Type				       = CASE WHEN b.Test_Type is not null THEN b.Test_Type collate Latin1_General_CI_AS
												  ELSE a.Test_Type
												  END
			,Test_Name					   = CASE WHEN b.Test_Name is not null THEN b.Test_Name collate Latin1_General_CI_AS
												  ELSE a.Test_Name
												  END
			,Test_Info					   = CASE WHEN b.Test_Info is not null THEN b.Test_Info collate Latin1_General_CI_AS
												  ELSE a.Test_Info
												  END
			,direction					   = CASE WHEN b.direction is not null THEN b.direction collate Latin1_General_CI_AS
												  ELSE a.direction
												  END
			,host					       = CASE WHEN b.Host is not null THEN b.Host collate Latin1_General_CI_AS
												  ELSE a.host
												  END
			,URL					       = CASE WHEN b.URL is not null THEN b.URL collate Latin1_General_CI_AS
												  ELSE a.URL
												  END
			,APN					       = CASE WHEN b.APN is not null THEN b.APN collate Latin1_General_CI_AS
												  ELSE a.APN
												  END
			,IP_Service_Access_Result      = CASE WHEN b.IpServiceAccessStatus is not null THEN b.IpServiceAccessStatus collate Latin1_General_CI_AS
												  ELSE a.IP_Service_Access_Result
												  END
			,IP_Service_Access_Delay_ms    = CASE WHEN b.IpServiceAccessTime_ms is not null THEN b.IpServiceAccessTime_ms
												  ELSE a.IP_Service_Access_Delay_ms
												  END
			,DNS_Delay_ms                  = CASE WHEN b.DNS_Delay_Access_ms is not null THEN b.DNS_Delay_Access_ms
												  ELSE a.DNS_Delay_ms
												  END
			,DNS_1st_Request               = CASE WHEN b.DNS_1st_Request is not null THEN b.DNS_1st_Request
												  ELSE a.DNS_1st_Request
												  END
			,DNS_1st_Response              = CASE WHEN b.DNS_1st_Response is not null THEN b.DNS_1st_Response
												  ELSE a.DNS_1st_Response
												  END
			,RTT_Delay_ms                  = CASE WHEN b.Round_Trip_Time_ms is not null THEN b.Round_Trip_Time_ms
												  ELSE a.RTT_Delay_ms
												  END
			,TCP_1st_SYN                    = CASE WHEN b.TCP_SYN_UL is not null THEN b.TCP_SYN_UL
												  ELSE a.TCP_1st_SYN
												  END
			,TCP_1st_SYN_ACK                 = CASE WHEN b.TCP_SYNACK_UL is not null THEN b.TCP_SYNACK_UL
												  ELSE a.TCP_1st_SYN_ACK
												  END
			,Data_1st_recieved                 = CASE WHEN b.HTTP_1st_Data is not null THEN b.HTTP_1st_Data
												  ELSE a.Data_1st_recieved
												  END
			,Data_Last_Recieved                = CASE WHEN b.HTTP_last_Data is not null THEN b.HTTP_last_Data
												  ELSE a.Data_Last_Recieved
												  END
			,[Application_Layer_MDR_kbit_s]			 = CASE WHEN b.Throughput_kbit_s is not null THEN CAST(b.Throughput_kbit_s as decimal(10,2))
															ELSE a.Application_Layer_MDR_kbit_s
															END
			,Content_Transfered_Size_Bytes			= CASE WHEN b.BytesTransferred is not null THEN b.BytesTransferred
															ELSE a.Content_Transfered_Size_Bytes
															END
			,[Local_Filename]						 = CASE WHEN b.LocalFilename is not null THEN b.LocalFilename  collate Latin1_General_CI_AS
															ELSE a.Local_Filename
															END
			,[Remote_Filename]						 = CASE WHEN b.RemoteFilename is not null THEN b.RemoteFilename  collate Latin1_General_CI_AS
															ELSE a.Remote_Filename
															END
			,Content_Transfered_Time_ms				= CASE WHEN b.duration is not null THEN b.duration
															ELSE a.Content_Transfered_Time_ms
															END
			,AndroidApp								= CASE WHEN b.Status is not null THEN 'SQ Generic' ELSE AndroidApp	END
			,AppProtocol							= CASE WHEN b.Status is not null THEN 'HTTP' ELSE AppProtocol	END
			,ErrorCode_Message						= CASE WHEN b.ErrorCode_Message is not null THEN b.ErrorCode_Message
														   ELSE a.ErrorCode_Message
														   END
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RESULTS_http_Transfers_2018 b ON a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with HTTP BROWSING Test Results...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_http_Browsing_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET 
			 Validity					   = case when b.Validity is not null THEN b.Validity
												  else a.Validity
												  end
			,InvalidReason				   = case when b.InvalidReason is not null THEN b.InvalidReason
												  else a.InvalidReason
												  end
			,Test_Status				   = CASE WHEN b.Status is not null THEN b.Status
												  ELSE a.Test_Status
												  END
			,Test_Type				       = CASE WHEN b.Test_Type is not null THEN b.Test_Type collate Latin1_General_CI_AS
												  ELSE a.Test_Type
												  END
			,Test_Name					   = CASE WHEN b.Test_Name is not null THEN b.Test_Name collate Latin1_General_CI_AS
												  ELSE a.Test_Name
												  END
			,Test_Info					   = CASE WHEN b.Test_Info is not null THEN b.Test_Info collate Latin1_General_CI_AS
												  ELSE a.Test_Info
												  END
			,direction					   = CASE WHEN b.direction is not null THEN b.direction collate Latin1_General_CI_AS
												  ELSE a.direction
												  END
			,host					       = CASE WHEN b.Host is not null THEN b.Host collate Latin1_General_CI_AS
												  ELSE a.host
												  END
			,URL					       = CASE WHEN b.URL is not null THEN b.URL collate Latin1_General_CI_AS
												  ELSE a.URL
												  END
			,APN					       = CASE WHEN b.APN is not null THEN b.APN collate Latin1_General_CI_AS
												  ELSE a.APN
												  END
			,IP_Service_Access_Result      = CASE WHEN b.IpServiceAccessStatus is not null THEN b.IpServiceAccessStatus collate Latin1_General_CI_AS
												  ELSE a.IP_Service_Access_Result
												  END
			,IP_Service_Access_Delay_ms    = CASE WHEN b.IpServiceAccessTime_ms is not null THEN b.IpServiceAccessTime_ms
												  ELSE a.IP_Service_Access_Delay_ms
												  END
			,DNS_Delay_ms                  = CASE WHEN b.DNS_Delay_Access_ms is not null THEN b.DNS_Delay_Access_ms
												  ELSE a.DNS_Delay_ms
												  END
			,DNS_1st_Request               = CASE WHEN b.Test_First_DNS_Request is not null THEN b.Test_First_DNS_Request
												  ELSE a.DNS_1st_Request
												  END
			,DNS_1st_Response              = CASE WHEN b.Test_First_DNS_Response is not null THEN b.Test_First_DNS_Response
												  ELSE a.DNS_1st_Response
												  END
			,RTT_Delay_ms                  = CASE WHEN b.Round_Trip_Time_ms is not null THEN b.Round_Trip_Time_ms
												  ELSE a.RTT_Delay_ms
												  END
			,TCP_1st_SYN                    = CASE WHEN b.Test_First_TCP_Syn_UL is not null THEN b.Test_First_TCP_Syn_UL
												  ELSE a.TCP_1st_SYN
												  END
			,TCP_1st_SYN_ACK                 = CASE WHEN b.Test_First_TCP_SynAck_UL is not null THEN b.Test_First_TCP_SynAck_UL
												  ELSE a.TCP_1st_SYN_ACK
												  END
			,Data_1st_recieved                 = CASE WHEN b.Test_First_Data_Packet is not null THEN b.Test_First_Data_Packet
												  ELSE a.Data_1st_recieved
												  END
			,Data_Last_Recieved                = CASE WHEN b.Test_Last_Data_Packet is not null THEN b.Test_Last_Data_Packet
												  ELSE a.Data_Last_Recieved
												  END
			,[Application_Layer_MDR_kbit_s]			 = CASE WHEN b.Throughput_kbit_s is not null THEN CAST(b.Throughput_kbit_s as decimal(10,2))
															ELSE a.Application_Layer_MDR_kbit_s
															END
			,Content_Transfered_Size_Bytes			= CASE WHEN b.size is not null THEN b.size
															ELSE a.Content_Transfered_Size_Bytes
															END
			,Page_Images_Count						= CASE WHEN b.numOfImages is not null THEN b.numOfImages
															ELSE a.Page_Images_Count
															END
			,AndroidApp								= CASE WHEN b.browser is not null THEN b.browser collate Latin1_General_CI_AS
															ELSE a.AndroidApp
															END
			,Content_Transfered_Time_ms				= CASE WHEN b.duration_2017 is not null THEN CAST(b.duration_2017 as bigint)
															ELSE a.Content_Transfered_Time_ms
															END
			,AppProtocol							= CASE WHEN b.url like 'https%' THEN 'HTTPS' 
														   WHEN b.url like 'http%' THEN 'HTTP' 
														   ELSE a.AppProtocol 
														   END
			,ErrorCode_Message						= CASE WHEN b.ErrorCode_Message is not null THEN b.ErrorCode_Message
														   ELSE a.ErrorCode_Message
														   END
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b ON a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with VIDEO STREAM YOUTUBE Test Results...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_VS_Youtube_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET 
			 Test_Status										 = CASE WHEN b.Test_Result is not null THEN b.Test_Result
																		ELSE a.Test_Status
																		END
			,direction											 = CASE WHEN b.Test_Result is not null THEN 'DL' ELSE a.direction END
			,host												 = CASE WHEN b.Host is not null THEN b.Host collate SQL_Latin1_General_CP1_CI_AS
																		ELSE a.host
																		END
			,URL												 = CASE WHEN b.URL is not null THEN b.URL collate SQL_Latin1_General_CP1_CI_AS
																		ELSE a.URL
																		END
			,IP_Service_Access_Result							 = CASE WHEN b.IP_Service_Access_Status is not null THEN b.IP_Service_Access_Status
																		ELSE a.IP_Service_Access_Result
																		END
			,IP_Service_Access_Delay_ms							 = CASE WHEN a.IP_Service_Access_Delay_ms is not null THEN a.IP_Service_Access_Delay_ms
																		ELSE b.IP_Service_Access_Time_s * 1000.0
																		END
			,DNS_Delay_ms										 = CASE WHEN a.DNS_Delay_ms is not null THEN a.DNS_Delay_ms
																		ELSE DATEDIFF(ms,a.DNS_1st_Request,DNS_1st_Response)
																		END
			,AndroidApp											= CASE WHEN b.Test_Player	IS NOT NULL THEN b.Test_Player	 ELSE a.AndroidApp	 END
			,AppProtocol										= CASE WHEN b.Test_Protocol	IS NOT NULL THEN b.Test_Protocol ELSE a.AppProtocol END
			,Video_Stream_Result_Detailed						= b.Test_Result_Detailed
			,Player_1st_Packet									= b.Test_First_Packet_Of_Player_Recieved	
			,Player_End_of_Download								= b.Test_End_Of_Player_Download			
			,Video_Start_Download								= b.Test_Start_Of_Video_Download			
			,Video_Start_Transfer								= b.Test_Start_Of_Video_Transfer			
			,Data_1st_recieved									= CASE WHEN b.Test_Start_Of_Video_Playout is not null THEN b.Test_Start_Of_Video_Playout
																	   ELSE a.Data_1st_recieved
																	   END
			,Data_Last_Recieved									= CASE WHEN b.Test_End_Of_Video_Transfer is not null THEN b.Test_End_Of_Video_Transfer	
																	   ELSE a.Data_Last_Recieved
																	   END
			,[Player_IP_Service_Access_Status]					= b.[Player_IP_Service_Access_Status]					
			,[Player_Download_Status]							= b.[Player_Download_Status]							
			,[Player_Session_Status]							= b.[Player_Session_Status]							
			,[Player_IP_Service_Access_Time_s]					= b.[Player_IP_Service_Access_Time_s]					
			,[Player_Download_Time_s]							= b.[Player_Download_Time_s]							
			,[Player_Session_Time_s]							= b.[Player_Session_Time_s]							
			,[Video_IP_Service_Access_Status]					= b.[Video_IP_Service_Access_Status]					
			,[Video_Reproduction_Start_Status]					= b.[Video_Reproduction_Start_Status]					
			,[Video_Play_Start_Status]							= b.[Video_Play_Start_Status]							
			,[Video_IP_Service_Access_Time_s]					= b.[Video_IP_Service_Access_Time_s]					
			,[Video_Reproduction_Start_Delay_s]					= b.[Video_Reproduction_Start_Delay_s]					
			,[Video_Play_Start_Time_s]							= b.[Video_Play_Start_Time_s]							
			,[Time_To_First_Picture_s]							= b.[Time_To_First_Picture_s]							
			,[Video_Transfer_Status]							= b.[Video_Transfer_Status]							
			,[Video_Transfer_Time_s]							= b.[Video_Transfer_Time_s]							
			,[Video_Playout_Status]								= b.[Video_Playout_Status]								
			,[Video_Expected_Duration_Time_s]					= b.[Video_Expected_Duration_Time_s]					
			,[Video_Playout_Duration_Time_s]					= b.[Video_Playout_Duration_Time_s]					
			,[Video_Playout_Cutoff_Time_s]						= b.[Video_Playout_Cutoff_Time_s]						
			,[Video_Session_Status]								= b.[Video_Session_Status]								
			,[Video_Session_Time_s]								= b.[Video_Session_Time_s]								
			,[qualityIndication]								= CASE WHEN b.[qualityIndication] is not null then 	b.[qualityIndication] else a.[qualityIndication] end						
			,MIN_VMOS											= b.[Test_Minimum_vMOS]								
			,AVG_VMOS											= b.[Test_Average_vMOS]								
			,MAX_VMOS											= b.[Test_Maximum_vMOS]								
			,HorResolution										= b.[Test_Video_Horizontal_Resolution]					
			,VerResolution										= b.[Test_Video_Vertical_Resolution]					
			,FrameRateCalc										= b.[Test_Video_Frame_Rate_Calc]						
			,[Jerkiness]										= CASE WHEN b.[Test_Video_Jerkiness] is not null then b.[Test_Video_Jerkiness] 	ELSE a.Jerkiness END						
			,[Black]											= CASE WHEN b.[Test_Video_Black]	 is not null then b.[Test_Video_Black]		ELSE a.Black END	 				
			,[Video_Freeze_Count]								= b.[Video_Freeze_Count]					
			,Longest_Single_Freezing_Time_s						= b.[Video_Longest_Single_Freezing_Duration_Time_s]	
			,Accumulated_Freezing_Time_s						= b.[Video_Accumulated_Freezing_Duration_Time_s]		
			,[Video_Skips_Count]								= b.[Video_Skips_Count]								
			,[Video_Skips_Duration_Time_s]						= b.[Video_Skips_Duration_Time_s]			
			,[Video_Downloaded_Size_kbit]						= b.[Video_Downloaded_Size_kbit]
			,ErrorCode_Message						= CASE WHEN a.Test_Status like 'Completed' THEN 'OK'
														   WHEN b.Test_Result_Detailed is not null THEN b.Test_Result_Detailed
														   ELSE a.ErrorCode_Message
														   END
		FROM NEW_CDR_DATA_2018 a 
		LEFT OUTER JOIN NEW_RESULTS_VS_Youtube_2018 b ON a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with VIDEO STREAM Test Results...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_VS_ALL_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET 
			 Validity					   = case when b.Validity is not null THEN b.Validity
												  else a.Validity
												  end
			,InvalidReason				   = case when b.InvalidReason is not null THEN b.InvalidReason collate SQL_Latin1_General_CP1_CI_AS
												  else a.InvalidReason
												  end
			,Test_Status				   = CASE WHEN b.Status is not null THEN b.Status collate SQL_Latin1_General_CP1_CI_AS
												  ELSE a.Test_Status
												  END
			,Test_Type				       = CASE WHEN b.Test_Type is not null THEN b.Test_Type collate Latin1_General_CI_AS
												  ELSE a.Test_Type
												  END
			,Test_Name					   = CASE WHEN b.Test_Name is not null THEN b.Test_Name collate Latin1_General_CI_AS
												  ELSE a.Test_Name
												  END
			,Test_Info					   = CASE WHEN b.Test_Info is not null THEN b.Test_Info collate Latin1_General_CI_AS
												  ELSE a.Test_Info
												  END
			,direction					   = CASE WHEN b.direction is not null THEN b.direction collate Latin1_General_CI_AS
												  ELSE a.direction
												  END
			,URL					       = CASE WHEN b.URL is not null THEN b.URL collate Latin1_General_CI_AS
												  ELSE a.URL
												  END
			,host					       = CASE WHEN b.URL is not null THEN b.URL collate Latin1_General_CI_AS
												  ELSE a.URL
												  END
			,IP_Service_Access_Result      = CASE WHEN b.IpServiceAccessStatus is not null THEN b.IpServiceAccessStatus collate Latin1_General_CI_AS
												  ELSE a.IP_Service_Access_Result
												  END
			,IP_Service_Access_Delay_ms    = CASE WHEN b.IpServiceAccessTime is not null THEN b.IpServiceAccessTime
												  ELSE a.IP_Service_Access_Delay_ms
												  END	
			,Content_Transfered_Size_Bytes	= (CASE WHEN b.VideoSizeBytes				IS NOT NULL THEN b.VideoSizeBytes				ELSE a.Content_Transfered_Size_Bytes	END)		
			,Data_1st_recieved				= (CASE WHEN b.StreamStartTime				IS NOT NULL THEN b.StreamStartTime				ELSE a.Data_1st_recieved				END)
			,Data_Last_Recieved				= (CASE WHEN b.StreamEndTime				IS NOT NULL THEN b.StreamEndTime				ELSE a.Data_Last_Recieved				END)	
			,TimeToFirstPicture_ms			= (CASE WHEN b.TimeToFirstPicture			IS NOT NULL THEN b.TimeToFirstPicture			ELSE a.TimeToFirstPicture_ms			END)		
			,StreamedVideoTime				= (CASE WHEN b.StreamedVideoTime			IS NOT NULL THEN b.StreamedVideoTime			ELSE a.StreamedVideoTime				END)	
			,StreamedVideoTotalTime			= (CASE WHEN b.StreamedVideoTotalTime		IS NOT NULL THEN b.StreamedVideoTotalTime		ELSE a.StreamedVideoTotalTime			END)		
			,Resolution_Timeline			= (CASE WHEN b.Resolution_Timeline			IS NOT NULL THEN b.Resolution_Timeline			ELSE a.Resolution_Timeline				END)  collate Latin1_General_CI_AS
			,HorResolution					= (CASE WHEN b.HorResolution				IS NOT NULL THEN b.HorResolution				ELSE a.HorResolution					END)	
			,VerResolution					= (CASE WHEN b.VerResolution				IS NOT NULL THEN b.VerResolution				ELSE a.VerResolution					END)	
			,ApplicationResolutionOptions	= (CASE WHEN b.ApplicationResolutionOptions	IS NOT NULL THEN b.ApplicationResolutionOptions collate SQL_Latin1_General_CP1_CI_AS	ELSE a.ApplicationResolutionOptions		END)  
			,ImageSizeInPixels				= (CASE WHEN b.ImageSizeInPixels			IS NOT NULL THEN b.ImageSizeInPixels collate Latin1_General_CI_AS			ELSE a.ImageSizeInPixels				END)  	
			,FrameRateCalc					= (CASE WHEN b.FrameRateCalc				IS NOT NULL THEN b.FrameRateCalc				ELSE a.FrameRateCalc					END)
			,Black							= (CASE WHEN b.Black						IS NOT NULL THEN b.Black						ELSE a.Black							END)
			,Freezing_Proportion			= (CASE WHEN b.Freezing						IS NOT NULL THEN b.Freezing						ELSE a.Freezing_Proportion				END)
			,Jerkiness						= (CASE WHEN b.Jerkiness					IS NOT NULL THEN b.Jerkiness					ELSE a.Jerkiness						END)
			,MIN_VMOS						= (CASE WHEN b.MIN_VMOS						IS NOT NULL THEN b.MIN_VMOS						ELSE a.MIN_VMOS							END)
			,AVG_VMOS						= (CASE WHEN b.AVG_VMOS						IS NOT NULL THEN b.AVG_VMOS						ELSE a.AVG_VMOS							END)
			,MAX_VMOS						= (CASE WHEN b.MAX_VMOS						IS NOT NULL THEN b.MAX_VMOS						ELSE a.MAX_VMOS							END)
		FROM NEW_CDR_DATA_2018 a 																																				
		LEFT OUTER JOIN NEW_RESULTS_VS_ALL_2018 b ON a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with RAN extracted information...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RAN_TEST_2019') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET HomeOperator = b.HomeOperator
		   ,HomeMCC		 = b.HomeMCC
		   ,HomeMNC		 = b.HomeMNC
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_Operator b on a.SessionId = b.SessionId

		UPDATE NEW_CDR_DATA_2018
		SET
			 MCC                                  = b.MCC                                  
			,MNC                                  = b.MNC                                  
			,CellID                               = b.CID                               
			,LAC                                  = b.LAC                                  
			,BCCH                                 = b.BCCH                                 
			,SC1                                  = b.SC1                                  
			,SC2                                  = b.SC2                                  
			,SC3                                  = b.SC3                                  
			,SC4                                  = b.SC4                                  
			,CGI                                  = b.CGI                                  
			,BSIC                                 = b.BSIC                                 
			,PCI                                  = b.PCI                                  
			,LAC_CId_BCCH                         = b.LAC_CId_BCCH    
			,VDF_CELL_NAME						  = b.VDF_CELL                     
			,AvgTA2G                              = b.AvgTA2G                              
			,MaxTA2G                              = b.MaxTA2G                              
			,CQI_HSDPA_Min                        = b.CQI_HSDPA_Min                        
			,CQI_HSDPA                            = b.CQI_HSDPA                            
			,CQI_HSDPA_Max                        = b.CQI_HSDPA_Max                        
			,CQI_HSDPA_StDev                      = b.CQI_HSDPA_StDev                      
			,ACK3G                                = b.ACK3G                                
			,NACK3G                               = b.NACK3G                               
			,ACKNACK3G_Total                      = b.ACKNACK3G_Total                      
			,BLER3G                               = b.BLER3G                               
			,BLER3GSamples                        = b.BLER3GSamples                        
			,StDevBLER3G                          = b.StDevBLER3G                          
			,CQI_LTE_Min                          = b.CQI_LTE_Min                          
			,CQI0                                 = b.CQI_LTE_Avg                                 
			,CQI_LTE                              = b.CQI_LTE_Avg                              
			,CQI_LTE_Max                          = b.CQI_LTE_Max                          
			,CQI_LTE_StDev                        = b.CQI_LTE_StDev                        
			,ACK4G                                = b.ACK4G                                
			,NACK4G                               = b.NACK4G                               
			,ACKNACK4G_Total                      = b.ACKNACK4G_Total                      
			,AvgDLTA4G                            = b.AvgDLTA4G                            
			,MaxDLTA4G                            = b.MaxDLTA4G                            
			,LTE_DL_MinDLNumCarriers              = b.LTE_DL_MinDLNumCarriers              
			,LTE_DL_AvgDLNumCarriers              = b.LTE_DL_AvgDLNumCarriers              
			,LTE_DL_MaxDLNumCarriers              = b.LTE_DL_MaxDLNumCarriers              
			,LTE_DL_MinRB                         = b.LTE_DL_MinRB                         
			,LTE_DL_AvgRB                         = b.LTE_DL_AvgRB                         
			,LTE_DL_MaxRB                         = b.LTE_DL_MaxRB                         
			,LTE_DL_MinMCS                        = b.LTE_DL_MinMCS                        
			,LTE_DL_AvgMCS                        = b.LTE_DL_AvgMCS                        
			,LTE_DL_MaxMCS                        = b.LTE_DL_MaxMCS                        
			,LTE_DL_CountNumQPSK                  = b.LTE_DL_CountNumQPSK                  
			,LTE_DL_CountNum16QAM                 = b.LTE_DL_CountNum16QAM                 
			,LTE_DL_CountNum64QAM                 = b.LTE_DL_CountNum64QAM                 
			,LTE_DL_CountNum256QAM                = b.LTE_DL_CountNum256QAM                
			,LTE_DL_CountModulation               = b.LTE_DL_CountModulation               
			,LTE_DL_MinScheduledPDSCHThroughput   = b.LTE_DL_MinScheduledPDSCHThroughput   
			,LTE_DL_AvgScheduledPDSCHThroughput   = b.LTE_DL_AvgScheduledPDSCHThroughput   
			,LTE_DL_MaxScheduledPDSCHThroughput   = b.LTE_DL_MaxScheduledPDSCHThroughput   
			,LTE_DL_MinNetPDSCHThroughput         = b.LTE_DL_MinNetPDSCHThroughput         
			,LTE_DL_AvgNetPDSCHThroughput         = b.LTE_DL_AvgNetPDSCHThroughput         
			,LTE_DL_MaxNetPDSCHThroughput         = b.LTE_DL_MaxNetPDSCHThroughput         
			,LTE_DL_PDSCHBytesTransfered          = b.LTE_DL_PDSCHBytesTransfered          
			,LTE_DL_MinBLER                       = b.LTE_DL_MinBLER                       
			,LTE_DL_AvgBLER                       = b.LTE_DL_AvgBLER                       
			,LTE_DL_MaxBLER                       = b.LTE_DL_MaxBLER                       
			,LTE_DL_MinTBSize                     = b.LTE_DL_MinTBSize                     
			,LTE_DL_AvgTBSize                     = b.LTE_DL_AvgTBSize                     
			,LTE_DL_MaxTBSize                     = b.LTE_DL_MaxTBSize                     
			,LTE_DL_MinTBRate                     = b.LTE_DL_MinTBRate                     
			,LTE_DL_AvgTBRate                     = b.LTE_DL_AvgTBRate                     
			,LTE_DL_MaxTBRate                     = b.LTE_DL_MaxTBRate                     
			,LTE_DL_TransmissionMode              = b.LTE_DL_TransmissionMode              
			,LTE_UL_MinULNumCarriers              = b.LTE_UL_MinULNumCarriers              
			,LTE_UL_AvgULNumCarriers              = b.LTE_UL_AvgULNumCarriers              
			,LTE_UL_MaxULNumCarriers              = b.LTE_UL_MaxULNumCarriers              
			,LTE_UL_CountNumBPSK                  = b.LTE_UL_CountNumBPSK                  
			,LTE_UL_CountNumQPSK                  = b.LTE_UL_CountNumQPSK                  
			,LTE_UL_CountNum16QAM                 = b.LTE_UL_CountNum16QAM                 
			,LTE_UL_CountNum64QAM                 = b.LTE_UL_CountNum64QAM                 
			,LTE_UL_CountModulation               = b.LTE_UL_CountModulation               
			,LTE_UL_MinScheduledPUSCHThroughput   = b.LTE_UL_MinScheduledPUSCHThroughput   
			,LTE_UL_AvgScheduledPUSCHThroughput   = b.LTE_UL_AvgScheduledPUSCHThroughput   
			,LTE_UL_MaxScheduledPUSCHThroughput   = b.LTE_UL_MaxScheduledPUSCHThroughput   
			,LTE_UL_MinNetPUSCHThroughput         = b.LTE_UL_MinNetPUSCHThroughput         
			,LTE_UL_AvgNetPUSCHThroughput         = b.LTE_UL_AvgNetPUSCHThroughput         
			,LTE_UL_MaxNetPUSCHThroughput         = b.LTE_UL_MaxNetPUSCHThroughput         
			,LTE_UL_PUSCHBytesTransfered          = b.LTE_UL_PUSCHBytesTransfered          
			,LTE_UL_MinTBSize                     = b.LTE_UL_MinTBSize                     
			,LTE_UL_AvgTBSize                     = b.LTE_UL_AvgTBSize                     
			,LTE_UL_MaxTBSize                     = b.LTE_UL_MaxTBSize                     
			,LTE_UL_MinTBRate                     = b.LTE_UL_MinTBRate                     
			,LTE_UL_AvgTBRate                     = b.LTE_UL_AvgTBRate                     
			,LTE_UL_MaxTBRate                     = b.LTE_UL_MaxTBRate                     
			,CA_PCI                               = b.CA_PCI                               
			,HandoversInfo                        = b.HandoversInfo  
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RAN_TEST_2019 b on a.SessionId = b.SessionId and a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with RF extracted information...')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RF_Test_2018') 
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET MinRxLev      = b.MinRxLev
		   ,AvgRxLev      = b.AvgRxLev
		   ,MaxRxLev      = b.MaxRxLev
		   ,StDevRxLev    = b.StDevRxLev
		   ,MinRxQual     = b.MinRxQual
		   ,AvgRxQual     = b.AvgRxQual
		   ,MaxRxQual     = b.MaxRxQual
		   ,StDevRxQual   = b.StDevRxQual
		   ,MinRSCP       = b.MinRSCP
		   ,AvgRSCP       = b.AvgRSCP
		   ,MaxRSCP       = b.MaxRSCP
		   ,StDevRSCP     = b.StDevRSCP
		   ,MinEcIo       = b.MinEcIo
		   ,AvgEcIo       = b.AvgEcIo
		   ,MaxEcIo       = b.MaxEcIo
		   ,StDevEcIo     = b.StDevEcIo
		   ,MinTxPwr3G    = b.MinTxPwr3G
		   ,AvgTxPwr3G    = b.AvgTxPwr3G
		   ,MaxTxPwr3G    = b.MaxTxPwr3G
		   ,StDevTxPwr3G  = b.StDevTxPwr3G
		   ,MinRSRP       = b.MinRSRP
		   ,AvgRSRP       = b.AvgRSRP
		   ,MaxRSRP       = b.MaxRSRP
		   ,StDevRSRP     = b.StDevRSRP
		   ,MinRSRQ       = b.MinRSRQ
		   ,AvgRSRQ       = b.AvgRSRQ
		   ,MaxRSRQ       = b.MaxRSRQ
		   ,StDevRSRQ     = b.StDevRSRQ
		   ,MinSINR       = b.MinSINR
		   ,AvgSINR       = b.AvgSINR
		   ,MaxSINR       = b.MaxSINR
		   ,StDevSINR     = b.StDevSINR
		   ,MinSINR0      = b.MinSINR0
		   ,AvgSINR0      = b.AvgSINR0
		   ,MaxSINR0      = b.MaxSINR0
		   ,StDevSINR0    = b.StDevSINR0
		   ,MinSINR1      = b.MinSINR1
		   ,AvgSINR1      = b.AvgSINR1
		   ,MaxSINR1      = b.MaxSINR1
		   ,StDevSINR1    = b.StDevSINR1
		   ,MinTxPwr4G    = b.MinTxPwr4G
		   ,AvgTxPwr4G    = b.AvgTxPwr4G
		   ,MaxTxPwr4G    = b.MaxTxPwr4G
		   ,StDevTxPwr4G  = b.StDevTxPwr4G
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN NEW_RF_Test_2018 b on a.SessionId = b.SessionId and a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with Technology extracted information...')
	UPDATE NEW_CDR_DATA_2018
	SET
			RAT                 = b.RAT                
		,TIME_GSM_900_s      = b.TIME_GSM_900_s     
		,TIME_GSM_1800_s     = b.TIME_GSM_1800_s    
		,TIME_GSM_1900_s     = b.TIME_GSM_1900_s    
		,TIME_UMTS_850_s     = b.TIME_UMTS_850_s    
		,TIME_UMTS_900_s     = b.TIME_UMTS_900_s    
		,TIME_UMTS_1700_s    = b.TIME_UMTS_1700_s   
		,TIME_UMTS_1900_s    = b.TIME_UMTS_1900_s   
		,TIME_UMTS_2100_s    = b.TIME_UMTS_2100_s   
		,TIME_LTE_700_s      = b.TIME_LTE_700_s     
		,TIME_LTE_800_s      = b.TIME_LTE_800_s     
		,TIME_LTE_900_s      = b.TIME_LTE_900_s     
		,TIME_LTE_1700_s     = b.TIME_LTE_1700_s    
		,TIME_LTE_1800_s     = b.TIME_LTE_1800_s    
		,TIME_LTE_1900_s     = b.TIME_LTE_1900_s    
		,TIME_LTE_2100_s     = b.TIME_LTE_2100_s    
		,TIME_LTE_2600_s     = b.TIME_LTE_2600_s    
		,TIME_LTE_TDD_2300_s = b.TIME_LTE_TDD_2300_s
		,TIME_LTE_TDD_2500_s = b.TIME_LTE_TDD_2500_s
		,TIME_No_Service_s   = b.TIME_No_Service_s  
		,TIME_Unknown_s      = b.TIME_Unknown_s     
		,Test_RAT_Duration_s = b.Test_RAT_Duration_s
		,RAT_Timeline        = b.RAT_Timeline       
		,GPRS_s              = b.GPRS_s             
		,EDGE_s              = b.EDGE_s             
		,UMTS_R99_s          = b.UMTS_R99_s         
		,HSDPA_s             = b.HSDPA_s            
		,HSUPA_s             = b.HSUPA_s            
		,HSDPA_Plus_s        = b.HSDPA_Plus_s       
		,HSPA_s              = b.HSPA_s             
		,HSPA_Plus_s         = b.HSPA_Plus_s        
		,HSPA_DC_s           = b.HSPA_DC_s          
		,LTE_s               = b.LTE_s              
		,LTE_CA_s            = b.LTE_CA_s           
		,Wifi_s              = b.Wifi_s             
		,Unknown_s           = b.Unknown_s          
		,Test_TEC_Duration_s = b.Test_TEC_Duration_s
		,TEC_Timeline        = b.TEC_Timeline 
	FROM NEW_CDR_DATA_2018 a
	LEFT OUTER JOIN NEW_TECH_Test_2018 b on --a.SessionId = b.SessionId and 
	a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with APN extracted information...')
	UPDATE NEW_CDR_DATA_2018
	SET   APN	   = CASE WHEN b.APN is not null THEN b.APN collate SQL_Latin1_General_CP1_CI_AS ELSE a.APN END,
		  APN_Name = b.Name collate SQL_Latin1_General_CP1_CI_AS
	FROM NEW_CDR_DATA_2018 a
	LEFT OUTER JOIN AccessPoints b on a.SessionId = b.SessionId and a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with MDR information...')
	IF OBJECT_ID ('tempdb..#httptransferthroughput' ) IS NOT NULL DROP TABLE #httptransferthroughput
	SELECT SessionId,TestId,
		  CASE WHEN qualityIndication like '%Throughput%' THEN SUBSTRING(qualityIndication,CHARINDEX('Throughput',qualityIndication),LEN(qualityIndication))
								 WHEN qualityIndication like '%Error%' THEN null
								 ELSE qualityIndication
								 END AS qualityIndication
	INTO #httptransferthroughput
	FROM NEW_CDR_DATA_2018
	WHERE Test_Type like 'httpTransfer' or qualityIndication like '%Throughput%'
	UPDATE #httptransferthroughput
	SET qualityIndication = CASE WHEN qualityIndication like '%=%' THEN SUBSTRING(qualityIndication,CHARINDEX('=',qualityIndication)+1,LEN(qualityIndication))
								 ELSE null
								 END
	UPDATE #httptransferthroughput
	SET qualityIndication = REPLACE(qualityIndication,'kbit/s','')

	UPDATE NEW_CDR_DATA_2018
		SET Application_Layer_MDR_kbit_s = CASE WHEN a.Application_Layer_MDR_kbit_s is null then CAST(b.qualityIndication AS decimal(10,2)) ELSE a.Application_Layer_MDR_kbit_s END
	FROM NEW_CDR_DATA_2018 a
	LEFT OUTER JOIN #httptransferthroughput b ON a.SessionId =b.SessionId and a.TestId = b.TestId

	UPDATE NEW_CDR_DATA_2018
		SET Data_1st_recieved = dateadd(ms,IP_Service_Access_Delay_ms,Test_Start_Time)
	WHERE IP_Service_Access_Delay_ms is not null and Data_1st_recieved is null and Test_Status not like 'Failed'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with LTE Carrier Aggregation information...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'KB_CAAnalysis' AND type = 'U')
	BEGIN
		UPDATE NEW_CDR_DATA_2018
		SET
			   CA_STARTTIME               = b.STARTTIME           
			  ,CA_duration                = b.duration            
			  ,CA_PosId                   = b.PosId               
			  ,CA_PDSCHThroughput         = b.PDSCHThroughput     
			  ,CA_PUSCHThroughput         = b.PUSCHThroughput     
			  ,CA_AvgNRBDL                = b.AvgNRBDL            
			  ,CA_AvgNRBUL                = b.AvgNRBUL            
			  ,CA_PCellAvgCQI             = b.PCellAvgCQI         
			  ,CA_PCellPDSCHThroughput    = b.PCellPDSCHThroughput
			  ,CA_PCellTransferredDL      = b.PCellTransferredDL  
			  ,CA_PCellTBRateDL           = b.PCellTBRateDL       
			  ,CA_PCellRank2Ratio         = b.PCellRank2Ratio     
			  ,CA_PCellAvgMCSDL           = b.PCellAvgMCSDL       
			  ,CA_PCellAvgNRBDL           = b.PCellAvgNRBDL       
			  ,CA_PCellTBRateUL           = b.PCellTBRateUL       
			  ,CA_PCellAvgMCSUL           = b.PCellAvgMCSUL       
			  ,CA_PCellAvgNRBUL           = b.PCellAvgNRBUL       
			  ,CA_SCellAvgCQI             = b.SCellAvgCQI         
			  ,CA_SCellPDSCHThroughput    = b.SCellPDSCHThroughput
			  ,CA_SCellTransferredDL      = b.SCellTransferredDL  
			  ,CA_SCellTBRateDL           = b.SCellTBRateDL       
			  ,CA_SCellRank2Ratio         = b.SCellRank2Ratio     
			  ,CA_SCellAvgMCSDL           = b.SCellAvgMCSDL       
			  ,CA_SCellAvgNRBDL           = b.SCellAvgNRBDL       
			  ,CA_SCellAvgNRBDL2          = b.SCellAvgNRBDL2      
			  ,CA_PCellDLEARFCN           = b.PCellDLEARFCN       
			  ,CA_PCellDLBW               = b.PCellDLBW           
			  ,CA_PCellRSRP               = b.PCellRSRP           
			  ,CA_PCellRSRQ               = b.PCellRSRQ           
			  ,CA_PCellSINR               = b.PCellSINR           
			  ,CA_SCell1DLEARFCN          = b.SCell1DLEARFCN      
			  ,CA_SCell1DLBW              = b.SCell1DLBW          
			  ,CA_SCell1RSRP              = b.SCell1RSRP          
			  ,CA_SCell1RSRQ              = b.SCell1RSRQ          
			  ,CA_SCell1SINR              = b.SCell1SINR          
			  ,CA_SCell2DLEARFCN          = b.SCell2DLEARFCN      
			  ,CA_SCell2DLBW              = b.SCell2DLBW          
			  ,CA_SCell2RSRP              = b.SCell2RSRP          
			  ,CA_SCell2RSRQ              = b.SCell2RSRQ          
			  ,CA_SCell2SINR              = b.SCell2SINR          
			  ,CA_UNUSUAL                 = b.UNUSUAL  
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN KB_CAAnalysis b on a.Sessionid = b.SessionId and a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with PCAP File information...')
		IF OBJECT_ID ('tempdb..#pcap' ) IS NOT NULL DROP TABLE #pcap
		SELECT
			 SessionID
			,CASE WHEN MAX(CASE WHEN RNK = 2 THEN FILENAME ELSE NULL END) IS NULL THEN MAX(CASE WHEN RNK = 1 THEN FILENAME ELSE NULL END)
				  ELSE MAX(CASE WHEN RNK = 1 THEN FILENAME ELSE NULL END) + ' / ' + MAX(CASE WHEN RNK = 2 THEN FILENAME ELSE NULL END)
				  END AS pcap_filename
		INTO #pcap
		FROM
			(SELECT 
			RANK () OVER (PARTITION BY SessionID ORDER BY Filename) AS RNK,
			SessionID,
			FileName
			FROM PCAPData) as a
		GROUP BY SessionID
		ORDER BY SessionID
		
		UPDATE NEW_CDR_DATA_2018
		SET PCAP_File_Name = b.pcap_filename
		FROM NEW_CDR_DATA_2018 a
		LEFT OUTER JOIN #pcap b on a.Sessionid = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 consistency cleanup...')
		UPDATE NEW_CDR_DATA_2018
		SET  [Application_Layer_MDR_kbit_s] = null
			,MIN_VMOS = null
			,AVG_VMOS = null
			,MAX_VMOS = null
		where test_status <> 'Completed'

		UPDATE NEW_CDR_DATA_2018
		SET
		  IP_Service_Access_Delay_ms	= CASE WHEN  IP_Service_Access_Delay_ms  < 0				THEN null 
											   WHEN  IP_Service_Access_Delay_ms  < DNS_Delay_ms		THEN null 
											   WHEN  IP_Service_Access_Delay_ms  < RTT_Delay_ms		THEN null 
											   ELSE  IP_Service_Access_Delay_ms 
											   END
		 ,DNS_Delay_ms					= CASE WHEN  DNS_Delay_ms				 < 3  THEN null ELSE  DNS_Delay_ms				 END
		 ,RTT_Delay_ms					= CASE WHEN  RTT_Delay_ms				 < 3  THEN null ELSE  RTT_Delay_ms				 END
		 ,DNS_1st_Request				= CASE WHEN DNS_1st_Request < Test_Start_Time THEN null 
												ELSE  DNS_1st_Request			 
												END
		 ,DNS_1st_Response				= CASE  WHEN DNS_1st_Response < Test_Start_Time				THEN null 
												WHEN DNS_1st_Request  < Test_Start_Time				THEN null 
												WHEN DNS_1st_Response  > TCP_1st_SYN				THEN null 
												ELSE DNS_1st_Response
												END
		 ,TCP_1st_SYN					= CASE  WHEN TCP_1st_SYN < Test_Start_Time					THEN null 
												ELSE TCP_1st_SYN
												END
		 ,TCP_1st_SYN_ACK				= CASE  WHEN TCP_1st_SYN_ACK < Test_Start_Time				THEN null 
												WHEN TCP_1st_SYN_ACK < TCP_1st_SYN					THEN null 
												ELSE TCP_1st_SYN_ACK
												END
		 ,Player_1st_Packet				= CASE  WHEN Player_1st_Packet < Test_Start_Time			THEN null 
												WHEN Player_1st_Packet < TCP_1st_SYN				THEN null
												WHEN Player_1st_Packet < TCP_1st_SYN_ACK			THEN null
												ELSE Player_1st_Packet
												END
		 ,Player_End_of_Download		= CASE  WHEN Player_End_of_Download < Test_Start_Time		THEN null 
												WHEN Player_End_of_Download < TCP_1st_SYN			THEN null
												WHEN Player_End_of_Download < TCP_1st_SYN_ACK		THEN null
												WHEN Player_End_of_Download < Player_1st_Packet		THEN null
												ELSE Player_End_of_Download
												END 
		 ,Video_Start_Download			= CASE  WHEN Video_Start_Download < Test_Start_Time			THEN null 
												WHEN Video_Start_Download < TCP_1st_SYN				THEN null
												WHEN Video_Start_Download < TCP_1st_SYN_ACK			THEN null
												WHEN Video_Start_Download < Player_1st_Packet		THEN null
												WHEN Video_Start_Download < Player_End_of_Download	THEN null
												ELSE Video_Start_Download
												END 
		 ,Video_Start_Transfer			= CASE  WHEN Video_Start_Transfer < Test_Start_Time			THEN null 
												WHEN Video_Start_Transfer < TCP_1st_SYN				THEN null
												WHEN Video_Start_Transfer < TCP_1st_SYN_ACK			THEN null
												WHEN Video_Start_Transfer < Player_1st_Packet		THEN null
												WHEN Video_Start_Transfer < Player_End_of_Download	THEN null
												WHEN Video_Start_Transfer < Video_Start_Download	THEN null
												ELSE Video_Start_Transfer
												END 
		 ,Data_1st_recieved				= CASE  WHEN Data_1st_recieved < Test_Start_Time			THEN null 
												WHEN Data_1st_recieved < TCP_1st_SYN				THEN null
												WHEN Data_1st_recieved < TCP_1st_SYN_ACK			THEN null
												WHEN Data_1st_recieved < Player_1st_Packet			THEN null
												WHEN Data_1st_recieved < Player_End_of_Download		THEN null
												WHEN Data_1st_recieved < Video_Start_Download		THEN null
												WHEN Data_1st_recieved < Video_Start_Transfer		THEN null
												ELSE Data_1st_recieved
												END 
		 ,Data_Last_Recieved			= CASE  WHEN Data_Last_Recieved < Test_Start_Time			THEN null 
												WHEN Data_Last_Recieved < TCP_1st_SYN				THEN null
												WHEN Data_Last_Recieved < TCP_1st_SYN_ACK			THEN null
												WHEN Data_Last_Recieved < Player_1st_Packet			THEN null
												WHEN Data_Last_Recieved < Player_End_of_Download	THEN null
												WHEN Data_Last_Recieved < Video_Start_Download		THEN null
												WHEN Data_Last_Recieved < Video_Start_Transfer		THEN null
												WHEN Data_Last_Recieved < Data_Last_Recieved		THEN null
												ELSE Data_Last_Recieved
												END 
-- REPAIR NEGATIVE IP THROUGHPUT
update NEW_CDR_DATA_2018
SET IP_Layer_Transferred_Bytes_DL = 5132890
where  Validity = 1 and Test_Name like 'FDFS http DL ST' and Test_Status like 'Completed' and IP_Layer_Transferred_Bytes_DL < 5000000

update NEW_CDR_DATA_2018
SET IP_Layer_Transferred_Bytes_DL = null
where  Validity = 1 and IP_Layer_Transferred_Bytes_DL < 0

update NEW_CDR_DATA_2018
SET IP_Layer_Transferred_Bytes_UL = 2164644
where  Validity = 1 and Test_Name like 'FDFS http DL ST' and Test_Status like 'Completed' and IP_Layer_Transferred_Bytes_UL < 2000000

update NEW_CDR_DATA_2018
SET IP_Layer_Transferred_Bytes_UL = null
where  Validity = 1 and IP_Layer_Transferred_Bytes_UL < 0


PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script Execution Completed...')

-- SELECT * FROM NEW_CDR_DATA_2018 WHERE Test_name like 'FDFS%'

-- SELECT * FROM NEW_CDR_DATA_2018 WHERE Validity <> 0 order by TestId
