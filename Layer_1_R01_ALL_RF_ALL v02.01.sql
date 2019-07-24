/*******************************************************************************/
/****** Creates NEW_Test_Info_2018                                        ******/
/****** Author: Tomislav Miksa                                            ******/
/****** v1.00: initial table from where all others are built              ******/
/****** v1.00: replaces nc_pegel_Tables in RAN Script                     ******/
/****** v2.00: per session and per test                                   ******/
/*******************************************************************************/

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execution...')

------------------------------------------------------------------------------------------------------------------
-- SESSION GSM RF                                                                                               --
------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - GSM Calculation STARTING...')
		IF OBJECT_ID ('tempdb..#S_GSMRadioRF' ) IS NOT NULL DROP TABLE #S_GSMRadioRF
		select  
			SessionId,
			convert(smallint,round(_Master_DB.dbo.Lin_dBm(Avg(_Master_DB.dbo.dBm_Lin(gsm.RxLev))),1))	as 'AvgRxLev',
			convert(smallint,round(Avg(gsm.RxQual),1))													as 'AvgRxQual',
			convert(smallint,round(min(gsm.RxLev),1))													as 'MinRxLev',
			convert(smallint,round(max(gsm.RxLev),1))													as 'MaxRxLev',
			convert(float,round(stdev(gsm.RxLev),1))													as 'StDevRxLev',
			convert(smallint,round(min(gsm.RxQual),1))													as 'MinRxQual',
			convert(smallint,round(max(gsm.RxQual),1))													as 'MaxRxQual',	
			convert(float,round(Stdev(gsm.RxQual),1))													as 'StDevRxQual'
		into #S_GSMRadioRF
		FROM   
			(
				select 
					SessionId,
					case when (RxLev between -110 and -47)	then RxLev  else null end as RxLev,
					case when (RxQual between 0 and 7)		then RxQual else null end as RxQual  
				from MsgGSMReport
			) AS gsm

		GROUP BY SessionId

------------------------------------------------------------------------------------------------------------------
-- TEST GSM RF                                                                                                  --
------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#GSMRadioRF' ) IS NOT NULL DROP TABLE #GSMRadioRF
		select  
			SessionId,TestId,
			convert(smallint,round(_Master_DB.dbo.Lin_dBm(Avg(_Master_DB.dbo.dBm_Lin(gsm.RxLev))),1))	as 'AvgRxLev',
			convert(smallint,round(Avg(gsm.RxQual),1))													as 'AvgRxQual',
			convert(smallint,round(min(gsm.RxLev),1))													as 'MinRxLev',
			convert(smallint,round(max(gsm.RxLev),1))													as 'MaxRxLev',
			convert(float,round(stdev(gsm.RxLev),1))													as 'StDevRxLev',
			convert(smallint,round(min(gsm.RxQual),1))													as 'MinRxQual',
			convert(smallint,round(max(gsm.RxQual),1))													as 'MaxRxQual',	
			convert(float,round(Stdev(gsm.RxQual),1))													as 'StDevRxQual'
		into #GSMRadioRF
		FROM   
			(
				select 
					SessionId,TestId,
					case when (RxLev between -110 and -47)	then RxLev  else null end as RxLev,
					case when (RxQual between 0 and 7)		then RxQual else null end as RxQual  
				from MsgGSMReport
				where TestId <> 0
			) AS gsm
		GROUP BY SessionId,TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - GSM Calculation COMPLETED!...')

------------------------------------------------------------------------------------------------------------------
-- SESSION UMTS RF                                                                                              --
------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UMTS Calculation STARTING...')
		IF OBJECT_ID ('tempdb..#S_UMTSRadioRF' ) IS NOT NULL DROP TABLE #S_UMTSRadioRF
		select  
			SessionId,
			convert(real,round(min(umts.AggrRSCP),1))													as 'MinRSCP',
			convert(real,round(_Master_DB.dbo.Lin_dBm(avg(_Master_DB.dbo.dBm_Lin(umts.AggrRSCP))),1))	as 'AvgRSCP',
			convert(real,round(max(umts.AggrRSCP),1))													as 'MaxRSCP',
			convert(float,round(stdev(umts.AggrRSCP),1))												as 'StDevRSCP',
			convert(real,round(min(umts.AggrEcIo),1))													as 'MinEcIo',
			convert(real,round(_Master_DB.dbo.Lin_dB(avg(_Master_DB.dbo.dB_Lin(umts.AggrEcIo))),1))		as 'AvgEcIo',
			convert(real,round(max(umts.AggrEcIo),1))													as 'MaxEcIo',
			convert(float,round(stdev(umts.AggrEcIo),1))												as 'StDevEcIo'
		into #S_UMTSRadioRF
		FROM 
			(
				select 
					SessionId,
					case when (AggrRSCP between -140 and -40) then AggrRSCP else null end as AggrRSCP,
					case when (AggrEcIo between -32 and 0) then AggrEcIo else null end as AggrEcIo 
					-- select * 
				from WCDMAActiveSet) AS umts 
		GROUP BY SessionId

