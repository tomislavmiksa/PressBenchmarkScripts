-- DROP OLD VIEWS IF THEY EXISTS
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'vDataCDR2018_Operator1_TDG') DROP view vDataCDR2018_Operator1_TDG
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'vDataCDR2018_Operator2_TDG') DROP view vDataCDR2018_Operator2_TDG
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'vDataCDR2018_Operator3_TDG') DROP view vDataCDR2018_Operator3_TDG
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'vDataCDR2018_Operator4_TDG') DROP view vDataCDR2018_Operator4_TDG
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'vDataCDR2018_Operator5_TDG') DROP view vDataCDR2018_Operator5_TDG

GO
CREATE VIEW [dbo].[vDataCDR2018_Operator1_TDG] 
AS
SELECT [Campaign_A]											AS Campaign
	  ,[HomeOperator]										AS Operator
      ,[Test_Type]											AS Type_of_Test
      ,[Test_Name]											AS Test_Name
      ,[Test_Info]											AS Test_Info
      ,[direction]											AS Direction
	  ,CASE WHEN [Test_Type] like 'httpTransfer' and [Test_Name] like '%MT' THEN 'MT'
			WHEN [Test_Type] like 'httpBrowser'  and TCP_Threads_Count > 1 THEN 'MT'
			WHEN [Test_Type] like 'ICMP Ping' then null
			ELSE 'ST'
			END AS Thread_Info
      ,[URL]
	  ,CASE WHEN [Test_Type] like 'httpBrowser' and Test_Status like 'Completed' THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
		    WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' and Content_Transfered_Size_Bytes is not null THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
			WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' THEN '1 MB'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_01 is not null THEN CAST(PacketSize_01 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_02 is not null THEN CAST(PacketSize_02 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1mb%'   THEN '1 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1mb%'   THEN '1 MB'
			END AS Size
      ,[Test_Status]										AS Test_Result
	  ,ErrorCode_Message
	  ,[Application_Layer_MDR_kbit_s]						AS Mean_Data_Rate_Kbit_s
	  ,CASE WHEN Test_Status like 'Completed' THEN  0.001*Content_Transfered_Time_ms
			ELSE null
			END AS Transfer_Duration_s
      ,[TestId]
	  ,[Sessionid]
      ,[FileId_A]											AS FileID
      ,[Sequenz_ID_per_File_A]								AS Sequenz_ID_per_File
      ,[FileName_A]											AS File_Name
	  ,PCAP_File_Name

	  -- LOCATION INFORMATION
      ,[Channel]
      ,[Channel_Description]
      ,[G_Level_1]
      ,[G_Level_2]
      ,[G_Level_3]
      ,[G_Level_4]
	  ,case when G_Level_5 is null or G_Level_5 like '' then G_Level_5
	        when Remark    is null or Remark like ''    then G_Level_5 
	        else G_Level_5 + ': ' + Remark
	        end as G_Level_5
      ,[Train_Type]
      ,[Train_Name]
      ,[Wagon_Number]
      ,[Repeater_Wagon]     
      ,[startLatitude_A]									AS Test_Start_Latitude
	  ,[startLongitude_A]									AS Test_Start_Longitude
      ,CAST([Distance_A] as decimal(10,2))					AS Test_Distance_m

	  -- EVENTS SECTION
	  ,DATEPART(year,[Test_Start_Time])						AS Year
	  ,DATEPART(quarter,[Test_Start_Time])					AS Quarter
	  ,DATEPART(month,[Test_Start_Time])					AS Month
	  ,DATEPART(week,[Test_Start_Time])						AS Week
	  ,DATEPART(day,[Test_Start_Time])						AS Day
	  ,DATEPART(hour,[Test_Start_Time])						AS Hour
      ,dbo.DelphiDateTime([Test_Start_Time])				AS [Test_Start_Time]
      ,dbo.DelphiDateTime([DNS_1st_Request])				AS [DNS_1st_Request]
      ,dbo.DelphiDateTime([DNS_1st_Response])				AS [DNS_1st_Response]
      ,dbo.DelphiDateTime([TCP_1st_SYN])					AS [TCP_1st_SYN]
      ,dbo.DelphiDateTime([TCP_1st_SYN_ACK])				AS [TCP_1st_SYN_ACK]
      ,dbo.DelphiDateTime([Player_1st_Packet])				AS [Player_1st_Packet]
      ,dbo.DelphiDateTime([Player_End_of_Download])			AS [Player_End_of_Download]
      ,dbo.DelphiDateTime([Video_Start_Download])			AS [Video_Start_Download]
      ,dbo.DelphiDateTime([Video_Start_Transfer])			AS [Video_Start_Transfer]
      ,dbo.DelphiDateTime([Data_1st_recieved])				AS [Data_1st_recieved]
      ,dbo.DelphiDateTime([Data_Last_Recieved])				AS [Data_Last_Recieved]
      ,dbo.DelphiDateTime([Test_End_Time])					AS [Test_End_Time]
      ,CAST(0.001*[Test_Duration_ms] as decimal(10,2))		AS Test_Duration_s

	  -- FAILURE CLASSIFICATION
      ,[FAILURE_PHASE]										AS Failure_Phase
      ,[FAILURE_TECHNOLOGY]									AS Failure_Technology
      ,[FAILURE_CLASS]										AS Failure_Class
      ,[FAILURE_CATEGORY]									AS Failure_Category
      ,[FAILURE_SUBCATEGORY]								AS Failure_SubCategory
      ,[FAILURE_COMMENT]									AS Failure_Comment

	  -- TEST SPECIFIC QoS
	  ,CASE WHEN Test_Type like 'httpTransfer' THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Transfer_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpTransfer' THEN Content_Transfered_Size_Bytes ELSE null END AS http_Transfer_Transferred_Bytes
	  ,CASE WHEN Test_Type like 'httpBrowser'  THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Browser_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpBrowser'  THEN Content_Transfered_Size_Bytes ELSE null END AS http_Browser_Transferred_Bytes
      ,[Page_Images_Count]									AS http_Browser_Number_of_Images
      ,[MIN_VMOS]											AS VideoStream_VQ_Min
      ,[AVG_VMOS]											AS VideoStream_VQ_Mean
      ,[MAX_VMOS]											AS VideoStream_VQ_Max
      ,CAST([HorResolution] as varchar(10)) + 'x' + CAST([VerResolution] as varchar(10))			AS VideoStream_Video_Resolution
      ,[Resolution_Timeline]								AS VideoStream_Video_Resolution_Timeline
      ,[Video_Freeze_Count]									AS VideoStream_Number_of_Freezings
      ,[Accumulated_Freezing_Time_s]						AS VideoStream_Freezing_Time_Sum_s
      ,[Longest_Single_Freezing_Time_s]						AS VideoStream_Freezing_Time_Max_s
      ,[Black]												AS VideoStream_Black_Frames_Ratio
      ,[Jerkiness]											AS VideoStream_Jerkiness_Ratio
      ,[Video_Skips_Count]									AS VideoStream_Number_of_Skips
      ,[Video_Skips_Duration_Time_s]						AS VideoStream_Skipped_Time_Sum_s
	  ,[Time_To_First_Picture_s]							AS VideoStream_Time_to_First_Picture_s
      ,[Player_IP_Service_Access_Time_s]					AS VideoStream_Player_IP_Service_Access_Time_s
      ,[Player_Download_Time_s]								AS VideoStream_Player_Download_Time_s
      ,[Player_Session_Time_s]								AS VideoStream_Player_Session_Time_s
      ,[Test_Video_Stream_Duration_s]						AS VideoStream_Test_Video_Stream_Duration_s
      ,[Video_IP_Service_Access_Time_s]						AS VideoStream_Video_IP_Service_Access_Time_s
      ,[Video_Reproduction_Start_Delay_s]					AS VideoStream_Video_Reproduction_Start_Delay_s
      ,[Video_Play_Start_Time_s]							AS VideoStream_Video_Play_Start_Time_s
      ,[Video_Transfer_Time_s]								AS VideoStream_Video_Transfer_Time_s
      ,[Video_Playout_Duration_Time_s]						AS VideoStream_Video_Playout_Duration_Time_s
      ,[PING_Samples]										AS ICMP_Ping_Attempt
	  ,CASE WHEN [PING_Failure_Samples] > 0 THEN [PING_Samples] - [PING_Failure_Samples]
			ELSE [PING_Failure_Samples]
			END AS ICMP_Ping_Success
      ,[RTT_MIN_ms]											AS ICMP_Ping_RTT_Min_ms
      ,[RTT_AVG_ms]											AS ICMP_Ping_RTT_Mean_ms
      ,[RTT_AVG_no_1st_ms]									AS ICMP_Ping_RTT_Mean_no1st_ms
      ,[RTT_MAX_ms]											AS ICMP_Ping_RTT_Max_ms

	  -- TCP/IP Information
	  ,IP_Service_Access_Result
	  ,IP_Service_Access_Delay_ms
	  ,DNS_Delay_ms											AS DNS_Service_Access_Delay_ms
	  ,RTT_Delay_ms											AS TCP_RTT_Service_Access_Delay_ms
	  ,DATEDIFF(ms,TCP_1st_SYN_ACK,Data_1st_recieved)		AS [Data_Download_Delay (SYNACK -> 1stData)]
	  ,APN													AS APN_String
	  ,Client_IPs											AS Source_IP
	  ,DNS_Server_IPs		
	  ,Server_IPs											AS Destination_IP
	  ,TCP_Threads_Count									AS Threads
	  ,TCP_Threads_Per_Server								AS TCP_Threads_Detailed
	  ,DNS_Resolution_Attempts
	  ,DNS_Resolution_Success
	  ,DNS_Resolution_Time_Minimum_ms						AS DNS_Min_Resolution_Time_ms
	  ,DNS_Resolution_Time_Average_ms						AS DNS_Avg_Resolution_Time_ms
	  ,DNS_Resolution_Time_Maximum_ms						AS DNS_Max_Resolution_Time_ms
	  ,DNS_Hosts_List										AS DNS_Hosts_Resolved
	  ,IP_Layer_Transferred_Bytes_DL
	  ,IP_Layer_Transferred_Bytes_UL
	  
	  -- Technology Info
	  ,RAT													AS PCell_RAT
	  ,RAT_Timeline											AS PCell_RAT_Timeline
	  ,TEC_Timeline
	  ,TIME_GSM_900_s										AS TIME_GSM_900_s	
	  ,TIME_GSM_1800_s										AS TIME_GSM_1800_s	
	  ,TIME_GSM_1900_s										AS TIME_GSM_1900_s	
	  ,TIME_UMTS_850_s										AS TIME_UMTS_850_s	
	  ,TIME_UMTS_900_s										AS TIME_UMTS_900_s	
	  ,TIME_UMTS_1700_s										AS TIME_UMTS_1700_s	
	  ,TIME_UMTS_1900_s										AS TIME_UMTS_1900_s	
	  ,TIME_UMTS_2100_s										AS TIME_UMTS_2100_s	
	  ,TIME_LTE_700_s										AS PCell_TIME_LTE_700_s	
	  ,TIME_LTE_800_s										AS PCell_TIME_LTE_800_s	
	  ,TIME_LTE_900_s										AS PCell_TIME_LTE_900_s	
	  ,TIME_LTE_1700_s										AS PCell_TIME_LTE_1700_s	
	  ,TIME_LTE_1800_s										AS PCell_TIME_LTE_1800_s	
	  ,TIME_LTE_2100_s										AS PCell_TIME_LTE_2100_s	
	  ,TIME_LTE_2600_s										AS PCell_TIME_LTE_2600_s	
	  ,TIME_No_Service_s 									AS TIME_No_Service_s

	  ,IMEI_A												AS IMEI
	  ,IMSI_A												AS IMSI
	  ,UE_A													AS Device
	  ,FW_A													AS Firmware
	  ,System_Type_A										AS Measurement_System
	  ,SW_A													AS SW_Version
	  ,HomeOperator											AS Home_Operator
	  ,HomeMCC												AS Home_MCC
	  ,HomeMNC												AS Home_MNC
	  ,MCC
	  ,MNC
	  ,CellID
	  ,LAC
	  ,BCCH
	  ,SC1
	  ,SC2
	  ,SC3
	  ,SC4
	  ,BSIC
	  ,PCI
	  ,LAC_CId_BCCH
	  ,MinRxLev
	  ,AvgRxLev
	  ,MaxRxLev
	  ,MinRxQual
	  ,AvgRxQual
	  ,MaxRxQual
	  ,MinRSCP
	  ,AvgRSCP
	  ,MaxRSCP
	  ,minEcIo
	  ,AvgEcIo
	  ,maxEcIo
	  ,MinTxPwr3G
	  ,AvgTxPwr3G
	  ,MaxTxPwr3G
	  ,CQI_HSDPA_Min
	  ,CQI_HSDPA
	  ,CQI_HSDPA_Max
	  ,BLER3G
	  ,MinRSRP
	  ,AvgRSRP
	  ,MaxRSRP
	  ,MinRSRQ
	  ,AvgRSRQ
	  ,MaxRSRQ
	  ,MinSINR
	  ,AvgSINR
	  ,MaxSINR
	  ,MinTxPwr4G
	  ,AvgTxPwr4G
	  ,MaxTxPwr4G
	  ,CQI_LTE_Min
	  ,CQI_LTE
	  ,CQI_LTE_Max
	  ,CAST(LTE_DL_MinRB as decimal(10,0))													AS MinDLRB
	  ,CAST(LTE_DL_AvgRB as decimal(10,0))													AS AvgDLRB
	  ,CAST(LTE_DL_MaxRB as decimal(10,0))													AS MaxDLRB
	  ,CAST(LTE_DL_AvgMCS as decimal(10,1))													AS AvgDLMCS
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNumQPSK]   / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDLQPSK
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum16QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL16QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum64QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL64QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL256QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 and CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) >= 0.1 THEN 'True'
	     ELSE 'False'
	 	END AS DL256QAM_larger_10
	  ,LTE_DL_PDSCHBytesTransfered															AS PDSCHBytesTransfered
	  ,LTE_DL_MinScheduledPDSCHThroughput													AS MinScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_AvgScheduledPDSCHThroughput													AS AvgScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_MaxScheduledPDSCHThroughput													AS MaxScheduledPDSCHThroughput_kbit_s
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumBPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULBPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumQPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULQPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum16QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL16QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL64QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 and CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) >= 0.3 THEN 'True'
		ELSE 'False'
		END AS UL64QAM_larger_30
	  ,LTE_UL_PUSCHBytesTransfered															AS PUSCHBytesTransfered
	  ,LTE_UL_MinScheduledPUSCHThroughput													AS MinScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_AvgScheduledPUSCHThroughput													AS AvgScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_MaxScheduledPUSCHThroughput													AS MaxScheduledPUSCHThroughput_kbit_s
	  ,HandoversInfo
	  ,NULL as Region
	  ,NULL as Vendor
	  ,JOIN_ID
	   ,CASE WHEN Test_Status like 'Completed' and Test_Name like 'YouTube' and 1.0*(isnull(Accumulated_Freezing_Time_s,0) + isnull(Video_Skips_Duration_Time_s,0) + isnull(Black,0) )/Video_Playout_Duration_Time_s > 0.1 THEN 'True'
	        WHEN Test_Status like 'Completed' and Test_Name like 'YouTube' and 1.0*(isnull(Accumulated_Freezing_Time_s,0) + isnull(Video_Skips_Duration_Time_s,0) + isnull(Black,0) )/Video_Playout_Duration_Time_s <= 0.1 THEN null
	        ELSE null END AS Irritating_Video_Playout
  FROM NEW_CDR_DATA_2018_TDG
  WHERE Validity = 1 and HomeOperator like (SELECT Operator FROM NEW_OPERATORS_PRIORITY_2018 WHERE SequenceNumber = 1) --and [Test_Start_Time] < CONVERT(datetime,'June 01 00:00:00 2019')

