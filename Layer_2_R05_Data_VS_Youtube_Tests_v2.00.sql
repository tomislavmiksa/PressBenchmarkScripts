
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script execution start!...')

IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RESULTS_VS_Youtube_2018' AND type = 'U')	DROP TABLE [NEW_RESULTS_VS_Youtube_2018]
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 beeing created...')
Select   [SessionID]
		,[TestId]
		,[typeoftest]
		,CAST(null as varchar(50))							AS Test_Player
		,CAST(null as varchar(50))							AS Test_Protocol
		,CAST(null as varchar(50))							AS Test_Technology
		,CAST(null as varchar(20))							AS Test_Result
		,CAST([End-to-End Session] as varchar(100))			AS Test_Result_Detailed
		,[URL]												AS Host
		,[URL]

		-- EVENTS RELATED TO VIDEO STREAM TEST
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		,CAST(null as datetime2(3))							AS Test_Start_Time
		,CAST(null as datetime2(3))							AS Test_First_Packet_Of_Player_Recieved
		,CAST(null as datetime2(3))							AS Test_End_Of_Player_Download
		,CAST(null as datetime2(3))							AS Test_Start_Of_Video_Download
		,CAST(null as datetime2(3))							AS Test_Start_Of_Video_Transfer
		,CAST(null as datetime2(3))							AS Test_Start_Of_Video_Playout
		,CAST(null as datetime2(3))							AS Test_End_Of_Video_Transfer
		,CAST(null as datetime2(3))							AS Test_End_Of_Video_Playout
		,CAST(null as float)								AS Test_Video_Stream_Duration_s

		-- ETSI TR 101-578 TIMERS AND PHASES STATUS
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- IP SERVICE ACCESS ACCORDING TO ETSI TS 102 205-1 METHOD A
		-- FROM Test Start TO 1st Data downloaded in DL
		,[IP Service Access]								AS IP_Service_Access_Status
		,"IP Service Access Time [s]"						AS IP_Service_Access_Time_s

		-- SETUP PHASE
		,[Player IP Service Access]							AS Player_IP_Service_Access_Status			
		,[Player Download]									AS Player_Download_Status
		,[Player Session]									AS Player_Session_Status
		,"Player IP Service Access Time [s]"				AS Player_IP_Service_Access_Time_s
		,"Player Download Time [s]"							AS Player_Download_Time_s	
		,"Player Session Time [s]"							AS Player_Session_Time_s

		-- VIDEO PLAY START DELAY (PRESSING "PLAY" TO VIDEO REPRODUCTION)
		,[Video IP Service Access]							AS Video_IP_Service_Access_Status				
		,[Video Reproduction Start]							AS Video_Reproduction_Start_Status				
		,[Video Play Start]									AS Video_Play_Start_Status						
		,"Video IP Service Access Time [s]"					AS Video_IP_Service_Access_Time_s		
		,"Video Reproduction Start Delay [s]"				AS Video_Reproduction_Start_Delay_s
		,"Video Play Start Time [s]"						AS Video_Play_Start_Time_s
		-- TIME TO FIRST PICTURE IS IP_Service_Access_Time + Video_Reproduction_Start_Delay
		,"Video Reproduction Start Delay [s]" + "IP Service Access Time [s]" AS Time_To_First_Picture_s

		-- VIDEO TRANSFER TIME
		-- TIME FROM FIRST DATA TO LAST DOWNLOADED DATA
		-- (IN LIVE STREAM VERY UNRELIABLE)
		,[Video Transfer]									AS Video_Transfer_Status
		,"Video Transfer Time [s]"							AS Video_Transfer_Time_s

		-- VIDEO PLAYOUT
		-- (IN LIVE STREAM VERY UNRELIABLE)
		,[Video Playout]									AS Video_Playout_Status
	    ,"Video Expected Duration [s]"						AS Video_Expected_Duration_Time_s
		,"Video Playout Duration [s]"						AS Video_Playout_Duration_Time_s
		,"Video Playout Cut-off Time [s]"					AS Video_Playout_Cutoff_Time_s

		-- TIME FROM FIRST DATA TO LAST PLAYER SHOWN PICTURE
		-- DEFINES FINAL TEST RESULT 
		-- (IN LIVE STREAM VERY UNRELIABLE)
		,[Video Session]									AS Video_Session_Status
		,"Video Session Time [s]"							AS Video_Session_Time_s

		-- INTEGRITY KPI-s
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		,[qualityIndication]
		,CAST(null as varchar(50))							AS Test_Image_Size
		,CAST(null as float)								AS Test_Minimum_vMOS
		,[qualityIndication]								AS Test_Average_vMOS
		,CAST(null as float)								AS Test_Maximum_vMOS
		,CAST(null as int)									AS Test_Video_Horizontal_Resolution
		,CAST(null as int)									AS Test_Video_Vertical_Resolution
		,CAST(null as float)								AS Test_Video_Frame_Rate_Calc
		,CAST(null as float)								AS Test_Video_Jerkiness
		,CAST(null as float)								AS Test_Video_Black

		-- VIDEO FREEZE
		,[Video Freezing Impairment]						AS Video_Freezeing_Impairment
		,[Video Freeze Occurrences]							AS Video_Freeze_Count
		,"Video Freezing Time Proportion [%]"				AS Video_Freezing_Time_Proportion
		,"Video Maximum Freezing Duration [s]"				AS Video_Longest_Single_Freezing_Duration_Time_s
		,"Accumulated Video Freezing Duration [s]"			AS Video_Accumulated_Freezing_Duration_Time_s

		-- VIDEO SKIP (IN LIVE STREAM VERY UNRELIABLE)
		,[Video Skip Occurrences]							AS Video_Skips_Count
		,"Accumulated Video Skips Duration [s]"				AS Video_Skips_Duration_Time_s

		-- APPLICATION DOWNLOAD STATISTICS (IN LIVE STREAM VERY UNRELIABLE)
		,"Video Expected Size [kbit]"						AS Video_Expected_Size_kbit
		,"Video Downloaded Size [kbit]"						AS Video_Downloaded_Size_kbit
		,"Video Compression Ratio [%]"						AS Video_Compression_Ratio
		,"Video Mean User Data Rate [kbit/s]"				AS Video_Download_Application_MDR_kbit_s

		-- STREAMING TEST EXECUTION PROPERTIES
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Test Exceution Timeouts
		,"Player IP Service Access TimeOut [s]"				AS Timeout_Player_IP_Service_Access_Time_s
		,"Player Download TimeOut [s]"						AS Timeout_Player_Download_Time_s
		,"Video IP Service Access TimeOut [s]"				AS Timeout_Video_IP_Service_Access_Time_s
		,"Video Reproduction Start TimeOut [s]"				AS Timeout_Video_Reproduction_Start_Time_s

		-- FREEZE THRESHOLDS DEFINED FOR TEST
		-- OUTSIDE THOSE THRESHOLDS TEST WILL BE DECLARED AS FAILED 
		--    or in case Minimum_Allowed_Single_Freeze_Duration_ms Freeze will not be detected
		,[Maximum number of freezes]						AS Maximum_Allowed_Number_Of_Freezes
		,"Minimum freeze duration [ms]"						AS Minimum_Allowed_Single_Freeze_Duration_ms
		,"Maximum duration of single freeze [s]"			AS Maximum_Allowed_Single_Freeze_Duration_s
		,"Maximum duration of all freezes [s]"				AS Maximum_Allowed_Duration_Of_All_Freezes_s