------------------------------------------------------------------------------------------------------------------
-- TEST UMTS RF                                                                                                 --
------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#UMTSRadioRF' ) IS NOT NULL DROP TABLE #UMTSRadioRF
		select  
			SessionId,TestId,
			convert(real,round(_Master_DB.dbo.Lin_dBm(avg(_Master_DB.dbo.dBm_Lin(umts.AggrRSCP))),1))	as 'AvgRSCP',
			convert(real,round(_Master_DB.dbo.Lin_dB(avg(_Master_DB.dbo.dB_Lin(umts.AggrEcIo))),1))		as 'AvgEcIo',
			convert(real,round(min(umts.AggrRSCP),1))													as 'MinRSCP',
			convert(real,round(max(umts.AggrRSCP),1))													as 'MaxRSCP',
			convert(float,round(stdev(umts.AggrRSCP),1))												as 'StDevRSCP',
			convert(real,round(min(umts.AggrEcIo),1))													as 'MinEcIo',
			convert(real,round(max(umts.AggrEcIo),1))													as 'MaxEcIo',
			convert(float,round(stdev(umts.AggrEcIo),1))												as 'StDevEcIo'
		into #UMTSRadioRF
		FROM 
			(
				select 
					SessionId,TestId,
					case when (AggrRSCP between -140 and -40) then AggrRSCP else null end as AggrRSCP,
					case when (AggrEcIo between -32 and 0) then AggrEcIo else null end as AggrEcIo 
					-- select * 
				from WCDMAActiveSet 
				where TestId <> 0 ) AS umts 
		GROUP BY SessionId,TestId

------------------------------------------------------------------------------------------------------------------
-- SESSION UMTS Tx Pwr                                                                                          --
------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#S_RadioTx_3G' ) IS NOT NULL DROP TABLE #S_RadioTx_3G
		Select   SessionId
				,MIN(TxPwr)						AS MinTxPwr3G
				,AVG(TxPwr)						AS AvgTxPwr3G
				,MAX(TxPwr)						AS MaxTxPwr3G
				,StDev(TxPwr)					AS StDevTxPwr3G
		INTO #S_RadioTx_3G
		FROM (SELECT
						a.[MsgTime]
					   ,a.[SessionId]
					   ,a.[TestId]
					   ,a.[NetworkId]
					   ,b.[Operator]
					   ,b.[HomeOperator]
					   ,b.[technology]
					   ,a.[TxPwr]
					FROM [WCDMAAGC]			AS a
					LEFT JOIN [NetworkInfo] AS b	ON a.[NetworkId] = b.[NetworkId]
					WHERE a.TxPwr <=24 ) AS urtx
		GROUP BY SessionId

------------------------------------------------------------------------------------------------------------------
-- TEST UMTS Tx Pwr                                                                                             --
------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#RadioTx_3G' ) IS NOT NULL DROP TABLE #RadioTx_3G
		Select   SessionId,TestId
				,MIN(TxPwr)						AS MinTxPwr3G
				,AVG(TxPwr)						AS AvgTxPwr3G
				,MAX(TxPwr)						AS MaxTxPwr3G
				,StDev(TxPwr)					AS StDevTxPwr3G
		
		INTO #RadioTx_3G
		FROM (		SELECT
								a.[MsgTime]
							   ,a.[SessionId]
							   ,a.[TestId]
							   ,a.[NetworkId]
							   ,b.[Operator]
							   ,b.[HomeOperator]
							   ,b.[technology]
							   ,a.[TxPwr]
						FROM [WCDMAAGC]			AS a
						LEFT JOIN [NetworkInfo] AS b	ON a.[NetworkId] = b.[NetworkId]
						WHERE a.TxPwr <=24 ) AS urtx
		WHERE TestId <> 0
		GROUP BY SessionId,TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UMTS Calculation COMPLETED...')