GO
CREATE VIEW [dbo].[vDataCDR2018_Operator2_TDG] 
AS
SELECT [Campaign_A]											AS Campaign
	  ,[HomeOperator]										AS Operator
      ,[Test_Type]											AS Type_of_Test
      ,[Test_Name]											AS Test_Name
      ,[Test_Info]											AS Test_Info
      ,[direction]											AS Direction
	  ,CASE WHEN [Test_Type] like 'httpTransfer' and [Test_Name] like '%MT' THEN 'MT'
			WHEN [Test_Type] like 'httpBrowser'  and TCP_Threads_Count > 1 THEN 'MT'
			WHEN [Test_Type] like 'ICMP Ping' then null
			ELSE 'ST'
			END AS Thread_Info
      ,[URL]
	  ,CASE WHEN [Test_Type] like 'httpBrowser' and Test_Status like 'Completed' THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
		    WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' and Content_Transfered_Size_Bytes is not null THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
			WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' THEN '1 MB'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_01 is not null THEN CAST(PacketSize_01 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_02 is not null THEN CAST(PacketSize_02 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1mb%'   THEN '1 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1mb%'   THEN '1 MB'
			END AS Size
      ,[Test_Status]										AS Test_Result
	  ,ErrorCode_Message
	  ,[Application_Layer_MDR_kbit_s]						AS Mean_Data_Rate_Kbit_s
	  ,CASE WHEN Test_Status like 'Completed' THEN  0.001*Content_Transfered_Time_ms
			ELSE null
			END AS Transfer_Duration_s
      ,[TestId]
	  ,[Sessionid]
      ,[FileId_A]											AS FileID
      ,[Sequenz_ID_per_File_A]								AS Sequenz_ID_per_File
      ,[FileName_A]											AS File_Name
	  ,PCAP_File_Name

	  -- LOCATION INFORMATION
      ,[Channel]
      ,[Channel_Description]
      ,[G_Level_1]
      ,[G_Level_2]
      ,[G_Level_3]
      ,[G_Level_4]
	  ,case when G_Level_5 is null or G_Level_5 like '' then G_Level_5
	        when Remark    is null or Remark like ''    then G_Level_5 
	        else G_Level_5 + ': ' + Remark
	        end as G_Level_5
      ,[Train_Type]
      ,[Train_Name]
      ,[Wagon_Number]
      ,[Repeater_Wagon]
      ,[startLatitude_A]									AS Test_Start_Latitude
      ,[startLongitude_A]									AS Test_Start_Longitude
      ,CAST([Distance_A] as decimal(10,2))					AS Test_Distance_m

	  -- EVENTS SECTION
	  ,DATEPART(year,[Test_Start_Time])						AS Year
	  ,DATEPART(quarter,[Test_Start_Time])					AS Quarter
	  ,DATEPART(month,[Test_Start_Time])					AS Month
	  ,DATEPART(week,[Test_Start_Time])						AS Week
	  ,DATEPART(day,[Test_Start_Time])						AS Day
	  ,DATEPART(hour,[Test_Start_Time])						AS Hour
      ,dbo.DelphiDateTime([Test_Start_Time])				AS [Test_Start_Time]
      ,dbo.DelphiDateTime([DNS_1st_Request])				AS [DNS_1st_Request]
      ,dbo.DelphiDateTime([DNS_1st_Response])				AS [DNS_1st_Response]
      ,dbo.DelphiDateTime([TCP_1st_SYN])					AS [TCP_1st_SYN]
      ,dbo.DelphiDateTime([TCP_1st_SYN_ACK])				AS [TCP_1st_SYN_ACK]
      ,dbo.DelphiDateTime([Player_1st_Packet])				AS [Player_1st_Packet]
      ,dbo.DelphiDateTime([Player_End_of_Download])			AS [Player_End_of_Download]
      ,dbo.DelphiDateTime([Video_Start_Download])			AS [Video_Start_Download]
      ,dbo.DelphiDateTime([Video_Start_Transfer])			AS [Video_Start_Transfer]
      ,dbo.DelphiDateTime([Data_1st_recieved])				AS [Data_1st_recieved]
      ,dbo.DelphiDateTime([Data_Last_Recieved])				AS [Data_Last_Recieved]
      ,dbo.DelphiDateTime([Test_End_Time])					AS [Test_End_Time]
      ,CAST(0.001*[Test_Duration_ms] as decimal(10,2))		AS Test_Duration_s

	  -- FAILURE CLASSIFICATION
	  ,NULL													AS Failure_Phase
      ,NULL													AS Failure_Technology
      ,NULL													AS Failure_Class
      ,NULL													AS Failure_Category
      ,NULL													AS Failure_SubCategory
      ,NULL													AS Failure_Comment

	  -- TEST SPECIFIC QoS
	  ,CASE WHEN Test_Type like 'httpTransfer' THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Transfer_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpTransfer' THEN Content_Transfered_Size_Bytes ELSE null END AS http_Transfer_Transferred_Bytes
	  ,CASE WHEN Test_Type like 'httpBrowser'  THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Browser_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpBrowser'  THEN Content_Transfered_Size_Bytes ELSE null END AS http_Browser_Transferred_Bytes
      ,[Page_Images_Count]									AS http_Browser_Number_of_Images
      ,[MIN_VMOS]											AS VideoStream_VQ_Min
      ,[AVG_VMOS]											AS VideoStream_VQ_Mean
      ,[MAX_VMOS]											AS VideoStream_VQ_Max
      ,CAST([HorResolution] as varchar(10)) + 'x' + CAST([VerResolution] as varchar(10))			AS VideoStream_Video_Resolution
      ,[Resolution_Timeline]								AS VideoStream_Video_Resolution_Timeline
      ,[Video_Freeze_Count]									AS VideoStream_Number_of_Freezings
      ,[Accumulated_Freezing_Time_s]						AS VideoStream_Freezing_Time_Sum_s
      ,[Longest_Single_Freezing_Time_s]						AS VideoStream_Freezing_Time_Max_s
      ,[Black]												AS VideoStream_Black_Frames_Ratio
      ,[Jerkiness]											AS VideoStream_Jerkiness_Ratio
      ,[Video_Skips_Count]									AS VideoStream_Number_of_Skips
      ,[Video_Skips_Duration_Time_s]						AS VideoStream_Skipped_Time_Sum_s
	  ,[Time_To_First_Picture_s]							AS VideoStream_Time_to_First_Picture_s
      ,[Player_IP_Service_Access_Time_s]					AS VideoStream_Player_IP_Service_Access_Time_s
      ,[Player_Download_Time_s]								AS VideoStream_Player_Download_Time_s
      ,[Player_Session_Time_s]								AS VideoStream_Player_Session_Time_s
      ,[Test_Video_Stream_Duration_s]						AS VideoStream_Test_Video_Stream_Duration_s
      ,[Video_IP_Service_Access_Time_s]						AS VideoStream_Video_IP_Service_Access_Time_s
      ,[Video_Reproduction_Start_Delay_s]					AS VideoStream_Video_Reproduction_Start_Delay_s
      ,[Video_Play_Start_Time_s]							AS VideoStream_Video_Play_Start_Time_s
      ,[Video_Transfer_Time_s]								AS VideoStream_Video_Transfer_Time_s
      ,[Video_Playout_Duration_Time_s]						AS VideoStream_Video_Playout_Duration_Time_s
      ,[PING_Samples]										AS ICMP_Ping_Attempt
	  ,CASE WHEN [PING_Failure_Samples] > 0 THEN [PING_Samples] - [PING_Failure_Samples]
			ELSE [PING_Failure_Samples]
			END AS ICMP_Ping_Success
      ,[RTT_MIN_ms]											AS ICMP_Ping_RTT_Min_ms
      ,[RTT_AVG_ms]											AS ICMP_Ping_RTT_Mean_ms
      ,[RTT_AVG_no_1st_ms]									AS ICMP_Ping_RTT_Mean_no1st_ms
      ,[RTT_MAX_ms]											AS ICMP_Ping_RTT_Max_ms

	  -- TCP/IP Information
	  ,IP_Service_Access_Result
	  ,IP_Service_Access_Delay_ms
	  ,DNS_Delay_ms											AS DNS_Service_Access_Delay_ms
	  ,RTT_Delay_ms											AS TCP_RTT_Service_Access_Delay_ms
	  ,DATEDIFF(ms,TCP_1st_SYN_ACK,Data_1st_recieved)		AS [Data_Download_Delay (SYNACK -> 1stData)]
	  ,APN													AS APN_String
	  ,Client_IPs											AS Source_IP
	  ,DNS_Server_IPs		
	  ,Server_IPs											AS Destination_IP
	  ,TCP_Threads_Count									AS Threads
	  ,TCP_Threads_Per_Server								AS TCP_Threads_Detailed
	  ,DNS_Resolution_Attempts
	  ,DNS_Resolution_Success
	  ,DNS_Resolution_Time_Minimum_ms						AS DNS_Min_Resolution_Time_ms
	  ,DNS_Resolution_Time_Average_ms						AS DNS_Avg_Resolution_Time_ms
	  ,DNS_Resolution_Time_Maximum_ms						AS DNS_Max_Resolution_Time_ms
	  ,DNS_Hosts_List										AS DNS_Hosts_Resolved
	  ,IP_Layer_Transferred_Bytes_DL
	  ,IP_Layer_Transferred_Bytes_UL
	  
	  -- Technology Info
	  ,RAT													AS PCell_RAT
	  ,RAT_Timeline											AS PCell_RAT_Timeline
	  ,TEC_Timeline
	  ,TIME_GSM_900_s										AS TIME_GSM_900_s	
	  ,TIME_GSM_1800_s										AS TIME_GSM_1800_s	
	  ,TIME_GSM_1900_s										AS TIME_GSM_1900_s	
	  ,TIME_UMTS_850_s										AS TIME_UMTS_850_s	
	  ,TIME_UMTS_900_s										AS TIME_UMTS_900_s	
	  ,TIME_UMTS_1700_s										AS TIME_UMTS_1700_s	
	  ,TIME_UMTS_1900_s										AS TIME_UMTS_1900_s	
	  ,TIME_UMTS_2100_s										AS TIME_UMTS_2100_s	
	  ,TIME_LTE_700_s										AS PCell_TIME_LTE_700_s	
	  ,TIME_LTE_800_s										AS PCell_TIME_LTE_800_s	
	  ,TIME_LTE_900_s										AS PCell_TIME_LTE_900_s	
	  ,TIME_LTE_1700_s										AS PCell_TIME_LTE_1700_s	
	  ,TIME_LTE_1800_s										AS PCell_TIME_LTE_1800_s	
	  ,TIME_LTE_2100_s										AS PCell_TIME_LTE_2100_s	
	  ,TIME_LTE_2600_s										AS PCell_TIME_LTE_2600_s	
	  ,TIME_No_Service_s 									AS TIME_No_Service_s

	  ,IMEI_A												AS IMEI
	  ,IMSI_A												AS IMSI
	  ,UE_A													AS Device
	  ,FW_A													AS Firmware
	  ,System_Type_A										AS Measurement_System
	  ,SW_A													AS SW_Version
	  ,HomeOperator											AS Home_Operator
	  ,HomeMCC												AS Home_MCC
	  ,HomeMNC												AS Home_MNC
	  ,MCC
	  ,MNC
	  ,CellID
	  ,LAC
	  ,BCCH
	  ,SC1
	  ,SC2
	  ,SC3
	  ,SC4
	  ,BSIC
	  ,PCI
	  ,LAC_CId_BCCH
	  ,MinRxLev
	  ,AvgRxLev
	  ,MaxRxLev
	  ,MinRxQual
	  ,AvgRxQual
	  ,MaxRxQual
	  ,MinRSCP
	  ,AvgRSCP
	  ,MaxRSCP
	  ,minEcIo
	  ,AvgEcIo
	  ,maxEcIo
	  ,MinTxPwr3G
	  ,AvgTxPwr3G
	  ,MaxTxPwr3G
	  ,CQI_HSDPA_Min
	  ,CQI_HSDPA
	  ,CQI_HSDPA_Max
	  ,BLER3G
	  ,MinRSRP
	  ,AvgRSRP
	  ,MaxRSRP
	  ,MinRSRQ
	  ,AvgRSRQ
	  ,MaxRSRQ
	  ,MinSINR
	  ,AvgSINR
	  ,MaxSINR
	  ,MinTxPwr4G
	  ,AvgTxPwr4G
	  ,MaxTxPwr4G
	  ,CQI_LTE_Min
	  ,CQI_LTE
	  ,CQI_LTE_Max
	  ,CAST(LTE_DL_MinRB as decimal(10,0))													AS MinDLRB
	  ,CAST(LTE_DL_AvgRB as decimal(10,0))													AS AvgDLRB
	  ,CAST(LTE_DL_MaxRB as decimal(10,0))													AS MaxDLRB
	  ,CAST(LTE_DL_AvgMCS as decimal(10,1))													AS AvgDLMCS
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNumQPSK]   / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDLQPSK
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum16QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL16QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum64QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL64QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL256QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 and CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) >= 0.1 THEN 'True'
	     ELSE 'False'
	 	END AS DL256QAM_larger_10
	  ,LTE_DL_PDSCHBytesTransfered															AS PDSCHBytesTransfered
	  ,LTE_DL_MinScheduledPDSCHThroughput													AS MinScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_AvgScheduledPDSCHThroughput													AS AvgScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_MaxScheduledPDSCHThroughput													AS MaxScheduledPDSCHThroughput_kbit_s
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumBPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULBPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumQPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULQPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum16QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL16QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL64QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 and CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) >= 0.3 THEN 'True'
		ELSE 'False'
		END AS UL64QAM_larger_30
	  ,LTE_UL_PUSCHBytesTransfered															AS PUSCHBytesTransfered
	  ,LTE_UL_MinScheduledPUSCHThroughput													AS MinScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_AvgScheduledPUSCHThroughput													AS AvgScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_MaxScheduledPUSCHThroughput													AS MaxScheduledPUSCHThroughput_kbit_s
	  ,HandoversInfo
	  ,NULL as Region
	  ,NULL as Vendor
	  ,JOIN_ID
	   ,CASE WHEN Test_Status like 'Completed' and Test_Name like 'YouTube' and 1.0*(isnull(Accumulated_Freezing_Time_s,0) + isnull(Video_Skips_Duration_Time_s,0) + isnull(Black,0) )/Video_Playout_Duration_Time_s > 0.1 THEN 'True'
	        WHEN Test_Status like 'Completed' and Test_Name like 'YouTube' and 1.0*(isnull(Accumulated_Freezing_Time_s,0) + isnull(Video_Skips_Duration_Time_s,0) + isnull(Black,0) )/Video_Playout_Duration_Time_s <= 0.1 THEN null
	        ELSE null END AS Irritating_Video_Playout
  FROM NEW_CDR_DATA_2018_TDG
  WHERE Validity = 1 and HomeOperator like (SELECT Operator FROM NEW_OPERATORS_PRIORITY_2018 WHERE SequenceNumber = 2) -- and [Test_Start_Time] < CONVERT(datetime,'June 01 00:00:00 2019')

