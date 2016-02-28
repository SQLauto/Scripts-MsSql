/*
Find database users
http://www.sqlservercentral.com/scripts/Auditing/121752/
*/

select @@servername as instance_name
, '?' as database_name
, rp.name as database_user
, mp.name as database_role
, sp.name as instance_login
,case 
when sp.is_disabled = 1 then 'Disabled'
when sp.is_disabled = 0 then 'Enabled'
end
[login_status]
from sys.database_principals rp 
left outer join sys.database_role_members drm on (drm.member_principal_id = rp.principal_id) 
left outer join sys.database_principals mp on (drm.role_principal_id = mp.principal_id)
left outer join sys.server_principals sp on (rp.sid=sp.sid)
where rp.type_desc in ('WINDOWS_USER','SQL_USER')