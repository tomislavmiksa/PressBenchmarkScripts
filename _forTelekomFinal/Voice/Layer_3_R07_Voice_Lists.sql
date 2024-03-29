-- CALL STATUS LIST
IF OBJECT_ID ('tempdb..#CallStatus' ) IS NOT NULL DROP TABLE #CallStatus
SELECT DISTINCT
	   [Call_Status]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [Call_Status] asc) as rnk
  INTO #CallStatus
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[Call_Status]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [Call_Status] is not null) AS T1

-- DIALED NUMBER LIST
IF OBJECT_ID ('tempdb..#Dialed' ) IS NOT NULL DROP TABLE #Dialed
SELECT DISTINCT
	   [DialedNumber]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [DialedNumber] asc) as rnk
  INTO #Dialed
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Dialed_Number AS DialedNumber
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Dialed_Number is not null) AS T1

-- L1_Call_Mode_A LIST
IF OBJECT_ID ('tempdb..#L1_callMode_A' ) IS NOT NULL DROP TABLE #L1_callMode_A
SELECT DISTINCT
	   L1_callMode_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by L1_callMode_A asc) as rnk
  INTO #L1_callMode_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Call_Mode_L1_A AS L1_callMode_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Call_Mode_L1_A is not null) AS T1

-- L2_Call_Mode_A LIST
IF OBJECT_ID ('tempdb..#L2_callMode_A' ) IS NOT NULL DROP TABLE #L2_callMode_A
SELECT DISTINCT
	   L2_callMode_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by L2_callMode_A asc) as rnk
  INTO #L2_callMode_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Call_Mode_L2_A AS L2_callMode_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Call_Mode_L2_A is not null) AS T1

-- L1_Call_Mode_B LIST
IF OBJECT_ID ('tempdb..#L1_callMode_B' ) IS NOT NULL DROP TABLE #L1_callMode_B
SELECT DISTINCT
	   L1_callMode_B
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by L1_callMode_B asc) as rnk
  INTO #L1_callMode_B
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Call_Mode_L1_B AS L1_callMode_B
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Call_Mode_L1_B is not null) AS T1

-- L2_Call_Mode_B LIST
IF OBJECT_ID ('tempdb..#L2_callMode_B' ) IS NOT NULL DROP TABLE #L2_callMode_B
SELECT DISTINCT
	   L2_callMode_B
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by L2_callMode_B asc) as rnk
  INTO #L2_callMode_B
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Call_Mode_L2_B AS L2_callMode_B
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Call_Mode_L2_B is not null) AS T1

-- CHANNELS
IF OBJECT_ID ('tempdb..#Channel_A' ) IS NOT NULL DROP TABLE #Channel_A
SELECT DISTINCT
	   Channel_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [Channel_A] asc) as rnk
  INTO #Channel_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Channel_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Channel_A is not null) AS T1

IF OBJECT_ID ('tempdb..#Channel_B' ) IS NOT NULL DROP TABLE #Channel_B
SELECT DISTINCT
	   Channel_B
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [Channel_B] asc) as rnk
  INTO #Channel_B
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Channel_B
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Channel_B is not null) AS T1

--SYSTEM A LIST
IF OBJECT_ID ('tempdb..#SystemA' ) IS NOT NULL DROP TABLE #SystemA
SELECT DISTINCT
	   [System_A]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [System_A] asc) as rnk
  INTO #SystemA
  FROM (SELECT DISTINCT
			1 as Partitioning,
			System_Name_A AS [System_A]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and System_Name_A is not null) AS T1

--UE_A LIST
IF OBJECT_ID ('tempdb..#UEA' ) IS NOT NULL DROP TABLE #UEA
SELECT DISTINCT
	   [UE_A]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [UE_A]asc) as rnk
  INTO #UEA
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[UE_A]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [UE_A] is not null) AS T1

--IMEI_A LIST
IF OBJECT_ID ('tempdb..#IMEIA' ) IS NOT NULL DROP TABLE #IMEIA
SELECT DISTINCT
	   [IMEI_A]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [IMEI_A] asc) as rnk
  INTO #IMEIA
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[IMEI_A]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [IMEI_A] is not null) AS T1

