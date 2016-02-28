Select 
'Create Login ' + QUOTENAME(A.name) 
+ ' With Password=' + CONVERT(varchar(max), A.password_hash, 1) + ' hashed'		--script out the passwrod
+ ', DEFAULT_DATABASE=' + quotename(A.default_database_Name) --if you apply the scrip to a mirroed server or log-shipped server user master database, as user database is not in useable state
+ ', DEFAULT_LANGUAGE=' + quotename(A.default_language_Name)
+ ', CHECK_POLICY=' + Case A.is_policy_checked when 0 then 'OFF' When 1 Then 'On' End 
+ ', CHECK_EXPIRATION=' + Case A.is_expiration_checked when 0 then 'OFF' When 1 Then 'On' End
+ ', SID=' + CONVERT(varchar(max), A.SID, 1)		--script out the SIDs
+ ';'
 As SQLLogin
From 
sys.sql_logins A
Where A.name Not like '##%##'  --remove those system generated sql logins
And A.sid != 0x01 --SA sid is always same