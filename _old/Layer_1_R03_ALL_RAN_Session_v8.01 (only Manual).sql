/*****************************************************************************************************************************************************************************
============================================================================================================================================================================
Projekt: Pressemessung
   Name: Layer_1_R03_Create_RAN_Table__Session_v8.01.sql
  Autor: NET CHECK GmbH
============================================================================================================================================================================
*****************************************************************************************************************************************************************************/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- History 
-- v1. ->     CREATE
-- v2. ->     mpausin 13.05.2016 sc4 eingefügt
-- v3. ->     mpausin 13.05.2016 Disconnect_LAC,CId,BCCH und LAC,CId,BCCH_A eingefügt
-- v6. ->     mpausin 08.03.2017 Add Workaround for more then one LTE PhyCellId per networkid
-- v7. ->     tmiksa  08.03.2017 Added HO/Reselection Info
-- v7. ->     tmiksa  08.03.2017 Added Basic RF Statistics
-- v7. ->     tmiksa  08.03.2017 Added RRC State into Table
-- v8. ->     tmiksa  27.03.2017 Making cumulative instead of droping all in the beginning
-- v8.01 ->   tmiksa  08.11.2017 Cleanup to avoid duplicate calculations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DELETE OLD RAN TABLES (do only if required)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	IF OBJECT_ID (N'dbo.NEW_RAN_Source_Session_2018', N'U') IS NOT NULL DROP table NEW_RAN_Source_Session_2018
	IF OBJECT_ID (N'dbo.NEW_RAN_Session_2018', N'U') IS NOT NULL DROP table NEW_RAN_Session_2018

	SELECT * FROM NEW_RAN_Source_Session_2018
	SELECT * FROM NEW_RAN_Session_2018
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetLACCIDBCCH_Disconnect') DROP FUNCTION NEW_GetLACCIDBCCH_Disconnect
GO
CREATE FUNCTION NEW_GetLACCIDBCCH_Disconnect(@SessionID bigint)
RETURNS varchar(2000)
as
Begin
	  Declare @TN as varchar(200)   
      Declare @Result as varchar(2000)
	  Declare @Temp as Varchar(50)   
      set @Temp=''
	  set @Result =''
	  
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
	  select 
		'['+
			isnull(CAST(dbo.GetRFBand(nt.[RFBand]) as varchar(20)),'') +','+ 
			isnull(CAST(nt.LAC as varchar(10)),'') +','+ 
			isnull(cast(Cid as varchar(10)),'')+','+
			isnull(cast(BCCH as varchar(10)),'')+
		']'
	  from
		
		(
			SELECT [SessionId_A]				as Sessionid
				  ,[callDisconnectTimeStamp_A]	as callDisconnectTimeStamp
				  ,[callDisconnectTimeStamp_B]	as Disconnect_B
			  FROM [NEW_Call_Info_2018]
		) t
		left outer join [NEW_RAN_Source_Session_2018] nt on nt.sessionid=t.sessionid  
		where 
			t.sessionid=@SessionID	and 
			 callDisconnectTimeStamp>= nt.MsgTime and callDisconnectTimeStamp< dateadd(ms,duration,nt.MsgTime) AND
			(nt.LAC is not null or Cid is not null or BCCH is not null)
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + @TN+','
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor

      RETURN @Result
	
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetLACCIDBCCH') DROP FUNCTION NEW_GetLACCIDBCCH
GO
CREATE FUNCTION NEW_GetLACCIDBCCH(@SessionID bigint)
RETURNS varchar(2000)
AS
BEGIN
      
      Declare @TN as varchar(200)   
      Declare @Result as varchar(500)
	  Declare @Temp as Varchar(50)   
      set @Temp=''
	  set @Result =''
	  
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT 
            '['+
				isnull(CAST(dbo.GetRFBand([RFBand]) as varchar(20)),'') +','+ 
				isnull(CAST(LAC as varchar(10)),'') +','+ 
				isnull(cast(Cid as varchar(10)),'')+','+
				isnull(cast(BCCH as varchar(10)),'')+
			']'
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and 
				(LAC is not null or Cid is not null or BCCH is not null)
				
           order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + @TN+','
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END
GO
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetCGI_Disconnect') DROP FUNCTION NEW_GetCGI_Disconnect
GO
CREATE FUNCTION NEW_GetCGI_Disconnect(@SessionID bigint)
RETURNS varchar(2000)
as
Begin
	Declare @Result as varchar(200)	
	set @Result=''
	
	select @Result=CGI
	from
	
	(
		SELECT [SessionId_A]				as Sessionid
			  ,[callDisconnectTimeStamp_A]	as callDisconnectTimeStamp
			  ,[callDisconnectTimeStamp_B]	as Disconnect_B
		  FROM NEW_Call_Info_2018
	) t
	left outer join [NEW_RAN_Source_Session_2018] nt on nt.sessionid=t.sessionid 
    where 
		t.sessionid=@SessionID AND
		callDisconnectTimeStamp>= nt.MsgTime and callDisconnectTimeStamp< dateadd(ms,duration,nt.MsgTime)
	 RETURN @Result
