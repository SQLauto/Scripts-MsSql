DECLARE @RecId INT
	,@SomeText VARCHAR(255)
	,@maxlength INT
	,@minlength INT
	,@RecordCount INT
	,@Counter INT

SET @maxlength = 254
SET @minlength = 50
SET @RecordCount = 500000
SET @Counter = 1

SELECT TOP 1 (
		SELECT TOP (abs(checksum(newid())) % (@maxlength - @minlength) + @minlength) CHAR(abs(checksum(newid())) % 26 + ascii('A'))
		FROM sys.all_objects a1
		WHERE sign(a1.object_id) = sign(t.object_id) /* Meaningless thing to force correlation */
		FOR XML path('')
		) AS NewRandomString
FROM sys.all_objects t;