PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execution...')
--  _____            _   _   _____       __          __
-- |  __ \     /\   | \ | | |  __ \     /\ \        / /
-- | |__) |   /  \  |  \| | | |__) |   /  \ \  /\  / / 
-- |  _  /   / /\ \ | . ` | |  _  /   / /\ \ \/  \/ /  
-- | | \ \  / ____ \| |\  | | | \ \  / ____ \  /\  /   
-- |_|  \_\/_/    \_\_| \_| |_|  \_\/_/    \_\/  \/  

-- drop table NEW_RAN_RAW_2019
-- drop table NEW_RAN_RAW_2019_NEW
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CREATING TABLE NEW_RAN_RAW_2019...')
if not exists (select * from sysobjects where name='NEW_RAN_RAW_2019' and xtype='U')
	begin
	create table NEW_RAN_RAW_2019 ( FileId								bigint,
									SessionId							bigint,
									TestId								bigint,
									NetworkId							bigint,
									MsgTime								datetime2(3),
									MCC									int,            
									MNC									int,              
									LAC									int,              
									BCCH								int,              
									Cid									int,              
									sc1									int,              
									sc2									int,              
									sc3									int,              
									sc4									int,         
									technology							varchar(50),     
									rfband								int,              
									BSIC								int,              
									CGI									varchar(50),     
									PCI									int,      
									duration							bigint)
	CREATE INDEX ran ON NEW_RAN_RAW_2019 (SessionId,TestId,NetworkId)
	end

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - ADDING NEW INTO TABLE NEW_RAN_RAW_2019...')
IF OBJECT_ID ('tempdb..#existingSessions' ) IS NOT NULL DROP TABLE #existingSessions
select * 
into #existingSessions
from
(select distinct SessionId from Sessions 
union all 
select distinct SessionId from SessionsB) as A
except select distinct SessionId from  NEW_RAN_RAW_2019

-- INSERT NEW SESSIONS INTO RAW TABLE
if exists (select * from sysobjects where name='NEW_RAN_RAW_2019_NEW' and xtype='U') DROP TABLE NEW_RAN_RAW_2019_NEW
Select distinct	FileId,SessionId,TestId,NetworkId,MsgTime
			   ,cast(null as int)				as MCC			
			   ,cast(null as int)				as MNC			  
			   ,cast(null as int)				as LAC			  
			   ,cast(null as int)				as BCCH		  
			   ,cast(null as int)				as Cid			  
			   ,cast(null as int)				as sc1			  
			   ,cast(null as int)				as sc2			  
			   ,cast(null as int)				as sc3			  
			   ,cast(null as int)				as sc4			
			   ,cast(null as varchar(50))		as technology	
			   ,cast(null as int)				as rfband		
			   ,cast(null as int)				as BSIC		  
			   ,cast(null as varchar(50))		as CGI			 
			   ,cast(null as int)				as PCI			
			   ,cast(null as bigint)			as duration
into NEW_RAN_RAW_2019_NEW         
from
	(select FileId,
		   SessionId,
		   cast(0 as bigint) as TestId,
		   StartNetworkId As NetworkId,
		   startTime as MsgTime
	 from Sessions where SessionId in (select SessionId from #existingSessions)
	union all
	select FileId,
		   SessionId,
		   cast(0 as bigint) as TestId,
		   StartNetworkId As NetworkId,
		   startTime as MsgTime
	 from SessionsB where SessionId in (select SessionId from #existingSessions)
	union all
	select FileId,
		   SessionId,
		   cast(0 as bigint) as TestId,
		   StartNetworkId As NetworkId,
		   startTime as MsgTime
	 from SessionsB where SessionId in (select SessionId from #existingSessions)
	union all
	select b.FileId,
		   a.SessionId,
		   a.TestId,
		   a.StartNetworkId As NetworkId,
		   a.startTime as MsgTime
	 from TestInfo as a 
	 left outer join Sessions b on a.SessionId = b.SessionId  where a.SessionId in (select SessionId from #existingSessions)
	union all
	select b.FileId,
		   a.SessionId,
		   a.TestId,
		   a.NetworkId,
		   a.MsgTime
	 from WCDMAActiveSet a
	 left outer join Sessions b on a.SessionId = b.SessionId  where a.SessionId in (select SessionId from #existingSessions)
	union all
	select b.FileId,
		   a.SessionId,
		   a.TestId,
		   a.NetworkId,
		   a.MsgTime
	 from LTEServingCellInfo a
	 left outer join Sessions b on a.SessionId = b.SessionId  where a.SessionId in (select SessionId from #existingSessions)
	union all
	select b.FileId,
		   a.SessionId,
		   a.TestId,
		   a.NetworkId,
		   a.MsgTime
	 from NetworkIdRelation a
	 left outer join Sessions b on a.SessionId = b.SessionId  where a.SessionId in (select SessionId from #existingSessions)) a 

update NEW_RAN_RAW_2019_NEW
set  MCC		= b.MCC
	,MNC		= b.MNC
	,LAC		= b.LAC
	,BCCH		= b.BCCH
	,Cid		= b.CId
	,sc1		= b.SC1
	,sc2		= b.SC2
	,sc3		= b.SC3
	,technology	= b.technology
	,rfband		= b.RFBand
	,BSIC		= b.BSIC
	,CGI		= b.CGI
	,duration	= b.Duration
from NEW_RAN_RAW_2019_NEW a
left outer join NetworkInfo b on a.NetworkId = b.NetworkId
 where a.SessionId in (select SessionId from #existingSessions)

update NEW_RAN_RAW_2019_NEW
set sc4 = PrimScCode
from NEW_RAN_RAW_2019_NEW a
left outer join (select SessionId,TestId,NetworkId,MsgTime,PrimScCode
					from WCDMAActiveSet
					where numCells = 4
					group by SessionId,TestId,NetworkId,MsgTime,PrimScCode) as was
					on was.NetworkId=a.NetworkId and was.PrimScCode not in(a.SC1,a.SC2,a.SC3)
 where a.SessionId in (select SessionId from #existingSessions)

UPDATE NEW_RAN_RAW_2019_NEW
SET PCI = sc1
WHERE technology like 'LTE%' and PCI is null and
		 SessionId in (select SessionId from #existingSessions)

UPDATE NEW_RAN_RAW_2019_NEW
SET sc1 = null
   ,sc2 = null
   ,sc3 = null
   ,sc4 = null
WHERE technology like 'LTE%' and
		 SessionId in (select SessionId from #existingSessions)
		 -- select * from NEW_RAN_RAW_2019
insert into NEW_RAN_RAW_2019 
select *
from NEW_RAN_RAW_2019_NEW
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - COMPLETED ADDING INTO TABLE NEW_RAN_RAW_2019...')
go
--  _____            _   _            _____  _____ _____  ______ _____       _______ ______ 
-- |  __ \     /\   | \ | |     /\   / ____|/ ____|  __ \|  ____/ ____|   /\|__   __|  ____|
-- | |__) |   /  \  |  \| |    /  \ | |  __| |  __| |__) | |__ | |  __   /  \  | |  | |__   
-- |  _  /   / /\ \ | . ` |   / /\ \| | |_ | | |_ |  _  /|  __|| | |_ | / /\ \ | |  |  __|  
-- | | \ \  / ____ \| |\  |  / ____ \ |__| | |__| | | \ \| |___| |__| |/ ____ \| |  | |____ 
-- |_|  \_\/_/    \_\_| \_| /_/    \_\_____|\_____|_|  \_\______\_____/_/    \_\_|  |______|
--                                                                                          

Declare @cSessionId as bigint   = 0
Declare @pSessionId as bigint   = 0
Declare @cTestId as bigint   = 0
Declare @pTestId as bigint   = 0
Declare @cMCC as varchar(3)   = ''
Declare @pMCC as varchar(3)   = ''
Declare @rMCC as varchar(500) = ''
Declare @tMCC as varchar(500) = ''
Declare @cMNC as varchar(3)   = ''
Declare @pMNC as varchar(3)   = ''
Declare @rMNC as varchar(500) = ''
Declare @tMNC as varchar(500) = ''
Declare @cLAC as varchar(7)   = ''
Declare @pLAC as varchar(7)   = ''
Declare @rLAC as varchar(500) = ''
Declare @tLAC as varchar(500) = ''
Declare @cCGI as varchar(24)  = ''
Declare @pCGI as varchar(24)  = ''
Declare @rCGI as varchar(2000)  = ''
Declare @tCGI as varchar(2000)  = ''
Declare @cPCI as varchar(3)   = ''
Declare @pPCI as varchar(3)   = ''
Declare @rPCI as varchar(500) = ''
Declare @tPCI as varchar(500) = ''
Declare @cCID as varchar(24)  = ''
Declare @pCID as varchar(24)  = ''
Declare @rCID as varchar(500)  = ''
Declare @tCID as varchar(500)  = ''
Declare @cBCCH as varchar(6)   = ''
Declare @pBCCH as varchar(6)   = ''
Declare @rBCCH as varchar(500) = ''
Declare @tBCCH as varchar(500) = ''
Declare @cBSIC as varchar(6)   = ''
Declare @pBSIC as varchar(6)   = ''
Declare @rBSIC as varchar(500) = ''
Declare @tBSIC as varchar(500) = ''
Declare @csc1 as varchar(3)   = ''
Declare @psc1 as varchar(3)   = ''
Declare @rsc1 as varchar(500) = ''
Declare @tsc1 as varchar(500) = ''
Declare @csc2 as varchar(3)   = ''
Declare @psc2 as varchar(3)   = ''
Declare @rsc2 as varchar(500) = ''
Declare @tsc2 as varchar(500) = ''
Declare @csc3 as varchar(3)   = ''
Declare @psc3 as varchar(3)   = ''
Declare @rsc3 as varchar(500) = ''
Declare @tsc3 as varchar(500) = ''
Declare @csc4 as varchar(3)   = ''
Declare @psc4 as varchar(3)   = ''
Declare @rsc4 as varchar(500) = ''
Declare @tsc4 as varchar(500) = ''
Declare @ctec as varchar(30)   = ''
Declare @ptec as varchar(30)   = ''
Declare @rtec as varchar(2000)= ''
Declare @ttec as varchar(2000)= ''
Declare @start as datetime2(2) = cast(GETDATE() as datetime2(3))
Declare @exec as bigint = 0