GO
CREATE VIEW [dbo].[vDataCDR2018_Operator3_TDG] 
AS
SELECT [Campaign_A]											AS Campaign
	  ,[HomeOperator]										AS Operator
      ,[Test_Type]											AS Type_of_Test
      ,[Test_Name]											AS Test_Name
      ,[Test_Info]											AS Test_Info
      ,[direction]											AS Direction
	  ,CASE WHEN [Test_Type] like 'httpTransfer' and [Test_Name] like '%MT' THEN 'MT'
			WHEN [Test_Type] like 'httpBrowser'  and TCP_Threads_Count > 1 THEN 'MT'
			WHEN [Test_Type] like 'ICMP Ping' then null
			ELSE 'ST'
			END AS Thread_Info
      ,[URL]
	  ,CASE WHEN [Test_Type] like 'httpBrowser' and Test_Status like 'Completed' THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
		    WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' and Content_Transfered_Size_Bytes is not null THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
			WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' THEN '1 MB'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_01 is not null THEN CAST(PacketSize_01 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_02 is not null THEN CAST(PacketSize_02 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1mb%'   THEN '1 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1mb%'   THEN '1 MB'
			END AS Size
      ,[Test_Status]										AS Test_Result
	  ,ErrorCode_Message
	  ,[Application_Layer_MDR_kbit_s]						AS Mean_Data_Rate_Kbit_s
	  ,CASE WHEN Test_Status like 'Completed' THEN  0.001*Content_Transfered_Time_ms
			ELSE null
			END AS Transfer_Duration_s
      ,[TestId]
	  ,[Sessionid]
      ,[FileId_A]											AS FileID
      ,[Sequenz_ID_per_File_A]								AS Sequenz_ID_per_File
      ,[FileName_A]											AS File_Name
	  ,PCAP_File_Name

	  -- LOCATION INFORMATION
      ,[Channel]
      ,[Channel_Description]
      ,[G_Level_1]
      ,[G_Level_2]
      ,[G_Level_3]
      ,[G_Level_4]
	  ,case when G_Level_5 is null or G_Level_5 like '' then G_Level_5
	        when Remark    is null or Remark like ''    then G_Level_5 
	        else G_Level_5 + ': ' + Remark
	        end as G_Level_5
      ,[Train_Type]
      ,[Train_Name]
      ,[Wagon_Number]
      ,[Repeater_Wagon]
      ,[startLatitude_A]									AS Test_Start_Latitude
      ,[startLongitude_A]									AS Test_Start_Longitude
      ,CAST([Distance_A] as decimal(10,2))					AS Test_Distance_m

	  -- EVENTS SECTION
	  ,DATEPART(year,[Test_Start_Time])						AS Year
	  ,DATEPART(quarter,[Test_Start_Time])					AS Quarter
	  ,DATEPART(month,[Test_Start_Time])					AS Month
	  ,DATEPART(week,[Test_Start_Time])						AS Week
	  ,DATEPART(day,[Test_Start_Time])						AS Day
	  ,DATEPART(hour,[Test_Start_Time])						AS Hour
      ,dbo.DelphiDateTime([Test_Start_Time])				AS [Test_Start_Time]
      ,dbo.DelphiDateTime([DNS_1st_Request])				AS [DNS_1st_Request]
      ,dbo.DelphiDateTime([DNS_1st_Response])				AS [DNS_1st_Response]
      ,dbo.DelphiDateTime([TCP_1st_SYN])					AS [TCP_1st_SYN]
      ,dbo.DelphiDateTime([TCP_1st_SYN_ACK])				AS [TCP_1st_SYN_ACK]
      ,dbo.DelphiDateTime([Player_1st_Packet])				AS [Player_1st_Packet]
      ,dbo.DelphiDateTime([Player_End_of_Download])			AS [Player_End_of_Download]
      ,dbo.DelphiDateTime([Video_Start_Download])			AS [Video_Start_Download]
      ,dbo.DelphiDateTime([Video_Start_Transfer])			AS [Video_Start_Transfer]
      ,dbo.DelphiDateTime([Data_1st_recieved])				AS [Data_1st_recieved]
      ,dbo.DelphiDateTime([Data_Last_Recieved])				AS [Data_Last_Recieved]
      ,dbo.DelphiDateTime([Test_End_Time])					AS [Test_End_Time]
      ,CAST(0.001*[Test_Duration_ms] as decimal(10,2))		AS Test_Duration_s

	  -- FAILURE CLASSIFICATION
      ,NULL													AS Failure_Phase
      ,NULL													AS Failure_Technology
      ,NULL													AS Failure_Class
      ,NULL													AS Failure_Category
      ,NULL													AS Failure_SubCategory
      ,NULL													AS Failure_Comment

	  -- TEST SPECIFIC QoS
	  ,CASE WHEN Test_Type like 'httpTransfer' THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Transfer_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpTransfer' THEN Content_Transfered_Size_Bytes ELSE null END AS http_Transfer_Transferred_Bytes
	  ,CASE WHEN Test_Type like 'httpBrowser'  THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Browser_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpBrowser'  THEN Content_Transfered_Size_Bytes ELSE null END AS http_Browser_Transferred_Bytes
      ,[Page_Images_Count]									AS http_Browser_Number_of_Images
      ,[MIN_VMOS]											AS VideoStream_VQ_Min
      ,[AVG_VMOS]											AS VideoStream_VQ_Mean
      ,[MAX_VMOS]											AS VideoStream_VQ_Max
      ,CAST([HorResolution] as varchar(10)) + 'x' + CAST([VerResolution] as varchar(10))			AS VideoStream_Video_Resolution
      ,[Resolution_Timeline]								AS VideoStream_Video_Resolution_Timeline
      ,[Video_Freeze_Count]									AS VideoStream_Number_of_Freezings
      ,[Accumulated_Freezing_Time_s]						AS VideoStream_Freezing_Time_Sum_s
      ,[Longest_Single_Freezing_Time_s]						AS VideoStream_Freezing_Time_Max_s
      ,[Black]												AS VideoStream_Black_Frames_Ratio
      ,[Jerkiness]											AS VideoStream_Jerkiness_Ratio
      ,[Video_Skips_Count]									AS VideoStream_Number_of_Skips
      ,[Video_Skips_Duration_Time_s]						AS VideoStream_Skipped_Time_Sum_s
	  ,[Time_To_First_Picture_s]							AS VideoStream_Time_to_First_Picture_s
      ,[Player_IP_Service_Access_Time_s]					AS VideoStream_Player_IP_Service_Access_Time_s
      ,[Player_Download_Time_s]								AS VideoStream_Player_Download_Time_s
      ,[Player_Session_Time_s]								AS VideoStream_Player_Session_Time_s
      ,[Test_Video_Stream_Duration_s]						AS VideoStream_Test_Video_Stream_Duration_s
      ,[Video_IP_Service_Access_Time_s]						AS VideoStream_Video_IP_Service_Access_Time_s
      ,[Video_Reproduction_Start_Delay_s]					AS VideoStream_Video_Reproduction_Start_Delay_s
      ,[Video_Play_Start_Time_s]							AS VideoStream_Video_Play_Start_Time_s
      ,[Video_Transfer_Time_s]								AS VideoStream_Video_Transfer_Time_s
      ,[Video_Playout_Duration_Time_s]						AS VideoStream_Video_Playout_Duration_Time_s
      ,[PING_Samples]										AS ICMP_Ping_Attempt
	  ,CASE WHEN [PING_Failure_Samples] > 0 THEN [PING_Samples] - [PING_Failure_Samples]
			ELSE [PING_Failure_Samples]
			END AS ICMP_Ping_Success
      ,[RTT_MIN_ms]											AS ICMP_Ping_RTT_Min_ms
      ,[RTT_AVG_ms]											AS ICMP_Ping_RTT_Mean_ms
      ,[RTT_AVG_no_1st_ms]									AS ICMP_Ping_RTT_Mean_no1st_ms
      ,[RTT_MAX_ms]											AS ICMP_Ping_RTT_Max_ms

	  -- TCP/IP Information
	  ,IP_Service_Access_Result
	  ,IP_Service_Access_Delay_ms
	  ,DNS_Delay_ms											AS DNS_Service_Access_Delay_ms
	  ,RTT_Delay_ms											AS TCP_RTT_Service_Access_Delay_ms
	  ,DATEDIFF(ms,TCP_1st_SYN_ACK,Data_1st_recieved)		AS [Data_Download_Delay (SYNACK -> 1stData)]
	  ,APN													AS APN_String
	  ,Client_IPs											AS Source_IP
	  ,DNS_Server_IPs		
	  ,Server_IPs											AS Destination_IP
	  ,TCP_Threads_Count									AS Threads
	  ,TCP_Threads_Per_Server								AS TCP_Threads_Detailed
	  ,DNS_Resolution_Attempts
	  ,DNS_Resolution_Success
	  ,DNS_Resolution_Time_Minimum_ms						AS DNS_Min_Resolution_Time_ms
	  ,DNS_Resolution_Time_Average_ms						AS DNS_Avg_Resolution_Time_ms
	  ,DNS_Resolution_Time_Maximum_ms						AS DNS_Max_Resolution_Time_ms
	  ,DNS_Hosts_List										AS DNS_Hosts_Resolved
	  ,IP_Layer_Transferred_Bytes_DL
	  ,IP_Layer_Transferred_Bytes_UL
	  
	  -- Technology Info
	  ,RAT													AS PCell_RAT
	  ,RAT_Timeline											AS PCell_RAT_Timeline
	  ,TEC_Timeline
	  ,TIME_GSM_900_s										AS TIME_GSM_900_s	
	  ,TIME_GSM_1800_s										AS TIME_GSM_1800_s	
	  ,TIME_GSM_1900_s										AS TIME_GSM_1900_s	
	  ,TIME_UMTS_850_s										AS TIME_UMTS_850_s	
	  ,TIME_UMTS_900_s										AS TIME_UMTS_900_s	
	  ,TIME_UMTS_1700_s										AS TIME_UMTS_1700_s	
	  ,TIME_UMTS_1900_s										AS TIME_UMTS_1900_s	
	  ,TIME_UMTS_2100_s										AS TIME_UMTS_2100_s	
	  ,TIME_LTE_700_s										AS PCell_TIME_LTE_700_s	
	  ,TIME_LTE_800_s										AS PCell_TIME_LTE_800_s	
	  ,TIME_LTE_900_s										AS PCell_TIME_LTE_900_s	
	  ,TIME_LTE_1700_s										AS PCell_TIME_LTE_1700_s	
	  ,TIME_LTE_1800_s										AS PCell_TIME_LTE_1800_s	
	  ,TIME_LTE_2100_s										AS PCell_TIME_LTE_2100_s	
	  ,TIME_LTE_2600_s										AS PCell_TIME_LTE_2600_s	
	  ,TIME_No_Service_s 									AS TIME_No_Service_s

	  ,IMEI_A												AS IMEI
	  ,IMSI_A												AS IMSI
	  ,UE_A													AS Device
	  ,FW_A													AS Firmware
	  ,System_Type_A										AS Measurement_System
	  ,SW_A													AS SW_Version
	  ,HomeOperator											AS Home_Operator
	  ,HomeMCC												AS Home_MCC
	  ,HomeMNC												AS Home_MNC
	  ,MCC
	  ,MNC
	  ,CellID
	  ,LAC
	  ,BCCH
	  ,SC1
	  ,SC2
	  ,SC3
	  ,SC4
	  ,BSIC
	  ,PCI
	  ,LAC_CId_BCCH
	  ,MinRxLev
	  ,AvgRxLev
	  ,MaxRxLev
	  ,MinRxQual
	  ,AvgRxQual
	  ,MaxRxQual
	  ,MinRSCP
	  ,AvgRSCP
	  ,MaxRSCP
	  ,minEcIo
	  ,AvgEcIo
	  ,maxEcIo
	  ,MinTxPwr3G
	  ,AvgTxPwr3G
	  ,MaxTxPwr3G
	  ,CQI_HSDPA_Min
	  ,CQI_HSDPA
	  ,CQI_HSDPA_Max
	  ,BLER3G
	  ,MinRSRP
	  ,AvgRSRP
	  ,MaxRSRP
	  ,MinRSRQ
	  ,AvgRSRQ
	  ,MaxRSRQ
	  ,MinSINR
	  ,AvgSINR
	  ,MaxSINR
	  ,MinTxPwr4G
	  ,AvgTxPwr4G
	  ,MaxTxPwr4G
	  ,CQI_LTE_Min
	  ,CQI_LTE
	  ,CQI_LTE_Max
	  ,CAST(LTE_DL_MinRB as decimal(10,0))													AS MinDLRB
	  ,CAST(LTE_DL_AvgRB as decimal(10,0))													AS AvgDLRB
	  ,CAST(LTE_DL_MaxRB as decimal(10,0))													AS MaxDLRB
	  ,CAST(LTE_DL_AvgMCS as decimal(10,1))													AS AvgDLMCS
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNumQPSK]   / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDLQPSK
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum16QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL16QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum64QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL64QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL256QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 and CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) >= 0.1 THEN 'True'
	     ELSE 'False'
	 	END AS DL256QAM_larger_10
	  ,LTE_DL_PDSCHBytesTransfered															AS PDSCHBytesTransfered
	  ,LTE_DL_MinScheduledPDSCHThroughput													AS MinScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_AvgScheduledPDSCHThroughput													AS AvgScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_MaxScheduledPDSCHThroughput													AS MaxScheduledPDSCHThroughput_kbit_s
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumBPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULBPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumQPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULQPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum16QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL16QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL64QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 and CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) >= 0.3 THEN 'True'
		ELSE 'False'
		END AS UL64QAM_larger_30
	  ,LTE_UL_PUSCHBytesTransfered															AS PUSCHBytesTransfered
	  ,LTE_UL_MinScheduledPUSCHThroughput													AS MinScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_AvgScheduledPUSCHThroughput													AS AvgScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_MaxScheduledPUSCHThroughput													AS MaxScheduledPUSCHThroughput_kbit_s
	  ,HandoversInfo
	  ,NULL as Region
	  ,NULL as Vendor
	  ,JOIN_ID
	   ,CASE WHEN Test_Status like 'Completed' and Test_Name like 'YouTube' and 1.0*(isnull(Accumulated_Freezing_Time_s,0) + isnull(Video_Skips_Duration_Time_s,0) + isnull(Black,0) )/Video_Playout_Duration_Time_s > 0.1 THEN 'True'
	        WHEN Test_Status like 'Completed' and Test_Name like 'YouTube' and 1.0*(isnull(Accumulated_Freezing_Time_s,0) + isnull(Video_Skips_Duration_Time_s,0) + isnull(Black,0) )/Video_Playout_Duration_Time_s <= 0.1 THEN null
	        ELSE null END AS Irritating_Video_Playout
  FROM NEW_CDR_DATA_2018_TDG
  WHERE Validity = 1 and HomeOperator like (SELECT Operator FROM NEW_OPERATORS_PRIORITY_2018 WHERE SequenceNumber = 3) -- and [Test_Start_Time] < CONVERT(datetime,'June 01 00:00:00 2019')

