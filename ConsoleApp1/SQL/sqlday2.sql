-- Student Name: Naomi Chen
-- Title: HW of SQL day 2 
USE AdventureWorks2019
-- Write queries for following scenarios
-- 1.      How many products can you find in the Production.Product table?
SELECT COUNT(*)
FROM  Production.Product

-- 2.      Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(*)
FROM  Production.Product
WHERE ProductSubcategoryID IS NOT NULL

-- 3.      How many Products reside in each SubCategory? Write a query to display the results with the following titles.
-- ProductSubcategoryID CountedProducts

-- -------------------- ---------------
SELECT ProductSubcategoryID, COUNT(*) AS CountedProducts
FROM  Production.Product
WHERE ProductSubcategoryID IS NOT NULL 
GROUP BY ProductSubcategoryID

-- 4.      How many products that do not have a product subcategory.
SELECT count(*)
FROM  Production.Product
WHERE ProductSubcategoryID IS NULL 

-- 5.      Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, SUM(Quantity) AS TotalProductQuantity
FROM Production.ProductInventory
GROUP BY ProductID

-- 6.    Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.

--               ProductID    TheSum

--               -----------        ----------

SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

-- 7.    Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

--     Shelf      ProductID    TheSum

--     ----------   -----------        -----------
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ProductInventory' AND TABLE_SCHEMA = 'Production';

SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40 AND Shelf IS NOT NULL
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100;

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS AVGQuantity
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

-- 9.    Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory

--     ProductID   Shelf      TheAvg

--     ----------- ---------- -----------

SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY Shelf, ProductID

-- 10.  Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

--     ProductID   Shelf      TheAvg

--     ----------- ---------- -----------
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY Shelf, ProductID

-- 11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

--     Color                        Class              TheCount          AvgPrice

--     -------------- - -----    -----------            ---------------------
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

-- Joins:
-- 12.   Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.

--     Country                        Province

--     ---------                          ----------------------
SELECT B.CountryRegionCode AS Country, B.StateProvinceID As Province
FROM Person.CountryRegion AS A JOIN Person.StateProvince AS B ON A.CountryRegionCode = B.CountryRegionCode

-- 13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
--     Country                        Province

--     ---------                          ----------------------
SELECT B.CountryRegionCode AS Country, B.StateProvinceID As Province
FROM Person.CountryRegion AS A JOIN Person.StateProvince AS B ON A.CountryRegionCode = B.CountryRegionCode
WHERE B.CountryRegionCode IN ('DE', 'CA')

--  Using Northwnd Database: (Use aliases for all the Joins)
USE Northwind

-- 14.  List all Products that has been sold at least once in last 27 years.
SELECT P.ProductID
FROM dbo.Products AS P 
JOIN dbo.[Order Details] AS D ON P.ProductID = D.ProductID 
JOIN dbo.Orders AS O ON O.OrderID = D.OrderID
WHERE O.OrderDate  >= DATEADD(YEAR, -27, GETDATE());

-- 15.  List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 O.ShipPostalCode AS ZipCode, SUM(D.Quantity) AS OrderQuantity
FROM dbo.Products AS P 
JOIN dbo.[Order Details] AS D ON P.ProductID = D.ProductID 
JOIN dbo.Orders AS O ON O.OrderID = D.OrderID
WHERE O.ShipPostalCode IS NOT NULL
GROUP BY O.ShipPostalCode
ORDER BY OrderQuantity DESC

-- 16.  List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT TOP 5 O.ShipPostalCode AS ZipCode, SUM(D.Quantity) AS OrderQuantity
FROM dbo.Products AS P 
JOIN dbo.[Order Details] AS D ON P.ProductID = D.ProductID 
JOIN dbo.Orders AS O ON O.OrderID = D.OrderID
WHERE O.ShipPostalCode IS NOT NULL AND O.OrderDate  >= DATEADD(YEAR, -27, GETDATE())
GROUP BY O.ShipPostalCode
ORDER BY OrderQuantity DESC

-- 17.   List all city names and number of customers in that city.     
SELECT City, COUNT(CustomerID) CustomerNum
FROM dbo.Customers
GROUP BY City
ORDER BY CustomerNum DESC

