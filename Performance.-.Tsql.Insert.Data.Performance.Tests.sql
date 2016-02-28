/*
SQL Server Insert Data Performance Tests
http://stackoverflow.com/questions/10819/sql-auxiliary-table-of-numbers/2663232#2663232

*/
--===== Test for 100000 rows ==================================
GO
--===== Traditional RECURSIVE CTE method
   WITH Tally (N) AS 
        ( 
         SELECT 1 UNION ALL 
         SELECT 1 + N FROM Tally WHERE N < 100000 
        ) 
 SELECT N 
   INTO #Tally1 
   FROM Tally 
 OPTION (MAXRECURSION 0);
GO
--===== Traditional WHILE LOOP method
 CREATE TABLE #Tally2 (N INT);
    SET NOCOUNT ON;
DECLARE @Index INT;
    SET @Index = 1;
  WHILE @Index <= 100000 
  BEGIN 
         INSERT #Tally2 (N) 
         VALUES (@Index);
            SET @Index = @Index + 1;
    END;
GO
--===== Traditional CROSS JOIN table method
 SELECT TOP (100000)
        ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS N
   INTO #Tally3
   FROM Master.sys.All_Columns ac1
  CROSS JOIN Master.sys.ALL_Columns ac2;
GO
--===== Itzik's CROSS JOINED CTE method
   WITH E00(N) AS (SELECT 1 UNION ALL SELECT 1),
        E02(N) AS (SELECT 1 FROM E00 a, E00 b),
        E04(N) AS (SELECT 1 FROM E02 a, E02 b),
        E08(N) AS (SELECT 1 FROM E04 a, E04 b),
        E16(N) AS (SELECT 1 FROM E08 a, E08 b),
        E32(N) AS (SELECT 1 FROM E16 a, E16 b),
   cteTally(N) AS (SELECT ROW_NUMBER() OVER (ORDER BY N) FROM E32)
 SELECT N
   INTO #Tally4
   FROM cteTally
  WHERE N <= 100000;
GO
--===== Housekeeping
   DROP TABLE #Tally1, #Tally2, #Tally3, #Tally4;
GO