-- DROP TABLE NEW_RAN_SESSION_2019
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CREATING TABLE NEW_RAN_SESSION_2019...')
IF NOT EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RAN_SESSION_2019' AND type = 'U')
	CREATE TABLE NEW_RAN_SESSION_2019 (SessionId					bigint,
							  MinTime					datetime2(3),
							  MaxTime					datetime2(3),
							  MCC						varchar(500),
							  MNC						varchar(500),
							  LAC						varchar(500),
							  BCCH						varchar(500),
							  CGI						varchar(2000),
							  CID						varchar(500),
							  BSIC						varchar(500),
							  sc1						varchar(500),
							  sc2						varchar(500),
							  sc3						varchar(500),
							  sc4						varchar(500),
							  PCI						varchar(2000),
							  LAC_CID_BCCH				varchar(2000),
							  Disconnect_CGI			varchar(500),
							  Disconnect_LAC_CID_BCCH	varchar(2000),
							  									AvgTA2G								bigint, 
									MaxTA2G								bigint, 
									CQI_HSDPA_Min						bigint, 
									CQI_HSDPA							bigint, 
									CQI_HSDPA_Max						bigint, 
									CQI_HSDPA_StDev						float, 
									ACK3G								bigint, 
									NACK3G								bigint, 
									ACKNACK3G_Total						bigint, 
									BLER3G								float, 
									BLER3GSamples						bigint, 
									StDevBLER3G							float, 
									CQI_LTE_Min							float, 
									CQI_LTE_Avg							float, 
									CQI_LTE_Max							float, 
									CQI_LTE_StDev						float, 
									ACK4G								bigint, 
									NACK4G								bigint, 
									ACKNACK4G_Total						bigint, 
									AvgDLTA4G							bigint, 
									MaxDLTA4G							bigint, 
									LTE_DL_MinDLNumCarriers				float, 
									LTE_DL_AvgDLNumCarriers				float, 
									LTE_DL_MaxDLNumCarriers				float, 
									LTE_DL_MinRB						float, 
									LTE_DL_AvgRB						float, 
									LTE_DL_MaxRB						float, 
									LTE_DL_MinMCS						float, 
									LTE_DL_AvgMCS						float, 
									LTE_DL_MaxMCS						float, 
									LTE_DL_CountNumQPSK					bigint, 
									LTE_DL_CountNum16QAM				bigint, 
									LTE_DL_CountNum64QAM				bigint, 
									LTE_DL_CountNum256QAM				bigint, 
									LTE_DL_CountModulation				bigint, 
									LTE_DL_MinScheduledPDSCHThroughput	float, 
									LTE_DL_AvgScheduledPDSCHThroughput	float, 
									LTE_DL_MaxScheduledPDSCHThroughput	float, 
									LTE_DL_MinNetPDSCHThroughput		float, 
									LTE_DL_AvgNetPDSCHThroughput		float, 
									LTE_DL_MaxNetPDSCHThroughput		float, 
									LTE_DL_PDSCHBytesTransfered			bigint, 
									LTE_DL_MinBLER						float, 
									LTE_DL_AvgBLER						float, 
									LTE_DL_MaxBLER						float, 
									LTE_DL_MinTBSize					float, 
									LTE_DL_AvgTBSize					float, 
									LTE_DL_MaxTBSize					float, 
									LTE_DL_MinTBRate					float, 
									LTE_DL_AvgTBRate					float, 
									LTE_DL_MaxTBRate					float, 
									LTE_DL_TransmissionMode				varchar(100),
									LTE_UL_MinULNumCarriers				float, 
									LTE_UL_AvgULNumCarriers				float, 
									LTE_UL_MaxULNumCarriers				float, 
									LTE_UL_CountNumBPSK					bigint, 
									LTE_UL_CountNumQPSK					bigint, 
									LTE_UL_CountNum16QAM				bigint, 
									LTE_UL_CountNum64QAM				bigint, 
									LTE_UL_CountModulation				bigint, 
									LTE_UL_MinScheduledPUSCHThroughput	float, 
									LTE_UL_AvgScheduledPUSCHThroughput	float, 
									LTE_UL_MaxScheduledPUSCHThroughput	float, 
									LTE_UL_MinNetPUSCHThroughput		float, 
									LTE_UL_AvgNetPUSCHThroughput		float, 
									LTE_UL_MaxNetPUSCHThroughput		float, 
									LTE_UL_PUSCHBytesTransfered			bigint, 
									LTE_UL_MinTBSize					float, 
									LTE_UL_AvgTBSize					float, 
									LTE_UL_MaxTBSize					float, 
									LTE_UL_MinTBRate					float, 
									LTE_UL_AvgTBRate					float, 
									LTE_UL_MaxTBRate					float, 
									CA_PCI								varchar(5000), 
									HandoversInfo						varchar(5000))

IF OBJECT_ID ('tempdb..#existingRSessions' ) IS NOT NULL DROP TABLE #existingRSessions
select distinct SessionId into #existingRSessions from  NEW_RAN_SESSION_2019

-- DROP TABLE NEW_RAN_TEST_2019
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CREATING TABLE NEW_RAN_TEST_2019...')
IF NOT EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RAN_TEST_2019' AND type = 'U')
	CREATE TABLE NEW_RAN_TEST_2019  (SessionId					bigint,
									 TestId					    bigint,
									 MinTime					datetime2(3),
									 MaxTime					datetime2(3),
									 MCC						varchar(500),
									 MNC						varchar(500),
									 LAC						varchar(500),
									 BCCH						varchar(500),
									 CGI						varchar(2000),
									 CID						varchar(500),
									 BSIC						varchar(500),
									 sc1						varchar(500),
									 sc2						varchar(500),
									 sc3						varchar(500),
									 sc4						varchar(500),
									 PCI						varchar(2000),
									 LAC_CID_BCCH				varchar(2000),
									 									AvgTA2G								bigint, 
									MaxTA2G								bigint, 
									CQI_HSDPA_Min						bigint, 
									CQI_HSDPA							bigint, 
									CQI_HSDPA_Max						bigint, 
									CQI_HSDPA_StDev						float, 
									ACK3G								bigint, 
									NACK3G								bigint, 
									ACKNACK3G_Total						bigint, 
									BLER3G								float, 
									BLER3GSamples						bigint, 
									StDevBLER3G							float, 
									CQI_LTE_Min							float, 
									CQI_LTE_Avg							float, 
									CQI_LTE_Max							float, 
									CQI_LTE_StDev						float, 
									ACK4G								bigint, 
									NACK4G								bigint, 
									ACKNACK4G_Total						bigint, 
									AvgDLTA4G							bigint, 
									MaxDLTA4G							bigint, 
									LTE_DL_MinDLNumCarriers				float, 
									LTE_DL_AvgDLNumCarriers				float, 
									LTE_DL_MaxDLNumCarriers				float, 
									LTE_DL_MinRB						float, 
									LTE_DL_AvgRB						float, 
									LTE_DL_MaxRB						float, 
									LTE_DL_MinMCS						float, 
									LTE_DL_AvgMCS						float, 
									LTE_DL_MaxMCS						float, 
									LTE_DL_CountNumQPSK					bigint, 
									LTE_DL_CountNum16QAM				bigint, 
									LTE_DL_CountNum64QAM				bigint, 
									LTE_DL_CountNum256QAM				bigint, 
									LTE_DL_CountModulation				bigint, 
									LTE_DL_MinScheduledPDSCHThroughput	float, 
									LTE_DL_AvgScheduledPDSCHThroughput	float, 
									LTE_DL_MaxScheduledPDSCHThroughput	float, 
									LTE_DL_MinNetPDSCHThroughput		float, 
									LTE_DL_AvgNetPDSCHThroughput		float, 
									LTE_DL_MaxNetPDSCHThroughput		float, 
									LTE_DL_PDSCHBytesTransfered			bigint, 
									LTE_DL_MinBLER						float, 
									LTE_DL_AvgBLER						float, 
									LTE_DL_MaxBLER						float, 
									LTE_DL_MinTBSize					float, 
									LTE_DL_AvgTBSize					float, 
									LTE_DL_MaxTBSize					float, 
									LTE_DL_MinTBRate					float, 
									LTE_DL_AvgTBRate					float, 
									LTE_DL_MaxTBRate					float, 
									LTE_DL_TransmissionMode				varchar(100),
									LTE_UL_MinULNumCarriers				float, 
									LTE_UL_AvgULNumCarriers				float, 
									LTE_UL_MaxULNumCarriers				float, 
									LTE_UL_CountNumBPSK					bigint, 
									LTE_UL_CountNumQPSK					bigint, 
									LTE_UL_CountNum16QAM				bigint, 
									LTE_UL_CountNum64QAM				bigint, 
									LTE_UL_CountModulation				bigint, 
									LTE_UL_MinScheduledPUSCHThroughput	float, 
									LTE_UL_AvgScheduledPUSCHThroughput	float, 
									LTE_UL_MaxScheduledPUSCHThroughput	float, 
									LTE_UL_MinNetPUSCHThroughput		float, 
									LTE_UL_AvgNetPUSCHThroughput		float, 
									LTE_UL_MaxNetPUSCHThroughput		float, 
									LTE_UL_PUSCHBytesTransfered			bigint, 
									LTE_UL_MinTBSize					float, 
									LTE_UL_AvgTBSize					float, 
									LTE_UL_MaxTBSize					float, 
									LTE_UL_MinTBRate					float, 
									LTE_UL_AvgTBRate					float, 
									LTE_UL_MaxTBRate					float, 
									CA_PCI								varchar(5000), 
									HandoversInfo						varchar(5000))

IF OBJECT_ID ('tempdb..#existingRTests' ) IS NOT NULL DROP TABLE #existingRTests
select distinct SessionId,TestId into #existingRTests from  NEW_RAN_TEST_2019

DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
    SELECT SessionId,TestId,MCC,MNC,CGI,LAC,PCI,CID,BCCH,BSIC,sc1,sc2,sc3,sc4,technology
    from
            NEW_RAN_RAW_2019_NEW
    order by SessionId,msgtime
