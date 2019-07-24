/*******************************************************************************/
/****** Creates NEW_RESULTS_http_Transfers_2018                          ******/
/****** Author: Tomislav Miksa                                            ******/
/****** v1.00: initial table from where all others are built              ******/
/*******************************************************************************/
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'FileSize') AND xtype IN (N'FN', N'IF', N'TF') ) DROP FUNCTION FileSize
go
create function dbo.FileSize
(@String_in nvarchar(100))
returns bigint
as
begin
declare @NumberStr nvarchar(100), @Number_out bigint
SET @NumberStr = SUBSTRING(@String_in,1,charindex('.',@String_in) - 1 )
SET @NumberStr = REPLACE(REPLACE(@NumberStr,'mb','000000'),'gb','000000000')
SET @NumberStr = REPLACE(REPLACE(@NumberStr,'MB','000000'),'GB','000000000')
return CAST(@NumberStr as bigint)
end
go

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 beeing created...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RESULTS_http_Transfers_2018' AND type = 'U')	DROP TABLE [NEW_RESULTS_http_Transfers_2018]
CREATE TABLE NEW_RESULTS_http_Transfers_2018 (Validity					int
											 ,InvalidReason				varchar(50)
											 ,SessionId					bigint not null
											 ,TestId					bigint not null
											 ,Status					varchar(20)
											 ,ErrorCode_Message			varchar(100)
											 ,Test_Type					varchar(20)
											 ,Test_Name					varchar(20)
											 ,Test_Info					varchar(200)
											 ,Direction					varchar(5)
											 ,host						varchar(255)
											 ,url						varchar(255)
											 ,Client_IP_Address			varchar(100)
											 ,Server_First_IP_Adress	varchar(100)
											 ,IP_Addresses_List			varchar(max)
											 ,LocalFilename				varchar(255)
											 ,RemoteFilename			varchar(255)
											 ,FileSizeBytes				bigint
											 ,BytesTransferred			bigint
											 ,TestStart					datetime2(3)
											 ,DNS_1st_Request			datetime2(3)
											 ,DNS_1st_Response			datetime2(3)
											 ,TCP_SYN_UL				datetime2(3)
											 ,TCP_SYNACK_UL				datetime2(3)
											 ,HTTP_1st_Data				datetime2(3)
											 ,HTTP_last_Data			datetime2(3)
											 ,TestEnd					datetime2(3)
											 ,IpServiceAccessStatus		varchar(20)
											 ,IpServiceAccessTime_ms	bigint
											 ,DNS_Delay_Access_ms		bigint
											 ,Round_Trip_Time_ms		bigint
											 ,Throughput_kbit_s			float
											 ,duration					bigint
											 ,Operation					varchar(20)
											 ,APN						varchar(100))

-- SINGLE THREAD DL
INSERT INTO NEW_RESULTS_http_Transfers_2018(SessionId,TestId,Status,ErrorCode_Message,Test_Type,Test_Name,Direction,url,LocalFilename,RemoteFilename,FileSizeBytes,BytesTransferred,Throughput_kbit_s,duration,Operation,APN)
SELECT SessionId
	  ,TestId
	  ,Status
	  ,CAST (dbo.GetErrorMsg(ErrorCode,0)	AS VARCHAR (100)) as ErrorCode_Message
	  ,'httpTransfer'		AS Test_Type
	  ,CASE WHEN  (CASE WHEN host like '%/' THEN 1000000000 ELSE dbo.FileSize(REVERSE(SUBSTRING(REVERSE(host),1,CHARINDEX('/',REVERSE(host),1)-1)))	End )  > 100000000	THEN 'FDTT http DL ST'
			WHEN  (CASE WHEN host like '%/' THEN 1000000000 ELSE dbo.FileSize(REVERSE(SUBSTRING(REVERSE(host),1,CHARINDEX('/',REVERSE(host),1)-1)))	End ) <= 100000000 THEN 'FDFS http DL ST'
			END AS Test_Name
	  ,'DL'					AS Direction
	  ,host					AS url
	  ,LocalFilename
	  ,CASE WHEN host like '%/' THEN '1gb.dat'
			ELSE REVERSE(SUBSTRING(REVERSE(host),1,CHARINDEX('/',REVERSE(host),1)-1))
			End AS RemoteFilename
	  ,CASE WHEN host like '%/' THEN 1000000000
			ELSE dbo.FileSize(REVERSE(SUBSTRING(REVERSE(host),1,CHARINDEX('/',REVERSE(host),1)-1)))
			End AS FileSizeBytes
	  ,BytesTransferred
	  ,8.0* Throughput / 1000.0 as Throughput_kbit_s
	  ,duration
	  ,Operation 
	  ,APN 
