
/* Kullanıcının Bütün veritabanlarını görmemesini sağla */
USE master;
DENY VIEW ANY DATABASE TO [Dev_Framework_User]; 


/* Görebileceği veritabanından kullanıcıyı kaldır */
USE [Dev_Framework];

IF EXISTS(
	SELECT SU.[uid], SL.[loginname], SU.[name]
      FROM [dbo].[sysusers] SU INNER JOIN [master].[dbo].[syslogins] SL ON SU.[sid] = SL.[sid]
     WHERE SU.[name] not in ('public','dbo','guest','sys')
	   AND SU.name = '[Dev_Framework_User]'
    )
	EXEC sp_dropuser [Dev_Framework_User] --DROP USER [Dev_Framework_User]



/* Kullanıcının gerekli database'i görebilmesini sağla */
USE master;
ALTER AUTHORIZATION ON DATABASE::[Dev_Framework] TO [Dev_Framework_User];
