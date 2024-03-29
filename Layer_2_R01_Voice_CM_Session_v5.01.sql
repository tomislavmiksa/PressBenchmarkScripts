/*****************************************************************************************************************************************************************************
         Creates Call Mode Table                                          
         Author: Tomislav Miksa                                           
         v4.00: Updated so takes only data not in CM Table                
         v5.00: Significantlly updated and improved                       
         Koba tool for CSFB must be executed before script and result saved in KB_CsfbCheck
*****************************************************************************************************************************************************************************/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'recREPLACE') AND xtype IN (N'FN', N'IF', N'TF') ) DROP FUNCTION recREPLACE
GO
CREATE FUNCTION recREPLACE
(
    @orig varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
	WHILE @orig like '%LTE/LTE%' OR @orig like '%UMTS/UMTS%' OR @orig like '%GSM/GSM%'  OR @orig like '%VoLTE/VoLTE%' 
			OR @orig like '%UMTS/GSM/UMTS%' OR @orig like '%UMTS/GSM/UMTS/GSM%' OR @orig like '%GSM/UMTS/GSM%' OR @orig like '%GSM/UMTS/GSM/UMTS%'
			OR @orig like '%//%'
			OR @orig like '%CSFB/VoLTE/%' OR @orig like '%CSFB/Vo/%'
	BEGIN
		SET @orig = REPLACE(@orig,'LTE/LTE','LTE')
		SET @orig = REPLACE(@orig,'UMTS/UMTS','UMTS')
		SET @orig = REPLACE(@orig,'GSM/GSM','GSM')
		SET @orig = REPLACE(@orig,'VoLTE/VoLTE','VoLTE')
		SET @orig = REPLACE(@orig,'UMTS/GSM/UMTS/GSM','UMTS/GSM')
		SET @orig = REPLACE(@orig,'GSM/UMTS/GSM/UMTS','GSM/UMTS')
		SET @orig = REPLACE(@orig,'UMTS/GSM/UMTS','UMTS/GSM')
		SET @orig = REPLACE(@orig,'GSM/UMTS/GSM','GSM/UMTS')
		SET @orig = REPLACE(@orig,'//','/')
		SET @orig = REPLACE(@orig,'CSFB/VoLTE/','CSFB/')
		SET @orig = REPLACE(@orig,'CSFB/Vo/','CSFB/')
    END
	RETURN @orig
END
GO
-- FUNCTION TO EXTRACT REASON HEADER FROM SIP MESSAGE
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'ReasonString') AND xtype IN (N'FN', N'IF', N'TF') ) DROP FUNCTION ReasonString
GO
CREATE FUNCTION ReasonString
(
	@rawstring varchar(8000)
)
RETURNS varchar(8000)
AS
BEGIN
		Declare @temp1 varchar(8000) = @rawstring
			Declare @temp2 varchar(8000) = ''
			Declare @i int = 0
			Declare @n int = ( LEN(@rawstring) - LEN( REPLACE(@rawstring,'Reason:','') ) ) / LEN('Reason:')
			-- Replace special chars to have delimiters
			SET @temp1 = REPLACE(@rawstring,CHAR(13),'||')
			SET @temp1 = REPLACE(@temp1,CHAR(10),'||')
			-- Loop For Extracting Reason Header
			WHILE @i < @n
			BEGIN
			SET @temp1 = SUBSTRING(@temp1,PATINDEX('%Reason:%',@temp1),LEN(@temp1))
				SET @temp2 = @temp2 + SUBSTRING(@temp1,1,PATINDEX('%||%',@temp1) - 1 ) + CHAR(13) + CHAR(10)
				SET @temp1 = SUBSTRING(@temp1,3,LEN(@temp1))
				SET @i = @i + 1
			END
			RETURN @temp2
END
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DATA MINING
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Script Execution starting ...')

IF OBJECT_ID ('tempdb..#CallInfo' ) IS NOT NULL DROP TABLE #CallInfo
SELECT DISTINCT
	   [SessionId_A]
	  ,[Call_Status]
	  ,cast(null as varchar(100)) as Call_Mode_L1_A
	  ,cast(null as varchar(100)) as Call_Mode_L2_A
	  ,cast(null as varchar(100)) as Call_Mode_L1_B
	  ,cast(null as varchar(100)) as Call_Mode_L2_B
	  ,[callDir]
	  ,CASE WHEN [callDir] like 'A->%' THEN [callStartTimeStamp_A]
			WHEN [callDir] like 'B->%' THEN [callStartTimeStamp_B]
			END AS Call_Setup_Start_Trigger
	  ,CASE WHEN [callSetupEndTimestamp_A] is null THEN [callSetupEndTimestamp_B]
			WHEN [callSetupEndTimestamp_B] is null THEN [callSetupEndTimestamp_A]
			WHEN [callSetupEndTimestamp_A] < [callSetupEndTimestamp_B] THEN [callSetupEndTimestamp_B]
			ELSE [callSetupEndTimestamp_A]
			END AS Call_Setup_End_Trigger
	  ,CASE WHEN [callEndTimestamp_A] is null THEN [callEndTimestamp_B]
			WHEN [callEndTimestamp_B] is null THEN [callEndTimestamp_A]
			WHEN [callEndTimestamp_A] < [callEndTimestamp_B] THEN [callEndTimestamp_B]
			ELSE [callEndTimestamp_A]
			END AS Call_End_Trigger
      ,[callStatus_A]
      ,[SQ_CST_A]
      ,[startNetId_A]
      ,[callStartTimeStamp_A]
	  ,[startTechnology_A]
	  ,cast(null as datetime2(3)) as Paging_Timestamp_A
	  ,cast(null as varchar(100)) as Paging_Technology_A
	  ,cast(null as datetime2(3)) as CMService_Timestamp_1st_A
	  ,cast(null as varchar(100)) as CMService_Technology_1st_A
	  ,cast(null as datetime2(3)) as CMService_Timestamp_Lst_A
	  ,cast(null as varchar(100)) as CMService_Technology_Lst_A
	  ,cast(null as datetime2(3)) as CCSetup_Timestamp_A
	  ,cast(null as varchar(100)) as CCSetup_Technology_A
	  ,cast(null as datetime2(3)) as CCCallProceeding_Timestamp_A
	  ,cast(null as varchar(100)) as CCCallProceeding_Technology_A
	  ,cast(null as datetime2(3)) as CCAlerting_Timestamp_A
	  ,cast(null as varchar(100)) as CCAlerting_Technology_A
	  ,cast(null as datetime2(3)) as CCConnect_Timestamp_A
	  ,cast(null as varchar(100)) as CCConnect_Technology_A
	  ,cast(null as datetime2(3)) as CCConnectAck_Timestamp_A
	  ,cast(null as varchar(100)) as CCConnectAck_Technology_A
	  ,cast(null as datetime2(3)) as CCDisconnect_Timestamp_A
	  ,cast(null as varchar(100)) as CCDisconnect_Technology_A
	  ,cast(null as datetime2(3)) as CSFB_Timestamp_A
	  ,cast(null as varchar(2))   as CSFB_Flag_A
	  ,cast(null as datetime2(3)) as SRVCC_Timestamp_A
	  ,cast(null as datetime2(3)) as SipInvite_Timestamp_A
	  ,cast(null as varchar(100)) as SipInvite_Technology_A
	  ,cast(null as datetime2(3)) as SipTrying_Timestamp_A
	  ,cast(null as varchar(100)) as SipTrying_Technology_A
	  ,cast(null as datetime2(3)) as SipSessProgress_Timestamp_A
	  ,cast(null as varchar(100)) as SipSessProgress_Technology_A
	  ,cast(null as datetime2(3)) as SipRinging_Timestamp_A
	  ,cast(null as varchar(100)) as SipRinging_Technology_A
	  ,cast(null as datetime2(3)) as Sip200Ok_Timestamp_A
	  ,cast(null as varchar(100)) as Sip200Ok_Technology_A
	  ,cast(null as datetime2(3)) as SipAck_Timestamp_A
	  ,cast(null as varchar(100)) as SipAck_Technology_A
	  ,cast(null as datetime2(3)) as SipSetupBye_Timestamp_A
	  ,cast(null as datetime2(3)) as SipByeCancel_Timestamp_A
	  ,cast(null as varchar(100)) as SipByeCancel_Technology_A
	  ,cast(null as varchar(200)) as SipByeCancel_Reason_A
	  ,cast(null as varchar(100)) as CS_Setup_Start_Time_A
	  ,cast(null as varchar(100)) as CS_Setup_End_Time_A
	  ,cast(null as varchar(100)) as CS_Setup_Success_A
	  ,cast(null as varchar(100)) as CS_Setup_Call_Mode_A
	  ,cast(null as varchar(100)) as VoLTE_Setup_Start_Time_A
	  ,cast(null as varchar(100)) as VoLTE_Setup_End_Time_A
	  ,cast(null as varchar(100)) as VoLTE_Setup_Success_A
	  ,cast(null as varchar(100)) as VoLTE_Setup_Call_Mode_A
	  ,cast(null as varchar(100)) as L3_SC_Technology_A
	  ,cast(null as varchar(100)) as NW_SC_Technology_A
	  ,cast(null as varchar(100)) as NW_AC_Technology_A
      ,[callSetupEndTimestamp_A]
      ,[callDisconnectTimeStamp_A]
      ,[callEndTimeStamp_A]
      ,[callDuaration_A]
      ,[SessionId_B]
      ,[callStatus_B]
      ,[startNetId_B]
      ,[SQ_CST_B]
      ,[callStartTimeStamp_B]
	  ,[startTechnology_B]
	  ,cast(null as datetime2(3)) as Paging_Timestamp_B
	  ,cast(null as varchar(100)) as Paging_Technology_B
	  ,cast(null as datetime2(3)) as CMService_Timestamp_1st_B
	  ,cast(null as varchar(100)) as CMService_Technology_1st_B
	  ,cast(null as datetime2(3)) as CMService_Timestamp_Lst_B
	  ,cast(null as varchar(100)) as CMService_Technology_Lst_B
	  ,cast(null as datetime2(3)) as CCSetup_Timestamp_B
	  ,cast(null as varchar(100)) as CCSetup_Technology_B
	  ,cast(null as datetime2(3)) as CCCallProceeding_Timestamp_B
	  ,cast(null as varchar(100)) as CCCallProceeding_Technology_B
	  ,cast(null as datetime2(3)) as CCAlerting_Timestamp_B
	  ,cast(null as varchar(100)) as CCAlerting_Technology_B
	  ,cast(null as datetime2(3)) as CCConnect_Timestamp_B
	  ,cast(null as varchar(100)) as CCConnect_Technology_B
	  ,cast(null as datetime2(3)) as CCConnectAck_Timestamp_B
	  ,cast(null as varchar(100)) as CCConnectAck_Technology_B
	  ,cast(null as datetime2(3)) as CCDisconnect_Timestamp_B
	  ,cast(null as varchar(100)) as CCDisconnect_Technology_B
	  ,cast(null as datetime2(3)) as CSFB_Timestamp_B
	  ,cast(null as varchar(2))   as CSFB_Flag_B
	  ,cast(null as datetime2(3)) as SRVCC_Timestamp_B
	  ,cast(null as datetime2(3)) as SipInvite_Timestamp_B
	  ,cast(null as varchar(100)) as SipInvite_Technology_B
	  ,cast(null as datetime2(3)) as SipTrying_Timestamp_B
	  ,cast(null as varchar(100)) as SipTrying_Technology_B
	  ,cast(null as datetime2(3)) as SipSessProgress_Timestamp_B
	  ,cast(null as varchar(100)) as SipSessProgress_Technology_B
	  ,cast(null as datetime2(3)) as SipRinging_Timestamp_B
	  ,cast(null as varchar(100)) as SipRinging_Technology_B
	  ,cast(null as datetime2(3)) as Sip200Ok_Timestamp_B
	  ,cast(null as varchar(100)) as Sip200Ok_Technology_B
	  ,cast(null as datetime2(3)) as SipAck_Timestamp_B
	  ,cast(null as varchar(100)) as SipAck_Technology_B
	  ,cast(null as datetime2(3)) as SipSetupBye_Timestamp_B
	  ,cast(null as datetime2(3)) as SipByeCancel_Timestamp_B
	  ,cast(null as varchar(100)) as SipByeCancel_Technology_B
	  ,cast(null as varchar(200)) as SipByeCancel_Reason_B
	  ,cast(null as varchar(100)) as CS_Setup_Start_Time_B
	  ,cast(null as varchar(100)) as CS_Setup_End_Time_B
	  ,cast(null as varchar(100)) as CS_Setup_Success_B
	  ,cast(null as varchar(100)) as CS_Setup_Call_Mode_B
	  ,cast(null as varchar(100)) as VoLTE_Setup_Start_Time_B
	  ,cast(null as varchar(100)) as VoLTE_Setup_End_Time_B
	  ,cast(null as varchar(100)) as VoLTE_Setup_Success_B
	  ,cast(null as varchar(100)) as VoLTE_Setup_Call_Mode_B
	  ,cast(null as varchar(100)) as L3_SC_Technology_B
	  ,cast(null as varchar(100)) as NW_SC_Technology_B
	  ,cast(null as varchar(100)) as NW_AC_Technology_B
      ,[callSetupEndTimestamp_B]
      ,[callDisconnectTimeStamp_B]
      ,[callEndTimeStamp_B]
  INTO #CallInfo
  FROM [NEW_Call_Info_2018]

