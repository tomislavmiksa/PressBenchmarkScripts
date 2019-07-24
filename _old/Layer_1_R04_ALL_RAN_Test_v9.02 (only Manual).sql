/*****************************************************************************************************************************************************************************
============================================================================================================================================================================
Projekt: Pressemessung
   Name: CREATE_NEW_Radio_Access_Network_per_Session
  Autor: NET CHECK GmbH
============================================================================================================================================================================
*****************************************************************************************************************************************************************************/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- History 
-- v1.    -> CREATE
-- v2.    -> mpausin 13.05.2016 sc4 eingefügt
-- v3.    -> mpausin 13.05.2016 Disconnect_LAC,CId,BCCH und LAC,CId,BCCH_A eingefügt
-- v6.    -> mpausin 08.03.2017 Add Workaround for more then one LTE PhyCellId per networkid
-- v7.    -> tmiksa  08.03.2017 Added HO/Reselection Info
-- v7.    -> tmiksa  08.03.2017 Added Basic RF Statistics
-- v8.    -> AST	  17.03.2017 Changed to TestID
-- v9.    -> mpausin 28.03.2017 Add and calculate only new	Test' for the tables NEW_RAN_Source_Test_2018 and NEW_RAN_Test_2018
--							 delete Test from the tables NEW_RAN_Source_Test_2018 and NEW_RAN_Test_2018 if not Testid in table Testinfo.		
-- v9.01  -> tmiksa 08.10.2017 cleanup					 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DELETE OLD RAN TABLES (do only if required)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	IF OBJECT_ID (N'dbo.NEW_RAN_Source_Test_2018', N'U') IS NOT NULL DROP table NEW_RAN_Source_Test_2018
	IF OBJECT_ID (N'dbo.NEW_RAN_Test_2018', N'U') IS NOT NULL DROP table NEW_RAN_Test_2018

	SELECT * FROM NEW_RAN_Source_Test_2018 ORDER BY TestId,SessionId
	SELECT * FROM NEW_RAN_Test_2018 ORDER BY TestId,SessionId
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetLACCIDBCCH') DROP FUNCTION NEW_GetLACCIDBCCH
GO
CREATE FUNCTION NEW_GetLACCIDBCCH(@SessionID bigint,@TestID bigint)
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
            '('+
				isnull(CAST(LAC as varchar(10)),'') +','+ 
				isnull(cast(Cid as varchar(10)),'')+','+
				isnull(cast(BCCH as varchar(10)),'')+
			')'
            from
                  NEW_RAN_Source_Test_2018
            where 
				TestID=@TestID and SessionId = @SessionId and 
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

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetPCI') DROP FUNCTION NEW_GetPCI
GO
CREATE FUNCTION NEW_GetPCI(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestId = @TestID and  SessionId = @SessionId and 
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
CREATE FUNCTION NEW_GetCGI(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestID=@TestID and SessionId = @SessionId and 
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
CREATE FUNCTION NEW_GetMCC(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestId=@TestID and SessionId = @SessionId and 
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
CREATE FUNCTION NEW_GetMNC(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestID=@TestID and SessionId = @SessionId and 
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
CREATE FUNCTION NEW_GetCellID(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestId=@TestId and SessionId = @SessionId and 
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

IF EXISTS (SELECT * FROM   sysobjects  WHERE  name = N'NEW_GetLAC')   DROP FUNCTION NEW_GetLAC
GO
CREATE FUNCTION NEW_GetLAC(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestID=@TestID and SessionId = @SessionId and 
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

IF EXISTS (SELECT * FROM   sysobjects  WHERE  name = N'NEW_GetBCCH')  DROP FUNCTION NEW_GetBCCH
GO
CREATE FUNCTION NEW_GetBCCH(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestID=@TestID and SessionId = @SessionId and 
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

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetSC1')   DROP FUNCTION NEW_GetSC1
GO
CREATE FUNCTION NEW_GetSC1(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestId=@TestId and SessionId = @SessionId and 
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

IF EXISTS (SELECT * FROM   sysobjects  WHERE  name = N'NEW_GetSC2')    DROP FUNCTION NEW_GetSC2
GO
CREATE FUNCTION NEW_GetSC2(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestId=@TestId and SessionId = @SessionId and 
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

IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetSC3')   DROP FUNCTION NEW_GetSC3
GO
CREATE FUNCTION NEW_GetSC3(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestId=@TestId and SessionId = @SessionId and 
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
CREATE FUNCTION NEW_GetSC4(@SessionID bigint,@TestID bigint)
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
                  NEW_RAN_Source_Test_2018
            where 
				TestId=@TestId and SessionId = @SessionId and 
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
CREATE FUNCTION NEW_GetBSIC(@SessionID bigint,@TestID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500) 
	  Declare @Temp as Varchar(50)   
      set @Temp=''     
      set @Result =''
      DECLARE TN_cursor CURSOR  FAST_FORWARD FOR  
            SELECT  BSIC as BSIC
            from
                  NEW_RAN_Source_Test_2018
            where 
				TestId=@TestId and SessionId = @SessionId and 
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
CREATE FUNCTION NEW_GetHandover_A(@SessionID bigint,@TestID bigint)
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

IF EXISTS (SELECT * FROM  sysobjects WHERE  name = N'NEW_GetHandover_B') DROP FUNCTION NEW_GetHandover_B
GO
CREATE FUNCTION NEW_GetHandover_B(@SessionID bigint,@TestID bigint)
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
IF EXISTS (SELECT * FROM sysobjects WHERE name = N'NC_GetRRCStateA') DROP FUNCTION NC_GetRRCStateA
GO
CREATE FUNCTION NC_GetRRCStateA(@SessionID bigint,@TestID bigint)
RETURNS varchar(500)
AS
BEGIN
      
      DECLARE @TN as varchar(50)   
      DECLARE @Result as varchar(500) 
      DECLARE @Temp as Varchar(50)     
      set @Result	=''
      set @Temp		=''

      DECLARE TN_cursor CURSOR  FAST_FORWARD FOR  
            SELECT	
				--ti.TestID,                   
				case when RRCState = 0 then 'Idle'
                     when RRCState = 1 then 'Connected'
                     when RRCState = 2 then 'CELL FACH'
                     when RRCState = 3 then 'CELL DCH'
                     when RRCState = 4 then 'CELL PCH'
                     when RRCState = 5 then 'URA PCH' else null end as RRCState
            from TestInfo AS ti      
            left outer join WCDMARRCState rrc ON ti.TestId = rrc.TestId
            where 
                 ti.TestID=@TestID and  ti.SessionId = @SessionId
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

IF EXISTS (SELECT * FROM sysobjects WHERE name = N'NC_GetActivePSC_A') DROP FUNCTION NC_GetActivePSC_A
go
CREATE FUNCTION NC_GetActivePSC_A(@SessionID bigint,@TestID bigint)
RETURNS varchar(5000)
AS
BEGIN
      
      DECLARE @TN as varchar(50)   
      DECLARE @Result as varchar(5000) 
      DECLARE @Temp as Varchar(50)     
      set @Result	=''
      set @Temp		=''

      DECLARE TN_cursor CURSOR  FAST_FORWARD FOR  
            SELECT                    
				lmr.PhyCellId
            from
				TestInfo AS ti
				left outer join LTEMeasurementReport lmr 
				on ti.TestID = lmr.TestId
            where 
                 ti.TestID=@TestID and ti.SessionId = @SessionId
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING TABLES IF THEY DO NOT EXIST
-- Table: NEW_RAN_Source_Test_2018
-- Table: NEW_RAN_Test_2018
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Starting Script Execeution...')

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Create NEW_RAN_Test_2018 table if it does not exist...')
	IF OBJECT_ID (N'dbo.NEW_RAN_Test_2018', N'U') IS  NULL 
		begin
			CREATE TABLE [dbo].[NEW_RAN_Test_2018](
				[SessionId] [bigint]  NULL,
				[testid]    [bigint]  NULL,
				[MCC] [varchar] (500) NULL,
				[MNC] [varchar] (500) NULL,
				[CellID] [varchar] (500) NULL,
				[LAC] [varchar] (500) NULL,
				[BCCH] [varchar] (500) NULL,
				[SC1] [varchar] (500) NULL,
				[SC2] [varchar] (500) NULL,
				[SC3] [varchar] (500) NULL,
				[SC4] [varchar] (500) NULL,
				[CGI] [varchar] (2000) NULL,
				[BSIC] [varchar] (500) NULL,
				[PCI] [varchar] (2000) NULL,
				[LAC_CId_BCCH] [varchar] (2000) NULL,
				[AvgTA2G] [bigint]  NULL,
				[MaxTA2G] [bigint]  NULL,
				[CQI_HSDPA_Min] [bigint]  NULL,
				[CQI_HSDPA] [bigint]  NULL,
				[CQI_HSDPA_Max] [bigint]  NULL,
				[CQI_HSDPA_StDev] [float]  NULL,
				[ACK3G] [bigint]  NULL,
				[NACK3G] [bigint]  NULL,
				[ACKNACK3G_Total] [bigint]  NULL,
				[BLER3G] [float]  NULL,
				[BLER3GSamples] [bigint]  NULL,
				[StDevBLER3G] [float]  NULL,
				[CQI_LTE_Min] [float]  NULL,
				[CQI0] [float]  NULL,
				[CQI_LTE] [float]  NULL,
				[CQI_LTE_Max] [float]  NULL,
				[CQI_LTE_StDev] [float]  NULL,
				[ACK4G] [bigint]  NULL,
				[NACK4G] [bigint]  NULL,
				[ACKNACK4G_Total] [bigint]  NULL,
				[AvgDLTA4G] [bigint]  NULL,
				[MaxDLTA4G] [bigint]  NULL,
				[LTE_DL_MinDLNumCarriers] [float]  NULL,
				[LTE_DL_AvgDLNumCarriers] [float]  NULL,
				[LTE_DL_MaxDLNumCarriers] [float]  NULL,
				[LTE_DL_MinRB] [float]  NULL,
				[LTE_DL_AvgRB] [float]  NULL,
				[LTE_DL_MaxRB] [float]  NULL,
				[LTE_DL_MinMCS] [float]  NULL,
				[LTE_DL_AvgMCS] [float]  NULL,
				[LTE_DL_MaxMCS] [float]  NULL,
				[LTE_DL_CountNumQPSK] [bigint]  NULL,
				[LTE_DL_CountNum16QAM] [bigint]  NULL,
				[LTE_DL_CountNum64QAM] [bigint]  NULL,
				[LTE_DL_CountNum256QAM] [bigint]  NULL,
				[LTE_DL_CountModulation] [bigint]  NULL,
				[LTE_DL_MinScheduledPDSCHThroughput] [float]  NULL,
				[LTE_DL_AvgScheduledPDSCHThroughput] [float]  NULL,
				[LTE_DL_MaxScheduledPDSCHThroughput] [float]  NULL,
				[LTE_DL_MinNetPDSCHThroughput] [float]  NULL,
				[LTE_DL_AvgNetPDSCHThroughput] [float]  NULL,
				[LTE_DL_MaxNetPDSCHThroughput] [float]  NULL,
				[LTE_DL_PDSCHBytesTransfered] [bigint]  NULL,
				[LTE_DL_MinBLER] [float]  NULL,
				[LTE_DL_AvgBLER] [float]  NULL,
				[LTE_DL_MaxBLER] [float]  NULL,
				[LTE_DL_MinTBSize] [float]  NULL,
				[LTE_DL_AvgTBSize] [float]  NULL,
				[LTE_DL_MaxTBSize] [float]  NULL,
				[LTE_DL_MinTBRate] [float]  NULL,
				[LTE_DL_AvgTBRate] [float]  NULL,
				[LTE_DL_MaxTBRate] [float]  NULL,
				[LTE_DL_TransmissionMode] [varchar] (100) NULL,
				[LTE_UL_MinULNumCarriers] [float]  NULL,
				[LTE_UL_AvgULNumCarriers] [float]  NULL,
				[LTE_UL_MaxULNumCarriers] [float]  NULL,
				[LTE_UL_CountNumBPSK] [bigint]  NULL,
				[LTE_UL_CountNumQPSK] [bigint]  NULL,
				[LTE_UL_CountNum16QAM] [bigint]  NULL,
				[LTE_UL_CountNum64QAM] [bigint]  NULL,
				[LTE_UL_CountModulation] [bigint]  NULL,
				[LTE_UL_MinScheduledPUSCHThroughput] [float]  NULL,
				[LTE_UL_AvgScheduledPUSCHThroughput] [float]  NULL,
				[LTE_UL_MaxScheduledPUSCHThroughput] [float]  NULL,
				[LTE_UL_MinNetPUSCHThroughput] [float]  NULL,
				[LTE_UL_AvgNetPUSCHThroughput] [float]  NULL,
				[LTE_UL_MaxNetPUSCHThroughput] [float]  NULL,
				[LTE_UL_PUSCHBytesTransfered] [bigint]  NULL,
				[LTE_UL_MinTBSize] [float]  NULL,
				[LTE_UL_AvgTBSize] [float]  NULL,
				[LTE_UL_MaxTBSize] [float]  NULL,
				[LTE_UL_MinTBRate] [float]  NULL,
				[LTE_UL_AvgTBRate] [float]  NULL,
				[LTE_UL_MaxTBRate] [float]  NULL,
				[CA_PCI] [varchar](5000) NULL,
				[HandoversInfo] [varchar](5000) NULL
			) 
		end
	go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERT INTO NEW_RAN_Source_Test_2018 TABLE
-- USED FOR FURTHER CALCULATIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Creating NEW_RAN_Source_Test_2018 table...')

if exists (select * from sysobjects where name='NEW_RAN_Source_Test_2018' and xtype='U') drop table NEW_RAN_Source_Test_2018
select *
into NEW_RAN_Source_Test_2018
from
(
		select distinct ni.MsgTime,
						dateadd(ms,ni.duration,ni.MsgTime)		as TimeEnd,
						ni.Networkid,
						nr.sessionid,
						nr.TestId,
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
			(   
			    select distinct Sessionid,TestId,Networkid
				from
				(
					select Sessionid,TestId,StartNetworkid as Networkid  from Testinfo				where TestId <> 0		-- initial Table for Tests, least reliable source
					union all
					select sessionid,TestId,networkid					 from NetworkIdRelation		where TestId <> 0		-- netId Relation a bit more reliable
					union all
					select Sessionid,TestId,Networkid					 from WCDMAActiveSet		where TestId <> 0		-- netId Relation a very reliable in case of UMTS
					union all
					select Sessionid,TestId,Networkid					 from LTEServingCellInfo	where TestId <> 0		-- netId Relation a very reliable in case of LTE
				) as A
			) nr 
			join networkinfo ni on nr.networkid=ni.networkid
			left outer join (select SessionId,TestId,NetworkId,MsgTime,PrimScCode
												from WCDMAActiveSet
												where TestId <> 0 and numCells = 4
												group by SessionId,TestId,NetworkId,MsgTime,PrimScCode) as was
												on was.NetworkId=nr.NetworkId and was.PrimScCode not in(ni.SC1,ni.SC2,ni.SC3)
			) o

UPDATE NEW_RAN_Source_Test_2018
SET PCI = sc1
WHERE technology like 'LTE%' and PCI is null

UPDATE NEW_RAN_Source_Test_2018
SET sc1 = null
WHERE technology like 'LTE%'

	go

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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #CQI_UMTS
-- Table: #CQI_LTE
-- Table: #AckNack_UMTS
-- Table: #AckNack_LTE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING ACK/NACK in 3G...')
	IF OBJECT_ID ('tempdb..#AckNack_UMTS' ) IS NOT NULL DROP TABLE #AckNack_UMTS
	SELECT ti.SessionId,
		   ti.TestId,
		   sum(numACK)		as 'ACK', 
		   sum(numNACK)		as 'NACK'
		into #AckNack_UMTS
		FROM			TestInfo AS ti
		LEFT OUTER JOIN HSDPACQI AS cqi ON ti.TestId = cqi.TestId and ti.SessionId = cqi.SessionId
		GROUP BY ti.SessionId,ti.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING ACK/NACK in 4G...')
	IF OBJECT_ID ('tempdb..#AckNack_LTE' ) IS NOT NULL DROP TABLE #AckNack_LTE
	SELECT  ti.SessionId,
			ti.TestId, 
			SUM(dl.NumAck)		as DL_ACK, 
			SUM(dl.NumNack)		as DL_NACK,
			SUM(ul.NumAck)		as UL_ACK, 
			SUM(ul.NumNack)		as UL_NACK
		into #AckNack_LTE
		FROM			TestInfo AS ti
		LEFT OUTER JOIN LTEDLAckNack AS dl ON ti.TestId = dl.TestId	and ti.SessionId = dl.SessionId
		LEFT OUTER JOIN LTEULAckNack AS ul ON ti.TestId = ul.TestId	and ti.SessionId = ul.SessionId
		GROUP BY ti.SessionId,ti.TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING CQI in 3G...')
	IF OBJECT_ID ('tempdb..#CQI_UMTS' ) IS NOT NULL DROP TABLE #CQI_UMTS
	select SessionId,
		   TestId,
		   sum(cqi.sumCQI)/nullif(sum(cqi.numCQI),0)				as 'CQI_HSDPA',
		   min((cqi.sumCQI)/nullif((cqi.numCQI),0)) 				as 'CQI_HSDPA_Min',
		   max((cqi.sumCQI)/nullif((cqi.numCQI),0))					as 'CQI_HSDPA_Max',
		   round(stdev((cqi.sumCQI)/nullif((cqi.numCQI),0)),1) 		as 'CQI_HSDPA_StDev'
	into #CQI_UMTS
	FROM			
		 HSDPACQI AS	cqi 
	GROUP BY SessionId,TestId

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING CQI in 4G...')
	IF OBJECT_ID ('tempdb..#CQI_LTE' ) IS NOT NULL DROP TABLE #CQI_LTE
	SELECT  SessionId,
			TestId,
			avg(CQI0)							as 'CQI0',
			convert(real,round(Avg(CQI0),0))	as 'CQI_LTE',
			convert(real,round(Min(CQI0),0))	as 'CQI_LTE_Min',
			convert(real,round(Max(CQI0),0))	as 'CQI_LTE_Max',
			convert(real,round(Stdev(CQI0),1))	as 'CQI_LTE_StDev' 
		into #CQI_LTE
		FROM			LTEPUCCHCQI
		GROUP BY SessionId,TestId

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #BLER_UMTS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING BLER in 3G...')
	IF OBJECT_ID ('tempdb..#BLER_UMTS' ) IS NOT NULL DROP TABLE #BLER_UMTS
	SELECT * 
	into #BLER_UMTS
	FROM	(
			SELECT  SessionId,
					TestId, 
					coalesce(sum(nullif((crcError),0)*100.0)/sum(nullif((crcRec),0)),0)		as 'BLER3G',
					count(convert(float,crcerror)*100.0/nullif(convert(float,crcrec),0))	as 'BLER3GSamples',
					stdev(((nullif((crcError),0)*100.0)/(nullif((crcRec),0))))				as 'StDevBLER3G'
			FROM			 WCDMABLER 
			GROUP BY SessionId,TestId	
			) AS t1

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- Table: #LTE_DL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - CALCULATING DL LTE VARIABLES...')
	IF OBJECT_ID ('tempdb..#LTE_DL' ) IS NOT NULL DROP TABLE #LTE_DL
	select SessionId
		  ,TestId
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
	where TestId <> 0
	group by SessionId,TestId

IF OBJECT_ID ('tempdb..#LTE_DL_TM' ) IS NOT NULL DROP TABLE #LTE_DL_TM
SELECT SessionId,TestId,TransmissionMode 
	  ,COUNT(TransmissionMode) AS Number
INTO #LTE_DL_TM
FROM LTEPDSCHStatisticsInfo 
WHERE TestId <> 0
GROUP BY SessionId,TestId,TransmissionMode

IF OBJECT_ID ('tempdb..#LTE_DL_TM_ALL' ) IS NOT NULL DROP TABLE #LTE_DL_TM_ALL
SELECT DISTINCT  SessionId,TestId
				,CAST(null as bigint) AS tm1
				,CAST(null as bigint) AS tm2
				,CAST(null as bigint) AS tm3
				,CAST(null as bigint) AS tm4
				,CAST(null as bigint) AS tm5
				,CAST(null as bigint) AS tm6
				,CAST(null as bigint) AS tm7
				,CAST(null as bigint) AS tm8
				,CAST(null as bigint) AS tm9
				,CAST(null as bigint) AS tm10
				,CAST(null as bigint) AS total
				,cast(null as varchar(100)) AS result
INTO #LTE_DL_TM_ALL
FROM #LTE_DL_TM

UPDATE #LTE_DL_TM_ALL
SET tm1 =  CASE WHEN t1.Number	is not null then t1.Number	ELSE 0 END
   ,tm2 =  CASE WHEN t2.Number	is not null then t2.Number	ELSE 0 END
   ,tm3 =  CASE WHEN t3.Number	is not null then t3.Number	ELSE 0 END
   ,tm4 =  CASE WHEN t4.Number	is not null then t4.Number	ELSE 0 END
   ,tm5 =  CASE WHEN t5.Number	is not null then t5.Number	ELSE 0 END
   ,tm6 =  CASE WHEN t6.Number	is not null then t6.Number	ELSE 0 END
   ,tm7 =  CASE WHEN t7.Number	is not null then t7.Number	ELSE 0 END
   ,tm8 =  CASE WHEN t8.Number	is not null then t8.Number	ELSE 0 END
   ,tm9 =  CASE WHEN t9.Number	is not null then t9.Number	ELSE 0 END
   ,tm10 = CASE WHEN t10.Number	is not null then t10.Number	ELSE 0 END
FROM #LTE_DL_TM_ALL a
LEFT OUTER JOIN #LTE_DL_TM t1  ON a.SessionId = t1.SessionId and a.TestId = t1.TestId and t1.TransmissionMode = 1
LEFT OUTER JOIN #LTE_DL_TM t2  ON a.SessionId = t2.SessionId and a.TestId = t2.TestId and t2.TransmissionMode = 2
LEFT OUTER JOIN #LTE_DL_TM t3  ON a.SessionId = t3.SessionId and a.TestId = t3.TestId and t3.TransmissionMode = 3
LEFT OUTER JOIN #LTE_DL_TM t4  ON a.SessionId = t4.SessionId and a.TestId = t4.TestId and t4.TransmissionMode = 4
LEFT OUTER JOIN #LTE_DL_TM t5  ON a.SessionId = t5.SessionId and a.TestId = t5.TestId and t5.TransmissionMode = 5
LEFT OUTER JOIN #LTE_DL_TM t6  ON a.SessionId = t6.SessionId and a.TestId = t6.TestId and t6.TransmissionMode = 6
LEFT OUTER JOIN #LTE_DL_TM t7  ON a.SessionId = t7.SessionId and a.TestId = t7.TestId and t7.TransmissionMode = 7
LEFT OUTER JOIN #LTE_DL_TM t8  ON a.SessionId = t8.SessionId and a.TestId = t8.TestId and t8.TransmissionMode = 8
LEFT OUTER JOIN #LTE_DL_TM t9  ON a.SessionId = t9.SessionId and a.TestId = t9.TestId and t9.TransmissionMode = 9
LEFT OUTER JOIN #LTE_DL_TM t10 ON a.SessionId = t10.SessionId and a.TestId = t10.TestId and t10.TransmissionMode = 10

UPDATE #LTE_DL_TM_ALL
SET total = tm1 + tm2 + tm3 + tm4 + tm5 + tm6 + tm7 + tm8 + tm9 + tm10

UPDATE #LTE_DL_TM_ALL
SET result = CASE WHEN tm1  > 0 THEN 'tm1(' + CAST(CAST(100.0*tm1/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm2  > 0 THEN 'tm2(' + CAST(CAST(100.0*tm2/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm3  > 0 THEN 'tm3(' + CAST(CAST(100.0*tm3/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm4  > 0 THEN 'tm4(' + CAST(CAST(100.0*tm4/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm5  > 0 THEN 'tm5(' + CAST(CAST(100.0*tm5/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm6  > 0 THEN 'tm6(' + CAST(CAST(100.0*tm6/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm7  > 0 THEN 'tm7(' + CAST(CAST(100.0*tm7/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm8  > 0 THEN 'tm8(' + CAST(CAST(100.0*tm8/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm9  > 0 THEN 'tm9(' + CAST(CAST(100.0*tm9/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END +
			 CASE WHEN tm10 > 0 THEN 'tm10(' + CAST(CAST(100.0*tm10/total as decimal(10,2)) AS varchar(10)) + '%), ' ELSE '' END

UPDATE #LTE_DL_TM_ALL
SET result = CASE WHEN LEN(result) > 2 THEN LEFT(result, LEN(result)-1) ELSE '' END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALCULTE TEMPORARLY TABLE 
-- USED FOR FURTHER CALCULATIONS
-- TBs we are unable to calculate for Exynos Chipset
-- PUSCHBytesTransfered unable to calculate for Exynos Chipset
-- Table: #LTE_UL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('tempdb..#LTE_UL' ) IS NOT NULL DROP TABLE #LTE_UL
select SessionId
	  ,TestId 
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
group by Sessionid,TestId
order by TestId,SessionId

insert into  NEW_RAN_Test_2018
select distinct  ti.SessionId
			    ,ti.testid
				,dbo.NEW_GetMCC(ti.SessionId,ti.TestId)			as MCC
				,dbo.NEW_GetMNC(ti.SessionId,ti.TestId)			as MNC
				,dbo.NEW_GetCellID(ti.SessionId,ti.TestId)		as CellID
				,dbo.NEW_GetLAC(ti.SessionId,ti.TestId)			as LAC
				,dbo.NEW_GetBCCH(ti.SessionId,ti.TestId)		as BCCH
				,dbo.NEW_GetSC1(ti.SessionId,ti.TestId)			as SC1
				,dbo.NEW_GetSC2(ti.SessionId,ti.TestId)			as SC2
				,dbo.NEW_GetSC3(ti.SessionId,ti.TestId)			as SC3
				,dbo.NEW_GetSC4(ti.SessionId,ti.TestId)			as SC4
				,dbo.NEW_GetCGI(ti.SessionId,ti.TestId)			as CGI
				,dbo.NEW_GetBSIC(ti.SessionId,ti.TestId)		as BSIC
				,dbo.NEW_GetPCI(ti.SessionId,ti.TestId)			as PCI
				,dbo.NEW_GetLACCIDBCCH(ti.SessionId,ti.TestId)	as LAC_CId_BCCH
				-- GSM Specific
				,tagsm.AvgTA									as AvgTA2G
				,tagsm.MaxTA									as MaxTA2G
				-- UMTS SPECIFIC
				,cqiumts.CQI_HSDPA_Min
				,cqiumts.CQI_HSDPA
				,cqiumts.CQI_HSDPA_Max
				,cqiumts.CQI_HSDPA_StDev
				,ackumts.ACK									as ACK3G
				,ackumts.NACK									as NACK3G
				,ackumts.ACK + ackumts.NACK						as ACKNACK3G_Total
				,blerumts.[BLER3G]
				,blerumts.[BLER3GSamples]
				,blerumts.[StDevBLER3G]
				-- LTE SPECIFIC
				,cqilte.CQI_LTE_Min	
				,cqilte.CQI0	
				,cqilte.CQI_LTE
				,cqilte.CQI_LTE_Max	
				,cqilte.CQI_LTE_StDev 
				,acklte.UL_ACK +  acklte.DL_ACK 										AS ACK4G
				,acklte.UL_NACK + acklte.DL_NACK										AS NACK4G
				,acklte.UL_ACK +  acklte.DL_ACK +  acklte.UL_NACK +  acklte.DL_NACK		AS ACKNACK4G_Total
				,talte.AvgTA								AS AvgDLTA4G
				,talte.MaxTA								AS MaxDLTA4G
				,blerlte.MinDLNumCarriers					AS LTE_DL_MinDLNumCarriers
				,blerlte.AvgDLNumCarriers					AS LTE_DL_AvgDLNumCarriers
				,blerlte.MaxDLNumCarriers					AS LTE_DL_MaxDLNumCarriers
				,blerlte.MinRB								AS LTE_DL_MinRB
				,blerlte.AvgRB								AS LTE_DL_AvgRB
				,blerlte.MaxRB								AS LTE_DL_MaxRB
				,blerlte.MinMCS								AS LTE_DL_MinMCS
				,blerlte.AvgMCS								AS LTE_DL_AvgMCS
				,blerlte.MaxMCS								AS LTE_DL_MaxMCS
				,blerlte.CountNumQPSK						AS LTE_DL_CountNumQPSK
				,blerlte.CountNum16QAM						AS LTE_DL_CountNum16QAM
				,blerlte.CountNum64QAM						AS LTE_DL_CountNum64QAM
				,blerlte.CountNum256QAM						AS LTE_DL_CountNum256QAM
				,blerlte.CountModulation					AS LTE_DL_CountModulation
				,blerlte.MinScheduledPDSCHThroughput		AS LTE_DL_MinScheduledPDSCHThroughput
				,blerlte.AvgScheduledPDSCHThroughput		AS LTE_DL_AvgScheduledPDSCHThroughput
				,blerlte.MaxScheduledPDSCHThroughput		AS LTE_DL_MaxScheduledPDSCHThroughput
				,blerlte.MinNetPDSCHThroughput				AS LTE_DL_MinNetPDSCHThroughput
				,blerlte.AvgNetPDSCHThroughput				AS LTE_DL_AvgNetPDSCHThroughput
				,blerlte.MaxNetPDSCHThroughput				AS LTE_DL_MaxNetPDSCHThroughput
				,blerlte.PDSCHBytesTransfered				AS LTE_DL_PDSCHBytesTransfered
				,blerlte.MinBLER							AS LTE_DL_MinBLER
				,blerlte.AvgBLER							AS LTE_DL_AvgBLER
				,blerlte.MaxBLER							AS LTE_DL_MaxBLER
				,blerlte.MinTBSize							AS LTE_DL_MinTBSize
				,blerlte.AvgTBSize							AS LTE_DL_AvgTBSize
				,blerlte.MaxTBSize							AS LTE_DL_MaxTBSize
				,blerlte.MinTBRate							AS LTE_DL_MinTBRate
				,blerlte.AvgTBRate							AS LTE_DL_AvgTBRate
				,blerlte.MaxTBRate							AS LTE_DL_MaxTBRate
				,ltm.result									AS LTE_DL_TransmissionMode
				,ullte.MinULNumCarriers						AS LTE_UL_MinULNumCarriers
				,ullte.AvgULNumCarriers						AS LTE_UL_AvgULNumCarriers
				,ullte.MaxULNumCarriers						AS LTE_UL_MaxULNumCarriers
				,ullte.CountNumBPSK							AS LTE_UL_CountNumBPSK
				,ullte.CountNumQPSK							AS LTE_UL_CountNumQPSK
				,ullte.CountNum16QAM						AS LTE_UL_CountNum16QAM
				,ullte.CountNum64QAM						AS LTE_UL_CountNum64QAM
				,ullte.CountModulation						AS LTE_UL_CountModulation
				,ullte.MinScheduledPUSCHThroughput			AS LTE_UL_MinScheduledPUSCHThroughput
				,ullte.AvgScheduledPUSCHThroughput			AS LTE_UL_AvgScheduledPUSCHThroughput
				,ullte.MaxScheduledPUSCHThroughput			AS LTE_UL_MaxScheduledPUSCHThroughput
				,ullte.MinNetPUSCHThroughput				AS LTE_UL_MinNetPUSCHThroughput
				,ullte.AvgNetPUSCHThroughput				AS LTE_UL_AvgNetPUSCHThroughput
				,ullte.MaxNetPUSCHThroughput				AS LTE_UL_MaxNetPUSCHThroughput
				,ullte.PUSCHBytesTransfered					AS LTE_UL_PUSCHBytesTransfered
				,ullte.MinTBSize							AS LTE_UL_MinTBSize
				,ullte.AvgTBSize							AS LTE_UL_AvgTBSize
				,ullte.MaxTBSize							AS LTE_UL_MaxTBSize
				,ullte.MinTBRate							AS LTE_UL_MinTBRate
				,ullte.AvgTBRate							AS LTE_UL_AvgTBRate
				,ullte.MaxTBRate							AS LTE_UL_MaxTBRate
				,dbo.NC_GetActivePSC_A(ti.SessionId,ti.TestId) AS CA_PCI
				-- Based on SwissQual KPI-s Handover Information
				,CASE WHEN ti.SessionId in (SELECT sessionId from sessions) THEN dbo.NEW_GetHandover_A(ti.SessionId,ti.TestId)
					ELSE dbo.NEW_GetHandover_B(ti.SessionId,ti.TestId)  
					END AS HandoversInfo
from  NEW_RAN_Source_Test_2018 ti 
left outer join  NEW_RAN_Test_2018 n	 on ti.sessionid=n.sessionid	 and ti.testid=n.testid
left outer join #CQI_UMTS cqiumts		 on ti.TestId = cqiumts.TestId	 and ti.SessionId = cqiumts.SessionId
left outer join #CQI_LTE cqilte			 on ti.TestId = cqilte.TestId	 and ti.SessionId = cqilte.SessionId	
left outer join #AckNack_LTE acklte      on ti.TestId = acklte.TestId	 and ti.SessionId = acklte.SessionId
left outer join #AckNack_UMTS ackumts    on ti.TestId = ackumts.TestId	 and ti.SessionId = ackumts.SessionId
left outer join #BLER_UMTS	blerumts	 on ti.TestId = blerumts.TestId	 and ti.SessionId = blerumts.SessionId
left outer join #LTE_DL	blerlte		     on ti.TestId = blerlte.TestId	 and ti.SessionId = blerlte.SessionId
left outer join #TA_GSM	tagsm			 on ti.TestId = tagsm.TestId	 and ti.SessionId = tagsm.SessionId
left outer join #TA_LTE	talte			 on ti.TestId = talte.TestId	 and ti.SessionId = talte.SessionId	
left outer join #LTE_UL ullte			 on ti.TestId = ullte.TestId	 and ti.SessionId = ullte.SessionId
left outer join #LTE_DL_TM_ALL ltm		 on ti.TestId = ltm.TestId		 and ti.SessionId = ltm.SessionId
where n.testid is null

PRINT(CONVERT(VARCHAR,GETDATE(),120) +  '  - Script execution Completed...')



-- select * from NEW_RAN_Test_2018 order by testid,sessionid
-- select * from NEW_RAN_Source_Test_2018
-- select * from NEW_RAN_Test_2018