into NEW_RESULTS_VS_Youtube_2018 -- select * 
from vETSIYouTubeKPIs
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 successfully created...')

-- UPDATE Host COLLUMN
---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 updating Host Information...')
	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Host = REPLACE(Host,'http://','')
	WHERE Host like 'http://%'

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Host = REPLACE(Host,'https://','')
	WHERE Host like 'https://%'

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Host = SUBSTRING(Host,0,CHARINDEX('/',Host))
	WHERE Host like '%/%'

-- UPDATE Test_Result_Detiled COLLUMN FOR FAILURES BY PHASES
---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 updating failure phases...')
	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Result_Detailed = CASE  WHEN Video_Accumulated_Freezing_Duration_Time_s >= Maximum_Allowed_Duration_Of_All_Freezes_s		THEN 'Accumulated freezing time exceeded Threshold'
									 WHEN Video_Longest_Single_Freezing_Duration_Time_s >= Maximum_Allowed_Single_Freeze_Duration_s		THEN 'Accumulated freezing single time exceeded Threshold'
									 WHEN Video_Freeze_Count >= Maximum_Allowed_Number_Of_Freezes										THEN 'Allowed number of freezing occurances exceeded Threshold'
									 WHEN Player_IP_Service_Access_Status  like 'Failed%' THEN 'Player IP Service Access Failed'
									 WHEN Player_Download_Status		   like 'Failed%' THEN 'Player Download Failed'
									 WHEN Video_IP_Service_Access_Status   like 'Failed%' THEN 'Start of Video Transfer Failed'
									 WHEN Video_Reproduction_Start_Status  like 'Failed%' THEN 'Video Reproduction Start Failed'
									 WHEN Video_Transfer_Status            like 'Failed%' THEN 'Video Transfer Failed'
									 -- WHEN Video_Playout_Status             like 'Failed%' THEN 'Video Playout Failed'
									 ELSE 'OK'
									 END
