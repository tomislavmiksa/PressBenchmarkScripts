/*****************************************************************************************************************************************************************************
============================================================================================================================================================================
Projekt: Pressemessung
   Name: UPDATE_NEW_CDR_VOICE_2018 with Operator Specific Data
  Autor: NET CHECK GmbH

  v1.00 Adding all relevant data for VDF CDR in 2017 Table to kick out completly Customer specific Tables and only creating operator views out of it
============================================================================================================================================================================
*****************************************************************************************************************************************************************************/

----------------------------------------------
-- STEP 1: Automatic Failure Classification --
----------------------------------------------
PRINT ('Updating CDR with Automatic Failure Classification...')
	UPDATE NEW_CDR_VOICE_2018
	SET  [FAILURE_PHASE]		= fc.[FAILURE_PHASE]
		,[FAILURE_SIDE]			= fc.[FAILURE_SIDE]
		,[FAILURE_TECHNOLOGY]	= fc.[TECHNOLOGY]
		,[FAILURE_CLASS]		= fc.[FAILURE_CLASS]
		,[FAILURE_CATEGORY]		= fc.[FAILURE_CATEGORY]
		,[FAILURE_SUBCATEGORY]	= fc.[FAILURE_SUBCATEGORY]
		,[COMMENT]				= CAST('-AUTO FC-' + CHAR(13) as nvarchar(max)) + CAST(fc.[COMMENT] as nvarchar(max))
	FROM [NC_FailureClassification_Automatic] fc
	  JOIN NEW_CDR_VOICE_2018 cdr ON cdr.SessionId_PRIM_KEY = fc.[SESSIONID]

-------------------------------------------
-- STEP 2: Manual Failure Classification --
-------------------------------------------
PRINT ('Updating Manual/Final Failure Classification Information Updated')
	UPDATE NEW_CDR_VOICE_2018
	SET  [FAILURE_PHASE]		= (CASE 
									WHEN fc.[FAILURE_PHASE] is not null THEN fc.[FAILURE_PHASE]
									ELSE cdr.[FAILURE_PHASE]
									END)
		,[FAILURE_SIDE]			= CASE 
									WHEN fc.[FAILURE_SIDE] is not null THEN fc.[FAILURE_SIDE]
									ELSE cdr.[FAILURE_SIDE]
									END
		,[FAILURE_TECHNOLOGY]	= CASE 
									WHEN fc.[FAILURE_TECHNOLOGY] is not null THEN fc.[FAILURE_TECHNOLOGY]
									ELSE cdr.[FAILURE_TECHNOLOGY]
									END
		,[FAILURE_CLASS]		= CASE 
									WHEN fc.[FAILURE_CLASS] is not null THEN fc.[FAILURE_CLASS]
									ELSE cdr.[FAILURE_CLASS]
									END
		,[FAILURE_CATEGORY]		= CASE 
									WHEN fc.[FAILURE_CATEGORY] is not null THEN fc.[FAILURE_CATEGORY]
									ELSE cdr.[FAILURE_CATEGORY]
									END
		,[FAILURE_SUBCATEGORY]	= CASE 
									WHEN fc.[FAILURE_SUBCATEGORY] is not null THEN fc.[FAILURE_SUBCATEGORY]
									ELSE cdr.[FAILURE_SUBCATEGORY]
									END
		,[COMMENT]				= CASE 
									WHEN fc.[FAILURE_COMMENT] is not null THEN fc.[FAILURE_COMMENT]
									ELSE cdr.[COMMENT]
									END
		,Call_Status			= CASE 
									WHEN fc.[FC_CALL_STATUS] is not null THEN fc.[FC_CALL_STATUS] collate Latin1_General_CI_AS
									ELSE cdr.Call_Status
									END
	FROM NEW_CDR_VOICE_2018 cdr
	 LEFT OUTER JOIN [NC_Failure_Classification_Voice] fc ON cdr.SessionId_PRIM_KEY = fc.[SessionId_A]

	UPDATE NEW_CDR_VOICE_2018
	SET 
		Failure_Phase			= NULL,
		Failure_SIDE			= NULL,
		Failure_Technology		= NULL,	
		Failure_Class			= NULL,	
		Failure_Category		= NULL,	
		Failure_SubCategory		= NULL,	
		Comment					= NULL
	FROM NEW_CDR_VOICE_2018 a
	WHERE a.Validity = 1 AND a.Call_Status LIKE 'Completed'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_VOICE_2018 with System Releases...')
	UPDATE NEW_CDR_VOICE_2018
	SET  Validity = 0
		,Invalid_Reason = 'SwissQual System Release'
	WHERE Call_Status like 'System%' or Call_Status like 'not%'