FROM vResultsHTTPTransferTestGet


-- SINGLE THREAD UL
IF OBJECT_ID ('tempdb..#ultemp1' ) IS NOT NULL DROP TABLE #ultemp1
SELECT SessionId
	  ,TestId
	  ,Status
	  ,CAST (dbo.GetErrorMsg(ErrorCode,0)	AS VARCHAR (100)) As ErrCode
	  ,'httpTransfer'		AS Test_Type
	  ,CAST(null as varchar(50))		AS Test_Name
      ,'UL'					AS Direction
	  ,host					AS URL
	  ,CASE WHEN LocalFilename like '%/%'THEN REVERSE(SUBSTRING(REVERSE(LocalFilename),1,CHARINDEX('/',REVERSE(LocalFilename),1)-1))	
	  	ELSE LocalFilename			
	  	END AS LocalFilename
	  ,RemoteFilename
	  ,CAST(null as varchar(10))		AS FileSize
	  ,CAST(null as bigint)				AS FileSizeBytes
	  ,BytesTransferred
	  ,8.0* Throughput / 1000.0			As throughput
	  ,duration
	  ,Operation 
	  ,APN
into #ultemp1
FROM vResultsHTTPTransferTestPut

Update #ultemp1
set FileSize = CASE WHEN LocalFilename like '%.%' THEN SUBSTRING(LocalFilename,0,CHARINDEX('.',LocalFilename,1)) else LocalFilename end

Update #ultemp1
set FileSize = replace(FileSize,'KB','000')
where FileSize like '%KB%'

Update #ultemp1
set FileSize = replace(FileSize,'kb','000')
where FileSize like '%kb%'

Update #ultemp1
set FileSize = replace(FileSize,'MB','000000')
where FileSize like '%MB%'

Update #ultemp1
set FileSize = replace(FileSize,'mb','000000')
where FileSize like '%mb%'

Update #ultemp1
set FileSizeBytes = CAST(FileSize as bigint) 

Update #ultemp1
set Test_Name = CASE WHEN FileSizeBytes >  100000000	THEN 'FDTT http UL ST'
						 WHEN FileSizeBytes <= 100000000 THEN 'FDFS http UL ST'
						 END

INSERT INTO NEW_RESULTS_http_Transfers_2018(SessionId,TestId,Status,ErrorCode_Message,Test_Type,Test_Name,Direction,url,LocalFilename,RemoteFilename,FileSizeBytes,BytesTransferred,Throughput_kbit_s,duration,Operation,APN)
SELECT SessionId
	  ,TestId
	  ,Status
	  ,ErrCode
	  ,Test_Type
	  ,Test_Name
	  ,Direction
	  ,URL
	  ,LocalFilename
	  ,RemoteFilename
	  ,FileSizeBytes
	  ,BytesTransferred
	  ,throughput
	  ,duration
	  ,Operation
	  ,APN
FROM #ultemp1

-- CAPACITY DL
INSERT INTO NEW_RESULTS_http_Transfers_2018(SessionId,TestId,Status,ErrorCode_Message,Test_Type,Test_Name,Direction,url,LocalFilename,RemoteFilename,FileSizeBytes,BytesTransferred,Throughput_kbit_s,duration,Operation,APN)
select SessionId
	  ,TestId
	  ,Status
	  ,CAST (dbo.GetErrorMsg(ErrorCode,0)	AS VARCHAR (100))
	  ,'httpTransfer'		AS Test_Type
	  ,'FDTT http DL MT'	AS Test_Name
	  ,'DL'					AS Direction
	  ,host					AS URL
	  ,null					AS LocalFilename
	  ,REVERSE(SUBSTRING(REVERSE(host),1,CHARINDEX('/',REVERSE(host),1)-1))					AS RemoteFilename
	  ,dbo.FileSize(REVERSE(SUBSTRING(REVERSE(host),1,CHARINDEX('/',REVERSE(host),1)-1)))	AS FileSizeBytes
	  ,BytesTransferredGet	AS BytesTransferred
	  ,8.0* Throughput / 1000.0
	  ,duration
	  ,Direction			AS Operation 
	  ,APN
from vResultsCapacityTestGet

