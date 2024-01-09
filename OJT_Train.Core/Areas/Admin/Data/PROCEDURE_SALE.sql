-- BUY PRODUCT
CREATE TRIGGER buy_product ON SALE
AFTER INSERT
AS
BEGIN
	DECLARE @QUANTITY INT
	DECLARE @PRODUCTID INT
	DECLARE @INVENTORYID INT
	SET @QUANTITY = (SELECT inserted.QUANTITY FROM inserted);
	SET @PRODUCTID = (SELECT inserted.PRODUCTID FROM inserted);
	SET @INVENTORYID = 1;
	
	IF NOT EXISTS (
		SELECT * FROM INVENTORYDETAIL 
		WHERE INVENTORYID = @INVENTORYID 
		AND PRODUCTID = @PRODUCTID
	)
	BEGIN
		INSERT INTO INVENTORYDETAIL(IMPORTEDDATE, TOTALIMPORT, DELIVERED, REMAINING, PRODUCTID, INVENTORYID) 
		VALUES(GETDATE(), @QUANTITY, 0, @QUANTITY, @PRODUCTID, @INVENTORYID)
	END
	ELSE
	BEGIN
		UPDATE INVENTORYDETAIL
		SET TOTALIMPORT = TOTALIMPORT + @QUANTITY,
			REMAINING = TOTALIMPORT + @QUANTITY - DELIVERED
		WHERE INVENTORYID = @INVENTORYID
		AND PRODUCTID = @PRODUCTID
	END
END;
GO;
------ CREATE SALE
CREATE PROCEDURE AddSale @quantity int, @unitPrice int, @productId int
AS
BEGIN
	INSERT INTO SALE VALUES(@productId, @quantity, @unitPrice, GETDATE(), NULL, NULL, NULL, 'False');
END;
GO;
------ UPDATE SALE
CREATE PROCEDURE UpdateSale 
@oldQuantity int, @newQuantity int, @saleId int, @unitPrice int, @productId int
AS
BEGIN
	UPDATE SALE
	SET QUANTITY = @newQuantity,
		UNITPRICE = @unitPrice,
		MODIFIEDDATE = GETDATE()
	WHERE SALEID = @saleId;
	UPDATE INVENTORYDETAIL
	SET TOTALIMPORT = TOTALIMPORT - @oldQuantity + @newQuantity,
		REMAINING = TOTALIMPORT - @oldQuantity + @newQuantity - DELIVERED
	WHERE INVENTORYID = 1
	AND PRODUCTID = @productId;
END;
GO;
------ DELETE SALE
CREATE PROCEDURE DeleteSale 
@saleId int, @quantity int, @productId int
AS
BEGIN
	UPDATE SALE
	SET ISDELETED = 'True'
	WHERE SALEID = @saleId;
	UPDATE INVENTORYDETAIL
	SET TOTALIMPORT = TOTALIMPORT - @quantity,
		REMAINING = TOTALIMPORT - @quantity - DELIVERED
	WHERE INVENTORYID = 1
	AND PRODUCTID = @productId;
END;
GO;
--GET ALL SALE
CREATE PROCEDURE GetAllSale
AS
BEGIN
	SELECT S.*, P.PRODUCTNAME FROM SALE AS S JOIN PRODUCT AS P ON S.PRODUCTID = P.PRODUCTID;
END;
GO;
--GET SALE BY ID
CREATE PROCEDURE GetSaleById @saleId int
AS
BEGIN
	SELECT S.*, P.PRODUCTNAME FROM SALE AS S 
	JOIN PRODUCT AS P ON S.PRODUCTID = P.PRODUCTID 
	WHERE S.SALEID =  @saleId;
END;

EXEC GetAllSale
SELECT * FROM INVENTORYDETAIL