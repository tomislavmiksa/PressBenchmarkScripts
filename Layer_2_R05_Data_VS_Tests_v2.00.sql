PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script execution start!...')

IF EXISTS(SELECT name FROM sysobjects WHERE name = N'NEW_RESULTS_VS_ALL_2018' AND type = 'U')	DROP TABLE NEW_RESULTS_VS_ALL_2018
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_ALL_2018 beeing created...')
-- VIDEO STREAMING RESULTS
SELECT 1													AS Validity
	  ,CAST(null as varchar(50))							AS InvalidReason
	  ,a.[SessionId]
      ,a.[TestId]
	  ,CASE WHEN a.[Status] like 'Dropped'	THEN 'Cutoff'
			WHEN a.[Status] like 'Fail%'	THEN 'Failed'
			WHEN a.[Status] like 'Comple%'	THEN 'Completed'
			END AS Status
	  ,'VideoStreaming'										AS Test_Type
	  ,CASE WHEN a.url like '%youtu%' THEN 'YouTube'
			WHEN a.url like '%netflix%' THEN 'Netflix'
			END												AS Test_Name
	  ,'Adaptive Live Streaming'							AS Test_Info 
	  ,'DL'													AS Direction
      ,a.[URL]
      ,a.[Player]
	  ,a.[Technology]
      ,a.[Protocol]
	  ,c.[VideoSize]										AS VideoSizeBytes
      ,a.[StreamStartTime]
      ,a.[StreamEndTime]
	  ,cast(null as varchar(20))							AS IpServiceAccessStatus
      ,d.[TimeToStartBufferingPlayer]						AS IpServiceAccessTime
	  ,d.[TimeToFirstPicturePlayer]							AS TimeToFirstPicture
	  ,b.[VideoDuration]									AS StreamedVideoTime
	  ,a.[StreamDuration]									AS StreamedVideoTotalTime
	  ,CAST(null as varchar(1000))							AS Resolution_Timeline
      ,a.[HorResolution]
      ,a.[VerResolution]
	  ,a.[VideoResolution]									AS ApplicationResolutionOptions
      ,a.[ImageSize]										AS ImageSizeInPixels
      ,c.[SignalDist]
      ,c.[FrameRateCalc]
      ,c.[Black]
      ,c.[Freezing]
      ,c.[Jerkiness]
	  ,f.Min_VQ												AS MIN_VMOS
      ,f.AvgTest_VQ											AS AVG_VMOS
      ,f.Max_VQ												AS MAX_VMOS
  INTO NEW_RESULTS_VS_ALL_2018
  FROM [vResultsVQTest] a
  LEFT OUTER JOIN [ResultsVideoStream] b ON a.SessionId = b.SessionId and a.TestId = b.TestId
  LEFT OUTER JOIN [ResultsVQ08StreamAvg] c ON a.SessionId = c.SessionId and a.TestId = c.TestId
  LEFT OUTER JOIN [ResultsVideoStreamTCPData] d ON a.SessionId = d.SessionId and a.TestId = d.TestId
  LEFT OUTER JOIN [ResultsVideoStreamAvg] e ON a.SessionId = e.SessionId and a.TestId = e.TestId
  LEFT OUTER JOIN 	(select 
							testid,
							count(visualQuality)	as Samples_VQ,
							sum(visualQuality)		as Sum_VQ,
							min(visualQuality)		as Min_VQ,
							max(visualQuality)		as Max_VQ,
							avg(visualQuality)		as AvgTest_VQ
						from ResultsVQ08ClipAvg
						group by testid) as f on a.TestId = f.TestId

  --select * from ResultsVQ08StreamAvg