-- CAPACITY UL
INSERT INTO NEW_RESULTS_http_Transfers_2018(SessionId,TestId,Status,ErrorCode_Message,Test_Type,Test_Name,Direction,url,LocalFilename,RemoteFilename,FileSizeBytes,BytesTransferred,Throughput_kbit_s,duration,Operation,APN)
select SessionId
	  ,TestId
	  ,Status
	  ,CAST (dbo.GetErrorMsg(ErrorCode,0)	AS VARCHAR (100))
	  ,'httpTransfer'		AS Test_Type
	  ,'FDTT http UL MT'	AS Test_Name
	  ,'UL'					AS Direction
	  ,host					AS URL
	  ,REVERSE(SUBSTRING(REVERSE(LocalFilename),1,CHARINDEX('/',REVERSE(LocalFilename),1)-1))				AS LocalFilename
	  ,null					AS RemoteFilename
	  ,dbo.FileSize(REVERSE(SUBSTRING(REVERSE(LocalFilename),1,CHARINDEX('/',REVERSE(LocalFilename),1)-1)))	AS FileSizeBytes
	  ,BytesTransferredGet	AS BytesTransferred
	  ,8.0 * ThroughputPut / 1000.0		AS Throughput
	  ,duration
	  ,Direction			AS Operation 
	  ,APN
from vResultsCapacityTestPut

-- VALIDITY AND BASIC TEST INFO	
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update Test Start and end started...')
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  TestStart	= b.startTime
		,TestEnd	= DATEADD(ms,b.duration,b.startTime)
		,Validity	= CASE WHEN b.valid <> 0 THEN 1
						   ELSE 0
						   END
		,InvalidReason	= CASE WHEN b.valid <> 0 THEN null
						   ELSE 'SwissQual System Release'
						   END
		,Test_Info = CASE WHEN Test_Name like 'FDFS%' THEN 'Fixed Data File Size'
					  WHEN Test_Name like 'FDTT%' THEN 'Fixed Data Transfer Time'
					  END
	    ,Status		= CASE WHEN Status like 'Successful' THEN 'Completed'
								   WHEN Status not like 'Successful' and BytesTransferred > 0 THEN 'Cutoff'
								   ELSE 'Failed'
								   END 
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN TestInfo b on a.TestId = b.TestId

-- DNS DELAY INFORMATION TABLE UPDATE FROM KPI-s
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update DNS Information started...')
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  [DNS_1st_Request]			= a.[DNS_1st_Request]
		,[DNS_1st_Response]			= a.[DNS_1st_Response]
		,DNS_Delay_Access_ms	= a.[DNS_1st_Service_Delay_ms]
		,Client_IP_Address		= RTRIM(LTRIM(a.[DNS_Client_IPs]))
	FROM NEW_RESULTS_http_Transfers_2018 b
	LEFT OUTER JOIN NEW_DNS_PER_TEST_2018 a ON a.TestId = b.TestId
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update DNS Information completed...')

-- HTTP TRANSFER TESTS FROM SWISSQUAL KPI-s
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TCP Handshake
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update TCP Handshake for HTTP Transfer data started...')
	IF OBJECT_ID ('tempdb..#tcphandshakeHttpTransfer' ) IS NOT NULL DROP TABLE #tcphandshakeHttpTransfer
	SELECT   SessionId
			,TestId
			,MIN([TCP_SYN_UL]) AS [TCP_SYN_UL]
			,CAST(NULL AS datetime2(3)) AS [TCP_SYN_ACK_UL]
			,CAST(NULL AS varchar(100)) AS [Client_IP]
			,CAST(NULL AS varchar(100)) AS [Server_IP]
	INTO #tcphandshakeHttpTransfer
	FROM
		(SELECT SessionId,TestId,KPIID,
			   CASE 
					WHEN KPIID = 10401 Then StartTime 
					WHEN KPIID = 10402 Then StartTime 
					WHEN KPIID = 10411 Then StartTime
					WHEN KPIID = 10412 Then StartTime 
					WHEN KPIID = 10431 Then StartTime 
					WHEN KPIID = 10432 Then StartTime
				END AS [TCP_SYN_UL]
		FROM ResultsKPI
		WHERE KPIId IN (10401,10402,10411,10412,10431,10432)) AS TCPSYN
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE #tcphandshakeHttpTransfer
	SET  TCP_SYN_ACK_UL = A.EndTime
		,Client_IP = REVERSE( SUBSTRING( REVERSE(Value3),CHARINDEX(':',REVERSE(Value3)) + 1,LEN(REVERSE(Value3)) ) )
		,Server_IP = REVERSE( SUBSTRING( REVERSE(Value4),CHARINDEX(':',REVERSE(Value4)) + 1,LEN(REVERSE(Value4)) ) )
	FROM #tcphandshakeHttpTransfer T
	LEFT OUTER JOIN (SELECT * FROM ResultsKPI WHERE KPIID = 31000) AS A ON T.TestId = A.TestId and T.TCP_SYN_UL = A.StartTime

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET
		 [TCP_SYN_UL]			  = a.TCP_SYN_UL
		,[TCP_SYNACK_UL]		  = a.TCP_SYN_ACK_UL
		,Round_Trip_Time_ms = DATEDIFF(ms,a.TCP_SYN_UL,a.TCP_SYN_ACK_UL)
		,Client_IP_Address	  = CASE WHEN Client_IP_Address is null then Client_IP
									 WHEN Client_IP_Address not like Client_IP THEN Client_IP_Address + ',' + Client_IP
									 ELSE Client_IP_Address
									 END
		,Server_First_IP_Adress  = Server_IP
	FROM #tcphandshakeHttpTransfer a
	RIGHT OUTER JOIN NEW_RESULTS_http_Transfers_2018 b ON a.TestId = b. TestId

