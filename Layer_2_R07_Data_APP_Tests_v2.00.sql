PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execution...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 beeing created...')

-- SELECT APPLICATION TESTS
-- MULTIPLE POSSIBLE SOURCES BETWEEN DIFFERENT DB VERSIONS
IF OBJECT_ID ('tempdb..#AppTests' ) IS NOT NULL DROP TABLE #AppTests
CREATE TABLE #AppTests (SessionId bigint,TestId bigint)

IF EXISTS(SELECT name FROM sysobjects WHERE name = N'ResultsAppActionSocialMedia' AND type = 'U')	-- 17.x DB Type
	BEGIN
		INSERT INTO #AppTests(SessionId,TestId)
		SELECT SessionId,TestId FROM ResultsAppActionSocialMedia
	END

IF EXISTS(SELECT name FROM sysobjects WHERE name = N'ResultsAppAction' AND type = 'U')				-- 16.x DB Type
	BEGIN
		INSERT INTO #AppTests(SessionId,TestId)
		SELECT SessionId,TestId FROM ResultsAppAction
	END

IF EXISTS(SELECT name FROM sysobjects WHERE name = N'ResultsAppTestParameters' AND type = 'U')		-- both 16.x and 17.x DB Type
	BEGIN
		INSERT INTO #AppTests(SessionId,TestId)
		SELECT SessionId,TestId FROM ResultsAppTestParameters
	END

