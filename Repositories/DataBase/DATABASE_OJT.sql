CREATE DATABASE OJT_TRAIN_G6;
use OJT_TRAIN_G6;
GO
CREATE TABLE [ROLE]
(
ROLEID INT IDENTITY(1,1) PRIMARY KEY,
ROLENAME NVARCHAR(255),
);
GO
CREATE TABLE ACCOUNT(
USERID INT IDENTITY(1,1) PRIMARY KEY,
USERNAME VARCHAR(100),
[PASSWORD] VARCHAR(MAX),
EMAIL VARCHAR(255),
FULLNAME NVARCHAR(255),
[ADDRESS] NVARCHAR(255),
PHONE VARCHAR(12),
DATEOFBIRTH DATE,
[IMAGE] VARCHAR(255),
CREATEDDATE DATETIME,
MODIFIEDDATE DATETIME,
[TIMESTAMP] DATETIME,
ISBLOCKED BIT,
ISACTIVED BIT,
ISDELETED BIT,
ROLEID INT,
FOREIGN KEY (ROLEID) REFERENCES [ROLE](ROLEID)
);
GO
CREATE TABLE CATEGORY(
CATEGORYID INT IDENTITY(1,1) PRIMARY KEY,
CATEGORYNAME NVARCHAR(100),
CREATEDDATE DATETIME,
MODIFIEDDATE DATETIME,
CREATEDBY VARCHAR(50),
MODIFIEDBY VARCHAR(50),
ISPUBLISHED BIT,
ISDELETED BIT,
);
GO
CREATE TABLE PRODUCT(
PRODUCTID INT IDENTITY(1,1) PRIMARY KEY,
PRODUCTNAME NVARCHAR(255),
MEMORY VARCHAR(100),
PRICEOLD INT,
PRICENEW INT,
PRODUCTDETAIL NVARCHAR(MAX),
CREATEDDATE DATETIME,
MODIFIEDDATE DATETIME,
CREATEDBY VARCHAR(50),
MODIFIEDBY VARCHAR(50),
ISPUBLISHED BIT,
ISDELETED BIT,
CATEGORYID INT,
IMAGEPRODUCT VARCHAR(1000)
FOREIGN KEY (CATEGORYID) REFERENCES CATEGORY(CATEGORYID)
);
GO
CREATE TABLE [ORDER](
ORDERID INT IDENTITY(1,1) PRIMARY KEY,
ORDERPRICE BIGINT,
CREATEDDATE DATETIME,
MODIFIEDDATE DATETIME,
CREATEDBY VARCHAR(50),
MODIFIEDBY VARCHAR(50),
[ADDRESS] NVARCHAR(200),
PAYMENTDATE DATETIME,
ORDERSTATUS NVARCHAR(50),
ISDELETED BIT,
USERID INT,
FOREIGN KEY (USERID) REFERENCES ACCOUNT(USERID)
);
GO
CREATE TABLE ORDERDETAIL(
ORDERDETAILID INT IDENTITY(1,1) PRIMARY KEY,
PRODUCTID INT,
QUANTITY INT,
PRICE INT,
ORDERID INT,
FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT(PRODUCTID),
FOREIGN KEY (ORDERID) REFERENCES [ORDER](ORDERID),
);
GO
CREATE TABLE COMMENT(
COMMENTID INT IDENTITY(1,1) PRIMARY KEY,
COMMENTTITLE NVARCHAR (100),
COMMENTCONTENT NVARCHAR(200),
CREATEDDATE DATETIME,
MODIFIEDDATE DATETIME,
CREATEDBY VARCHAR(50),
MODIFIEDBY VARCHAR(50),
ISPUBLISHED BIT,
ISDELETED BIT,
PRODUCTID INT,
USERID INT,
FOREIGN KEY (USERID) REFERENCES ACCOUNT(USERID),
FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT(PRODUCTID)
);
GO
CREATE TABLE PROMOTION(
PROMOTIONID INT IDENTITY(1,1) PRIMARY KEY,
PROMOTIONCODE VARCHAR(50),
PROMOTIONVALUE INT,
CREATEDDATE DATETIME,
MODIFIEDDATE DATETIME,
CREATEDBY VARCHAR(50),
MODIFIEDBY VARCHAR(50),
ISDELETED BIT,
);
GO
CREATE TABLE INVENTORY(
INVENTORYID INT IDENTITY(1,1) PRIMARY KEY,
INVENTORYNAME NVARCHAR(255)
);
GO
CREATE TABLE INVENTORYDETAIL(
INVENTORYDETAIID INT IDENTITY(1,1) PRIMARY KEY,
IMPORTEDDATE NVARCHAR(255),
TOTALIMPORT INT,
DELIVERED INT,
REMAINING INT,
PRODUCTID INT,
INVENTORYID INT,
FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT(PRODUCTID),
FOREIGN KEY (INVENTORYID) REFERENCES INVENTORY(INVENTORYID)
);
GO
CREATE TABLE SALE(
SALEID INT IDENTITY(1,1) PRIMARY KEY,
PRODUCTID INT,
QUANTITY INT ,
UNITPRICE INT,
CREATEDDATE DATETIME,
MODIFIEDDATE DATETIME,
CREATEDBY VARCHAR(50),
MODIFIEDBY VARCHAR(50),
ISDELETED BIT,
FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT(PRODUCTID)
);
GO
ALTER TABLE ACCOUNT ADD DEFAULT 0 FOR ISBLOCKED;
ALTER TABLE ACCOUNT ADD DEFAULT 0 FOR ISDELETED;
ALTER TABLE ACCOUNT ADD DEFAULT 1 FOR ISACTIVED;
ALTER TABLE ACCOUNT
ADD CONSTRAINT df_Role
DEFAULT 1 FOR ROLEID;
ALTER TABLE CATEGORY ADD DEFAULT 1 FOR ISPUBLISHED;
ALTER TABLE CATEGORY ADD DEFAULT 0 FOR ISDELETED;
GO
--create proc UpsUserLogin
create proc UpsUserLogin
@JInput NVARCHAR(MAX) =NULL
AS
BEGIN
DECLARE @UserName NVARCHAR(255),
		@Password NVARCHAR(255)
		SELECT @UserName = OJ.USERNAME,
			   @Password = OJ.[PASSWORD]
		FROM OPENJSON(@JInput)
	    WITH
		(
		USERNAME NVARCHAR(255),
		[PASSWORD] NVARCHAR(255)
		)OJ
		SELECT 
		userlogin.USERID,
		userlogin.USERNAME,
		userlogin.[PASSWORD]
		FROM ACCOUNT userlogin
		WHERE (USERNAME=@UserName and [PASSWORD]=@Password)
