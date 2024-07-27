USE DB84
GO
CREATE PROCEDURE productDetails(@prcode INT, @date1 DATE, @date2 DATE)
AS
BEGIN
	SELECT description, purcode, quantity, date 
	FROM product
	INNER JOIN purchase
	ON product.prcode = purchase.prcode
	WHERE product.prcode = @prcode AND date BETWEEN @date1 AND @date2;
END;

EXEC productDetails @prcode = 2, @date1 = '2023-01-01', @date2 = '2023-12-31';