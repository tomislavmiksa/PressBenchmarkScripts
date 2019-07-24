/*****************************************************************************************************************************************************************************
============================================================================================================================================================================
 Project: Press Benchmark 2016
  Script: CREATE_NEW_Technology_per_Test
  Author: MP @ NET CHECK GmbH
============================================================================================================================================================================
*****************************************************************************************************************************************************************************/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- History 
-- v01. -> Create script
-- v04. -> Trennung von Emergency calls only or No_Service entfernt -> zu No_Service
-- v05. -> mpausin 23.06.2016 Funktion NC_GetTestRatTechnology  auf Timeline geändert
-- v06. -> mpausin 23.06.2016 NC_GetTestDataTechnology   auf Timeline geändert
-- v07. -> astage  14.07.2016 Emergency calls only added (Freerider)
-- v08. -> astage  27.07.2016 Status not available added, put to Unknown
-- v09. -> mpausin  01.08.2016 RAT UMTS 850 eingefügt
-- v09. -> 12.08.2016.	/	AST		/	LTE 2100 added	/	Status not available added to Unknown
-- v11. ->mpausin 17.11.2016 Funktionen Timeline erweitert 
-- v12. -> astage 17.03.2017 added LTE 700 (LTE E-UTRA 28)
-- v13. -> astage 21.03.2017 added GSM 1900 and UMTS 1700
-- v13.01 -> tmiksa 21.03.2017 added partially no service into calculation
-- v13.01 -> tmiksa 21.03.2017 added LTE 700 band 12 and LTE band 40, LTE 2300
-- v13.03 -> tmiksa 09.11.2017 Cleanup
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete old tables  --------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_TECH_Test_2018') DROP Table NEW_TECH_Test_2018
-- select * from NEW_TECH_Test_2018

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NC_GetTestRatTechnology') DROP FUNCTION NC_GetTestRatTechnology
GO
CREATE FUNCTION NC_GetTestRatTechnology(@TestID bigint)
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

		DECLARE Tec_cursor CURSOR Fast_Forward FOR 
			SELECT  
				case technology
					when	'GSM 900'								THEN  'GSM_900'
					when	'GSM 1800'								THEN  'GSM_1800'
					when	'GSM 1900'								THEN  'GSM_1900'					
					when	'UMTS 850'								THEN  'UMTS_850'
					when	'UMTS 900'								THEN  'UMTS_900'
					when	'UMTS 1700'								THEN  'UMTS_1700'					
					when	'UMTS 1900'								THEN  'UMTS_1900'
					when	'UMTS 2100'								THEN  'UMTS_2100'
					when	'LTE E-UTRA 12'							THEN  'LTE_700'
					when	'LTE E-UTRA 13'							THEN  'LTE_700'
					when	'LTE E-UTRA 28'							THEN  'LTE_700'
					when	'LTE E-UTRA 20'							THEN  'LTE_800'
					when	'LTE E-UTRA 8'							THEN  'LTE_900'	
					when	'LTE E-UTRA 10'							THEN  'LTE_1700'			
					when	'LTE E-UTRA 3'							THEN  'LTE_1800'
					when	'LTE E-UTRA 2'							THEN  'LTE_1900'					
					when	'LTE E-UTRA 1'							THEN  'LTE_2100'	
					when	'LTE E-UTRA 7'							THEN  'LTE_2600'
					when	'LTE E-UTRA 38'							THEN  'LTE_TDD_2600'
					when	'LTE E-UTRA 40'							THEN  'LTE_TDD_2300'
					when	'LTE E-UTRA 41'							THEN  'LTE_TDD_2500'
					else technology													
				end																		as Technology,
				TechnologyDuration
			from
				vTechnologyDurationTest
			where 
				Testid=@TestID and
				TestID<>0 and 
				Technology is not null
			ORDER BY TestStart
      
      Open Tec_cursor
      set @SumDuration = 0
	  set @Duration = 0
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

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NC_GetTestDataTechnology') DROP FUNCTION NC_GetTestDataTechnology
GO
CREATE FUNCTION NC_GetTestDataTechnology(@TestID bigint)
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
		set @SumDuration=0
	  
	  DECLARE Tec_cursor CURSOR FOR 
		select 
			case when PrevTechnology like 'R99%' then 'R99' else  PrevTechnology end asPrevTechnology ,
			duration  
		from 
			Technology
		where
				TestID=@TestID and
				Duration is not null and 
				PrevTechnology is not null and
				TestID<>0 
        order by msgtime
      
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
			Fetch next FROM Tec_cursor into @Tec,@duration
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
-- View: select * from vTechnologyDurationSessionAB
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execeution...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Create NEW_TECH_Test_2018 table if it does not exist...')
GO
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_TECH_Test_2018') DROP Table NEW_TECH_Test_2018
	GO
	Declare @Error as int
	set @Error=0

	select  
		@Error=COUNT(PrevTechnology) 
	from 
		Technology 
	where  	case when	
					PrevTechnology is null		or  PrevTechnology = 'GPRS'		or PrevTechnology = 'EDGE'	or PrevTechnology like 'R99%'	or	
					PrevTechnology = 'HSPA'		or  PrevTechnology = 'HSPA+'	or PrevTechnology = 'HSDPA'	or PrevTechnology = 'HSUPA'		or
					PrevTechnology = 'HSPA DC'	or	PrevTechnology = 'LTE'		or PrevTechnology = 'Wifi'	Or PrevTechnology = 'HSDPA+'	or
					PrevTechnology = 'LTE CA'
				then 'OK'  else PrevTechnology 
			end	<>'OK'
	if @Error<>0 
	Begin
	
		Select  distinct 'Fehlende Technology' as Error, PrevTechnology
		from Technology 
		where case when	
					PrevTechnology is null		or  PrevTechnology = 'GPRS'		or PrevTechnology = 'EDGE'	or PrevTechnology like 'R99%'	or	
					PrevTechnology = 'HSPA'		or  PrevTechnology = 'HSPA+'	or PrevTechnology = 'HSDPA'	or PrevTechnology = 'HSUPA'		or
					PrevTechnology = 'HSPA DC'	or	PrevTechnology = 'LTE'		or PrevTechnology = 'Wifi'	Or PrevTechnology = 'HSDPA+'	or
					PrevTechnology = 'LTE CA'
				then 'OK'  else PrevTechnology 
				end	<>'OK'
	end
	else
	begin
		print 'Technologie O.K.'
					
		select @Error=COUNT(Technology)  
		from vTechnologyDurationTest
		where  Technology  not in		('GSM 900','GSM 1800','GSM 1900','UMTS 850','UMTS 900','UMTS 1700','UMTS 1900','UMTS 2100','LTE E-UTRA 1','LTE E-UTRA 2','LTE E-UTRA 3','LTE E-UTRA 7','LTE E-UTRA 8','LTE E-UTRA 10', 'LTE E-UTRA 12','LTE E-UTRA 20', 'LTE E-UTRA 13','LTE E-UTRA 28','LTE E-UTRA 38', 'LTE E-UTRA 40','LTE E-UTRA 41','LTE E-UTRA 26', 'LTE E-UTRA 39','No service','Emergency calls only','Unknown', 'Status not available','WiFi')		
		if @Error<>0 
		begin
			select distinct 'Fehlende RAT' as Error,Technology  
			from vTechnologyDurationTest
			where  Technology  not in	('GSM 900','GSM 1800','GSM 1900','UMTS 850','UMTS 900','UMTS 1700','UMTS 1900','UMTS 2100','LTE E-UTRA 1','LTE E-UTRA 2','LTE E-UTRA 3','LTE E-UTRA 7','LTE E-UTRA 8','LTE E-UTRA 10', 'LTE E-UTRA 12', 'LTE E-UTRA 13','LTE E-UTRA 20', 'LTE E-UTRA 28','LTE E-UTRA 38', 'LTE E-UTRA 41', 'LTE E-UTRA 40', 'LTE E-UTRA 39','LTE E-UTRA 26','No service','Emergency calls only','Unknown', 'Status not available', 'WiFi')		
			raiserror('ERROR RAT Technology! New Technology There!', 20, -1) with log
		end
		else
		begin
			print 'RATTechnologie O.K.'
			select	
				tec.Sessionid,
				tec.testid,
				[RAT Technology]													AS RAT,
				NULLIF (CAST([TIME_GSM_900]					AS Decimal (10,3)), 0)	AS TIME_GSM_900_s,
				NULLIF (CAST([TIME_GSM_1800]				AS Decimal (10,3)), 0)	AS TIME_GSM_1800_s,
				NULLIF (CAST([TIME_GSM_1900]				AS Decimal (10,3)), 0)	AS TIME_GSM_1900_s,
				NULLIF (CAST([TIME_UMTS_850]				AS Decimal (10,3)), 0)	AS TIME_UMTS_850_s,
				NULLIF (CAST([TIME_UMTS_900]				AS Decimal (10,3)), 0)	AS TIME_UMTS_900_s,
				NULLIF (CAST([TIME_UMTS_1700]				AS Decimal (10,3)), 0)	AS TIME_UMTS_1700_s,
				NULLIF (CAST([TIME_UMTS_1900]				AS Decimal (10,3)), 0)	AS TIME_UMTS_1900_s,
				NULLIF (CAST([TIME_UMTS_2100]				AS Decimal (10,3)), 0)	AS TIME_UMTS_2100_s,
				NULLIF (CAST([TIME_LTE_700]					AS Decimal (10,3)), 0)	AS TIME_LTE_700_s,
				NULLIF (CAST([TIME_LTE_800]					AS Decimal (10,3)), 0)	AS TIME_LTE_800_s,
				NULLIF (CAST([TIME_LTE_900]					AS Decimal (10,3)), 0)	AS TIME_LTE_900_s,
				NULLIF (CAST([TIME_LTE_1700]				AS Decimal (10,3)), 0)	AS TIME_LTE_1700_s,
				NULLIF (CAST([TIME_LTE_1800]				AS Decimal (10,3)), 0)	AS TIME_LTE_1800_s,
				NULLIF (CAST([TIME_LTE_1900]				AS Decimal (10,3)), 0)	AS TIME_LTE_1900_s,
				NULLIF (CAST([TIME_LTE_2100]				AS Decimal (10,3)), 0)	AS TIME_LTE_2100_s,
				NULLIF (CAST([TIME_LTE_2600]				AS Decimal (10,3)), 0)	AS TIME_LTE_2600_s,
				NULLIF (CAST([TIME_LTE_TDD_2500]			AS Decimal (10,3)), 0)	AS TIME_LTE_TDD_2300_s,
				NULLIF (CAST([TIME_LTE_TDD_2500]			AS Decimal (10,3)), 0)	AS TIME_LTE_TDD_2500_s,
				NULLIF (CAST([TIME_No_Service]				AS Decimal (10,3)), 0)	AS TIME_No_Service_s,
				NULLIF (CAST([TIME_Unknown]					AS Decimal (10,3)), 0)	AS TIME_Unknown_s,
				NULLIF (CAST([RAT Technology Duration]		AS Decimal (10,3)), 0)	AS Test_RAT_Duration_s, 
				dbo.NC_GetTestRatTechnology(tec.testid)								AS RAT_Timeline,
				NULLIF (CAST([GPRS]							AS Decimal (10,3)), 0)	AS [GPRS_s],
				NULLIF (CAST([EDGE]							AS Decimal (10,3)), 0)	AS [EDGE_s],
				NULLIF (CAST([UMTS_R99]						AS Decimal (10,3)), 0)	AS [UMTS_R99_s],
				NULLIF (CAST([HSDPA]						AS Decimal (10,3)), 0)	AS [HSDPA_s],
				NULLIF (CAST([HSUPA]						AS Decimal (10,3)), 0)	AS [HSUPA_s],
				NULLIF (CAST([HSDPA+]						AS Decimal (10,3)), 0)	AS [HSDPA_Plus_s],
				NULLIF (CAST([HSPA]							AS Decimal (10,3)), 0)	AS [HSPA_s],
				NULLIF (CAST([HSPA+]						AS Decimal (10,3)), 0)	AS [HSPA_Plus_s],			
				NULLIF (CAST([HSPA DC]						AS Decimal (10,3)), 0)	AS [HSPA_DC_s],
				NULLIF (CAST([LTE]							AS Decimal (10,3)), 0)	AS [LTE_s],
				NULLIF (CAST([LTE CA]						AS Decimal (10,3)), 0)	AS [LTE_CA_s],
				NULLIF (CAST([Wifi]							AS Decimal (10,3)), 0)	AS [Wifi_s],
				NULLIF (CAST([Unknown]						AS Decimal (10,3)), 0)	AS [Unknown_s],
				NULLIF (CAST([Data Technology Duration]		AS Decimal (10,3)), 0)	AS [Test_TEC_Duration_s],
				dbo.NC_GetTestDataTechnology(tec.testid)							AS TEC_Timeline
			into NEW_TECH_Test_2018
			from
			(
				select 
					SessionId,
					TestId,
					sum( case when PrevTechnology is null		then Duration else 0 end)/1000.0 AS Unknown,
					sum( case when PrevTechnology = 'GPRS'		then Duration else 0 end)/1000.0 AS GPRS,
					sum( case when PrevTechnology = 'EDGE'		then Duration else 0 end)/1000.0 AS EDGE,
					sum( case when PrevTechnology like 'R99%'	then Duration else 0 end)/1000.0 AS UMTS_R99,
					sum( case when PrevTechnology = 'HSPA'		then Duration else 0 end)/1000.0 AS HSPA,
					sum( case when PrevTechnology = 'HSPA+'		then Duration else 0 end)/1000.0 AS [HSPA+],
					sum( case when PrevTechnology = 'HSDPA'		then Duration else 0 end)/1000.0 AS [HSDPA],
					sum( case when PrevTechnology = 'HSUPA'		then Duration else 0 end)/1000.0 AS [HSUPA],
					sum( case when PrevTechnology = 'HSPA DC'	then Duration else 0 end)/1000.0 AS [HSPA DC],
					sum( case when PrevTechnology = 'HSDPA+'	then Duration else 0 end)/1000.0 AS [HSDPA+],
					sum( case when PrevTechnology = 'LTE'		then Duration else 0 end)/1000.0 AS [LTE],
					sum( case when PrevTechnology = 'LTE CA'	then Duration else 0 end)/1000.0 AS [LTE CA],
					sum( case when PrevTechnology = 'Wifi'		then Duration else 0 end)/1000.0 AS [Wifi],
					SUM (Duration)/1000.0														 AS [Data Technology Duration]
			
				from Technology
				group by SessionId,testid
			) tec
			left outer join 
			(
				SELECT 
					testid,
					SUM(TechnologyDuration)/1000.0																		 AS [RAT Technology Duration],
					SUM(CASE WHEN Technology LIKE 'GSM 900'					THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_GSM_900],
					SUM(CASE WHEN Technology LIKE 'GSM 1800'				THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_GSM_1800],
					SUM(CASE WHEN Technology LIKE 'GSM 1900'				THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_GSM_1900],
				
					SUM(CASE WHEN Technology LIKE 'UMTS 850'				THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_850],
					SUM(CASE WHEN Technology LIKE 'UMTS 900'				THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_900],
					SUM(CASE WHEN Technology LIKE 'UMTS 1700'				THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_1700],
					SUM(CASE WHEN Technology LIKE 'UMTS 1900'				THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_1900],
					SUM(CASE WHEN Technology LIKE 'UMTS 2100'				THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_UMTS_2100],
					
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 28' OR Technology LIKE 'LTE E-UTRA 12'			
																			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_700],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 20'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_800],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 8'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_900],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 10'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_1700],			
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 3'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_1800],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 2'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_1900],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 38'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_TDD_2600],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 1'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_2100],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 40'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_2300],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 7'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_2600],
					SUM(CASE WHEN Technology LIKE 'LTE E-UTRA 41'			THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_LTE_TDD_2500],
						
					SUM(CASE WHEN Technology in('No service','Emergency calls only') THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_No_Service],
					SUM(CASE WHEN Technology in('Status not available','unknown')	 THEN  TechnologyDuration ELSE 0 END)/1000.0	 AS [TIME_Unknown]	
				
			FROM vTechnologyDurationTest
			GROUP BY testid
			)rtec on tec.TestId=rtec.TestId
			left outer join
			(
			select 
			testid,
				case when Unknown>0 then 'Unknown' else  -- Status not available
					case when No_Service>0 and (GSM<>0 or UMTS<>0 or LTE<>0) then  'Partially_No_Service' else  				
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
						 testid,	  
						 SUM(case when SUBSTRING(technology,1,4)='GSM'						then 1 else 0 end) as GSM,
						 SUM(case when SUBSTRING(technology,1,4)='UMTS'						then 1 else 0 end) as UMTS,
						 SUM(case when SUBSTRING(technology,1,4)='LTE'						then 1 else 0 end) as LTE,
						 SUM(case when technology IN ('No service','Emergency calls only')	then 1 else 0 end) as No_Service,
						 SUM(case when technology IN ('Status not available','unknown')		then 1 else 0 end) as Unknown
					from vTechnologyDurationTest 
					group by testid
				) t 
			) t2 on rtec.testid=t2.testid
			where tec.TestId<>0
		end
	END
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script Execution Completed!')

-- SELECT * FROM NEW_TECH_Test_2018