end; 
GO
--create proc UpsRegistration
create proc UpsRegistration
@JInput NVARCHAR(MAX) = NULL
AS 
	BEGIN
	DECLARE
	@UserName VARCHAR(255),
	@Password VARCHAR(255),
	@Email VARCHAR(255),
	@FullName NVARCHAR(255),
	@Address NVARCHAR(255),
	@Phone VARCHAR(12),
	@DateOfBirth Date,
	@UserExists INT = 0 
	--LẤY GIÁ TRỊ TỪ FILE JSON
	SELECT @UserName = OJ.USERNAME,
	       @Password = OJ.[PASSWORD],
		   @Email =OJ.EMAIL,
		   @FullName= OJ.FULLNAME,
		   @Address=OJ.[ADDRESS],
		   @Phone =OJ.PHONE,
		   @DateOfBirth= OJ.DATEOFBIRTH
		FROM OPENJSON(@JInput)
	    WITH
		(
		USERNAME VARCHAR(255),
		[PASSWORD] VARCHAR(255),
		EMAIL VARCHAR(255),
		FULLNAME NVARCHAR(255),
		[ADDRESS] NVARCHAR(255),
		[PHONE] VARCHAR(12),
		[DATEOFBIRTH] DATE
		)OJ
		--CHECK XEM CO TON TAI THI XET USEREXIT=1 
		IF EXISTS(SELECT 1 FROM ACCOUNT WHERE USERNAME=@UserName)
		BEGIN
		SET @UserExists=1;
		END
		ELSE IF EXISTS(SELECT 1 FROM ACCOUNT WHERE EMAIL=@Email)
		BEGIN
		SET @UserExists=2;
		END
		--CON NEU KHONG CO THI TIEP TUC ADD USER VAO
		ELSE
		BEGIN

		INSERT INTO ACCOUNT( USERNAME,[PASSWORD],EMAIL,FULLNAME,[ADDRESS],PHONE,DATEOFBIRTH) VALUES(@UserName,@Password,@Email,@FullName,@Address,@Phone,@DateOfBirth);
		END
		SELECT @UserExists AS UserExists;