---------------------------------------------------------------
-- STEP 3: INVALIDATION OF ALL SESSIONS WITH NO G_Levels     --
--         INVALIDATION OF ALL SESSIONS WITH CALL START TIME --
---------------------------------------------------------------
PRINT ('Update CDR A Side with NET CHECK Protocol Data')
	UPDATE NEW_CDR_VOICE_2018
	Set [ProtocolID_A]			= b.ProtocolId
	   ,[MSISDN_A]				= CASE WHEN a.MSISDN_A is not null THEN a.MSISDN_A
									   ELSE c.MSISDN
									   END
	   ,[G_Level_1_A]			= b.Level_1
	   ,[G_Level_2_A]			= b.Level_2
	   ,[G_Level_3_A]			= b.Level_3
	   ,[G_Level_4_A]			= b.Level_4
	   ,[G_Level_5_A]			= b.Level_5
	   ,[G_Remarks_A]			= b.Remarks
	   ,[TrainType_A]			= b.Train_Type
	   ,[TrainName_A]			= b.Train_Name
	   ,[WagonNumber_A]			= b.Wagon_Number
	   ,[WagonRepeter_A]		= b.Repeater_Wagon
	   ,[Channel_A]				= b.Channel
	   ,[Channel_Description_A]	= b.Channel_description
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_GLEVEL_Sessions_2018 b on a.SessionId_A = b.SessionId
	LEFT OUTER JOIN NEW_ImsiMsisdn_2018 c on a.[MO:Dial] between c.Start_Time and c.End_Time and a.IMSI_A like c.IMSI

PRINT ('Update CDR B Side with NET CHECK Protocol Data')
	UPDATE NEW_CDR_VOICE_2018
	Set [ProtocolID_B]			= b.ProtocolId
	   ,[MSISDN_B]				= CASE WHEN a.MSISDN_B is not null THEN a.MSISDN_B
									   ELSE c.MSISDN
									   END
	   ,[G_Level_1_B]			= b.Level_1
	   ,[G_Level_2_B]			= b.Level_2
	   ,[G_Level_3_B]			= b.Level_3
	   ,[G_Level_4_B]			= b.Level_4
	   ,[G_Level_5_B]			= b.Level_5
	   ,[G_Remarks_B]			= b.Remarks
	   ,[TrainType_B]			= b.Train_Type
	   ,[TrainName_B]			= b.Train_Name
	   ,[WagonNumber_B]			= b.Wagon_Number
	   ,[WagonRepeter_B]		= b.Repeater_Wagon
	   ,[Channel_B]				= b.Channel
	   ,[Channel_Description_B]	= b.Channel_description
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN NEW_GLEVEL_Sessions_2018 b on a.SessionId_B = b.SessionId
	LEFT OUTER JOIN NEW_ImsiMsisdn_2018 c on a.[MO:Dial] between c.Start_Time and c.End_Time and a.IMSI_B like c.IMSI

PRINT ('Update CDR with NET CHECK Wrong Protocol Data (invalidated)')
UPDATE NEW_CDR_VOICE_2018
Set Validity = 0, Invalid_Reason = 'NetCheck Protocol Error'
WHERE Validity = 1 and ((G_Level_1_A is null or G_Level_2_A is null or G_Level_1_A like '' or G_Level_2_A like '') or [MO:Dial] is null)


----------------------------------------------------------------
-- STEP 4: INVALIDATION OF ALL Manual Testing System Failures --
-- Writting Validation Results                                --
----------------------------------------------------------------
	UPDATE NEW_CDR_VOICE_2018
	SET  Validity = 0
		,Invalid_Reason = 'TestingSystemRelease'
	WHERE Failure_Class IN ('Testing system failure', 'SYSTEM ERROR') and [COMMENT] not like '-AUTO%'

	UPDATE NEW_CDR_VOICE_2018
	SET Validity = 0,
		Invalid_Reason = 'UeRelatedProblem' -- select * 
	FROM NEW_CDR_VOICE_2018
	WHERE Failure_Class LIKE 'UE_Problems'

