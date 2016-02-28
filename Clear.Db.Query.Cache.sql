-- Using DBCC FREEPROCCACHE will clear the procedure cache and remove all cached query plans.
DBCC FREEPROCCACHE
/*
It must be noted that this could have a performance impact, 
as SQL Server will have to compile all queries until the cache is up to size again.

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
*/