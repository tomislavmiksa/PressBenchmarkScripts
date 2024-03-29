-----------------------------------------------------------------------------------
-- add by TM: DNS ADDED FOR ALL TEST (06.07.2017.)
-----------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_RAW_2018 Table creation started!')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_DNS_RAW_2018' AND type = 'U')	DROP TABLE [NEW_DNS_RAW_2018]
SELECT   SessionId
        ,TestId
		,rank() OVER (ORDER BY SessionId, TestId, StartTime) AS DnsId
        ,KPIId
        ,StartTime
        ,EndTime
        ,Duration
        ,ErrorCode
        ,Counter	AS Query_Hosts_Count
        ,Value3		AS DNS_Query
        ,Value4     AS DNS_Response
		,REPLACE(REPLACE(Value3,'Standard query A ',''),'Standard query AAAA ','') AS HOST
		-- TECHNOLOGY INFORMATION
		,NetworkId
		,CAST(NULL AS INT)			AS Cell_Id
		,CAST(NULL AS VARCHAR(50))	AS Home_Operator
		,CAST(NULL AS INT)			AS Home_MCC	
		,CAST(NULL AS INT)			AS Home_MNC
		,CAST(NULL AS VARCHAR(50))	AS Serving_Operator
		,CAST(NULL AS INT)			AS Serving_MCC	
		,CAST(NULL AS INT)			AS Serving_MNC	
		,CAST(NULL AS INT)			AS LAC	
		,CAST(NULL AS VARCHAR(50))	AS Technology
		,CAST(NULL AS INT)			AS BCCH
		,CAST(NULL AS INT)			AS BSIC
		,CAST(NULL AS VARCHAR(50))	AS SC	
		,CAST(NULL AS VARCHAR(50))	AS CGI	
		-- RADIO INFORMATION
		,CAST(NULL AS FLOAT) AS MinRxLev
		,CAST(NULL AS FLOAT) AS AvgRxLev
		,CAST(NULL AS FLOAT) AS MaxRxLev
		,CAST(NULL AS FLOAT) AS StDevRxLev
		,CAST(NULL AS FLOAT) AS MinRxQual
		,CAST(NULL AS FLOAT) AS AvgRxQual
		,CAST(NULL AS FLOAT) AS MaxRxQual
		,CAST(NULL AS FLOAT) AS StDevRxQual
		,CAST(NULL AS FLOAT) AS MinRSCP
		,CAST(NULL AS FLOAT) AS AvgRSCP
		,CAST(NULL AS FLOAT) AS MaxRSCP
		,CAST(NULL AS FLOAT) AS StDevRSCP
		,CAST(NULL AS FLOAT) AS MinEcIo
		,CAST(NULL AS FLOAT) AS AvgEcIo
		,CAST(NULL AS FLOAT) AS MaxEcIo
		,CAST(NULL AS FLOAT) AS StDevEcIo
		,CAST(NULL AS FLOAT) AS MinTxPwr3G
		,CAST(NULL AS FLOAT) AS AvgTxPwr3G
		,CAST(NULL AS FLOAT) AS MaxTxPwr3G
		,CAST(NULL AS FLOAT) AS StDevTxPwr3G
		,CAST(NULL AS FLOAT) AS MinRSRP
		,CAST(NULL AS FLOAT) AS AvgRSRP
		,CAST(NULL AS FLOAT) AS MaxRSRP
		,CAST(NULL AS FLOAT) AS StDevRSRP
		,CAST(NULL AS FLOAT) AS MinRSRQ
		,CAST(NULL AS FLOAT) AS AvgRSRQ
		,CAST(NULL AS FLOAT) AS MaxRSRQ
		,CAST(NULL AS FLOAT) AS StDevRSRQ
		,CAST(NULL AS FLOAT) AS MinSINR
		,CAST(NULL AS FLOAT) AS AvgSINR
		,CAST(NULL AS FLOAT) AS MaxSINR
		,CAST(NULL AS FLOAT) AS StDevSINR
		,CAST(NULL AS FLOAT) AS MinSINR0
		,CAST(NULL AS FLOAT) AS AvgSINR0
		,CAST(NULL AS FLOAT) AS MaxSINR0
		,CAST(NULL AS FLOAT) AS StDevSINR0
		,CAST(NULL AS FLOAT) AS MinSINR1
		,CAST(NULL AS FLOAT) AS AvgSINR1
		,CAST(NULL AS FLOAT) AS MaxSINR1
		,CAST(NULL AS FLOAT) AS StDevSINR1
		,CAST(NULL AS FLOAT) AS MinTxPwr4G
		,CAST(NULL AS FLOAT) AS AvgTxPwr4G
		,CAST(NULL AS FLOAT) AS MaxTxPwr4G
		,CAST(NULL AS FLOAT) AS StDevTxPwr4G
		-- LOCATION INFORMATION
		,PosId
		,CAST(NULL AS FLOAT)		AS latitude
		,CAST(NULL AS FLOAT)		AS longitude
