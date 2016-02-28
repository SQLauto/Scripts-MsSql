USE GulaylarOnlineDb
GO
BEGIN TRY
	CREATE NONCLUSTERED INDEX IX_Urunler_01 ON [Urunler] ([SinifAdi], [AltSinifAdi], [Aktif]); -- with (ONLINE=OFF);
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO