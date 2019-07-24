PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execution...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 beeing created...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RESULTS_http_Browsing_2018' AND type = 'U')	DROP TABLE [NEW_RESULTS_http_Browsing_2018]
SELECT  1 AS Validity
		,cast(null as varchar(50))		AS InvalidReason
		,a.SessionId
		,a.TestId
		,a.Status
		,dbo.GetErrorMsg(ErrorCode,0)	AS ErrorCode_Message
		,'httpBrowser'					AS Test_Type
		,cast(null as varchar(50))		AS Test_Name
		,cast(null as varchar(50))		AS Test_Info
		,'DL'							AS Direction
		,a.host
		,a.url
		,CAST(null as varchar(100))		AS Client_IP_Address
		,CAST(null as varchar(100))		AS Server_First_IP_Address
		,CAST(null as varchar(MAX))		AS IP_Addresses_List
		,a.browser
		,a.size
		,a.numOfImages
		,cast(null as datetime2(3))		AS TestStart
		,CAST(null as datetime2(3))		AS Test_First_DNS_Request
		,CAST(null as datetime2(3))		AS Test_First_DNS_Response
		,CAST(null as datetime2(3))		AS Test_First_TCP_Syn_UL
		,CAST(null as datetime2(3))		AS Test_First_TCP_SynAck_UL
		,CAST(null as datetime2(3))		AS Test_First_PUT_GET_UL
		,CAST(null as datetime2(3))		AS Test_First_200Ok_DL
		,CAST(null as datetime2(3))		AS Test_First_Data_Packet
		,CAST(null as datetime2(3))		AS Test_Last_Data_Packet
		,cast(null as datetime2(3))		AS TestEnd
		,cast(null as bigint)			AS duration_ETSI
		,cast(null as bigint)			AS duration_DataSession
		,CASE WHEN a.throughput > 0 THEN 1000.0 * a.size / a.throughput			
			  END AS duration_2017
		,cast(null as varchar(20))		AS IpServiceAccessStatus
		,cast(null as bigint)			AS IpServiceAccessTime_ms
		,CAST(NULL as int)				AS DNS_Delay_Access_ms
		,CAST(NULL as int)				AS Round_Trip_Time_ms
		,8.0 * a.throughput / 1000.0	AS Throughput_kbit_s
		,a.APN
INTO NEW_RESULTS_http_Browsing_2018
FROM vResultsHTTPBrowserTest a
left outer join TestInfo b on a.SessionId = b.SessionId and a.TestId = b.TestId