-- CREATE RESULTS TABLE
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RESULTS_SOCIAL_MEDIA_2018' AND type = 'U')	DROP TABLE NEW_RESULTS_SOCIAL_MEDIA_2018
	SELECT DISTINCT
		 CAST(1 as int)     				AS      Validity
		,CAST(null as varchar(50 ))			AS      InvalidReason
		,SessionId
		,TestId
		,'Application'     					AS      Test_Type
		,CAST(null as varchar(50))     		AS      Test_Name
		,CAST(null as varchar(100))     	AS      Test_Info
		,CAST(null as varchar(2))     		AS      Direction
		,CAST(null as varchar(50 ))     	AS      ServiceProvider
		,CAST(null as varchar(8000 ))		AS      ActionName
		,CAST(null as varchar(200))     	AS      FileName
		,CAST(null as varchar(20))     		AS      Test_Result
		,CAST(null as varchar(100))     	AS      ErrorCode_Message
		,CAST(null as varchar(max ))     	AS      Client_IPs
		,CAST(null as varchar(200 ))		AS      DNS_Client_IPs
		,CAST(null as varchar(200 ))		AS      DNS_Server_IPs
		,CAST(null as varchar(max))     	AS      Server_IPs
		,CAST(null as bigint)     			AS      Threads_Count
		,CAST(null as varchar(max))     	AS      Threads_Per_Server
		,CAST(null as datetime2(3))     	AS      StartTime
		,CAST(null as datetime2(3))     	AS      DNS_1st_Request
		,CAST(null as datetime2(3))     	AS      DNS_1st_Response
		,CAST(null as varchar(max))     	AS      DNS_Hosts_List
		,CAST(null as datetime2(3))     	AS      IP_Serv_End
		,CAST(null as datetime2(3))     	AS      EndTime
		,CAST(null as varchar(20))     		AS      IP_Server_Access_Result
		,CAST(null as bigint)     			AS      IP_Service_Access_Time_ms
		,CAST(null as bigint)     			AS      RTT_ms
		,CAST(null as bigint)     			AS      DNS_1st_Service_Delay_ms
		,CAST(null as int)     				AS      Transfer_Time_ms
		,CAST(null as bigint)     			AS      File_Size_bytes
	INTO NEW_RESULTS_SOCIAL_MEDIA_2018
	FROM #AppTests

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with events...')
	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET EndTime = DATEADD(ms,b.duration,b.startTime)
	   ,StartTime = b.startTime
	FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
	LEFT OUTER JOIN TestInfo b on a.TestId=b.TestId 
	
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with test properties...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'ResultsAppTestParameters' AND type = 'U')
	BEGIN
		UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		SET ServiceProvider		= b.ServiceProvider
		   ,ActionName			= b.ActionNames
		FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
		LEFT OUTER JOIN ResultsAppTestParameters b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	END
	
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with results v17.x SQ...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'ResultsAppActionSocialMedia' AND type = 'U')
	BEGIN
		UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		SET Transfer_Time_ms		= case when a.Transfer_Time_ms is null then b.CoreDuration
											else a.Transfer_Time_ms
											end
		   ,StartTime				= case when a.StartTime is null then b.StartTime
											else a.StartTime
											end
		   ,File_Size_bytes			= case when b.FileSize > 0 then b.FileSize
											else a.File_Size_bytes
											end
		   ,FileName				= case when a.FileName is not null then a.FileName
											else b.FileName collate Latin1_General_CI_AS
											end
		   ,Test_Result				= case when a.Test_Result is not null then a.Test_Result
										   when b.ErrorCode <> 0 and b.ErrorCode is not null then 'Failed'
		   								   when b.ErrorCode = 0 then 'Completed'
		   								   end
		   ,ErrorCode_Message		 = case when b.ErrorCode is not null then dbo.GetErrorMsg(ErrorCode,0)
										    else a.ErrorCode_Message
											end
		   ,IP_Server_Access_Result  = case when a.Test_Result is not null then a.Test_Result
										   when b.ErrorCode <> 0 and b.ErrorCode is not null then 'Failed'
		   								   when b.ErrorCode = 0 then 'Success'
		   								   end
		FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
		LEFT OUTER JOIN ResultsAppActionSocialMedia b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	END
	
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with results v16.x SQ...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'ResultsAppAction' AND type = 'U')
	BEGIN
		UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		SET Transfer_Time_ms		= case when a.Transfer_Time_ms is null then b.Duration
											else a.Transfer_Time_ms
											end
		   ,Test_Result				= case when a.Test_Result is not null then a.Test_Result
										   when b.ErrorCode <> 0 and b.ErrorCode is not null then 'Failed'
		   								   when b.ErrorCode = 0 then 'Completed'
		   								   end
		   ,IP_Server_Access_Result  = case when a.Test_Result is not null then a.Test_Result
										   when b.ErrorCode <> 0 and b.ErrorCode is not null then 'Failed'
		   								   when b.ErrorCode = 0 then 'Success'
		   								   end
		   ,ErrorCode_Message		 = case when b.ErrorCode is not null then dbo.GetErrorMsg(ErrorCode,0)
										    else a.ErrorCode_Message
											end
		   ,File_Size_bytes			= case when a.File_Size_bytes > 0 then a.File_Size_bytes
										   when b.BytesTransferred > 0 then b.BytesTransferred
										   else null
										   end
		FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
		LEFT OUTER JOIN ResultsAppAction b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with Whatsapp E2E FDFS Transfer...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'ResultsAppActionMessaging' AND type = 'U')
	BEGIN
		IF OBJECT_ID ('tempdb..#whatsappMsg' ) IS NOT NULL DROP TABLE #whatsappMsg
		select a.SessionId
			  ,a.TestId
			  ,b.typeoftest
			  ,a.Identifier
			  ,a.ErrorCode
			  ,b.StartTime AS TestStart
			  ,a.StartTime As FileTransferStart
			  ,dateadd(ms,a.Duration,a.StartTime) as FileTransferComplete
			  ,dateadd(ms,b.Duration,b.StartTime) as TestEnd
			  ,a.FileName
			  ,CASE a.MessagingType
					WHEN 1 THEN 'Text'
					WHEN 2 THEN 'Sticker'
					WHEN 3 THEN 'Photo'
					WHEN 4 THEN 'Audio'
					WHEN 5 THEN 'Video'
					END AS MsgType
			  ,CASE a.Direction
					WHEN 0 THEN 'Send'
					WHEN 1 THEN 'Recieve'
					END AS Direction
			  ,a.FileSize 
			  ,a.Duration
		 into #whatsappMsg
		 from ResultsAppActionMessaging a
		 left outer join testinfo b on a.SessionId = b.SessionId and a.TestId = b.TestId
		 where a.MessagingType = 3

		 UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		 SET Transfer_Time_ms		= case when a.Transfer_Time_ms is null then b.Duration
											else a.Transfer_Time_ms
											end
		   ,Test_Result				= case when a.Test_Result is not null then a.Test_Result
										   when b.ErrorCode <> 0 and b.ErrorCode is not null then 'Failed'
		   								   when b.ErrorCode = 0 then 'Completed'
		   								   end
		   ,IP_Server_Access_Result  = case when a.Test_Result is not null then a.Test_Result
										   when b.ErrorCode <> 0 and b.ErrorCode is not null then 'Failed'
		   								   when b.ErrorCode = 0 then 'Success'
		   								   end
		   ,ErrorCode_Message		 = case when b.ErrorCode is not null then dbo.GetErrorMsg(ErrorCode,0)
										    else a.ErrorCode_Message
											end
		   ,File_Size_bytes			= case when a.File_Size_bytes > 0 then a.File_Size_bytes
										   when b.FileSize > 0 then b.FileSize
										   else null
										   end
		   ,FileName		        = case when b.FileName is not null then b.FileName collate SQL_Latin1_General_CP1_CI_AS
										    else a.FileName
											end
		 FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
		 LEFT OUTER JOIN #whatsappMsg b on a.SessionId = b.SessionId and a.TestId = b.TestId
 END

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 preprocessing...')
	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET 
		Test_Name = CASE 
						WHEN ServiceProvider='Dropbox'	and ActionName like '%Upload%'			THEN  'FDFS Dropbox UL ST'
						WHEN ServiceProvider='Dropbox'	and ActionName like '%Create%'			THEN  'FDFS Dropbox UL ST'
						WHEN ServiceProvider='Dropbox'	and ActionName like '%Post%'			THEN  'FDFS Dropbox UL ST'
						WHEN ServiceProvider='Dropbox'	and ActionName like '%Download%'		THEN  'FDFS Dropbox DL ST'
						WHEN ServiceProvider='Facebook'	and ActionName like '%Upload%'			THEN  'FDFS Facebook UL ST' 
						WHEN ServiceProvider='Facebook'	and ActionName like '%Create%'			THEN  'FDFS Facebook UL ST'
						WHEN ServiceProvider='Facebook'	and ActionName like '%Post%'			THEN  'FDFS Facebook UL ST' 
						WHEN ServiceProvider='Facebook'	and ActionName like '%Download%'		THEN  'FDFS Facebook DL ST'
						WHEN ServiceProvider='Instagram'	and ActionName like '%Upload%'		THEN  'FDFS Instagram UL MT' 
						WHEN ServiceProvider='Instagram'	and ActionName like '%Create%'		THEN  'FDFS Instagram UL MT'
						WHEN ServiceProvider='Instagram'	and ActionName like '%Post%'		THEN  'FDFS Instagram UL MT' 
						WHEN ServiceProvider='Instagram'	and ActionName like '%Download%'	THEN  'FDFS Instagram DL MT' 
						WHEN ServiceProvider='WhatsApp'	and ActionName like '%Upload%'			THEN  'FDFS WhatsApp UL' 
						WHEN ServiceProvider='WhatsApp'	and ActionName like '%Create%'			THEN  'FDFS WhatsApp UL'
						WHEN ServiceProvider='WhatsApp'	and ActionName like '%Post%'			THEN  'FDFS WhatsApp UL' 
						WHEN ServiceProvider='WhatsApp'	and ActionName like '%Send%'			THEN  'FDFS WhatsApp UL' 
						WHEN ServiceProvider='WhatsApp'	and ActionName like '%Download%'		THEN  'FDFS WhatsApp DL' 
						WHEN ServiceProvider='WhatsApp'	and ActionName like '%Receive%'			THEN  'FDFS WhatsApp DL' 
						END
		,Test_Info = CASE 
						WHEN ServiceProvider='Dropbox'		and ActionName like '%Upload%'		    THEN  'Dropbox Upload File'
						WHEN ServiceProvider='Dropbox'		and ActionName like '%Create%'		    THEN  'Dropbox Upload File'
						WHEN ServiceProvider='Dropbox'		and ActionName like '%Post%'		    THEN  'Dropbox Upload File'
						WHEN ServiceProvider='Dropbox'		and ActionName like '%Download%'	    THEN  'Dropbox Download File'
						WHEN ServiceProvider='Facebook'		and ActionName like '%Upload%'		    THEN  'Social Media Create Picture Post' 
						WHEN ServiceProvider='Facebook'		and ActionName like '%Create%'		    THEN  'Social Media Create Picture Post'
						WHEN ServiceProvider='Facebook'		and ActionName like '%Post%'		    THEN  'Social Media Create Picture Post' 
						WHEN ServiceProvider='Facebook'		and ActionName like '%Download%'	    THEN  'Social Media Download Post' 
						WHEN ServiceProvider='Instagram'	and ActionName like '%Upload%'			THEN  'Social Media Create Picture Post' 
						WHEN ServiceProvider='Instagram'	and ActionName like '%Create%'			THEN  'Social Media Create Picture Post'
						WHEN ServiceProvider='Instagram'	and ActionName like '%Post%'			THEN  'Social Media Create Picture Post' 
						WHEN ServiceProvider='Instagram'	and ActionName like '%Download%'		THEN  'Social Media Download Post' 
						WHEN ServiceProvider='WhatsApp'		and ActionName like '%Upload%'			THEN  'WhatsApp Sending Picture' 
						WHEN ServiceProvider='WhatsApp'		and ActionName like '%Create%'			THEN  'WhatsApp Sending Picture'
						WHEN ServiceProvider='WhatsApp'		and ActionName like '%Post%'			THEN  'WhatsApp Sending Picture' 
						WHEN ServiceProvider='WhatsApp'		and ActionName like '%Send%'			THEN  'WhatsApp Sending Picture' 
						WHEN ServiceProvider='WhatsApp'		and ActionName like '%Download%'		THEN  'WhatsApp Recieving Picure' 
						WHEN ServiceProvider='WhatsApp'		and ActionName like '%Receive%'			THEN  'WhatsApp Recieving Picure' 
						END
		,Direction = CASE 
						WHEN ActionName like '%Upload%'		THEN  'UL'
						WHEN ActionName like '%Create%'		THEN  'UL'
						WHEN ActionName like '%Post%'		THEN  'UL'
						WHEN ActionName like '%Download%'	THEN  'DL'
						WHEN ActionName like '%Upload%'		THEN  'UL' 
						WHEN ActionName like '%Create%'		THEN  'UL'
						WHEN ActionName like '%Post%'		THEN  'UL' 
						WHEN ActionName like '%Send%'		THEN  'UL' 
						WHEN ActionName like '%Download%'	THEN  'DL'  
						WHEN ActionName like '%Receive%'	THEN  'DL'
						END
						
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with DNS INFO...')
	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET    [DNS_1st_Request]		  = b.[DNS_1st_Request]		 
		  ,[DNS_1st_Response]		  = b.[DNS_1st_Response]		 
		  ,[DNS_1st_Service_Delay_ms] = b.[DNS_1st_Service_Delay_ms]
		  ,DNS_Hosts_List			  = b.DNS_Hosts_List
		  ,[DNS_Client_IPs]			  = b.[DNS_Client_IPs]
		  ,[DNS_Server_IPs]			  = b.[DNS_Server_IPs]
	FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
	LEFT OUTER JOIN NEW_DNS_PER_TEST_2018 b on a.TestId=b.TestId 

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with RTT...')
	IF OBJECT_ID ('tempdb..#AppRtt' ) IS NOT NULL DROP TABLE #AppRtt
	SELECT [SessionId]
			,[TestId]
			,[KPIId]
			,MIN([StartTime])		AS TimeStamp
			,CAST(null as bigint)	AS RTT_ms
		INTO #AppRtt
		FROM [ResultsKPI]
		WHERE TestId in (select TestId from NEW_RESULTS_SOCIAL_MEDIA_2018) and KPIId = 31000
		GROUP BY [SessionId],[TestId],[KPIId]

	IF OBJECT_ID ('tempdb..#AppRttRaw' ) IS NOT NULL DROP TABLE #AppRttRaw
	SELECT [SessionId]
			,[TestId]
			,[KPIId]
			,[StartTime]
			,[Duration]
			,[ErrorCode]
		INTO #AppRttRaw
		FROM [ResultsKPI]
		WHERE TestId in (select TestId from NEW_RESULTS_SOCIAL_MEDIA_2018) and KPIId = 31000

	UPDATE #AppRtt
	SET RTT_ms = case when [ErrorCode] = 0 then b.Duration else null end
	FROM #AppRtt a
	LEFT OUTER JOIN #AppRttRaw b on a.SessionId = b.SessionId and a.TestId = b.TestId and a.TimeStamp = b.StartTime

	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET RTT_ms = b.RTT_ms
	FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
	LEFT OUTER JOIN #AppRtt b on a.TestId=b.TestId 

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with IP address information...')
	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET Client_IPs = b.CLIENT_IPs
	   ,Server_IPs = b.Server_IPs
	   ,Threads_Count = b.Threads_Count
	   ,Threads_Per_Server = b.Threads_Per_Server
	FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
	LEFT OUTER JOIN NEW_RESULTS_IP_2018 b on a.TestId=b.TestId 

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_SOCIAL_MEDIA_2018 updated with IP Service Access Time...')
	IF OBJECT_ID ('tempdb..#IpSrv' ) IS NOT NULL DROP TABLE #IpSrv
	select   SessionId,TestId
			,Min(MsgTime) as start
			,cast(null as datetime2(3)) as IPServiceDone
	INTO #IpSrv
	from [MsgEthereal] 
	where testid in (select TestId from NEW_RESULTS_SOCIAL_MEDIA_2018) and msg like '%Hello'
	GROUP BY SessionId,TestId

	IF OBJECT_ID ('tempdb..#IpSrvEnd' ) IS NOT NULL DROP TABLE #IpSrvEnd
	SELECT a.SessionId,a.TestId,MIN(a.MsgTime) as IP_Srv_End
	INTO #IpSrvEnd
	FROM [MsgEthereal] a
	LEFT OUTER JOIN #IpSrv b ON a.MsgTime > b.start
	where a.testid in (Select TestId from #IpSrv) and direction = 0 and (msg like 'Application Data%' or msg like 'TLS Traffic%')
	Group By a.SessionId,a.TestId

	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET IP_Serv_End = b.IP_Srv_End
	   ,IP_Service_Access_Time_ms = DATEDIFF(ms,a.StartTime,b.IP_Srv_End)
	FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
	LEFT OUTER JOIN #IpSrvEnd b on a.TestId=b.TestId 

	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET IP_Service_Access_Time_ms = null
	WHERE IP_Service_Access_Time_ms < RTT_ms or IP_Service_Access_Time_ms < DNS_1st_Service_Delay_ms OR IP_Service_Access_Time_ms < (RTT_ms + DNS_1st_Service_Delay_ms)

	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET  Validity = CASE WHEN b.valid = 0 THEN 0 ELSE a.Validity END
		,InvalidReason = CASE WHEN b.valid = 0 THEN 'SwissQual System Release' ELSE a.InvalidReason END
	FROM NEW_RESULTS_SOCIAL_MEDIA_2018 a
	LEFT OUTER JOIN TestInfo b ON a.SessionId = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		SET Validity = 0, InvalidReason = 'SQ Processing Failure'
	WHERE Test_Result is null and Test_Name not like '%whatsapp%'

	-- invalidate after AFC --
	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		SET Validity = 0, InvalidReason = 'SQ Processing Failure'
	from NEW_RESULTS_SOCIAL_MEDIA_2018 sm
	join NC_FailureClassification_Automatic_D fc on sm.TestId=fc.TESTID
	WHERE Test_Result is null and Test_Name like '%whatsapp%' and fc.valid=0

/*
	-- set test status after AFC --
	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		SET Test_Result = 'Completed'
	from NEW_RESULTS_SOCIAL_MEDIA_2018 sm
	join NC_FailureClassification_Automatic_D fc on sm.TestId=fc.TESTID
	WHERE Test_Result is null and Test_Name like '%whatsapp%' and fc.valid=1 and FAILURE_CLASS is null and comment like '%successful%'
*/
	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
		SET Test_Result = 'Failed'
	from NEW_RESULTS_SOCIAL_MEDIA_2018 sm
	join NC_FailureClassification_Automatic_D fc on sm.TestId=fc.TESTID
	WHERE Test_Result is null and Test_Name like '%whatsapp%' and fc.valid=1 and ErrorCode_Message is null

	-- invalidate whatsapp generic or initializatio failures --
	update NEW_RESULTS_SOCIAL_MEDIA_2018 
		set Validity = 0,
			InvalidReason = 'Generic or Initialization failure',
			test_result = NULL 

	from NEW_RESULTS_SOCIAL_MEDIA_2018
	where validity=1 
	and testid in 
	(
		227633266749,227633266811,227633266873,124554051636,124554051698,124554051760,124554051822,244813136057,176093659259,176093659322,98784247931,98784248055,270582939709,270582939761,270582939823,279172874301,811748818996,708669603902,
		708669603964,708669604026,682899800126,682899800187,966367641662,966367641723,923417968763,219043332157,219043332219,219043332281,115964117109,115964117171,734439407678,734439407740,734439407802,115964117234,141733920829,141733920892,
		141733920953,244813135933,244813135995,167503724667,167503724729,176093659197,90194313339,90194313391,90194313449,785979015344,785979015406,38654705725,38654705788,785979015229,923417968825,536870912124,536870912185,794568950007,
		639950127228,639950127289,639950127352,450971566266,691489734841,304942678263,450971566142,511101108347,511101108409,296352743548,296352743601,579820585022,579820585084,579820585145,768799146169,450971566327,450971566389,304942678077,
		304942678139,304942678201,785979015292,502511173755,502511173817,296352743485,279172874363,279172874426,296352743664,296352743725,605590389045,614180323513,12884902011,12884902067,64424509501,64424509564,562640715900,562640715962,528280977532,
		528280977593,536870912061,614180323567,614180323629,768799146045,768799146107,554050781246,554050781308,554050781370,605590388798,605590388860,605590388921,605590388983,322122547261,330712481853,330712481915,450971566203,115964117047,794568949822,
		794568949883,794568949946,528280977469,657129996350,657129996411,657129996473,322122547324,914828034171,167503724606,21474836603,21474836665,914828034233,974957576315,201863462973,201863463036,201863463097,708669604088,717259538493,717259538555,
		90194313277,64424509625,811748819224,811748819286,631360192759,639950127166,717259538617,811748819053,631360192573,631360192635,871878361211,193273528381,193273528444,193273528506,682899800249,691489734718,691489734779,966367641785,974957576253,
		974957576377,760209211453,631360192698,863288426619,863288426671,871878361149,863288426557,760209211516,760209211577,880468295803,880468295865
	)


	UPDATE NEW_RESULTS_SOCIAL_MEDIA_2018
	SET 
		 RTT_ms											= null
		,Transfer_Time_ms								= null
		,IP_Service_Access_Time_ms						= null
	WHERE Test_Result like 'Failed'

-- select * from NEW_RESULTS_SOCIAL_MEDIA_2018 ORDER BY SessionId,TestId
-- select * from ResultsAppActionMessaging ORDER BY SessionId,TestId