Open TN_cursor
while 1=1
Begin
	Fetch next FROM TN_cursor into @cSessionId, @cTestId, @cMCC, @cMNC, @cCGI, @cLAC, @cPCI, @cCID, @cBCCH, @cBSIC, @csc1, @csc2, @csc3, @csc4, @ctec
	-- WRITE SESSION TABLE
    if @cSessionId <> @pSessionId
		begin
			INSERT INTO NEW_RAN_SESSION_2019 (SessionId,
									 MCC,
									 MNC,
									 LAC,
									 BCCH,
									 CGI,
									 CID,
									 BSIC,
									 sc1,
									 sc2,
									 sc3,
									 sc4,
									 PCI,
									 LAC_CID_BCCH,
									 Disconnect_CGI,
									 Disconnect_LAC_CID_BCCH )
			SELECT @pSessionId,
				   substring(@rMCC ,0,len(@rMCC )),
				   substring(@rMNC ,0,len(@rMNC )),
				   substring(@rLAC ,0,len(@rLAC )),
				   substring(@rBCCH,0,len(@rBCCH)),
				   substring(@rCGI ,0,len(@rCGI )),
				   substring(@rCID ,0,len(@rCID )),
				   substring(@rBSIC,0,len(@rBSIC)),
				   substring(@rsc1 ,0,len(@rsc1 )),
				   substring(@rsc2 ,0,len(@rsc2 )),
				   substring(@rsc3 ,0,len(@rsc3 )),
				   substring(@rsc4 ,0,len(@rsc4 )),
				   substring(@rPCI ,0,len(@rPCI )),
				   substring(@rtec ,0,len(@rtec )),
				   substring(@pCGI ,0,len(@pCGI )),
				   '['+@ptec + ',' + @pLAC + ',' + @pCID +  + ',' + @pBCCH  + ']'

			IF @pTestId > 0
				BEGIN
					INSERT INTO NEW_RAN_TEST_2019 (SessionId,
												   TestId,
												   MCC,
												   MNC,
												   LAC,
												   BCCH,
												   CGI,
												   CID,
												   BSIC,
												   sc1,
												   sc2,
												   sc3,
												   sc4,
												   PCI,
												   LAC_CID_BCCH)
					SELECT @pSessionId,
						   @pTestId,
						   substring(@tMCC ,0,len(@tMCC )),
						   substring(@tMNC ,0,len(@tMNC )),
						   substring(@tLAC ,0,len(@tLAC )),
						   substring(@tBCCH,0,len(@tBCCH)),
						   substring(@tCGI ,0,len(@tCGI )),
						   substring(@tCID ,0,len(@tCID )),
						   substring(@tBSIC,0,len(@tBSIC)),
						   substring(@tsc1 ,0,len(@tsc1 )),
						   substring(@tsc2 ,0,len(@tsc2 )),
						   substring(@tsc3 ,0,len(@tsc3 )),
						   substring(@tsc4 ,0,len(@tsc4 )),
						   substring(@tPCI ,0,len(@tPCI )),
						   substring(@ttec ,0,len(@ttec ))
				END
			Set @cMCC = ''
			Set @pMCC = ''
			Set @rMCC = ''
			Set @tMCC = ''
			Set @cMNC = ''
			Set @pMNC = ''
			Set @rMNC = ''
			Set @tMNC = ''
			Set @cLAC = ''
			Set @pLAC = ''
			Set @rLAC = ''
			Set @tLAC = ''
			Set @cCGI = ''
			Set @pCGI = ''
			Set @rCGI = ''
			Set @tCGI = ''
			Set @cPCI = ''
			Set @pPCI = ''
			Set @rPCI = ''
			Set @tPCI = ''
			Set @cCID = ''
			Set @pCID = ''
			Set @rCID = ''
			Set @tCID = ''
			Set @cBCCH = ''
			Set @pBCCH = ''
			Set @rBCCH = ''
			Set @tBCCH = ''
			Set @cBSIC = ''
			Set @pBSIC = ''
			Set @rBSIC = ''
			Set @tBSIC = ''
			Set @csc1 = ''
			Set @psc1 = ''
			Set @rsc1 = ''
			Set @tsc1 = ''
			Set @csc2 = ''
			Set @psc2 = ''
			Set @rsc2 = ''
			Set @tsc2 = ''
			Set @csc3 = ''
			Set @psc3 = ''
			Set @rsc3 = ''
			Set @tsc3 = ''
			Set @csc4 = ''
			Set @psc4 = ''
			Set @rsc4 = ''
			Set @tsc4 = ''
			Set @ctec = ''
			Set @ptec = ''
			Set @rtec = ''
			Set @ttec = ''
			Set @pSessionId=@cSessionId
			Set @pTestId=@cTestId
		end

	if @cTestId <> @pTestId
		begin
			IF @pTestId > 0
				BEGIN
					INSERT INTO NEW_RAN_TEST_2019 (SessionId,
												   TestId,
												   MCC,
												   MNC,
												   LAC,
												   BCCH,
												   CGI,
												   CID,
												   BSIC,
												   sc1,
												   sc2,
												   sc3,
												   sc4,
												   PCI,
												   LAC_CID_BCCH)
					SELECT @pSessionId,
						   @pTestId,
						   substring(@tMCC ,0,len(@tMCC )),
						   substring(@tMNC ,0,len(@tMNC )),
						   substring(@tLAC ,0,len(@tLAC )),
						   substring(@tBCCH,0,len(@tBCCH)),
						   substring(@tCGI ,0,len(@tCGI )),
						   substring(@tCID ,0,len(@tCID )),
						   substring(@tBSIC,0,len(@tBSIC)),
						   substring(@tsc1 ,0,len(@tsc1 )),
						   substring(@tsc2 ,0,len(@tsc2 )),
						   substring(@tsc3 ,0,len(@tsc3 )),
						   substring(@tsc4 ,0,len(@tsc4 )),
						   substring(@tPCI ,0,len(@tPCI )),
						   substring(@ttec ,0,len(@ttec ))
				END
			Set @tMCC = CASE WHEN @pMCC  <> '' and @pMCC  is not null then '[' + @pMCC  + '],' ELSE '' END
			Set @tMNC = CASE WHEN @pMNC  <> '' and @pMNC  is not null then '[' + @pMNC  + '],' ELSE '' END
			Set @tLAC = CASE WHEN @pLAC  <> '' and @pLAC  is not null then '[' + @pLAC  + '],' ELSE '' END
			Set @tCGI = CASE WHEN @pCGI  <> '' and @pCGI  is not null then '[' + @pCGI  + '],' ELSE '' END
			Set @tPCI = CASE WHEN @pPCI  <> '' and @pPCI  is not null then '[' + @pPCI  + '],' ELSE '' END
			Set @tCID = CASE WHEN @pCID  <> '' and @pCID  is not null then '[' + @pCID  + '],' ELSE '' END
			Set @tBCCH =CASE WHEN @pBCCH <> '' and @pBCCH is not null then '[' + @pBCCH + '],' ELSE '' END
			Set @tBSIC =CASE WHEN @pBSIC <> '' and @pBSIC is not null then '[' + @pBSIC + '],' ELSE '' END
			Set @tsc1 = CASE WHEN @psc1  <> '' and @psc1  is not null then '[' + @psc1  + '],' ELSE '' END
			Set @tsc2 = CASE WHEN @psc2  <> '' and @psc2  is not null then '[' + @psc2  + '],' ELSE '' END
			Set @tsc3 = CASE WHEN @psc3  <> '' and @psc3  is not null then '[' + @psc3  + '],' ELSE '' END
			Set @tsc4 = CASE WHEN @psc4  <> '' and @psc4  is not null then '[' + @psc4  + '],' ELSE '' END
			Set @ttec = CASE WHEN @ptec  <> '' and @ptec  is not null then '[' + @ptec + ',' + @pLAC + ',' + @pCID +  + ',' + @pBCCH  + '],' ELSE '' END
			Set @pTestId = @cTestId
		end
	-- CALCULATE MCC
    if @cMCC<>@pMCC and @cMCC <> '' and @cMCC is not null
		begin
			set @pMCC=@cMCC
			Set @rMCC = @rMCC + '['+@cMCC +'],'
			Set @tMCC = @tMCC + '['+@cMCC +'],'
		end
	-- CALCULATE MNC
    if @cMNC<>@pMNC and @cMNC <> '' and @cMNC is not null
		begin
			set @pMNC=@cMNC
			Set @rMNC = @rMNC + '['+@cMNC +'],'
			Set @tMNC = @tMNC + '['+@cMNC +'],'
		end
	-- CALCULATE LAC
    if @cLAC <> @pLAC and @cLAC <> '' and @cLAC is not null
		begin
			set @pLAC = @cLAC
			Set @rLAC = @rLAC + '['+@cLAC +'],'
			Set @tLAC = @tLAC + '['+@cLAC +'],'
		end
	-- CALCULATE CGI
    if @cCGI<>@pCGI and @cCGI <> '' and @cCGI is not null
		begin
			set @pCGI=@cCGI
			Set @rCGI = @rCGI + '['+@cCGI +'],'
			Set @tCGI = @tCGI + '['+@cCGI +'],'
		end
	-- CALCULATE PCI
    if @cPCI<>@pPCI and @cPCI <> '' and @cPCI is not null
		begin
			set @pPCI=@cPCI
			Set @rPCI = @rPCI + '['+@cPCI +'],'
			Set @tPCI = @tPCI + '['+@cPCI +'],'
		end
	-- CALCULATE CID
    if @cCID<>@pCID and @cCID <> '' and @cCID is not null
		begin
			set @pCID=@cCID
			Set @rCID = @rCID + '['+@cCID +'], '
			Set @tCID = @tCID + '['+@cCID +'], '
			set @ptec=@ctec
			Set @rtec = @rtec + '['+@ctec + ',' + @cLAC + ',' + @cCID +  + ',' + @cBCCH  + '],'
			Set @ttec = @ttec + '['+@ctec + ',' + @cLAC + ',' + @cCID +  + ',' + @cBCCH  + '],'
		end
	-- CALCULATE BCCH
    if @cBCCH<>@pBCCH and @cBCCH <> '' and @cBCCH is not null
		begin
			set @pBCCH=@cBCCH
			Set @rBCCH = @rBCCH + '['+@cBCCH +'], '
			Set @tBCCH = @tBCCH + '['+@cBCCH +'], '
		end
	-- CALCULATE BSIC
    if @cBSIC<>@pBSIC and @cBSIC <> '' and @cBSIC is not null
		begin
			set @pBSIC=@cBSIC
			Set @rBSIC = @rBSIC + '['+@cBSIC +'], '
			Set @tBSIC = @tBSIC + '['+@cBSIC +'], '
		end
	-- CALCULATE sc1
    if @csc1<>@psc1 and @csc1 <> '' and @csc1 is not null
		begin
			set @psc1=@csc1
			Set @rsc1 = @rsc1 + '['+@csc1 +'], '
			Set @tsc1 = @tsc1 + '['+@csc1 +'], '
		end
	-- CALCULATE sc2
    if @csc2<>@psc2 and @csc2 <> '' and @csc2 is not null
		begin
			set @psc2=@csc2
			Set @rsc2 = @rsc2 + '['+@csc2 +'], '
			Set @tsc2 = @tsc2 + '['+@csc2 +'], '
		end
	-- CALCULATE sc3
    if @csc3<>@psc3 and @csc3 <> '' and @csc3 is not null
		begin
			set @psc3=@csc3
			Set @rsc3 = @rsc3 + '['+@csc3 +'], '
			Set @tsc3 = @tsc3 + '['+@csc3 +'], '
		end
	-- CALCULATE sc4
    if @csc4<>@psc4 and @csc4 <> '' and @csc4 is not null
		begin
			set @psc4=@csc4
			Set @rsc4 = @rsc4 + '['+@csc4 +'], '
			Set @tsc4 = @tsc4 + '['+@csc4 +'], '
		end
	-- CALCULATE tec
    if (@ctec<>@ptec and @ctec <> '' and @ctec is not null)
		begin
			set @ptec=@ctec
			Set @rtec = @rtec + '['+@ctec + ',' + @cLAC + ',' + @cCID +  + ',' + @cBCCH  + '],'
			Set @ttec = @ttec + '['+@ctec + ',' + @cLAC + ',' + @cCID +  + ',' + @cBCCH  + '],'
		end
	if @@fetch_status <> 0
		begin
			break
		end
