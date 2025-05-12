-- List all employees and their job titles.

SELECT 
	prs.FirstName,
	prs.LastName,
	emp.JobTitle,
	emp.Gender,
	emp.MaritalStatus,
	emp.HireDate
FROM Person.Person prs
JOIN HumanResources.Employee emp
	ON prs.BusinessEntityID = emp.BusinessEntityID;

-- Find all customers who live in 'California'.

SELECT 
    cst.CustomerID,
    cst.AccountNumber,
    adr.AddressLine1,
    adr.City,
    stp.Name AS StateName
FROM Sales.Customer cst
JOIN Person.Person prs
    ON cst.PersonID = prs.BusinessEntityID
JOIN Person.BusinessEntityAddress bea
    ON prs.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address adr
    ON bea.AddressID = adr.AddressID
JOIN Person.StateProvince stp
    ON adr.StateProvinceID = stp.StateProvinceID
WHERE stp.Name = 'California';

-- Display the top 10 most expensive products.

SELECT 
	Name,
	ProductNumber,
	StandardCost
FROM Production.Product
ORDER BY StandardCost DESC;

-- Show all orders placed in the year 2013.

SELECT 
	soh.SalesOrderID,
	soh.OrderDate,
	cst.AccountNumber,
	odt.OrderQty,
	(odt.UnitPrice * odt.OrderQty * (1-odt.UnitPriceDiscount)) AS total_spent
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer cst
	ON soh.CustomerID = cst.CustomerID
JOIN Sales.SalesOrderDetail odt
	ON soh.SalesOrderID = odt.SalesOrderID
WHERE YEAR(OrderDate) = 2013;

-- List all products that are currently out of stock.

SELECT 
	pdt.Name,
	pdt.StandardCost,
	pit.Shelf,
	pit.Quantity
FROM Production.ProductInventory pit
JOIN Production.Product pdt
	ON pit.ProductID = pdt.ProductID
WHERE Quantity = 0

-- Find the total sales per customer.

SELECT 
	cst.CustomerID,
	SUM(soh.TotalDue) AS Total
FROM Sales.Customer cst
JOIN Sales.SalesOrderHeader soh
	ON cst.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail odt
	ON soh.SalesOrderID = odt.SalesOrderID
GROUP BY cst.CustomerID;

-- List employees who work in the 'Production' department.

SELECT 
	prs.FirstName,
	prs.LastName,
	emp.Gender,
	emp.HireDate,
	emp.JobTitle,
	dep.Name,
	dep.GroupName
FROM Person.Person prs
JOIN HumanResources.Employee emp
	ON prs.BusinessEntityID = emp.BusinessEntityID
JOIN (
	SELECT 
		emp.BusinessEntityID,
		emp.DepartmentID
	FROM HumanResources.EmployeeDepartmentHistory emp
	WHERE emp.EndDate IS NULL
) aux
	ON emp.BusinessEntityID = aux.BusinessEntityID
JOIN HumanResources.Department dep
	ON aux.DepartmentID = dep.DepartmentID
WHERE dep.Name = 'Production';

SELECT 
	prs.FirstName,
	prs.LastName,
	emp.Gender,
	emp.HireDate,
	emp.JobTitle,
	dep.Name,
	dep.GroupName
FROM Person.Person prs
JOIN HumanResources.Employee emp
	ON prs.BusinessEntityID = emp.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh
	ON emp.BusinessEntityID = edh.BusinessEntityID
	AND edh.EndDate IS NULL
JOIN HumanResources.Department dep
	ON edh.DepartmentID = dep.DepartmentID
WHERE dep.Name = 'Production';

-- Find the average unit price of products in each product category.

SELECT 
	cat.Name AS 'Category', 
	AVG(pph.ListPrice) AS 'Average Price'
FROM Production.Product pdt
JOIN Production.ProductSubcategory sub
	ON pdt.ProductSubcategoryID = sub.ProductSubcategoryID
JOIN Production.ProductCategory cat
	ON sub.ProductCategoryID = cat.ProductCategoryID
JOIN Production.ProductListPriceHistory pph
	ON pdt.ProductID = pph.ProductID AND pph.EndDate IS NULL
GROUP BY cat.Name;

-- Retrieve all customers who have never placed an order.

SELECT 
	cst.CustomerID,
	cst.AccountNumber,
	cst.PersonID
FROM Sales.Customer cst
LEFT JOIN Sales.SalesOrderHeader soh
	ON cst.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;

-- Show the five cities with the most customers.

SELECT 
	adr.City,
	COUNT(DISTINCT cst.CustomerID) Customers
FROM Sales.Customer cst
JOIN Person.Person prs
	ON cst.PersonID = prs.BusinessEntityID
JOIN Person.BusinessEntityAddress bea
	ON prs.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address adr
    ON bea.AddressID = adr.AddressID
JOIN Person.StateProvince stp
    ON adr.StateProvinceID = stp.StateProvinceID
GROUP BY adr.City
ORDER BY Customers DESC;

-- Rank salespeople by total revenue generated.

SELECT 
	spn.BusinessEntityID,
	prs.FirstName,
	prs.LastName,
	SUM(odt.UnitPrice * odt.OrderQty * (1 - odt.UnitPriceDiscount)) AS TotalRevenue,
	DENSE_RANK() OVER (ORDER BY SUM(odt.UnitPrice * odt.OrderQty * (1 - odt.UnitPriceDiscount)) DESC) AS Rank
FROM Sales.SalesPerson spn
JOIN Sales.SalesOrderHeader soh
	ON spn.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail odt
	ON soh.SalesOrderID = odt.SalesOrderID
JOIN Person.Person prs
	ON spn.BusinessEntityID = prs.BusinessEntityID
GROUP BY spn.BusinessEntityID, prs.FirstName, prs.LastName;

-- Find products that have never been sold.

SELECT
	pdt.ProductID,
	pdt.Name
FROM Production.Product pdt
LEFT JOIN Sales.SalesOrderDetail odt
	ON pdt.ProductID = odt.ProductID
WHERE odt.SalesOrderID IS NULL;

-- Get the top 3 selling products by total quantity sold.

SELECT 
	pdt.Name,
	SUM(odt.OrderQty) AS Quantity,
	DENSE_RANK() OVER (ORDER BY SUM(odt.OrderQty) DESC) AS Rank
FROM Production.Product pdt
JOIN Sales.SalesOrderDetail odt
	ON pdt.ProductID = odt.ProductID
GROUP BY pdt.Name;

-- List the names of employees who have worked in more than one department.

SELECT
	emp.BusinessEntityID,
	prs.FirstName,
	prs.LastName,
	COUNT(DISTINCT edh.DepartmentID) AS 'Dept. Count'
FROM HumanResources.Employee emp
JOIN HumanResources.EmployeeDepartmentHistory edh
	ON emp.BusinessEntityID = edh.BusinessEntityID
JOIN Person.Person prs
	ON emp.BusinessEntityID = prs.BusinessEntityID
GROUP BY emp.BusinessEntityID, prs.FirstName, prs.LastName
HAVING COUNT(DISTINCT edh.DepartmentID) > 1;

-- Show the monthly sales totals for the year 2014.

SELECT
    MONTH(soh.OrderDate) AS 'Month',
    SUM(soh.TotalDue) AS 'Total Sales'
FROM Sales.SalesOrderHeader soh
WHERE YEAR(soh.OrderDate) = 2014
GROUP BY MONTH(soh.OrderDate)
ORDER BY 'Month';