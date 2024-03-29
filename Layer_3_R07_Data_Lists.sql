-- CALL STATUS LIST
IF OBJECT_ID ('tempdb..#CallStatus' ) IS NOT NULL DROP TABLE #CallStatus
SELECT DISTINCT
	   QoS
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by QoS asc) as rnk
  INTO #CallStatus
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Test_Status AS QoS
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and Test_Status is not null) AS T1

IF OBJECT_ID ('tempdb..#Type_of_Test' ) IS NOT NULL DROP TABLE #Type_of_Test
SELECT DISTINCT
	   Type_of_Test
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Type_of_Test asc) as rnk
  INTO #Type_of_Test
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Test_Type AS Type_of_Test
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and Test_Type is not null) AS T1

IF OBJECT_ID ('tempdb..#Test_Name' ) IS NOT NULL DROP TABLE #Test_Name
SELECT DISTINCT
	   Test_Name
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Test_Name asc) as rnk
  INTO #Test_Name
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Test_Name
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and Test_Name is not null) AS T1

IF OBJECT_ID ('tempdb..#Test_Info' ) IS NOT NULL DROP TABLE #Test_Info
SELECT DISTINCT
	   Test_Info
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Test_Info asc) as rnk
  INTO #Test_Info
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Test_Info
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and Test_Info is not null) AS T1

IF OBJECT_ID ('tempdb..#Direction' ) IS NOT NULL DROP TABLE #Direction
SELECT DISTINCT
	   Direction
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Direction asc) as rnk
  INTO #Direction
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Direction
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and Direction is not null) AS T1

IF OBJECT_ID ('tempdb..#Threads' ) IS NOT NULL DROP TABLE #Threads
SELECT DISTINCT
	   Threads
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Threads asc) as rnk
  INTO #Threads
  FROM (SELECT 1 as Partitioning,
			'ST' AS Threads
		union ALL 
		SELECT 1 as Partitioning,
			'MT' AS Threads) AS T1

--SYSTEM A LIST
IF OBJECT_ID ('tempdb..#System' ) IS NOT NULL DROP TABLE #System
SELECT DISTINCT
	   [System]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [System] asc) as rnk
  INTO #System
  FROM (SELECT DISTINCT
			1 as Partitioning,
			System_Type_A as System
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and System_Type_A is not null) AS T1

--CHANNEL A LIST
IF OBJECT_ID ('tempdb..#Channel' ) IS NOT NULL DROP TABLE #Channel
SELECT DISTINCT
	   [Channel]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [Channel] asc) as rnk
  INTO #Channel
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[Channel]
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and [Channel] is not null) AS T1

--UE_A LIST
IF OBJECT_ID ('tempdb..#UE' ) IS NOT NULL DROP TABLE #UE
SELECT DISTINCT
	   [UE]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [UE] asc) as rnk
  INTO #UE
  FROM (SELECT DISTINCT
			1 as Partitioning,
			UE_A as UE
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and UE_A is not null) AS T1

--IMEI_A LIST
IF OBJECT_ID ('tempdb..#IMEI' ) IS NOT NULL DROP TABLE #IMEI
SELECT DISTINCT
	   [IMEI]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [IMEI] asc) as rnk
  INTO #IMEI
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[IMEI_A] as IMEI
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and [IMEI_A] is not null) AS T1

--IMSI LIST
IF OBJECT_ID ('tempdb..#IMSI' ) IS NOT NULL DROP TABLE #IMSI
SELECT DISTINCT
	   [IMSI]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [IMSI] asc) as rnk
  INTO #IMSI
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[IMSI_A] as IMSI
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and [IMSI_A] is not null) AS T1

--Year LIST
IF OBJECT_ID ('tempdb..#Year' ) IS NOT NULL DROP TABLE #Year
SELECT DISTINCT
	   Year
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Year asc) as rnk
  INTO #Year
  FROM (SELECT DISTINCT
			1 as Partitioning,
			datepart(year,Test_Start_Time) AS Year
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and datepart(year,Test_Start_Time) is not null) AS T1

--Month LIST
IF OBJECT_ID ('tempdb..#Month' ) IS NOT NULL DROP TABLE #Month
SELECT DISTINCT
	   Month
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Month asc) as rnk
  INTO #Month
  FROM (SELECT DISTINCT
			1 as Partitioning,
			datepart(month,Test_Start_Time) as Month
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and datepart(month,Test_Start_Time) is not null) AS T1

