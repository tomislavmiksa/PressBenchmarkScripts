------------------------------------------------------------------------------
-- CREATE and FILL NC_Polygons2
--
--
-- created by Andreas Nagorsen 
-- v01 2017-12-19 AN: initial Version
--
------------------------------------------------------------------------------
-- Remarks:
-- 28.02.2019: Added Vodafone Region/Vendor to NC_Polygons table  -- Nedzad Cohodarevic	
--
--
--
--
--
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- DROP TABLE NC_Polygons2
-- SELECT * FROM NC_Polygons2 order by posId

PRINT	CAST(GETDATE() as varchar(26)) + ': Script was started'
GO 
IF OBJECT_ID('NC_Polygons2') IS NULL 
	BEGIN
		SET ANSI_NULLS ON
		SET QUOTED_IDENTIFIER ON

		CREATE TABLE NC_Polygons2 
		(
			[FileId] [bigint] NOT NULL,
			[SessionID] [bigint] NOT NULL,
			[TestId] [bigint]  NULL,
			[PosId]  [bigint]  NULL,
			[Longitude] [float] NULL,
			[Latitude] [float] NULL,
			[Source] varchar(50) NULL,	
			
			[Type] varchar(50) NULL,

			[Country] varchar(50) NULL,
			[State_Province] varchar(50) NULL,
			[Region] varchar(50) NULL,
			[City] varchar(50) NULL,
			[ZIP_Code] varchar(50) NULL,
			[Type1] varchar(50) NULL,
			[Type2] varchar(50) NULL,
			[Comment]  varchar(255) NULL,

			[Vendor] varchar (50) NULL,
			[VF_Region] varchar (50) NULL
 
		) ON [PRIMARY]
	PRINT	CAST(GETDATE() as varchar(26)) + ': Table was created'
	END

-- Check if old version w/o TYPE field exists	
	IF COL_LENGTH('NC_Polygons2', 'TYPE') IS NULL ALTER TABLE NC_Polygons2 ADD [Type] varchar(50)
	GO



PRINT	CAST(GETDATE() as varchar(26)) + ': Fill #temp Table was started'
GO 

IF OBJECT_ID('tempdb..#temp_poly') IS NOT NULL DROP TABLE #temp_poly
GO
CREATE TABLE #temp_poly (
			[FileId] [bigint] NOT NULL,
			[SessionID] [bigint] NOT NULL,
			[TestId] [bigint]  NULL,
			[PosId]  [bigint]  NULL,
			[Longitude] [float] NULL,
			[Latitude] [float] NULL,
			[Source] varchar(25) NULL,

			)
------------------------------------------------------
---
------------------------------------------------------
IF DB_NAME() LIKE '%Data%'	GOTO ONLY_DATA_DB
IF DB_NAME() LIKE '%Voice%' GOTO ONLY_Voice_DB 	
GOTO WEITER


ONLY_DATA_DB:
		PRINT 'Data Database found'
		INSERT INTO #temp_poly
		SELECT s.FileId, ti.Sessionid, ti.TestId, ti.PosId, p.longitude, p.latitude, 'TestId' AS 'Source'

			FROM TestInfo ti 
				INNER JOIN Sessions s ON ti.SessionId = s.SessionId 
				INNER JOIN Position p ON ti.StartPosId = p.PosId
			WHERE p.longitude > 0.01 and sessiontype not like 'call'
		EXCEPT
		SELECT FileId, Sessionid, TestId, PosId, longitude, latitude, [Source]
			FROM NC_Polygons2
--		GOTO WEITER

ONLY_VOICE_DB:
-- Session A-Side
		PRINT 'Voice Database found'
		INSERT INTO #temp_poly
		SELECT s.FileId, s.Sessionid, NULL AS 'TestId', s.PosId, p.longitude, p.latitude, 'SessionIdA' AS 'Source'
			FROM Sessions s 
				INNER JOIN Position p ON s.StartPosId = p.PosId
			WHERE p.longitude > 0.01 and sessiontype not like 'data'
		EXCEPT
		SELECT FileId, Sessionid, TestId, PosId, longitude, latitude, [Source]
			FROM NC_Polygons2
		GOTO WEITER

-- Session B-Side
		INSERT INTO #temp_poly
		SELECT s.FileId, s.Sessionid, NULL AS 'TestId', s.PosId, p.longitude, p.latitude, 'SessionIdB' AS 'Source'
			FROM SessionsB s 
				INNER JOIN Position p ON s.StartPosId = p.PosId
			WHERE p.longitude > 0.01 and sessiontype not like 'data'
		EXCEPT
		SELECT FileId, Sessionid, TestId, PosId, longitude, latitude, [Source]
			FROM NC_Polygons2
		GOTO WEITER