end; 
GO

--create proc UspForgetPassword 
create proc UspForgetPassword 
@jInput nvarchar(max) = null
AS
BEGIN
	DECLARE 
	@Email VARCHAR(255),
	@UserExists INT = 0,
	@Password VARCHAR(255);
	SELECT @Email=OJ.EMAIL
	FROM OPENJSON(@jInput)
	WITH
	(
	EMAIL VARCHAR(255)
	)OJ
	IF EXISTS (SELECT 1 FROM ACCOUNT WHERE EMAIL=@Email)
	BEGIN
	  set @Password  = CAST(SUBSTRING(CONVERT(VARCHAR(36), NEWID()), 1, 9) AS VARCHAR(255));
	  Update ACCOUNT
	  SET [PASSWORD]= @Password 
	  WHERE Email = @Email;
	  SET @UserExists = 1;
	END
	else
	begin
	SET @UserExists = 0;
	end
	SELECT @UserExists AS UserExists, @Password AS [Password], @Email as Email;
end; 
GO

-- create proc UspAllCategory
create proc UspAllCategory
as
begin
	select
	cate.CATEGORYID,
	cate.CATEGORYNAME
	from CATEGORY cate
	where cate.ISPUBLISHED='true' AND cate.ISDELETED='false'
end; 
GO
--create proc UspAllProduct
create proc UspAllProduct
as
begin
	select 
	pro.PRODUCTID,
	pro.PRODUCTNAME,
	pro.CATEGORYID,
	pro.MEMORY,
	pro.PRICENEW,
    pro.PRICEOLD,
	pro.PRODUCTDETAIL,
	pro.IMAGEPRODUCT
	from PRODUCT pro
	where pro.ISPUBLISHED='true' and pro.ISDELETED='false'
end; 
GO
--create proc UspGetListProductByCategory
create proc UspGetListProductByCategory
 @CategoryId INT
as
begin
   SELECT 
   	pro.PRODUCTID,
	pro.PRODUCTNAME,
	pro.CATEGORYID,
	pro.MEMORY,
	pro.PRICENEW,
    pro.PRICEOLD,
	pro.PRODUCTDETAIL,
	pro.IMAGEPRODUCT
	from PRODUCT pro
	where pro.ISPUBLISHED='true' and pro.ISDELETED='false' and @CategoryId=pro.CATEGORYID
end; 
GO
--create proc UspGetProfile
create proc UspGetProfile
@UserId int
as
begin
	Select
	act.USERID,
	act.USERNAME,
	act.[PASSWORD],
	act.EMAIL,
	ACT.FULLNAME,
	ACT.[ADDRESS],
	ACT.PHONE,
	ACT.DATEOFBIRTH
	from ACCOUNT ACT
	where ACT.ISBLOCKED = 'FALSE' AND ACT.ISACTIVED='TRUE' AND ACT.USERID=@USERID
end; 
GO
--create proc UspGetProductDetails
create proc UspGetProductDetails
@ProductId int
as
begin
	select 
	pro.PRODUCTID,
	pro.PRODUCTNAME,
	pro.CATEGORYID,
	pro.MEMORY,
	pro.PRICENEW,
    pro.PRICEOLD,
	pro.PRODUCTDETAIL,
	pro.IMAGEPRODUCT
	from PRODUCT pro
	where pro.ISPUBLISHED='true' and pro.ISDELETED='false' and @ProductId=PRODUCTID
end; 
GO
--create proc UspgetlistcomentProduct
create proc UspgetlistcomentProduct
@ProductId int
as 
   begin
   select
   CMT.COMMENTID,
   CMT.COMMENTCONTENT,
   CMT.CREATEDDATE,
   ACT.USERNAME
   from COMMENT CMT left join ACCOUNT ACT ON CMT.USERID = ACT.USERID 
   where CMT.PRODUCTID =@ProductId
