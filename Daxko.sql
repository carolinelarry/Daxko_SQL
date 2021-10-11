-- 1) Provide all addresses that are located in Texas

SELECT * FROM Person.Address;

SELECT * FROM  Person.StateProvince;

SELECT 
    Person.Address.AddressLine1, 
    Person.Address.AddressLine2, 
    Person.Address.City, 
    Person.StateProvince.Name AS "State", 
    Person.Address.PostalCode
FROM Person.Address
INNER JOIN Person.StateProvince
    ON Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID
WHERE Person.Address.StateProvinceID IN (
    SELECT StateProvinceID 
    FROM Person.StateProvince
    WHERE Name = 'Texas' 
);  


-- 2) All products that have a standard cost greater than $50 and a list price more than double the standard cost 

SELECT * FROM Production.Product
WHERE StandardCost > 50 AND ListPrice > (2 * StandardCost);

-- 3) Update "St." to "Street"

SELECT * FROM Person.Address;

UPDATE Person.Address  
SET  AddressLine1 = REPLACE(AddressLine1, 'St.', 'Street');

SELECT * FROM Person.Address;

-- 4) Up list price $25

SELECT * FROM Production.Product;

-- First update list price in Product table
UPDATE Production.Product
SET ListPrice = ListPrice + 25
WHERE Name = 'All-Purpose Bike Stand';


--Insert record into list price history table and update end date in previous entry
SELECT * FROM Production.ProductListPriceHistory;

UPDATE Production.ProductListPriceHistory
SET EndDate = DATEADD(day, 0, getdate())
WHERE ProductID IN (
    SELECT ProductID FROM Production.Product
    WHERE Name = 'All-Purpose Bike Stand'
);

SELECT ProductID FROM Production.Product
WHERE Name = 'All-Purpose Bike Stand';
--879

INSERT INTO Production.ProductListPriceHistory (ProductID, StartDate, EndDate, ListPrice, ModifiedDate)
VALUES (879, DATEADD(day, 0, getdate()), NULL, 184.0000, DATEADD(day, 0, getdate()));

--DELETE FROM Production.ProductListPriceHistory WHERE ProductID = '879' AND ListPrice = 184;

SELECT * FROM Production.ProductListPriceHistory
WHERE ProductID = 879;


-- 5) Human Rources Pay History Table

SELECT * FROM HumanResources.EmployeePayHistory;

--Creating view--
CREATE VIEW RateChangeView AS
SELECT
	  RateChangeDate,
	  DATEDIFF(DAY, LAG(RateChangeDate) OVER (ORDER BY RateChangeDate), RateChangeDate)
                AS DaysSinceLastRateChange,
    Count(BusinessEntityID) OVER (Partition BY RateChangeDate) AS NumberofRateChanges,
    Rate
FROM  HumanResources.EmployeePayHistory;


SELECT * FROM RateChangeView;

--------------------------------------------------------------
SELECT *
    --LAG(RateChangeDate) OVER (ORDER BY RateChangeDate) AS PreviousDate
FROM RateChangeView
WHERE DaysSinceLastRateChange = 
    (SELECT MAX(DaysSinceLastRateChange)
    FROM RateChangeView);

--------------------------------------------------------------
--Query ordering results by DaysSinceLastRateChange
SELECT
	  RateChangeDate,
      ModifiedDate,
	  DATEDIFF(DAY, LAG(RateChangeDate) OVER (ORDER BY RateChangeDate), RateChangeDate) AS DaysSinceLastRateChange,
    Count(BusinessEntityID) OVER (Partition BY RateChangeDate)AS NumberofRateChanges,
    Rate
FROM  HumanResources.EmployeePayHistory;
--ORDER BY DaysSinceLastRateChange DESC;

-- 6) 

SELECT * FROM Sales.SalesOrderHeader;

--Created view to use later
CREATE VIEW SalesReport5 AS
    SELECT 
        year(OrderDate) AS Year, 
        SalesPersonID, 
        TaxAmt, 
        SubTotal, 
        (TaxAmt + SubTotal) AS TotalSales,
        SUM(TaxAmt + SubTotal) OVER (PARTITION BY SalesPersonID, year(OrderDate) ORDER BY year(OrderDate)) AS SalesPersonTotal,
        SUM(TaxAmt + SubTotal) OVER (PARTITION BY year(OrderDate) ORDER BY year(OrderDate)) AS YearlyTotal
    FROM Sales.SalesOrderHeader;

SELECT * FROM SalesReport5;

--Year, Total Sales, and Percentage of Total Sales for Michael Blythe
SELECT
    Year,
    AVG(YearlyTotal) as TotalSales,
    AVG((SalesPersonTotal / YearlyTotal) * 100) AS PercentSales
FROM SalesReport5
WHERE SalesPersonID IN (
    SELECT BusinessEntityID FROM Person.Person
    WHERE LastName = 'Blythe'
)
GROUP BY Year
ORDER BY Year


-- 7) Provide listing for every employee hired after Jan 1, 2008 who has had their pay rate changed

SELECT * FROM HumanResources.Employee --hire date, jobtitle, 
SELECT * FROM Person.Person --first name, last name, 
SELECT * FROM HumanResources.EmployeePayHistory --pay history


SELECT Person.Person.BusinessEntityID, Person.Person.FirstName, Person.Person.LastName, 
    HumanResources.Employee.JobTitle, HumanResources.Employee.HireDate, HumanResources.EmployeePayHistory.RateChangeDate,
    HumanResources.EmployeePayHistory.Rate
FROM Person.Person
--Joining three tables on BusinessEntityID
INNER JOIN HumanResources.Employee ON
    Person.Person.BusinessEntityID = HumanResources.Employee.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory ON
    HumanResources.Employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID
--Only including employees hired after Jan 1, 2008 and who have had their pay rate changed since hire date
WHERE HireDate > '01-08-2008' AND HireDate != RateChangeDate
ORDER BY Person.Person.BusinessEntityID


 