GO
CREATE VIEW [dbo].[vDataCDR2018_Operator4_TDG] 
AS
SELECT [Campaign_A]											AS Campaign
	  ,[HomeOperator]										AS Operator
      ,[Test_Type]											AS Type_of_Test
      ,[Test_Name]											AS Test_Name
      ,[Test_Info]											AS Test_Info
      ,[direction]											AS Direction
	  ,CASE WHEN [Test_Type] like 'httpTransfer' and [Test_Name] like '%MT' THEN 'MT'
			WHEN [Test_Type] like 'httpBrowser'  and TCP_Threads_Count > 1 THEN 'MT'
			WHEN [Test_Type] like 'ICMP Ping' then null
			ELSE 'ST'
			END AS Thread_Info
      ,[URL]
	  ,CASE WHEN [Test_Type] like 'httpBrowser' and Test_Status like 'Completed' THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
		    WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' and Content_Transfered_Size_Bytes is not null THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
			WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' THEN '1 MB'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_01 is not null THEN CAST(PacketSize_01 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_02 is not null THEN CAST(PacketSize_02 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1mb%'   THEN '1 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1mb%'   THEN '1 MB'
			END AS Size
      ,[Test_Status]										AS Test_Result
	  ,ErrorCode_Message
	  ,[Application_Layer_MDR_kbit_s]						AS Mean_Data_Rate_Kbit_s
	  ,CASE WHEN Test_Status like 'Completed' THEN  0.001*Content_Transfered_Time_ms
			ELSE null
			END AS Transfer_Duration_s
      ,[TestId]
	  ,[Sessionid]
      ,[FileId_A]											AS FileID
      ,[Sequenz_ID_per_File_A]								AS Sequenz_ID_per_File
      ,[FileName_A]											AS File_Name
	  ,PCAP_File_Name

	  -- LOCATION INFORMATION
      ,[Channel]
      ,[Channel_Description]
      ,[G_Level_1]
      ,[G_Level_2]
      ,[G_Level_3]
      ,[G_Level_4]
	  ,case when G_Level_5 is null or G_Level_5 like '' then G_Level_5
	        when Remark    is null or Remark like ''    then G_Level_5 
	        else G_Level_5 + ': ' + Remark
	        end as G_Level_5
      ,[Train_Type]
      ,[Train_Name]
      ,[Wagon_Number]
      ,[Repeater_Wagon]
      ,[startLongitude_A]									AS Test_Start_Longitude
      ,[startLatitude_A]									AS Test_Start_Latitude
      ,CAST([Distance_A] as decimal(10,2))					AS Test_Distance_m

	  -- EVENTS SECTION
	  ,DATEPART(year,[Test_Start_Time])						AS Year
	  ,DATEPART(quarter,[Test_Start_Time])					AS Quarter
	  ,DATEPART(month,[Test_Start_Time])					AS Month
	  ,DATEPART(week,[Test_Start_Time])						AS Week
	  ,DATEPART(day,[Test_Start_Time])						AS Day
	  ,DATEPART(hour,[Test_Start_Time])						AS Hour
      ,dbo.DelphiDateTime([Test_Start_Time])				AS [Test_Start_Time]
      ,dbo.DelphiDateTime([DNS_1st_Request])				AS [DNS_1st_Request]
      ,dbo.DelphiDateTime([DNS_1st_Response])				AS [DNS_1st_Response]
      ,dbo.DelphiDateTime([TCP_1st_SYN])					AS [TCP_1st_SYN]
      ,dbo.DelphiDateTime([TCP_1st_SYN_ACK])				AS [TCP_1st_SYN_ACK]
      ,dbo.DelphiDateTime([Player_1st_Packet])				AS [Player_1st_Packet]
      ,dbo.DelphiDateTime([Player_End_of_Download])			AS [Player_End_of_Download]
      ,dbo.DelphiDateTime([Video_Start_Download])			AS [Video_Start_Download]
      ,dbo.DelphiDateTime([Video_Start_Transfer])			AS [Video_Start_Transfer]
      ,dbo.DelphiDateTime([Data_1st_recieved])				AS [Data_1st_recieved]
      ,dbo.DelphiDateTime([Data_Last_Recieved])				AS [Data_Last_Recieved]
      ,dbo.DelphiDateTime([Test_End_Time])					AS [Test_End_Time]
      ,CAST(0.001*[Test_Duration_ms] as decimal(10,2))		AS Test_Duration_s

	  -- FAILURE CLASSIFICATION
      ,[FAILURE_PHASE]										AS Failure_Phase
      ,[FAILURE_TECHNOLOGY]									AS Failure_Technology
      ,[FAILURE_CLASS]										AS Failure_Class
      ,[FAILURE_CATEGORY]									AS Failure_Category
      ,[FAILURE_SUBCATEGORY]								AS Failure_SubCategory
      ,[FAILURE_COMMENT]									AS Failure_Comment

	  -- TEST SPECIFIC QoS
	  ,CASE WHEN Test_Type like 'httpTransfer' THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Transfer_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpTransfer' THEN Content_Transfered_Size_Bytes ELSE null END AS http_Transfer_Transferred_Bytes
	  ,CASE WHEN Test_Type like 'httpBrowser'  THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Browser_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpBrowser'  THEN Content_Transfered_Size_Bytes ELSE null END AS http_Browser_Transferred_Bytes
      ,[Page_Images_Count]									AS http_Browser_Number_of_Images
      ,[MIN_VMOS]											AS VideoStream_VQ_Min
      ,[AVG_VMOS]											AS VideoStream_VQ_Mean
      ,[MAX_VMOS]											AS VideoStream_VQ_Max
      ,CAST([HorResolution] as varchar(10)) + 'x' + CAST([VerResolution] as varchar(10))			AS VideoStream_Video_Resolution
      ,[Resolution_Timeline]								AS VideoStream_Video_Resolution_Timeline
      ,[Video_Freeze_Count]									AS VideoStream_Number_of_Freezings
      ,[Accumulated_Freezing_Time_s]						AS VideoStream_Freezing_Time_Sum_s
      ,[Longest_Single_Freezing_Time_s]						AS VideoStream_Freezing_Time_Max_s
      ,[Black]												AS VideoStream_Black_Frames_Ratio
      ,[Jerkiness]											AS VideoStream_Jerkiness_Ratio
      ,[Video_Skips_Count]									AS VideoStream_Number_of_Skips
      ,[Video_Skips_Duration_Time_s]						AS VideoStream_Skipped_Time_Sum_s
	  ,[Time_To_First_Picture_s]							AS VideoStream_Time_to_First_Picture_s
      ,[Player_IP_Service_Access_Time_s]					AS VideoStream_Player_IP_Service_Access_Time_s
      ,[Player_Download_Time_s]								AS VideoStream_Player_Download_Time_s
      ,[Player_Session_Time_s]								AS VideoStream_Player_Session_Time_s
      ,[Test_Video_Stream_Duration_s]						AS VideoStream_Test_Video_Stream_Duration_s
      ,[Video_IP_Service_Access_Time_s]						AS VideoStream_Video_IP_Service_Access_Time_s
      ,[Video_Reproduction_Start_Delay_s]					AS VideoStream_Video_Reproduction_Start_Delay_s
      ,[Video_Play_Start_Time_s]							AS VideoStream_Video_Play_Start_Time_s
      ,[Video_Transfer_Time_s]								AS VideoStream_Video_Transfer_Time_s
      ,[Video_Playout_Duration_Time_s]						AS VideoStream_Video_Playout_Duration_Time_s
      ,[PING_Samples]										AS ICMP_Ping_Attempt
	  ,CASE WHEN [PING_Failure_Samples] > 0 THEN [PING_Samples] - [PING_Failure_Samples]
			ELSE [PING_Failure_Samples]
			END AS ICMP_Ping_Success
      ,[RTT_MIN_ms]											AS ICMP_Ping_RTT_Min_ms
      ,[RTT_AVG_ms]											AS ICMP_Ping_RTT_Mean_ms
      ,[RTT_AVG_no_1st_ms]									AS ICMP_Ping_RTT_Mean_no1st_ms
      ,[RTT_MAX_ms]											AS ICMP_Ping_RTT_Max_ms

	  -- TCP/IP Information
	  ,IP_Service_Access_Result
	  ,IP_Service_Access_Delay_ms
	  ,DNS_Delay_ms											AS DNS_Service_Access_Delay_ms
	  ,RTT_Delay_ms											AS TCP_RTT_Service_Access_Delay_ms
	  ,DATEDIFF(ms,TCP_1st_SYN_ACK,Data_1st_recieved)		AS [Data_Download_Delay (SYNACK -> 1stData)]
	  ,APN													AS APN_String
	  ,Client_IPs											AS Source_IP
	  ,DNS_Server_IPs		
	  ,Server_IPs											AS Destination_IP
	  ,TCP_Threads_Count									AS Threads
	  ,TCP_Threads_Per_Server								AS TCP_Threads_Detailed
	  ,DNS_Resolution_Attempts
	  ,DNS_Resolution_Success
	  ,DNS_Resolution_Time_Minimum_ms						AS DNS_Min_Resolution_Time_ms
	  ,DNS_Resolution_Time_Average_ms						AS DNS_Avg_Resolution_Time_ms
	  ,DNS_Resolution_Time_Maximum_ms						AS DNS_Max_Resolution_Time_ms
	  ,DNS_Hosts_List										AS DNS_Hosts_Resolved
	  ,IP_Layer_Transferred_Bytes_DL
	  ,IP_Layer_Transferred_Bytes_UL
	  
	  -- Technology Info
	  ,RAT													AS PCell_RAT
	  ,RAT_Timeline											AS PCell_RAT_Timeline
	  ,TEC_Timeline
	  ,TIME_GSM_900_s										AS TIME_GSM_900_s	
	  ,TIME_GSM_1800_s										AS TIME_GSM_1800_s	
	  ,TIME_GSM_1900_s										AS TIME_GSM_1900_s	
	  ,TIME_UMTS_850_s										AS TIME_UMTS_850_s	
	  ,TIME_UMTS_900_s										AS TIME_UMTS_900_s	
	  ,TIME_UMTS_1700_s										AS TIME_UMTS_1700_s	
	  ,TIME_UMTS_1900_s										AS TIME_UMTS_1900_s	
	  ,TIME_UMTS_2100_s										AS TIME_UMTS_2100_s	
	  ,TIME_LTE_700_s										AS PCell_TIME_LTE_700_s	
	  ,TIME_LTE_800_s										AS PCell_TIME_LTE_800_s	
	  ,TIME_LTE_900_s										AS PCell_TIME_LTE_900_s	
	  ,TIME_LTE_1700_s										AS PCell_TIME_LTE_1700_s	
	  ,TIME_LTE_1800_s										AS PCell_TIME_LTE_1800_s	
	  ,TIME_LTE_2100_s										AS PCell_TIME_LTE_2100_s	
	  ,TIME_LTE_2600_s										AS PCell_TIME_LTE_2600_s	
	  ,TIME_No_Service_s 									AS TIME_No_Service_s

	  ,IMEI_A												AS IMEI
	  ,IMSI_A												AS IMSI
	  ,UE_A													AS Device
	  ,FW_A													AS Firmware
	  ,System_Type_A										AS Measurement_System
	  ,SW_A													AS SW_Version
	  ,HomeOperator											AS Home_Operator
	  ,HomeMCC												AS Home_MCC
	  ,HomeMNC												AS Home_MNC
	  ,MCC
	  ,MNC
	  ,CellID
	  ,LAC
	  ,BCCH
	  ,SC1
	  ,SC2
	  ,SC3
	  ,SC4
	  ,BSIC
	  ,PCI
	  ,LAC_CId_BCCH
	  ,MinRxLev
	  ,AvgRxLev
	  ,MaxRxLev
	  ,MinRxQual
	  ,AvgRxQual
	  ,MaxRxQual
	  ,MinRSCP
	  ,AvgRSCP
	  ,MaxRSCP
	  ,minEcIo
	  ,AvgEcIo
	  ,maxEcIo
	  ,MinTxPwr3G
	  ,AvgTxPwr3G
	  ,MaxTxPwr3G
	  ,CQI_HSDPA_Min
	  ,CQI_HSDPA
	  ,CQI_HSDPA_Max
	  ,BLER3G
	  ,MinRSRP
	  ,AvgRSRP
	  ,MaxRSRP
	  ,MinRSRQ
	  ,AvgRSRQ
	  ,MaxRSRQ
	  ,MinSINR
	  ,AvgSINR
	  ,MaxSINR
	  ,MinTxPwr4G
	  ,AvgTxPwr4G
	  ,MaxTxPwr4G
	  ,CQI_LTE_Min
	  ,CQI_LTE
	  ,CQI_LTE_Max
	  ,CAST(LTE_DL_MinRB as decimal(10,0))													AS MinDLRB
	  ,CAST(LTE_DL_AvgRB as decimal(10,0))													AS AvgDLRB
	  ,CAST(LTE_DL_MaxRB as decimal(10,0))													AS MaxDLRB
	  ,CAST(LTE_DL_AvgMCS as decimal(10,1))													AS AvgDLMCS
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNumQPSK]   / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDLQPSK
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum16QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL16QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum64QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL64QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL256QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 and CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) >= 0.1 THEN 'True'
	     ELSE 'False'
	 	END AS DL256QAM_larger_10
	  ,LTE_DL_PDSCHBytesTransfered															AS PDSCHBytesTransfered
	  ,LTE_DL_MinScheduledPDSCHThroughput													AS MinScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_AvgScheduledPDSCHThroughput													AS AvgScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_MaxScheduledPDSCHThroughput													AS MaxScheduledPDSCHThroughput_kbit_s
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumBPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULBPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumQPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULQPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum16QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL16QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL64QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 and CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) >= 0.3 THEN 'True'
		ELSE 'False'
		END AS UL64QAM_larger_30
	  ,LTE_UL_PUSCHBytesTransfered															AS PUSCHBytesTransfered
	  ,LTE_UL_MinScheduledPUSCHThroughput													AS MinScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_AvgScheduledPUSCHThroughput													AS AvgScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_MaxScheduledPUSCHThroughput													AS MaxScheduledPUSCHThroughput_kbit_s
	  ,HandoversInfo
	  ,Region
	  ,Vendor
	  ,JOIN_ID
  FROM NEW_CDR_DATA_2018_TDG
  WHERE Validity = 1 and HomeOperator like (SELECT Operator FROM NEW_OPERATORS_PRIORITY_2018 WHERE SequenceNumber = 4) -- and [Test_Start_Time] < CONVERT(datetime,'May 18 00:00:00 2019')

