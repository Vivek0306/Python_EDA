-- T-SQL or Transact SQL which is extension of SQL(Structured Query 
-- Language). T-SQL developed by Microsoft for use of SQL Server, Azure 
-- SQL DB. Key Features of T-SQL: a) Variable , Control Flow Statements 
-- (IF-ELSE), LOOPS, TRY CATCH, CREATE FUNCTIONS, STORED PROCEDURES 

-- 1. Show Databases
SELECT name FROM sys.databases;

-- 2. Show list of schema
SELECT name as SchemaName from sys.schemas;

-- 3. Create new database
create database sales;

-- 4. Create a database with condition to test if it exists
-- Decalare a variable with name Databasename
DECLARE @Databasename NVARCHAR(128) = 'sales';

-- 5. Test condition to check if database exists
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = @Databasename)
BEGIN
	DECLARE @sql NVARCHAR(MAX)='CREATE DATABASE '+QUOTENAME(@Databasename);
    EXEC sp_executesql @sql;
END

-- 6. Change database
USE sales;

-- 7. Create table using schema name (dbo) which is default database
create table [dbo].products(productid varchar(20) NOT NULL,
productname varchar(50), price float, quantity int, 
storename varchar(50), city varchar(50))

-- 8. Insert values into table products
INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P001', 'Samsung Galaxy S21', 69999.99, 50, 'Electronics Hub', 'Mumbai');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P002', 'Sony WH-1000XM4', 29999.99, 30, 'Audio World', 'Delhi');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P003', 'Apple MacBook Air', 92999.99, 20, 'Techies Store', 'Bengaluru');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P004', 'OnePlus 9 Pro', 64999.99, 40, 'Smartphone Central', 'Chennai');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P005', 'LG 55 inch 4K TV', 54999.99, 15, 'Home Appliances Store', 'Hyderabad');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P006', 'Nikon D3500', 42999.99, 25, 'Camera Mart', 'Pune');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P007', 'Dell Inspiron 15', 74999.99, 10, 'Laptop World', 'Kolkata');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P008', 'JBL Charge 4', 12999.99, 35, 'Music Zone', 'Jaipur');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P009', 'Fitbit Charge 4', 9999.99, 45, 'Fitness Gear', 'Ahmedabad');

INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city)
VALUES ('P010', 'Kindle Paperwhite', 8999.99, 60, 'Book Lovers', 'Surat');

-- 9. Run query on products table to show all records.
select * from products;

-- 10. Show the Schema Description of Table.
SELECT 
	TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME = 'products';
	
-- 11. Drop Table 
-- DROP TABLE [dbo].products;

-- 12. Alter Table
alter table [dbo].products ADD TOTALAMOUNT FLOAT;

alter table products ADD TRANSACTIONDATE FLOAT;

-- 13. Drop Column using ALter
alter table products DROP COLUMN TRANSACTIONDATE;

-- 14. Update Existing Column DataType
alter table products alter column TOTALAMOUNT DECIMAL(18,2);

-- 15. Update the Value of Column TOTALAMOUNT = PRICE * QUANTITY
update [dbo].products set TOTALAMOUNT = PRICE * QUANTITY;

select * from products;

-- 16. Query to show first 5 Records. 
SELECT TOP (5) [productid],[productname],[price],[quantity],[storename]
      ,[city],[TOTALAMOUNT]
  FROM [sales].[dbo].[products];