end; 
GO
-- create proc UspAddComment 
create proc UspAddComment
@ProductId int,
@UserId int,
@CommentContent nvarchar(max)
as
begin
  insert into Comment(Commentcontent,Createddate,Productid,UserId) values(@CommentContent,GETDATE(),@ProductId,@UserId);
end; 
GO
-- GET ALL CATEGORY
CREATE PROCEDURE GetAllCategory
AS
BEGIN
	SELECT * FROM CATEGORY
END;
GO
-- ADD CATEGORY
CREATE PROCEDURE AddCategory
@categoryName NVARCHAR(50), @isPublished VARCHAR(5)
AS
BEGIN
	INSERT INTO CATEGORY VALUES(@categoryName, GETDATE(), NULL, NULL, NULL, @isPublished, 'False')
END;
GO
-- UPDATE CATEGORY
CREATE PROCEDURE UpdateCategory @categoryId int, @categoryName NVARCHAR(50), @isPublished VARCHAR(5)
AS
BEGIN
	UPDATE CATEGORY
	SET CATEGORYNAME = @categoryName,
		MODIFIEDDATE = GETDATE(),
		ISPUBLISHED = @isPublished
	WHERE CATEGORYID = @categoryId
END;
GO
-- DELETE CATEGORY
CREATE PROCEDURE DeleteCategory
@categoryId int
AS
BEGIN
	UPDATE CATEGORY
	SET ISPUBLISHED = 'False',
		ISDELETED = 'True',
		MODIFIEDDATE = GETDATE()
	WHERE CATEGORYID = @categoryId
END;
GO
--GET ALL PRODUCT
CREATE PROCEDURE GetAllProduct
AS 
BEGIN
	SELECT P.*, C.CATEGORYNAME FROM PRODUCT AS P JOIN CATEGORY AS C ON P.CATEGORYID = C.CATEGORYID;
END;
GO
--GET PRODUCT BY ID
CREATE PROCEDURE GetProductById @productId INT
AS 
BEGIN
	SELECT P.*, C.CATEGORYNAME FROM PRODUCT AS P JOIN CATEGORY AS C ON P.CATEGORYID = C.CATEGORYID WHERE P.PRODUCTID = @productId;
END
GO
--ADD NEW PRODUCT
CREATE PROCEDURE AddProduct 
@productName NVARCHAR(100), @memory VARCHAR(50), @priceOld INT, @productDetail NVARCHAR(MAX),
@categoryId INT, @isPublished VARCHAR(5), @imageProduct VARCHAR(1000)
AS 
BEGIN
	INSERT INTO PRODUCT VALUES(@productName, @memory, @priceOld,'',@productDetail, GETDATE(),NULL,NULL,NULL,@isPublished,'False',@categoryId,@imageProduct);
END;
GO
--DELETE PRODUCT
CREATE PROCEDURE DeleteProduct @productId int
AS 
BEGIN
	UPDATE PRODUCT
	SET ISPUBLISHED = 'False',
		ISDELETED = 'True'
	WHERE PRODUCTID = @productId
END;
GO
--UPDATE PRODUCT
CREATE PROCEDURE UpdateProduct 
@productId INT, @productName NVARCHAR(100), @memory VARCHAR(50), @priceOld INT, 
@productDetail NVARCHAR(MAX), @categoryId INT, @isPublished VARCHAR(5), @imageProduct VARCHAR(1000)
AS
BEGIN
	UPDATE PRODUCT
	SET PRODUCTNAME = @productName,
		MEMORY = @memory,
		PRICEOLD = @priceOld,
		PRODUCTDETAIL = @productDetail,
		MODIFIEDDATE = GETDATE(),
		IMAGEPRODUCT = @imageProduct,
		ISPUBLISHED = @isPublished,
		CATEGORYID = @categoryId
	WHERE PRODUCTID = @productId;
END;
GO
-- SELECT CATEGORIES AVAILABLE
CREATE PROCEDURE GetPublishedCategories 
AS 
BEGIN
	SELECT C.CATEGORYID, C.CATEGORYNAME FROM CATEGORY AS C WHERE C. ISPUBLISHED = 'True';