-- CSFB START MARKER - INDICATES TEST START
-- ORIGINAL CODE WITH SWISSQUAL DLL DECODER
/*
		IF OBJECT_ID ('tempdb..#CSFBStart' ) IS NOT NULL DROP TABLE #CSFBStart
		select 
				  l3.SessionId,
				  max(l3.MsgTime) as MsgTime,
				  l3.message,
				  case when Cause like'mobile terminating%' then 'MT' else
					 case when Cause like'mobile originating%' then 'MO' else 'Unknown' end 
				  end as  Flag,
				  case when Cause like'mobile terminating%' then 'CSFB on MT' else
					 case when Cause like'mobile originating%' then 'CSFB on MO' else 'Unknown' end 
				  end as CSFBType
		into #CSFBStart
		from
			   AN_Layer3 l3
		where message ='Extended service request' and Cause like'mobile % CS fallback or 1xCS fallback'
		group by l3.SessionId,Message,
					 case when Cause like'mobile terminating%' then 'MT' else
					 case when Cause like'mobile originating%' then 'MO' else 'Unknown' end 
				  end ,
				  case when Cause like'mobile terminating%' then 'CSFB on MT' else
					 case when Cause like'mobile originating%' then 'CSFB on MO' else 'Unknown' end 
				  end 
		ORDER BY SessionId
*/

-- USING KOBA-s TOOL OUTPUT
		IF OBJECT_ID ('tempdb..#CSFBStart' ) IS NOT NULL DROP TABLE #CSFBStart
		SELECT [SESSIONID] as SessionId
			  ,[STARTTIME] as MsgTime
			  ,[MO_MT] as  Flag
		into #CSFBStart
		  FROM KB_CsfbCheck

		UPDATE #CallInfo
		SET  CSFB_Timestamp_A = ds.MsgTime
			,CSFB_Flag_A      = ds.Flag
		FROM #CSFBStart ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE (ci.callDir like 'A->%' and ds.Flag like 'MO') OR (ci.callDir like 'B->%' and ds.Flag like 'MT')

		UPDATE #CallInfo
		SET  CSFB_Timestamp_B = ds.MsgTime
			,CSFB_Flag_B      = ds.Flag
		FROM #CSFBStart ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE (ci.callDir like 'B->%' and ds.Flag like 'MO') OR (ci.callDir like 'A->%' and ds.Flag like 'MT')

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: CSFB Triggers imported in table ...')

/****** PAGING MARKER ******/
		IF OBJECT_ID ('tempdb..#PagingCS' ) IS NOT NULL DROP TABLE #PagingCS
		SELECT    ds.[SessionId]
				 ,ds.[MsgTime]
				 ,ds.[Technology]
				 ,'Paging' AS Message
		INTO #PagingCS
		FROM AN_Layer3 ds
		WHERE [Message] like 'CS Serv%'

		UPDATE #CallInfo
		SET  Paging_Timestamp_A		= ds.MsgTime
			,Paging_Technology_A    = ds.Technology
		FROM #PagingCS ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'

		UPDATE #CallInfo
		SET  Paging_Timestamp_B		= ds.MsgTime
			,Paging_Technology_B    = ds.Technology
		FROM #PagingCS ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: CS Service Notification Triggers imported in table ...')

IF OBJECT_ID ('tempdb..#PagingKPI10152' ) IS NOT NULL DROP TABLE #PagingKPI10152
		SELECT SessionId,TestId,NetworkId
				 ,[StartTime] AS MsgTime
				 ,cast(null as varchar(100)) as Technology
		INTO #PagingKPI10152
		FROM [ResultsKPI] 
		WHERE [KPIId] IN (10152)

		UPDATE #PagingKPI10152
		SET Technology = ni.technology
		FROM NetworkInfo ni 
		LEFT OUTER JOIN #PagingKPI10152 p ON p.NetworkId = ni.NetworkId

		UPDATE #CallInfo
		SET  Paging_Timestamp_A		= CASE WHEN Paging_Timestamp_A  is not null  THEN Paging_Timestamp_A  ELSE ds.MsgTime	 END
			,Paging_Technology_A    = CASE WHEN Paging_Technology_A is not null  THEN Paging_Technology_A ELSE ds.Technology END
		FROM #PagingKPI10152 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'

		UPDATE #CallInfo
		SET  Paging_Timestamp_B		= CASE WHEN Paging_Timestamp_B	   is not null  THEN Paging_Timestamp_B		ELSE ds.MsgTime	 END
			,Paging_Technology_B    = CASE WHEN Paging_Technology_B    is not null  THEN Paging_Technology_B    ELSE ds.Technology END
		FROM #PagingKPI10152 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Paging based on KPI 10152 imported in table ...')
		IF OBJECT_ID ('tempdb..#PagingKPI10150' ) IS NOT NULL DROP TABLE #PagingKPI10150
		SELECT SessionId,TestId,NetworkId
				 ,[StartTime] AS MsgTime
				 ,cast(null as varchar(100)) as Technology
		INTO #PagingKPI10150
		FROM [ResultsKPI] 
		WHERE [KPIId] IN (10150)

		UPDATE #PagingKPI10150
		SET Technology = ni.technology
		FROM NetworkInfo ni 
		LEFT OUTER JOIN #PagingKPI10150 p ON p.NetworkId = ni.NetworkId

		UPDATE #CallInfo
		SET  Paging_Timestamp_A		= CASE WHEN Paging_Timestamp_A  is not null  THEN Paging_Timestamp_A  ELSE ds.MsgTime	 END
			,Paging_Technology_A    = CASE WHEN Paging_Technology_A is not null  THEN Paging_Technology_A ELSE ds.Technology END
		FROM #PagingKPI10150 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'

		UPDATE #CallInfo
		SET  Paging_Timestamp_B		= CASE WHEN Paging_Timestamp_B	   is not null  THEN Paging_Timestamp_B		ELSE ds.MsgTime	 END
			,Paging_Technology_B    = CASE WHEN Paging_Technology_B    is not null  THEN Paging_Technology_B    ELSE ds.Technology END
		FROM #PagingKPI10150 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Paging based on KPI 10150 imported in table ...')

IF OBJECT_ID ('tempdb..#PagingKPI10165' ) IS NOT NULL DROP TABLE #PagingKPI10165
		SELECT SessionId,TestId,NetworkId
				 ,[StartTime] AS MsgTime
				 ,cast(null as varchar(100)) as Technology
		INTO #PagingKPI10165
		FROM [ResultsKPI] 
		WHERE [KPIId] IN (10165)

		UPDATE #PagingKPI10165
		SET Technology = ni.technology
		FROM NetworkInfo ni 
		LEFT OUTER JOIN #PagingKPI10165 p ON p.NetworkId = ni.NetworkId

		UPDATE #CallInfo
		SET  Paging_Timestamp_A		= CASE WHEN Paging_Timestamp_A  is not null  THEN Paging_Timestamp_A  ELSE ds.MsgTime	 END
			,Paging_Technology_A    = CASE WHEN Paging_Technology_A is not null  THEN Paging_Technology_A ELSE ds.Technology END
		FROM #PagingKPI10165 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'

		UPDATE #CallInfo
		SET  Paging_Timestamp_B		= CASE WHEN Paging_Timestamp_B	   is not null  THEN Paging_Timestamp_B		ELSE ds.MsgTime	 END
			,Paging_Technology_B    = CASE WHEN Paging_Technology_B    is not null  THEN Paging_Technology_B    ELSE ds.Technology END
		FROM #PagingKPI10165 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Paging based on KPI 10165 imported in table ...')

IF OBJECT_ID ('tempdb..#PagingKPI10141' ) IS NOT NULL DROP TABLE #PagingKPI10141
		SELECT SessionId,TestId,NetworkId
				 ,[EndTime] AS MsgTime
				 ,cast(null as varchar(100)) as Technology
		INTO #PagingKPI10141
		FROM [ResultsKPI] 
		WHERE [KPIId] IN (10141)

		UPDATE #PagingKPI10141
		SET Technology = ni.technology
		FROM NetworkInfo ni 
		LEFT OUTER JOIN #PagingKPI10141 p ON p.NetworkId = ni.NetworkId

		UPDATE #CallInfo
		SET  Paging_Timestamp_A		= CASE WHEN Paging_Timestamp_A  is not null  THEN Paging_Timestamp_A  ELSE ds.MsgTime	 END
			,Paging_Technology_A    = CASE WHEN Paging_Technology_A is not null  THEN Paging_Technology_A ELSE ds.Technology END
		FROM #PagingKPI10141 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'

		UPDATE #CallInfo
		SET  Paging_Timestamp_B		= CASE WHEN Paging_Timestamp_B	   is not null  THEN Paging_Timestamp_B		ELSE ds.MsgTime	 END
			,Paging_Technology_B    = CASE WHEN Paging_Technology_B    is not null  THEN Paging_Technology_B    ELSE ds.Technology END
		FROM #PagingKPI10141 ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Paging based on KPI 10141 imported in table ...')

