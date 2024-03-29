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
	IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NC_FailureClassification_Automatic_D') 
	BEGIN
		update [NEW_CDR_Data_2018]
			set [FAILURE_PHASE]			= ncf.FAILURE_PHASE,
				[FAILURE_TECHNOLOGY]	= ncf.TECHNOLOGY, 
				[FAILURE_CLASS]			= ncf.FAILURE_CLASS,
				[FAILURE_CATEGORY]		= ncf.FAILURE_CATEGORY,
				[FAILURE_SUBCATEGORY]	= ncf.FAILURE_SUBCATEGORY,
				[FAILURE_COMMENT]		= ncf.COMMENT
		from NC_FailureClassification_Automatic_D ncf
		join [NEW_CDR_Data_2018] nct on ncf.TESTID=nct.TestId
	END

-------------------------------------------
-- STEP 2: Manual Failure Classification --
-------------------------------------------
PRINT ('Updating Manual/Final Failure Classification Information Updated')
IF EXISTS (SELECT * FROM  sysobjects WHERE name = N'vNC_Failure_Classification_Data') 
	BEGIN
		UPDATE NEW_CDR_Data_2018  SET 
		Validity				=	MFC_Validity,
		Test_Status				=	fc.MFC_QoS,
		FAILURE_PHASE			=	fc.FAILURE_PHASE,
		FAILURE_TECHNOLOGY		=	fc.FAILURE_TECHNOLOGY,
		FAILURE_CLASS			=	fc.FAILURE_CLASS,
		FAILURE_CATEGORY		=	fc.FAILURE_CATEGORY,
		FAILURE_SUBCATEGORY		=	fc.FAILURE_SUBCATEGORY,	
		FAILURE_COMMENT			=	fc.FAILURE_COMMENT
		FROM NEW_CDR_Data_2018 AS nc
		JOIN vNC_Failure_Classification_Data AS fc ON nc.TestID = fc.TestID 
		WHERE fc.MFC_Validity is not null
	END

	UPDATE NEW_CDR_Data_2018
	SET 
		FAILURE_PHASE			= NULL,
		FAILURE_TECHNOLOGY		= NULL,	
		FAILURE_CLASS			= NULL,	
		FAILURE_SUBCATEGORY		= NULL,	
		FAILURE_CATEGORY		= NULL,	
		FAILURE_COMMENT			= NULL
	FROM NEW_CDR_Data_2018 a
	WHERE a.Validity = 1 AND a.Test_Status LIKE 'Completed'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - UPDATING TABLE: NEW_CDR_DATA_2018 with Failure Classification and data validation information...')
	IF OBJECT_ID ('tempdb..#sysrelease' ) IS NOT NULL DROP TABLE #sysrelease
	SELECT SessionId,MAX(TestId) as TestId
	INTO #sysrelease
	FROM TestInfo a
	WHERE a.SessionId in (SELECT SessionId from Sessions where info like 'System%')
	GROUP BY a.SessionId

	UPDATE NEW_CDR_DATA_2018
		SET Validity = 0, 
			InvalidReason = 'SwissQual System Release'
		WHERE TestId in (SELECT TestId FROM #sysrelease) and Test_Status not like 'Completed'

	UPDATE NEW_CDR_Data_2018
		SET Validity = 0
			,InvalidReason = 'TestingSystemRelease'
	WHERE Failure_Class IN ('Testing system failure', 'SYSTEM ERROR') and FAILURE_COMMENT not like '-AUTO%' and Test_Name not like '%whatsapp%'

	UPDATE NEW_CDR_Data_2018
		SET InvalidReason = 'Capacity test failure'
	WHERE validity = 0 and Failure_Class = 'Testing system failure' and failure_subcategory like 'Capacity test failure' and Test_Name not like '%whatsapp%'

	UPDATE NEW_CDR_Data_2018
		SET Validity = 0,
			InvalidReason = 'UeRelatedProblem' -- select * 
	FROM NEW_CDR_Data_2018
	WHERE Failure_Class LIKE 'UE_Problems'

---------------------------------------------------------------
-- STEP 3: INVALIDATION OF ALL SESSIONS WITH NO G_Levels     --
--         INVALIDATION OF ALL SESSIONS WITH CALL START TIME --
---------------------------------------------------------------
PRINT ('Update CDRwith NET CHECK Protocol Data')
	UPDATE NEW_CDR_Data_2018
	Set [ProtocolID]			= b.ProtocolId
	   ,[MSISDN]				= CASE WHEN a.MSISDN_A is not null THEN a.MSISDN_A
									   ELSE c.MSISDN
									   END
	   ,[G_Level_1]				= b.Level_1
	   ,[G_Level_2]				= b.Level_2
	   ,[G_Level_3]				= b.Level_3
	   ,[G_Level_4]				= b.Level_4
	   ,[G_Level_5]				= b.Level_5
	   ,[Remark]				= b.Remarks
	   ,[Train_Type]			= b.Train_Type
	   ,[Train_Name]			= b.Train_Name
	   ,[Wagon_Number]			= b.Wagon_Number
	   ,Repeater_Wagon			= b.Repeater_Wagon
	   ,[Channel]				= b.Channel
	   ,[Channel_Description]	= b.Channel_description
	FROM NEW_CDR_Data_2018 a
	LEFT OUTER JOIN NEW_GLEVEL_Sessions_2018 b on a.SessionId = b.SessionId
	LEFT OUTER JOIN NEW_ImsiMsisdn_2018 c on a.[Test_Start_Time] between c.Start_Time and c.End_Time and a.IMSI_A like c.IMSI


PRINT ('Update CDR with NET CHECK Wrong Protocol Data (invalidated)')
UPDATE NEW_CDR_Data_2018
Set Validity = 0, InvalidReason = 'NetCheck Protocol Error'
WHERE Validity = 1 and ((G_Level_1 is null or G_Level_2 is null or G_Level_1 like '' or G_Level_2 like '') or [Test_Start_Time] is null)

----------------------------------------------------------------
-- STEP 5: VODAFONE REGIONS AND VENDORS                       --
----------------------------------------------------------------
	UPDATE NEW_CDR_Data_2018
	SET Region = CASE pinA.GroupName
							WHEN 'VF_Region_NORD'		THEN 'Nord'		
							WHEN 'VF_Region_NORD_OST'	THEN 'Nord_Ost'	
							WHEN 'VF_Region_NORD_WEST'	THEN 'Nord_West'
							WHEN 'VF_Region_OST'		THEN 'Ost'		
							WHEN 'VF_Region_RHEIN_MAIN'	THEN 'Rhein_Main'	
							WHEN 'VF_Region_SUED'		THEN 'Süd'		
							WHEN 'VF_Region_SUED_WEST'	THEN 'Süd_West'	
							WHEN 'VF_Region_WEST'		THEN 'West'	 
							END
	   ,Vendor = pinA.Description
	FROM NEW_CDR_Data_2018 a
	LEFT OUTER JOIN [PolygonRelation] pdA   ON a.StartPosId_A = pdA.PosId
	LEFT OUTER JOIN [PolygonInfo] pinA      ON pdA.PolygonId = pinA.PolygonId 
	WHERE pina.GroupName LIKE  'VF_Region%'
	
-- Vodafone Region and Vendor from Master DB --
	--update NEW_CDR_DATA_2018 
	--	set Region = p2.VF_Region,
	--		vendor = p2.vendor

	--from NEW_CDR_DATA_2018 cdr
	--join NC_Polygons2 p2 on cdr.TestId=p2.TestId

-----------------------------------------------------------------------------------------------------------
-- additional whatsapp validation --
/*
update NEW_CDR_DATA_2018 
	set Test_Status = 'Failed' 
from NEW_CDR_DATA_2018 cdr
join NC_FailureClassification_Automatic_D fc on cdr.TestId=fc.TESTID
where Validity=1 and qualityIndication like '%error%' and Test_Name like '%whatsapp%' and fc.comment not like '%successful%'

update NEW_CDR_DATA_2018 
	set Test_Status = 'Completed' 
from NEW_CDR_DATA_2018 cdr
join NC_FailureClassification_Automatic_D fc on cdr.TestId=fc.TESTID
where Validity=1 and qualityIndication like '%error%' and Test_Name like '%whatsapp%' and fc.comment like '%successful%' 

update new_cdr_data_2018 
	set Test_Status = 'Completed'
where validity=1 and qualityindication like '%error%' and Test_Status not like 'completed' and errorcode_message = 'ok' and Test_Name like '%whatsapp%'
-----------------------------------------------------------------------------------------------------------
*/
----------------------------------------------------------------
-- STEP 6: CLEANUP AND CONSISTENCY                            --
----------------------------------------------------------------
	UPDATE NEW_CDR_DATA_2018
		SET Test_Status = 'Failed'
	WHERE Test_Status like '%Fail%'

	UPDATE NEW_CDR_DATA_2018
		SET  Test_Status = 'Invalid'
			,Validity = 0
			,InvalidReason = 'SwissQual Processing Failure'
	WHERE Test_Status is null


--------------------------------------------------------------
-- step 7: invalidation --
--------------------------------------------------------------
-- invalidate tests which are failed due to generic failure --
UPDATE NEW_CDR_Data_2018 
	SET Validity			= 0,
		InvalidReason		= 'Facebook failed due to Cancelled or Initialization Failure'
	where Validity = 1 
		and Test_Name like '%facebook%'
		and ErrorCode_Message in ('Cancelled') 
		and (Failure_Category = 'TCP Connection Errors')

UPDATE NEW_CDR_Data_2018 
	SET Validity			= 0,
		InvalidReason		= 'Facebook failed due to Cancelled or Initialization Failure'
	where Validity = 1 
		and Test_Name like '%facebook%'
		and ErrorCode_Message in ('Initialization failed') 
		and (Failure_Category = 'TCP Connection Errors' or Failure_Category is null)

UPDATE NEW_CDR_Data_2018 
	SET Validity			= 0,
		InvalidReason		= 'Facebook failed due to Generic Failure or Service unavailability'
	where Validity = 1 
		and Test_Name like '%facebook%'
		and ErrorCode_Message in ('Generic failure','Service unavailable')
		and Failure_Category is null

UPDATE NEW_CDR_DATA_2018 
	SET Validity = 0,
		ErrorCode_Message = 'Generic failure',
		InvalidReason = 'Facebook failed due to Generic Failure'				

from NEW_CDR_DATA_2018 where Test_Name like '%face%' and ErrorCode_Message like '%generic%' and validity=1

-- invalidate 503 server error on http upload --
IF OBJECT_ID ('tempdb..#ULServerError') IS NOT NULL   DROP TABLE #ULServerError
select Testid,
	UE_A,
	Validity,
	system_name_a,
	ErrorCode_Message,
	InvalidReason,
	failure_category,
	url,
	HomeOperator,
	DATEPART(day,[Test_Start_Time])	AS Day,
	Test_Status,
	case when AvgRSCP<-105 then 1 else 0 end as AvgRSCP1,
	case when AvgRSRP<-115 then 1 else 0 end as AvgRSRP1, 
	case when AvgRxLev<-95 then 1 else 0 end as AvgRxLev1, 
	AvgRSCP,
	AvgRSRP,
	AvgRxLev,
	case when avgSINR0<3 then 1 else 0 end as SINR01,
	case when AvgEcIo<-15 then 1 else 0 end as AvgEcIo1,
	case when AvgRxQual>6 then 1 else 0 end as AvgRxQual1,
	avgSINR0,
	AvgEcIo,
	AvgRxQual,
	Test_Name
into #ULServerError	 
from NEW_CDR_DATA_2018 
	where validity=1 
	and test_name like '%http UL%' 
	and Test_Status not like 'completed' 
	and FAILURE_COMMENT like '%503 Service Unavailable' 
	order by test_start_time

update NEW_CDR_DATA_2018 
	set validity = 0, 
		InvalidReason = '503 Server Unavailable on UL' 
	where validity=1 
		and testid in (select distinct testid from #ULServerError where AvgRSCP1=0 and AvgRxLev1=0 and AvgRSRP1=0 and SINR01=0 and AvgEcIo1=0 and AvgRxQual1=0)
		and test_name like '%http UL%' 
		and Test_Status not like 'completed' 
		and FAILURE_COMMENT like '%503 Service Unavailable' 


-- invalidate tests without vq-mos --
update NEW_CDR_DATA_2018 
	set Validity=0, 
	InvalidReason='No VQ-MOS - invalid'
WHERE Test_Name LIKE 'YouTube' AND Validity = 1 AND Test_Status LIKE 'Completed' AND AVG_VMOS IS NULL


-- invalidate youtube player error--
IF OBJECT_ID ('tempdb..#YouTubeFailed') IS NOT NULL   DROP TABLE #YouTubeFailed
select 
	ncd.Testid,
--	UE_A,
	Validity,
	system_name_a,
	ErrorCode_Message,
	InvalidReason,
	failure_category,
	url,
	HomeOperator,
	DATEPART(day,[Test_Start_Time])	AS Day,
	Test_Status,
	case when AvgRSCP<-105 then 1 else 0 end as AvgRSCP1,
	case when AvgRSRP<-115 then 1 else 0 end as AvgRSRP1, 
	case when AvgRxLev<-95 then 1 else 0 end as AvgRxLev1, 
	AvgRSCP,
	AvgRSRP,
	AvgRxLev,
	case when avgSINR0<3 then 1 else 0 end as SINR01,
	case when AvgEcIo<-15 then 1 else 0 end as AvgEcIo1,
	case when AvgRxQual>6 then 1 else 0 end as AvgRxQual1,
	avgSINR0,
	AvgEcIo,
	AvgRxQual,
	Test_Name, 
	test_type

into #YouTubeFailed
from NEW_CDR_DATA_2018 ncd
left outer join VideoStatusTrace vst on vst.TestId=ncd.TestID
where Validity = 1 and test_type LIKE 'VideoStreaming'
and Event like 'YouTube player error. Reason: The current video could not be loaded%'

update NEW_CDR_Data_2018 
	set validity = 0, 
	InvalidReason = 'YouTube failed - video can not be loaded - invalid'
	where testid in 
	(
		select distinct testid from #YouTubeFailed where AvgRSCP1=0 and AvgRxLev1=0 and AvgRSRP1=0 and SINR01=0 and AvgEcIo1=0 and AvgRxQual1=0
	)  
	and Validity = 1


UPDATE NEW_CDR_DATA_2018
	SET  Test_Status = 'Invalid'
		,InvalidReason = 'SwissQual Processing Failure'
	WHERE validity = 0 and InvalidReason is null and test_type not like '%ping%'


-- set tests invalid where status = completed and mdr = 0
update new_cdr_data_2018 
	set validity = 0, 
	test_status = 'Invalid', 
	Application_Layer_MDR_kbit_s = NULL, 
	InvalidReason = 'Test Completed but MDR=0 - invalid' 
where validity = 1 and test_status='completed' and Application_Layer_MDR_kbit_s = 0

-- invalidate FDTT failed tests --
update NEW_CDR_DATA_2018 
	set validity=0,
		InvalidReason='Capacity test failure - invalid'
where validity=1 and test_name like 'fdtt http%' and Test_Status not like 'completed' 


-- delete POLQA from Data DB --
delete from NEW_CDR_DATA_2018 where Test_Type = 'POLQA'

-- set right test name for browsing --
update NEW_CDR_DATA_2018 set test_name = 'chip' where Test_Type like '%browser%' and Test_Name like 'Browsing%' and host = 'https://www.chip.de'

-- set missing namings for HomeOperator
update NEW_CDR_DATA_2018 
	set HomeOperator = 
		case when MCC = '[262]' and MNC = '[1]'															then 'Telekom'
			when MCC = '[262]' and MNC = '[2]'															then 'Vodafone'
			when MCC = '[262]' and MNC = '[3]'															then 'o2' 
			when MCC = '' and MNC = '' and APN = 'internet.telekom' and APN_Name = 'Telekom Internet'	then 'Telekom'			
			when MCC = '' and MNC = '' and APN = 'web.vodafone.de' and APN_Name like 'VF DE Web%'		then 'Vodafone'
			when MCC = '' and MNC = '' and APN = 'internet' and APN_Name like 'o2 Internet%'			then 'o2'
		else HomeOperator end

where Validity = 1 and HomeOperator is null 

-- set missing MNC/MCC 
update NEW_CDR_DATA_2018 
	set HomeMCC = case when MCC = '[262]' or (apn in ('internet.telekom','web.vodafone.de','internet'))	then 262 else HomeMCC end,
		HomeMNC = case when MNC = '[1]'																	then 1	   
					when MNC = '[2]'																	then 2
					when MNC = '[3]'																	then 3
					when MNC = '' and APN = 'internet.telekom' and APN_Name = 'Telekom Internet'		then 1			
					when MNC = '' and APN = 'web.vodafone.de' and APN_Name like 'VF DE Web%'			then 2
					when MNC = '' and APN = 'internet' and APN_Name like 'o2 Internet%'					then 3
		else HomeMNC end
 
where Validity = 1 and HomeOperator in ('Telekom','Vodafone','o2') and (homeMNC is null or homemcc is null) 

-- set campaign name --
UPDATE NEW_CDR_DATA_2018 SET Campaign_A = 'Benchmark Q3 2019'
-----------------------------------------------------------------------------------------------------------

/*
-- o2 additional invalidation --
update NEW_CDR_DATA_2018 
	set Validity=0,
		InvalidReason = 'Facebook failed due to Cancelled or Initialization Failure'
where testid in 
(

)
*/
-- diverse invalidation --
update NEW_CDR_DATA_2018 
	set Validity=0,
		InvalidReason = 'SwissQual Processing Failure'
where testid in 
(
	180388626572,180388626573,180388626574,180388626575
)

/*
-- invalidate not visible testids in fc tool --
update NEW_CDR_DATA_2018 
	set Validity = 0, 
		InvalidReason = 'SwissQual Processing Failure' 
where testid in 
(

) 
*/
----------------------------------------------------------------------------------------------------------
-- set missing region/vendor
--update NEW_CDR_DATA_2018 set Region = 'OST', Vendor = 'Huawei' where G_Level_4 = 'Weimar to Bayreuth' and Test_Start_Time between '2019-05-10 08:25:00.000' and '2019-05-10 10:04:59.999' and Region is null


----------------------------------------------------------------------------------------------------------
-- invalidation
update NEW_CDR_DATA_2018 
	set Validity = 0,
		InvalidReason = 'Berlin Suedkreuz test measurement - invalid'
where Test_Start_Time between '2019-07-15 15:49:00.000' and '2019-07-15 16:20:59.999' and zone_a = 'system 0'
