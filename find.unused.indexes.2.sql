
-- Find Unused Indexes
-- https://www.mssqltips.com/sqlservertutorial/256/discovering-unused-indexes/


/*
--This DMV allows you to see insert, update and delete information for various aspects for an index.  
--Basically this shows how much effort was used in maintaining the index based on data changes.

SELECT OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       A.LEAF_INSERT_COUNT, 
       A.LEAF_UPDATE_COUNT, 
       A.LEAF_DELETE_COUNT 
FROM   SYS.DM_DB_INDEX_OPERATIONAL_STATS (db_id(),NULL,NULL,NULL ) A 
       INNER JOIN SYS.INDEXES AS I 
         ON I.[OBJECT_ID] = A.[OBJECT_ID] 
            AND I.INDEX_ID = A.INDEX_ID 
WHERE  OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1;
*/



/*
Here we can see seeks, scans, lookups and updates. 

    The seeks refer to how many times an index seek occurred for that index.  A seek is the fastest way to access the data, so this is good.
    The scans refers to how many times an index scan occurred for that index.  A scan is when multiple rows of data had to be searched to find the data.  Scans are something you want to try to avoid.
    The lookups refer to how many times the query required data to be pulled from the clustered index or the heap (does not have a clustered index).  Lookups are also something you want to try to avoid.
    The updates refers to how many times the index was updated due to data changes which should correspond to the first query above.

*/
SELECT OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       USER_SEEKS, 
       USER_SCANS, 
       USER_LOOKUPS, 
       USER_UPDATES,
	   'DROP INDEX ['+I.[NAME]+'] ON ['+OBJECT_NAME(S.[OBJECT_ID])+']'
FROM   SYS.DM_DB_INDEX_USAGE_STATS AS S 
       INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID 
WHERE  OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
       AND S.database_id = DB_ID()
	   AND I.type_desc <> 'CLUSTERED'
	 --  and (
		--USER_SEEKS = 0 
		--AND 
		--USER_LOOKUPS = 0
		--AND 
		--USER_SCANS = 0
	 --  )

	 --  select * from sys.indexes




/*

DROP INDEX [IX_history_base_201542116132053288] ON [history_base]
DROP INDEX [IX_history_base_201542116132053184] ON [history_base]
DROP INDEX [IX_history_detail_2015420125241207803] ON [history_detail]

*/