IF OBJECT_ID ('tempdb..#PagingWA1' ) IS NOT NULL DROP TABLE #PagingWA1
		SELECT   [SessionId]
				,[MsgTime]				  AS MsgTime
				,[Technology]             AS Technology
				,[Message]
				,1 AS Valid
		INTO #PagingWA1
		FROM AN_Layer3 ds
		WHERE [Message] like 'Paging resp%'
		UNION ALL 
		SELECT   [SessionId]
				,[MsgTime]				  AS MsgTime
				,[Technology]             AS Technology
				,[Message]
				,1 AS Valid
		FROM AN_Layer3 WHERE Message like 'RRCConnectionRequest%' AND CAUSE like 'mt_Access'

		IF OBJECT_ID ('tempdb..#PagingWA' ) IS NOT NULL DROP TABLE #PagingWA
		Select [SessionId],MIN(MsgTime) AS MsgTime,MIN(Technology) AS Technology
		INTO #PagingWA
		FROM
				(SELECT  p.[SessionId]
					   ,p.MsgTime
					   ,p.Technology
				FROM #PagingWA1 p
				LEFT OUTER JOIN #CallInfo ci 
					on (p.[SessionId] = ci.SessionId_B and ci.callDir like 'A->%') OR (p.[SessionId] = ci.SessionId_A and ci.callDir like 'B->%')
				WHERE p.MsgTime between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger) AS pw
		GROUP BY [SessionId]

		UPDATE #CallInfo
		SET  Paging_Timestamp_A		= CASE WHEN Paging_Timestamp_A  is not null  THEN Paging_Timestamp_A  ELSE ds.MsgTime	 END
			,Paging_Technology_A    = CASE WHEN Paging_Technology_A is not null  THEN Paging_Technology_A ELSE ds.Technology END
		FROM #PagingWA ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'

		UPDATE #CallInfo
		SET  Paging_Timestamp_B		= CASE WHEN Paging_Timestamp_B	   is not null  THEN Paging_Timestamp_B		ELSE ds.MsgTime	 END
			,Paging_Technology_B    = CASE WHEN Paging_Technology_B    is not null  THEN Paging_Technology_B    ELSE ds.Technology END
		FROM #PagingWA ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Paging based on Paging response workarround imported in table ...')

/****** INVITE MARKER - INDICATES VOICE CALL ESTABLISHMENT PROCEDURE START ******/
IF OBJECT_ID ('tempdb..#CMService' ) IS NOT NULL DROP TABLE #CMService
		SELECT [SessionId]
				 ,COUNT([MsgTime]) AS Attempts 
				 ,MIN([MsgTime])   AS MsgTime_1
				 ,MIN([NetworkId]) AS NetworkId_1
				 ,CAST(null as varchar(100)) as Technology_1
				 ,MAX([MsgTime])   AS MsgTime_F
				 ,MAX([NetworkId]) AS NetworkId_F
				 ,CAST(null as varchar(100)) as Technology_F
		INTO #CMService
		  FROM
				(SELECT DISTINCT
					   [SessionId]
					  ,[NetworkId]
					  ,[MsgTime]
					  ,[Message]
				  FROM AN_Layer3 p
				  WHERE [Message] like 'CM Service Request') AS cm
		  GROUP BY [SessionId]
		  ORDER BY [SessionId]

		UPDATE #CMService
		SET Technology_1 = ni.technology
		FROM NetworkInfo ni
		RIGHT OUTER JOIN #CMService ON NetworkId_1 = NetworkId

		UPDATE #CMService
		SET Technology_F = ni.technology
		FROM NetworkInfo ni
		RIGHT OUTER JOIN #CMService ON NetworkId_F = NetworkId

		UPDATE #CallInfo
		SET  CMService_Timestamp_1st_A	= MsgTime_1
			,CMService_Technology_1st_A	= Technology_1
		FROM #CMService ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime_1] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'

		UPDATE #CallInfo
		SET  CMService_Timestamp_Lst_A	= MsgTime_F
			,CMService_Technology_Lst_A	= Technology_F
		FROM #CMService ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime_F] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'A->%'

		UPDATE #CallInfo
		SET  CMService_Timestamp_1st_A	= MsgTime_1
			,CMService_Technology_1st_A	= Technology_1
		FROM #CMService ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = ds.SessionId and ds.[MsgTime_1] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'

		UPDATE #CallInfo
		SET  CMService_Timestamp_Lst_B	= MsgTime_F
			,CMService_Technology_Lst_B	= Technology_F
		FROM #CMService ds
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = ds.SessionId and ds.[MsgTime_F] between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger
		WHERE ci.callDir like 'B->%'
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: CM Service Request imported in table ...')

/****** SRVCC_Alerting MARKER ******/
		IF OBJECT_ID ('tempdb..#SRVCCa' ) IS NOT NULL DROP TABLE #SRVCCa
		SELECT    ds.[SessionId]
				 ,ds.[MsgTime]
				 ,ds.[Technology]
				 ,'SRVCCa' AS Message
		INTO #SRVCCa
		FROM AN_Layer3 ds
		WHERE [Message] like '%MobilityFromEUTRACommand%'

/****** SIP ERRORS MARKER ******/
		IF OBJECT_ID ('tempdb..#SipErrors' ) IS NOT NULL DROP TABLE #SipErrors
		SELECT DISTINCT
			   [SessionId]
			  ,[SessionIdA]
			  ,[SessionIdB]
			  ,[Technology]
			  ,[MsgTime]
			  ,null AS [Direction]
			  ,'IMS SIP BYE' AS [Message]
			 INTO #SipErrors
			 FROM AN_Layer3
			 WHERE ([Message] like 'IMS SIP CANCEL%' OR [Message] like 'IMS SIP BYE (Request)' or [Message] like 'IMS SIP INVITE Error%') and Direction is not null

