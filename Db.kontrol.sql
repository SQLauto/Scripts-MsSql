USE Dev_YurticiKargo
go

dbcc traceon(3604)
go
dbcc traceflags
go


dbcc checkalloc (Dev_YurticiKargo)
go
dbcc checkcatalog (Dev_YurticiKargo)
go
dbcc checkdb (Dev_YurticiKargo)
go

sp_msforeachtable 'DBCC checktable (''?'')'
go
--dbcc tablealloc('Urunler')
go
--dbcc indexalloc('Urunler')
go

-------------------------------------------------------------------------------
-- INFO TABLE
-------------------------------------------------------------------------------
SELECT sysobjects.name tabla, 
sysobjects.id table_id,
sysindexes.name indice, 
sysindexes.first, 
sysindexes.root--, 
--sysindexes.doampg, 
--sysindexes.ioampg
FROM sysobjects,
sysindexes
WHERE sysobjects.id = sysindexes.id
AND sysobjects.name like '%branch%'
go