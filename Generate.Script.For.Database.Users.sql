/* ----------------------------------------------------
  DB User Permission / Role generation .
  Jeyong Park
  11/17/2014
 
  For a database User backup or copy to
  other database that includes it's permissions.
 
    Generate script for a database users.
---------------------------------------------------- */
SET NOCOUNT ON
 
DECLARE @DatabaseUserName [sysname]
SET @DatabaseUserName = NULL  --<<-- 'user_name_goes_here'
 
DECLARE
@errStatement [varchar](8000),
@msgStatement [varchar](8000),
@DatabaseUserID [smallint],
@ServerUserName [sysname],
@DBUserName     [sysname],
@RoleName [varchar](8000),
@ObjectID [int],
@ObjectName [varchar](261),
@cnt  [int]
 
PRINT '--Security creation script for Database [' + DB_NAME() + ']' + CHAR(13)+CHAR(10) +
      '--Created At: ' + CONVERT(varchar, GETDATE()) + CHAR(13)+CHAR(10) +
      'USE [' + DB_NAME() + ']' + CHAR(13)+CHAR(10) +
      'GO' + CHAR(13)+CHAR(10)
 
 
/* ---------- DB roles copy first  --------------- */
 
-- IF NULL, then search for whole DB users
IF @DatabaseUserName IS NULL
    DECLARE C_RoleName CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
        SELECT [name] FROM [dbo].[sysusers] 
        WHERE gid != 0 AND gid < 10000
