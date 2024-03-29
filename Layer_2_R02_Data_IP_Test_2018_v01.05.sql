/*******************************************************************************/
/****** Creates NEW_Test_Info_2018                                        ******/
/****** Author: Tomislav Miksa                                            ******/
/****** v1.00: initial table                                              ******/
/****** v1.05: adjustments for SQ 18.3                                    ******/
/****** v1.05: calculating just for newly imported data, not for old data ******/
/*******************************************************************************/

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execution...')
	IF NOT EXISTS (SELECT * FROM  sysobjects WHERE name = N'NEW_RESULTS_IP_2018') 
		BEGIN
			-- CREATE NEW TABLE IF NOT EXISTING
			CREATE TABLE NEW_RESULTS_IP_2018 (
												 SessionId							bigint        
												,Testid								bigint        
												,CLIENT_IPs							varchar(max)      
												,Server_IPs							varchar(max)       
												,HTTP_Server_IPs					varchar(max) 
												,Threads_Count						int           
												,Threads_Per_Server					varchar(max)       
												,HTTP_GET_Requests					int           
												,HTTP_PUT_Requests					int           
												,HTTP_200_Ok						int           
												,IP_Layer_Transferred_Bytes_DL		bigint        
												,IP_Layer_Transferred_Bytes_UL		bigint        
											  )
		END
		-- drop table NEW_RESULTS_IP_2018
	-- WORK ONLY WITH NEW TESTS AND SESSIONS TO SAVE TIME
	IF OBJECT_ID ('tempdb..#newSessions' ) IS NOT NULL DROP TABLE #newSessions
	SELECT DISTINCT SessionId_A as SessionId,TestId 
	INTO #newSessions
	FROM NEW_Test_Info_2018
	EXCEPT
	SELECT DISTINCT SessionId,TestId FROM NEW_RESULTS_IP_2018
	
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting UL messages Information...')
		IF OBJECT_ID ('tempdb..#RawMsgUL' ) IS NOT NULL DROP TABLE #RawMsgUL
		SELECT [MsgId]
			  ,[SessionId]
			  ,[TestId]
			  ,[MsgTime]
			  ,[PosId]
			  ,[NetworkId]
			  ,[src]
			  ,[dst]
			  ,[protocol]
			  ,[msg]
			  ,[Direction]
			  ,CASE WHEN protocol like '%tcp%' THEN SUBSTRING(msg,0,CHARINDEX('[',msg)) END AS Socket
		  INTO #RawMsgUL
		  FROM [MsgEthereal] a
		  WHERE a.TestId <> 0 and Direction = 1	and msg not like '%router%'
		        and SessionId in (Select SessionId from #newSessions)
				and TestId in (Select TestId from #newSessions)
-- select * from #sckt
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Creating temporarly #Results Table to Write results...')
		IF OBJECT_ID ('tempdb..#sckt' ) IS NOT NULL DROP TABLE #sckt
		select SessionId,TestId,dst,count(dst) as Threads 
		into #sckt 
		from ( select distinct SessionId,TestId,dst,Socket from #RawMsgUL where Socket is not null)  as a
		where SessionId in (Select SessionId from #newSessions)
				and TestId in (Select TestId from #newSessions)
		group by SessionId,TestId,dst


		IF OBJECT_ID ('tempdb..#Result' ) IS NOT NULL DROP TABLE #Result
		SELECT   SessionId
				,Testid
				,STUFF(
					(SELECT DISTINCT ', ' + [src]
					 FROM #RawMsgUL 
					 WHERE TestId = a.TestId AND SessionId = a.SessionId
					 FOR XML PATH (''))
					 , 1, 1, '')  AS CLIENT_IPs
				,STUFF(
					(SELECT DISTINCT ', ' + [dst]
					 FROM #RawMsgUL 
					 WHERE TestId = a.TestId AND SessionId = a.SessionId and protocol not like '%DNS%'
					 FOR XML PATH (''))
					 , 1, 1, '')  AS Server_IPs
				,cast(null as varchar(max)) as HTTP_Server_IPs
				,COUNT(DISTINCT Socket)														  AS Threads_Count
			    ,STUFF(
						(SELECT DISTINCT ', ' + [dst] + ' (' + CAST(Threads as varchar(5)) + ')'
						 FROM #sckt
						 WHERE TestId = a.TestId AND SessionId = a.SessionId
						 FOR XML PATH (''))
						 , 1, 1, '')  AS Threads_Per_Server
				,CAST(NULL AS BIGINT)								   						  AS HTTP_GET_Requests
				,CAST(NULL AS BIGINT)								   						  AS HTTP_PUT_Requests
				,CAST(NULL AS INT)															  AS HTTP_200_Ok
				,CAST(NULL AS BIGINT)														  AS IP_Layer_Transferred_Bytes_DL
				,CAST(NULL AS BIGINT)														  AS IP_Layer_Transferred_Bytes_UL
		INTO #Result
		FROM #RawMsgUL a
		GROUP BY SessionId,Testid
		ORDER BY SessionId,Testid
		-- select * from #Result
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting HTTP Information...')
		UPDATE #Result
		SET  HTTP_200_Ok       = CASE WHEN b.HTTP_200_Ok       IS NOT NULL THEN b.HTTP_200_Ok       ELSE A.http_ok  END
		    ,HTTP_GET_Requests = CASE WHEN b.HTTP_GET_Requests IS NOT NULL THEN b.HTTP_GET_Requests ELSE A.http_get END
			,HTTP_PUT_Requests = CASE WHEN b.HTTP_PUT_Requests IS NOT NULL THEN b.HTTP_PUT_Requests ELSE A.http_put END
		FROM #Result B
		LEFT OUTER JOIN (
							SELECT a.[SessionId]
								  ,a.[TestId]
								  ,SUM(CASE WHEN msg like '%HTTP%200 OK%' THEN 1 ELSE 0 END) AS http_ok
								  ,SUM(CASE WHEN msg like '%GET%' THEN 1 ELSE 0 END)		 AS http_get
								  ,SUM(CASE WHEN msg like '%PUT%' THEN 1 ELSE 0 END)		 AS http_put
							  FROM [MsgEthereal] a
							  WHERE a.TestId <> 0 and a.SessionId in (Select SessionId from #newSessions)
												  and a.TestId in (Select TestId from #newSessions)
							  GROUP BY SessionId,Testid 
						) as A ON A.SessionId = B.SessionId and A.TestId = B.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update #Results Table with IP Transferred Bytes...')
	IF OBJECT_ID ('tempdb..#iptrans' ) IS NOT NULL DROP TABLE #iptrans
	select
		TestId,
		SUM(CASE WHEN TestID <> 0 AND direction = 'downlink'	THEN CAST (bytesTransferred AS BIGINT)	ELSE NULL END)					AS IP_Layer_Transferred_Bytes_DL,
		SUM(CASE WHEN TestID <> 0 AND direction = 'uplink'		THEN CAST (bytesTransferred AS BIGINT)	ELSE NULL END)					AS IP_Layer_Transferred_Bytes_UL
	INTO #iptrans
	FROM MsgIPThroughput
	WHERE bytesTransferred <> 0 and SessionId in (Select SessionId from #newSessions)
				                and TestId in (Select TestId from #newSessions)
	GROUP BY TestId

	UPDATE #Result
	SET  IP_Layer_Transferred_Bytes_DL = b.IP_Layer_Transferred_Bytes_DL
		,IP_Layer_Transferred_Bytes_UL = b.IP_Layer_Transferred_Bytes_UL
	FROM #Result a
	LEFT OUTER JOIN #iptrans b on a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Update #Results Table with IP of HTTP Transfer in tests...')
	IF OBJECT_ID ('tempdb..#transIp' ) IS NOT NULL DROP TABLE #transIp
	select TestId,dst,msg 
	into #transIp
	from MsgEthereal 
	where TestId in (SELECT TestId  FROM NEW_Test_Info_2018 WHERE Type_of_Test like '%httpTransfer%') and (msg like '%GET%' or msg like '%PUT%' and msg not like '%api%')

	IF OBJECT_ID ('tempdb..#transFin' ) IS NOT NULL DROP TABLE #transFin
	SELECT Testid
		  ,STUFF(
			      (SELECT DISTINCT ', ' + [dst]
			       FROM #transIp
			       WHERE TestId = a.TestId
			       FOR XML PATH (''))
			       , 1, 1, '')  AS server
	into #transFin
	from #transIp a
	group by TestId

	UPDATE #Result
	set HTTP_Server_IPs = b.server
	from #Result  a
	left outer join #transFin b on a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - WRITING RESULTS...')
	INSERT INTO NEW_RESULTS_IP_2018
	SELECT * -- select top 10 *
	FROM #Result 
	ORDER BY SessionId,Testid 

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script execution completed...')

-- SELECT * FROM NEW_RESULTS_IP_2018 where TestId in (SELECT TestId  FROM NEW_Test_Info_2018 WHERE Type_of_Test like '%httpTransfer%') order by Sessionid,TestId
-- SELECT DISTINCT SessionId_A,TestId  FROM NEW_Test_Info_2018 WHERE Type_of_Test like '%httpTransfer%' ORDER BY SessionId_A,Testid
-- select TestId,dst,msg from MsgEthereal where TestId in (SELECT TestId  FROM NEW_Test_Info_2018 WHERE Type_of_Test like '%httpTransfer%') and (msg like '%GET%' or msg like '%PUT%') order by TestId,MsgTime
-- SELECT * FROM #Result            ORDER BY SessionId,Testid
-- SELECT TOP 10000 * FROM #RawMsgDL          ORDER BY SessionId,Testid,MsgTime