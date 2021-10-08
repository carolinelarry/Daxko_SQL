-- 1) Provide all addresses that are located in Texas

Select * from Person.StateProvince
where Name = 'Texas' 

select * from Person.Address
where StateProvinceID = 73

SELECT Person.Address.AddressLine1, Person.Address.AddressLine2, Person.Address.City, Person.StateProvince.Name AS "State", Person.Address.PostalCode
from Person.Address
INNER JOIN Person.StateProvince ON
Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID
WHERE Person.Address.StateProvinceID = 73;

-- 2) All products that have a standard cost greater than $50 and a list price more than double the standard cost 

SELECT * FROM Production.Product
WHERE StandardCost > 50 AND 
ListPrice > (2 * StandardCost);

-- 3) Update "St." to "Street"

SELECT * FROM Person.Address;

UPDATE Person.Address  
SET  AddressLine1 = REPLACE(AddressLine1, 'St.', 'Street')
SELECT @@ROWCOUNT;

SELECT * FROM Person.Address;

-- 4) Up list price $25

-- First update list price in Product table
UPDATE Production.Product
SET ListPrice = ListPrice + 25
WHERE Name = 'All-Purpose Bike Stand';

SELECT * FROM Production.Product
WHERE Name = 'All-Purpose Bike Stand';

--Insert record into list price history table and update end date in previous entry
SELECT * FROM Production.ProductListPriceHistory;

SELECT * from Production.Product
WHERE Name = 'All-Purpose Bike Stand';
--Product ID is 879

SELECT * FROM Production.ProductListPriceHistory
WHERE ProductID = 879;

UPDATE Production.ProductListPriceHistory
SET EndDate = '2021-10-12 00:00:00.000'
WHERE ProductID = 879 AND ListPrice = 159;

INSERT INTO Production.ProductListPriceHistory (ProductID, StartDate, EndDate, ListPrice, ModifiedDate)
VALUES (879, '2021-10-12 00:00:00.000', NULL, 184.0000, '2021-10-12 00:00:00.000');

SELECT * FROM Production.ProductListPriceHistory
WHERE ProductID = 879;

--MESS AROUND WITH THIS LATER
--Convert(DateTime,'19820626',112)

-- 5) Human Rources Pay History Table

SELECT * FROM HumanResources.EmployeePayHistory;

-- 6) 

SELECT * FROM Person.Person
WHERE LastName = 'Blythe';
--BusinessEntityID either 275 or 495

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesPersonID = '274' or SalesPersonID = '495';
--Id = 274

--Is freight included in tax amount? I don't think it is because you have to add all 3 up to get "total"
-- select sum(*) as qty, datepart(yyyy, [date]) as [year]
-- from shoptransfer 
-- group by datepart(yyyy, [date])
-- order by [year]

SELECT *, (SubTotal + TaxAmt) as 'Total Sales'
from Sales.SalesOrderHeader;
--group above query by year/ sum it up for each year