------------------------------------------------------------------------------------------------------------------
-- SESSION LTE RF                                                                                               --
------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - LTE Calculation STARTING...')
		IF OBJECT_ID ('tempdb..#S_LTERadioRF' ) IS NOT NULL DROP TABLE #S_LTERadioRF
		select  
			SessionId,
			convert(real,round(_Master_DB.dbo.Lin_dB(avg(_Master_DB.dbo.dB_Lin(lte.RSSI))),1))		as 'AvgRSSI',
			convert(real,round(min(lte.RSRP),1))													as 'MinRSRP',
			convert(real,round(_Master_DB.dbo.Lin_dBm(avg(_Master_DB.dbo.dBm_Lin(lte.RSRP))),1))	as 'AvgRSRP',
			convert(real,round(max(lte.RSRP),1))													as 'MaxRSRP',
			convert(float,round(stdev(lte.RSRP),1))													as 'StDevRSRP',
			convert(real,round(min(lte.RSRQ),1))													as 'MinRSRQ',
			convert(real,round(_Master_DB.dbo.Lin_dB(avg(_Master_DB.dbo.dB_Lin(lte.RSRQ))),1))		as 'AvgRSRQ',
			convert(real,round(max(lte.RSRQ),1))													as 'MaxRSRQ',
			convert(float,round(stdev(lte.RSRQ),1))													as 'StDevRSRQ',
			convert(real,min(lte.SINR0))															as 'MinSINR0',
			convert(real,round(_Master_DB.dbo.Lin_DB(avg(_Master_DB.dbo.dB_Lin(lte.SINR0))),3))		as 'AvgSINR0',
			convert(real,max(lte.SINR0))															as 'MaxSINR0',
			convert(real,round(stdev(lte.SINR0),1))													as 'StDevSINR0',
			convert(real,min(lte.SINR1))															as 'MinSINR1',
			convert(real,round(_Master_DB.dbo.Lin_DB(avg(_Master_DB.dbo.dB_Lin(lte.SINR1))),3))		as 'AvgSINR1',
			convert(real,max(lte.SINR1))															as 'MaxSINR1',
			convert(real,round(stdev(lte.SINR1),1))													as 'StDevSINR1' 
		into #S_LTERadioRF
		FROM 
			(
				select 
					SessionId,TestId,
					case when (RSRP between -140 and -40)	then RSRP else null end as RSRP,
					case when (RSSI between -110 and -10)	then RSSI else null end as RSSI, 
					case when (RSRQ between -30 and 0)		then RSRQ else null end as RSRQ,			
					case when (SINR0 between -20 and 30)	then SINR0 else null end as SINR0,
					case when (SINR1 between -20 and 30)	then SINR1 else null end as SINR1  
				from LTEMeasurementReport
			 )  AS lte
		GROUP BY SessionId

------------------------------------------------------------------------------------------------------------------
-- TEST LTE RF                                                                                                  --
------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#LTERadioRF' ) IS NOT NULL DROP TABLE #LTERadioRF
		select  
			SessionId,TestId,
			convert(real,round(_Master_DB.dbo.Lin_dB(avg(_Master_DB.dbo.dB_Lin(lte.RSSI))),1))		as 'AvgRSSI',
			convert(real,round(min(lte.RSRP),1))													as 'MinRSRP',
			convert(real,round(_Master_DB.dbo.Lin_dBm(avg(_Master_DB.dbo.dBm_Lin(lte.RSRP))),1))	as 'AvgRSRP',
			convert(real,round(max(lte.RSRP),1))													as 'MaxRSRP',
			convert(float,round(stdev(lte.RSRP),1))													as 'StDevRSRP',
			convert(real,round(min(lte.RSRQ),1))													as 'MinRSRQ',
			convert(real,round(_Master_DB.dbo.Lin_dB(avg(_Master_DB.dbo.dB_Lin(lte.RSRQ))),1))		as 'AvgRSRQ',
			convert(real,round(max(lte.RSRQ),1))													as 'MaxRSRQ',
			convert(float,round(stdev(lte.RSRQ),1))													as 'StDevRSRQ',
			convert(real,min(lte.SINR0))															as 'MinSINR0',
			convert(real,round(_Master_DB.dbo.Lin_DB(avg(_Master_DB.dbo.dB_Lin(lte.SINR0))),3))		as 'AvgSINR0',
			convert(real,max(lte.SINR0))															as 'MaxSINR0',
			convert(real,round(stdev(lte.SINR0),1))													as 'StDevSINR0',
			convert(real,min(lte.SINR1))															as 'MinSINR1',
			convert(real,round(_Master_DB.dbo.Lin_DB(avg(_Master_DB.dbo.dB_Lin(lte.SINR1))),3))		as 'AvgSINR1',
			convert(real,max(lte.SINR1))															as 'MaxSINR1',
			convert(real,round(stdev(lte.SINR1),1))													as 'StDevSINR1' 
		into #LTERadioRF
		FROM 
			(
				select 
					SessionId,TestId,
					case when (RSRP between -140 and -40)	then RSRP else null end as RSRP,
					case when (RSSI between -110 and -10)	then RSSI else null end as RSSI, 
					case when (RSRQ between -30 and 0)		then RSRQ else null end as RSRQ,			
					case when (SINR0 between -20 and 30)	then SINR0 else null end as SINR0,
					case when (SINR1 between -20 and 30)	then SINR1 else null end as SINR1  
					-- select * 
				from LTEMeasurementReport
				WHERE TestId <> 0
			 )  AS lte
		GROUP BY SessionId,TestId