ELSE
    DECLARE C_RoleName CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
        SELECT [name] FROM [dbo].[sysusers] 
        WHERE gid != 0 AND gid < 10000
         AND [uid] IN (SELECT [groupuid] FROM [dbo].[sysmembers] WHERE [memberuid] = USER_ID(@DatabaseUserName) )
  
 
    OPEN C_RoleName
    FETCH NEXT FROM C_RoleName INTO @RoleName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @msgStatement = '-- CREATE Role : ' + @RoleName + CHAR(13)+CHAR(10) +
        'IF NOT Exists(select name from sysusers where name ='''+@RoleName+''' WHERE gid !=0 )'+ CHAR(13)+CHAR(10) +
        '   CREATE ROLE ' + @RoleName + CHAR(13)+CHAR(10) + 'GO' 
        PRINT @msgStatement
 
        /* ------------ Set Role secruables ------------------ */
        DECLARE C_RoleSec CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
        select CASE prm.state WHEN  'D' THEN 'DENY ' ELSE 'GRANT ' END 
        + prm.permission_name 
        + CASE prm.class    
            WHEN 0 THEN ' '     -- database permission
            WHEN 3 THEN ' ON SCHEMA::' + SCHEMA_NAME(major_id)   -- schema permission
            WHEN 4 THEN (select ' ON ROLE::'+ x.name collate SQL_Latin1_General_CP1_CI_AS  from sys.database_principals x WHERE x.principal_id = prm.major_id)
            ELSE ' ON '+ OBJECT_NAME(major_id) END
        +' TO '
        + rol.name collate SQL_Latin1_General_CP1_CI_AS 
        + CASE prm.state WHEN 'W' THEN '  WITH GRANT OPTION' ELSE '' END
        from sys.database_permissions prm
        join sys.database_principals rol on prm.grantee_principal_id = rol.principal_id
        where rol.type = 'R'
          AND rol.name = @RoleName
 
        OPEN C_RoleSec
        FETCH NEXT FROM C_RoleSec INTO @msgStatement
        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT @msgStatement
            FETCH NEXT FROM C_RoleSec INTO @msgStatement
        END
        CLOSE C_RoleSec
        DEALLOCATE C_RoleSec
        PRINT 'Go'
 
        FETCH NEXT FROM C_RoleName INTO @RoleName
    END
    CLOSE C_RoleName
    DEALLOCATE C_RoleName
 
 
/* ---------- DB user permission generate  --------------- */
 
-- IF NULL, then search for whole DB users
IF @DatabaseUserName IS NULL
    DECLARE login_curs CURSOR FOR
    SELECT SU.[uid], SL.[loginname], SU.[name]
      FROM [dbo].[sysusers] SU INNER JOIN [master].[dbo].[syslogins] SL ON SU.[sid] = SL.[sid]
    WHERE SU.[name] not in ('public','dbo','guest','sys')
    ORDER BY [loginname]
-- ELSE search only for @DatabaseUserName
ELSE
--  DECLARE login_curs CURSOR FOR
    SELECT SU.[uid], SL.[loginname], SU.[name]
      FROM [dbo].[sysusers] SU INNER JOIN [master].[dbo].[syslogins] SL ON SU.[sid] = SL.[sid]
    WHERE SL.[loginname] = @DatabaseUserName
      AND SU.[name] not in ('public','dbo','guest','sys')
 
OPEN login_curs
FETCH NEXT FROM login_curs INTO @DatabaseUserID, @ServerUserName, @DBUserName
IF  (@@fetch_status = -1)
BEGIN
    CLOSE login_curs
    DEALLOCATE login_curs
     
    IF (@DatabaseUserName IS NOT NULL)
    BEGIN
        SET @errStatement = 'User ' + @DatabaseUserName + ' does not exist in ' + DB_NAME() + CHAR(13)+CHAR(10) + 
        'Please provide the name of a current user in ' + DB_NAME() + ' OR put NULL to search all.'
    END
    ELSE
        SET @errStatement = 'No login(s) found.'
    RAISERROR(@errStatement, 16, 1)
END
 
WHILE @@FETCH_STATUS = 0
BEGIN
    IF (@ServerUserName = 'sa')
        FETCH NEXT FROM login_curs INTO @DatabaseUserID, @ServerUserName, @DBUserName
 
    SET @msgStatement = 
    '-------------- Add User : ' + @ServerUserName + CHAR(13)+CHAR(10) +
    'IF NOT Exists(select name from sysusers where name ='''+@DBUserName+''')'+ CHAR(13)+CHAR(10) +
    '   EXEC [sp_grantdbaccess] @loginame = [' + @ServerUserName + '], @name_in_db = [' + @DBUserName + ']' + CHAR(13)+CHAR(10) +
    'GO' + CHAR(13)+CHAR(10) + '--Add User To Roles'
    PRINT @msgStatement
 
    DECLARE _sysusers CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
        SELECT [name] FROM [dbo].[sysusers] 
        WHERE [uid] IN (SELECT [groupuid] FROM [dbo].[sysmembers] WHERE [memberuid] = @DatabaseUserID )
    OPEN _sysusers
    FETCH NEXT FROM _sysusers INTO @RoleName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @msgStatement = 'EXEC [sp_addrolemember] @rolename = ''' + @RoleName + ''', @membername = [' + @DBUserName + ']'
        PRINT @msgStatement
        FETCH NEXT FROM _sysusers INTO @RoleName
    END
    CLOSE _sysusers
    DEALLOCATE _sysusers
 
    SET @msgStatement = 'GO' + CHAR(13)+CHAR(10) + '--Set Object Specific Permissions'
    PRINT @msgStatement
 
    DECLARE _sysobjects CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
        SELECT DISTINCT([sysobjects].[id]), '[' + USER_NAME([sysobjects].[uid]) + '].[' + [sysobjects].[name] + ']'
        FROM [dbo].[sysprotects]
        INNER JOIN [dbo].[sysobjects]
            ON [sysprotects].[id] = [sysobjects].[id]
        WHERE [sysprotects].[uid] = @DatabaseUserID
    OPEN _sysobjects
    SET @cnt = 0
    FETCH NEXT FROM _sysobjects INTO @ObjectID, @ObjectName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @msgStatement = ''
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 193 AND [protecttype] = 205)
        SET @msgStatement = @msgStatement + 'SELECT,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 195 AND [protecttype] = 205)
        SET @msgStatement = @msgStatement + 'INSERT,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 197 AND [protecttype] = 205)
        SET @msgStatement = @msgStatement + 'UPDATE,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 196 AND [protecttype] = 205)
        SET @msgStatement = @msgStatement + 'DELETE,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 224 AND [protecttype] = 205)
        SET @msgStatement = @msgStatement + 'EXECUTE,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 26 AND [protecttype] = 205)
        SET @msgStatement = @msgStatement + 'REFERENCES,'
        IF LEN(@msgStatement) > 0
        BEGIN
            IF RIGHT(@msgStatement, 1) = ','
            SET @msgStatement = LEFT(@msgStatement, LEN(@msgStatement) - 1)
            SET @msgStatement = 'GRANT '+@msgStatement+' ON '+@ObjectName+' TO ['+ @DBUserName+']'
            PRINT @msgStatement
            SET @cnt = @cnt +1
        END
        SET @msgStatement = ''
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 193 AND [protecttype] = 206)
        SET @msgStatement = @msgStatement + 'SELECT,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 195 AND [protecttype] = 206)
        SET @msgStatement = @msgStatement + 'INSERT,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 197 AND [protecttype] = 206)
        SET @msgStatement = @msgStatement + 'UPDATE,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 196 AND [protecttype] = 206)
        SET @msgStatement = @msgStatement + 'DELETE,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 224 AND [protecttype] = 206)
        SET @msgStatement = @msgStatement + 'EXECUTE,'
        IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseUserID AND [action] = 26 AND [protecttype] = 206)
        SET @msgStatement = @msgStatement + 'REFERENCES,'
        IF LEN(@msgStatement) > 0
        BEGIN
            IF RIGHT(@msgStatement, 1) = ','
            SET @msgStatement = LEFT(@msgStatement, LEN(@msgStatement) - 1)
            SET @msgStatement = 'DENY '+@msgStatement+' ON '+@ObjectName+' TO [' + @DBUserName+']'
            PRINT @msgStatement
            SET @cnt = @cnt +1
        END
        FETCH NEXT FROM _sysobjects INTO @ObjectID, @ObjectName
    END
    CLOSE _sysobjects
    DEALLOCATE _sysobjects
    IF (@cnt > 0)    PRINT 'GO'
    PRINT CHAR(13)+CHAR(10)
 
    FETCH NEXT FROM login_curs INTO @DatabaseUserID, @ServerUserName, @DBUserName
END
 
PRINT '------------------- Finished...'
CLOSE login_curs
DEALLOCATE login_curs
GO