--IMSI_A LIST
IF OBJECT_ID ('tempdb..#IMSIA' ) IS NOT NULL DROP TABLE #IMSIA
SELECT DISTINCT
	   [IMSI_A]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [IMSI_A] asc) as rnk
  INTO #IMSIA
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[IMSI_A]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [IMSI_A] is not null) AS T1
--SYSTEM A LIST
IF OBJECT_ID ('tempdb..#SystemB' ) IS NOT NULL DROP TABLE #SystemB
SELECT DISTINCT
	   [System_B]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [System_B] asc) as rnk
  INTO #SystemB
  FROM (SELECT DISTINCT
			1 as Partitioning,
			System_Name_B AS [System_B]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and System_Name_B is not null) AS T1

--UE_A LIST
IF OBJECT_ID ('tempdb..#UEB' ) IS NOT NULL DROP TABLE #UEB
SELECT DISTINCT
	   [UE_B]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [UE_B]asc) as rnk
  INTO #UEB
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[UE_B]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [UE_B] is not null) AS T1

--IMEI_A LIST
IF OBJECT_ID ('tempdb..#IMEIB' ) IS NOT NULL DROP TABLE #IMEIB
SELECT DISTINCT
	   [IMEI_B]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [IMEI_B] asc) as rnk
  INTO #IMEIB
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[IMEI_B]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [IMEI_B] is not null) AS T1

--IMSI_A LIST
IF OBJECT_ID ('tempdb..#IMSIB' ) IS NOT NULL DROP TABLE #IMSIB
SELECT DISTINCT
	   [IMSI_B]
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by [IMSI_B] asc) as rnk
  INTO #IMSIB
  FROM (SELECT DISTINCT
			1 as Partitioning,
			[IMSI_B]
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [IMSI_B] is not null) AS T1

--Year LIST
IF OBJECT_ID ('tempdb..#Year' ) IS NOT NULL DROP TABLE #Year
SELECT DISTINCT
	   Year
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Year asc) as rnk
  INTO #Year
  FROM (SELECT DISTINCT
			1 as Partitioning,
			DATEPART(year,[MO:Dial]) AS Year
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and [MO:Dial] is not null) AS T1

--Month LIST
IF OBJECT_ID ('tempdb..#Month' ) IS NOT NULL DROP TABLE #Month
SELECT DISTINCT
	   Month
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Month asc) as rnk
  INTO #Month
  FROM (SELECT DISTINCT
			1 as Partitioning,
			DATEPART(month,[MO:Dial]) as Month
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and DATEPART(month,[MO:Dial]) is not null) AS T1

--Week LIST
IF OBJECT_ID ('tempdb..#Week' ) IS NOT NULL DROP TABLE #Week
SELECT DISTINCT
	   Week
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Week asc) as rnk
  INTO #Week
  FROM (SELECT DISTINCT
			1 as Partitioning,
			DATEPART(week,[MO:Dial]) as Week
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and DATEPART(week,[MO:Dial]) is not null) AS T1

--Day LIST
IF OBJECT_ID ('tempdb..#Day' ) IS NOT NULL DROP TABLE #Day
SELECT DISTINCT
	   Day
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Day asc) as rnk
  INTO #Day
  FROM (SELECT DISTINCT
			1 as Partitioning,
			DATEPART(day,[MO:Dial]) as Day
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and DATEPART(day,[MO:Dial]) is not null) AS T1
--Hour LIST
IF OBJECT_ID ('tempdb..#Hour' ) IS NOT NULL DROP TABLE #Hour
SELECT DISTINCT
	   Hour
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by Hour asc) as rnk
  INTO #Hour
  FROM (SELECT DISTINCT
			1 as Partitioning,
			DATEPART(hour,[MO:Dial]) as Hour
		FROM [NEW_CDR_VOICE_2018_TDG]
		Where Validity=1 and DATEPART(hour,[MO:Dial]) is not null) AS T1

--VDF_Region LIST
IF OBJECT_ID ('tempdb..#VDF_Region' ) IS NOT NULL DROP TABLE #VDF_Region
SELECT DISTINCT
	   VDF_Region_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by VDF_Region_A asc) as rnk
  INTO #VDF_Region
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Region_A as VDF_Region_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		Where Validity=1 and Region_A is not null) AS T1

