-- USER RIGHTS CONTROL SCRIPT --

USE demoportal;
EXECUTE AS USER = 'p1m1';
SELECT * 
FROM fn_my_permissions(NULL,'Database')
ORDER BY subentity_name, permission_name ; 
REVERT;
GO
-- p1m1 is able to perform SELECT, INSERT, UPDATE and DELETE commands

EXECUTE AS USER = 'p1m1';
SELECT * 
FROM fn_my_permissions('p1m1', 'User') 
ORDER BY subentity_name, permission_name ; 
REVERT;
GO
-- p1m1's user permissions

/*
-- Create SQL Server users and rights
USE [master]
GO
CREATE LOGIN [Katie] WITH PASSWORD=N'Katie', DEFAULT_DATABASE=[AdventureWorks], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [AdventureWorks]
GO
CREATE USER [Katie] FOR LOGIN [Katie]
GO

USE [AdventureWorks]
GO
ALTER USER [Katie] WITH DEFAULT_SCHEMA=[dbo]
GO

*/

/*
-- Give rights to user

EXEC sp_addrolemember N'db_owner', N'p1m1'
GO

EXEC sp_addrolemember N'db_datareader', N'p1m1'
GO

EXEC sp_addrolemember N'db_datawriter', N'p1m1'
GO
*/