/*****************************************************************************************************************************************************************************
============================================================================================================================================================================
Projekt: Pressemessung
   Name: CREATE_NEW_Operator
  Autor: NET CHECK GmbH
============================================================================================================================================================================
*****************************************************************************************************************************************************************************/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- History 
-- v01. -> Create
-- v02. ->
-- v03. ->
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Alte Tabellen mit Daten löschen--------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_Operator')			DROP Table NEW_Operator
GO
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetServiceOperator')	DROP FUNCTION NEW_GetServiceOperator
GO
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetServiceMCC')		DROP FUNCTION NEW_GetServiceMCC
GO
IF EXISTS (SELECT * FROM   sysobjects WHERE  name = N'NEW_GetServiceMNC')		DROP FUNCTION NEW_GetServiceMNC
GO

CREATE FUNCTION NEW_GetServiceOperator(@Sessionid bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500) 
	  Declare @Temp as Varchar(50)   
      set @Temp=''   
      set @Result =''
      DECLARE TN_cursor CURSOR FOR 
            select Operator 
			from 
				NetworkIdRelation nr
				join NetworkInfo ni on nr.NetworkId=ni.NetworkId
            where 
				SessionId=@Sessionid and
				Operator is not null 
				
            order by nr.MsgTime
      
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

CREATE FUNCTION NEW_GetServiceMCC(@Sessionid bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500) 
	  Declare @Temp as Varchar(50)   
      set @Temp=''     
      set @Result =''
      DECLARE TN_cursor CURSOR FOR 
            select  MCC 
			from 
				NetworkIdRelation nr
				join NetworkInfo ni on nr.NetworkId=ni.NetworkId
            where 
				SessionId=@Sessionid and
				Operator is not null 
            order by nr.MsgTime
      
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

CREATE FUNCTION NEW_GetServiceMNC(@Sessionid bigint)
RETURNS varchar(500)
AS
BEGIN
      
      Declare @TN as varchar(50)   
      Declare @Result as varchar(500)
	  Declare @Temp as Varchar(50)   
      set @Temp=''         
      set @Result =''
      DECLARE TN_cursor CURSOR FOR 
            select  MNC 
			from 
				NetworkIdRelation nr
				join NetworkInfo ni on nr.NetworkId=ni.NetworkId
            where 
				SessionId=@Sessionid and
				Operator is not null 
            order by nr.MsgTime
      
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


select 
	ta.sessionid as Sessionid,
	ta.HomeOperator as HomeOperator,
	ta.HoMCC as HomeMCC,
	ta.HoMNC as HomeMNC,
	dbo.NEW_GetServiceOperator(ta.SessionId) as ServiceOperator,
	dbo.NEW_GetServiceMCC(ta.sessionid)	     as MCC,
	dbo.NEW_GetServiceMNC(ta.sessionid)	     as MNC
into NEW_Operator
from 
	(
		Select distinct nr.sessionid as Sessionid,
			   HomeOperator,
			   HoMCC,
			   HoMNC
		from
			NetworkIdRelation nr 
			join NetworkInfo ni on nr.NetworkId=ni.NetworkId 
	) ta

update NEW_Operator
set HomeOperator = 'o2'
where HomeOperator like '262/07'
	
	
--##################################################################################################################
--Result--**********************************************************************************************************
--##################################################################################################################
/*
select * 
from NEW_Operator
ORDER BY Sessionid
*/