------------------------------------------------------------------------------------------------------------------
-- SESSION LTE Tx Pwr                                                                                           --
------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#S_RadioTx_4G' ) IS NOT NULL	DROP TABLE #S_RadioTx_4G
		SELECT   SessionId
				,MIN(TxPower)						AS MinTxPwr4G
				,AVG(TxPower)						AS AvgTxPwr4G
				,MAX(TxPower)						AS MaxTxPwr4G
				,StDev(TxPower)						AS StDevTxPwr4G
		INTO #S_RadioTx_4G
		FROM [LTEPUCCHCQI]	AS a
		WHERE TxPower <= 24
		GROUP BY SessionId

------------------------------------------------------------------------------------------------------------------
-- TEST LTE Tx Pwr                                                                                           --
------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('tempdb..#RadioTx_4G' ) IS NOT NULL	DROP TABLE #RadioTx_4G
		SELECT   SessionId,TestId
				,MIN(TxPower)						AS MinTxPwr4G
				,AVG(TxPower)						AS AvgTxPwr4G
				,MAX(TxPower)						AS MaxTxPwr4G
				,StDev(TxPower)						AS StDevTxPwr4G
		INTO #RadioTx_4G
		FROM LTEPUCCHCQI	AS a
		WHERE a.TestId <> 0 and TxPower <= 24
		GROUP BY SessionId,TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - LTE Calculation COMPLETED...')