--VDF_Vendor LIST
IF OBJECT_ID ('tempdb..#VDF_Vendor' ) IS NOT NULL DROP TABLE #VDF_Vendor
SELECT DISTINCT
	   VDF_Vendor_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by VDF_Vendor_A asc) as rnk
  INTO #VDF_Vendor
  FROM (SELECT DISTINCT
			1 as Partitioning,
			Vendor_A as VDF_Vendor_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and Vendor_A is not null) AS T1

--G_Level_1_A LIST
IF OBJECT_ID ('tempdb..#G_Level_1_A' ) IS NOT NULL DROP TABLE #G_Level_1_A
SELECT DISTINCT
	   G_Level_1_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_1_A asc) as rnk
  INTO #G_Level_1_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_1_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		WHERE Validity=1 and G_Level_1_A is not null) AS T1

--G_Level_2_A LIST
IF OBJECT_ID ('tempdb..#G_Level_2_A' ) IS NOT NULL DROP TABLE #G_Level_2_A
SELECT DISTINCT
	   G_Level_2_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_2_A asc) as rnk
  INTO #G_Level_2_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_2_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		Where Validity=1 and G_Level_2_A is not null) AS T1

--G_Level_3_A LIST
IF OBJECT_ID ('tempdb..#G_Level_3_A' ) IS NOT NULL DROP TABLE #G_Level_3_A
SELECT DISTINCT
	   G_Level_3_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_3_A asc) as rnk
  INTO #G_Level_3_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_3_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		Where Validity=1 and G_Level_3_A is not null) AS T1

--G_Level_4_A LIST
IF OBJECT_ID ('tempdb..#G_Level_4_A' ) IS NOT NULL DROP TABLE #G_Level_4_A
SELECT DISTINCT
	   G_Level_4_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_4_A asc) as rnk
  INTO #G_Level_4_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			G_Level_4_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		Where Validity=1 and G_Level_4_A is not null) AS T1
--G_Level_5_A LIST
IF OBJECT_ID ('tempdb..#G_Level_5_A' ) IS NOT NULL DROP TABLE #G_Level_5_A
SELECT DISTINCT
	   G_Level_5_A
	   ,ROW_NUMBER() over (PARTITION BY (Partitioning) order by G_Level_5_A asc) as rnk
  INTO #G_Level_5_A
  FROM (SELECT DISTINCT
			1 as Partitioning,
			CAST(G_Level_5_A as varchar(max)) as G_Level_5_A
		FROM [NEW_CDR_VOICE_2018_TDG]
		Where Validity=1 and G_Level_5_A is not null and G_Level_5_A not like '') AS T1

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_SELECTIONLIST_2018_TDG_Voice')					DROP Table NEW_SELECTIONLIST_2018_TDG_Voice
-- JOIN ALL TOGETHER
IF OBJECT_ID ('tempdb..#rnk' ) IS NOT NULL DROP TABLE #rnk
SELECT DISTINCT rnk
 INTO #rnk
 FROM ( SELECT rnk from #CallStatus
		UNION ALL SELECT rnk from #SystemA  
		UNION ALL SELECT rnk from #Dialed   
		UNION ALL SELECT rnk from #UEA		
		UNION ALL SELECT rnk from #IMEIA	
		UNION ALL SELECT rnk from #IMSIA
		UNION ALL SELECT rnk from #L1_callMode_A
		UNION ALL SELECT rnk from #L2_callMode_A
		UNION ALL SELECT rnk from #G_Level_1_A
		UNION ALL SELECT rnk from #G_Level_2_A
		UNION ALL SELECT rnk from #G_Level_3_A
		UNION ALL SELECT rnk from #G_Level_4_A
		UNION ALL SELECT rnk from #G_Level_5_A
		UNION ALL SELECT rnk from #VDF_Region
		UNION ALL SELECT rnk from #VDF_Vendor
		UNION ALL SELECT rnk from #SystemB  
		UNION ALL SELECT rnk from #UEB		
		UNION ALL SELECT rnk from #IMEIB	
		UNION ALL SELECT rnk from #IMSIB	
		UNION ALL SELECT rnk from #L1_callMode_B
		UNION ALL SELECT rnk from #L2_callMode_B
		UNION ALL SELECT rnk from #Year		
		UNION ALL SELECT rnk from #Month	
		UNION ALL SELECT rnk from #Week		
		UNION ALL SELECT rnk from #Day		
		UNION ALL SELECT rnk from #Hour	
		UNION ALL SELECT rnk from #Channel_A
		UNION ALL SELECT rnk from #Channel_B	
) AS T1