WEITER:
PRINT	CAST(GETDATE() as varchar(26)) + ': Fill #temp Table is done'
GO 
-------------------------------------------------------------------------
-- Insert States/Provinces into NC_Polygons2
-------------------------------------------------------------------------
PRINT	CAST(GETDATE() as varchar(26)) + ': Fill NC_Polygons Table was started'
GO 
-------------------------------------------------------------------------
-- GERMANY -- Vodafone Region and Vendor Polygons --
-------------------------------------------------------------------------
IF DB_NAME() LIKE 'VF%' OR DB_NAME() LIKE 'TDG%' OR DB_NAME() LIKE 'PBM_DE%' OR DB_NAME() LIKE 'DE_%' OR DB_NAME() LIKE 'VDF%'
	BEGIN
		INSERT INTO [dbo].[NC_Polygons2] ([FileId],[SessionID],[TestId],[PosId],[Longitude],[latitude],[Source],[Type],[Country],[State_Province],[City],[TYPE1],[TYPE2],[VF_Region],[Vendor])
    	SELECT	t1.[FileId], t1.[SessionID], t1.[TestId], t1.[PosId], t1.[Longitude], t1.[latitude], t1.[Source]
				,[TYPE]		    = 'administrative borders'
				,Country		= a.NAME_0
				,State_Province = a.NAME_1
				,City			= a.NAME_2 
				,TYPE1			= a.TYPE_2
			    ,TYPE2			= a.EngTYPE_2
				,VF_Region      = b.Region
			    ,Vendor		    = b.Vendor
				    
			FROM #temp_poly t1
					LEFT OUTER JOIN _Master_DB.[dbo].[GEOADM_DEU_adm2] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(t1.Longitude as varchar(15))+' ' +cast(t1.Latitude as varchar(15))+')', 4326))=1 
					LEFT OUTER JOIN _Master_DB.[dbo].[VF_Regions_Vendor] b ON b.geom.STIntersects(geography::STPointFromText('POINT('+cast(t1.Longitude as varchar(15))+' ' +cast(t1.Latitude as varchar(15))+')', 4326))=1 

		PRINT 'GERMANY States/Provinces and Vodafone Region/Vendor was updated'
	END

-- Vodafone Region and Vendor Polygons --
--IF DB_NAME() LIKE 'VF%' OR DB_NAME() LIKE 'TDG%' OR DB_NAME() LIKE 'PBM_DE%' OR DB_NAME() LIKE 'DE_%'
--	BEGIN
--		INSERT INTO [dbo].[NC_Polygons2] ([FileId],[SessionID],[TestId],[PosId],[Longitude],[latitude],[Source],[Region],[Vendor])
--		SELECT t1.[FileId], t1.[SessionID], t1.[TestId], t1.[PosId], t1.[Longitude], t1.[latitude], t1.[Source],
--			   Region        = b.Region,
--			   Vendor		 = b.Vendor                                            

--       FROM #temp_poly t1 
--             LEFT OUTER JOIN _Master_DB.[dbo].[VF_Regions_Vendor] b ON b.geom.STIntersects(geography::STPointFromText('POINT('+cast(t1.Longitude as varchar(15))+' ' +cast(t1.Latitude as varchar(15))+')', 4326))=1 

--		PRINT 'Vodafone Region/Vendor was updated'
--	END
-------------------------------------------------------------------------
-- NETHERLAND
-------------------------------------------------------------------------
IF DB_NAME() LIKE 'NL_%' 
	BEGIN
		INSERT INTO [dbo].[NC_Polygons2] ([FileId],    [SessionID],    [TestId],    [PosId],    [Longitude],    [Latitude], [Source], [TYPE], [Country],[State_Province],[TYPE1])
    	SELECT	                       t1.[FileId], t1.[SessionID], t1.[TestId], t1.[PosId], t1.[Longitude], t1.[Latitude], t1.[Source]
			   ,[TYPE]	    	= 'administrative borders'
			   ,Country			= a.NAME_0
			   ,State_Province	= a.NAME_1
			   ,TYPE1			= a.EngTYPE_1   
			FROM #temp_poly t1
					LEFT OUTER JOIN _Master_DB.[dbo].[NLD_adm1] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(t1.Longitude as varchar(15))+' ' +cast(t1.Latitude as varchar(15))+')', 4326))=1 
		PRINT 'Netherland States/Provinces was updated'
	END

-------------------------------------------------------------------------
-- AUSTRIA
-------------------------------------------------------------------------
IF DB_NAME() LIKE 'AT_%' 
	BEGIN
		INSERT INTO [dbo].[NC_Polygons2] ([FileId],    [SessionID],    [TestId],    [PosId],    [Longitude],    [latitude],  [Source], [TYPE], [Country],[State_Province],[City])
    	SELECT	                       t1.[FileId], t1.[SessionID], t1.[TestId], t1.[PosId], t1.[Longitude], t1.[latitude], t1.[Source]
			    ,[TYPE]	         = 'administrative borders'
				,Country		 = a.St
				,State_Province  = a.BL
				,City			 = a.Pg   
				
			FROM #temp_poly t1
					LEFT OUTER JOIN _Master_DB.[dbo].[GEO_AUS_Verwaltungsgrenzen_250] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(t1.Longitude as varchar(15))+' ' +cast(t1.Latitude as varchar(15))+')', 4326))=1 
		PRINT 'Austria States/Provinces was updated'
	END	 