-- VMOS from Quality Indication
---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 updating Video Quality Information (vMOS)...')
	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Minimum_vMOS = b.TestQualityMin
       ,Test_Average_vMOS = b.TestQualityAvg
       ,Test_Maximum_vMOS = b.TestQualityAvg
	   ,Video_Freezing_Time_Proportion = b.FreezingPercent / 100.0
	FROM NEW_RESULTS_VS_Youtube_2018 a
	LEFT OUTER JOIN ResultsVideoStreamAvg b ON a.SessionID = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Video_Frame_Rate_Calc = b.FrameRateCalc
	   ,Test_Video_Jerkiness = b.Jerkiness
	   ,Test_Video_Black = b.Black
	   ,Video_Downloaded_Size_kbit = 8.0 * b.VideoSize / 1000.00
	FROM NEW_RESULTS_VS_Youtube_2018 a
	LEFT OUTER JOIN ResultsVQ08StreamAvg b ON a.SessionID = b.SessionId and a.TestId = b.TestId

-- UPDATE DATA EXTRACTED FORM ResultsVideoStream
---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 updating Test Result...')
	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Start_Time					  = b.startTime
	FROM NEW_RESULTS_VS_Youtube_2018 a
	LEFT OUTER JOIN TestInfo b on a.SessionID = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Result						  = CASE WHEN b.State like 'Completed' THEN 'Completed'
												 WHEN b.State like 'Dropped%'  THEN 'Cutoff'
												 WHEN b.State like 'Aborted%'  THEN 'Cutoff'
												 WHEN b.State like 'Failed'    THEN 'Failed'
												 ELSE b.State
												 END
	   ,Test_Player						  = b.Player
	   ,Test_Protocol					  = b.Protocol
	   ,Test_Technology					  = b.Technology
	   ,Test_Start_Of_Video_Playout		  = b.StartTime
	   ,Test_Video_Horizontal_Resolution  = b.HorResolution
	   ,Test_Video_Vertical_Resolution	  = b.VerResolution
	FROM NEW_RESULTS_VS_Youtube_2018 a
	LEFT OUTER JOIN ResultsVideoStream b on a.SessionID = b.SessionId and a.TestId = b.TestId

-- UPDATE DATA EXTRACTED FORM vResultsVQTest
---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 updating Events...')
	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Image_Size = b.ImageSize
	   ,Test_First_Packet_Of_Player_Recieved = DATEADD(s,Player_IP_Service_Access_Time_s,Test_Start_Time)
	   ,Test_End_Of_Player_Download = CASE WHEN DATEADD(s,Player_IP_Service_Access_Time_s + Player_Download_Time_s,Test_Start_Time) is not null THEN DATEADD(s,Player_IP_Service_Access_Time_s + Player_Download_Time_s,Test_Start_Time)
										   ELSE DATEADD(s,Player_Session_Time_s,Test_Start_Time)
										   END
	   ,Test_Start_Of_Video_Download = DATEADD(s,Player_IP_Service_Access_Time_s - Video_IP_Service_Access_Time_s,Test_Start_Time)
	   ,Test_Start_Of_Video_Transfer = b.StartRec
	   ,Test_Start_Of_Video_Playout = CASE WHEN b.StreamStartTime is not null then b.StreamStartTime else a.Test_Start_Of_Video_Playout end
	   ,Test_End_Of_Video_Transfer = b.endRec
	   ,Test_End_Of_Video_Playout = b.StreamEndTime
	   ,Test_Video_Stream_Duration_s = 0.001 * b.StreamDuration
	   ,Video_Playout_Duration_Time_s = 0.001 * b.StreamDuration
	   ,Video_Session_Time_s = Video_Play_Start_Time_s + 0.001 * b.StreamDuration
	   ,Video_Session_Status =  CASE WHEN b.StreamDuration is null THEN 'Failed' 
									 ELSE 'Successful' 
									 END
	   ,Video_Transfer_Status = CASE WHEN datediff(ms,b.StartRec,b.endRec) IS NOT NULL THEN 'Successful'
									 ELSE 'Failed'
									 END
	   ,Video_Transfer_Time_s = 0.001 * datediff(ms,b.StartRec,b.endRec)
	FROM NEW_RESULTS_VS_Youtube_2018 a
	LEFT OUTER JOIN vResultsVQTest b on a.SessionID = b.SessionId and a.TestId = b.TestId