END;
GO
-- SELECT PRODUCT AVAILABLE
CREATE PROCEDURE GetValidProducts
AS 
BEGIN
	SELECT PRODUCTID, PRODUCTNAME FROM PRODUCT WHERE ISPUBLISHED = 'True' AND ISDELETED = 'False';
END;
GO
-- THONG KE SAN PHAM TRONG KHO
CREATE PROCEDURE GetInforInventory
AS
BEGIN
SELECT I.TOTALIMPORT,I.DELIVERED,I.REMAINING,P.PRODUCTNAME
FROM INVENTORYDETAIL AS I
JOIN PRODUCT AS P ON I.PRODUCTID = P.PRODUCTID
END;
GO
-- THONG KE DOANH SO
CREATE PROCEDURE THONGKE
AS
	DECLARE @REVENUE BIGINT = (SELECT SUM(CAST(P.PRICEOLD AS BIGINT) * I.DELIVERED)
						FROM INVENTORYDETAIL AS I
						JOIN PRODUCT AS P ON I.PRODUCTID = P.PRODUCTID
						GROUP BY I.INVENTORYID
						);
	DECLARE @COST BIGINT = (SELECT SUM(QUANTITY*CAST(UNITPRICE AS BIGINT)) FROM SALE WHERE ISDELETED = 0)
	DECLARE @PROFIT BIGINT = @REVENUE - @COST;
BEGIN
	SELECT @REVENUE AS REVENUE, @COST AS COST, @PROFIT AS PROFIT
END;
GO
-- GET ORDER INFOR
CREATE PROCEDURE GetOrderInfo
AS
BEGIN
	SELECT * FROM [ORDER]
END;
GO
-- GET ORDER DETAIL BY ORDERID 
CREATE PROCEDURE GetOrderDetail @orderId INT
AS
BEGIN
	SELECT O.*, P.PRODUCTNAME, P.IMAGEPRODUCT FROM ORDERDETAIL AS O JOIN PRODUCT AS P
	ON O.PRODUCTID = P.PRODUCTID
	WHERE O.ORDERID = @orderId
END;
GO
-- GET ORDER BY ID
CREATE PROCEDURE GetOrderById @orderId INT
AS
BEGIN
	SELECT O.*, A.ADDRESS AS UserAddress, A.Phone FROM [ORDER] AS O 
	JOIN ACCOUNT AS A ON O.USERID = A.USERID
	WHERE ORDERID = @orderId
END;
GO
-- SHIP ORDER
CREATE PROCEDURE ShippingOrder @orderId INT
AS 
BEGIN
	UPDATE [ORDER]
	SET ORDERSTATUS = N'Đang giao hàng'
	WHERE ORDERID = @orderId

END;
GO
------ CREATE SALE
CREATE PROCEDURE AddSale @quantity int, @unitPrice int, @productId int
AS
BEGIN
	INSERT INTO SALE VALUES(@productId, @quantity, @unitPrice, GETDATE(), NULL, NULL, NULL, 'False');
	IF EXISTS (SELECT 1 FROM INVENTORYDETAIL WHERE PRODUCTID = @productId)
	BEGIN
		UPDATE INVENTORYDETAIL
		SET TOTALIMPORT = TOTALIMPORT + @quantity,
		REMAINING = REMAINING + @quantity
		WHERE INVENTORYID = 1
		AND PRODUCTID = @productId;
	END
	ELSE
	BEGIN
		INSERT INTO INVENTORYDETAIL (IMPORTEDDATE, PRODUCTID, TOTALIMPORT, DELIVERED, REMAINING, INVENTORYID)
        VALUES (GETDATE(), @productId, @quantity, '0', @quantity, '1');
	END
END;
GO
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
GO
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
GO
--GET ALL SALE
CREATE PROCEDURE GetAllSale
AS
BEGIN
	SELECT S.*, P.PRODUCTNAME FROM SALE AS S JOIN PRODUCT AS P ON S.PRODUCTID = P.PRODUCTID;
END;
GO
--GET SALE BY ID
CREATE PROCEDURE GetSaleById @saleId int
AS
BEGIN
	SELECT S.*, P.PRODUCTNAME FROM SALE AS S 
	JOIN PRODUCT AS P ON S.PRODUCTID = P.PRODUCTID 
	WHERE S.SALEID =  @saleId;