end
set @exec = datediff(ms,@start,cast(GETDATE() as datetime2(3)))
  
CLOSE TN_cursor
DEALLOCATE TN_cursor

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #TA_GSM
-- Table: #TA_LTE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE 2G...')
	IF OBJECT_ID ('tempdb..#TA_GSM' ) IS NOT NULL DROP TABLE #TA_GSM
	SELECT * 
	INTO #TA_GSM
	FROM	(
			SELECT  SessionId,
					TestId,
					avg(ta) as AvgTA, 
					max(ta) as MaxTA

			FROM MsgGSMReport	AS gsm
			GROUP BY SessionId,TestId
			) as T1

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE 4G...')
	IF OBJECT_ID ('tempdb..#TA_LTE' ) IS NOT NULL DROP TABLE #TA_LTE
	SELECT * 
	INTO #TA_LTE
	FROM (select ti.SessionId,
				 ti.TestId,
				 avg(TimingAdvance) as AvgTA, 
				 max(TimingAdvance) as MaxTA
				 FROM			TestInfo		AS ti
			LEFT OUTER JOIN	
				(
					select 
						SessionId,
						TestId,
						case when (TimingAdvance between 0 and 1282) then TimingAdvance else null end as TimingAdvance
					from LTEFrameTiming
				)lte ON ti.TestId = lte.TestId and ti.SessionId = lte.SessionId

				GROUP BY ti.SessionId,ti.TestId
				) AS T1

UPDATE NEW_RAN_TEST_2019
SET AvgTA2G = AvgTA, 
    MaxTA2G = MaxTA 
FROM NEW_RAN_TEST_2019 a
LEFT OUTER JOIN #TA_GSM b on a.SessionId = b.SessionId and a.TestId = b.TestId

UPDATE NEW_RAN_TEST_2019
SET AvgDLTA4G = AvgTA, 
    MaxDLTA4G = MaxTA 
