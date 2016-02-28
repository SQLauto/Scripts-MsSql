-- CPU bilgisini Registry'den alacaðýz
EXEC xp_instance_regread
'HKEY_LOCAL_MACHINE',
'HARDWARE\DESCRIPTION\System\CentralProcessor\0',
'ProcessorNameString';
 
-- CPU ve Memory bilgisi
SELECT cpu_count AS [CPU sayýsý (mantýksal)]
,hyperthread_ratio
,cpu_count/hyperthread_ratio AS [CPU sayýsý (fiziksel)]
,physical_memory_in_bytes/1048576/1024 AS [Toplam bellek miktarý (GB)]
FROM sys.dm_os_sys_info;