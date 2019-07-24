/*****************************************************************************************************************************************************************************
============================================================================================================================================================================
 Project: Press Benchmark 2016
  Script: CREATE_TECH_Session_2018
  Author: MP @ NET CHECK GmbH
============================================================================================================================================================================
*****************************************************************************************************************************************************************************/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- History 
-- v01 -> Create
-- v02 ->NEW_GetSessionRatTechnology angepasst
-- v03 ->mpausin 15.06.2016 Skript beschleunigt
-- v04 -> 08.08.2016.	/	AST		/	GSM 1900, UMTS 850, UMTS 1900 added
-- v05 -> 26.08.2016.	/	AST		/	LTE 900 added	/	limited to 3 internal decimal places	
-- v06 -> 17.11.2016.	/	mpausin		funktion Timeline erweitert
-- v08.02 -> added partially no service
-- v08.03 -> tmiksa cleanup 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DROP OLD TABLES
-- IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_TECH_Session_2018') DROP Table NEW_TECH_Session_2018
-- IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'vTechnologyDurationSessionAB')	DROP view vTechnologyDurationSessionAB
-- select * from NEW_TECH_Session_2018

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'Duration') DROP FUNCTION Duration
GO
CREATE FUNCTION Duration(@K varchar(25),@N varchar(25))
RETURNS  float
AS
BEGIN
	if @N < '2014-02-28 13:30:17.704' or @K < '2014-02-28 13:30:17.704' or datediff(mi,@K,@N)>5 return NULL
	return	datediff(ms,@K,@N)
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetSessionRatTechnology')		DROP FUNCTION NEW_GetSessionRatTechnology
GO
CREATE FUNCTION NEW_GetSessionRatTechnology(@Sessionid bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @Tec as varchar(50)   
      Declare @Result as varchar(1000)    
      set @Result =''
	  Declare @TecTemp as varchar(100)
	  set @TecTemp =''
	  Declare @IsTec as int
	  Declare @Duration as int
	  Declare @SumDuration as int
	  Set @SumDuration=0
      DECLARE Tec_cursor CURSOR FAST_FORWARD FOR 
      Select 
			case when ni.Status in (6, 8) then 
							case ni.technology
								when	'GSM 900'								THEN  'GSM_900'
								when	'GSM 1800'								THEN  'GSM_1800'
								when	'GSM 1900'								THEN  'GSM_1900'
								when	'UMTS 850'								THEN  'UMTS_850'
								when	'UMTS 900'								THEN  'UMTS_900'
								when	'UMTS 1700'								THEN  'UMTS 1700'
								when	'UMTS 1900'								THEN  'UMTS 1900'
								when	'UMTS 2100'								THEN  'UMTS_2100'
								when	'LTE E-UTRA 28'							THEN  'LTE_700'
								when	'LTE E-UTRA 20'							THEN  'LTE_800'
								when	'LTE E-UTRA 8'							THEN  'LTE_900'
								when	'LTE E-UTRA 10'							THEN  'LTE_1700'			
								when	'LTE E-UTRA 3'							THEN  'LTE_1800'
								when	'LTE E-UTRA 2'							THEN  'LTE_1900'					
								when	'LTE E-UTRA 1'							THEN  'LTE_2100'	
								when	'LTE E-UTRA 7'							THEN  'LTE_2600'
								when	'LTE E-UTRA 40'							THEN  'LTE_TDD_2300'
								when	'LTE E-UTRA 41'							THEN  'LTE_TDD_2500'
								when	'WiFi'									THEN  'WiFi'
							end			
							else 
								dbo.GetNetworkStatusDescription(ni.Status)	
						end																as Technology,
			ni.duration-
			case
					when s.StartNetworkId = ni.NetworkId then DATEDIFF(ms, ni.MsgTime, s.StartTime)
					else 0
				end
				+ case
					when s.NetworkId = ni.NetworkId then DATEDIFF(ms, ni.MsgTime, DATEADD(ms, s.Duration, s.StartTime)) - nEnd.Duration
					else 0
				end as Duration
	from
	(
		select sessionid,starttime,duration,StartNetworkId,NetworkId from   Sessions
		UNION ALL
		select sessionid,starttime,duration,StartNetworkId,NetworkId from   SessionsB
	)s
	join NetworkInfo ni on ni.NetworkId between s.StartNetworkId and s.NetworkId
	JOIN NetworkInfo nEnd ON nEnd.NetworkId = s.NetworkId
	where 
			ni.Technology is not null and
			s.SessionId = @Sessionid
	order by ni.MsgTime
      Open Tec_cursor
      Fetch next FROM Tec_cursor into @Tec,@Duration
	  set @TecTemp=@Tec
	  set @IsTec=0
	  while @@Fetch_status =0
      Begin
			set @IsTec=1 
			if @Tec<>@TecTemp
			begin 
				set @Result = @Result + @TecTemp +' ('+ltrim(str(@SumDuration/1000.0,25,1))+ ')->'
				set @TecTemp=@Tec
				set @SumDuration =0
			end                           
			set @SumDuration = @SumDuration +@Duration
            Fetch next FROM Tec_cursor into @Tec,@Duration
      end
	  if @IsTec=1
	  begin
		set @Result = @Result + @TecTemp +' ('+ltrim(str(@SumDuration/1000.0,25,1))+ ')->'
		Set @Result = substring(@Result,0,len(@Result)-1)
	  end
      CLOSE Tec_cursor
      DEALLOCATE Tec_cursor
      RETURN @Result
END
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING VIEWS IF THEY DO NOT EXIST
-- USED FOR FURTHER CALCULATIONS
-- View: vTechnologyDurationSessionAB
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execeution...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Create vTechnologyDurationSessionAB view if it does not exist...')
	GO
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'vTechnologyDurationSessionAB')	DROP view vTechnologyDurationSessionAB
	GO
	CREATE VIEW [dbo].[vTechnologyDurationSessionAB]
	AS
	select 
		sessionid,
		SessionStart,
		SessionEnd,
		SessionDuration,
		Technology,
		sum(duration) as TechnologyDuration
	from
	(
		Select 
				s.SessionId,
				s.starttime as SessionStart,
				s.duration as SessionDuration,
				DATEADD(ms, s.Duration, s.StartTime) as SessionEnd,
				case when ni.Status in (6, 8) then dbo.GetRFBand(ni.RFBand)
						  else dbo.GetNetworkStatusDescription(ni.Status)
				end as Technology,
				ni.networkid,
				ni.msgtime,
				ni.Status,
				ni.RFBand,
				ni.duration-
				case
						when s.StartNetworkId = ni.NetworkId then DATEDIFF(ms, ni.MsgTime, s.StartTime)
						else 0
					end
					+ case
						when s.NetworkId = ni.NetworkId then DATEDIFF(ms, ni.MsgTime, DATEADD(ms, s.Duration, s.StartTime)) - nEnd.Duration
						else 0
					end as Duration
		from
		(
			select sessionid,starttime,duration,StartNetworkId,NetworkId from   Sessions
			UNION ALL
			select sessionid,starttime,duration,StartNetworkId,NetworkId from   SessionsB
		)s
		join NetworkInfo ni on ni.NetworkId between s.StartNetworkId and s.NetworkId
		JOIN NetworkInfo nEnd ON nEnd.NetworkId = s.NetworkId
	) t
	group by sessionid,SessionStart,SessionEnd,SessionDuration,Technology,Status,RFBand
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING TABLE
-- Table: NEW_TECH_Session_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Create NEW_TECH_Session_2018 table if it does not exist...')
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_TECH_Session_2018')					DROP Table NEW_TECH_Session_2018
	Declare @Error as int
	set @Error=0
		select @Error=COUNT(Technology)  
		from vTechnologyDurationTest
		where  Technology  not in		('GSM 900','GSM 1800','GSM 1900','UMTS 850','UMTS 900','UMTS 1700','UMTS 1900','UMTS 2100','LTE E-UTRA 28','LTE E-UTRA 1','LTE E-UTRA 2','LTE E-UTRA 3','LTE E-UTRA 7','LTE E-UTRA 8','LTE E-UTRA 10','LTE E-UTRA 20','LTE E-UTRA 26','LTE E-UTRA 28','LTE E-UTRA 38','LTE E-UTRA 39','LTE E-UTRA 40','LTE E-UTRA 41','WiFi','No service','Emergency calls only','Status not available','unknown')		
		if @Error<>0 
		begin
			select distinct 'ERROR RAT Technology' as Error,Technology  
			from vTechnologyDurationSessionAB
			where  Technology  not in	('GSM 900','GSM 1800','GSM 1900','UMTS 850','UMTS 900','UMTS 1700','UMTS 1900','UMTS 2100','LTE E-UTRA 28','LTE E-UTRA 1','LTE E-UTRA 2','LTE E-UTRA 3','LTE E-UTRA 7','LTE E-UTRA 8','LTE E-UTRA 10','LTE E-UTRA 20','LTE E-UTRA 26','LTE E-UTRA 28','LTE E-UTRA 38','LTE E-UTRA 39','LTE E-UTRA 40','LTE E-UTRA 41','WiFi','No service','Emergency calls only','Status not available','unknown')		
			print('ERROR RAT Technology! New Technology There!')
		end
		else -- select distinct technology from vTechnologyDurationSessionAB order by technology
		begin
			print 'RAT Technologie O.K.'
			select 
				rtec.SessionID,
				[RAT Technology]					AS RAT,
				NULLIF (CAST(rtec.[TIME_GSM_900]	AS Decimal (10,3)), 0) AS TIME_GSM_900_s,
				NULLIF (CAST(rtec.[TIME_GSM_1800]	AS Decimal (10,3)), 0) AS TIME_GSM_1800_s,
				NULLIF (CAST(rtec.[TIME_GSM_1900]	AS Decimal (10,3)), 0) AS TIME_GSM_1900_s,
				NULLIF (CAST(rtec.[TIME_UMTS_850]	AS Decimal (10,3)), 0) AS TIME_UMTS_850_s,			
				NULLIF (CAST(rtec.[TIME_UMTS_900]	AS Decimal (10,3)), 0) AS TIME_UMTS_900_s,
				NULLIF (CAST(rtec.[TIME_UMTS_1700]	AS Decimal (10,3)), 0) AS TIME_UMTS_1700_s,
				NULLIF (CAST(rtec.[TIME_UMTS_1900]	AS Decimal (10,3)), 0) AS TIME_UMTS_1900_s,
				NULLIF (CAST(rtec.[TIME_UMTS_2100]	AS Decimal (10,3)), 0) AS TIME_UMTS_2100_s,
				NULLIF (CAST(rtec.[TIME_LTE_700]	AS Decimal (10,3)), 0) AS TIME_LTE_700_s,
				NULLIF (CAST(rtec.[TIME_LTE_800]	AS Decimal (10,3)), 0) AS TIME_LTE_800_s,
				NULLIF (CAST(rtec.[TIME_LTE_900]	AS Decimal (10,3)), 0) AS TIME_LTE_900_s,			
				NULLIF (CAST(rtec.[TIME_LTE_1700]	AS Decimal (10,3)), 0) AS TIME_LTE_1700_s,
				NULLIF (CAST(rtec.[TIME_LTE_1800]	AS Decimal (10,3)), 0) AS TIME_LTE_1800_s,
				NULLIF (CAST(rtec.[TIME_LTE_1900]	AS Decimal (10,3)), 0) AS TIME_LTE_1900_s,
				NULLIF (CAST(rtec.[TIME_LTE_2100]	AS Decimal (10,3)), 0) AS TIME_LTE_2100_s,
				NULLIF (CAST(rtec.[TIME_LTE_2600]	AS Decimal (10,3)), 0) AS TIME_LTE_2600_s,
				NULLIF (CAST(rtec.[TIME_LTE_TDD_2300]	AS Decimal (10,3)), 0) AS TIME_LTE_TDD_2300_s,
				NULLIF (CAST(rtec.[TIME_LTE_TDD_2600]	AS Decimal (10,3)), 0) AS TIME_LTE_TDD_2600_s,
				NULLIF (CAST(rtec.[TIME_LTE_TDD_2500]	AS Decimal (10,3)), 0) AS TIME_LTE_TDD_2500_s,
				NULLIF (CAST(rtec.[TIME_WiFi]		AS Decimal (10,3)), 0) AS TIME_WiFi_s,
				NULLIF (CAST(rtec.[TIME_No_Service]		AS Decimal (10,3)), 0) AS TIME_No_Service_s,
				NULLIF (CAST(rtec.[TIME_Unknown]		AS Decimal (10,3)), 0) AS TIME_Unknown_s,
				NULLIF (CAST(RAT_Technology_Duration	AS Decimal (10,3)), 0) AS RAT_Technology_Duration_s, 
				dbo.NEW_GetSessionRatTechnology(rtec.sessionid)					AS RAT_Timeline
			into NEW_TECH_Session_2018
			from
			(
				SELECT 
					SessionId,
					SUM(CASE WHEN Technology LIKE 'GSM 900'									THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_GSM_900],
					SUM(CASE WHEN Technology LIKE 'GSM 1800'								THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_GSM_1800],
					SUM(CASE WHEN Technology LIKE 'GSM 1900'								THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_GSM_1900],
					SUM(CASE WHEN Technology LIKE 'UMTS 850'								THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_850],				
					SUM(CASE WHEN Technology LIKE 'UMTS 900'								THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_900],
					SUM(CASE WHEN Technology LIKE 'UMTS 1700'								THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_1700],
					SUM(CASE WHEN Technology LIKE 'UMTS 1900'								THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_1900],
					SUM(CASE WHEN Technology LIKE 'UMTS 2100'								THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_2100],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 28'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_700],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 20'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_800],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 8'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_900],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 10'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_1700],			
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 3'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_1800],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 2'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_1900],					
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 1'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_2100],	
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 7'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_2600],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 38'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_TDD_2600],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 40'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_TDD_2300],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 41'							THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_TDD_2500],
					SUM(CASE WHEN Technology in('WiFi')										THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_WiFi],
					SUM(CASE WHEN Technology in('No service','Emergency calls only')		THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_No_Service],
					SUM(CASE WHEN Technology in('Status not available','unknown')			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_Unknown],
					SUM (TechnologyDuration)/1000.0																						 AS [RAT_Technology_Duration]			
				FROM vTechnologyDurationSessionAB
				GROUP BY SessionId )rtec 
			left outer join
			(
				select 
						Sessionid,
						case when Unknown>0 then 'Unknown' else  -- Status not available	
							case when No_Service>0 and (GSM<>0 or UMTS<>0 or LTE<>0) then  'Partially_No_Service' else  -- Emergency calls only or No_Service			
								case when No_Service>0 then 'No Service' else  -- Emergency calls only or No_Service
									case when LTE>0 and UMTS=0 and GSM=0  then 'LTE' else
										case when LTE=0 and UMTS>0 and GSM=0 then 'UMTS' else
											case when LTE=0 and UMTS=0 and GSM>0  then 'GSM' else
												case when LTE=0 and UMTS>0 and GSM>0  then 'UMTS/GSM' else
													case when LTE>0 and UMTS=0 and GSM>0  then 'LTE/GSM' else
														case when LTE>0 and UMTS>0 and GSM=0  then 'LTE/UMTS' else
															case when LTE>0 and UMTS>0 and GSM>0  then 'LTE/UMTS/GSM'  
															end
														end
													end
												end
											end
										end
									end
								end
							end	 
						end as [RAT Technology]
				from
				(
					select
							 SessionId,	  			
							 SUM(case when SUBSTRING(technology,1,4)='GSM'						then 1 else 0 end) as GSM,
							 SUM(case when SUBSTRING(technology,1,4)='UMTS'						then 1 else 0 end) as UMTS,
							 SUM(case when SUBSTRING(technology,1,4)='LTE'						then 1 else 0 end) as LTE,
							 SUM(case when technology IN ('No service','Emergency calls only')	then 1 else 0 end) as No_Service,
							 SUM(case when technology IN ('Status not available','unknown')		then 1 else 0 end) as Unknown
					from vTechnologyDurationSessionAB 
					group by SessionId
				) t 
			) t2 on rtec.SessionId=t2.SessionId
		end

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script Execution Completed!')


-- SELECT * FROM NEW_TECH_Session_2018
-- select distinct Technology from [vTechnologyDurationSessionAB] order by Technology