FROM NEW_RAN_TEST_2019 a
LEFT OUTER JOIN #TA_LTE b on a.SessionId = b.SessionId and a.TestId = b.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE 2G...')
	IF OBJECT_ID ('tempdb..#STA_GSM' ) IS NOT NULL DROP TABLE #STA_GSM
	SELECT * 
	INTO #STA_GSM
	FROM	(
			SELECT  SessionId,
					avg(ta) as AvgTA, 
					max(ta) as MaxTA

			FROM MsgGSMReport	AS gsm
			GROUP BY SessionId
			) as T1

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE 4G...')
	IF OBJECT_ID ('tempdb..#STA_LTE' ) IS NOT NULL DROP TABLE #STA_LTE
	SELECT * 
	INTO #STA_LTE
	FROM (select ti.SessionId,
				 avg(TimingAdvance) as AvgTA, 
				 max(TimingAdvance) as MaxTA
				 FROM Sessions AS ti
			LEFT OUTER JOIN	
				(
					select 
						SessionId,
						case when (TimingAdvance between 0 and 1282) then TimingAdvance else null end as TimingAdvance
					from LTEFrameTiming
				)lte ON ti.SessionId = lte.SessionId

				GROUP BY ti.SessionId
				) AS T1

	UPDATE NEW_RAN_SESSION_2019
	SET AvgTA2G = AvgTA, 
		MaxTA2G = MaxTA 
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #STA_GSM b on a.SessionId = b.SessionId

	UPDATE NEW_RAN_SESSION_2019
	SET AvgDLTA4G = AvgTA, 
		MaxDLTA4G = MaxTA 
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #STA_LTE b on a.SessionId = b.SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #CQI_UMTS
-- Table: #CQI_LTE
-- Table: #AckNack_UMTS
-- Table: #AckNack_LTE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING ACK/NACK and CQI in 3G...')
	IF OBJECT_ID ('tempdb..#CQI_UMTS' ) IS NOT NULL DROP TABLE #CQI_UMTS
	select SessionId,TestId,
			count(cqi.sumCQI)												as 'CQI_Samples',
			sum(cqi.sumCQI)/nullif(sum(cqi.numCQI),0)						as 'CQI_HSDPA',
			min((cqi.sumCQI)/nullif((cqi.numCQI),0)) 						as 'CQI_HSDPA_Min',
			max((cqi.sumCQI)/nullif((cqi.numCQI),0))						as 'CQI_HSDPA_Max',
			round(stdev((cqi.sumCQI)/nullif((cqi.numCQI),0)),1) 			as 'CQI_HSDPA_StDev',
			sum(numACK)														as 'ACK_HSDPA_Count',
			sum(numNACK)													as 'NACK_HSDPA_Count',
			(1.0*sum(numACK)) /nullif(1.0*(sum(numACK)+sum(numNACK)),0)		as 'ACK_HSDPA_Ratio',
			(1.0*sum(numNACK))/nullif(1.0*(sum(numACK)+sum(numNACK)),0)		as 'NACK_HSDPA_Ratio'
	into #CQI_UMTS
	from HSDPACQI cqi
	group by SessionId,TestId

	IF OBJECT_ID ('tempdb..#SCQI_UMTS' ) IS NOT NULL DROP TABLE #SCQI_UMTS
	select SessionId, 
			count(cqi.sumCQI)												as 'CQI_Samples',
			sum(cqi.sumCQI)/nullif(sum(cqi.numCQI),0)						as 'CQI_HSDPA',
			min((cqi.sumCQI)/nullif((cqi.numCQI),0)) 						as 'CQI_HSDPA_Min',
			max((cqi.sumCQI)/nullif((cqi.numCQI),0))						as 'CQI_HSDPA_Max',
			round(stdev((cqi.sumCQI)/nullif((cqi.numCQI),0)),1) 			as 'CQI_HSDPA_StDev',
			sum(numACK)														as 'ACK_HSDPA_Count',
			sum(numNACK)													as 'NACK_HSDPA_Count',
			(1.0*sum(numACK)) /nullif(1.0*(sum(numACK)+sum(numNACK)),0)		as 'ACK_HSDPA_Ratio',
			(1.0*sum(numNACK))/nullif(1.0*(sum(numACK)+sum(numNACK)),0)		as 'NACK_HSDPA_Ratio'
	into #SCQI_UMTS
	from HSDPACQI cqi
	group by SessionId

	UPDATE NEW_RAN_TEST_2019
	SET  CQI_HSDPA_Min	 = b.CQI_HSDPA_Min,
		 CQI_HSDPA   	 = b.CQI_HSDPA,
		 CQI_HSDPA_Max	 = b.CQI_HSDPA_Max,
		 CQI_HSDPA_StDev = b.CQI_HSDPA_StDev,
		 ACK3G			 = b.ACK_HSDPA_Count,
		 NACK3G			 = b.NACK_HSDPA_Count,
		 ACKNACK3G_Total = b.ACK_HSDPA_Count + b.NACK_HSDPA_Count
	FROM NEW_RAN_TEST_2019 a
	LEFT OUTER JOIN #CQI_UMTS b on a.SessionId = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RAN_SESSION_2019
	SET  CQI_HSDPA_Min	 = b.CQI_HSDPA_Min,
		 CQI_HSDPA   	 = b.CQI_HSDPA,
		 CQI_HSDPA_Max	 = b.CQI_HSDPA_Max,
		 CQI_HSDPA_StDev = b.CQI_HSDPA_StDev,
		 ACK3G			 = b.ACK_HSDPA_Count,
		 NACK3G			 = b.NACK_HSDPA_Count,
		 ACKNACK3G_Total = b.ACK_HSDPA_Count + b.NACK_HSDPA_Count
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #SCQI_UMTS b on a.SessionId = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING ACK/NACK in 4G...')
	IF OBJECT_ID ('tempdb..#AckNack_LTE' ) IS NOT NULL DROP TABLE #AckNack_LTE
	SELECT  ti.SessionId,
			ti.TestId, 
			CASE WHEN SUM(dl.NumAck)	is null THEN 0 ELSE SUM(dl.NumAck)	 END	as DL_ACK, 
			CASE WHEN SUM(dl.NumNack)	is null THEN 0 ELSE SUM(dl.NumNack)  END 	as DL_NACK,
			CASE WHEN SUM(ul.NumAck)	is null THEN 0 ELSE SUM(ul.NumAck)	 END	as UL_ACK, 
			CASE WHEN SUM(ul.NumNack)	is null THEN 0 ELSE SUM(ul.NumNack)  END 	as UL_NACK
		into #AckNack_LTE
		FROM			TestInfo AS ti
		LEFT OUTER JOIN LTEDLAckNack AS dl ON ti.TestId = dl.TestId	and ti.SessionId = dl.SessionId
		LEFT OUTER JOIN LTEULAckNack AS ul ON ti.TestId = ul.TestId	and ti.SessionId = ul.SessionId
		GROUP BY ti.SessionId,ti.TestId

	IF OBJECT_ID ('tempdb..#SAckNack_LTE' ) IS NOT NULL DROP TABLE #SAckNack_LTE
	SELECT  ti.SessionId,
			CASE WHEN SUM(dl.NumAck)	is null THEN 0 ELSE SUM(dl.NumAck)	 END	as DL_ACK, 
			CASE WHEN SUM(dl.NumNack)	is null THEN 0 ELSE SUM(dl.NumNack)  END 	as DL_NACK,
			CASE WHEN SUM(ul.NumAck)	is null THEN 0 ELSE SUM(ul.NumAck)	 END	as UL_ACK, 
			CASE WHEN SUM(ul.NumNack)	is null THEN 0 ELSE SUM(ul.NumNack)  END 	as UL_NACK
		into #SAckNack_LTE
		FROM			Sessions AS ti
		LEFT OUTER JOIN LTEDLAckNack AS dl ON ti.SessionId = dl.SessionId
		LEFT OUTER JOIN LTEULAckNack AS ul ON ti.SessionId = ul.SessionId
		GROUP BY ti.SessionId

	UPDATE NEW_RAN_TEST_2019
	SET  ACK4G	             = b.DL_ACK + UL_ACK,
		 NACK4G   	         = b.DL_NACK + UL_NACK,
		 ACKNACK4G_Total	 = b.DL_ACK + UL_ACK + b.DL_NACK + UL_NACK
	FROM NEW_RAN_TEST_2019 a
	LEFT OUTER JOIN #AckNack_LTE b on a.SessionId = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RAN_SESSION_2019
	SET  ACK4G	             = b.DL_ACK + UL_ACK,
		 NACK4G   	         = b.DL_NACK + UL_NACK,
		 ACKNACK4G_Total	 = b.DL_ACK + UL_ACK + b.DL_NACK + UL_NACK
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #SAckNack_LTE b on a.SessionId = b.SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING CQI in 4G...')
	IF OBJECT_ID ('tempdb..#CQI_LTE' ) IS NOT NULL DROP TABLE #CQI_LTE
	SELECT  SessionId,
			TestId,
			convert(real,round(Avg(CQI0),0))	as 'CQI_LTE_Avg',
			convert(real,round(Min(CQI0),0))	as 'CQI_LTE_Min',
			convert(real,round(Max(CQI0),0))	as 'CQI_LTE_Max',
			convert(real,round(Stdev(CQI0),1))	as 'CQI_LTE_StDev' 
		into #CQI_LTE
		FROM LTEPUCCHCQI
		GROUP BY SessionId,TestId

	IF OBJECT_ID ('tempdb..#SCQI_LTE' ) IS NOT NULL DROP TABLE #SCQI_LTE
	SELECT  SessionId,
			convert(real,round(Avg(CQI0),0))	as 'CQI_LTE_Avg',
			convert(real,round(Min(CQI0),0))	as 'CQI_LTE_Min',
			convert(real,round(Max(CQI0),0))	as 'CQI_LTE_Max',
			convert(real,round(Stdev(CQI0),1))	as 'CQI_LTE_StDev' 
		into #SCQI_LTE
		FROM LTEPUCCHCQI
		GROUP BY SessionId

	UPDATE NEW_RAN_TEST_2019
	SET CQI_LTE_Min	  = b.CQI_LTE_Min,
		CQI_LTE_Avg	  = b.CQI_LTE_Avg,
		CQI_LTE_Max	  = b.CQI_LTE_Max,
		CQI_LTE_StDev = b.CQI_LTE_StDev
	FROM NEW_RAN_TEST_2019 a
	LEFT OUTER JOIN #CQI_LTE b on a.SessionId = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RAN_SESSION_2019
	SET CQI_LTE_Min	  = b.CQI_LTE_Min,
		CQI_LTE_Avg	  = b.CQI_LTE_Avg,
		CQI_LTE_Max	  = b.CQI_LTE_Max,
		CQI_LTE_StDev = b.CQI_LTE_StDev
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #CQI_LTE b on a.SessionId = b.SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #BLER_UMTS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING BLER FOR UMTS...')
	IF OBJECT_ID ('tempdb..#BLER_UMTS' ) IS NOT NULL DROP TABLE #BLER_UMTS
	select 
		SessionId,TestId
		,count(convert(float,crcerror)*100.0/nullif(convert(float,crcrec),0))	as 'BLER3GSamples'
		,sum(crcError)*100.0/sum(nullif((crcRec),0))							as 'BLER3G'
		,stdev(((crcError*100.0)/(nullif((crcRec),0))))							as 'StDevBLER3G'
	into #BLER_UMTS
	from WCDMABLER
	group by sessionid,TestId

	IF OBJECT_ID ('tempdb..#SBLER_UMTS' ) IS NOT NULL DROP TABLE #SBLER_UMTS
	select 
		sessionid
		,count(convert(float,crcerror)*100.0/nullif(convert(float,crcrec),0))	as 'BLER3GSamples'
		,sum(crcError)*100.0/sum(nullif((crcRec),0))							as 'BLER3G'
		,stdev(((crcError*100.0)/(nullif((crcRec),0))))							as 'StDevBLER3G'
	into #SBLER_UMTS
	from WCDMABLER
	group by sessionid

	UPDATE NEW_RAN_TEST_2019
	SET BLER3G	      = b.BLER3G,
		BLER3GSamples = b.BLER3GSamples,
		StDevBLER3G	  = b.StDevBLER3G
	FROM NEW_RAN_TEST_2019 a
	LEFT OUTER JOIN #BLER_UMTS b on a.SessionId = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RAN_SESSION_2019
	SET BLER3G	      = b.BLER3G,
		BLER3GSamples = b.BLER3GSamples,
		StDevBLER3G	  = b.StDevBLER3G
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #SBLER_UMTS b on a.SessionId = b.SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #LTE_DL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING DL LTE VARIABLES...')
	IF OBJECT_ID ('tempdb..#LTE_DL' ) IS NOT NULL DROP TABLE #LTE_DL
	select SessionId,TestId
		  ,CAST(MIN(CAST(NumCarriers as float)) as decimal(10,2))			AS MinDLNumCarriers
		  ,CAST(AVG(CAST(NumCarriers as float)) as decimal(10,2))			AS AvgDLNumCarriers
		  ,CAST(MAX(CAST(NumCarriers as float)) as decimal(10,2))			AS MaxDLNumCarriers
		  ,MIN(CAST(MinRBsFrame as float))									AS MinRB
		  ,AVG(CAST(AvgRBsFrame as float))									AS AvgRB
		  ,MAX(CAST(MaxRBsFrame as float))									AS MaxRB
		  -- Modulation DL
		  ,MIN(AvgMCS)														AS MinMCS
		  ,AVG(AvgMCS)														AS AvgMCS
		  ,MAX(AvgMCS)														AS MaxMCS
		  ,SUM(NumQPSK)														AS CountNumQPSK
		  ,SUM(Num16QAM)													AS CountNum16QAM
		  ,SUM(Num64QAM)													AS CountNum64QAM
		  ,SUM(Num256QAM)													AS CountNum256QAM
		  ,SUM(NumQPSK+Num16QAM+Num64QAM+Num256QAM)							AS CountModulation
		  -- PDSCH THROUGHPUT
		  ,MIN(ScheduledPDSCHThroughput)									AS MinScheduledPDSCHThroughput
		  ,AVG(ScheduledPDSCHThroughput)									AS AvgScheduledPDSCHThroughput
		  ,MAX(ScheduledPDSCHThroughput)									AS MaxScheduledPDSCHThroughput
		  ,MIN(NetPDSCHThroughput)											AS MinNetPDSCHThroughput
		  ,AVG(NetPDSCHThroughput)											AS AvgNetPDSCHThroughput
		  ,MAX(NetPDSCHThroughput)											AS MaxNetPDSCHThroughput
		  ,SUM(BytesTransferred)											AS PDSCHBytesTransfered
		  ,MIN(BLER)														AS MinBLER
		  ,AVG(BLER)														AS AvgBLER
		  ,MAX(BLER)														AS MaxBLER
		  -- Transfer Blocks (unavailable in Exynos)
		  ,CAST(MIN(MinTBSize) AS decimal(10,2))							AS MinTBSize
		  ,CAST(AVG(AvgTBSize) AS decimal(10,2))							AS AvgTBSize
		  ,CAST(MAX(MaxTBSize) AS decimal(10,2))							AS MaxTBSize
		  ,CAST(MIN(TBRate)	AS decimal(10,2))								AS MinTBRate
		  ,CAST(AVG(TBRate)	AS decimal(10,2))								AS AvgTBRate
		  ,CAST(MAX(TBRate)	AS decimal(10,2))								AS MaxTBRate
	into #LTE_DL
	from LTEPDSCHStatisticsInfo							
	group by SessionId,TestId

	IF OBJECT_ID ('tempdb..#SLTE_DL' ) IS NOT NULL DROP TABLE #SLTE_DL
	select SessionId
		  ,CAST(MIN(CAST(NumCarriers as float)) as decimal(10,2))			AS MinDLNumCarriers
		  ,CAST(AVG(CAST(NumCarriers as float)) as decimal(10,2))			AS AvgDLNumCarriers
		  ,CAST(MAX(CAST(NumCarriers as float)) as decimal(10,2))			AS MaxDLNumCarriers
		  ,MIN(CAST(MinRBsFrame as float))									AS MinRB
		  ,AVG(CAST(AvgRBsFrame as float))									AS AvgRB
		  ,MAX(CAST(MaxRBsFrame as float))									AS MaxRB
		  -- Modulation DL
		  ,MIN(AvgMCS)														AS MinMCS
		  ,AVG(AvgMCS)														AS AvgMCS
		  ,MAX(AvgMCS)														AS MaxMCS
		  ,SUM(NumQPSK)														AS CountNumQPSK
		  ,SUM(Num16QAM)													AS CountNum16QAM
		  ,SUM(Num64QAM)													AS CountNum64QAM
		  ,SUM(Num256QAM)													AS CountNum256QAM
		  ,SUM(NumQPSK+Num16QAM+Num64QAM+Num256QAM)							AS CountModulation
		  -- PDSCH THROUGHPUT
		  ,MIN(ScheduledPDSCHThroughput)									AS MinScheduledPDSCHThroughput
		  ,AVG(ScheduledPDSCHThroughput)									AS AvgScheduledPDSCHThroughput
		  ,MAX(ScheduledPDSCHThroughput)									AS MaxScheduledPDSCHThroughput
		  ,MIN(NetPDSCHThroughput)											AS MinNetPDSCHThroughput
		  ,AVG(NetPDSCHThroughput)											AS AvgNetPDSCHThroughput
		  ,MAX(NetPDSCHThroughput)											AS MaxNetPDSCHThroughput
		  ,SUM(BytesTransferred)											AS PDSCHBytesTransfered
		  ,MIN(BLER)														AS MinBLER
		  ,AVG(BLER)														AS AvgBLER
		  ,MAX(BLER)														AS MaxBLER
		  -- Transfer Blocks (unavailable in Exynos)
		  ,CAST(MIN(MinTBSize) AS decimal(10,2))							AS MinTBSize
		  ,CAST(AVG(AvgTBSize) AS decimal(10,2))							AS AvgTBSize
		  ,CAST(MAX(MaxTBSize) AS decimal(10,2))							AS MaxTBSize
		  ,CAST(MIN(TBRate)	AS decimal(10,2))								AS MinTBRate
		  ,CAST(AVG(TBRate)	AS decimal(10,2))								AS AvgTBRate
		  ,CAST(MAX(TBRate)	AS decimal(10,2))								AS MaxTBRate
	into #SLTE_DL
	from LTEPDSCHStatisticsInfo							
	group by SessionId

	UPDATE NEW_RAN_TEST_2019
	SET LTE_DL_MinDLNumCarriers				= b.MinDLNumCarriers,			
		LTE_DL_AvgDLNumCarriers				= b.AvgDLNumCarriers,			
		LTE_DL_MaxDLNumCarriers				= b.MaxDLNumCarriers,			
		LTE_DL_MinRB						= b.MinRB,				
		LTE_DL_AvgRB						= b.AvgRB,							
		LTE_DL_MaxRB						= b.MaxRB,							
		LTE_DL_MinMCS					    = b.MinMCS,						
		LTE_DL_AvgMCS					    = b.AvgMCS,						
		LTE_DL_MaxMCS					    = b.MaxMCS,						
		LTE_DL_CountNumQPSK				    = b.CountNumQPSK,				
		LTE_DL_CountNum16QAM				= b.CountNum16QAM,					
		LTE_DL_CountNum64QAM				= b.CountNum64QAM,					
		LTE_DL_CountNum256QAM				= b.CountNum256QAM,
		LTE_DL_CountModulation				= b.CountModulation,			
		LTE_DL_MinScheduledPDSCHThroughput	= b.MinScheduledPDSCHThroughput,	
		LTE_DL_AvgScheduledPDSCHThroughput	= b.AvgScheduledPDSCHThroughput,	
		LTE_DL_MaxScheduledPDSCHThroughput	= b.MaxScheduledPDSCHThroughput,	
		LTE_DL_MinNetPDSCHThroughput		= b.MinNetPDSCHThroughput,			
		LTE_DL_AvgNetPDSCHThroughput		= b.AvgNetPDSCHThroughput,			
		LTE_DL_MaxNetPDSCHThroughput		= b.MaxNetPDSCHThroughput,			
		LTE_DL_PDSCHBytesTransfered		    = b.PDSCHBytesTransfered,			
		LTE_DL_MinBLER						= b.MinBLER,						
		LTE_DL_AvgBLER						= b.AvgBLER,						
		LTE_DL_MaxBLER						= b.MaxBLER,						
		LTE_DL_MinTBSize					= b.MinTBSize,						
		LTE_DL_AvgTBSize					= b.AvgTBSize,						
		LTE_DL_MaxTBSize					= b.MaxTBSize,						
		LTE_DL_MinTBRate					= b.MinTBRate,						
		LTE_DL_AvgTBRate					= b.AvgTBRate,						
		LTE_DL_MaxTBRate					= b.MaxTBRate						
	FROM NEW_RAN_TEST_2019 a
	LEFT OUTER JOIN #LTE_DL b on a.SessionId = b.SessionId and a.TestId = b.TestId

	UPDATE NEW_RAN_SESSION_2019
	SET LTE_DL_MinDLNumCarriers				= b.MinDLNumCarriers,			
		LTE_DL_AvgDLNumCarriers				= b.AvgDLNumCarriers,			
		LTE_DL_MaxDLNumCarriers				= b.MaxDLNumCarriers,			
		LTE_DL_MinRB						= b.MinRB,				
		LTE_DL_AvgRB						= b.AvgRB,							
		LTE_DL_MaxRB						= b.MaxRB,							
		LTE_DL_MinMCS					    = b.MinMCS,						
		LTE_DL_AvgMCS					    = b.AvgMCS,						
		LTE_DL_MaxMCS					    = b.MaxMCS,						
		LTE_DL_CountNumQPSK				    = b.CountNumQPSK,				
		LTE_DL_CountNum16QAM				= b.CountNum16QAM,					
		LTE_DL_CountNum64QAM				= b.CountNum64QAM,					
		LTE_DL_CountNum256QAM				= b.CountNum256QAM,
		LTE_DL_CountModulation				= b.CountModulation,			
		LTE_DL_MinScheduledPDSCHThroughput	= b.MinScheduledPDSCHThroughput,	
		LTE_DL_AvgScheduledPDSCHThroughput	= b.AvgScheduledPDSCHThroughput,	
		LTE_DL_MaxScheduledPDSCHThroughput	= b.MaxScheduledPDSCHThroughput,	
		LTE_DL_MinNetPDSCHThroughput		= b.MinNetPDSCHThroughput,			
		LTE_DL_AvgNetPDSCHThroughput		= b.AvgNetPDSCHThroughput,			
		LTE_DL_MaxNetPDSCHThroughput		= b.MaxNetPDSCHThroughput,			
		LTE_DL_PDSCHBytesTransfered		    = b.PDSCHBytesTransfered,			
		LTE_DL_MinBLER						= b.MinBLER,						
		LTE_DL_AvgBLER						= b.AvgBLER,						
		LTE_DL_MaxBLER						= b.MaxBLER,						
		LTE_DL_MinTBSize					= b.MinTBSize,						
		LTE_DL_AvgTBSize					= b.AvgTBSize,						
		LTE_DL_MaxTBSize					= b.MaxTBSize,						
		LTE_DL_MinTBRate					= b.MinTBRate,						
		LTE_DL_AvgTBRate					= b.AvgTBRate,						
		LTE_DL_MaxTBRate					= b.MaxTBRate
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #SLTE_DL b on a.SessionId = b.SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #LTE_UL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING UL LTE VARIABLES...')
	IF OBJECT_ID ('tempdb..#LTE_UL' ) IS NOT NULL DROP TABLE #LTE_UL
	select SessionId,TestId
		  ,CAST(MIN(CAST(NumCarriers as float)) as decimal(10,2))			AS MinULNumCarriers
		  ,CAST(AVG(CAST(NumCarriers as float)) as decimal(10,2))			AS AvgULNumCarriers
		  ,CAST(MAX(CAST(NumCarriers as float)) as decimal(10,2))			AS MaxULNumCarriers
		  -- UL MODULATION
		  ,SUM(NumBPSK)														AS CountNumBPSK
		  ,SUM(NumQPSK)														AS CountNumQPSK
		  ,SUM(Num16QAM)													AS CountNum16QAM
		  ,SUM(Num64QAM) 													AS CountNum64QAM
		  ,SUM(NumBPSK+NumQPSK+Num16QAM+Num64QAM)							AS CountModulation
		  -- PUSCH THROUGHPUT
		  ,CAST(MIN(ScheduledPUSCHThroughput) as decimal(10,2))				AS MinScheduledPUSCHThroughput
		  ,CAST(AVG(ScheduledPUSCHThroughput) as decimal(10,2))				AS AvgScheduledPUSCHThroughput
		  ,CAST(MAX(ScheduledPUSCHThroughput) as decimal(10,2))				AS MaxScheduledPUSCHThroughput
		  ,CAST(MIN(NetPUSCHThroughput) as decimal(10,2))					AS MinNetPUSCHThroughput
		  ,CAST(AVG(NetPUSCHThroughput) as decimal(10,2))					AS AvgNetPUSCHThroughput
		  ,CAST(MAX(NetPUSCHThroughput) as decimal(10,2))					AS MaxNetPUSCHThroughput
		  ,SUM(BytesTransferred)											AS PUSCHBytesTransfered
		  -- Transfer Blocks (unavailable in Exynos)
		  ,CAST(MIN(MinTBSize) AS decimal(10,2))							AS MinTBSize
		  ,CAST(AVG(AvgTBSize) AS decimal(10,2))							AS AvgTBSize
		  ,CAST(MAX(MaxTBSize) AS decimal(10,2))							AS MaxTBSize
		  ,CAST(MIN(TBRate)	AS decimal(10,2))								AS MinTBRate
		  ,CAST(AVG(TBRate)	AS decimal(10,2))								AS AvgTBRate
		  ,CAST(MAX(TBRate)	AS decimal(10,2))								AS MaxTBRate
	into #LTE_UL
	from LTEPUSCHStatisticsInfo
	group by Sessionid,TestId
	order by SessionId,TestId

	IF OBJECT_ID ('tempdb..#SLTE_UL' ) IS NOT NULL DROP TABLE #SLTE_UL
	select SessionId
		  ,CAST(MIN(CAST(NumCarriers as float)) as decimal(10,2))			AS MinULNumCarriers
		  ,CAST(AVG(CAST(NumCarriers as float)) as decimal(10,2))			AS AvgULNumCarriers
		  ,CAST(MAX(CAST(NumCarriers as float)) as decimal(10,2))			AS MaxULNumCarriers
		  -- UL MODULATION
		  ,SUM(NumBPSK)														AS CountNumBPSK
		  ,SUM(NumQPSK)														AS CountNumQPSK
		  ,SUM(Num16QAM)													AS CountNum16QAM
		  ,SUM(Num64QAM) 													AS CountNum64QAM
		  ,SUM(NumBPSK+NumQPSK+Num16QAM+Num64QAM)							AS CountModulation
		  -- PUSCH THROUGHPUT
		  ,CAST(MIN(ScheduledPUSCHThroughput) as decimal(10,2))				AS MinScheduledPUSCHThroughput
		  ,CAST(AVG(ScheduledPUSCHThroughput) as decimal(10,2))				AS AvgScheduledPUSCHThroughput
		  ,CAST(MAX(ScheduledPUSCHThroughput) as decimal(10,2))				AS MaxScheduledPUSCHThroughput
		  ,CAST(MIN(NetPUSCHThroughput) as decimal(10,2))					AS MinNetPUSCHThroughput
		  ,CAST(AVG(NetPUSCHThroughput) as decimal(10,2))					AS AvgNetPUSCHThroughput
		  ,CAST(MAX(NetPUSCHThroughput) as decimal(10,2))					AS MaxNetPUSCHThroughput
		  ,SUM(BytesTransferred)											AS PUSCHBytesTransfered
		  -- Transfer Blocks (unavailable in Exynos)
		  ,CAST(MIN(MinTBSize) AS decimal(10,2))							AS MinTBSize
		  ,CAST(AVG(AvgTBSize) AS decimal(10,2))							AS AvgTBSize
		  ,CAST(MAX(MaxTBSize) AS decimal(10,2))							AS MaxTBSize
		  ,CAST(MIN(TBRate)	AS decimal(10,2))								AS MinTBRate
		  ,CAST(AVG(TBRate)	AS decimal(10,2))								AS AvgTBRate
		  ,CAST(MAX(TBRate)	AS decimal(10,2))								AS MaxTBRate
	into #SLTE_UL
	from LTEPUSCHStatisticsInfo
	group by Sessionid
	order by SessionId

	UPDATE NEW_RAN_TEST_2019
	SET	 LTE_UL_MinULNumCarriers           		= b.MinULNumCarriers,
		 LTE_UL_AvgULNumCarriers           		= b.AvgULNumCarriers,
		 LTE_UL_MaxULNumCarriers           		= b.MaxULNumCarriers,
		 LTE_UL_CountNumBPSK              		= b.CountNumBPSK,
		 LTE_UL_CountNumQPSK              		= b.CountNumQPSK,	
		 LTE_UL_CountNum16QAM             		= b.CountNum16QAM,
		 LTE_UL_CountNum64QAM             		= b.CountNum64QAM,
		 LTE_UL_CountModulation           		= b.CountModulation,
		 LTE_UL_MinScheduledPUSCHThroughput		= b.MinScheduledPUSCHThroughput,
		 LTE_UL_AvgScheduledPUSCHThroughput		= b.AvgScheduledPUSCHThroughput,
		 LTE_UL_MaxScheduledPUSCHThroughput		= b.MaxScheduledPUSCHThroughput,	
		 LTE_UL_MinNetPUSCHThroughput      		= b.MinNetPUSCHThroughput,	
		 LTE_UL_AvgNetPUSCHThroughput      		= b.AvgNetPUSCHThroughput,
		 LTE_UL_MaxNetPUSCHThroughput      		= b.MaxNetPUSCHThroughput,
		 LTE_UL_PUSCHBytesTransfered       		= b.PUSCHBytesTransfered,
		 LTE_UL_MinTBSize                 		= b.MinTBSize,	
		 LTE_UL_AvgTBSize                 		= b.AvgTBSize,	
		 LTE_UL_MaxTBSize                 		= b.MaxTBSize,	
		 LTE_UL_MinTBRate                 		= b.MinTBRate,	
		 LTE_UL_AvgTBRate                 		= b.AvgTBRate,	
		 LTE_UL_MaxTBRate 						= b.MaxTBRate			
	FROM NEW_RAN_TEST_2019 a
	LEFT OUTER JOIN #LTE_UL b on a.SessionId = b.SessionId and a.TestId = b.TestId
	-- select * from #LTE_UL
	UPDATE NEW_RAN_SESSION_2019
	SET	 LTE_UL_MinULNumCarriers           		= b.MinULNumCarriers,
		 LTE_UL_AvgULNumCarriers           		= b.AvgULNumCarriers,
		 LTE_UL_MaxULNumCarriers           		= b.MaxULNumCarriers,
		 LTE_UL_CountNumBPSK              		= b.CountNumBPSK,
		 LTE_UL_CountNumQPSK              		= b.CountNumQPSK,	
		 LTE_UL_CountNum16QAM             		= b.CountNum16QAM,
		 LTE_UL_CountNum64QAM             		= b.CountNum64QAM,
		 LTE_UL_CountModulation           		= b.CountModulation,
		 LTE_UL_MinScheduledPUSCHThroughput		= b.MinScheduledPUSCHThroughput,
		 LTE_UL_AvgScheduledPUSCHThroughput		= b.AvgScheduledPUSCHThroughput,
		 LTE_UL_MaxScheduledPUSCHThroughput		= b.MaxScheduledPUSCHThroughput,	
		 LTE_UL_MinNetPUSCHThroughput      		= b.MinNetPUSCHThroughput,	
		 LTE_UL_AvgNetPUSCHThroughput      		= b.AvgNetPUSCHThroughput,
		 LTE_UL_MaxNetPUSCHThroughput      		= b.MaxNetPUSCHThroughput,
		 LTE_UL_PUSCHBytesTransfered       		= b.PUSCHBytesTransfered,
		 LTE_UL_MinTBSize                 		= b.MinTBSize,	
		 LTE_UL_AvgTBSize                 		= b.AvgTBSize,	
		 LTE_UL_MaxTBSize                 		= b.MaxTBSize,	
		 LTE_UL_MinTBRate                 		= b.MinTBRate,	
		 LTE_UL_AvgTBRate                 		= b.AvgTBRate,	
		 LTE_UL_MaxTBRate 						= b.MaxTBRate			
	FROM NEW_RAN_SESSION_2019 a
	LEFT OUTER JOIN #LTE_UL b on a.SessionId = b.SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE HANDOVERS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	GO
	IF EXISTS (SELECT * FROM  sysobjects WHERE  name = N'NEW_GetHandover_A') DROP FUNCTION NEW_GetHandover_A
	GO
	CREATE FUNCTION NEW_GetHandover_A(@SessionID bigint)
	RETURNS varchar(5000)
	AS
	BEGIN
      
		  DECLARE @HO as varchar(50) 
		  DECLARE @HOCount int   
		  DECLARE @Result as varchar(5000) 
		  DECLARE @HOTemp as Varchar(50)     
		  Declare @IsHO as int
         
		  set @Result	=''
		  set @HOTemp	=''
		  set @HOCount	=0
	        
		  DECLARE TN_cursor CURSOR FOR 
		  SELECT 
				case 
					when kpiid = 34050 then '2G-Handover'
					when kpiid = 34060 then '2G-ChannelModify'
					when kpiid = 34070 then '2G-IntraCellHO'
					when kpiid = 35010 then '3G-CompressMode'
					when kpiid = 35020 then '2G->3G-InterSystemHO'
					when kpiid = 35030 then '3G->2G-InterSystemHO'
					when kpiid = 35040 then '3G->2G-InterSystemHO-DuringTransfer'
					when kpiid = 35041 then '3G->2G-InterSystemHO-RAU' 				
					when kpiid = 35060 then '2G->3G-InterSystemHO-IdleReselect'
					when kpiid = 35061 then '2G->3G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35070 then '3G->2G-InterSystemHO-IdleReselect'
					when kpiid = 35071 then '3G->2G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35080 then '3G-P-TMSI Reallocation'
					when kpiid = 35100 then '3G-Handover'
					when kpiid = 35101 then '3G-CellUpdate'
					when kpiid = 35106 then '3G-InterFrequencyReselection'				
					when kpiid = 35107 then '3G-InterFrequencyHO'
					when kpiid = 35110 then '3G-HSPA-CellChange'
					when kpiid = 35111 then '3G-HSPA R99-LinkChange' 
					when kpiid = 38020 then '4G->3G-InterSystemHO-IdleReselect'
					when kpiid = 38021 then '4G->3G-RedirectionToUARFCN'
					when kpiid = 38030 then '3G->4G-InterSystemHO-IdleReselect'
					when kpiid = 38040 then '4G->3G-InterSystemHO'
					when kpiid = 38100 then '4G-Handover'
				else null end as KPIId                         
		  from
				vresultskpi kpi 
				left outer join sessions s on kpi.SessionId=s.SessionId 
				where 
					 s.SessionId=@SessionId
					 and KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100)
			   order by s.StartTime
      
		  Open TN_cursor
      
		  Fetch next FROM TN_cursor into @HO
		  set @HOTemp=@HO
			 set @IsHO=0
			 while @@Fetch_status = 0
		  Begin
				set @IsHO=1
						if @HO<>@HOTemp
						begin
							   Set @Result = @Result + '[' + cast(@HOTemp as varchar(40))+' ('+cast(@HOCount as varchar(10))+')],'
							   set @HOTemp=@HO
							   set @HOCount=0

						end
						if @HO=@HOTemp
						begin
							   set @HOCount=@HOCount+1
						end

				Fetch next FROM TN_cursor into @HO              
		  end
         
			 if @IsHO=1
			 begin
				 Set @Result = @Result + '[' + cast(@HOTemp as varchar(40)) +' ('+cast(@HOCount as varchar(10))+')],'
		  end
      
		  Set @Result = substring(@Result,0,len(@Result))
		  CLOSE TN_cursor
		  DEALLOCATE TN_cursor
		  RETURN @Result
	END

	GO
	UPDATE NEW_RAN_SESSION_2019
	SET HandoversInfo = dbo.NEW_GetHandover_A(SessionId)
	WHERE SessionId in (select distinct SessionId from vresultskpi where KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100) 
	         and SessionId in (Select SessionId from Sessions))

	GO
	IF EXISTS (SELECT * FROM  sysobjects WHERE  name = N'NEW_GetHandover_B') DROP FUNCTION NEW_GetHandover_B
	GO
	CREATE FUNCTION NEW_GetHandover_B(@SessionID bigint)
	RETURNS varchar(5000)
	AS
	BEGIN
      
		  DECLARE @HO as varchar(50) 
		  DECLARE @HOCount int   
		  DECLARE @Result as varchar(5000) 
		  DECLARE @HOTemp as Varchar(50)     
		  Declare @IsHO as int
         
		  set @Result	=''
		  set @HOTemp	=''
		  set @HOCount	=0
	        
		  DECLARE TN_cursor CURSOR FOR 
		  SELECT 
				case 
					when kpiid = 34050 then '2G-Handover'
					when kpiid = 34060 then '2G-ChannelModify'
					when kpiid = 34070 then '2G-IntraCellHO'
					when kpiid = 35010 then '3G-CompressMode'
					when kpiid = 35020 then '2G->3G-InterSystemHO'
					when kpiid = 35030 then '3G->2G-InterSystemHO'
					when kpiid = 35040 then '3G->2G-InterSystemHO-DuringTransfer'
					when kpiid = 35041 then '3G->2G-InterSystemHO-RAU' 				
					when kpiid = 35060 then '2G->3G-InterSystemHO-IdleReselect'
					when kpiid = 35061 then '2G->3G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35070 then '3G->2G-InterSystemHO-IdleReselect'
					when kpiid = 35071 then '3G->2G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35080 then '3G-P-TMSI Reallocation'
					when kpiid = 35100 then '3G-Handover'
					when kpiid = 35101 then '3G-CellUpdate'
					when kpiid = 35106 then '3G-InterFrequencyReselection'				
					when kpiid = 35107 then '3G-InterFrequencyHO'
					when kpiid = 35110 then '3G-HSPA-CellChange'
					when kpiid = 35111 then '3G-HSPA R99-LinkChange' 
					when kpiid = 38020 then '4G->3G-InterSystemHO-IdleReselect'
					when kpiid = 38021 then '4G->3G-RedirectionToUARFCN'
					when kpiid = 38030 then '3G->4G-InterSystemHO-IdleReselect'
					when kpiid = 38040 then '4G->3G-InterSystemHO'
					when kpiid = 38100 then '4G-Handover'
				else null end as KPIId                         
		  from
				vresultskpi kpi 
				left outer join SessionsB sb on kpi.SessionId=sb.SessionId 
				where 
					 sb.SessionId=@SessionId
					 and KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100)
			   order by sb.StartTime
      
		  Open TN_cursor
      
		  Fetch next FROM TN_cursor into @HO
		  set @HOTemp=@HO
			 set @IsHO=0
			 while @@Fetch_status = 0
		  Begin
				set @IsHO=1
						if @HO<>@HOTemp
						begin
							   Set @Result = @Result + '[' + cast(@HOTemp as varchar(40))+' ('+cast(@HOCount as varchar(10))+')],'
							   set @HOTemp=@HO
							   set @HOCount=0

						end
						if @HO=@HOTemp
						begin
							   set @HOCount=@HOCount+1
						end

				Fetch next FROM TN_cursor into @HO              
		  end
         
			 if @IsHO=1
			 begin
				 Set @Result = @Result + '[' + cast(@HOTemp as varchar(40)) +' ('+cast(@HOCount as varchar(10))+')],'
		  end
      
		  Set @Result = substring(@Result,0,len(@Result))
		  CLOSE TN_cursor
		  DEALLOCATE TN_cursor
		  RETURN @Result
	END

	GO
	UPDATE NEW_RAN_SESSION_2019
	SET HandoversInfo = dbo.NEW_GetHandover_B(SessionId)
	WHERE SessionId in (select distinct SessionId from vresultskpi where KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100) 
	         and SessionId in (Select SessionId from SessionsB))