PRINT ('Testing System Failure Information Updated (invalidated)')

----------------------------------------------------------------
-- STEP 5: VODAFONE REGIONS AND VENDORS                       --
----------------------------------------------------------------
/*	UPDATE NEW_CDR_VOICE_2018
	SET Region_A = CASE pinA.GroupName
							WHEN 'VF_Region_NORD'		THEN 'Nord'		
							WHEN 'VF_Region_NORD_OST'	THEN 'Nord_Ost'	
							WHEN 'VF_Region_NORD_WEST'	THEN 'Nord_West'
							WHEN 'VF_Region_OST'		THEN 'Ost'		
							WHEN 'VF_Region_RHEIN_MAIN'	THEN 'Rhein_Main'	
							WHEN 'VF_Region_SUED'		THEN 'Süd'		
							WHEN 'VF_Region_SUED_WEST'	THEN 'Süd_West'	
							WHEN 'VF_Region_WEST'		THEN 'West'	 
							END
	   ,Vendor_A = pinA.Description
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN [PolygonRelation] pdA   ON a.StartPosId_A = pdA.PosId
	LEFT OUTER JOIN [PolygonInfo] pinA      ON pdA.PolygonId = pinA.PolygonId 
	WHERE pina.GroupName LIKE  'VF_Region%'

	UPDATE NEW_CDR_VOICE_2018
	SET Region_B = CASE pinA.GroupName
							WHEN 'VF_Region_NORD'		THEN 'Nord'		
							WHEN 'VF_Region_NORD_OST'	THEN 'Nord_Ost'	
							WHEN 'VF_Region_NORD_WEST'	THEN 'Nord_West'
							WHEN 'VF_Region_OST'		THEN 'Ost'		
							WHEN 'VF_Region_RHEIN_MAIN'	THEN 'Rhein_Main'	
							WHEN 'VF_Region_SUED'		THEN 'Süd'		
							WHEN 'VF_Region_SUED_WEST'	THEN 'Süd_West'	
							WHEN 'VF_Region_WEST'		THEN 'West'	 
							END
	   ,Vendor_B = pinA.Description
	FROM NEW_CDR_VOICE_2018 a
	LEFT OUTER JOIN [PolygonRelation] pdA   ON a.StartPosId_B = pdA.PosId
	LEFT OUTER JOIN [PolygonInfo] pinA      ON pdA.PolygonId = pinA.PolygonId 
	WHERE pina.GroupName LIKE  'VF_Region%'
*/

-- Vodafone Region and Vendor from Master DB --
update NEW_CDR_VOICE_2018 
	set Region_A = p2.VF_Region,
		Vendor_A = p2.vendor

from NEW_CDR_VOICE_2018 cdr
join NC_Polygons2 p2 on cdr.SessionId_A = p2.SessionID

update NEW_CDR_VOICE_2018 
	set Region_B = p2.VF_Region,
		Vendor_B = p2.vendor

from NEW_CDR_VOICE_2018 cdr
join NC_Polygons2 p2 on cdr.SessionId_B = p2.SessionID

update NEW_CDR_VOICE_2018 
	set Region_B = Region_A, Vendor_B = Vendor_A

-- delete -AUTO FC- from FC comments --
update NEW_CDR_VOICE_2018 
	set COMMENT = SUBSTRING(comment, 11,500) 
from NEW_CDR_VOICE_2018 
where validity=1 and Call_Status in ('failed','dropped') and [COMMENT]  like '-AUTO%'

-- invalidate calls with FAILURE_CLASS = 'Testing system failure' and Validity = 1 --
update NEW_CDR_VOICE_2018 
	set Validity = 0,
		Invalid_Reason = 'TestingSystemRelease',
		Call_Status = 'System Release' 
where Validity = 1 and FAILURE_CLASS = 'Testing system failure' -- and Call_Status not like 'System Release'

-- set campaign name --
UPDATE NEW_CDR_VOICE_2018 SET Campaign_A = 'Benchmark Q3 2019', Campaign_B = 'Benchmark Q3 2019'

-- invalidation --
update NEW_CDR_VOICE_2018 
	set Validity = 0,
		Invalid_Reason = 'Berlin Suedkreuz test measurement - invalid'
where callstarttimestamp_a between '2019-07-15 15:49:00.000' and '2019-07-15 16:17:59.999' and zone_a = 'system 0'