INTO NEW_DNS_RAW_2018
FROM ResultsKPI
WHERE TestId <> 0 and KPIId = 31100 and Value3 not like '%dummy_url%'
ORDER BY SessionId,TestId

-- UPDATE UNSUCCESSFULL DNS AS ERROR
UPDATE NEW_DNS_RAW_2018
SET ErrorCode = 404
WHERE DNS_Response like 'Standard query response; No such name'

-- ALL ERRORS SHOULD BE NULL IN TIMES CALLCULATION
UPDATE NEW_DNS_RAW_2018
SET Duration = null 
WHERE ErrorCode <> 0
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_RAW_2018 Table successfully created!')

-- LONGITUDE, LATITUDE UPDATE SUCCESSFULLY COMPLETED
UPDATE NEW_DNS_RAW_2018
SET latitude	 = a.latitude,	
	longitude = a.longitude
	FROM Position a
	RIGHT OUTER JOIN NEW_DNS_RAW_2018 b ON a.PosId = b.PosId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_RAW_2018 Table updated with location Information!')

-- RAN INFORMATIONS UPDATE
UPDATE NEW_DNS_RAW_2018
SET   Cell_Id			= a.CId
	,Home_Operator		= a.HomeOperator
	,Home_MCC			= a.HOMCC
	,Home_MNC			= a.HOMNC
	,Serving_Operator	= a.Operator
	,Serving_MCC		= a.MCC
	,Serving_MNC		= a.MNC
	,LAC				= a.LAC
	,Technology			= a.technology
	,BCCH				= a.BCCH
	,BSIC				= a.BSIC
	,SC					= CAST(a.SC1 as varchar(4))
	,CGI				= a.CGI
	FROM NetworkInfo a
	RIGHT OUTER JOIN NEW_DNS_RAW_2018 b ON a.NetworkId = b.NetworkId

UPDATE NEW_DNS_RAW_2018
SET   SC					= SC + ',' + CAST(a.SC2 as varchar(4))
	FROM NetworkInfo a
	RIGHT OUTER JOIN NEW_DNS_RAW_2018 b ON a.NetworkId = b.NetworkId
	WHERE a.SC2 is not null

UPDATE NEW_DNS_RAW_2018
SET   SC					= SC + ',' + CAST(a.SC3 as varchar(4))
	FROM NetworkInfo a
	RIGHT OUTER JOIN NEW_DNS_RAW_2018 b ON a.NetworkId = b.NetworkId
	WHERE a.SC3 is not null
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_RAW_2018 Table updated with RAN Information!')

UPDATE NEW_DNS_RAW_2018
SET      MinRxLev      = a.MinRxLev    
		,AvgRxLev      = a.AvgRxLev    
		,MaxRxLev      = a.MaxRxLev    
		,StDevRxLev    = a.StDevRxLev  
		,MinRxQual     = a.MinRxQual   
		,AvgRxQual     = a.AvgRxQual   
		,MaxRxQual     = a.MaxRxQual   
		,StDevRxQual   = a.StDevRxQual 
	FROM NEW_RF_Test_2018 a
	RIGHT OUTER JOIN NEW_DNS_RAW_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	WHERE Technology like '%GSM%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_RAW_2018 Table updated with GSM Radio!')

UPDATE NEW_DNS_RAW_2018
SET      MinRSCP       = a.MinRSCP     
		,AvgRSCP       = a.AvgRSCP     
		,MaxRSCP       = a.MaxRSCP     
		,StDevRSCP     = a.StDevRSCP   
		,MinEcIo       = a.MinEcIo     
		,AvgEcIo       = a.AvgEcIo     
		,MaxEcIo       = a.MaxEcIo     
		,StDevEcIo     = a.StDevEcIo   
		,MinTxPwr3G    = a.MinTxPwr3G  
		,AvgTxPwr3G    = a.AvgTxPwr3G  
		,MaxTxPwr3G    = a.MaxTxPwr3G  
		,StDevTxPwr3G  = a.StDevTxPwr3G
	FROM NEW_RF_Test_2018 a
	RIGHT OUTER JOIN NEW_DNS_RAW_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	WHERE Technology like '%UMTS%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_RAW_2018 Table updated with UMTS Radio!')