-- CAPACITY TESTS FROM SWISSQUAL KPI-s TCP Handshake
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update TCP Handshake for CAPACITY data started...')
	IF OBJECT_ID ('tempdb..#tcphandshakeCapacity' ) IS NOT NULL DROP TABLE #tcphandshakeCapacity
	SELECT   SessionId
			,TestId
			,MIN([TCP_SYN_UL]) AS [TCP_SYN_UL]
			,CAST(NULL AS datetime2(3)) AS [TCP_SYN_ACK_UL]
			,CAST(NULL AS varchar(100)) AS [Client_IP]
			,CAST(NULL AS varchar(100)) AS [Server_IP]
	INTO #tcphandshakeCapacity
	FROM
		(SELECT SessionId,TestId,KPIID,
			   CASE 
					-- HTTP Browser
					WHEN KPIID = 10461 Then StartTime 
					WHEN KPIID = 10462 Then StartTime 
					WHEN KPIID = 10463 Then StartTime
				END AS [TCP_SYN_UL]
		FROM ResultsKPI
		WHERE KPIId IN (10461,10462,10463)) AS TCPSYN
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE #tcphandshakeCapacity
	SET  TCP_SYN_ACK_UL = A.EndTime
		,Client_IP = REVERSE( SUBSTRING( REVERSE(Value3),CHARINDEX(':',REVERSE(Value3)) + 1,LEN(REVERSE(Value3)) ) )
		,Server_IP = REVERSE( SUBSTRING( REVERSE(Value4),CHARINDEX(':',REVERSE(Value4)) + 1,LEN(REVERSE(Value4)) ) )
	FROM #tcphandshakeCapacity T
	LEFT OUTER JOIN (SELECT * FROM ResultsKPI WHERE KPIID = 31000) AS A ON T.TestId = A.TestId and T.TCP_SYN_UL = A.StartTime

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET
		 [TCP_SYN_UL]			  = a.TCP_SYN_UL
		,[TCP_SYNACK_UL]		  = a.TCP_SYN_ACK_UL
		,Round_Trip_Time_ms = DATEDIFF(ms,a.TCP_SYN_UL,a.TCP_SYN_ACK_UL)
		,Client_IP_Address	  = CASE WHEN Client_IP_Address is null then Client_IP
									 WHEN Client_IP_Address not like Client_IP THEN Client_IP_Address + ',' + Client_IP
									 ELSE Client_IP_Address
									 END
		,Server_First_IP_Adress  = Server_IP
	FROM #tcphandshakeCapacity a
	RIGHT OUTER JOIN NEW_RESULTS_http_Transfers_2018 b ON a.TestId = b. TestId
	WHERE Test_Info like '%FDTT%' AND Test_Info like  '%MT%'

