USE DB84
GO
CREATE PROCEDURE customersPerRegion(@geocode INT)
AS
BEGIN
	SELECT COUNT(custcode) AS NumberOfCustomers
	FROM customer
	WHERE geocode = @geocode;
END;

EXEC customersPerRegion @geocode = 3;