UPDATE NEW_RESULTS_http_Browsing_2018
Set Test_Name = CASE 
				--Static web pages	
					WHEN URL LIKE '%Spieglein%'												THEN 'Spieglein'
					WHEN URL LIKE '%NC_IEHTTP_1MB%'											THEN 'Spieglein'
					WHEN URL LIKE '%Kepler_mobile%'											THEN 'Kepler mobile'
					WHEN URL LIKE '%Kepler_Smartphone%'										THEN 'Kepler mobile'
					WHEN URL LIKE '%Kepler/%'												THEN 'Kepler'	 
				--Dynamic web pages
				--International
					WHEN URL LIKE 'http://www.amazon.com'									THEN 'amazon'
					WHEN URL LIKE 'http://m.facebook.com/corrieredellasera'					THEN 'facebook/Corriere'
					WHEN URL LIKE 'http://m.facebook.com/CHIP%'								THEN 'facebook/CHIP'
					WHEN URL LIKE 'https://m.facebook.com//AngelaMerkel'					THEN 'facebook/AngelaMerkel mobile'
					WHEN URL LIKE 'https://m.facebook.com//DFBTeam'							THEN 'facebook/DFBTeam mobile'
					WHEN URL LIKE 'http://m.youtube.com'									THEN 'youtube mobile'
					WHEN URL LIKE 'https://m.youtube.com/'									THEN 'youtube mobile'
					WHEN URL LIKE 'http://www.booking.com'									THEN 'booking'
					WHEN URL LIKE 'http://www.bing.com/'									THEN 'bing'
					WHEN URL LIKE 'http://www.gmx.net/'										THEN 'gmx'
					WHEN URL LIKE 'http://www.gmx.net'										THEN 'gmx'
					WHEN URL LIKE 'https://www.gmx.net/'									THEN 'gmx'
					WHEN URL LIKE 'https://www.gmx.net'										THEN 'gmx'
					WHEN URL LIKE 'http://www.swissqual.com/'								THEN 'swissqual'
					WHEN URL LIKE 'https://de.yahoo.com/'									THEN 'yahoo'
				--Germany
					WHEN URL LIKE 'http://m.chip.de'										THEN 'chip mobile'
					WHEN URL LIKE 'http://m.chip.de/'										THEN 'chip mobile'
					WHEN URL LIKE 'http://www.chip.de/'										THEN 'chip'
					WHEN URL LIKE 'http://www.chip.de'										THEN 'chip'
					WHEN URL LIKE 'https://www.chip.de'										THEN 'chip'
					WHEN URL LIKE 'http://m.spiegel.de'										THEN 'spiegel mobile'
					WHEN URL LIKE 'http://m.spiegel.de/'									THEN 'spiegel mobile'
					WHEN URL LIKE 'http://m.welt.de'										THEN 'welt mobile'
					WHEN URL LIKE 'http://m.welt.de/'										THEN 'welt mobile'
					WHEN URL LIKE 'http://m.bild.de/'										THEN 'bild mobile'
					WHEN URL LIKE 'http://m.ebay.de/'										THEN 'ebay mobile'
					WHEN URL LIKE 'http://m.faz.de/'										THEN 'faz mobile'
					WHEN URL LIKE 'http://web.de/'											THEN 'web.de'
					WHEN URL LIKE 'https://www.amazon.de/'									THEN 'amazon'
					WHEN URL LIKE 'https://www.amazon.de'									THEN 'amazon'
					WHEN URL LIKE 'https://www.instagram.com/'								THEN 'instagram'
					WHEN URL LIKE 'https://www.instagram.com'								THEN 'instagram'
					WHEN URL LIKE 'https://www.google.de/'									THEN 'google'
					WHEN URL LIKE 'https://www.google.de'									THEN 'google'
					WHEN URL LIKE 'http://www.google.de/'									THEN 'google'
					WHEN URL LIKE 'http://www.google.de'									THEN 'google'
					WHEN URL LIKE 'https://de.m.wikipedia.org/wiki/Wikipedia:Hauptseite'	THEN 'wikipedia mobile'
					WHEN URL LIKE 'https://de.m.wikipedia.org/wiki/Europa'					THEN 'wikipedia/europa mobile'
					WHEN URL LIKE 'https://m.ebay-kleinanzeigen.de/'						THEN 'ebay-kleinanzeigen mobile'
				--Austria
					WHEN URL LIKE 'http://orf.at/m/'										THEN 'orf mobile'
					WHEN URL LIKE 'http://orf.at/m//'										THEN 'orf mobile'
					WHEN URL LIKE 'http://mobil.derstandard.at'								THEN 'der standard mobile'	
					WHEN URL LIKE 'http://mobil.derstandard.at/'							THEN 'der standard mobile'	
				--Switzerland	
					WHEN URL LIKE 'http://www.blick.ch'										THEN 'blick'
					WHEN URL LIKE 'http://www.blick.ch/'									THEN 'blick'
					WHEN URL LIKE 'http://m.blick.ch'										THEN 'blick mobile'
					WHEN URL LIKE 'http://m.blick.ch/'										THEN 'blick mobile'
					WHEN URL LIKE 'http://m.20min.ch%'										THEN '20 Minuten mobile'
					WHEN URL LIKE 'http://m.20min.ch/'										THEN '20 Minuten mobile'
					WHEN URL LIKE 'http://m.20min.ch//'										THEN '20 Minuten mobile'
					WHEN URL LIKE 'http://www.20min.ch//'									THEN '20 Minuten mobile'
				--Italia
					WHEN URL LIKE 'http://corriere.it'										THEN 'corriere'
					WHEN URL LIKE 'http://www.corriere.it'									THEN 'corriere'
					WHEN URL LIKE 'http://www.amazon.it'									THEN 'amazon'
					WHEN URL LIKE 'http://www.libero.it'									THEN 'libero'
				--Luxemburg
					WHEN URL LIKE 'http://www.lessentiel.lu/fr/luxembourg/'					THEN 'lessentiel'
					WHEN URL LIKE 'http://www.rtl.lu'										THEN 'rtl'
					WHEN URL LIKE 'http://www.orange.lu/fr'									THEN 'orange'
				--Belgium
					WHEN URL LIKE 'https://fr.m.wikipedia.org/wiki/Europe'					THEN 'wikipedia/europe mobile'
					WHEN URL LIKE 'http://www.hln.be/'										THEN 'hln mobile'
					WHEN URL LIKE 'https://www2.telenet.be/'								THEN 'telenet'
				--Croatia	
					WHEN URL LIKE 'http://www.index.hr/mobile/'								THEN 'index mobile'
					WHEN URL LIKE 'https://www.facebook.hr'									THEN 'facebook'
					WHEN URL LIKE 'https://www.google.hr/'									THEN 'goolge'
					END
		,Test_Info = CASE 
						WHEN URL LIKE '%Spieglein%'								THEN 'Static Webpage'
						WHEN URL LIKE '%Kepler_mobile%'							THEN 'Static Webpage'
						WHEN URL LIKE '%Kepler_smartphone%'						THEN 'Static Webpage'
						WHEN URL LIKE '%Kepler/%'								THEN 'Static Webpage'	
						WHEN URL LIKE 'http://www.%'							THEN 'Dynamic Webpage'
						WHEN URL LIKE 'http://m.%'								THEN 'Dynamic Webpage'
						WHEN URL LIKE 'http://orf.at%'							THEN 'Dynamic Webpage'
						WHEN URL LIKE 'http://de.m.%'							THEN 'Dynamic Webpage'
						WHEN URL LIKE 'http://mobil%'							THEN 'Dynamic Webpage'
						WHEN URL LIKE 'http://amazon%'							THEN 'Dynamic Webpage'
						WHEN URL LIKE 'http://instagram%'						THEN 'Dynamic Webpage'
						WHEN URL LIKE 'https%'									THEN 'Secure Dynamic Webpage'	
						END

