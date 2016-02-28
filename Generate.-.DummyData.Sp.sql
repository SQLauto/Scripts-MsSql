USE [Testing]
GO
/****** Object:  StoredProcedure [dbo].[CreateSampleData]    Script Date: 05/13/2011 12:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jeff Moden
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CreateSampleData] 

AS

--===== Preset the environment for appearance and speed    
SET NOCOUNT ON

--===== If the test table already exists, drop it in case we need to rerun.     
-- The 3 part naming is overkill, but prevents accidents on real tables.     
IF OBJECT_ID('TempDB.dbo.TransactionDetail') IS NOT NULL        
DROP TABLE TempDB.dbo.TransactionDetail

--===== Create the test table (TransactionDetail) with a NON clustered PK 
CREATE TABLE TempDB.dbo.TransactionDetail        (        
	TransactionDetailID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,      
	[Date]              DATETIME,        
	AccountID           INT,        
	Amount              MONEY,
	Sentence			VARCHAR(200),        
	AccountRunningTotal MONEY,  --Running total across each account        
	AccountRunningCount INT,    --Like "Rank" across each account        
	NCID                INT)

INSERT INTO TempDB.dbo.TransactionDetail (Date, AccountID, Amount, Sentence)
     SELECT TOP 100000                
     --10 years worth of dates with times from 1/1/2000 to 12/31/2009                
     CAST(RAND(CHECKSUM(NEWID()))*3653.0+36524.0 AS DATETIME) AS Date,                
     --100 different account numbers                
     ABS(CHECKSUM(NEWID()))%100+1,                
     --Dollar amounts from -99.99 to + 99.99                
     CAST(CHECKSUM(NEWID())%10000 /100.0 AS MONEY),
     --Randomised number of words
     iTVF.Sentence          
FROM Master.dbo.SysColumns sc1          
CROSS JOIN Master.dbo.SysColumns sc2
CROSS APPLY (
	SELECT Word AS 'data()'
	FROM (
		SELECT TOP ((sc1.colorder*sc2.colorder)%9+1) word 
		FROM (
		SELECT word = CAST('the' AS VARCHAR(200)) UNION ALL 
		SELECT 'quick' UNION ALL 
		SELECT 'brown' UNION ALL 
		SELECT 'fox' UNION ALL 
		SELECT 'jumped' UNION ALL
		SELECT 'over' UNION ALL 
		SELECT 'the' UNION ALL 
		SELECT 'lazy' UNION ALL 
		SELECT 'dog'
		) Words ORDER BY NEWID()) u2
	FOR XML PATH('') 
		
) iTVF(Sentence)  

RETURN 0

SELECT * FROM TempDB.dbo.TransactionDetail