UPDATE NEW_DNS_RAW_2018
SET      MinRSRP       = a.MinRSRP     
		,AvgRSRP       = a.AvgRSRP     
		,MaxRSRP       = a.MaxRSRP     
		,StDevRSRP     = a.StDevRSRP   
		,MinRSRQ       = a.MinRSRQ     
		,AvgRSRQ       = a.AvgRSRQ     
		,MaxRSRQ       = a.MaxRSRQ     
		,StDevRSRQ     = a.StDevRSRQ   
		,MinSINR       = a.MinSINR     
		,AvgSINR       = a.AvgSINR     
		,MaxSINR       = a.MaxSINR     
		,StDevSINR     = a.StDevSINR   
		,MinSINR0      = a.MinSINR0    
		,AvgSINR0      = a.AvgSINR0    
		,MaxSINR0      = a.MaxSINR0    
		,StDevSINR0    = a.StDevSINR0  
		,MinSINR1      = a.MinSINR1    
		,AvgSINR1      = a.AvgSINR1    
		,MaxSINR1      = a.MaxSINR1    
		,StDevSINR1    = a.StDevSINR1  
		,MinTxPwr4G    = a.MinTxPwr4G  
		,AvgTxPwr4G    = a.AvgTxPwr4G  
		,MaxTxPwr4G    = a.MaxTxPwr4G  
		,StDevTxPwr4G  = a.StDevTxPwr4G
	FROM NEW_RF_Test_2018 a
	RIGHT OUTER JOIN NEW_DNS_RAW_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
	WHERE Technology like '%LTE%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_RAW_2018 Table updated with LTE Radio!')

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DNS PER TESTS STATISTICS WHICH WILL BE MERGED WITH FINAL CDR
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table creation started!')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_DNS_PER_TEST_2018' AND type = 'U')	DROP TABLE [NEW_DNS_PER_TEST_2018]
SELECT DISTINCT
	 SessionId
	,TestId
	,CAST(NULL AS varchar(200)) AS DNS_Client_IPs
	,CAST(NULL AS varchar(200)) AS DNS_Server_IPs
	,CAST(NULL AS int)          AS DNS_Resolution_Attempts
	,CAST(NULL AS int)          AS DNS_Resolution_Success
	,CAST(NULL AS int)          AS DNS_Resolution_Failures
	,CAST(NULL AS int)          AS DNS_Resolution_Time_Minimum_ms
	,CAST(NULL AS int)          AS DNS_Resolution_Time_Average_ms
	,CAST(NULL AS int)          AS DNS_Resolution_Time_Maximum_ms
	,CAST(NULL AS varchar(MAX)) AS DNS_Hosts_List
	,CAST(NULL AS datetime2(3)) AS DNS_1st_Request
	,CAST(NULL AS datetime2(3)) AS DNS_1st_Response
	,CAST(NULL AS int)			AS DNS_1st_Service_Delay_ms	
INTO NEW_DNS_PER_TEST_2018
FROM NEW_DNS_RAW_2018
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table creation completed!')

-- UPDATE BASIC STATISTICS
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table update with basic statistics started!')
IF OBJECT_ID ('tempdb..#DnsFinal' ) IS NOT NULL DROP TABLE #DnsFinal
SELECT SessionId,TestId
       ,SUM(Query_Hosts_Count) AS Attempts
       ,SUM(CASE WHEN ErrorCode like 0  THEN Query_Hosts_Count ELSE 0 END)  AS Success
       ,SUM(CASE WHEN ErrorCode <> 0    THEN Query_Hosts_Count ELSE 0 END)  AS Failed
	   ,MIN(Duration)														AS Min_Resolution_Time
	   ,1.0*SUM(Duration * Query_Hosts_Count)/SUM(Query_Hosts_Count)		AS Avg_Resolution_Time
	   ,MAX(Duration)														AS Max_Resolution_Time
	   ,STUFF(
				(SELECT DISTINCT ', ' + [HOST]
				  FROM NEW_DNS_RAW_2018
				  WHERE TestId = a.TestId AND SessionId = a.SessionId
				  FOR XML PATH (''))
				  , 1, 1, '')  AS DNS_HOSTS_RESOLVED_List