-- HTTP Transfer 1st Data for HTTP Transfer and Capacity
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update 1st Data Ok for CAPACITY and HTTP Transfer data started...')
	IF OBJECT_ID ('tempdb..#transferhttp1stdata' ) IS NOT NULL DROP TABLE #transferhttp1stdata
	SELECT   SessionId
			,TestId
			,MIN([event]) AS [event]
	INTO #transferhttp1stdata
	FROM
		(SELECT SessionId,TestId,KPIID,
			   CASE 
					WHEN KPIID = 10411 Then EndTime
					WHEN KPIID = 10450 Then EndTime
					WHEN KPIID = 15250 Then EndTime
				END AS [event]
		FROM ResultsKPI
		WHERE KPIId IN (10411,10450,15250)) AS TCPSYN
	GROUP BY SessionId,TestId
	ORDER BY SessionId,TestId

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET
		 HTTP_1st_Data			  = a.event
	FROM #transferhttp1stdata a
	RIGHT OUTER JOIN NEW_RESULTS_http_Transfers_2018 b ON a.TestId = b. TestId
	WHERE Test_Info like '%FDTT%' AND Test_Info like  '%MT%'


-- select * from vResultsCapacityTestPut
-- EXTRACT TRIGGERS BASED ON IP TRACE
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- STEP 1: Extract IP Trace interesting messagess 
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting usefull content from IP Trace...')
	IF OBJECT_ID ('tempdb..#rawprotocol' ) IS NOT NULL DROP TABLE #rawprotocol
	SELECT DISTINCT  SessionId
					,TestId
					,MsgTime
					,src
					,dst
					,protocol
					,msg 
	INTO #rawprotocol
	FROM MsgEthereal
	WHERE TestId in (SELECT DISTINCT TestId FROM NEW_RESULTS_http_Transfers_2018)

-- STEP 2: Update Table with fallback extracted data
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EXTRACT 1st DNS Request in Test
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with 1st DNS Request started...')
	IF OBJECT_ID ('tempdb..#dnsrequest' ) IS NOT NULL DROP TABLE #dnsrequest
	SELECT  SessionId
		   ,TestId
		   ,MIN(src) AS IP
		   ,MIN(MsgTime) AS dns_request
	INTO #dnsrequest
	FROM #rawprotocol 
	WHERE PROTOCOL LIKE 'DNS' and msg not like 'Standard query response%'
	GROUP BY SessionId,TestId

-- UPDATE 1st DNS Request in Test
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  DNS_1st_Request = CASE WHEN DNS_1st_Request is null THEN b.dns_request
								ELSE DNS_1st_Request
								END
		,Client_IP_Address = CASE WHEN Client_IP_Address is null THEN b.IP collate Latin1_General_CI_AS
								  ELSE Client_IP_Address
								  END
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN #dnsrequest b ON a.SessionId = b.SessionId and a.TestId = b.TestId

-- Delete all before DNS Request in Test
	DELETE T2 
	FROM #rawprotocol as T2 INNER JOIN NEW_RESULTS_http_Transfers_2018 T1 ON T1.TestId = T2.TestId and T2.MsgTime < T1.DNS_1st_Request
	WHERE T1.DNS_1st_Request is not null
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with 1st DNS Request completed...')

-- EXTRACT 1st DNS Response in Test
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with 1st DNS Response started...')
	IF OBJECT_ID ('tempdb..#dnsresponse' ) IS NOT NULL DROP TABLE #dnsresponse
	SELECT  SessionId
		   ,TestId
		   ,MIN(src) AS IP
		   ,MIN(MsgTime) AS dns_response
	INTO #dnsresponse
	FROM #rawprotocol 
	WHERE PROTOCOL LIKE 'DNS' and msg like 'Standard query response%'
	GROUP BY SessionId,TestId

-- UPDATE 1st DNS Response in Test
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  DNS_1st_Response = CASE WHEN DNS_1st_Response is null THEN b.dns_response
								 ELSE DNS_1st_Response
								 END
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN #dnsresponse b ON a.SessionId = b.SessionId and a.TestId = b.TestId

-- Delete all before DNS Response in Test
	DELETE T2 
	FROM #rawprotocol as T2 INNER JOIN NEW_RESULTS_http_Transfers_2018 T1 ON T1.TestId = T2.TestId and T2.MsgTime < T1.DNS_1st_Response
	WHERE T1.DNS_1st_Response is not null
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with 1st DNS Response completed...')

-- EXTRACT 1st SYN SENT in UL in Test
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with TCP SYN in UL started...')
	IF OBJECT_ID ('tempdb..#tcpsyn' ) IS NOT NULL DROP TABLE #tcpsyn
	SELECT  SessionId
		   ,TestId
		   ,MIN(MsgTime) AS eventtimestamp
	INTO #tcpsyn
	FROM #rawprotocol 
	WHERE PROTOCOL LIKE 'TCP' and msg like '%SYN]%'
	GROUP BY SessionId,TestId