END;
GO
-- INSERT MULTI CATE WITH EXCEL
CREATE PROCEDURE InsertCategories
    @CategoryData NVARCHAR(MAX)
AS
BEGIN
    CREATE TABLE #TempCategoryTable
    (
        CategoryName NVARCHAR(255),
        IsPublished BIT
    );
    INSERT INTO #TempCategoryTable (CategoryName, IsPublished)
    SELECT CategoryName, IsPublished
    FROM OPENJSON(@CategoryData)
    WITH (
        CategoryName NVARCHAR(255),
        IsPublished BIT
    );
    INSERT INTO CATEGORY(CATEGORYNAME, ISPUBLISHED)
    SELECT t.CategoryName, t.IsPublished
    FROM #TempCategoryTable t
    WHERE NOT EXISTS (
        SELECT 1
        FROM CATEGORY c
        WHERE c.CATEGORYNAME = t.CategoryName
    );
    DROP TABLE #TempCategoryTable;
END;
GO
-- CREATE MULTI SALE
CREATE PROCEDURE AddSaleExcel 
@jsonData NVARCHAR(MAX)
AS
BEGIN
	CREATE TABLE #TempSaleTable
    (
        ProductId INT,
        Quantity INT,
		UnitPrice BIGINT
    );
	-- Insert data from JSON array into the temporary table
    INSERT INTO #TempSaleTable (ProductId, Quantity, UnitPrice)
    SELECT ProductId, Quantity, UnitPrice
    FROM OPENJSON(@jsonData)
    WITH (
        ProductId INT,
        Quantity INT,
		UnitPrice BIGINT
    );
	 -- Insert data
    INSERT INTO SALE(PRODUCTID, QUANTITY, UNITPRICE, CREATEDDATE)
    SELECT ProductId, Quantity, UnitPrice, GETDATE() AS CREATEDDATE
    FROM #TempSaleTable;

	MERGE INTO INVENTORYDETAIL AS Target
    USING #TempSaleTable AS Source
    ON Target.PRODUCTID = Source.ProductId
    WHEN MATCHED THEN
        UPDATE SET 
            Target.TOTALIMPORT = Target.TOTALIMPORT + Source.Quantity,
			Target.REMAINING = Target.REMAINING + Source.Quantity
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (IMPORTEDDATE, PRODUCTID, TOTALIMPORT, DELIVERED, REMAINING, INVENTORYID)
        VALUES (GETDATE(), Source.ProductId, Source.Quantity, '0', Source.Quantity, '1');
    -- Drop the temporary table
    DROP TABLE #TempSaleTable;
END;
GO
-- GET ALL ACCOUNT
CREATE PROCEDURE GetAccountInfo
AS
BEGIN
	SELECT ACCOUNT.*, [ROLE].ROLENAME FROM ACCOUNT JOIN [ROLE]
	ON ACCOUNT.ROLEID = [ROLE].ROLEID
END;
GO
-- UPDATE ACCOUNT
CREATE  PROCEDURE UpdateAccount
@userId INT, @userName VARCHAR(50), @email VARCHAR(100), @fullName NVARCHAR(200), @phone VARCHAR(12), @address NVARCHAR(200), @timeStamp DATETIME,
@dateOfBirth DATETIME, @isBlocked VARCHAR(5), @isActived VARCHAR(5), @roleId INT
AS
BEGIN
	UPDATE ACCOUNT
	SET USERNAME = @userName, EMAIL = @email, FULLNAME = @fullName, PHONE = @phone, [ADDRESS] = @address, [TIMESTAMP] = @timeStamp,
		DATEOFBIRTH = @dateOfBirth, ISBLOCKED = @isBlocked, ISACTIVED = @isActived, ROLEID = @roleId, MODIFIEDDATE = GETDATE()
	WHERE USERID = @userId
END;
GO
-- DELETE ACCOUNT
CREATE PROCEDURE DeleteAccount @userId INT
AS
BEGIN
	UPDATE ACCOUNT
	SET ISDELETED = 'True'
	WHERE USERID = @userId
END;
GO
-- GET ROLE
CREATE PROCEDURE GetRole
AS
BEGIN
	SELECT * FROM [ROLE];
END;
GO