INTO #DnsFinal
FROM NEW_DNS_RAW_2018 a
GROUP BY SessionId,TestId

UPDATE NEW_DNS_PER_TEST_2018
SET	 DNS_Resolution_Attempts		= a.Attempts
	,DNS_Resolution_Success			= a.Success
	,DNS_Resolution_Failures		= a.Failed
	,DNS_Resolution_Time_Minimum_ms	= a.Min_Resolution_Time
	,DNS_Resolution_Time_Average_ms	= a.Avg_Resolution_Time
	,DNS_Resolution_Time_Maximum_ms	= a.Max_Resolution_Time
	,DNS_Hosts_List					= a.DNS_HOSTS_RESOLVED_List
FROM #DnsFinal a
RIGHT OUTER JOIN NEW_DNS_PER_TEST_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table update with basic statistics completed!')

-- UPDATE WITH SERVER AND CLIENT IP-s
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table update with Server and Client IP-s started')
IF OBJECT_ID ('tempdb..#DNSServer' ) IS NOT NULL DROP TABLE #DNSServer
SELECT DISTINCT [SessionId]
      ,[TestId]
	  ,[src]
      ,[dst]
  INTO #DNSServer
  FROM [MsgEthereal]
  WHERE TestId <> 0 AND Protocol like 'DNS' AND MSG like 'Standard query A%'

IF OBJECT_ID ('tempdb..#DNSips' ) IS NOT NULL DROP TABLE #DNSips
SELECT [SessionId]
      ,[TestId]
	  ,STUFF(
         (SELECT DISTINCT ', ' + [src]
          FROM #DNSServer
          WHERE TestId = a.TestId AND SessionId = a.SessionId
          FOR XML PATH (''))
          , 1, 1, '')  AS DNS_Client_List
	  ,STUFF(
         (SELECT DISTINCT ', ' + [dst]
          FROM #DNSServer
          WHERE TestId = a.TestId AND SessionId = a.SessionId
          FOR XML PATH (''))
          , 1, 1, '')  AS DNS_Server_List
INTO #DNSips
FROM #DNSServer AS a
GROUP BY [SessionId],[TestId]

UPDATE NEW_DNS_PER_TEST_2018
SET  DNS_Client_IPs = DNS_Client_List
	,DNS_Server_IPs = DNS_Server_List
FROM #DNSips a
RIGHT OUTER JOIN NEW_DNS_PER_TEST_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table update with Server and Client IP-s completed')

-- DNS SERVICE DELAY EXTRACTION
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table update with initial delay due DNS started')
IF OBJECT_ID ('tempdb..#DnsDelay' ) IS NOT NULL DROP TABLE #DnsDelay
SELECT SessionId,TestId
        ,CAST(NULL AS datetime2(3)) AS StartTime
        ,MIN(EndTime) AS EndTime                                        -- 1st DNS Response
        ,CAST(NULL AS bigint) AS DNS_Service_Delay
INTO #DnsDelay
FROM NEW_DNS_RAW_2018
WHERE ErrorCode = 0
GROUP BY SessionId,TestId

-- UPDATE WITH 1st Request
UPDATE #DnsDelay
SET StartTime = A.StartTime
FROM (SELECT SessionId,TestId
             ,MIN(StartTime) AS StartTime                                    -- 1st DNS Request
            FROM NEW_DNS_RAW_2018
            GROUP BY SessionId,TestId) AS A
RIGHT OUTER JOIN #DnsDelay B ON A.SessionId = B.SessionId and A.TestId = B.TestId


UPDATE NEW_DNS_PER_TEST_2018
SET  DNS_1st_Request			 = a.StartTime
	,DNS_1st_Response			 = a.EndTime
	,DNS_1st_Service_Delay_ms	 = DATEDIFF(ms,a.StartTime,a.EndTime)
FROM #DnsDelay a
RIGHT OUTER JOIN NEW_DNS_PER_TEST_2018 b ON a.SessionId = b.SessionId and a.TestId = b.TestId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - NEW_DNS_PER_TEST_2018 Table update with initial delay due DNS completed')

-- SELECT * FROM NEW_DNS_PER_TEST_2018
-- SELECT * FROM NEW_DNS_RAW_2018