-- UPDATE 1st SYN SENT in UL in Test
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  TCP_SYN_UL = CASE WHEN TCP_SYN_UL is null THEN b.eventtimestamp
						   ELSE TCP_SYN_UL
						   END
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN #tcpsyn b ON a.SessionId = b.SessionId and a.TestId = b.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with TCP SYN in UL completed...')

-- EXTRACT 1st SYN ACK Recieved in DL in Test
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with TCP SYN ACK in UL started...')
	IF OBJECT_ID ('tempdb..#tcpsynack' ) IS NOT NULL DROP TABLE #tcpsynack
	SELECT  SessionId
		   ,TestId
		   ,MIN(MsgTime) AS eventtimestamp
	INTO #tcpsynack
	FROM #rawprotocol 
	WHERE PROTOCOL LIKE 'TCP' and msg like '%SYN%ACK%'
	GROUP BY SessionId,TestId

-- UPDATE 1st SYN ACK Recieved in DL in Test
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  TCP_SYNACK_UL = CASE WHEN TCP_SYNACK_UL is null THEN b.eventtimestamp
							  ELSE TCP_SYNACK_UL
							  END
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN #tcpsynack b ON a.SessionId = b.SessionId and a.TestId = b.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with TCP SYN ACK in UL completed...')

-- EXTRACT HTTP/HTTPS DATA Recieved in DL in Test
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with 1st HTTP data in DL started...')
	IF OBJECT_ID ('tempdb..#data1st' ) IS NOT NULL DROP TABLE #data1st
	SELECT  SessionId
		   ,TestId
		   ,MIN(MsgTime) AS eventtimestamp
	INTO #data1st
	FROM #rawprotocol 
	WHERE PROTOCOL LIKE 'HTTP%' and (msg like '%Application Data%' OR msg like '%Server Hello%' OR msg like '%TLS Traffic%' OR msg like '%Continuation%')
	GROUP BY SessionId,TestId

-- UPDATE HTTP/HTTPS 1st response in DL in Test
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  HTTP_1st_Data = CASE WHEN HTTP_1st_Data is null THEN b.eventtimestamp
							  ELSE HTTP_1st_Data
							  END
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN #data1st b ON a.SessionId = b.SessionId and a.TestId = b.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with 1st HTTP data in DL completed...')

-- ALL SERVER IP-s INVOLVED IN TEST
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with all Server IP-s started...')
	IF OBJECT_ID ('tempdb..#Servers' ) IS NOT NULL DROP TABLE #Servers
	SELECT DISTINCT [SessionId]
		  ,[TestId]
		  ,[IP]
	  INTO #Servers
	  FROM 
		(SELECT DISTINCT [SessionId]
			  ,[TestId]
			  ,[dst] as IP
		  FROM #rawprotocol
		  WHERE Protocol not like 'DNS') AS T

	IF OBJECT_ID ('tempdb..#ips' ) IS NOT NULL DROP TABLE #ips
	SELECT [SessionId]
		  ,[TestId]
		  ,STUFF(
			 (SELECT DISTINCT ',' + [IP]
			  FROM #Servers
			  WHERE TestId = a.TestId AND SessionId = a.SessionId
			  FOR XML PATH (''))
			  , 1, 1, '')  AS IP_List
	INTO #ips
	FROM #Servers AS a
	GROUP BY [SessionId],[TestId]

-- UPDATE Server IP-s
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET  IP_Addresses_List = b.IP_List
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN #ips b ON a.SessionId = b.SessionId and a.TestId = b.TestId

-- REMOVE CLIENT IP FROM SERVERS LIST
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET IP_Addresses_List = REPLACE(IP_Addresses_List,RTRIM(LTRIM(Client_IP_Address)),'')

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET IP_Addresses_List = SUBSTRING(IP_Addresses_List,2,LEN(IP_Addresses_List))
	WHERE IP_Addresses_List like ',%'

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET IP_Addresses_List = SUBSTRING(IP_Addresses_List,0,LEN(IP_Addresses_List)-1)
	WHERE IP_Addresses_List like '%,'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with all Server IP-s')

