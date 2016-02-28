/*
Increase Size of Temp DB 
http://www.sqlhacks.com/Optimize/IncreaseSizeTempdb
*/

--Get the current size of TEMPDB
USE master;
go

SELECT name AS 'File', 
       CAST(CAST(size*1.0/128 AS DECIMAL(9,2)) AS VARCHAR(12)) + ' Mb' AS 'File Size',
       CASE max_size WHEN 0 THEN 'Off'
                     WHEN -1 THEN 'On'
                     ELSE 'Will grow to 2 Tb'
       END AS 'Auto Growth',
       growth AS 'Growth',
       CASE WHEN growth = 0 THEN 'size is fixed and will not grow'
            WHEN growth > 0 and is_percent_growth = 0 THEN 'Growth in 8Kb pages'
            ELSE '%'
       END AS 'Increment'
FROM tempdb.sys.database_files;
GO

--Increase the size of TEMPDB
USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = 'tempdev', SIZE = 10MB);
GO

-- Verification
USE tempdb 
GO 
EXEC SP_SPACEUSED;
go