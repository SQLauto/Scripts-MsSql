
-- SysMail log
SELECT * FROM msdb.dbo.sysmail_log

-- SysMail sended mails
SELECT mailitem_id,recipients,body,sent_status,sent_date from msdb.dbo.sysmail_allitems

/*

-- Alternatfully , we can use the sp_send_mail to test as well.

EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TestMail',
@recipients = 'po@sqlpanda.com',
@body='This is test from sp_send_dbmail',
@subject='This is test from sp_send_dbmail'

Read more at http://www.sqlpanda.com/2014/09/sql-server-database-mail-with-gmail.html#UJt3zJdUYFIvCMxJ.99
*/

/*
--- Chek the mail Q
EXEC msdb.dbo.sysmail_help_queue_sp
EXEC msdb.dbo.sysmail_stop_sp;
--- start the database process
EXEC msdb.dbo.sysmail_start_sp;
---Delete msdb.dbo.symail_allitems
EXEC msdb.dbo.sysmail_delete_mailitems_sp
-- Delete msdb.dbo.sysmail_event_log
EXEC msdb.dbo.sysmail_delete_log_sp

Read more at http://www.sqlpanda.com/2014/09/sql-server-database-mail-with-gmail.html#UJt3zJdUYFIvCMxJ.99
*/