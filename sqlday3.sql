-- Student Name: Naomi Chen 
-- Title: HW3

use Northwind
-- 1.      List all cities that have both Employees and Customers.
SELECT DISTINCT E.City
FROM dbo.Employees E
JOIN dbo.Customers C ON E.City = C.City;

-- 2.      List all cities that have Customers but no Employee.

-- a.      Use sub-query
SELECT DISTINCT C.City
FROM dbo.Customers C
WHERE C.City NOT IN (
    SELECT E.city FROM dbo.Employees E
)

-- b.      Do not use sub-query
SELECT DISTINCT C.City
FROM dbo.Customers C
LEFT JOIN dbo.Employees E ON C.City = E.City
WHERE E.City IS NULL;

-- 3.      List all products and their total order quantities throughout all orders.
SELECT ProductID, SUM(Quantity)
FROM dbo.[Order Details]
GROUP BY ProductID

SELECT P.ProductID, P.ProductName, SUM(D.Quantity) AS TotalQuantity
FROM dbo.Products P
JOIN dbo.[Order Details] D ON P.ProductID = D.ProductID
GROUP BY P.ProductID, P.ProductName
ORDER BY TotalQuantity DESC;

-- 4.      List all Customer Cities and total products ordered by that city.
SELECT O.ShipCity, SUM(D.Quantity) As TotalProducts
FROM dbo.Orders O JOIN dbo.[Order Details] D ON O.OrderID = D.OrderID
GROUP BY O.ShipCity
ORDER BY TotalProducts DESC;

SELECT C.City AS CustomerCity, SUM(D.Quantity) AS TotalProducts
FROM dbo.Customers C
LEFT JOIN dbo.Orders O ON C.CustomerID = O.CustomerID
LEFT JOIN dbo.[Order Details] D ON O.OrderID = D.OrderID
GROUP BY C.City
ORDER BY TotalProducts DESC;

-- 5.      List all Customer Cities that have at least two customers.
SELECT DISTINCT C.City, COUNT(DISTINCT O.CustomerID) AS TotalCustomers
FROM dbo.Customers C JOIN dbo.Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.City
HAVING COUNT(DISTINCT O.CustomerID) >= 2
ORDER BY TotalCustomers ASC

-- 6.      List all Customer Cities that have ordered at least two different kinds of products.
SELECT O.ShipCity, COUNT(DISTINCT D.ProductID) AS TotalProducts
FROM dbo.[Order Details] D JOIN dbo.Orders O ON D.OrderID = O.OrderID
GROUP BY O.ShipCity
HAVING COUNT(DISTINCT D.ProductID) >= 2
ORDER BY TotalProducts ASC 

SELECT O.ShipCity, COUNT(DISTINCT D.ProductID) AS TotalProducts
FROM dbo.[Order Details] D JOIN dbo.Orders O ON D.OrderID = O.OrderID
GROUP BY O.ShipCity
HAVING COUNT(DISTINCT D.ProductID) >= 2
ORDER BY TotalProducts ASC;

-- 7.      List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT O.CustomerID, C.ContactName, C.City AS CustomerCity, O.ShipCity
FROM dbo.Customers C JOIN dbo.Orders O ON C.CustomerID = O.CustomerID
WHERE C.City <> O.ShipCity

-- 8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 P.ProductName, AVG(P.UnitPrice) AS AVGPrice, C.City, SUM(D.Quantity) AS TotalQuantity
FROM dbo.Products P
JOIN dbo.[Order Details] D ON P.ProductID = D.ProductID
JOIN dbo.Orders O ON O.OrderID = D.OrderID
JOIN dbo.Customers C ON C.CustomerID = O.CustomerID 
GROUP BY D.quantity, D.ProductID, P.ProductName, C.City
ORDER BY D.quantity DESC

-- 9.      List all cities that have never ordered something but we have employees there.
-- a.      Use sub-query
SELECT DISTINCT E.City
FROM dbo.Employees E
WHERE E.City NOT IN (SELECT DISTINCT O.ShipCity 
                    FROM dbo.Orders O 
                    WHERE O.ShipCity IS NOT NULL)

-- b.      Do not use sub-query
SELECT DISTINCT E.City
FROM dbo.Employees E
LEFT JOIN dbo.Orders O ON E.City = O.ShipCity
WHERE O.ShipCity IS NULL;

-- 10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

-- Walla Walla
SELECT TOP 5 O.ShipCity, SUM(DISTINCT O.OrderID)
FROM dbo.Orders O
GROUP BY O.Shipcity
ORDER BY SUM(O.OrderID)

-- Boise
SELECT O.ShipCity, SUM(D.Quantity) AS TotalQuantity
FROM dbo.Orders O
JOIN dbo.[Order Details] D
ON O.OrderID = D.OrderID
GROUP BY O.ShipCity
ORDER BY SUM(D.Quantity) DESC

--CTE
WITH OrderCount AS (
    SELECT O.ShipCity, SUM(O.OrderID) AS TotalOrders
    FROM dbo.Orders O
    GROUP BY O.ShipCity
),
ProductQuantity AS (
    SELECT O.ShipCity, SUM(D.Quantity) AS TotalQuantity
    FROM dbo.Orders O
    JOIN dbo.[Order Details] D ON O.OrderID = D.OrderID
    GROUP BY O.ShipCity
)
SELECT TOP 1 OC.ShipCity, OC.TotalOrders, PQ.TotalQuantity
FROM OrderCount OC
JOIN ProductQuantity PQ ON OC.ShipCity = PQ.ShipCity
ORDER BY PQ.TotalQuantity DESC, OC.TotalOrders DESC;

-- 11. How do you remove the duplicates record of a table?
Using DISTINCT (For Query Results)