/*
9. Rebuild index

When an index gets fragmented, it requires defragmentation. 
Defragmentation can be done using the rebuild clause when altering a table
. This command is equivalent to DBCC DBREINDEX in SQL Server versions prior to 2005. 
The command that can be used to rebuild the index is as follows:
*/

USE AdventureWorks2008R2;
GO
ALTER INDEX PK_Employee_BusinessEntityID ON HumanResources.Employee
REBUILD;
GO

--If ALL is not specified in rebuild, it will not rebuild a nonclustered index.

/*-
10. REORGANIZE index

Specifies that the index leaf level will be reorganized. 
The REORGANIZE statement is always performed online. 
This command is equivalent to DBCC INDEXDEFRAG in SQL Server versions prior to 2005.
*/

USE AdventureWorks2008R2;
GO
ALTER INDEX PK_ProductPhoto_ProductPhotoID ON Production.ProductPhoto
REORGANIZE ;
GO