-- UPDATE Test_Status FOR FREEZE THERESHOLDS EXCEEDED
---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 updating Video Quality Information (Quality Failures)...')
	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Result = 'Cutoff'
	   ,Video_Session_Status = 'Failed'
	   ,Test_Average_vMOS = null
	   ,Test_Video_Horizontal_Resolution = null
	   ,Test_Video_Vertical_Resolution = null
	WHERE Test_Result_Detailed like 'Accumulated freezing time exceeded Threshold'
			or Test_Result_Detailed like 'Accumulated freezing single time exceeded Threshold'
			or Test_Result_Detailed like 'Allowed number of freezing occurances exceeded Threshold'

-- UPDATE Test_Status FOR FAILED CASES (CLEANUP)
----------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_Youtube_2018 cleanup...')
	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET Test_Average_vMOS = null
	   ,Test_Minimum_vMOS = null
	   ,Test_Maximum_vMOS = null
	   ,Test_Video_Horizontal_Resolution = null
	   ,Test_Video_Vertical_Resolution = null
	   ,Video_Freezeing_Impairment = 'No Freezings'
	   ,Video_Freezing_Time_Proportion = null
	   ,Video_Longest_Single_Freezing_Duration_Time_s = null
	   ,Video_Accumulated_Freezing_Duration_Time_s = null
	   ,Video_Freeze_Count = 0
	   ,Video_Skips_Count = null
	   ,Video_Skips_Duration_Time_s = null
	   ,Video_Expected_Size_kbit = null
	   ,Video_Downloaded_Size_kbit = null
	   ,Video_Compression_Ratio = null
	   ,Video_Download_Application_MDR_kbit_s = null
       ,Test_Video_Frame_Rate_Calc = null
       ,Test_Video_Jerkiness = null
       ,Test_Video_Black = null
	WHERE Test_Result like 'Failed'

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET  Video_Playout_Cutoff_Time_s = 0.001 * b.StreamDuration
		,Video_Download_Application_MDR_kbit_s = Video_Downloaded_Size_kbit / Video_Playout_Duration_Time_s	   
	FROM NEW_RESULTS_VS_Youtube_2018 a
	LEFT OUTER JOIN vResultsVQTest b on a.SessionID = b.SessionId and a.TestId = b.TestId
	WHERE a.Test_Result like 'Cutoff'

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET  Video_Playout_Status = 'Successful'
		,Video_Download_Application_MDR_kbit_s = Video_Downloaded_Size_kbit / Video_Playout_Duration_Time_s	 
	FROM NEW_RESULTS_VS_Youtube_2018 a
	LEFT OUTER JOIN vResultsVQTest b on a.SessionID = b.SessionId and a.TestId = b.TestId
	WHERE a.Test_Result like 'Completed'

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET IP_Service_Access_Status = 'Success'
	WHERE IP_Service_Access_Status like 'Suc%' 

	UPDATE NEW_RESULTS_VS_Youtube_2018
	SET  Test_First_Packet_Of_Player_Recieved		= dateadd(ms,1000*Player_IP_Service_Access_Time_s,Test_Start_Time)
		,Test_End_Of_Player_Download				= dateadd(ms,1000*Player_Session_Time_s,Test_Start_Time)
		,Test_Start_Of_Video_Download               = dateadd(ms,1000*(Time_To_First_Picture_s - Video_Play_Start_Time_s),Test_Start_Time)
		,Test_Start_Of_Video_Transfer				= dateadd(ms,1000*(Time_To_First_Picture_s - Video_Reproduction_Start_Delay_s),Test_Start_Time)
		,Test_Start_Of_Video_Playout				= dateadd(ms,1000*Time_To_First_Picture_s,Test_Start_Time)

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script executed successfully!...')

-- SELECT * FROM NEW_RESULTS_VS_Youtube_2018 WHERE Test_Result is null
