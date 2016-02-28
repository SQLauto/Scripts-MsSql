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