-- EXTRACTING Video Stream Timeline
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_ALL_2018 updated with all resolutions in test...')
	IF OBJECT_ID ('tempdb..#VsResolution' ) IS NOT NULL DROP TABLE #VsResolution
	SELECT SessionId,TestId,MsgTime
		  ,ROW_NUMBER() over (partition by SessionID, TestID ORDER BY MsgTime) as RNK
 		  ,SUBSTRING(Event,charindex(':',Event,1) + 1,len(Event)-charindex(':',Event,1) ) as Resolutions
		  ,cast(null as bigint) as duration
		  ,Event
	 INTO #VsResolution
	 FROM VideoStatusTrace
	 WHERE Event like '%resolution%'

	 UPDATE #VsResolution
	 Set duration = (select datediff(ms,a.MsgTime,b.MsgTime) from #VsResolution b where a.Sessionid = b.SessionId and a.TestId = b.TestId and b.RNK = a.RNK + 1 )
	 from #VsResolution a

	 UPDATE #VsResolution
	 Set duration = datediff(ms,a.MsgTime,dateadd(ms,b.duration,b.startTime))
	 from #VsResolution a
	 left outer join TestInfo b on a.TestId = b.TestId
	 WHERE a.duration is null

	IF OBJECT_ID ('tempdb..#Resolution' ) IS NOT NULL DROP TABLE #Resolution
	SELECT SessionId,TestId,
		   ( SELECT Resolutions + ' (' + CAST(CAST(duration/1000 as decimal(10,1)) as varchar(10)) + ') / ' 
			   FROM #VsResolution  b
			  WHERE a.SessionId = b.SessionId and a.TestId = b.TestId
			  ORDER BY MsgTime
				FOR XML PATH('') ) AS Name
	INTO #Resolution
	FROM #VsResolution a

	UPDATE NEW_RESULTS_VS_ALL_2018
	SET Resolution_Timeline = CASE WHEN len(b.Name) > 2 THEN substring(b.Name,1,len(b.Name)-2) ELSE NULL END
		,IpServiceAccessStatus = 'Success'
	FROM NEW_RESULTS_VS_ALL_2018 a
	LEFT OUTER JOIN #Resolution b on a.SessionId = b.SessionId and a.TestId = b.TestId
	-- select *,CASE WHEN len(b.Name) > 2 THEN substring(b.Name,1,len(b.Name)-2) ELSE NULL END from #Resolution as b
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - TABLE: NEW_RESULTS_VS_ALL_2018 updated with status/validation...')
	UPDATE NEW_RESULTS_VS_ALL_2018
	Set Validity = 0, InvalidReason = 'SwissQual System Release'
		,Protocol						 = null
		,IpServiceAccessStatus			 = null
		,StreamStartTime                 = null
		,StreamEndTime					 = null
		,IpServiceAccessTime			 = null
		,TimeToFirstPicture				 = null
		,StreamedVideoTime               = null
		,StreamedVideoTotalTime          = null
		,VideoSizeBytes                  = null
		,Resolution_Timeline             = null
		,HorResolution                   = null
		,VerResolution                   = null
		,ApplicationResolutionOptions    = null
		,ImageSizeInPixels               = null
		,SignalDist                      = null
		,FrameRateCalc                   = null
		,Black                           = null
		,Freezing                        = null
		,Jerkiness                       = null
		,MIN_VMOS                        = null
		,AVG_VMOS                        = null
		,MAX_VMOS                        = null
	WHERE Status like 'System%'

	UPDATE NEW_RESULTS_VS_ALL_2018
	Set 
		 Protocol						 = null
		,IpServiceAccessStatus			 = 'Failed'
		,StreamStartTime                 = null
		,StreamEndTime					 = null
		,IpServiceAccessTime			 = null
		,TimeToFirstPicture				 = null
		,StreamedVideoTime               = null
		,StreamedVideoTotalTime          = null
		,VideoSizeBytes                  = null
		,Resolution_Timeline             = null
		,HorResolution                   = null
		,VerResolution                   = null
		,ApplicationResolutionOptions    = null
		,ImageSizeInPixels               = null
		,SignalDist                      = null
		,FrameRateCalc                   = null
		,Black                           = null
		,Freezing                        = null
		,Jerkiness                       = null
		,MIN_VMOS                        = null
		,AVG_VMOS                        = null
		,MAX_VMOS                        = null
	WHERE Status like 'Failed%'

	UPDATE NEW_RESULTS_VS_ALL_2018
	Set  Status = 'Cutoff'
		,StreamEndTime					 = null
		,HorResolution                   = null
		,VerResolution                   = null
		,SignalDist                      = null
		,FrameRateCalc                   = null
		,Black                           = null
		,Freezing                        = null
		,Jerkiness                       = null
		,MIN_VMOS                        = null
		,AVG_VMOS                        = null
		,MAX_VMOS                        = null
	WHERE Status like 'Abort%'

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Scripts execution completed...')

-- select * from NEW_RESULTS_VS_ALL_2018

