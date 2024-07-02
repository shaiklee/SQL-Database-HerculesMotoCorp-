
--retrieving info about all the tables 
select * from INFORMATION_SCHEMA.tables

--retrieve info about all indexes defined on the customers table
EXEC sp_helpindex 'customers';
EXEC sp_helpindex 'employees';
EXEC sp_helpindex 'offices';
EXEC sp_helpindex 'orderdetails';
EXEC sp_helpindex 'orders';
EXEC sp_helpindex 'payments';
EXEC sp_helpindex 'productlines';
EXEC sp_helpindex 'products';

--retrieving info about all the tables 
select * from INFORMATION_SCHEMA.tables

--transferring the tables from the source schema(dbo) to the target schema(sales)
ALTER SCHEMA Sales TRANSFER dbo.orderdetails;
alter schema sales transfer dbo.customers
alter schema sales transfer dbo.employees
alter schema sales transfer dbo.offices
alter schema sales transfer dbo.orderdetails
alter schema sales transfer dbo.orders
alter schema sales transfer dbo.payments
alter schema sales transfer dbo.productlines
alter schema sales transfer dbo.products

--add a foreign key constraint to the 'customerID' column in 'orders' to establish a relationship with the customerID column in 'salesCustomers' table

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (CustomerID) REFERENCES salesCustomers(CustomerID);

alter table customers with nocheck
ADD CONSTRAINT FK_customers_salesrepempl  
foreign key(salesRepEmployeeNumber) references employees(employeeNumber)

alter table orders with nocheck 
add constraint FK_orders_customernumber
foreign key(customerNumber) references customers(customerNumber)

alter table payments with nocheck 
add constraint FK_payments_customerNumber_
foreign key(customerNumber) references customers(customerNumber)

ALTER TABLE orderdetails 
ADD FOREIGN KEY(orderNumber) REFERENCES orders(orderNumber)

ALTER TABLE orderdetails 
add foreign key(productCode) references products(productCode)

alter table employees
add foreign key(reportsTo) references employees(employeeNumber)

alter table employees
add foreign key(officeCode) references offices(officeCode)

alter table orders 
add foreign key(customerNumber) references customers(customerNumber)

alter table payments
add foreign key(customerNumber) references customers(customerNumber)

alter table products alter column productLine varchar(50)

alter table products
add foreign key(productLine) references productlines(productLine)


DROP TABLE IF EXISTS dbo.sysdiagrams;

DBCC CHECKDB('motorscertifications') WITH NO_INFOMSGS, ALL_ERRORMSGS;

USE master;
ALTER DATABASE [motorscertifications] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;


DBCC CHECKDB ('motorscertifications', REPAIR_REBUILD);

ALTER DATABASE [motorscertifications] SET MULTI_USER;

--retrieve info about all indexes defined on the customers table
EXEC sp_helpindex 'customers';
EXEC sp_helpindex 'employees';
EXEC sp_helpindex 'offices';
EXEC sp_helpindex 'orderdetails';
EXEC sp_helpindex 'orders';
EXEC sp_helpindex 'payments';
EXEC sp_helpindex 'productlines';
EXEC sp_helpindex 'products';
-- Drop the image column as it is deemed useless
ALTER TABLE productlines 
DROP COLUMN image;

-- Validating our records
select * from sales.orderdetails 
select * from sales.customers
select * from sales.orders 
select * from sales.offices
select * from sales.payments
select * from sales.productlines
select * from sales.products
select * from sales.employees


-- Finding the both highest and the lowest amount in the orders table
SELECT 
    MAX(priceEach) AS HighestAmount,
    MIN(priceEach) AS LowestAmount
FROM sales.orderdetails;    ---214,32

SELECT 
    MAX(creditLimit) AS HighestAmount,
    MIN(creditLimit) AS LowestAmount
FROM sales.customers;       ---227600,0

SELECT 
    MAX(amount) AS HighestAmount,
    MIN(amount) AS LowestAmount
FROM sales.payments;

-- Getting the unique count of customerName from the customers table
SELECT COUNT(DISTINCT customerName) AS UniqueCustomerCount FROM sales.customers;

-- Create the view cust_payment combining customers and payments
CREATE VIEW cust_payment AS
SELECT 
    sales.customers.customerName,
    sales.payments.amount,
    sales.customers.contactLastName,
    sales.customers.contactFirstName
FROM 
    sales.customers
JOIN 
    sales.payments
ON 
    sales.customers.customerNumber = sales.payments.customerNumber;


