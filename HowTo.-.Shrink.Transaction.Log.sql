USE TriVioCloudDB


PRINT N'There is no live show, process starting...'
		
CHECKPOINT
PRINT N'- Checkpoint completed.'

DBCC SHRINKFILE ('TriVioCloudDB_Log', 1)
PRINT N'- TriVioCloudDB_Log file shrinked.'

DBCC SHRINKDATABASE (TriVioCloudDB, TRUNCATEONLY)
Print N'- Pass the freed pages back to OS control.'