GO
CREATE VIEW [dbo].[vDataCDR2018_Operator5_TDG] 
AS
SELECT [Campaign_A]											AS Campaign
	  ,[HomeOperator]										AS Operator
      ,[Test_Type]											AS Type_of_Test
      ,[Test_Name]											AS Test_Name
      ,[Test_Info]											AS Test_Info
      ,[direction]											AS Direction
	  ,CASE WHEN [Test_Type] like 'httpTransfer' and [Test_Name] like '%MT' THEN 'MT'
			WHEN [Test_Type] like 'httpBrowser'  and TCP_Threads_Count > 1 THEN 'MT'
			WHEN [Test_Type] like 'ICMP Ping' then null
			ELSE 'ST'
			END AS Thread_Info
      ,[URL]
	  ,CASE WHEN [Test_Type] like 'httpBrowser' and Test_Status like 'Completed' THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
		    WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' and Content_Transfered_Size_Bytes is not null THEN CAST(CAST((0.000001*[Content_Transfered_Size_Bytes]) as decimal(10,2)) as varchar(10)) + ' MB'
			WHEN [Test_Type] like 'Application' and Test_Status like 'Completed' THEN '1 MB'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_01 is not null THEN CAST(PacketSize_01 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'ICMP Ping' and PacketSize_02 is not null THEN CAST(PacketSize_02 as varchar(10)) + ' bytes'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'DL' and Remote_Filename like '%1mb%'   THEN '1 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1gb%'   THEN '1000 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%500mb%' THEN '500 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%20mb%'  THEN '20 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%10mb%'  THEN '10 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%5mb%'   THEN '5 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%2mb%'   THEN '2 MB'
			WHEN [Test_Type] like 'httpTransfer' and direction like 'UL' and Local_Filename  like '%1mb%'   THEN '1 MB'
			END AS Size
      ,[Test_Status]										AS Test_Result
	  ,ErrorCode_Message
	  ,[Application_Layer_MDR_kbit_s]						AS Mean_Data_Rate_Kbit_s
	  ,CASE WHEN Test_Status like 'Completed' THEN  0.001*Content_Transfered_Time_ms
			ELSE null
			END AS Transfer_Duration_s
      ,[TestId]
	  ,[Sessionid]
      ,[FileId_A]											AS FileID
      ,[Sequenz_ID_per_File_A]								AS Sequenz_ID_per_File
      ,[FileName_A]											AS File_Name
	  ,PCAP_File_Name

	  -- LOCATION INFORMATION
      ,[Channel]
      ,[Channel_Description]
      ,[G_Level_1]
      ,[G_Level_2]
      ,[G_Level_3]
      ,[G_Level_4]
	  ,case when G_Level_5 is null or G_Level_5 like '' then G_Level_5
	        when Remark    is null or Remark like ''    then G_Level_5 
	        else G_Level_5 + ': ' + Remark
	        end as G_Level_5
      ,[Train_Type]
      ,[Train_Name]
      ,[Wagon_Number]
      ,[Repeater_Wagon]
      ,[startLongitude_A]									AS Test_Start_Longitude
      ,[startLatitude_A]									AS Test_Start_Latitude
      ,CAST([Distance_A] as decimal(10,2))					AS Test_Distance_m

	  -- EVENTS SECTION
	  ,DATEPART(year,[Test_Start_Time])						AS Year
	  ,DATEPART(quarter,[Test_Start_Time])					AS Quarter
	  ,DATEPART(month,[Test_Start_Time])					AS Month
	  ,DATEPART(week,[Test_Start_Time])						AS Week
	  ,DATEPART(day,[Test_Start_Time])						AS Day
	  ,DATEPART(hour,[Test_Start_Time])						AS Hour
      ,dbo.DelphiDateTime([Test_Start_Time])				AS [Test_Start_Time]
      ,dbo.DelphiDateTime([DNS_1st_Request])				AS [DNS_1st_Request]
      ,dbo.DelphiDateTime([DNS_1st_Response])				AS [DNS_1st_Response]
      ,dbo.DelphiDateTime([TCP_1st_SYN])					AS [TCP_1st_SYN]
      ,dbo.DelphiDateTime([TCP_1st_SYN_ACK])				AS [TCP_1st_SYN_ACK]
      ,dbo.DelphiDateTime([Player_1st_Packet])				AS [Player_1st_Packet]
      ,dbo.DelphiDateTime([Player_End_of_Download])			AS [Player_End_of_Download]
      ,dbo.DelphiDateTime([Video_Start_Download])			AS [Video_Start_Download]
      ,dbo.DelphiDateTime([Video_Start_Transfer])			AS [Video_Start_Transfer]
      ,dbo.DelphiDateTime([Data_1st_recieved])				AS [Data_1st_recieved]
      ,dbo.DelphiDateTime([Data_Last_Recieved])				AS [Data_Last_Recieved]
      ,dbo.DelphiDateTime([Test_End_Time])					AS [Test_End_Time]
      ,CAST(0.001*[Test_Duration_ms] as decimal(10,2))		AS Test_Duration_s

	  -- FAILURE CLASSIFICATION
      ,[FAILURE_PHASE]										AS Failure_Phase
      ,[FAILURE_TECHNOLOGY]									AS Failure_Technology
      ,[FAILURE_CLASS]										AS Failure_Class
      ,[FAILURE_CATEGORY]									AS Failure_Category
      ,[FAILURE_SUBCATEGORY]								AS Failure_SubCategory
      ,[FAILURE_COMMENT]									AS Failure_Comment

	  -- TEST SPECIFIC QoS
	  ,CASE WHEN Test_Type like 'httpTransfer' THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Transfer_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpTransfer' THEN Content_Transfered_Size_Bytes ELSE null END AS http_Transfer_Transferred_Bytes
	  ,CASE WHEN Test_Type like 'httpBrowser'  THEN CAST(0.001*IP_Service_Access_Delay_ms as decimal(10,2)) ELSE null END AS http_Browser_Access_Duration_s
      ,CASE WHEN Test_Type like 'httpBrowser'  THEN Content_Transfered_Size_Bytes ELSE null END AS http_Browser_Transferred_Bytes
      ,[Page_Images_Count]									AS http_Browser_Number_of_Images
      ,[MIN_VMOS]											AS VideoStream_VQ_Min
      ,[AVG_VMOS]											AS VideoStream_VQ_Mean
      ,[MAX_VMOS]											AS VideoStream_VQ_Max
      ,CAST([HorResolution] as varchar(10)) + 'x' + CAST([VerResolution] as varchar(10))			AS VideoStream_Video_Resolution
      ,[Resolution_Timeline]								AS VideoStream_Video_Resolution_Timeline
      ,[Video_Freeze_Count]									AS VideoStream_Number_of_Freezings
      ,[Accumulated_Freezing_Time_s]						AS VideoStream_Freezing_Time_Sum_s
      ,[Longest_Single_Freezing_Time_s]						AS VideoStream_Freezing_Time_Max_s
      ,[Black]												AS VideoStream_Black_Frames_Ratio
      ,[Jerkiness]											AS VideoStream_Jerkiness_Ratio
      ,[Video_Skips_Count]									AS VideoStream_Number_of_Skips
      ,[Video_Skips_Duration_Time_s]						AS VideoStream_Skipped_Time_Sum_s
	  ,[Time_To_First_Picture_s]							AS VideoStream_Time_to_First_Picture_s
      ,[Player_IP_Service_Access_Time_s]					AS VideoStream_Player_IP_Service_Access_Time_s
      ,[Player_Download_Time_s]								AS VideoStream_Player_Download_Time_s
      ,[Player_Session_Time_s]								AS VideoStream_Player_Session_Time_s
      ,[Test_Video_Stream_Duration_s]						AS VideoStream_Test_Video_Stream_Duration_s
      ,[Video_IP_Service_Access_Time_s]						AS VideoStream_Video_IP_Service_Access_Time_s
      ,[Video_Reproduction_Start_Delay_s]					AS VideoStream_Video_Reproduction_Start_Delay_s
      ,[Video_Play_Start_Time_s]							AS VideoStream_Video_Play_Start_Time_s
      ,[Video_Transfer_Time_s]								AS VideoStream_Video_Transfer_Time_s
      ,[Video_Playout_Duration_Time_s]						AS VideoStream_Video_Playout_Duration_Time_s
      ,[PING_Samples]										AS ICMP_Ping_Attempt
	  ,CASE WHEN [PING_Failure_Samples] > 0 THEN [PING_Samples] - [PING_Failure_Samples]
			ELSE [PING_Failure_Samples]
			END AS ICMP_Ping_Success
      ,[RTT_MIN_ms]											AS ICMP_Ping_RTT_Min_ms
      ,[RTT_AVG_ms]											AS ICMP_Ping_RTT_Mean_ms
      ,[RTT_AVG_no_1st_ms]									AS ICMP_Ping_RTT_Mean_no1st_ms
      ,[RTT_MAX_ms]											AS ICMP_Ping_RTT_Max_ms

	  -- TCP/IP Information
	  ,IP_Service_Access_Result
	  ,IP_Service_Access_Delay_ms
	  ,DNS_Delay_ms											AS DNS_Service_Access_Delay_ms
	  ,RTT_Delay_ms											AS TCP_RTT_Service_Access_Delay_ms
	  ,DATEDIFF(ms,TCP_1st_SYN_ACK,Data_1st_recieved)		AS [Data_Download_Delay (SYNACK -> 1stData)]
	  ,APN													AS APN_String
	  ,Client_IPs											AS Source_IP
	  ,DNS_Server_IPs		
	  ,Server_IPs											AS Destination_IP
	  ,TCP_Threads_Count									AS Threads
	  ,TCP_Threads_Per_Server								AS TCP_Threads_Detailed
	  ,DNS_Resolution_Attempts
	  ,DNS_Resolution_Success
	  ,DNS_Resolution_Time_Minimum_ms						AS DNS_Min_Resolution_Time_ms
	  ,DNS_Resolution_Time_Average_ms						AS DNS_Avg_Resolution_Time_ms
	  ,DNS_Resolution_Time_Maximum_ms						AS DNS_Max_Resolution_Time_ms
	  ,DNS_Hosts_List										AS DNS_Hosts_Resolved
	  ,IP_Layer_Transferred_Bytes_DL
	  ,IP_Layer_Transferred_Bytes_UL
	  
	  -- Technology Info
	  ,RAT													AS PCell_RAT
	  ,RAT_Timeline											AS PCell_RAT_Timeline
	  ,TEC_Timeline
	  ,TIME_GSM_900_s										AS TIME_GSM_900_s	
	  ,TIME_GSM_1800_s										AS TIME_GSM_1800_s	
	  ,TIME_GSM_1900_s										AS TIME_GSM_1900_s	
	  ,TIME_UMTS_850_s										AS TIME_UMTS_850_s	
	  ,TIME_UMTS_900_s										AS TIME_UMTS_900_s	
	  ,TIME_UMTS_1700_s										AS TIME_UMTS_1700_s	
	  ,TIME_UMTS_1900_s										AS TIME_UMTS_1900_s	
	  ,TIME_UMTS_2100_s										AS TIME_UMTS_2100_s	
	  ,TIME_LTE_700_s										AS PCell_TIME_LTE_700_s	
	  ,TIME_LTE_800_s										AS PCell_TIME_LTE_800_s	
	  ,TIME_LTE_900_s										AS PCell_TIME_LTE_900_s	
	  ,TIME_LTE_1700_s										AS PCell_TIME_LTE_1700_s	
	  ,TIME_LTE_1800_s										AS PCell_TIME_LTE_1800_s	
	  ,TIME_LTE_2100_s										AS PCell_TIME_LTE_2100_s	
	  ,TIME_LTE_2600_s										AS PCell_TIME_LTE_2600_s	
	  ,TIME_No_Service_s 									AS TIME_No_Service_s

	  ,IMEI_A												AS IMEI
	  ,IMSI_A												AS IMSI
	  ,UE_A													AS Device
	  ,FW_A													AS Firmware
	  ,System_Type_A										AS Measurement_System
	  ,SW_A													AS SW_Version
	  ,HomeOperator											AS Home_Operator
	  ,HomeMCC												AS Home_MCC
	  ,HomeMNC												AS Home_MNC
	  ,MCC
	  ,MNC
	  ,CellID
	  ,LAC
	  ,BCCH
	  ,SC1
	  ,SC2
	  ,SC3
	  ,SC4
	  ,BSIC
	  ,PCI
	  ,LAC_CId_BCCH
	  ,MinRxLev
	  ,AvgRxLev
	  ,MaxRxLev
	  ,MinRxQual
	  ,AvgRxQual
	  ,MaxRxQual
	  ,MinRSCP
	  ,AvgRSCP
	  ,MaxRSCP
	  ,minEcIo
	  ,AvgEcIo
	  ,maxEcIo
	  ,MinTxPwr3G
	  ,AvgTxPwr3G
	  ,MaxTxPwr3G
	  ,CQI_HSDPA_Min
	  ,CQI_HSDPA
	  ,CQI_HSDPA_Max
	  ,BLER3G
	  ,MinRSRP
	  ,AvgRSRP
	  ,MaxRSRP
	  ,MinRSRQ
	  ,AvgRSRQ
	  ,MaxRSRQ
	  ,MinSINR
	  ,AvgSINR
	  ,MaxSINR
	  ,MinTxPwr4G
	  ,AvgTxPwr4G
	  ,MaxTxPwr4G
	  ,CQI_LTE_Min
	  ,CQI_LTE
	  ,CQI_LTE_Max
	  ,CAST(LTE_DL_MinRB as decimal(10,0))													AS MinDLRB
	  ,CAST(LTE_DL_AvgRB as decimal(10,0))													AS AvgDLRB
	  ,CAST(LTE_DL_MaxRB as decimal(10,0))													AS MaxDLRB
	  ,CAST(LTE_DL_AvgMCS as decimal(10,1))													AS AvgDLMCS
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNumQPSK]   / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDLQPSK
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum16QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL16QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum64QAM]  / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL64QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareDL256QAM
	  ,CASE WHEN [LTE_DL_CountModulation] > 0 and CAST((1.0 * [LTE_DL_CountNum256QAM] / [LTE_DL_CountModulation]) as decimal(10,2)) >= 0.1 THEN 'True'
	     ELSE 'False'
	 	END AS DL256QAM_larger_10
	  ,LTE_DL_PDSCHBytesTransfered															AS PDSCHBytesTransfered
	  ,LTE_DL_MinScheduledPDSCHThroughput													AS MinScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_AvgScheduledPDSCHThroughput													AS AvgScheduledPDSCHThroughput_kbit_s
	  ,LTE_DL_MaxScheduledPDSCHThroughput													AS MaxScheduledPDSCHThroughput_kbit_s
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumBPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULBPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNumQPSK]  / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareULQPSK
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum16QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL16QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 THEN  CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) ELSE NULL END			AS ShareUL64QAM
	  ,CASE WHEN [LTE_UL_CountModulation] > 0 and CAST((1.0 * [LTE_UL_CountNum64QAM] / [LTE_UL_CountModulation]) as decimal(10,2)) >= 0.3 THEN 'True'
		ELSE 'False'
		END AS UL64QAM_larger_30
	  ,LTE_UL_PUSCHBytesTransfered															AS PUSCHBytesTransfered
	  ,LTE_UL_MinScheduledPUSCHThroughput													AS MinScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_AvgScheduledPUSCHThroughput													AS AvgScheduledPUSCHThroughput_kbit_s
	  ,LTE_UL_MaxScheduledPUSCHThroughput													AS MaxScheduledPUSCHThroughput_kbit_s
	  ,HandoversInfo
	  ,Region
	  ,Vendor
	  ,JOIN_ID
  FROM NEW_CDR_DATA_2018_TDG
  WHERE Validity = 1 and HomeOperator like (SELECT Operator FROM NEW_OPERATORS_PRIORITY_2018 WHERE SequenceNumber = 5) -- and [Test_Start_Time] < CONVERT(datetime,'May 18 00:00:00 2019')