/****** CC MARKERS - INDICATES VOICE CALL ESTABLISHMENT PROCEDURE START ******/
		IF OBJECT_ID ('tempdb..#callControl1' ) IS NOT NULL DROP TABLE #callControl1
		SELECT
			   p.[SessionId]
			  ,ci.callDir
			  ,p.[SessionIdA]
			  ,p.[SessionIdB]
			  ,p.[Technology]
			  ,p.[MsgTime]
			  ,p.[Direction]
			  ,p.[Message]
		INTO #callControl1
		FROM (SELECT DISTINCT
			   [SessionId]
			  ,[SessionIdA]
			  ,[SessionIdB]
			  ,[Technology]
			  ,[MsgTime]
			  ,[Direction]
			  ,[Message]
			 FROM AN_Layer3
			 WHERE ([Message] like 'Setup' OR [Message] like 'Call pro%' OR [Message] like 'Call conf%' OR [Message] like 'Alerting' OR [Message] like 'Connect' OR [Message] like 'Connect Acknowledge') and Direction is not null ) AS  p
		  LEFT OUTER JOIN #CallInfo ci ON p.SessionIdA = ci.SessionId_A and p.MsgTime between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger 
		WHERE [Technology] NOT LIKE '%LTE%'
		UNION ALL
		SELECT
			   p.[SessionId]
			  ,ci.callDir
			  ,p.[SessionIdA]
			  ,p.[SessionIdB]
			  ,p.[Technology]
			  ,p.[MsgTime]
			  ,p.[Direction]
			  ,p.[Message]
		FROM (SELECT DISTINCT
			   [SessionId]
			  ,[SessionIdA]
			  ,[SessionIdB]
			  ,[Technology]
			  ,[MsgTime]
			  ,null AS [Direction]
			  ,[Message]
			 FROM AN_Layer3
			 WHERE [Message] like 'Disconnect' and Direction is not null) AS  p
		  LEFT OUTER JOIN #CallInfo ci ON p.SessionIdA = ci.SessionId_A and p.MsgTime between ci.Call_Setup_Start_Trigger and ci.Call_End_Trigger 
		WHERE [Technology] NOT LIKE '%LTE%'

		IF OBJECT_ID ('tempdb..#callControl' ) IS NOT NULL DROP TABLE #callControl
		SELECT SessionId,SessionIdA,SessionIdB,Message,Direction
			   ,MIN(MsgTime) AS Min_MsgTime
			   ,MAX(MsgTime) AS Max_MsgTime
			   ,MIN(Technology) AS Technology
			   ,cast (null as varchar(5)) AS DIR
		INTO #callControl 
		FROM #callControl1 nw
		GROUP BY SessionId,SessionIdA,SessionIdB,Message,Direction,callDir
		ORDER BY SessionId, Min_MsgTime

		UPDATE #callControl
		SET DIR = ci.callDir
		from #CallInfo ci
		RIGHT OUTER JOIN #callControl cc on ci.SessionId_A = cc.SessionIdA
		
		-- CLEANING UP CC MESSAGESS NOT RELEVANT TO CALL
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'Setup' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'Setup' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'Setup' and Direction like 'U'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'Setup' and Direction like 'U'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'Call Proceeding'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'Call Proceeding'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'Call Confirmed'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'Call Confirmed'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'Alerting' and Direction like 'U'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'Alerting' and Direction like 'U'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'Alerting' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'Alerting' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'Connect' and Direction like 'U'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'Connect' and Direction like 'U'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'Connect' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'Connect' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'Connect Acknowledge' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'Connect Acknowledge' and Direction like 'D'
		DELETE FROM #callControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'Connect Acknowledge' and Direction like 'U'
		DELETE FROM #callControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'Connect Acknowledge' and Direction like 'U'

		IF OBJECT_ID ('tempdb..#ccGroup' ) IS NOT NULL DROP TABLE #ccGroup
		SELECT  a.SessionId,a.SessionIdA,a.SessionIdB
			   ,a.MsgTime			AS Setup_MsgTime
			   ,a.Technology		AS Setup_Technology
			   ,b.MsgTime			AS CallProceed_MsgTime
			   ,b.Technology		AS CallProceed_Technology
			   ,c.MsgTime			AS Alerting_MsgTime
			   ,c.Technology		AS Alerting_Technology
			   ,d.MsgTime			AS Connect_MsgTime
			   ,d.Technology		AS Connect_Technology
			   ,e.MsgTime			AS ConnectAck_MsgTime
			   ,e.Technology		AS ConnectAck_Technology
			   ,f.MsgTime			AS Disconnect_MsgTime
			   ,f.Technology		AS Disconnect_Technology
		INTO #ccGroup
		FROM            (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #callControl WHERE Message like 'Setup'				) AS a
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #callControl WHERE Message like 'Call%'				) AS b ON b.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #callControl WHERE Message like 'Aler%'				) AS c ON c.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #callControl WHERE Message like 'Connect'			) AS d ON d.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Max_MsgTime AS MsgTime,Technology FROM #callControl WHERE Message like 'Connect Acknowledge') AS e ON e.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Max_MsgTime AS MsgTime,Technology FROM #callControl WHERE Message like 'Disconne%'			) AS f ON f.SessionId = a.SessionId

		UPDATE #CallInfo
		SET  CCSetup_Timestamp_A			= Setup_MsgTime
			,CCSetup_Technology_A			= Setup_Technology
			,CCCallProceeding_Timestamp_A	= CallProceed_MsgTime
			,CCCallProceeding_Technology_A	= CallProceed_Technology
			,CCAlerting_Timestamp_A			= Alerting_MsgTime
			,CCAlerting_Technology_A		= Alerting_Technology
			,CCConnect_Timestamp_A			= Connect_MsgTime
			,CCConnect_Technology_A			= Connect_Technology
			,CCConnectAck_Timestamp_A		= ConnectAck_MsgTime
			,CCConnectAck_Technology_A		= ConnectAck_Technology
			,CCDisconnect_Timestamp_A		= Disconnect_MsgTime
			,CCDisconnect_Technology_A		= Disconnect_Technology
		FROM ( SELECT * FROM #ccGroup WHERE SessionId = SessionIdA ) a
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = a.SessionIdA

		UPDATE #CallInfo
		SET  CCSetup_Timestamp_B			= Setup_MsgTime
			,CCSetup_Technology_B			= Setup_Technology
			,CCCallProceeding_Timestamp_B	= CallProceed_MsgTime
			,CCCallProceeding_Technology_B	= CallProceed_Technology
			,CCAlerting_Timestamp_B			= Alerting_MsgTime
			,CCAlerting_Technology_B		= Alerting_Technology
			,CCConnect_Timestamp_B			= Connect_MsgTime
			,CCConnect_Technology_B			= Connect_Technology
			,CCConnectAck_Timestamp_B		= ConnectAck_MsgTime
			,CCConnectAck_Technology_B		= ConnectAck_Technology
			,CCDisconnect_Timestamp_B		= Disconnect_MsgTime
			,CCDisconnect_Technology_B		= Disconnect_Technology
		FROM ( SELECT * FROM #ccGroup WHERE SessionId = SessionIdB ) a
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = a.SessionIdA

-- DETERMINE CS CALL SETUP TIMESPAN
		IF OBJECT_ID ('tempdb..#csSummary' ) IS NOT NULL DROP TABLE #csSummary
		SELECT SessionId,SessionIdA,SessionIdB,CS_Setup_Start,CS_Setup_End,CS_Setup_Success,dbo.recREPLACE(CS_Call_Mode) AS CS_Call_Mode
		INTO #csSummary
		FROM
		(SELECT SessionId,SessionIdA,SessionIdB,
			   MIN(Min_MsgTime) AS CS_Setup_Start,
			   MAX(Max_MsgTime) AS CS_Setup_End,
			   SUM(CASE WHEN  Message like 'Connect' OR  Message like 'Connect Acknowledge' THEN 1 ELSE 0 END) AS CS_Setup_Success,
			   STUFF((
									SELECT '/' + (CASE WHEN [technology] like '%LTE%' THEN 'LTE' WHEN [technology] like '%UMTS%' THEN 'UMTS' WHEN [technology] like '%GSM%' THEN 'GSM' ELSE '' END) 
									FROM #callControl1 WHERE cc.SessionId = SessionId ORDER BY MsgTime
									FOR XML PATH('')
									), 1, 1, '') AS CS_Call_Mode
		FROM #callControl cc
		WHERE Message not like 'Disconn%'
		GROUP BY SessionId,SessionIdA,SessionIdB) AS A

		UPDATE #CallInfo
		SET  CS_Setup_Start_Time_A    = CS_Setup_Start
			,CS_Setup_End_Time_A      = CS_Setup_End
			,CS_Setup_Success_A       = CS_Setup_Success
			,CS_Setup_Call_Mode_A     = CS_Call_Mode	
		FROM #csSummary s
		RIGHT OUTER JOIN #CallInfo ci ON s.SessionId = ci.SessionId_A

		UPDATE #CallInfo
		SET  CS_Setup_Start_Time_B    = CS_Setup_Start
			,CS_Setup_End_Time_B      = CS_Setup_End
			,CS_Setup_Success_B       = CS_Setup_Success
			,CS_Setup_Call_Mode_B     = CS_Call_Mode	
		FROM #csSummary s
		RIGHT OUTER JOIN #CallInfo ci ON s.SessionId = ci.SessionId_B
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Legacy Call Control Messages imported in table ...')

/****** SIP MARKER - INDICATES VOICE CALL ESTABLISHMENT PROCEDURE START ******/
		IF OBJECT_ID ('tempdb..#sipControl1' ) IS NOT NULL DROP TABLE #sipControl1
		SELECT
			   p.[SessionId]
			  ,ci.callDir
			  ,p.[SessionIdA]
			  ,p.[SessionIdB]
			  ,p.[Technology]
			  ,p.[MsgTime]
			  ,p.[Direction]
			  ,p.[Message]
		INTO #sipControl1
		FROM (SELECT DISTINCT
			   [SessionId]
			  ,[SessionIdA]
			  ,[SessionIdB]
			  ,[Technology]
			  ,[MsgTime]
			  ,[Direction]
			  ,[Message]
			 FROM AN_Layer3
			 WHERE ([Message] like 'IMS SIP INVITE (Request)' OR [Message] like 'IMS SIP INVITE (Trying)' OR [Message] like 'IMS SIP INVITE (Session in Progress)' OR [Message] like 'IMS SIP INVITE (Ringing)' OR [Message] like 'IMS SIP INVITE (OK)' OR [Message] like 'IMS SIP ACK (Request)') and Direction is not null ) AS  p
		  LEFT OUTER JOIN #CallInfo ci ON p.SessionIdA = ci.SessionId_A and p.MsgTime between ci.Call_Setup_Start_Trigger and ci.Call_Setup_End_Trigger 
		WHERE [Technology] LIKE '%LTE%'
		UNION ALL
		SELECT
			   p.[SessionId]
			  ,ci.callDir
			  ,p.[SessionIdA]
			  ,p.[SessionIdB]
			  ,p.[Technology]
			  ,p.[MsgTime]
			  ,p.[Direction]
			  ,p.[Message]
		FROM (SELECT DISTINCT
			   [SessionId]
			  ,[SessionIdA]
			  ,[SessionIdB]
			  ,[Technology]
			  ,[MsgTime]
			  ,null AS [Direction]
			  ,'IMS SIP BYE' AS [Message]
			 FROM AN_Layer3
			 WHERE ([Message] like 'IMS SIP CANCEL%' OR [Message] like 'IMS SIP BYE (Request)' or [Message] like 'IMS SIP INVITE Error%') and Direction is not null) AS  p
		  LEFT OUTER JOIN #CallInfo ci ON p.SessionIdA = ci.SessionId_A and p.MsgTime between ci.Call_Setup_Start_Trigger and ci.Call_End_Trigger 
		WHERE [Technology] LIKE '%LTE%'

		IF OBJECT_ID ('tempdb..#sipControl' ) IS NOT NULL DROP TABLE #sipControl
		SELECT SessionId,SessionIdA,SessionIdB,Message,Direction
			   ,MIN(MsgTime) AS Min_MsgTime
			   ,MAX(MsgTime) AS Max_MsgTime
			   ,MIN(Technology) AS Technology
			   ,cast (null as varchar(5)) AS DIR
		INTO #sipControl
		FROM #sipControl1 
		GROUP BY SessionId,SessionIdA,SessionIdB,Message,Direction,callDir
		ORDER BY SessionId, Min_MsgTime

		UPDATE #sipControl
		SET DIR = ci.callDir
		from #CallInfo ci
		RIGHT OUTER JOIN #sipControl cc on ci.SessionId_A = cc.SessionIdA

		-- CLEANING UP SIP Messages THAT MAKE NO SENSE
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Request)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Request)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Request)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Request)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Trying)'  and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Trying)'  and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Trying)'  and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Trying)'  and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Session in Progress)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Session in Progress)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Session in Progress)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Session in Progress)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Ringing)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Ringing)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (Ringing)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (Ringing)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (OK)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (OK)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'IMS SIP INVITE (OK)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'IMS SIP INVITE (OK)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdA and Message like 'IMS SIP ACK (Request)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdB and Message like 'IMS SIP ACK (Request)' and Direction like 'D'
		DELETE FROM #sipControl WHERE DIR like 'A->%' and SessionId = SessionIdB and Message like 'IMS SIP ACK (Request)' and Direction like 'U'
		DELETE FROM #sipControl WHERE DIR like 'B->%' and SessionId = SessionIdA and Message like 'IMS SIP ACK (Request)' and Direction like 'U'

		IF OBJECT_ID ('tempdb..#sipGroup' ) IS NOT NULL DROP TABLE #sipGroup
		SELECT  a.SessionId,a.SessionIdA,a.SessionIdB
			   ,a.MsgTime			AS Setup_MsgTime
			   ,a.Technology		AS Setup_Technology
			   ,b.MsgTime			AS CallProceed_MsgTime
			   ,b.Technology		AS CallProceed_Technology
			   ,g.MsgTime			AS Progress_MsgTime
			   ,g.Technology		AS Progress_Technology
			   ,c.MsgTime			AS Alerting_MsgTime
			   ,c.Technology		AS Alerting_Technology
			   ,d.MsgTime			AS Connect_MsgTime
			   ,d.Technology		AS Connect_Technology
			   ,e.MsgTime			AS ConnectAck_MsgTime
			   ,e.Technology		AS ConnectAck_Technology
			   ,f.MsgTime			AS Disconnect_MsgTime
			   ,f.Technology		AS Disconnect_Technology
		INTO #sipGroup
		FROM            (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #sipControl WHERE Message like 'IMS SIP INVITE (Request)'				) AS a
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #sipControl WHERE Message like 'IMS SIP INVITE (Trying)'					) AS b ON b.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #sipControl WHERE Message like 'IMS SIP INVITE (Ringing)'				) AS c ON c.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Min_MsgTime AS MsgTime,Technology FROM #sipControl WHERE Message like 'IMS SIP INVITE (OK)'						) AS d ON d.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Max_MsgTime AS MsgTime,Technology FROM #sipControl WHERE Message like 'IMS SIP ACK (Request)'					) AS e ON e.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Max_MsgTime AS MsgTime,Technology FROM #sipControl WHERE Message like 'IMS SIP BYE%'							) AS f ON f.SessionId = a.SessionId
		LEFT OUTER JOIN (SELECT SessionId,SessionIdA,SessionIdB,Max_MsgTime AS MsgTime,Technology FROM #sipControl WHERE Message like 'IMS SIP INVITE (Session in Progress)'	) AS g ON g.SessionId = a.SessionId

		UPDATE #CallInfo
		SET  SipInvite_Timestamp_A			= Setup_MsgTime	
			,SipInvite_Technology_A			= Setup_Technology	
			,SipTrying_Timestamp_A			= CallProceed_MsgTime	
			,SipTrying_Technology_A			= CallProceed_Technology	
			,SipSessProgress_Timestamp_A	= Progress_MsgTime	
			,SipSessProgress_Technology_A	= Progress_Technology	
			,SipRinging_Timestamp_A			= Alerting_MsgTime	
			,SipRinging_Technology_A		= Alerting_Technology	
			,Sip200Ok_Timestamp_A			= Connect_MsgTime	
			,Sip200Ok_Technology_A			= Connect_Technology	
			,SipAck_Timestamp_A				= ConnectAck_MsgTime	
			,SipAck_Technology_A			= ConnectAck_Technology	
			,SipByeCancel_Timestamp_A		= Disconnect_MsgTime	
			,SipByeCancel_Technology_A		= Disconnect_Technology
		FROM ( SELECT * FROM #sipGroup WHERE SessionId = SessionIdA ) a
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = a.SessionIdA

		UPDATE #CallInfo
		SET  SipInvite_Timestamp_B			= Setup_MsgTime	
			,SipInvite_Technology_B			= Setup_Technology	
			,SipTrying_Timestamp_B			= CallProceed_MsgTime	
			,SipTrying_Technology_B			= CallProceed_Technology	
			,SipSessProgress_Timestamp_B	= Progress_MsgTime	
			,SipSessProgress_Technology_B	= Progress_Technology	
			,SipRinging_Timestamp_B			= Alerting_MsgTime	
			,SipRinging_Technology_B		= Alerting_Technology	
			,Sip200Ok_Timestamp_B			= Connect_MsgTime	
			,Sip200Ok_Technology_B			= Connect_Technology	
			,SipAck_Timestamp_B				= ConnectAck_MsgTime	
			,SipAck_Technology_B			= ConnectAck_Technology	
			,SipByeCancel_Timestamp_B		= Disconnect_MsgTime	
			,SipByeCancel_Technology_B		= Disconnect_Technology
		FROM ( SELECT * FROM #sipGroup WHERE SessionId = SessionIdB ) a
		RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = a.SessionIdA

		IF OBJECT_ID ('tempdb..#volteSummary' ) IS NOT NULL DROP TABLE #volteSummary
		SELECT SessionId,SessionIdA,SessionIdB,VoLTE_Setup_Start,VoLTE_Setup_End,VoLTE_Setup_Success,dbo.recREPLACE(VoLTE_Call_Mode) AS VoLTE_Call_Mode
		INTO #volteSummary
		FROM
			(SELECT SessionId,SessionIdA,SessionIdB,
				   MIN(MsgTime) AS VoLTE_Setup_Start,
				   MAX(MsgTime) AS VoLTE_Setup_End,
				   SUM(CASE WHEN  Message like 'IMS SIP INVITE (OK)' OR  Message like 'IMS SIP ACK (Request)' THEN 1 ELSE 0 END) AS VoLTE_Setup_Success,
				   STUFF((
										SELECT '/' + (CASE WHEN [technology] like '%LTE%' THEN 'LTE' WHEN [technology] like '%UMTS%' THEN 'UMTS' WHEN [technology] like '%GSM%' THEN 'GSM' ELSE '' END) 
										FROM #sipControl1 WHERE cc.SessionId = SessionId ORDER BY MsgTime
										FOR XML PATH('')
										), 1, 1, '') AS VoLTE_Call_Mode
			FROM #sipControl1 cc
			WHERE Message not like 'IMS SIP BYE'
			GROUP BY SessionId,SessionIdA,SessionIdB) AS V

		UPDATE #CallInfo
		SET  VoLTE_Setup_Start_Time_A    = VoLTE_Setup_Start
			,VoLTE_Setup_End_Time_A      = VoLTE_Setup_End
			,VoLTE_Setup_Success_A       = VoLTE_Setup_Success
			,VoLTE_Setup_Call_Mode_A     = VoLTE_Call_Mode	
		FROM #volteSummary s
		RIGHT OUTER JOIN #CallInfo ci ON s.SessionId = ci.SessionId_A

		UPDATE #CallInfo
		SET  VoLTE_Setup_Start_Time_B    = VoLTE_Setup_Start
			,VoLTE_Setup_End_Time_B      = VoLTE_Setup_End
			,VoLTE_Setup_Success_B       = VoLTE_Setup_Success
			,VoLTE_Setup_Call_Mode_B     = VoLTE_Call_Mode	
		FROM #volteSummary s
		RIGHT OUTER JOIN #CallInfo ci ON s.SessionId = ci.SessionId_B

		UPDATE #CallInfo
		SET SRVCC_Timestamp_A = b.MsgTime
		FROM #CallInfo a
		LEFT OUTER JOIN #SRVCCa b ON a.SessionId_A = b.SessionId and b.MsgTime between a.Call_Setup_Start_Trigger and a.Call_Setup_End_Trigger

		UPDATE #CallInfo
		SET SRVCC_Timestamp_B = b.MsgTime
		FROM #CallInfo a
		LEFT OUTER JOIN #SRVCCa b ON a.SessionId_B = b.SessionId and b.MsgTime between a.Call_Setup_Start_Trigger and a.Call_Setup_End_Trigger

		UPDATE #CallInfo
		SET SipSetupBye_Timestamp_A = b.MsgTime
		FROM #CallInfo a
		LEFT OUTER JOIN #SipErrors b ON a.SessionId_A = b.SessionId and b.MsgTime between a.Call_Setup_Start_Trigger and a.Call_Setup_End_Trigger

		UPDATE #CallInfo
		SET SipSetupBye_Timestamp_B = b.MsgTime
		FROM #CallInfo a
		LEFT OUTER JOIN #SipErrors b ON a.SessionId_B = b.SessionId and b.MsgTime between a.Call_Setup_Start_Trigger and a.Call_Setup_End_Trigger

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: VoLTE Call Control Messages imported in table ...')

/****** NETWORK INFO BASED CALL MODE ******/
		IF OBJECT_ID ('tempdb..#nwmode' ) IS NOT NULL DROP TABLE #nwmode
		SELECT DISTINCT
				 t1.[SessionId]
				,t2.StartTime
				,t2.EndTime
				,t2.technology
				,CAST(null as datetime2(3)) AS Call_Setup_Start_Trigger
				,CAST(null as datetime2(3)) AS Call_Setup_End_Trigger
				,CAST(null as datetime2(3)) AS Call_End_Trigger
		into #nwmode
		FROM [NetworkIdRelation] t1
		JOIN (SELECT [NetworkId]
					,[MsgTime] AS StartTime
					,DATEADD(ms,[Duration],[MsgTime]) as EndTime
					,[technology]
					,[Operator]
					,[HomeOperator]
				FROM [NetworkInfo]) t2 ON t1.NetworkId = t2.NetworkId

		UPDATE #nwmode
		SET  Call_Setup_Start_Trigger = CASE WHEN nm.Call_Setup_Start_Trigger is null THEN ci.Call_Setup_Start_Trigger ELSE nm.Call_Setup_Start_Trigger END
			,Call_Setup_End_Trigger   = CASE WHEN nm.Call_Setup_End_Trigger   is null THEN ci.Call_Setup_End_Trigger   ELSE nm.Call_Setup_End_Trigger   END
			,Call_End_Trigger		  = CASE WHEN nm.Call_End_Trigger		   is null THEN ci.Call_End_Trigger		   ELSE nm.Call_End_Trigger		    END
		FROM #CallInfo ci 
		right outer join #nwmode nm on ci.SessionId_A = nm.SessionId

		UPDATE #nwmode
		SET  Call_Setup_Start_Trigger = CASE WHEN nm.Call_Setup_Start_Trigger is null THEN ci.Call_Setup_Start_Trigger ELSE nm.Call_Setup_Start_Trigger END
			,Call_Setup_End_Trigger   = CASE WHEN nm.Call_Setup_End_Trigger   is null THEN ci.Call_Setup_End_Trigger   ELSE nm.Call_Setup_End_Trigger   END
			,Call_End_Trigger		  = CASE WHEN nm.Call_End_Trigger		   is null THEN ci.Call_End_Trigger		   ELSE nm.Call_End_Trigger		    END
		FROM #CallInfo ci 
		right outer join #nwmode nm on ci.SessionId_B = nm.SessionId

		DELETE FROM #nwmode WHERE Call_Setup_Start_Trigger is null and Call_Setup_End_Trigger is null and Call_End_Trigger is null
		DELETE FROM #nwmode WHERE EndTime < Call_Setup_Start_Trigger 
		DELETE FROM #nwmode WHERE StartTime > Call_End_Trigger 

-- SEPARATE TO CALL SETUP AND ACTIVE CALL
		IF OBJECT_ID ('tempdb..#nwmode1' ) IS NOT NULL DROP TABLE #nwmode1
		select SessionId,
			   StartTime AS CS_Start_Time,
			   EndTime   AS CS_End_Time,
			   StartTime AS AC_Start_Time,
			   EndTime   AS AC_End_Time,
			   technology,
			   Call_Setup_Start_Trigger,
			   Call_Setup_End_Trigger,
			   Call_End_Trigger
		into #nwmode1
		from #nwmode 
		order by SessionId,StartTime

		update #nwmode1
		set CS_Start_Time = Call_Setup_Start_Trigger
		where CS_Start_Time < Call_Setup_Start_Trigger

		update #nwmode1
		set CS_End_Time = Call_Setup_End_Trigger
		where CS_End_Time > Call_Setup_End_Trigger

		update #nwmode1
		set CS_Start_Time = Call_Setup_End_Trigger
		where CS_Start_Time > Call_Setup_End_Trigger

		update #nwmode1
		set AC_Start_Time = Call_Setup_End_Trigger
		where AC_Start_Time < Call_Setup_End_Trigger

		update #nwmode1
		set AC_End_Time = Call_End_Trigger
		where AC_End_Time > Call_End_Trigger

		update #nwmode1
		set AC_Start_Time = Call_End_Trigger
		where AC_Start_Time > Call_End_Trigger

		update #nwmode1
		set technology = CASE WHEN technology like 'LTE%' THEN 'LTE' WHEN technology like 'UMTS%' THEN 'UMTS' WHEN technology like 'GSM%' THEN 'GSM' ELSE '' END

		IF OBJECT_ID ('tempdb..#nwmode2' ) IS NOT NULL DROP TABLE #nwmode2
		Select SessionId,
			   CS_CM = dbo.recREPLACE(
							STUFF((
									SELECT '/' + [technology]
									FROM #nwmode1 WHERE CS_Start_Time <> CS_End_Time and nw.SessionId = SessionId ORDER BY CS_Start_Time
									FOR XML PATH('')
									), 1, 1, '')
							),
			   AC_CM = dbo.recREPLACE(
							STUFF((
									SELECT '/' + [technology]
									FROM #nwmode1 WHERE AC_Start_Time <> AC_End_Time and nw.SessionId = SessionId ORDER BY AC_Start_Time
									FOR XML PATH('')
									), 1, 1, '')  )
		 into #nwmode2
		 from #nwmode1 nw
		 Group by SessionId
		 Order by SessionId

-- IN ACTIVE CALL HO TO LTE NOT POSSIBLE
		IF OBJECT_ID ('tempdb..#nwmode3' ) IS NOT NULL DROP TABLE #nwmode3
		Select SessionId
			  ,CS_CM
			  ,CASE WHEN AC_CM like '%UMTS/LTE%' THEN substring(AC_CM,0,charindex('UMTS/LTE',AC_CM)+4)
					WHEN AC_CM like '%GSM/LTE%'  THEN substring(AC_CM,0,charindex('GSM/LTE',AC_CM)+3)
					ELSE AC_CM
					END AS AC_CM
		into #nwmode3
		from #nwmode2 order by sessionId

-- UPDATE NW CALL MODE IN CALL INFO TABLE
		UPDATE #CallInfo
		SET  NW_SC_Technology_A	= CS_CM
			,NW_AC_Technology_A	= AC_CM
		 FROM #nwmode3 nm
		 RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_A = nm.SessionId

		UPDATE #CallInfo
		SET  NW_SC_Technology_B	= CS_CM
			,NW_AC_Technology_B	= AC_CM
		 FROM #nwmode3 nm
		 RIGHT OUTER JOIN #CallInfo ci on ci.SessionId_B = nm.SessionId
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NW Call Mode imported in table ...')

-- FINAL CALL MODE CALCULATION SIDE A
		UPDATE #CallInfo
		SET  VoLTE_Setup_Call_Mode_A	= 'VoLTE'
			,CS_Setup_Call_Mode_A		= null
			,NW_AC_Technology_A			= REPLACE(NW_AC_Technology_A,	  'LTE','VoLTE')
		WHERE VoLTE_Setup_Success_A > 0

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_A	    = 'VoLTE(F)/CSFB'
			,CS_Setup_Call_Mode_A		= REPLACE(CS_Setup_Call_Mode_A	,'LTE','')
			,NW_AC_Technology_A			= REPLACE(NW_AC_Technology_A	,'LTE','')
		WHERE VoLTE_Setup_Start_Time_A is not null and VoLTE_Setup_Start_Time_A < CSFB_Timestamp_A

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_A = 'VoLTE(F)'
			,CS_Setup_Call_Mode_A		= REPLACE(CS_Setup_Call_Mode_A	,'LTE','')
			,NW_AC_Technology_A			= REPLACE(NW_AC_Technology_A	,'LTE','')
		WHERE VoLTE_Setup_Call_Mode_A like 'LTE' and CS_Setup_Start_Time_A is not null

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_A = 'VoLTE(F)/CSFB'
			,CS_Setup_Call_Mode_A		= null
			,NW_AC_Technology_A			= REPLACE(NW_AC_Technology_A	,'LTE','VoLTE')
		WHERE VoLTE_Setup_Start_Time_A is not null and VoLTE_Setup_Start_Time_A > CSFB_Timestamp_A

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_A = 'CSFB'
			,CS_Setup_Call_Mode_A		= REPLACE(CS_Setup_Call_Mode_A	,'LTE','')
			,NW_AC_Technology_A			= REPLACE(NW_AC_Technology_A	,'LTE','')
		WHERE VoLTE_Setup_Start_Time_A is null and CSFB_Timestamp_A is not null

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_A = 'LTE/Reselection'
			,CS_Setup_Call_Mode_A		= REPLACE(CS_Setup_Call_Mode_A	,'LTE','')
			,NW_AC_Technology_A			= REPLACE(NW_AC_Technology_A	,'LTE','')
		WHERE startTechnology_A like 'LTE%' and VoLTE_Setup_Start_Time_A is null and CSFB_Timestamp_A is null and CS_Setup_Start_Time_A is not null

		UPDATE #CallInfo
		SET  NW_AC_Technology_A			= REPLACE(NW_AC_Technology_A,	  'VoVoLTE','VoLTE')
		WHERE VoLTE_Setup_Success_A > 0

		UPDATE #CallInfo
		SET Call_Mode_L2_A = ISNULL(VoLTE_Setup_Call_Mode_A,'') + (CASE WHEN VoLTE_Setup_Call_Mode_A is not null then '/' else '' END) 
								+ ISNULL(CS_Setup_Call_Mode_A,'') + (CASE WHEN CS_Setup_Call_Mode_A is not null then '/' else '' END)  + ISNULL(NW_AC_Technology_A,'')
		UPDATE #CallInfo
		SET Call_Mode_L2_A = REPLACE(Call_Mode_L2_A,'//','/')
		WHERE Call_Mode_L2_A like '%//%'

		UPDATE #CallInfo
		SET Call_Mode_L2_A = dbo.recREPLACE(Call_Mode_L2_A)

		UPDATE #CallInfo
		SET Call_Mode_L2_A = 'VoLTE'
		WHERE Call_Mode_L2_A like 'LTE' and Call_Status like 'Completed'

		UPDATE #CallInfo
		SET Call_Mode_L2_A = 'Unknown'
		WHERE Call_Mode_L2_A like ''

		UPDATE #CallInfo
		SET Call_Mode_L2_A = SUBSTRING(Call_Mode_L2_A,0,LEN(Call_Mode_L2_A))
		WHERE Call_Mode_L2_A like '%/'

		UPDATE #CallInfo
		SET Call_Mode_L2_A = REPLACE(Call_Mode_L2_A,'VoLTE(F)','VoLTE')
		WHERE Call_Mode_L2_A like 'VoLTE(F)%' and SRVCC_Timestamp_A is not null and SipSetupBye_Timestamp_A is null

		UPDATE #CallInfo
		SET Call_Mode_L2_B = REPLACE(Call_Mode_L2_B,'VoLTE(F)','VoLTE')
		WHERE Call_Mode_L2_B like 'VoLTE(F)%' and SRVCC_Timestamp_B is not null and SipSetupBye_Timestamp_B is null

		UPDATE #CallInfo
		SET Call_Mode_L1_A = CASE WHEN Call_Mode_L2_A like '%CSFB%' THEN 'CSFB'
								  WHEN Call_Mode_L2_A like 'VoLTE(F)/%' THEN 'Mixed'
								  WHEN Call_Mode_L2_A like 'UMTS%' THEN 'CS'
								  WHEN Call_Mode_L2_A like 'GSM%' THEN 'CS'
								  WHEN Call_Mode_L2_A like 'LTE/reselection%' THEN 'CS'
								  WHEN Call_Mode_L2_A like 'VoLTE%'   THEN 'VoLTE'
								  WHEN Call_Mode_L2_A like 'Unknown%' THEN 'Mixed'
								  ELSE 'Mixed'
								  END
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Call Mode A Side calculated and imported in table ...')

-- FINAL CALL MODE CALCULATION SIDE B
		UPDATE #CallInfo
		SET  VoLTE_Setup_Call_Mode_B	= 'VoLTE'
			,CS_Setup_Call_Mode_B		= null
			,NW_AC_Technology_B			= REPLACE(NW_AC_Technology_B,	  'LTE','VoLTE')
		WHERE VoLTE_Setup_Success_B > 0

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_B	    = 'VoLTE(F)/CSFB'
			,CS_Setup_Call_Mode_B		= REPLACE(CS_Setup_Call_Mode_B	,'LTE','')
			,NW_AC_Technology_B			= REPLACE(NW_AC_Technology_B	,'LTE','')
		WHERE VoLTE_Setup_Start_Time_B is not null and VoLTE_Setup_Start_Time_B < CSFB_Timestamp_B

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_B = 'VoLTE(F)'
			,CS_Setup_Call_Mode_B		= REPLACE(CS_Setup_Call_Mode_B	,'LTE','')
			,NW_AC_Technology_B			= REPLACE(NW_AC_Technology_B	,'LTE','')
		WHERE VoLTE_Setup_Call_Mode_B like 'LTE' and CS_Setup_Start_Time_B is not null

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_B = 'VoLTE(F)/CSFB'
			,CS_Setup_Call_Mode_B		= null
			,NW_AC_Technology_B			= REPLACE(NW_AC_Technology_B	,'LTE','VoLTE')
		WHERE VoLTE_Setup_Start_Time_B is not null and VoLTE_Setup_Start_Time_B > CSFB_Timestamp_B

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_B = 'CSFB'
			,CS_Setup_Call_Mode_B		= REPLACE(CS_Setup_Call_Mode_B	,'LTE','')
			,NW_AC_Technology_B			= REPLACE(NW_AC_Technology_B	,'LTE','')
		WHERE VoLTE_Setup_Start_Time_B is null and CSFB_Timestamp_B is not null

		UPDATE #CallInfo
		SET VoLTE_Setup_Call_Mode_B = 'LTE/Reselection'
			,CS_Setup_Call_Mode_B		= REPLACE(CS_Setup_Call_Mode_B	,'LTE','')
			,NW_AC_Technology_B			= REPLACE(NW_AC_Technology_B	,'LTE','')
		WHERE startTechnology_B like 'LTE%' and VoLTE_Setup_Start_Time_B is null and CSFB_Timestamp_B is null and CS_Setup_Start_Time_B is not null

		UPDATE #CallInfo
		SET  NW_AC_Technology_B			= REPLACE(NW_AC_Technology_B,	  'VoVoLTE','VoLTE')
		WHERE VoLTE_Setup_Success_B > 0

		UPDATE #CallInfo
		SET Call_Mode_L2_B = ISNULL(VoLTE_Setup_Call_Mode_B,'') + (CASE WHEN VoLTE_Setup_Call_Mode_B is not null then '/' else '' END) 
								+ ISNULL(CS_Setup_Call_Mode_B,'') + (CASE WHEN CS_Setup_Call_Mode_B is not null then '/' else '' END)  + ISNULL(NW_AC_Technology_B,'')

		UPDATE #CallInfo
		SET Call_Mode_L2_B = REPLACE(Call_Mode_L2_B,'//','/')
		WHERE Call_Mode_L2_B like '%//%'

		UPDATE #CallInfo
		SET Call_Mode_L2_B = dbo.recREPLACE(Call_Mode_L2_B)

		UPDATE #CallInfo
		SET Call_Mode_L2_B = 'Unknown'
		WHERE Call_Mode_L2_B like ''

		UPDATE #CallInfo
		SET Call_Mode_L2_B = 'VoLTE'
		WHERE Call_Mode_L2_B like 'LTE' and Call_Status like 'Completed'

		UPDATE #CallInfo
		SET Call_Mode_L2_B = SUBSTRING(Call_Mode_L2_B,0,LEN(Call_Mode_L2_B))
		WHERE Call_Mode_L2_B like '%/'

		UPDATE #CallInfo
		SET Call_Mode_L1_B = CASE WHEN Call_Mode_L2_B like '%CSFB%' THEN 'CSFB'
								  WHEN Call_Mode_L2_B like 'VoLTE(F)/%' THEN 'Mixed'
								  WHEN Call_Mode_L2_B like 'UMTS%' THEN 'CS'
								  WHEN Call_Mode_L2_B like 'GSM%' THEN 'CS'
								  WHEN Call_Mode_L2_B like 'LTE/reselection%' THEN 'CS'
								  WHEN Call_Mode_L2_B like 'VoLTE%'   THEN 'VoLTE'
								  WHEN Call_Mode_L2_B like 'Unknown%' THEN 'Mixed'
								  ELSE 'Mixed'
								  END
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: Call Mode B Side calculated and imported in table ...')

-- CREATE FINAL CALL MODE TABLE
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_Call_Mode_2018 beeing created ...')
IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_Call_Mode_2018' AND type = 'U')	DROP TABLE [NEW_Call_Mode_2018]
SELECT SessionId_A AS [PrimKey]
	  ,Call_Status
	  ,Call_Mode_L1_A
	  ,Call_Mode_L2_A
	  ,Call_Mode_L1_B
	  ,Call_Mode_L2_B
	  ,callDir
	  ,Call_Setup_Start_Trigger AS [MO:Dial]
	  ,CAST(null as float)		AS [CallSetupTime(MO:Dial->MO:Alerting)]
	  ,CAST(null as float)		AS [CallSetupTime(MO:Dial->MO:ConnectAck)]
	  ,CAST(null as float)		AS [CallSetupTime(MT:Alerting->MT:Connect)]
	  -- Events for CDR
	  ,CASE WHEN callDir like 'A->%' and CSFB_Flag_A like 'MO' THEN CSFB_Timestamp_A
			WHEN callDir like 'B->%' and CSFB_Flag_B like 'MO' THEN CSFB_Timestamp_B
			END AS [MO:CSFB-ExtendedServiceRequest]
	  ,CASE WHEN callDir like 'A->%' THEN CMService_Timestamp_1st_A
			WHEN callDir like 'B->%' THEN CMService_Timestamp_1st_B
			END AS [MO:CmServiceRequest]
	  ,CASE WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'					THEN  CCSetup_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'						THEN  CCSetup_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'					THEN  SipInvite_Timestamp_A
					 WHEN SipInvite_Timestamp_A is null					THEN  CCSetup_Timestamp_A
					 WHEN CCSetup_Timestamp_A is null					THEN  CCSetup_Timestamp_A
					 WHEN CCSetup_Timestamp_A < SipInvite_Timestamp_A	THEN  CCSetup_Timestamp_A
					 ELSE SipInvite_Timestamp_A
					 END
			WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'					THEN  CCSetup_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'						THEN  CCSetup_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'					THEN  SipInvite_Timestamp_B
					 WHEN SipInvite_Timestamp_B is null					THEN  CCSetup_Timestamp_B
					 WHEN CCSetup_Timestamp_B is null					THEN  CCSetup_Timestamp_B
					 WHEN CCSetup_Timestamp_B < SipInvite_Timestamp_B	THEN  CCSetup_Timestamp_B
					 ELSE SipInvite_Timestamp_B
					 END
			END AS [MO:SipInvite/CC:Setup]
	  ,CASE WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'							THEN  CCCallProceeding_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'								THEN  CCCallProceeding_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'							THEN  SipTrying_Timestamp_A
					 WHEN SipTrying_Timestamp_A is null							THEN  CCCallProceeding_Timestamp_A
					 WHEN CCCallProceeding_Timestamp_A is null					THEN  CCCallProceeding_Timestamp_A
					 WHEN CCCallProceeding_Timestamp_A < SipTrying_Timestamp_A	THEN  CCCallProceeding_Timestamp_A
					 ELSE SipTrying_Timestamp_A
					 END
			WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'							THEN  CCCallProceeding_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'								THEN  CCCallProceeding_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'							THEN  SipTrying_Timestamp_B
					 WHEN SipTrying_Timestamp_B is null							THEN  CCCallProceeding_Timestamp_B
					 WHEN CCCallProceeding_Timestamp_B is null					THEN  CCCallProceeding_Timestamp_B
					 WHEN CCCallProceeding_Timestamp_B < SipTrying_Timestamp_B	THEN  CCCallProceeding_Timestamp_B
					 ELSE SipTrying_Timestamp_B
					 END
			END AS [MO:SipTrying/CC:CallProceeding]
	  ,CASE WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'						THEN  CCAlerting_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'							THEN  CCAlerting_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'						THEN  SipRinging_Timestamp_A
					 WHEN SipRinging_Timestamp_A is null					THEN  CCAlerting_Timestamp_A
					 WHEN CCAlerting_Timestamp_A is null					THEN  CCAlerting_Timestamp_A
					 WHEN CCAlerting_Timestamp_A < SipRinging_Timestamp_A	THEN  CCAlerting_Timestamp_A
					 ELSE SipRinging_Timestamp_A
					 END
			WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'						THEN  CCAlerting_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'							THEN  CCAlerting_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'						THEN  SipRinging_Timestamp_B
					 WHEN SipRinging_Timestamp_B is null					THEN  CCAlerting_Timestamp_B
					 WHEN CCAlerting_Timestamp_B is null					THEN  CCAlerting_Timestamp_B
					 WHEN CCAlerting_Timestamp_B < SipRinging_Timestamp_B	THEN  CCAlerting_Timestamp_B
					 ELSE SipRinging_Timestamp_B
					 END
			END AS [MO:SipRinging/CC:Alerting]
	  ,CASE WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'						THEN  CCConnect_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'							THEN  CCConnect_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'						THEN  Sip200Ok_Timestamp_A
					 WHEN Sip200Ok_Timestamp_A is null						THEN  CCConnect_Timestamp_A
					 WHEN CCConnect_Timestamp_A is null						THEN  CCConnect_Timestamp_A
					 WHEN CCConnect_Timestamp_A < Sip200Ok_Timestamp_A		THEN  CCConnect_Timestamp_A
					 ELSE Sip200Ok_Timestamp_A
					 END
			WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'						THEN  CCConnect_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'							THEN  CCConnect_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'						THEN  Sip200Ok_Timestamp_B
					 WHEN Sip200Ok_Timestamp_B is null						THEN  CCConnect_Timestamp_B
					 WHEN CCConnect_Timestamp_B is null						THEN  CCConnect_Timestamp_B
					 WHEN CCConnect_Timestamp_B < Sip200Ok_Timestamp_B		THEN  CCConnect_Timestamp_B
					 ELSE Sip200Ok_Timestamp_B
					 END
			END AS [MO:Sip200Ok/CC:Connect]
	  ,CASE WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'						THEN  CCConnectAck_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'							THEN  CCConnectAck_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'						THEN  SipAck_Timestamp_A
					 WHEN SipAck_Timestamp_A is null						THEN  CCConnectAck_Timestamp_A
					 WHEN CCConnectAck_Timestamp_A is null					THEN  CCConnectAck_Timestamp_A
					 WHEN CCConnectAck_Timestamp_A < SipAck_Timestamp_A		THEN  CCConnectAck_Timestamp_A
					 ELSE SipAck_Timestamp_A
					 END
			WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'						THEN  CCConnectAck_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'							THEN  CCConnectAck_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'						THEN  SipAck_Timestamp_B
					 WHEN SipAck_Timestamp_B is null						THEN  CCConnectAck_Timestamp_B
					 WHEN CCConnectAck_Timestamp_B is null					THEN  CCConnectAck_Timestamp_B
					 WHEN CCConnectAck_Timestamp_B < SipAck_Timestamp_B		THEN  CCConnectAck_Timestamp_B
					 ELSE SipAck_Timestamp_B
					 END
			END AS [MO:SipAck/CC:ConnectAck]
	  ,CASE WHEN callDir like 'B->%' and CSFB_Flag_A like 'MT' THEN CSFB_Timestamp_A
			WHEN callDir like 'A->%' and CSFB_Flag_B like 'MT' THEN CSFB_Timestamp_B
			END AS [MT:CSFB-ExtendedServiceRequest]
	  ,CASE WHEN callDir like 'A->%' THEN Paging_Timestamp_B
			WHEN callDir like 'B->%' THEN Paging_Timestamp_A
			END AS [MT:Paging]
	  ,CASE WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'					THEN  CCSetup_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'						THEN  CCSetup_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'					THEN  SipInvite_Timestamp_A
					 WHEN SipInvite_Timestamp_A is null					THEN  CCSetup_Timestamp_A
					 WHEN CCSetup_Timestamp_A is null					THEN  CCSetup_Timestamp_A
					 WHEN CCSetup_Timestamp_A < SipInvite_Timestamp_A	THEN  CCSetup_Timestamp_A
					 ELSE SipInvite_Timestamp_A
					 END
			WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'					THEN  CCSetup_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'						THEN  CCSetup_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'					THEN  SipInvite_Timestamp_B
					 WHEN SipInvite_Timestamp_B is null					THEN  CCSetup_Timestamp_B
					 WHEN CCSetup_Timestamp_B is null					THEN  CCSetup_Timestamp_B
					 WHEN CCSetup_Timestamp_B < SipInvite_Timestamp_B	THEN  CCSetup_Timestamp_B
					 ELSE SipInvite_Timestamp_B
					 END
			END AS [MT:SipInvite/CC:Setup]
	  ,CASE WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'							THEN  CCCallProceeding_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'								THEN  CCCallProceeding_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'							THEN  SipTrying_Timestamp_A
					 WHEN SipTrying_Timestamp_A is null							THEN  CCCallProceeding_Timestamp_A
					 WHEN CCCallProceeding_Timestamp_A is null					THEN  CCCallProceeding_Timestamp_A
					 WHEN CCCallProceeding_Timestamp_A < SipTrying_Timestamp_A	THEN  CCCallProceeding_Timestamp_A
					 ELSE SipTrying_Timestamp_A
					 END
			WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'							THEN  CCCallProceeding_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'								THEN  CCCallProceeding_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'							THEN  SipTrying_Timestamp_B
					 WHEN SipTrying_Timestamp_B is null							THEN  CCCallProceeding_Timestamp_B
					 WHEN CCCallProceeding_Timestamp_B is null					THEN  CCCallProceeding_Timestamp_B
					 WHEN CCCallProceeding_Timestamp_B < SipTrying_Timestamp_B	THEN  CCCallProceeding_Timestamp_B
					 ELSE SipTrying_Timestamp_B
					 END
			END AS [MT:SipTrying/CC:CallProceeding]
	  ,CASE WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'						THEN  CCAlerting_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'							THEN  CCAlerting_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'						THEN  SipRinging_Timestamp_A
					 WHEN SipRinging_Timestamp_A is null					THEN  CCAlerting_Timestamp_A
					 WHEN CCAlerting_Timestamp_A is null					THEN  CCAlerting_Timestamp_A
					 WHEN CCAlerting_Timestamp_A < SipRinging_Timestamp_A	THEN  CCAlerting_Timestamp_A
					 ELSE SipRinging_Timestamp_A
					 END
			WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'						THEN  CCAlerting_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'							THEN  CCAlerting_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'						THEN  SipRinging_Timestamp_B
					 WHEN SipRinging_Timestamp_B is null					THEN  CCAlerting_Timestamp_B
					 WHEN CCAlerting_Timestamp_B is null					THEN  CCAlerting_Timestamp_B
					 WHEN CCAlerting_Timestamp_B < SipRinging_Timestamp_B	THEN  CCAlerting_Timestamp_B
					 ELSE SipRinging_Timestamp_B
					 END
			END AS [MT:SipRinging/CC:Alerting]
	  ,CASE WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'						THEN  CCConnect_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'							THEN  CCConnect_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'						THEN  Sip200Ok_Timestamp_A
					 WHEN Sip200Ok_Timestamp_A is null						THEN  CCConnect_Timestamp_A
					 WHEN CCConnect_Timestamp_A is null						THEN  CCConnect_Timestamp_A
					 WHEN CCConnect_Timestamp_A < Sip200Ok_Timestamp_A		THEN  CCConnect_Timestamp_A
					 ELSE Sip200Ok_Timestamp_A
					 END
			WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'						THEN  CCConnect_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'							THEN  CCConnect_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'						THEN  Sip200Ok_Timestamp_B
					 WHEN Sip200Ok_Timestamp_B is null						THEN  CCConnect_Timestamp_B
					 WHEN CCConnect_Timestamp_B is null						THEN  CCConnect_Timestamp_B
					 WHEN CCConnect_Timestamp_B < Sip200Ok_Timestamp_B		THEN  CCConnect_Timestamp_B
					 ELSE Sip200Ok_Timestamp_B
					 END
			END AS [MT:Sip200Ok/CC:Connect]
	  ,CASE WHEN callDir like 'B->%' THEN
				CASE WHEN Call_Mode_L1_A like '%CSFB%'						THEN  CCConnectAck_Timestamp_A
					 WHEN Call_Mode_L1_A like 'CS'							THEN  CCConnectAck_Timestamp_A
				     WHEN Call_Mode_L1_A like 'VoLTE'						THEN  SipAck_Timestamp_A
					 WHEN SipAck_Timestamp_A is null						THEN  CCConnectAck_Timestamp_A
					 WHEN CCConnectAck_Timestamp_A is null					THEN  CCConnectAck_Timestamp_A
					 WHEN CCConnectAck_Timestamp_A < SipAck_Timestamp_A		THEN  CCConnectAck_Timestamp_A
					 ELSE SipAck_Timestamp_A
					 END
			WHEN callDir like 'A->%' THEN
				CASE WHEN Call_Mode_L1_B like '%CSFB%'						THEN  CCConnectAck_Timestamp_B
					 WHEN Call_Mode_L1_B like 'CS'							THEN  CCConnectAck_Timestamp_B
				     WHEN Call_Mode_L1_B like 'VoLTE'						THEN  SipAck_Timestamp_B
					 WHEN SipAck_Timestamp_B is null						THEN  CCConnectAck_Timestamp_B
					 WHEN CCConnectAck_Timestamp_B is null					THEN  CCConnectAck_Timestamp_B
					 WHEN CCConnectAck_Timestamp_B < SipAck_Timestamp_B		THEN  CCConnectAck_Timestamp_B
					 ELSE SipAck_Timestamp_B
					 END
			END AS [MT:SipAck/CC:ConnectAck]
	  ,Call_Setup_End_Trigger
	  ,Call_End_Trigger
	  -- A-Side
	  ,SessionId_A
	  ,callStatus_A
	  ,SQ_CST_A
	  ,callStartTimeStamp_A
	  ,callSetupEndTimestamp_A
	  ,callDisconnectTimeStamp_A
	  ,callEndTimeStamp_A
	  ,startTechnology_A
	  ,CSFB_Timestamp_A
	  ,CSFB_Flag_A
	  ,Paging_Timestamp_A
	  ,Paging_Technology_A
	  ,CMService_Timestamp_1st_A
	  ,CCSetup_Timestamp_A
	  ,CCCallProceeding_Timestamp_A
	  ,CCAlerting_Timestamp_A
	  ,CCConnect_Timestamp_A
	  ,CCConnectAck_Timestamp_A
	  ,CCDisconnect_Timestamp_A
	  ,SipInvite_Timestamp_A
	  ,SipTrying_Timestamp_A
	  ,SipSessProgress_Timestamp_A
	  ,SipRinging_Timestamp_A
	  ,Sip200Ok_Timestamp_A
	  ,SipAck_Timestamp_A
	  ,SipByeCancel_Timestamp_A
	  ,cast(null as varchar(200)) as SipByeCancel_Reason_A

	  -- B-Side
	  ,SessionId_B
	  ,callStatus_B
	  ,SQ_CST_B
	  ,callStartTimeStamp_B
	  ,callSetupEndTimestamp_B
	  ,callDisconnectTimeStamp_B
	  ,callEndTimeStamp_B
	  ,startTechnology_B
	  ,CSFB_Timestamp_B
	  ,CSFB_Flag_B
	  ,Paging_Timestamp_B
	  ,Paging_Technology_B
	  ,CMService_Timestamp_1st_B
	  ,CCSetup_Timestamp_B
	  ,CCCallProceeding_Timestamp_B
	  ,CCAlerting_Timestamp_B
	  ,CCConnect_Timestamp_B
	  ,CCConnectAck_Timestamp_B
	  ,CCDisconnect_Timestamp_B
	  ,SipInvite_Timestamp_B
	  ,SipTrying_Timestamp_B
	  ,SipSessProgress_Timestamp_B
	  ,SipRinging_Timestamp_B
	  ,Sip200Ok_Timestamp_B
	  ,SipAck_Timestamp_B
	  ,SipByeCancel_Timestamp_B
	  ,cast(null as varchar(200)) as SipByeCancel_Reason_B
INTO NEW_Call_Mode_2018
FROM #CallInfo
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_Call_Mode_2018 created successfully...')

-- UPDATE CALL SETUP TIME OUT OF ALLOWED SCOPE
	UPDATE NEW_Call_Mode_2018
	SET  [CallSetupTime(MO:Dial->MO:Alerting)]	  = CASE WHEN DATEDIFF(ms,[MO:Dial],[MO:SipRinging/CC:Alerting]) < 30000 and DATEDIFF(ms,[MO:Dial],[MO:SipRinging/CC:Alerting]) > 500 THEN 0.001*DATEDIFF(ms,[MO:Dial],[MO:SipRinging/CC:Alerting])
														 ELSE null
														 END
		,[CallSetupTime(MO:Dial->MO:ConnectAck)]  = CASE WHEN DATEDIFF(ms,[MO:Dial],[MO:SipAck/CC:ConnectAck]) < 30000 and DATEDIFF(ms,[MO:Dial],[MO:SipAck/CC:ConnectAck]) > 1000 THEN 0.001*DATEDIFF(ms,[MO:Dial],[MO:SipAck/CC:ConnectAck])
														 WHEN callDir like 'A->%' and SQ_CST_A < 30 and SQ_CST_A > 1 THEN SQ_CST_A
														 WHEN callDir like 'B->%' and SQ_CST_B < 30 and SQ_CST_B > 1 THEN SQ_CST_B
														 END
		,[CallSetupTime(MT:Alerting->MT:Connect)] = CASE WHEN DATEDIFF(ms,[MT:SipRinging/CC:Alerting],[MT:Sip200Ok/CC:Connect]) < 5000 and DATEDIFF(ms,[MT:SipRinging/CC:Alerting],[MT:Sip200Ok/CC:Connect]) > 300 THEN 0.001*DATEDIFF(ms,[MT:SipRinging/CC:Alerting],[MT:Sip200Ok/CC:Connect])
														 ELSE null
														 END

/****** INVITE MARKER - INDICATES VOICE CALL ESTABLISHMENT PROCEDURE START ******/
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Extracting SIP Reason header...')
IF OBJECT_ID ('tempdb..#reasonHeader' ) IS NOT NULL DROP TABLE #reasonHeader
		SELECT [SessionId]
			  ,[SessionIdA]
			  ,[SessionIdB]
			  ,[Side]
			  ,[SessionType]
			  ,[CallType]
			  ,[CallDir]
			  ,[TestId]
			  ,[Technology]
			  ,[NetworkId]
			  ,[MsgTime]
			  ,[Direction]
			  ,[Message]
			  ,[MessageRaw]
			  ,dbo.ReasonString([MessageRaw]) As ReasonHeader
			  ,[Cause]
			  ,[CauseLocation]
			  ,[CauseClass]
			  ,[CauseValue]
			  ,[Details]
			  ,[HomeOperator]
			  ,[HomeMCC]
			  ,[HomeMNC]
			  ,[ServingOperator]
			  ,[ServingMCC]
			  ,[ServingMNC]
			  ,[-]
		  INTO #reasonHeader
		  FROM [AN_Layer3]
		  WHERE Message like '%SIP%' and (Message like '%BYE%' or Message like '%CANCEL%')
					  and (MessageRaw like '%cause%' or MessageRaw like '%reason%')

-- CS Retry patch after VoLTE failed to have consistent call mode
UPDATE NEW_Call_Mode_2018
	SET  Call_Mode_L2_A = REPLACE(Call_Mode_L2_A,'VoLTE/CSFB','VoLTE(F)/CSFB')
	WHERE [Call_Mode_L2_A] like 'VoLTE/CSFB%'

UPDATE NEW_Call_Mode_2018
	SET  Call_Mode_L2_B = REPLACE(Call_Mode_L2_B,'VoLTE/CSFB','VoLTE(F)/CSFB')
	WHERE [Call_Mode_L2_B] like 'VoLTE/CSFB%'

-- Sip ReASON hEADER IN cdr
UPDATE NEW_Call_Mode_2018
	SET  SipByeCancel_Reason_A = b.ReasonHeader
	FROM NEW_Call_Mode_2018 a
	LEFT OUTER JOIN #reasonHeader b ON a.SessionId_A = b.SessionId

UPDATE NEW_Call_Mode_2018
	SET  SipByeCancel_Reason_B = b.ReasonHeader
	FROM NEW_Call_Mode_2018 a
	LEFT OUTER JOIN #reasonHeader b ON a.SessionId_B = b.SessionId


-- WHATSAPP ADDITION
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  WHATSAPP CALL MOSE EVALUATION...')
	IF OBJECT_ID ('tempdb..#WhatsAppCall' ) IS NOT NULL DROP TABLE #WhatsAppCall
	select SessionId,
		   callStatus,
		   startTime,
		   dateadd(ms,duration,startTime) as endTime
	into #WhatsAppCall
	from
		(
		select a.SessionId,startTime,duration,b.callStatus from sessions  a left outer join CallSession b on a.SessionId  = b.SessionId where b.JobName like 'WhatsApp%'
		union all
		select a.SessionId,startTime,duration,b.callStatus from sessionsB a left outer join CallSession b on a.SessionIdA = b.SessionId where b.JobName like 'WhatsApp%'
		) a
	order by SessionId

	UPDATE NEW_Call_Mode_2018
	SET Call_Mode_L1_A = 'VoIP',
		Call_Mode_L2_A = REPLACE(Call_Mode_L2_A,'VoLTE','LTE')
	WHERE SessionId_A in (SELECT SessionId FROM #WhatsAppCall)

	UPDATE NEW_Call_Mode_2018
	SET Call_Mode_L1_B = 'VoIP',
		Call_Mode_L2_B = REPLACE(Call_Mode_L2_B,'VoLTE','LTE')
	WHERE SessionId_B in (SELECT SessionId FROM #WhatsAppCall)

	UPDATE NEW_Call_Mode_2018
	SET Call_Mode_L2_A = REPLACE(Call_Mode_L2_A,'CSFB','LTE')
	WHERE SessionId_A in (SELECT SessionId FROM #WhatsAppCall)

	UPDATE NEW_Call_Mode_2018
	SET Call_Mode_L2_B = REPLACE(Call_Mode_L2_B,'CSFB','LTE')
	WHERE SessionId_B in (SELECT SessionId FROM #WhatsAppCall)

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script completed successfully...')

-- Select * from NEW_Call_Mode_2018 Where Call_Mode_L1_A like 'CSFB%' or Call_Mode_L1_B like 'CSFB%'