--Week LIST
IF OBJECT_ID ('tempdb..#Week' ) IS NOT NULL DROP TABLE #Week
SELECT DISTINCT
	   Week
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Week asc) as rnk
  INTO #Week
  FROM (SELECT DISTINCT
			1 as Partitioning,
			datepart(week,Test_Start_Time) as Week
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and datepart(week,Test_Start_Time) is not null) AS T1

--Day LIST
IF OBJECT_ID ('tempdb..#Day' ) IS NOT NULL DROP TABLE #Day
SELECT DISTINCT
	   Day
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Day asc) as rnk
  INTO #Day
  FROM (SELECT DISTINCT
			1 as Partitioning,
			datepart(day,Test_Start_Time) as Day
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and datepart(day,Test_Start_Time) is not null) AS T1

--Hour LIST
IF OBJECT_ID ('tempdb..#Hour' ) IS NOT NULL DROP TABLE #Hour
SELECT DISTINCT
	   Hour
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Hour asc) as rnk
  INTO #Hour
  FROM (SELECT DISTINCT
			1 as Partitioning,
			datepart(hour,Test_Start_Time) as Hour
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and datepart(hour,Test_Start_Time) is not null) AS T1

--VDF_Region LIST
IF OBJECT_ID ('tempdb..#VDF_Region' ) IS NOT NULL DROP TABLE #VDF_Region
SELECT DISTINCT
	   VDF_Region
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by VDF_Region asc) as rnk
  INTO #VDF_Region
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Region as VDF_Region
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and Region is not null) AS T1

--VDF_Vendor LIST
IF OBJECT_ID ('tempdb..#VDF_Vendor' ) IS NOT NULL DROP TABLE #VDF_Vendor
SELECT DISTINCT
	   VDF_Vendor
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by VDF_Vendor asc) as rnk
  INTO #VDF_Vendor
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Vendor as VDF_Vendor
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and Vendor is not null) AS T1

--G_Level_1 LIST
IF OBJECT_ID ('tempdb..#G_Level_1' ) IS NOT NULL DROP TABLE #G_Level_1
SELECT DISTINCT
	   G_Level_1
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_1 asc) as rnk
  INTO #G_Level_1
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_1
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and G_Level_1 is not null) AS T1

--G_Level_2 LIST
IF OBJECT_ID ('tempdb..#G_Level_2' ) IS NOT NULL DROP TABLE #G_Level_2
SELECT DISTINCT
	   G_Level_2
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_2 asc) as rnk
  INTO #G_Level_2
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_2
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and G_Level_2 is not null) AS T1

--G_Level_3 LIST
IF OBJECT_ID ('tempdb..#G_Level_3' ) IS NOT NULL DROP TABLE #G_Level_3
SELECT DISTINCT
	   G_Level_3
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_3 asc) as rnk
  INTO #G_Level_3
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_3
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and G_Level_3 is not null) AS T1

--G_Level_4 LIST
IF OBJECT_ID ('tempdb..#G_Level_4' ) IS NOT NULL DROP TABLE #G_Level_4
SELECT DISTINCT
	   G_Level_4
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_4 asc) as rnk
  INTO #G_Level_4
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_4
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and G_Level_4 is not null) AS T1

--G_Level_5 LIST
IF OBJECT_ID ('tempdb..#G_Level_5' ) IS NOT NULL DROP TABLE #G_Level_5
SELECT DISTINCT
	   G_Level_5
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_5 asc) as rnk
  INTO #G_Level_5
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_5
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and G_Level_5 is not null and G_Level_5 not like '') AS T1