-- 18.  List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) CustomerNum
FROM dbo.Customers
GROUP BY City
HAVING  COUNT(CustomerID) > 2
ORDER BY CustomerNum DESC

-- 19.  List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT C.ContactName CustomerName
FROM dbo.Orders O JOIN dbo.Customers C ON O.CustomerID = C.CustomerID
WHERE O.OrderDate > '1998-01-01'

-- 20.  List the names of all customers with most recent order dates
DECLARE @MostRecentDate DATE = CAST(GETDATE() AS DATE);  
SELECT DISTINCT C.ContactName CustomerName
FROM dbo.Orders O JOIN dbo.Customers C ON O.CustomerID = C.CustomerID
WHERE O.OrderDate = @MostRecentDate

-- 21.  Display the names of all customers  along with the  count of products they bought
SELECT C.ContactName CustomerName, SUM(DISTINCT D.ProductID) As ProductsBought
FROM dbo.Orders O JOIN dbo.Customers C ON O.CustomerID = C.CustomerID
JOIN dbo.[Order Details] D ON D.OrderID = O.OrderID
GROUP BY C.ContactName
ORDER BY ProductsBought DESC;

-- 22.  Display the customer ids who bought more than 100 Products with count of products.
SELECT C.ContactName CustomerName, SUM(DISTINCT D.ProductID) As ProductsBought
FROM dbo.Orders O JOIN dbo.Customers C ON O.CustomerID = C.CustomerID
JOIN dbo.[Order Details] D ON D.OrderID = O.OrderID
GROUP BY C.ContactName
HAVING SUM(DISTINCT D.ProductID) > 100
ORDER BY ProductsBought DESC;

-- 23.  List all of the possible ways that suppliers can ship their products. Display the results as below

--     Supplier Company Name                Shipping Company Name

--     ---------------------------------            ----------------------------------
SELECT S.CompanyName AS SupplierCompanyName, SH.CompanyName AS ShippingCompanyName
FROM dbo.Suppliers AS S 
JOIN dbo.Products AS P ON S.SupplierID = P.SupplierID
JOIN dbo.[Order Details] AS D ON P.ProductID = D.ProductID
JOIN dbo.Orders AS O ON O.OrderID = D.OrderID
JOIN dbo.Shippers AS SH ON O.ShipVia = SH.ShipperID
GROUP BY S.CompanyName, SH.CompanyName;

-- 24.  Display the products order each day. Show Order date and Product Name.
SELECT O.OrderDate, P.ProductName
FROM dbo.Orders O 
JOIN dbo.[Order Details] D ON O.OrderID = D.OrderID
JOIN dbo.Products P ON D.ProductID = P.ProductID
ORDER BY O.OrderDate, P.ProductName

-- 25.  Displays pairs of employees who have the same job title.
SELECT E1.FirstName + ' ' + E1.LastName AS Employee1, E2.FirstName + ' ' + E2.LastName AS Employee2, E1.Title AS JobTitle
FROM dbo.Employees E1
JOIN dbo.Employees E2 ON E1.Title = E2.Title
WHERE E1.EmployeeID != E2.EmployeeID

-- 26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT E2.FirstName + '' + E2.LastName ManagerName, COUNT(E1.EmployeeID) AS NumberOfEmployees 
FROM dbo.Employees E1
JOIN dbo.Employees E2 ON E1.ReportsTo = E2.EmployeeID
GROUP BY E2.EmployeeID, E2.FirstName, E2.LastName  
HAVING COUNT(E1.EmployeeID) > 2
ORDER BY NumberOfEmployees DESC;

-- 27.  Display the customers and suppliers by city. The results should have the following columns

-- City
-- Name
-- Contact Name,
-- Type (Customer or Supplier)

SELECT C.City, C.CompanyName AS Name, C.ContactName,'Customer' AS Type
FROM dbo.Customers AS C
UNION ALL
SELECT S.City, S.CompanyName AS Name, S.ContactName, 'Supplier' AS Type
FROM dbo.Suppliers AS S
ORDER BY City, Type, Name;