-- Select data from the view cust_payment
SELECT 
    customerName, 
    amount, 
    contactLastName, 
    contactFirstName
FROM 
    cust_payment;

-- to Drop the view cust_payment after the operation
--DROP VIEW cust_payment;

--  Create the stored procedure to display productLine for Classic Cars
CREATE PROCEDURE GettheClassicCarsProductLine
AS
BEGIN
    SELECT productLine
    FROM sales.products
    WHERE productLine = 'Classic Cars';
END;

--  Execute the stored procedure to get the productLine for Classic Cars
EXEC GettheClassicCarsProductLine;


-- Create a scalar function to get the creditLimit of customers less than 96800
CREATE FUNCTION GetCreditLimitBelow96800()
RETURNS TABLE
AS
RETURN
(
    SELECT customerNumber, customerName, creditLimit
    FROM sales.customers
    WHERE creditLimit < 96800
);

-- Use the function to get the creditLimit of customers less than 96800
SELECT * FROM GetCreditLimitBelow96800();

-- Create the trigger to store transaction record upon insertion into the employees table

-- Create the trigger to store transaction record upon insertion into the employees table
CREATE TRIGGER trg_InsertEmployee
ON sales.employees
AFTER INSERT
AS
BEGIN
    INSERT INTO employee_transactions (employeeNumber, lastName, firstName, officeCode)
    SELECT 
        inserted.employeeNumber,
        inserted.lastName,
        inserted.firstName,
        inserted.officeCode
    FROM inserted;
END;

--Insert new employee data to test the trigger
--INSERT INTO sales.employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle) VALUES (1102, 'Smith', 'John', 'x1234', 'jsmith@classicmodelcars.com', '2', 1056, 'Sales Manager');

--Check the transaction log table to see the recorded transaction
-- SELECT * FROM employee_transactions;

--Create the trigger to display customer number if the amount is greater than 10,000
CREATE TRIGGER trg_DisplayCustomerNumber
ON sales.payments
AFTER INSERT
AS
BEGIN
    DECLARE @customerNumber INT;

    SELECT @customerNumber = customerNumber
    FROM inserted
    WHERE amount > 10000;

    IF @customerNumber IS NOT NULL
    BEGIN
        PRINT 'Customer Number: ' + CAST(@customerNumber AS VARCHAR(10));
    END;
END;


-- Step 3: Insert sample data into the payments table to test the trigger
INSERT INTO sales.payments (customerNumber, checkNumber, paymentDate, amount)
VALUES 
(121, 'AB12345', '2024-06-22', 15000.00),  -- This should trigger the PRINT statement
(122, 'CD67890', '2024-06-22', 5000.00);  -- This should not trigger the PRINT statement

select * from sales.customers

INSERT INTO sales.payments (customerNumber, checkNumber, paymentDate, amount)
VALUES 
(144, 'EF12345', '2024-06-22', 15000.00),  -- This should trigger the PRINT statement
(144, 'GH67890', '2024-06-22', 5000.00);   -- This should not trigger the PRINT statement

-- Step 5: Check the transaction log to see the recorded transaction
SELECT * FROM sales.payments;
/
/

/
-- Create logins
CREATE LOGIN AdminLogin WITH PASSWORD = 'YourStrongPassword';
CREATE LOGIN HRLogin WITH PASSWORD = 'YourStrongPassword';
CREATE LOGIN EmployeeLogin WITH PASSWORD = 'YourStrongPassword';

-- Use the database where you want to create users
USE MOTORSCERTIFICATIONS;

-- Create users mapped to logins
CREATE USER AdminUser FOR LOGIN AdminLogin;
CREATE USER HRUser FOR LOGIN HRLogin;
CREATE USER EmployeeUser FOR LOGIN EmployeeLogin;

-- Create roles: Admin, HR, Employee
CREATE ROLE Admin;
CREATE ROLE HR;
CREATE ROLE Employee;

-- Assign users to roles
ALTER ROLE Admin ADD MEMBER AdminUser;
ALTER ROLE HR ADD MEMBER HRUser;
ALTER ROLE Employee ADD MEMBER EmployeeUser;

-- Grant permissions based on roles
-- Admin role (example grants full control)
GRANT CONTROL TO Admin;

-- HR role (example grants select on specific tables in the sales schema)
GRANT SELECT ON sales.employees TO HR;
GRANT SELECT ON sales.offices TO HR;

-- Employee role (example grants select on all tables in the sales schema)
GRANT SELECT ON ALL tables IN sales TO Employee;