IF OBJECT_ID ('tempdb..#RAT' ) IS NOT NULL DROP TABLE #RAT
SELECT DISTINCT
	   RAT
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by RAT asc) as rnk
  INTO #RAT
  FROM (SELECT DISTINCT
			1 as Partitioning,
			RAT
		FROM NEW_CDR_Data_2018
		WHERE Validity = 1 and RAT is not null) AS T1

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_DATA_SELECTIONLIST')					DROP Table NEW_DATA_SELECTIONLIST
-- JOIN ALL TOGETHER
IF OBJECT_ID ('tempdb..#rnk' ) IS NOT NULL DROP TABLE #rnk
SELECT DISTINCT rnk
 INTO #rnk
 FROM ( SELECT rnk from #CallStatus
		UNION ALL SELECT rnk from #Type_of_Test
		UNION ALL SELECT rnk from #Test_Name
		UNION ALL SELECT rnk from #Test_Info
		UNION ALL SELECT rnk from #Direction
		UNION ALL SELECT rnk from #Threads
		UNION ALL SELECT rnk from #System
		UNION ALL SELECT rnk from #Channel
		UNION ALL SELECT rnk from #UE
		UNION ALL SELECT rnk from #IMEI
		UNION ALL SELECT rnk from #IMSI	
		UNION ALL SELECT rnk from #Month	
		UNION ALL SELECT rnk from #Week		
		UNION ALL SELECT rnk from #Day		
		UNION ALL SELECT rnk from #Hour		
		UNION ALL SELECT rnk from #G_Level_1
		UNION ALL SELECT rnk from #G_Level_2
		UNION ALL SELECT rnk from #G_Level_3
		UNION ALL SELECT rnk from #G_Level_4
		UNION ALL SELECT rnk from #G_Level_5
		UNION ALL SELECT rnk from #VDF_Region
		UNION ALL SELECT rnk from #VDF_Vendor
		UNION ALL SELECT rnk from #RAT) AS T1

SELECT   rnk.rnk
		,cs.QoS				
		,tt.Type_of_Test				
		,tn.Test_Name				
		,ti.Test_Info				
		,di.Direction				
		,th.Threads					
		,sy.System					
		,ch.Channel					
		,ue.UE						
		,ie.IMEI						
		,ii.IMSI						
		,ty.Year						
		,tm.Month					
		,tw.Week						
		,td.Day						
		,thh.Hour						
		,g1.G_Level_1				
		,g2.G_Level_2				
		,g3.G_Level_3				
		,g4.G_Level_4	
		,g5.G_Level_5			
		,vfr.VDF_Region   			
		,vfv.VDF_Vendor
		,rat.RAT
INTO NEW_DATA_SELECTIONLIST
FROM #rnk rnk
FULL JOIN #CallStatus	 cs			ON cs.rnk			= rnk.rnk 
FULL JOIN #Type_of_Test	 tt			ON tt.rnk			= rnk.rnk 
FULL JOIN #Test_Name	 tn			ON tn.rnk			= rnk.rnk 
FULL JOIN #Test_Info	 ti			ON ti.rnk			= rnk.rnk 
FULL JOIN #Direction	 di			ON di.rnk			= rnk.rnk 
FULL JOIN #Threads		 th			ON th.rnk			= rnk.rnk 
FULL JOIN #System		 sy			ON sy.rnk			= rnk.rnk 
FULL JOIN #Channel		 ch			ON ch.rnk			= rnk.rnk 
FULL JOIN #UE			 ue			ON ue.rnk			= rnk.rnk 
FULL JOIN #IMEI			 ie			ON ie.rnk			= rnk.rnk 
FULL JOIN #IMSI			 ii			ON ii.rnk			= rnk.rnk 
FULL JOIN #Year			 ty			ON ty.rnk			= rnk.rnk
FULL JOIN #Month		 tm			ON tm.rnk			= rnk.rnk
FULL JOIN #Week			 tw			ON tw.rnk			= rnk.rnk
FULL JOIN #Day			 td			ON td.rnk			= rnk.rnk
FULL JOIN #Hour			 thh		ON thh.rnk			= rnk.rnk
FULL JOIN #G_Level_1	 g1			ON g1.rnk			= rnk.rnk
FULL JOIN #G_Level_2	 g2			ON g2.rnk			= rnk.rnk
FULL JOIN #G_Level_3	 g3			ON g3.rnk			= rnk.rnk
FULL JOIN #G_Level_4	 g4			ON g4.rnk			= rnk.rnk
FULL JOIN #G_Level_5	 g5			ON g5.rnk			= rnk.rnk
FULL JOIN #VDF_Region   vfr			ON vfr.rnk			= rnk.rnk
FULL JOIN #VDF_Vendor   vfv			ON vfv.rnk			= rnk.rnk
FULL JOIN #rat			rat			ON rat.rnk			= rnk.rnk

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- History 
-- v01. -> Create 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Alte Tabellen mit Daten löschen--------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF object_id(N'vNEW_DATA_SELECTIONLIST') IS NOT NULL	DROP VIEW vNEW_DATA_SELECTIONLIST
GO 

CREATE VIEW [dbo].[vNEW_DATA_SELECTIONLIST]
AS
SELECT  
* 
FROM NEW_DATA_SELECTIONLIST

--SELECT * FROM vNEW_DATA_SELECTIONLIST