/*******************************************************************************/
/****** Creates NEW_Test_Info_2018                                        ******/
/****** Author: Tomislav Miksa                                            ******/
/****** v1.00: initial table                                              ******/
/*******************************************************************************/

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execution...')

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting client IP Information...')
		IF OBJECT_ID ('tempdb..#ClientIPs' ) IS NOT NULL DROP TABLE #ClientIPs
		SELECT   SessionId,TestId
				,ROW_NUMBER() over (partition by SessionId,TestID ORDER BY ClientIPs) AS rnk
				,ClientIPs
		INTO #ClientIPs
		FROM
		( select DISTINCT SessionId,TestId, 
		         CASE WHEN Direction = 1 THEN src 
				      WHEN Direction = 0 THEN dst 
			      END AS ClientIPs 
		   from [MsgEthereal]	) AS A
-- select DISTINCT SessionId,TestId, CASE WHEN Direction = 1 THEN src WHEN Direction = 0 THEN dst END AS ClientIPs from [MsgEthereal]
		IF OBJECT_ID ('tempdb..#ClientIP' ) IS NOT NULL DROP TABLE #ClientIP
		SELECT  DISTINCT a.Sessionid,a.TestId
			   ,CAST(NULL AS VARCHAR(100))  AS IP_1
			   ,CAST(NULL AS VARCHAR(100))  AS IP_2
			   ,CAST(NULL AS VARCHAR(100))  AS IP_3
			   ,CAST(NULL AS VARCHAR(100))  AS IP_4
			   ,CAST(NULL AS VARCHAR(100))  AS IP_5
		INTO #ClientIP
		FROM #ClientIPs a

		UPDATE #ClientIP
		SET IP_1 = b.ClientIPs
		FROM #ClientIP a
		LEFT OUTER JOIN #ClientIPs b ON a.SessionId = b.SessionId and a.TestId = b.TestId and b.rnk = 1 
		UPDATE #ClientIP
		SET IP_2 = b.ClientIPs
		FROM #ClientIP a
		LEFT OUTER JOIN #ClientIPs b ON a.SessionId = b.SessionId and a.TestId = b.TestId and b.rnk = 2
		UPDATE #ClientIP
		SET IP_3 = b.ClientIPs
		FROM #ClientIP a
		LEFT OUTER JOIN #ClientIPs b ON a.SessionId = b.SessionId and a.TestId = b.TestId and b.rnk = 3
		UPDATE #ClientIP
		SET IP_4 = b.ClientIPs
		FROM #ClientIP a
		LEFT OUTER JOIN #ClientIPs b ON a.SessionId = b.SessionId and a.TestId = b.TestId and b.rnk = 4
		UPDATE #ClientIP
		SET IP_5 = b.ClientIPs
		FROM #ClientIP a
		LEFT OUTER JOIN #ClientIPs b ON a.SessionId = b.SessionId and a.TestId = b.TestId and b.rnk = 5

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting UL messages Information...')
		IF OBJECT_ID ('tempdb..#RawMsgUL' ) IS NOT NULL DROP TABLE #RawMsgUL
		SELECT a.[MsgId]
			  ,a.[SessionId]
			  ,a.[TestId]
			  ,a.[MsgTime]
			  ,a.[PosId]
			  ,a.[NetworkId]
			  ,a.[src]
			  ,a.[dst]
			  ,a.[protocol]
			  ,a.[msg]
			  ,a.[Direction]
		  INTO #RawMsgUL
		  FROM [MsgEthereal] a
		  LEFT OUTER JOIN #ClientIP b ON a.SessionId = b.SessionId and a.TestId = b.TestId
		  WHERE a.TestId <> 0 and Direction = 1	and msg not like '%router%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting Threads Information...')
		IF OBJECT_ID ('tempdb..#Threads1' ) IS NOT NULL DROP TABLE #Threads1
		SELECT sessionId, Testid, dst, count(dst) as threads
		into #Threads1
		FROM 
		(select distinct SessionId,TestId,src,dst
			   ,SUBSTRING(msg,0,CHARINDEX('[',msg)) AS Socket
		from #RawMsgUL 
		WHERE protocol like '%tcp%') AS A
		group by sessionId, Testid, dst
		order by sessionId, Testid, dst

		IF OBJECT_ID ('tempdb..#Threads' ) IS NOT NULL DROP TABLE #Threads
		SELECT SessionId,TestId
			  ,SUM(threads) AS Threads
			  ,STUFF(
						(SELECT DISTINCT ', ' + [dst] + ' (' + CAST(threads as varchar(5)) + ')'
						 FROM #Threads1
						 WHERE TestId = a.TestId AND SessionId = a.SessionId
						 FOR XML PATH (''))
						 , 1, 1, '')  AS per_server
		INTO #Threads
		FROM #Threads1 a
		GROUP BY SessionId,TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Creating temporarly #Results Table to Write results...')
		IF OBJECT_ID ('tempdb..#Result' ) IS NOT NULL DROP TABLE #Result
		SELECT   SessionId
				,Testid
				,CAST(NULL AS VARCHAR(MAX))  AS CLIENT_IPs
				,STUFF(
					(SELECT DISTINCT ', ' + [dst]
					 FROM #RawMsgUL 
					 WHERE TestId = a.TestId AND SessionId = a.SessionId and protocol not like '%DNS%'
					 FOR XML PATH (''))
					 , 1, 1, '')  AS Server_IPs
				,CAST(NULL AS INT)															  AS Threads_Count
				,CAST(NULL AS VARCHAR(MAX))													  AS Threads_Per_Server
				,SUM(CASE WHEN msg like '%GET%'      THEN 1 ELSE 0 END)						  AS HTTP_GET_Requests
				,SUM(CASE WHEN msg like '%PUT%'      THEN 1 ELSE 0 END)						  AS HTTP_PUT_Requests
				,CAST(NULL AS INT)															  AS HTTP_200_Ok
				,CAST(NULL AS BIGINT)														  AS IP_Layer_Transferred_Bytes_DL
				,CAST(NULL AS BIGINT)														  AS IP_Layer_Transferred_Bytes_UL
		INTO #Result
		FROM #RawMsgUL a
		GROUP BY SessionId,Testid
		ORDER BY SessionId,Testid

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update #Results Table with Thread information...')
		UPDATE #Result
		SET Threads_Count = b.Threads
			,Threads_Per_Server = b.per_server
		FROM #Result a
		LEFT OUTER JOIN #Threads AS b ON  A.SessionId = B.SessionId and A.TestId = B.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting DL messages Information...')
		IF OBJECT_ID ('tempdb..#RawMsgDL' ) IS NOT NULL DROP TABLE #RawMsgDL
		SELECT a.[SessionId]
			  ,a.[TestId]
			  ,[src]
			  ,[dst]
			  ,[protocol]
			  ,[msg]
		  INTO #RawMsgDL
		  FROM [MsgEthereal] a
		  LEFT OUTER JOIN #ClientIP b ON a.SessionId = b.SessionId and a.TestId = b.TestId
		  WHERE a.TestId <> 0 and Direction = 0 and msg not like '%router%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update #Results Table with HTTP Requests/Responses...')
		UPDATE #Result
		SET  HTTP_200_Ok = A.http_ok
		FROM #Result B
		LEFT OUTER JOIN 
			(SELECT  SessionId
					,Testid
					,SUM(CASE WHEN protocol like '%HTTP%200 OK%' THEN 1 ELSE 0 END) AS http_ok
			FROM #RawMsgDL a
			GROUP BY SessionId,Testid) AS A ON A.SessionId = B.SessionId and A.TestId = B.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update #Results Table with Client IP info...')
		UPDATE #Result
		SET CLIENT_IPs = b.IP_1 collate Latin1_General_CI_AS + CASE WHEN b.IP_2 is not null THEN ', ' + b.IP_2 collate Latin1_General_CI_AS
																	ELSE ''
																	END + CASE WHEN b.IP_3 is not null THEN ', ' + b.IP_3 collate Latin1_General_CI_AS
																				ELSE ''
																				END + CASE WHEN b.IP_4 is not null THEN ', ' + b.IP_4 collate Latin1_General_CI_AS
																							ELSE ''
																							END +  CASE WHEN ', ' + b.IP_5 is not null THEN b.IP_5 collate Latin1_General_CI_AS
																										ELSE ''
																										END
		FROM #Result a
		LEFT OUTER JOIN #ClientIP b on a.SessionId = b.SessionId and a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update #Results Table with IP Transferred Bytes...')
	IF OBJECT_ID ('tempdb..#iptrans' ) IS NOT NULL DROP TABLE #iptrans
	select
		TestId,
		SUM(CASE WHEN TestID <> 0 AND direction = 'downlink'	THEN CAST (bytesTransferred AS BIGINT)	ELSE NULL END)					AS IP_Layer_Transferred_Bytes_DL,
		SUM(CASE WHEN TestID <> 0 AND direction = 'uplink'		THEN CAST (bytesTransferred AS BIGINT)	ELSE NULL END)					AS IP_Layer_Transferred_Bytes_UL
	INTO #iptrans
	FROM MsgIPThroughput
	WHERE bytesTransferred <> 0
	GROUP BY TestId

	UPDATE #Result
	SET  IP_Layer_Transferred_Bytes_DL = b.IP_Layer_Transferred_Bytes_DL
		,IP_Layer_Transferred_Bytes_UL = b.IP_Layer_Transferred_Bytes_UL
	FROM #Result a
	LEFT OUTER JOIN #iptrans b on a.TestId = b.TestId

IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_IP_2018')					DROP Table NEW_RESULTS_IP_2018
SELECT * 
INTO NEW_RESULTS_IP_2018
FROM #Result 
ORDER BY SessionId,Testid 

-- SELECT * FROM NEW_RESULTS_IP_2018
-- SELECT * FROM NEW_Test_Info_2018 ORDER BY SessionId_A,Testid
-- SELECT TOP 10000 * FROM #Result ORDER BY SessionId,Testid
-- SELECT TOP 10000 * FROM #RawMsgDL ORDER BY SessionId,Testid,MsgTime