GO
	IF EXISTS (SELECT * FROM  sysobjects WHERE  name = N'NEW_GetTestHandover_A') DROP FUNCTION NEW_GetTestHandover_A
	GO
	CREATE FUNCTION NEW_GetTestHandover_A(@SessionID bigint,@TestID bigint)
	RETURNS varchar(5000)
	AS
	BEGIN
      
		  DECLARE @HO as varchar(50) 
		  DECLARE @HOCount int   
		  DECLARE @Result as varchar(5000) 
		  DECLARE @HOTemp as Varchar(50)     
		  Declare @IsHO as int
         
		  set @Result	=''
		  set @HOTemp	=''
		  set @HOCount	=0
	        
		  DECLARE TN_cursor CURSOR  FAST_FORWARD FOR  
		  SELECT 
				case 
					when kpiid = 34050 then '2G-Handover'
					when kpiid = 34060 then '2G-ChannelModify'
					when kpiid = 34070 then '2G-IntraCellHO'
					when kpiid = 35010 then '3G-CompressMode'
					when kpiid = 35020 then '2G->3G-InterSystemHO'
					when kpiid = 35030 then '3G->2G-InterSystemHO'
					when kpiid = 35040 then '3G->2G-InterSystemHO-DuringTransfer'
					when kpiid = 35041 then '3G->2G-InterSystemHO-RAU' 				
					when kpiid = 35060 then '2G->3G-InterSystemHO-IdleReselect'
					when kpiid = 35061 then '2G->3G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35070 then '3G->2G-InterSystemHO-IdleReselect'
					when kpiid = 35071 then '3G->2G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35080 then '3G-P-TMSI Reallocation'
					when kpiid = 35100 then '3G-Handover'
					when kpiid = 35101 then '3G-CellUpdate'
					when kpiid = 35106 then '3G-InterFrequencyReselection'				
					when kpiid = 35107 then '3G-InterFrequencyHO'
					when kpiid = 35110 then '3G-HSPA-CellChange'
					when kpiid = 35111 then '3G-HSPA R99-LinkChange' 
					when kpiid = 38020 then '4G->3G-InterSystemHO-IdleReselect'
					when kpiid = 38021 then '4G->3G-RedirectionToUARFCN'
					when kpiid = 38030 then '3G->4G-InterSystemHO-IdleReselect'
					when kpiid = 38040 then '4G->3G-InterSystemHO'
					when kpiid = 38100 then '4G-Handover'
				else null end as KPIId                         
		  from
				TestInfo AS Ti 
            				left outer join vresultskpi kpi ON ti.TestID = kpi.Testid  
				where 
					 ti.TestID=@TestID and ti.SessionId = @SessionId 
					 and KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100)
			   order by ti.StartTime
      
		  Open TN_cursor
		  Fetch next FROM TN_cursor into @HO
		  set @HOTemp=@HO
			 set @IsHO=0
			 while @@Fetch_status = 0
		  Begin
				set @IsHO=1
						if @HO<>@HOTemp
						begin
							   Set @Result = @Result + '[' + cast(@HOTemp as varchar(40))+' ('+cast(@HOCount as varchar(10))+')],'
							   set @HOTemp=@HO
							   set @HOCount=0

						end
						if @HO=@HOTemp
						begin
							   set @HOCount=@HOCount+1
						end

				Fetch next FROM TN_cursor into @HO              
		  end 
			 if @IsHO=1
			 begin
				 Set @Result = @Result + '[' + cast(@HOTemp as varchar(40)) +' ('+cast(@HOCount as varchar(10))+')],'
		  end
		  Set @Result = substring(@Result,0,len(@Result))
		  CLOSE TN_cursor
		  DEALLOCATE TN_cursor
		  RETURN @Result
	END
	GO
	UPDATE NEW_RAN_TEST_2019
	SET HandoversInfo = dbo.NEW_GetTestHandover_A(SessionId,TestId)
	WHERE SessionId in (select distinct SessionId from vresultskpi where KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100) 
	         and SessionId in (Select SessionId from Sessions))