END

GO
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetPCI') DROP FUNCTION NEW_GetPCI
GO

CREATE FUNCTION NEW_GetPCI(@SessionID bigint)
RETURNS varchar(2000)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)
	  Declare @Temp as Varchar(50)   
      set @Temp=''
	  set @Result =''
	  
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT PCI
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				PCI is not null
           order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor

      RETURN @Result

END

GO
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetPCI') DROP FUNCTION NEW_GetPCI
GO
CREATE FUNCTION NEW_GetPCI(@SessionID bigint)
RETURNS varchar(2000)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)
	  Declare @Temp as Varchar(50)   
      set @Temp=''
	  set @Result =''
	  
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT PCI
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				PCI is not null
           order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetCGI') DROP FUNCTION NEW_GetCGI
GO
CREATE FUNCTION NEW_GetCGI(@SessionID bigint)
RETURNS varchar(2000)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)
	  Declare @Temp as Varchar(50)   
      set @Temp=''
	  set @Result =''
	  
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT CGI
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				CGI is not null and
				CGI<>''
           order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetMCC') DROP FUNCTION NEW_GetMCC
GO
CREATE FUNCTION NEW_GetMCC(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500) 
	  Declare @Temp as Varchar(50)   
      set @Temp=''   
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  MCC
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				MCC is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetMNC') DROP FUNCTION NEW_GetMNC
GO
CREATE FUNCTION NEW_GetMNC(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500) 
	  Declare @Temp as Varchar(50)   
      set @Temp=''      
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  MNC
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				MNC is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
           if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetCellID') DROP FUNCTION NEW_GetCellID
GO
CREATE FUNCTION NEW_GetCellID(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)  
	  Declare @Temp as Varchar(50)   
      set @Temp=''     
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  CiD
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID  and
				CID is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor

      RETURN @Result

END

GO

IF EXISTS (SELECT * FROM   sysobjects  WHERE  name = N'NEW_GetLAC') DROP FUNCTION NEW_GetLAC
GO
CREATE FUNCTION NEW_GetLAC(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)   
	  Declare @Temp as Varchar(50)   
      set @Temp=''    
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  Lac
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				Lac is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetBCCH') DROP FUNCTION NEW_GetBCCH
GO
CREATE FUNCTION NEW_GetBCCH(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)   
	  Declare @Temp as Varchar(50)   
      set @Temp=''    
      set @Result =''
      DECLARE TN_cursor CURSOR  FAST_FORWARD FOR 
            SELECT  BCCH
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				BCCH is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor

      RETURN @Result

END

GO

IF EXISTS (SELECT *  FROM   sysobjects WHERE  name = N'NEW_GetSC1') DROP FUNCTION NEW_GetSC1
GO
CREATE FUNCTION NEW_GetSC1(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)    
	  Declare @Temp as Varchar(50)   
      set @Temp=''   
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  sc1
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				SC1 is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetSC2') DROP FUNCTION NEW_GetSC2
GO
CREATE FUNCTION NEW_GetSC2(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)    
	  Declare @Temp as Varchar(50)   
      set @Temp=''   
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  sc2
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				SC2 is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetSC3') DROP FUNCTION NEW_GetSC3
GO
CREATE FUNCTION NEW_GetSC3(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)  
	  Declare @Temp as Varchar(50)   
      set @Temp=''     
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  sc3
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				SC3 is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetSC4') DROP FUNCTION NEW_GetSC4
GO
CREATE FUNCTION NEW_GetSC4(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)  
	  Declare @Temp as Varchar(50)   
      set @Temp=''     
      set @Result =''
      DECLARE TN_cursor CURSOR FAST_FORWARD FOR 
            SELECT  sc4
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				SC4 is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetBSIC') DROP FUNCTION NEW_GetBSIC
GO
CREATE FUNCTION NEW_GetBSIC(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500) 
	  Declare @Temp as Varchar(50)   
      set @Temp=''     
      set @Result =''
      DECLARE TN_cursor CURSOR FOR 
            SELECT  BSIC as BSIC
            from
                  NEW_RAN_Source_Session_2018
            where 
				sessionid=@SessionID and
				BSIC is not null
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status =0
      Begin
            if @TN<>@Temp
			begin
				set @Temp=@TN
				Set @Result = @Result + '['+@TN +'], '
			end
            Fetch next FROM TN_cursor into @TN
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

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
go 

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