-- release some system resources related to huge IP fallback temporarly DB-s
IF OBJECT_ID ('tempdb..#rawprotocol' )		IS NOT NULL DROP TABLE #rawprotocol
IF OBJECT_ID ('tempdb..#Servers' )			IS NOT NULL DROP TABLE #Servers
IF OBJECT_ID ('tempdb..#data1st' )			IS NOT NULL DROP TABLE #data1st
IF OBJECT_ID ('tempdb..#http1stconfirm' )	IS NOT NULL DROP TABLE #http1stconfirm
IF OBJECT_ID ('tempdb..#http1st' )			IS NOT NULL DROP TABLE #http1st
IF OBJECT_ID ('tempdb..#tcpsynack' )		IS NOT NULL DROP TABLE #tcpsynack
IF OBJECT_ID ('tempdb..#tcpsyn' )			IS NOT NULL DROP TABLE #tcpsyn
IF OBJECT_ID ('tempdb..#dnsresponse' )		IS NOT NULL DROP TABLE #dnsresponse
IF OBJECT_ID ('tempdb..#dnsrequest' )		IS NOT NULL DROP TABLE #dnsrequest
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Relesed Temp Tables to speed up SQL performance...')


-- UPDATE HTTP HOSTS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 cleaning inconsistancies started!')
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Host = url

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Host = REPLACE(Host,'https://','')
	WHERE Host like 'https://%'

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Host = REPLACE(Host,'http://','')
	WHERE Host like 'http://%'

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Host = SUBSTRING(Host,0,CHARINDEX('/',Host))
	WHERE Host like '%/%'

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET HTTP_last_Data = TestEnd
	WHERE HTTP_1st_Data is not null and TestEnd is not null

-- NO TCP CONNECTION, DATA TRANSFER NOT POSSIBLE
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Server_First_IP_Adress = IP_Addresses_List
	WHERE Server_First_IP_Adress is null and IP_Addresses_List not like '%,%' and IP_Addresses_List is not null

-- UPDATE IP SERVICE ACCESS
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with IP Service Access started!')
	UPDATE NEW_RESULTS_http_Transfers_2018
	SET IpServiceAccessStatus = CASE WHEN Status like 'Failed' THEN 'Failed'
										  ELSE 'Success'
										  END
	   ,IpServiceAccessTime_ms = DATEDIFF(ms,TestStart,HTTP_1st_Data)

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Round_Trip_Time_ms = DATEDIFF(ms,TCP_SYN_UL,TCP_SYNACK_UL)
	WHERE Round_Trip_Time_ms like 'Successful' and Round_Trip_Time_ms is null and DATEDIFF(ms,TCP_SYN_UL,TCP_SYNACK_UL) is not null

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Round_Trip_Time_ms = NULL
	WHERE Round_Trip_Time_ms <= 0 

