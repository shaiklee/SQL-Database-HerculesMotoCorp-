# SQL-Database-HerculesMotoCorp
The Hercules MotoCorp SQL database is designed to manage and organize the operations of Hercules Motocorp, a fictional automotive company. This database includes various tables and relationships to track products, sales, customers, and other essential business operations.
This database project, named MotorsCertification, aims to help Hercules MotoCorp employees manage data efficiently and enable shareholders and other stakeholders to view and understand the data effortlessly. The database includes several interconnected tables, handling various aspects such as orders, customers, employees, products, and payments.

#Database Design
The database schema includes the following tables:

orderdetails: Manages order details, linked to the orders and products tables.

customers: Stores customer information, linked to the employees table.

employees: Contains employee data, linked to itself for hierarchical reporting and to the offices table.

orders: Records order information, linked to the customers table.

offices: Holds office location details.

payments: Tracks payment transactions, linked to the customers table.

productlines: Defines categories of products.

products: Details product information, linked to the productlines table.


Tasks Performed

Database Creation: Designed the database named MotorsCertification and created the necessary tables with appropriate primary keys, foreign keys, and indexes.

Data Insertion: Inserted records into the orderdetails, employees, payments, products, customers, offices, and orders tables using provided CSV files.

Column Deletion: Removed unnecessary columns from the productlines table.

Data Verification: Verified insertions and updates using select statements.

Data Analysis: Found the highest and lowest payment amounts and provided a unique count of customer names.

View Creation: Created and managed a view named cust_payment to display customer payment information.

Stored Procedure: Implemented a stored procedure to display product lines for Classic Cars.

Function Creation: Developed a function to get the credit limit of customers less than 96800.

Triggers: Created triggers to log transactions for employee table insertions and to display customer numbers for high payments.

User Roles: Set up users, roles, and logins with specific access permissions for Admin, HR, and Employee roles.