UPDATE NEW_RESULTS_http_Browsing_2018
SET  TestStart = b.startTime
	,TestEnd  = dateadd(ms,b.duration,b.startTime)
	,Validity = CASE WHEN b.valid = 0 THEN 0 ELSE a.Validity END
	,InvalidReason = CASE WHEN b.valid = 0 THEN 'SwissQual System Release' ELSE a.InvalidReason END
FROM NEW_RESULTS_http_Browsing_2018 a
LEFT OUTER JOIN TestInfo b ON a.SessionId = b.SessionId and a.TestId = b.TestId

-- HTTP BROWSER TCP SYN IN UL SENT FOR TCP HANDSHAKE IN UL
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update TCP Handshake data started...')
	IF OBJECT_ID ('tempdb..#tcphandshake' ) IS NOT NULL DROP TABLE #tcphandshake
	SELECT   SessionId
			,TestId
			,MIN([TCP_SYN_UL]) AS [TCP_SYN_UL]
			,CAST(NULL AS datetime2(3)) AS [TCP_SYN_ACK_UL]
			,CAST(NULL AS varchar(100)) AS [Client_IP]
			,CAST(NULL AS varchar(100)) AS [Server_IP]
	INTO #tcphandshake
	FROM
		(SELECT SessionId,TestId,KPIID,
			   CASE WHEN KPIID = 10400 Then StartTime 
					WHEN KPIID = 10403 Then StartTime 
					WHEN KPIID = 10404 Then StartTime
					WHEN KPIID = 10406 Then StartTime
					WHEN KPIID = 10407 Then StartTime
					WHEN KPIID = 10408 Then EndTime
					WHEN KPIID = 10410 Then StartTime
				END AS [TCP_SYN_UL]
		FROM ResultsKPI
		WHERE KPIId IN (10400,10403,10404,10406,10407,10408,10410)) AS TCPSYN
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE #tcphandshake
	SET TCP_SYN_ACK_UL = A.EndTime
		,Client_IP = Value3
		,Server_IP = Value4
	FROM
		(SELECT * FROM ResultsKPI WHERE KPIID = 31000) AS A
		RIGHT OUTER JOIN #tcphandshake T ON T.TestId = A.TestId and T.TCP_SYN_UL = A.StartTime

	UPDATE #tcphandshake
	SET TCP_SYN_ACK_UL = A.EndTime
	FROM
		(SELECT * FROM ResultsKPI WHERE KPIID = 31000) AS A
		RIGHT OUTER JOIN #tcphandshake T ON T.TestId = A.TestId
	WHERE T.TCP_SYN_ACK_UL is null

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET  Test_First_TCP_Syn_UL		= a.[TCP_SYN_UL]
		,Test_First_TCP_SynAck_UL	= a.[TCP_SYN_ACK_UL]
		,Client_IP_Address			= a.Client_IP
		,Server_First_IP_Address	= a.Server_IP
		,[Round_Trip_Time_ms] = DATEDIFF(ms,a.[TCP_SYN_UL],a.[TCP_SYN_ACK_UL])
	FROM #tcphandshake a
	RIGHT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET Client_IP_Address = REVERSE( SUBSTRING( REVERSE(Client_IP_Address), CHARINDEX(':',REVERSE(Client_IP_Address)) + 1, LEN(REVERSE(Client_IP_Address))) )
	WHERE Client_IP_Address like '%:%'

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET Server_First_IP_Address = REVERSE( SUBSTRING( REVERSE(Server_First_IP_Address), CHARINDEX(':',REVERSE(Server_First_IP_Address)) + 1, LEN(REVERSE(Server_First_IP_Address))) )
	WHERE Server_First_IP_Address like '%:%'
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update TCP Handshake data completed...')

	-- DNS DELAY AND EVENTS
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update DNS Events and delay stating...')
	UPDATE NEW_RESULTS_http_Browsing_2018
	SET   Test_First_DNS_Request         = a.DNS_1st_Request
		 ,Test_First_DNS_Response        = a.DNS_1st_Response
		 ,DNS_Delay_Access_ms            = a.DNS_1st_Service_Delay_ms
	FROM NEW_DNS_PER_TEST_2018 a
	RIGHT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update DNS Events and delay completed...')

	-- HTTP BROWSER 1st HTTP GET SENT IN UL
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update HTTP GET/PUT events started...')
	IF OBJECT_ID ('tempdb..#httpget' ) IS NOT NULL DROP TABLE #httpget
	SELECT SessionId,TestId,MIN([HTTP_1st_GET_UL]) AS [HTTP_1st_GET_UL]
	INTO #httpget
	FROM
		(SELECT SessionId,TestId,KPIID,
				   CASE WHEN KPIID = 10407 Then EndTime
						WHEN KPIID = 10420 Then EndTime
						WHEN KPIID = 20407 Then StartTime
					END AS [HTTP_1st_GET_UL]
			FROM ResultsKPI
			WHERE KPIId IN (10407,10420,20407) ) AS HTTPGET
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET   Test_First_PUT_GET_UL		= a.[HTTP_1st_GET_UL]
	FROM #httpget a
	RIGHT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId

	-- ETSI TS 102 250-2 - Method A Data transfer start
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update HTTP 1st 200 Ok events started...')
	IF OBJECT_ID ('tempdb..#http1st200Ok' ) IS NOT NULL DROP TABLE #http1st200Ok
	SELECT SessionId,TestId,MIN([HTTP_1st_200Ok_DL]) AS [HTTP_1st_200Ok_DL]
	INTO #http1st200Ok
	FROM
	(SELECT SessionId,TestId,KPIID,
				   CASE WHEN KPIID = 10400 Then EndTime
						WHEN KPIID = 10403 Then EndTime
						WHEN KPIID = 20400 Then StartTime
						WHEN KPIID = 20403 Then StartTime
						WHEN KPIID = 20405 Then StartTime
					END AS [HTTP_1st_200Ok_DL]
			FROM ResultsKPI
			WHERE KPIId IN (10400,10403,20400,20403,20405) ) AS HTTP200Ok
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET   Test_First_200Ok_DL		= a.[HTTP_1st_200Ok_DL]
	FROM #http1st200Ok a
	RIGHT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId

	-- HTTP BROWSER 1st HTTP Application Data RECIEVED IN DL
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update HTTP 1st Data Recieved event started...')
	IF OBJECT_ID ('tempdb..#http1stData' ) IS NOT NULL DROP TABLE #http1stData
	SELECT SessionId,TestId,MIN([HTTP_1st_Data_DL]) AS [HTTP_1st_Data_DL]
	INTO #http1stData
	FROM
	(SELECT SessionId,TestId,KPIID,
					CASE WHEN KPIID = 10404 Then EndTime
						WHEN KPIID = 10406 Then EndTime
						WHEN KPIID = 20404 Then StartTime
					END AS [HTTP_1st_Data_DL]
		FROM ResultsKPI
		WHERE KPIId IN (10404,10406,20404) ) AS HTTP1stData
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET   Test_First_Data_Packet		= a.[HTTP_1st_Data_DL]
	FROM #http1stData a
	RIGHT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId

	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update HTTP 1st Data Recieved event completed...')

	-- HTTP BROWSER LAST HTTP Application Data RECIEVED IN DL
	-- ETSI TS 102 250-2 - Method A and B Data transfer completion
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update HTTP Last Data Recieved event started...')
	IF OBJECT_ID ('tempdb..#httpLastData' ) IS NOT NULL DROP TABLE #httpLastData
	SELECT SessionId,TestId,MAX([HTTP_Last_Data_DL]) AS [HTTP_Last_Data_DL]
	INTO #httpLastData
	FROM
	(SELECT SessionId,TestId,KPIID,
					CASE WHEN KPIID = 10410 Then EndTime
						WHEN KPIID = 20400 Then EndTime
						WHEN KPIID = 20404 Then EndTime
						WHEN KPIID = 20405 Then EndTime
						WHEN KPIID = 20407 Then EndTime
					END AS [HTTP_Last_Data_DL]
		FROM ResultsKPI
		WHERE KPIId IN (10410,20400,20404,20405,20407) ) AS HTTPLastData
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET   Test_Last_Data_Packet		= a.[HTTP_Last_Data_DL]
	FROM #httpLastData a
	RIGHT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update HTTP Last Data Recieved event completed...')

	-- IP SERVICE_ACCESS UPDATE
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update IP Access Time starting...')
	UPDATE NEW_RESULTS_http_Browsing_2018
	SET IpServiceAccessTime_ms = CASE WHEN DATEDIFF(ms,TestStart,Test_First_Data_Packet) is not null THEN DATEDIFF(ms,TestStart,Test_First_Data_Packet)
													   ELSE DATEDIFF(ms,TestStart,Test_First_200Ok_DL)
													   END
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update IP Access Time completed...')

	-- BROWSING TEST RESULTS
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update test results starting...')
	UPDATE NEW_RESULTS_http_Browsing_2018
	SET  Status								= CASE WHEN Status like 'Successful' THEN 'Completed'
														   WHEN Status not like 'Successful' and size > 0 THEN 'Cutoff'
														   ELSE 'Failed'
														   END 
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update test results completed...')

	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update with all IP-s started')
	IF OBJECT_ID ('tempdb..#Servers' ) IS NOT NULL DROP TABLE #Servers
	SELECT DISTINCT [SessionId]
		  ,[TestId]
		  ,[IP]
	  INTO #Servers
	  FROM 
		(SELECT DISTINCT [SessionId]
			  ,[TestId]
			  ,[src] as IP
		  FROM [MsgEthereal]
		  WHERE TestId <> 0 AND Protocol not like 'DNS'
		  UNION ALL
		  SELECT DISTINCT [SessionId]
			  ,[TestId]
			  ,[DST] as IP
		  FROM [MsgEthereal]
		  WHERE TestId <> 0 AND Protocol not like 'DNS'  ) AS T

	IF OBJECT_ID ('tempdb..#ips' ) IS NOT NULL DROP TABLE #ips
	SELECT [SessionId]
		  ,[TestId]
		  ,STUFF(
			 (SELECT DISTINCT ', ' + [IP]
			  FROM #Servers
			  WHERE TestId = a.TestId AND SessionId = a.SessionId
			  FOR XML PATH (''))
			  , 1, 1, '')  AS IP_List
	INTO #ips
	FROM #Servers AS a
	GROUP BY [SessionId],[TestId]

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET  IP_Addresses_List = a.IP_List
	FROM #ips a
	RIGHT OUTER JOIN NEW_RESULTS_http_Browsing_2018 b on a.SessionId = b.SessionId and a.TestId = b.TestId
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Browsing_2018 update with all IP-s completed')

	-- SET IP SERVICE ACCESS RESULT
	UPDATE NEW_RESULTS_http_Browsing_2018
	SET IpServiceAccessStatus = CASE WHEN Status like 'Completed' THEN 'Success'
									 WHEN Status like 'Cutoff' THEN 'Success'
									 WHEN Status like 'Failed' THEN 'Failed'
									 END

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET duration_ETSI = CASE WHEN datediff(ms,TestStart,Test_Last_Data_Packet) is not null THEN datediff(ms,TestStart,Test_Last_Data_Packet)
						ELSE datediff(ms,TestStart,TestEnd)
						END,
	    duration_DataSession = CASE WHEN datediff(ms,Test_First_TCP_Syn_UL,Test_Last_Data_Packet) is not null THEN datediff(ms,Test_First_TCP_Syn_UL,Test_Last_Data_Packet)
									END

	-- CLEANUP
	UPDATE NEW_RESULTS_http_Browsing_2018
	SET 
		 Server_First_IP_Address  = null
		,IP_Addresses_List        = null
		,duration_ETSI			  = null
		,duration_DataSession	  = null
		,duration_2017			  = null
		,size                     = null
		,numOfImages              = null
		,Test_First_200Ok_DL      = null
		,Test_First_Data_Packet   = null
		,Test_Last_Data_Packet    = null
		,IpServiceAccessTime_ms   = null
		,Round_Trip_Time_ms       = null
		,Throughput_kbit_s        = null
	WHERE Status like  'Failed'

	UPDATE NEW_RESULTS_http_Browsing_2018
	SET 
		 duration_ETSI			  = null
		,duration_DataSession	  = null
		,duration_2017			  = null
		,size                     = null
		,numOfImages              = null
		,Throughput_kbit_s        = null
	WHERE Status <> 'Completed'

-- select Test_Name,
-- 	   master.dbo.Quantil(duration_ETSI,0.1) as P10_Option1,
-- 	   master.dbo.Quantil(duration_DataSession,0.1) as P10_Option2,
-- 	   master.dbo.Quantil(duration_2017,0.1) as P10_Option3,
-- 	  avg(duration_ETSI) as AVG_Option1,
-- 	  avg(duration_DataSession) as AVG_Option2,
-- 	  avg(duration_2017) as AVG_Option3,
-- 	   master.dbo.Quantil(duration_ETSI,0.9) as P90_Option1,
-- 	   master.dbo.Quantil(duration_DataSession,0.9) as P90_Option2,
-- 	   master.dbo.Quantil(duration_2017,0.9) as P90_Option3
--  from NEW_RESULTS_http_Browsing_2018 
--  group by Test_Name
--  Order by Test_Name

-- select * from NEW_RESULTS_http_Browsing_2018 Order by SessionId,TestId