------------------------------------------------------------------------------------------------------------------
-- CREATE NEW_RF_Session_2018 TABLE                                                                             --
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 assembling...')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RF_Session_2018 ' AND type = 'U')	DROP TABLE NEW_RF_Session_2018
	SELECT DISTINCT SessionId 
				   ,CAST(null as decimal(10,2)) AS MinRxLev	
				   ,CAST(null as decimal(10,2)) AS AvgRxLev	
				   ,CAST(null as decimal(10,2)) AS MaxRxLev	
				   ,CAST(null as decimal(10,2)) AS StDevRxLev	
				   ,CAST(null as decimal(10,2)) AS MinRxQual	
				   ,CAST(null as decimal(10,2)) AS AvgRxQual	
				   ,CAST(null as decimal(10,2)) AS MaxRxQual	
				   ,CAST(null as decimal(10,2)) AS StDevRxQual
				   ,CAST(null as decimal(10,2)) AS MinRSCP	
				   ,CAST(null as decimal(10,2)) AS AvgRSCP	
				   ,CAST(null as decimal(10,2)) AS MaxRSCP	
				   ,CAST(null as decimal(10,2)) AS StDevRSCP	
				   ,CAST(null as decimal(10,2)) AS MinEcIo	
				   ,CAST(null as decimal(10,2)) AS AvgEcIo	
				   ,CAST(null as decimal(10,2)) AS MaxEcIo	
				   ,CAST(null as decimal(10,2)) AS StDevEcIo	
				   ,CAST(null as decimal(10,2)) AS MinTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS AvgTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS MaxTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS StDevTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS MinRSRP		
				   ,CAST(null as decimal(10,2)) AS AvgRSRP		
				   ,CAST(null as decimal(10,2)) AS MaxRSRP		
				   ,CAST(null as decimal(10,2)) AS StDevRSRP	
				   ,CAST(null as decimal(10,2)) AS MinRSRQ		
				   ,CAST(null as decimal(10,2)) AS AvgRSRQ		
				   ,CAST(null as decimal(10,2)) AS MaxRSRQ		
				   ,CAST(null as decimal(10,2)) AS StDevRSRQ	
				   ,CAST(null as decimal(10,2)) AS MinSINR		
				   ,CAST(null as decimal(10,2)) AS AvgSINR		
				   ,CAST(null as decimal(10,2)) AS MaxSINR		
				   ,CAST(null as decimal(10,2)) AS StDevSINR	
				   ,CAST(null as decimal(10,2)) AS MinSINR0		
				   ,CAST(null as decimal(10,2)) AS AvgSINR0		
				   ,CAST(null as decimal(10,2)) AS MaxSINR0		
				   ,CAST(null as decimal(10,2)) AS StDevSINR0	
				   ,CAST(null as decimal(10,2)) AS MinSINR1		
				   ,CAST(null as decimal(10,2)) AS AvgSINR1		
				   ,CAST(null as decimal(10,2)) AS MaxSINR1		
				   ,CAST(null as decimal(10,2)) AS StDevSINR1
				   ,CAST(null as decimal(10,2)) AS MinTxPwr4G	
				   ,CAST(null as decimal(10,2)) AS AvgTxPwr4G	
				   ,CAST(null as decimal(10,2)) AS MaxTxPwr4G	
				   ,CAST(null as decimal(10,2)) AS StDevTxPwr4G		
	INTO NEW_RF_Session_2018	
	FROM (select SessionId from #S_GSMRadioRF
			union all
		  select SessionId from #S_UMTSRadioRF
			union all
		  select SessionId from #S_RadioTx_3G
			union all
		  select SessionId from #S_LTERadioRF
			union all
		  select SessionId from #S_RadioTx_4G) AS A

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 updating 2G RF Values...')
		UPDATE NEW_RF_Session_2018
		SET	 MinRxLev		= CAST(b.MinRxLev	 as decimal(10,2))
			,AvgRxLev		= CAST(b.AvgRxLev	 as decimal(10,2))
			,MaxRxLev		= CAST(b.MaxRxLev	 as decimal(10,2))
			,StDevRxLev		= CAST(b.StDevRxLev	 as decimal(10,2))
			,MinRxQual		= CAST(b.MinRxQual	 as decimal(10,2))
			,AvgRxQual		= CAST(b.AvgRxQual	 as decimal(10,2))
			,MaxRxQual		= CAST(b.MaxRxQual	 as decimal(10,2))
			,StDevRxQual	= CAST(b.StDevRxQual as decimal(10,2))
		FROM NEW_RF_Session_2018 a
		LEFT OUTER JOIN #S_GSMRadioRF b ON a.SessionId = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 updating 3G RF Values...')
		UPDATE NEW_RF_Session_2018
		SET	 MinRSCP		= CAST(b.MinRSCP   as decimal(10,2))
			,AvgRSCP		= CAST(b.AvgRSCP   as decimal(10,2))
			,MaxRSCP		= CAST(b.MaxRSCP   as decimal(10,2))
			,StDevRSCP		= CAST(b.StDevRSCP as decimal(10,2))
			,MinEcIo		= CAST(b.MinEcIo   as decimal(10,2))
			,AvgEcIo		= CAST(b.AvgEcIo   as decimal(10,2))
			,MaxEcIo		= CAST(b.MaxEcIo   as decimal(10,2))
			,StDevEcIo		= CAST(b.StDevEcIo as decimal(10,2))
		FROM NEW_RF_Session_2018 a
		RIGHT OUTER JOIN #S_UMTSRadioRF b ON a.SessionId = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 updating 3G Tx Power Values...')
		UPDATE NEW_RF_Session_2018
		SET	 MinTxPwr3G			= CAST(b.MinTxPwr3G	   as decimal(10,2))
			,AvgTxPwr3G			= CAST(b.AvgTxPwr3G	   as decimal(10,2))
			,MaxTxPwr3G			= CAST(b.MaxTxPwr3G	   as decimal(10,2))
			,StDevTxPwr3G		= CAST(b.StDevTxPwr3G  as decimal(10,2))
		FROM NEW_RF_Session_2018 a
		LEFT OUTER JOIN #S_RadioTx_3G b ON a.SessionId = b.SessionId
		WHERE a.AvgRSCP is not null

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 updating 4G RF Values...')
		UPDATE NEW_RF_Session_2018	
		SET	 MinRSRP		= CAST(b.MinRSRP															   as decimal(10,2))
			,AvgRSRP		= CAST(b.AvgRSRP															   as decimal(10,2))
			,MaxRSRP		= CAST(b.MaxRSRP															   as decimal(10,2))
			,StDevRSRP		= CAST(b.StDevRSRP															   as decimal(10,2))
			,MinRSRQ		= CAST(b.MinRSRQ															   as decimal(10,2))
			,AvgRSRQ		= CAST(b.AvgRSRQ															   as decimal(10,2))
			,MaxRSRQ		= CAST(b.MaxRSRQ															   as decimal(10,2))
			,StDevRSRQ		= CAST(b.StDevRSRQ															   as decimal(10,2))
			,MinSINR		= CAST(CASE WHEN b.MinSINR0 < b.MinSINR1 THEN b.MinSINR0 ELSE b.MinSINR1 END   as decimal(10,2))
			,AvgSINR		= CAST((b.AvgSINR0 + b.AvgSINR1)/2											   as decimal(10,2))
			,MaxSINR		= CAST(CASE WHEN b.MaxSINR0 > b.MaxSINR1 THEN b.MaxSINR0 ELSE b.MaxSINR1 END   as decimal(10,2))
			,StDevSINR		= CAST((b.StDevSINR0 + b.StDevSINR1)/2										   as decimal(10,2))
			,MinSINR0		= CAST(b.MinSINR0															   as decimal(10,2))
			,AvgSINR0		= CAST(b.AvgSINR0															   as decimal(10,2))
			,MaxSINR0		= CAST(b.MaxSINR0															   as decimal(10,2))
			,StDevSINR0		= CAST(b.StDevSINR0															   as decimal(10,2))
			,MinSINR1		= CAST(b.MinSINR1															   as decimal(10,2))
			,AvgSINR1		= CAST(b.AvgSINR1															   as decimal(10,2))
			,MaxSINR1		= CAST(b.MaxSINR1															   as decimal(10,2))
			,StDevSINR1		= CAST(b.StDevSINR1															   as decimal(10,2))
		FROM NEW_RF_Session_2018 a
		LEFT OUTER JOIN #S_LTERadioRF b ON a.SessionId = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 updating 4G Tx Power Values...')
		UPDATE NEW_RF_Session_2018
		SET	 MinTxPwr4G		= CAST(b.MinTxPwr4G	   as decimal(10,2))
			,AvgTxPwr4G		= CAST(b.AvgTxPwr4G	   as decimal(10,2))
			,MaxTxPwr4G		= CAST(b.MaxTxPwr4G	   as decimal(10,2))
			,StDevTxPwr4G	= CAST(b.StDevTxPwr4G  as decimal(10,2))
		FROM NEW_RF_Session_2018 a
		LEFT OUTER JOIN #S_RadioTx_4G b ON a.SessionId = b.SessionId
		WHERE a.AvgRSRP is not null

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 assembling COMPLETED!')

------------------------------------------------------------------------------------------------------------------
-- CREATE NEW_RF_Test_2018 TABLE                                                                                --
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Test_2018 assembling...')
	IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RF_Test_2018' AND type = 'U')	DROP TABLE NEW_RF_Test_2018
	SELECT DISTINCT SessionId 
				   ,TestId
				   ,CAST(null as decimal(10,2)) AS MinRxLev	
				   ,CAST(null as decimal(10,2)) AS AvgRxLev	
				   ,CAST(null as decimal(10,2)) AS MaxRxLev	
				   ,CAST(null as decimal(10,2)) AS StDevRxLev	
				   ,CAST(null as decimal(10,2)) AS MinRxQual	
				   ,CAST(null as decimal(10,2)) AS AvgRxQual	
				   ,CAST(null as decimal(10,2)) AS MaxRxQual	
				   ,CAST(null as decimal(10,2)) AS StDevRxQual
				   ,CAST(null as decimal(10,2)) AS MinRSCP	
				   ,CAST(null as decimal(10,2)) AS AvgRSCP	
				   ,CAST(null as decimal(10,2)) AS MaxRSCP	
				   ,CAST(null as decimal(10,2)) AS StDevRSCP	
				   ,CAST(null as decimal(10,2)) AS MinEcIo	
				   ,CAST(null as decimal(10,2)) AS AvgEcIo	
				   ,CAST(null as decimal(10,2)) AS MaxEcIo	
				   ,CAST(null as decimal(10,2)) AS StDevEcIo	
				   ,CAST(null as decimal(10,2)) AS MinTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS AvgTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS MaxTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS StDevTxPwr3G	
				   ,CAST(null as decimal(10,2)) AS MinRSRP		
				   ,CAST(null as decimal(10,2)) AS AvgRSRP		
				   ,CAST(null as decimal(10,2)) AS MaxRSRP		
				   ,CAST(null as decimal(10,2)) AS StDevRSRP	
				   ,CAST(null as decimal(10,2)) AS MinRSRQ		
				   ,CAST(null as decimal(10,2)) AS AvgRSRQ		
				   ,CAST(null as decimal(10,2)) AS MaxRSRQ		
				   ,CAST(null as decimal(10,2)) AS StDevRSRQ	
				   ,CAST(null as decimal(10,2)) AS MinSINR		
				   ,CAST(null as decimal(10,2)) AS AvgSINR		
				   ,CAST(null as decimal(10,2)) AS MaxSINR		
				   ,CAST(null as decimal(10,2)) AS StDevSINR	
				   ,CAST(null as decimal(10,2)) AS MinSINR0		
				   ,CAST(null as decimal(10,2)) AS AvgSINR0		
				   ,CAST(null as decimal(10,2)) AS MaxSINR0		
				   ,CAST(null as decimal(10,2)) AS StDevSINR0	
				   ,CAST(null as decimal(10,2)) AS MinSINR1		
				   ,CAST(null as decimal(10,2)) AS AvgSINR1		
				   ,CAST(null as decimal(10,2)) AS MaxSINR1		
				   ,CAST(null as decimal(10,2)) AS StDevSINR1
				   ,CAST(null as decimal(10,2)) AS MinTxPwr4G	
				   ,CAST(null as decimal(10,2)) AS AvgTxPwr4G	
				   ,CAST(null as decimal(10,2)) AS MaxTxPwr4G	
				   ,CAST(null as decimal(10,2)) AS StDevTxPwr4G		
	INTO NEW_RF_Test_2018	
	FROM (select SessionId,TestId from #GSMRadioRF
			union all
		  select SessionId,TestId from #UMTSRadioRF
			union all
		  select SessionId,TestId from #RadioTx_3G
			union all
		  select SessionId,TestId from #LTERadioRF
			union all
		  select SessionId,TestId from #RadioTx_4G) AS A

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Test_2018 updating 2G RF Values...')
		UPDATE NEW_RF_Test_2018
		SET	 MinRxLev		= CAST(b.MinRxLev	 as decimal(10,2))
			,AvgRxLev		= CAST(b.AvgRxLev	 as decimal(10,2))
			,MaxRxLev		= CAST(b.MaxRxLev	 as decimal(10,2))
			,StDevRxLev		= CAST(b.StDevRxLev	 as decimal(10,2))
			,MinRxQual		= CAST(b.MinRxQual	 as decimal(10,2))
			,AvgRxQual		= CAST(b.AvgRxQual	 as decimal(10,2))
			,MaxRxQual		= CAST(b.MaxRxQual	 as decimal(10,2))
			,StDevRxQual	= CAST(b.StDevRxQual as decimal(10,2))
		FROM NEW_RF_Test_2018 a
		LEFT OUTER JOIN #GSMRadioRF b ON a.SessionId = b.SessionId and a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Test_2018 updating 3G RF Values...')
		UPDATE NEW_RF_Test_2018
		SET	 MinRSCP		= CAST(b.MinRSCP   as decimal(10,2))
			,AvgRSCP		= CAST(b.AvgRSCP   as decimal(10,2))
			,MaxRSCP		= CAST(b.MaxRSCP   as decimal(10,2))
			,StDevRSCP		= CAST(b.StDevRSCP as decimal(10,2))
			,MinEcIo		= CAST(b.MinEcIo   as decimal(10,2))
			,AvgEcIo		= CAST(b.AvgEcIo   as decimal(10,2))
			,MaxEcIo		= CAST(b.MaxEcIo   as decimal(10,2))
			,StDevEcIo		= CAST(b.StDevEcIo as decimal(10,2))
		FROM NEW_RF_Test_2018 a
		RIGHT OUTER JOIN #UMTSRadioRF b ON a.SessionId = b.SessionId and a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Test_2018 updating 3G Tx Power Values...')
		UPDATE NEW_RF_Test_2018
		SET	 MinTxPwr3G			= CAST(b.MinTxPwr3G	   as decimal(10,2))
			,AvgTxPwr3G			= CAST(b.AvgTxPwr3G	   as decimal(10,2))
			,MaxTxPwr3G			= CAST(b.MaxTxPwr3G	   as decimal(10,2))
			,StDevTxPwr3G		= CAST(b.StDevTxPwr3G  as decimal(10,2))
		FROM NEW_RF_Test_2018 a
		LEFT OUTER JOIN #RadioTx_3G b ON a.SessionId = b.SessionId and a.TestId = b.TestId
		WHERE a.AvgRSCP is not null

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Test_2018 updating 4G RF Values...')
		UPDATE NEW_RF_Test_2018	
		SET	 MinRSRP		= CAST(b.MinRSRP															   as decimal(10,2))
			,AvgRSRP		= CAST(b.AvgRSRP															   as decimal(10,2))
			,MaxRSRP		= CAST(b.MaxRSRP															   as decimal(10,2))
			,StDevRSRP		= CAST(b.StDevRSRP															   as decimal(10,2))
			,MinRSRQ		= CAST(b.MinRSRQ															   as decimal(10,2))
			,AvgRSRQ		= CAST(b.AvgRSRQ															   as decimal(10,2))
			,MaxRSRQ		= CAST(b.MaxRSRQ															   as decimal(10,2))
			,StDevRSRQ		= CAST(b.StDevRSRQ															   as decimal(10,2))
			,MinSINR		= CAST(CASE WHEN b.MinSINR0 < b.MinSINR1 THEN b.MinSINR0 ELSE b.MinSINR1 END   as decimal(10,2))
			,AvgSINR		= CAST((b.AvgSINR0 + b.AvgSINR1)/2											   as decimal(10,2))
			,MaxSINR		= CAST(CASE WHEN b.MaxSINR0 > b.MaxSINR1 THEN b.MaxSINR0 ELSE b.MaxSINR1 END   as decimal(10,2))
			,StDevSINR		= CAST((b.StDevSINR0 + b.StDevSINR1)/2										   as decimal(10,2))
			,MinSINR0		= CAST(b.MinSINR0															   as decimal(10,2))
			,AvgSINR0		= CAST(b.AvgSINR0															   as decimal(10,2))
			,MaxSINR0		= CAST(b.MaxSINR0															   as decimal(10,2))
			,StDevSINR0		= CAST(b.StDevSINR0															   as decimal(10,2))
			,MinSINR1		= CAST(b.MinSINR1															   as decimal(10,2))
			,AvgSINR1		= CAST(b.AvgSINR1															   as decimal(10,2))
			,MaxSINR1		= CAST(b.MaxSINR1															   as decimal(10,2))
			,StDevSINR1		= CAST(b.StDevSINR1															   as decimal(10,2))
		FROM NEW_RF_Test_2018 a
		LEFT OUTER JOIN #LTERadioRF b ON a.SessionId = b.SessionId and a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Test_2018 updating 4G Tx Power Values...')
		UPDATE NEW_RF_Test_2018
		SET	 MinTxPwr4G		= CAST(b.MinTxPwr4G	   as decimal(10,2))
			,AvgTxPwr4G		= CAST(b.AvgTxPwr4G	   as decimal(10,2))
			,MaxTxPwr4G		= CAST(b.MaxTxPwr4G	   as decimal(10,2))
			,StDevTxPwr4G	= CAST(b.StDevTxPwr4G  as decimal(10,2))
		FROM NEW_RF_Test_2018 a
		LEFT OUTER JOIN #RadioTx_4G b ON a.SessionId = b.SessionId and a.TestId = b.TestId
		WHERE a.AvgRSRP is not null

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RF_Session_2018 assembling COMPLETED!')

-- SELECT * FROM NEW_RF_Session_2018 order by SessionId
-- SELECT * FROM NEW_RF_Test_2018 order by TestId,SessionId