SELECT   rnk.rnk
        ,ty.[Year]
        ,tm.[Month]
        ,tw.[Week]
        ,td.[Day]
        ,th.[Hour]
		,cs.Call_Status
		,da.DialedNumber
		,sa.System_A
		,ua.UE_A
		,cha.Channel_A
		,imeia.IMEI_A
		,imsia.IMSI_A
		,cm1a.L1_callMode_A
		,cm2a.L2_callMode_A
		,g1.G_Level_1_A	 
		,g2.G_Level_2_A	 
		,g3.G_Level_3_A	 
		,g4.G_Level_4_A	
		,g5.G_Level_5_A
		,vfr.VDF_Region_A
		,vfv.VDF_Vendor_A 
		,sb.System_B
		,ub.UE_B
		,chb.Channel_B
		,imeib.IMEI_B
		,imsib.IMSI_B
		,cm1b.L1_callMode_B
		,cm2b.L2_callMode_B
INTO NEW_SELECTIONLIST_2018_TDG_Voice
FROM #rnk rnk
FULL JOIN #CallStatus cs		ON cs.rnk			= rnk.rnk
FULL JOIN #SystemA  sa			ON sa.rnk			= rnk.rnk
FULL JOIN #Dialed   da			ON da.rnk			= rnk.rnk
FULL JOIN #UEA		ua			ON ua.rnk			= rnk.rnk
FULL JOIN #IMEIA	imeia		ON imeia.rnk		= rnk.rnk
FULL JOIN #IMSIA	imsia		ON imsia.rnk		= rnk.rnk
FULL JOIN #SystemB  sb			ON sb.rnk			= rnk.rnk
FULL JOIN #UEB		ub			ON ub.rnk			= rnk.rnk
FULL JOIN #IMEIB	imeib		ON imeib.rnk		= rnk.rnk
FULL JOIN #IMSIB	imsib		ON imsib.rnk		= rnk.rnk
FULL JOIN #L1_callMode_A cm1a	ON cm1a.rnk			= rnk.rnk
FULL JOIN #L2_callMode_A cm2a	ON cm2a.rnk			= rnk.rnk
FULL JOIN #L1_callMode_B cm1b	ON cm1b.rnk			= rnk.rnk
FULL JOIN #L2_callMode_B cm2b	ON cm2b.rnk			= rnk.rnk
FULL JOIN #Year			 ty		ON ty.rnk			= rnk.rnk
FULL JOIN #Month		 tm		ON tm.rnk			= rnk.rnk
FULL JOIN #Week			 tw		ON tw.rnk			= rnk.rnk
FULL JOIN #Day			 td		ON td.rnk			= rnk.rnk
FULL JOIN #Hour			 th		ON th.rnk			= rnk.rnk
FULL JOIN #G_Level_1_A	 g1		ON g1.rnk			= rnk.rnk
FULL JOIN #G_Level_2_A	 g2		ON g2.rnk			= rnk.rnk
FULL JOIN #G_Level_3_A	 g3		ON g3.rnk			= rnk.rnk
FULL JOIN #G_Level_4_A	 g4		ON g4.rnk			= rnk.rnk
FULL JOIN #G_Level_5_A	 g5		ON g5.rnk			= rnk.rnk
FULL JOIN #VDF_Region   vfr		ON vfr.rnk			= rnk.rnk
FULL JOIN #VDF_Vendor   vfv		ON vfv.rnk			= rnk.rnk
FULL JOIN #Channel_A    cha		ON cha.rnk			= rnk.rnk
FULL JOIN #Channel_B    chb		ON chb.rnk			= rnk.rnk

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

IF object_id(N'vNEW_SELECTIONLIST_2018_TDG_Voice') IS NOT NULL	DROP VIEW [vNEW_SELECTIONLIST_2018_TDG_Voice]
GO 

CREATE VIEW [dbo].[vNEW_SELECTIONLIST_2018_TDG_Voice]
AS
SELECT  

* 
FROM NEW_SELECTIONLIST_2018_TDG_Voice

--SELECT * FROM NEW_SELECTIONLIST_2018 ORDER BY rnk