GO
	IF EXISTS (SELECT * FROM  sysobjects WHERE  name = N'NEW_GetTestHandover_B') DROP FUNCTION NEW_GetTestHandover_B
	GO
	CREATE FUNCTION NEW_GetTestHandover_B(@SessionID bigint,@TestID bigint)
	RETURNS varchar(5000)
	AS
	BEGIN
      
		  DECLARE @HO as varchar(50) 
		  DECLARE @HOCount int   
		  DECLARE @Result as varchar(5000) 
		  DECLARE @HOTemp as Varchar(50)     
		  Declare @IsHO as int
         
		  set @Result	=''
		  set @HOTemp	=''
		  set @HOCount	=0
	        
		  DECLARE TN_cursor CURSOR  FAST_FORWARD FOR  
		  SELECT 
				case 
					when kpiid = 34050 then '2G-Handover'
					when kpiid = 34060 then '2G-ChannelModify'
					when kpiid = 34070 then '2G-IntraCellHO'
					when kpiid = 35010 then '3G-CompressMode'
					when kpiid = 35020 then '2G->3G-InterSystemHO'
					when kpiid = 35030 then '3G->2G-InterSystemHO'
					when kpiid = 35040 then '3G->2G-InterSystemHO-DuringTransfer'
					when kpiid = 35041 then '3G->2G-InterSystemHO-RAU' 				
					when kpiid = 35060 then '2G->3G-InterSystemHO-IdleReselect'
					when kpiid = 35061 then '2G->3G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35070 then '3G->2G-InterSystemHO-IdleReselect'
					when kpiid = 35071 then '3G->2G-InterSystemHOToLAU-IdleReselect'
					when kpiid = 35080 then '3G-P-TMSI Reallocation'
					when kpiid = 35100 then '3G-Handover'
					when kpiid = 35101 then '3G-CellUpdate'
					when kpiid = 35106 then '3G-InterFrequencyReselection'				
					when kpiid = 35107 then '3G-InterFrequencyHO'
					when kpiid = 35110 then '3G-HSPA-CellChange'
					when kpiid = 35111 then '3G-HSPA R99-LinkChange' 
					when kpiid = 38020 then '4G->3G-InterSystemHO-IdleReselect'
					when kpiid = 38021 then '4G->3G-RedirectionToUARFCN'
					when kpiid = 38030 then '3G->4G-InterSystemHO-IdleReselect'
					when kpiid = 38040 then '4G->3G-InterSystemHO'
					when kpiid = 38100 then '4G-Handover'
				else null end as KPIId                         
		  from
				TestInfo AS Ti 
				left outer join SessionsB sb    on sb.SessionIdA=ti.SessionId 
				left outer join vresultskpi kpi ON ti.TestID = kpi.Testid  
				where 
					 kpi.TestID=@TestID and kpi.SessionId = @SessionId 
					 and KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100)
			   order by ti.StartTime
      
		  Open TN_cursor
		  Fetch next FROM TN_cursor into @HO
		  set @HOTemp=@HO
			 set @IsHO=0
			 while @@Fetch_status = 0
		  Begin
				set @IsHO=1
						if @HO<>@HOTemp
						begin
							   Set @Result = @Result + '[' + cast(@HOTemp as varchar(40))+' ('+cast(@HOCount as varchar(10))+')],'
							   set @HOTemp=@HO
							   set @HOCount=0

						end
						if @HO=@HOTemp
						begin
							   set @HOCount=@HOCount+1
						end

				Fetch next FROM TN_cursor into @HO              
		  end 
			 if @IsHO=1
			 begin
				 Set @Result = @Result + '[' + cast(@HOTemp as varchar(40)) +' ('+cast(@HOCount as varchar(10))+')],'
		  end
		  Set @Result = substring(@Result,0,len(@Result))
		  CLOSE TN_cursor
		  DEALLOCATE TN_cursor
		  RETURN @Result
	END
	GO
	UPDATE NEW_RAN_TEST_2019
	SET HandoversInfo = dbo.NEW_GetTestHandover_B(SessionId,TestId)
	WHERE SessionId in (select distinct SessionId from vresultskpi where KPIId in (34050,34060,34070,35010,35020,35030,35040,35041,35060,35061,35070,35071,35080,35100,35101,35106,35107,35110,35111,38020,38021,38030,38040,38100) 
	         and SessionId in (Select SessionId from SessionsB))

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - COMPLETED...')

-- select * from #TA_GSM
-- select * from #TA_LTE where AvgTA is not null
-- select * from NEW_RAN_RAW_2019 where SessionId in (select sessionid from SessionsB)
-- select * from NEW_RAN_TEST_2019 order by TestId
-- select * from NEW_RAN_SESSION_2019 order by sessionid
-- select * from NEW_RAN_SESSION_2019 where SessionId in (select sessionid from SessionsB)
-- select * from SessionsB where SessionIdA = 4294967297
-- select top 50 * from NetworkIdRelation where SessionId in (select sessionid from SessionsB)
-- drop table NEW_RAN_TEST_2019
-- drop table NEW_RAN_SESSION_2019
-- drop table NEW_RAN_RAW_2019
