DECLARE
@db nvarchar(max)

BEGIN
DECLARE #cd CURSOR LOCAL FAST_FORWARD FOR
SELECT [name] FROM master..sysdatabases
WHERE [name] NOT IN (‘tempdb’,’master’)

OPEN #cd
FETCH NEXT FROM #cd INTO @db

WHILE(@@fetch_status=0)
BEGIN
EXEC (‘ALTER DATABASE [‘ + @db + ‘] SET RECOVERY SIMPLE’)
FETCH NEXT FROM #cd INTO @db
END

CLOSE #cd
DEALLOCATE #cd

END