-------------------------------------------------------------------------
-- SWITZERLAND
-------------------------------------------------------------------------
IF DB_NAME() LIKE 'CH_%' 
	BEGIN
		INSERT INTO [dbo].[NC_Polygons2] ([FileId],[SessionID],[TestId],[PosId],[Longitude],[latitude],[Source], [TYPE], [Country],[State_Province])
    	SELECT	t1.[FileId], t1.[SessionID], t1.[TestId], t1.[PosId], t1.[Longitude], t1.[latitude], t1.[Source]
			    ,[TYPE]  		    = 'administrative borders'
				,Country			= ISNULL(a.NAME_0,'')
				,State_Province		= ISNULL(a.NAME_1,'')
			FROM #temp_poly t1
					LEFT OUTER JOIN _Master_DB.[dbo].[GEOADM_CHE_adm1] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(t1.Longitude as varchar(15))+' ' +cast(t1.Latitude as varchar(15))+')', 4326))=1 
		PRINT 'Switzerland States/Provinces was updated'
	END	 



PRINT	CAST(GETDATE() as varchar(26)) + ': Fill NC_Polygons2 Table is done'
PRINT	CAST(GETDATE() as varchar(26)) + ': Script is done'
GO 		
-- SELECT * from [NC_Polygons2]


	




-- UPDATE NC_Polygons2 SET TYPE = 'administrative borders' where Type is  NULL

--	select * from NEW_CDR_data_2017




/*


IF DB_NAME() LIKE 'VF%' OR DB_NAME() LIKE 'TDG%' OR DB_NAME() LIKE 'PBM_DE%'
		BEGIN
			UPDATE NEW_CDR_TABLEAU4_Voice SET 
				-- SELECT 
				Country			= a.NAME_0,
				State_Province  = a.NAME_1,
				City			= a.NAME_2 
				
				FROM NEW_CDR_TABLEAU4_Voice cdr 
					LEFT OUTER JOIN _Master_DB.[dbo].[GEOADM_DEU_adm2] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(cdr.Call_Start_Longitude_A as varchar(15))+' ' +cast(cdr.Call_Start_Latitude_A as varchar(15))+')', 4326))=1 

			PRINT 'Germany States was updated'
		END
	ELSE
		BEGIN 
			PRINT 'Keine deutsche Datenbank'
		END


IF DB_NAME() LIKE 'AT_%' 
		BEGIN
			UPDATE NEW_CDR_TABLEAU4_Voice SET 
				-- SELECT 
				Country			= a.St,
				State_Province  = a.BL,
				City			= a.Pg 
				
				FROM NEW_CDR_TABLEAU4_Voice cdr 
					LEFT OUTER JOIN _Master_DB.[dbo].[GEO_AUS_Verwaltungsgrenzen_250] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(cdr.Call_Start_Longitude_A as varchar(15))+' ' +cast(cdr.Call_Start_Latitude_A as varchar(15))+')', 4326))=1 
				
			PRINT 'Austria States was updated'
		END
	ELSE
		BEGIN 
			PRINT 'Keine Östereischiche Datenbank'
		END


IF DB_NAME() LIKE 'CH_%' 
		BEGIN
			UPDATE NEW_CDR_TABLEAU4_Voice SET 
				-- SELECT 
				Country			= ISNULL(a.NAME_0,''),
				State_Province  = ISNULL(a.NAME_1,'')--,
				--City			= a.Pg 
				
				FROM NEW_CDR_TABLEAU4_Voice cdr 
				LEFT OUTER JOIN _Master_DB.[dbo].[GEOADM_CHE_adm1] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(cdr.Call_Start_Longitude_A as varchar(15))+' ' +cast(cdr.Call_Start_Latitude_A as varchar(15))+')', 4326))=1 

			PRINT 'Switzerland States was updated'
		END
	ELSE
		BEGIN 
			PRINT 'Keine Switzerland Datenbank'
		END


IF DB_NAME() LIKE 'NL_%' 
		BEGIN
			UPDATE NEW_CDR_TABLEAU4_Voice SET 
				-- SELECT 
				Country			= ISNULL(a.NAME_0,''),
				State_Province  = ISNULL(a.NAME_1,'')--,
				--City			= a.Pg 
				
				FROM NEW_CDR_TABLEAU4_Voice cdr 
				LEFT OUTER JOIN _Master_DB.[dbo].[GEOADM_CHE_adm1] a ON a.geom.STIntersects(geography::STPointFromText('POINT('+cast(cdr.Call_Start_Longitude_A as varchar(15))+' ' +cast(cdr.Call_Start_Latitude_A as varchar(15))+')', 4326))=1 

			PRINT 'Netherland provinces was updated'
		END
	ELSE
		BEGIN 
			PRINT 'Keine Netherland Datenbank'
		END

*/