-- Capacity Test Cutoff Criteria
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with Capacity Cutof Criteria!')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NC_HTTP_Transfer_Capacity' AND type = 'U')    DROP TABLE NC_HTTP_Transfer_Capacity
	select 
		ROW_NUMBER() over (partition by rtt1.testid order by rtt1.msgid) as rnk,
		rtt1.MsgId,
		rtt1.SessionId,
		rtt1.TestId,
		rtt1.MsgTime,
		rtt1.PosId,
		rtt1.NetworkId,
		rtt1.ErrorCode,
		CAST (rtt1.ThroughputGet AS BIGINT) AS ThroughputGet,
		rtt1.LastBlock,
		rtt1.Duration,
		rtt1.BytesTransferredGet,
		rtt1.ThroughputPut,
		rtt1.BytesTransferredPut,
		isnull(rtt1.BytesTransferredGet-rtt2.BytesTransferredGet, rtt1.BytesTransferredGet) as DeltaBytes
	into NC_HTTP_Transfer_Capacity
	from	
		ResultsCapacityTest rtt1
		join ResultsCapacityTestParameters rp on rtt1.TestId=rp.TestId
		left outer join ResultsCapacityTest rtt2 on rtt1.TestId=rtt2.TestId and rtt1.MsgId-1=rtt2.MsgId

	update NC_HTTP_Transfer_Capacity
	set 
		Duration=DATEDIFF(ms,rht2.MsgTime,rht.MsgTime),
		ThroughputGet	= CAST ((rht.BytesTransferredGET-rht2.BytesTransferredGET)/NULLIF((DATEDIFF(ms,rht2.MsgTime,rht.MsgTime)/1000.0),0) AS BIGINT)
	from 
		NC_HTTP_Transfer_Capacity trht 
		join ResultsCapacityTest rht on trht.MsgId=rht.MsgId
		join ResultsCapacityTest rht2 on rht.TestId=rht2.TestId and rht2.MsgId+1=rht.MsgId
	where rht.LastBlock=1 AND trht.ErrorCode = 0

	-- select * from NC_HTTP_Transfer_Capacity

	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NC_HTTP_Capacity_Cutoff_Criteria' AND type = 'U')    DROP TABLE NC_HTTP_Capacity_Cutoff_Criteria
	SELECT
		 SessionId,
		 TestId,	 
		 SUM(case when rnk=1  and DeltaBytes<>0 then 1 else null end)  as Block_01_Bytes,
		 SUM(case when rnk=2  and DeltaBytes<>0 then 1 else null end)  as Block_02_Bytes,
		 SUM(case when rnk=3  and DeltaBytes<>0 then 1 else null end)  as Block_03_Bytes,
		 SUM(case when rnk=4  and DeltaBytes<>0 then 1 else null end)  as Block_04_Bytes,
		 SUM(case when rnk=5  and DeltaBytes<>0 then 1 else null end)  as Block_05_Bytes,
		 SUM(case when rnk=6  and DeltaBytes<>0 then 1 else null end)  as Block_06_Bytes,
		 SUM(case when rnk=7  and DeltaBytes<>0 then 1 else null end)  as Block_07_Bytes,
		 SUM(case when rnk=8  and DeltaBytes<>0 then 1 else null end)  as Block_08_Bytes,
		 SUM(case when rnk=9  and DeltaBytes<>0 then 1 else null end)  as Block_09_Bytes,
		 SUM(case when rnk=10 and DeltaBytes<>0 then 1 else null end)  as Block_10_Bytes,
		 SUM(case when DeltaBytes<>0 then 1 else 0 end) as [COUNT_>0],
		 CAST(NULL AS INT) AS  No_http_Transfer_Last_4_Intermediate_Blocks	
	INTO NC_HTTP_Capacity_Cutoff_Criteria 
	FROM NC_HTTP_Transfer_Capacity
	GROUP BY SessionId,testid
	ORDER BY SessionId,testid 

	UPDATE NC_HTTP_Capacity_Cutoff_Criteria SET No_http_Transfer_Last_4_Intermediate_Blocks =
	CASE WHEN ([COUNT_>0] > 0) AND 
			  (
	--		  Block_01_Bytes IS NULL AND
	--		  Block_02_Bytes IS NULL AND
	--		  Block_03_Bytes IS NULL AND
	--		  Block_04_Bytes IS NULL AND
			  Block_05_Bytes IS NULL AND	
			  Block_06_Bytes IS NULL AND		  
			  Block_07_Bytes IS NULL AND
			  Block_08_Bytes IS NULL --AND
	--		  Block_09_Bytes IS NULL AND
	--		  Block_10_Bytes IS NULL  
			  ) THEN 1 ELSE NULL END

	UPDATE NEW_RESULTS_http_Transfers_2018
	SET Status = CASE WHEN b.No_http_Transfer_Last_4_Intermediate_Blocks = 1 THEN 'Cutoff'
					  ELSE a.Status
					  END
	FROM NEW_RESULTS_http_Transfers_2018 a
	LEFT OUTER JOIN NC_HTTP_Capacity_Cutoff_Criteria b on a.SessionId = b.SessionId and a.TestId = b.TestId
	WHERE a.Test_Name like 'FDTT%' AND a.Test_Name like '%MT' 

	UPDATE NEW_RESULTS_http_Transfers_2018
		set Validity = 0,
			InvalidReason = 'Capacity test Exceution Failure'
	where Test_Name like 'FDTT%' and Status like 'Completed' and duration < 2000

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_http_Transfers_2018 update with IP Service Access completed!')

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script execution completed!')

-- invalidate failed capacity tests --
update NEW_RESULTS_http_Transfers_2018
	set validity = 0,
		invalidreason = 'Capacity test failure'
--FROM NEW_RESULTS_http_Transfers_2018 http 
--join [NC_FailureClassification_Automatic_D] fc on http.testid=fc.testid
where Validity = 1 and Test_Name like 'FDTT%' and Status not like 'Completed'

-- SELECT * FROM NEW_RESULTS_http_Transfers_2018 where Validity = 1 and Test_Name like 'FDTT%' and Status not like 'Completed' and testid = 897648164944
-- select * from NC_HTTP_Capacity_Cutoff_Criteria
-- SELECT * FROM vResultsHTTPTransferTestGet
-- SELECT * FROM vResultsHTTPTransferTestPut
-- select * from vResultsCapacityTestGet
-- select * from vResultsCapacityTestPut
-- SELECT * FROM NEW_RESULTS_http_Transfers_2018 Order by SessionId, TestId 