IF EXISTS (SELECT * FROM sysobjects WHERE name = N'NC_GetRRCStateA') DROP FUNCTION NC_GetRRCStateA
GO
CREATE FUNCTION NC_GetRRCStateA(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      DECLARE @TN as varchar(50)   
      DECLARE @Result as varchar(500) 
      DECLARE @Temp as Varchar(50)     
      set @Result	=''
      set @Temp		=''

      DECLARE TN_cursor CURSOR FOR 
            SELECT                    
				case when RRCState = 0 then 'Idle'
                     when RRCState = 1 then 'Connected'
                     when RRCState = 2 then 'CELL FACH'
                     when RRCState = 3 then 'CELL DCH'
                     when RRCState = 4 then 'CELL PCH'
                     when RRCState = 5 then 'URA PCH' else null end as RRCState
            from
                  WCDMARRCState rrc
				  left outer join sessions s on rrc.SessionId=s.SessionId
            where 
                 s.SessionId=@SessionID 
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status = 0
      Begin
		if @TN<>@Temp
			begin
				set @Temp=@TN
                Set @Result = @Result + '['+@TN +'], '
            end
            Fetch next FROM TN_cursor into @TN              
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result

END

GO

IF EXISTS (SELECT * FROM sysobjects WHERE name = N'NC_GetRRCStateB') DROP FUNCTION NC_GetRRCStateB
GO
CREATE FUNCTION NC_GetRRCStateB(@SessionID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      DECLARE @TN as varchar(50)   
      DECLARE @Result as varchar(500) 
      DECLARE @Temp as Varchar(50)     
      set @Result	=''
      set @Temp		=''

      DECLARE TN_cursor CURSOR FOR 
            SELECT                    
				case when RRCState = 0 then 'Idle'
                     when RRCState = 1 then 'Connected'
                     when RRCState = 2 then 'CELL FACH'
                     when RRCState = 3 then 'CELL DCH'
                     when RRCState = 4 then 'CELL PCH'
                     when RRCState = 5 then 'URA PCH' else null end as RRCState
            from
                  WCDMARRCState rrc
				  left outer join SessionsB s on rrc.SessionId=s.SessionId
            where 
                 s.SessionId=@SessionID 
            order by msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status = 0
      Begin
		if @TN<>@Temp
			begin
				set @Temp=@TN
                Set @Result = @Result + '['+@TN +'], '
            end
            Fetch next FROM TN_cursor into @TN              
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NC_GetActivePSC_A') DROP FUNCTION NC_GetActivePSC_A
GO
CREATE FUNCTION NC_GetActivePSC_A(@SessionID bigint)
RETURNS varchar(5000)
AS
BEGIN
      
      DECLARE @TN as varchar(50)   
      DECLARE @Result as varchar(5000) 
      DECLARE @Temp as Varchar(50)     
      set @Result	=''
      set @Temp		=''

      DECLARE TN_cursor CURSOR FOR 
            SELECT                    
				lmr.PhyCellId
            from
                LTEMeasurementReport lmr 
				left outer join sessions s on lmr.SessionId=s.SessionId
            where 
                 s.SessionId=@SessionID 
				 and lmr.PhyCellId is not null
            order by lmr.msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status = 0
      Begin
		if @TN<>@Temp
			begin
				set @Temp=@TN
                Set @Result = @Result + @TN +','
            end
            Fetch next FROM TN_cursor into @TN              
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END

GO

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NC_GetActivePSC_B') DROP FUNCTION NC_GetActivePSC_B
go
CREATE FUNCTION NC_GetActivePSC_B(@SessionID bigint)
RETURNS varchar(5000)
AS
BEGIN
      
      DECLARE @TN as varchar(50)   
      DECLARE @Result as varchar(5000) 
      DECLARE @Temp as Varchar(50)     
      set @Result	=''
      set @Temp		=''

      DECLARE TN_cursor CURSOR FOR 
            SELECT                    
				lmr.PhyCellId
            from
                LTEMeasurementReport lmr 
				left outer join SessionsB sb on lmr.SessionId=sb.sessionid
            where 
                 sb.SessionId=@SessionID 
				 and lmr.PhyCellId is not null
            order by lmr.msgtime
      
      Open TN_cursor
      Fetch next FROM TN_cursor into @TN
      while @@Fetch_status = 0
      Begin
		if @TN<>@Temp
			begin
				set @Temp=@TN
                Set @Result = @Result + @TN + ','
            end
            Fetch next FROM TN_cursor into @TN              
      end
      Set @Result = substring(@Result,0,len(@Result))
      CLOSE TN_cursor
      DEALLOCATE TN_cursor
      RETURN @Result
END
go 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING TABLES IF THEY DO NOT EXIST
-- Table: NEW_RAN_Session_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execeution...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Create NEW_RAN_Session_2018 table if it does not exist...')
if not exists (select * from sysobjects where name='NEW_RAN_Session_2018' and xtype='U')
    create table NEW_RAN_Session_2018 (	sessionid bigint,
										MCC varchar(500),
										MNC varchar(500),
										CellID varchar(500),
										LAC varchar(500),
										BCCH varchar(500),
										SC1 varchar(500),
										SC2 varchar(500),
										SC3 varchar(500),
										SC4 varchar(500),
										CGI varchar(2000),
										BSIC varchar(500),
										PCI varchar(2000),
										CGI_Disconnect varchar(2000),
										Disconnect_LAC_CId_BCCH varchar(2000),
										LAC_CId_BCCH varchar(2000),
										AvgTA2G bigint,
										MaxTA2G bigint,
										CQI_HSDPA_Min bigint,
										CQI_HSDPA bigint,
										CQI_HSDPA_Max bigint,
										CQI_HSDPA_StDev float,
										ACK3G bigint,
										NACK3G bigint,
										ACKNACK3G_Total bigint,
										ACK3G_Percent float,
										NACK3G_Percent float,
										BLER3G float,
										BLER3GSamples bigint,
										StDevBLER3G float,
										CQI_LTE_Min float,
										CQI_LTE_Avg float,
										CQI_LTE_Max float,
										CQI_LTE_StDev float,
										ACK4G bigint,
										NACK4G bigint,
										ACKNACK4G_Total bigint,
										ACK4G_Percent float,
										NACK4G_Percent float,
										AvgDLTA4G bigint,
										MaxDLTA4G bigint,
										MinDLNumCarriers float,
										AvgDLNumCarriers float,
										MaxDLNumCarriers float,
										MinDLRB float,
										AvgDLRB float,
										MaxDLRB float,
										MinDLMCS float,
										AvgDLMCS float,
										MaxDLMCS float,
										CountDLNumQPSK bigint,
										CountDLNum16QAM bigint,
										CountDLNum64QAM bigint,
										CountDLNum256QAM bigint,
										CountDLModulation bigint,
										MinScheduledPDSCHThroughput float,
										AvgScheduledPDSCHThroughput float,
										MaxScheduledPDSCHThroughput float,
										MinNetPDSCHThroughput float,
										AvgNetPDSCHThroughput float,
										MaxNetPDSCHThroughput float,
										PDSCHBytesTransfered bigint,
										MinDLBLER float,
										AvgDLBLER float,
										MaxDLBLER float,
										MinDLTBSize float,
										AvgDLTBSize float,
										MaxDLTBSize float,
										MinDLTBRate float,
										AvgDLTBRate float,
										MaxDLTBRate float,
										MinULNumCarriers float,
										AvgULNumCarriers float,
										MaxULNumCarriers float,
										CountULNumBPSK bigint,
										CountULNumQPSK bigint,
										CountULNum16QAM bigint,
										CountULNum64QAM bigint,
										CountULModulation bigint,
										MinScheduledPUSCHThroughput float,
										AvgScheduledPUSCHThroughput float,
										MaxScheduledPUSCHThroughput float,
										MinNetPUSCHThroughput float,
										AvgNetPUSCHThroughput float,
										MaxNetPUSCHThroughput float,
										PUSCHBytesTransfered bigint,
										MinULTBSize float,
										AvgULTBSize float,
										MaxULTBSize float,
										MinULTBRate float,
										AvgULTBRate float,
										MaxULTBRate float,
										CA_PCI varchar(5000),
										HandoversInfo varchar(5000),
										RRCState varchar(500),
)
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EXCLUDING ALREADY EXISTING SESSIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Verify existing sessions in NEW_RAN_Session_2018 table if it does not exist...')
	IF OBJECT_ID ('tempdb..#ActSessions' ) IS NOT NULL DROP TABLE #ActSessions
	SELECT SessionId
	INTO #ActSessions
	FROM (Select sb.SessionId from SessionsB sb
		  UNION ALL
		  Select SessionId from Sessions sb) AS S
	EXCEPT SELECT SessionId FROM NEW_RAN_Session_2018


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERT INTO NEW_RAN_Source_Session_2018 TABLE
-- USED FOR FURTHER CALCULATIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Creating NEW_RAN_Source_Session_2018 table...')
if exists (select * from sysobjects where name='NEW_RAN_Source_Session_2018' and xtype='U') drop table NEW_RAN_Source_Session_2018
select DISTINCT  MsgTime
				,TimeEnd
				,sessionid
				,MCC
				,MNC
				,LAC
				,BCCH
				,Cid
				,sc1
				,sc2
				,sc3
				,sc4
				,technology
				,rfband
				,BSIC
				,CGI
				,PCI
				,duration
into NEW_RAN_Source_Session_2018
from
(
		select distinct ni.MsgTime,
						dateadd(ms,ni.duration,ni.MsgTime)		as TimeEnd,
						nr.sessionid,
						MCC,
						MNC,
						LAC,
						BCCH,
						Cid,
						sc1,
						sc2,
						sc3,
						was.PrimScCode as sc4,
						technology,
						rfband,
						BSIC,
						CGI,
						cast(null as integer) as PCI,
						ni.duration
		from 
			(   select Sessionid,StartNetworkid as Networkid  from sessions
				union all
				select Sessionid,StartNetworkid 			  from sessionsb
				union all
				select sessionid,networkid					  from NetworkIdRelation  
			) nr 
			join networkinfo ni on nr.networkid=ni.networkid
			left outer join WCDMAActiveSet was on ni.networkid=was.networkid and numCells=4 and was.PrimScCode not in(ni.SC1,ni.SC2,ni.SC3)
			) o

UPDATE NEW_RAN_Source_Session_2018
SET PCI = sc1
WHERE technology like 'LTE%' and PCI is null

UPDATE NEW_RAN_Source_Session_2018
SET sc1 = null
WHERE technology like 'LTE%'
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #TA_GSM
-- Table: #TA_LTE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE 2G...')
	IF OBJECT_ID ('tempdb..#TA_GSM' ) IS NOT NULL DROP TABLE #TA_GSM
	select SessionId, 
		   avg(ta) as AvgTA, 
		   max(ta) as MaxTA
	into #TA_GSM
	from MsgGSMReport gsm 
	group by SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING TIMING ADVANCE 4G...')
	IF OBJECT_ID ('tempdb..#TA_LTE' ) IS NOT NULL DROP TABLE #TA_LTE
	select 
			SessionId, 
			avg(TimingAdvance) as AvgTA, 
			max(TimingAdvance) as MaxTA
	into #TA_LTE
	from  
		(
			select 
				SessionId,
				case when (TimingAdvance between 0 and 1282) then TimingAdvance else null end as TimingAdvance
			from LTEFrameTiming
		) lte
		group by sessionid

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #CQI_UMTS
-- Table: #CQI_LTE
-- Table: #AckNack_LTE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING CQI...')
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING CQI UMTS...')
	IF OBJECT_ID ('tempdb..#CQI_UMTS' ) IS NOT NULL DROP TABLE #CQI_UMTS
	select SessionId, 
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
	group by SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING ACK/NACK Statistics FOR LTE...')
	IF OBJECT_ID ('tempdb..#AckNack_LTE' ) IS NOT NULL DROP TABLE #AckNack_LTE
	select sessionid, 
			SUM(NumAck)														as 'ACK_LTE_Count',
			SUM(NumNack)													as 'NACK_LTE_Count',
			1.0*SUM(NumAck)/nullif( 1.0 * (SUM(NumAck)+SUM(NumNack)) ,0)	as 'ACK_LTE_Ratio',
			1.0*SUM(NumAck)/nullif( 1.0 * (SUM(NumAck)+SUM(NumNack)) ,0)	as 'NACK_LTE_Ratio'
		into #AckNack_LTE
		from LTEDLAckNack ack 
		group by SessionId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING CQI LTE...')
	IF OBJECT_ID ('tempdb..#cqi_LTE1' ) IS NOT NULL DROP TABLE #cqi_LTE1
	select sessionid, 
			convert(real,round(Avg(CQI0),0))	as 'CQI_LTE_Avg',
			convert(real,round(Min(CQI0),0))	as 'CQI_LTE_Min',
			convert(real,round(Max(CQI0),0))	as 'CQI_LTE_Max',
			convert(real,round(Stdev(CQI0),1))	as 'CQI_LTE_StDev' 
		into #cqi_LTE1
		from LTEPUCCHCQI cqi 
		group by sessionid

	IF OBJECT_ID ('tempdb..#CQI_LTE' ) IS NOT NULL DROP TABLE #CQI_LTE
	select  cqi.SessionId
			,cqi.CQI_LTE_Min
			,cqi.CQI_LTE_Avg
			,cqi.CQI_LTE_Max
			,cqi.CQI_LTE_StDev
			,ack.ACK_LTE_Count
			,ack.NACK_LTE_Count
			,ack.ACK_LTE_Ratio
			,ack.NACK_LTE_Ratio
	into #CQI_LTE
	from #cqi_LTE1 cqi
	LEFT OUTER JOIN #AckNack_LTE ack ON ack.SessionId = cqi.SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #BLER_UMTS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING BLER FOR UMTS...')
	IF OBJECT_ID ('tempdb..#BLER_UMTS' ) IS NOT NULL DROP TABLE #BLER_UMTS
	select 
		sessionid
		,count(convert(float,crcerror)*100.0/nullif(convert(float,crcrec),0))	as 'BLER3GSamples'
		,sum(crcError)*100.0/sum(nullif((crcRec),0))							as 'BLER3G'
		,stdev(((crcError*100.0)/(nullif((crcRec),0))))							as 'StDevBLER3G'
	into #BLER_UMTS
	from WCDMABLER
	group by sessionid
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #LTE_DL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING DL LTE VARIABLES...')
	IF OBJECT_ID ('tempdb..#LTE_DL' ) IS NOT NULL DROP TABLE #LTE_DL
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
	into #LTE_DL
	from LTEPDSCHStatisticsInfo							
	group by SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #LTE_UL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING UL LTE VARIABLES...')
IF OBJECT_ID ('tempdb..#LTE_UL' ) IS NOT NULL DROP TABLE #LTE_UL
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
into #LTE_UL
from LTEPUSCHStatisticsInfo
where TestId <> 0
group by Sessionid
order by SessionId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERT INTO NEW_RAN_Session_2018 CQI TABLES
-- USED FOR FURTHER CALCULATIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Declare @records as bigint = (select COUNT(SessionId) from #ActSessions)
WHILE @records > 0
BEGIN
	PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Inserting into NEW_RAN_Session_2018 table...')
		IF OBJECT_ID ('tempdb..#ActSessionsTmp' ) IS NOT NULL DROP TABLE #ActSessionsTmp
		select top 3000 SessionId into #ActSessionsTmp from #ActSessions
		insert into NEW_RAN_Session_2018
		select 
			  s.sessionid,
			  dbo.NEW_GetMCC(s.sessionid) as MCC,
			  dbo.NEW_GetMNC(s.sessionid) as MNC,
			  dbo.NEW_GetCellID(s.sessionid) as CellID,
			  dbo.NEW_GetLAC(s.sessionid) as LAC,
			  dbo.NEW_GetBCCH(s.sessionid) as BCCH,
			  dbo.NEW_GetSC1(s.sessionid) as SC1,
			  dbo.NEW_GetSC2(s.sessionid) as SC2,
			  dbo.NEW_GetSC3(s.sessionid) as SC3,
			  dbo.NEW_GetSC4(s.sessionid) as SC4,
			  dbo.NEW_GetCGI(s.sessionid)	as CGI,
			  dbo.NEW_GetBSIC(s.sessionid) as BSIC,
			  dbo.NEW_GetPCI(s.sessionid) as PCI,
			  dbo.NEW_GetCGI_Disconnect(s.sessionid) as CGI_Disconnect,
			  dbo.NEW_GetLACCIDBCCH_Disconnect(s.sessionid) as Disconnect_LAC_CId_BCCH,
			  dbo.NEW_GetLACCIDBCCH(s.sessionid) as LAC_CId_BCCH,
			  tagsm.AvgTA			AS AvgTA2G,
			  tagsm.MaxTA			AS MaxTA2G,
			  cqiumts.CQI_HSDPA_Min,
			  cqiumts.CQI_HSDPA,
			  cqiumts.CQI_HSDPA_Max,	
			  cqiumts.CQI_HSDPA_StDev,
			  cqiumts.ACK_HSDPA_Count											AS ACK3G,
			  cqiumts.NACK_HSDPA_Count											AS NACK3G,
			  cqiumts.ACK_HSDPA_Count + cqiumts.NACK_HSDPA_Count				AS ACKNACK3G_Total,
			  100.0 * cqiumts.ACK_HSDPA_Ratio									AS ACK3G_Percent,
			  100.0 * cqiumts.NACK_HSDPA_Ratio									AS NACK3G_Percent,
			  blerumts.[BLER3G],
			  blerumts.[BLER3GSamples],
			  blerumts.[StDevBLER3G],
			  cqilte.CQI_LTE_Min,
			  cqilte.CQI_LTE_Avg,
			  cqilte.CQI_LTE_Max,	
			  cqilte.CQI_LTE_StDev,
			  cqilte.ACK_LTE_Count		AS ACK4G,
			  cqilte.NACK_LTE_Count		AS NACK4G,
			  cqilte.ACK_LTE_Count + cqilte.NACK_LTE_Count	AS ACKNACK4G_Total,
			  cqilte.ACK_LTE_Ratio * 100.0					AS ACK4G_Percent,
			  cqilte.NACK_LTE_Ratio * 100.0					AS NACK4G_Percent,
			  talte.AvgTA									AS AvgDLTA4G,
			  talte.MaxTA									AS MaxDLTA4G,
			  blerlte.MinDLNumCarriers						AS MinDLNumCarriers,
			  blerlte.AvgDLNumCarriers						AS AvgDLNumCarriers,
			  blerlte.MaxDLNumCarriers						AS MaxDLNumCarriers,
			  blerlte.MinRB									AS MinDLRB,
			  blerlte.AvgRB									AS AvgDLRB,
			  blerlte.MaxRB									AS MaxDLRB,
			  blerlte.MinMCS								AS MinDLMCS,
			  blerlte.AvgMCS								AS AvgDLMCS,
			  blerlte.MaxMCS								AS MaxDLMCS,
			  blerlte.CountNumQPSK							AS CountDLNumQPSK,
			  blerlte.CountNum16QAM							AS CountDLNum16QAM,
			  blerlte.CountNum64QAM							AS CountDLNum64QAM,
			  blerlte.CountNum256QAM						AS CountDLNum256QAM,
			  blerlte.CountModulation						AS CountDLModulation,
			  blerlte.MinScheduledPDSCHThroughput			AS MinScheduledPDSCHThroughput,
			  blerlte.AvgScheduledPDSCHThroughput			AS AvgScheduledPDSCHThroughput,
			  blerlte.MaxScheduledPDSCHThroughput			AS MaxScheduledPDSCHThroughput,
			  blerlte.MinNetPDSCHThroughput					AS MinNetPDSCHThroughput,
			  blerlte.AvgNetPDSCHThroughput					AS AvgNetPDSCHThroughput,
			  blerlte.MaxNetPDSCHThroughput					AS MaxNetPDSCHThroughput,
			  blerlte.PDSCHBytesTransfered					AS PDSCHBytesTransfered,
			  blerlte.MinBLER								AS MinDLBLER,
			  blerlte.AvgBLER								AS AvgDLBLER,
			  blerlte.MaxBLER								AS MaxDLBLER,
			  blerlte.MinTBSize								AS MinDLTBSize,
			  blerlte.AvgTBSize								AS AvgDLTBSize,
			  blerlte.MaxTBSize								AS MaxDLTBSize,
			  blerlte.MinTBRate								AS MinDLTBRate,
			  blerlte.AvgTBRate								AS AvgDLTBRate,
			  blerlte.MaxTBRate								AS MaxDLTBRate,
			  ullte.MinULNumCarriers						AS MinULNumCarriers,           
			  ullte.AvgULNumCarriers						AS AvgULNumCarriers,           
			  ullte.MaxULNumCarriers						AS MaxULNumCarriers,           
			  ullte.CountNumBPSK							AS CountULNumBPSK,               
			  ullte.CountNumQPSK							AS CountULNumQPSK,               
			  ullte.CountNum16QAM							AS CountULNum16QAM,              
			  ullte.CountNum64QAM							AS CountULNum64QAM,              
			  ullte.CountModulation							AS CountULModulation,           
			  ullte.MinScheduledPUSCHThroughput				AS MinScheduledPUSCHThroughput,
			  ullte.AvgScheduledPUSCHThroughput				AS AvgScheduledPUSCHThroughput,
			  ullte.MaxScheduledPUSCHThroughput				AS MaxScheduledPUSCHThroughput,
			  ullte.MinNetPUSCHThroughput					AS MinNetPUSCHThroughput,      
			  ullte.AvgNetPUSCHThroughput					AS AvgNetPUSCHThroughput,      
			  ullte.MaxNetPUSCHThroughput					AS MaxNetPUSCHThroughput,      
			  ullte.PUSCHBytesTransfered					AS PUSCHBytesTransfered,       
			  ullte.MinTBSize								AS MinULTBSize,                  
			  ullte.AvgTBSize								AS AvgULTBSize,                  
			  ullte.MaxTBSize								AS MaxULTBSize,                  
			  ullte.MinTBRate								AS MinULTBRate,                  
			  ullte.AvgTBRate								AS AvgULTBRate,                  
			  ullte.MaxTBRate								AS MaxULTBRate, 
			  CASE WHEN s.sessionid in (select distinct sessionid from SessionsB) THEN dbo.NC_GetActivePSC_B(s.SessionId)   
				   ELSE  dbo.NC_GetActivePSC_A(s.SessionId)
				   END AS CA_PCI,
			  -- Based on SwissQual KPI-s Handover Information
			  CASE WHEN s.sessionid in (select distinct sessionid from SessionsB) THEN dbo.NEW_GetHandover_B(s.sessionid)   
				   ELSE  dbo.NEW_GetHandover_A(s.sessionid) 
				   END AS HandoversInfo,
			  -- RRC State as in Telefonica Project
			  CASE WHEN s.sessionid in (select distinct sessionid from SessionsB) THEN dbo.NC_GetRRCStateB(s.sessionid)   
				   ELSE  dbo.NC_GetRRCStateA(s.sessionid) 
				   END AS RRCState
		from (select distinct sessionid from NetworkIdRelation) s
		left outer join #CQI_UMTS cqiumts       on cqiumts.SessionId = s.sessionid		
		left outer join #CQI_LTE cqilte         on cqilte.SessionId = s.sessionid	
		left outer join #BLER_UMTS	blerumts	on blerumts.SessionId = s.sessionid
		left outer join #LTE_DL	blerlte		    on blerlte.SessionId = s.sessionid
		left outer join #TA_GSM	tagsm			on tagsm.SessionId = s.sessionid
		left outer join #TA_LTE	talte			on talte.SessionId = s.sessionid
		left outer join #LTE_UL ullte			on ullte.SessionId = s.sessionid
		WHERE s.SessionId in (select SessionId from #ActSessions) 

		delete from #ActSessions
		where SessionId in (Select SessionId from #ActSessionsTmp)
		set @records = (select COUNT(SessionId) from #ActSessions)
	END
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script execution Completed...')

-- SELECT * FROM NEW_RAN_Session_2018
-- select * from NEW_RAN_Source_Session_2018 where technology like 'G%' and sc1 <> PCI