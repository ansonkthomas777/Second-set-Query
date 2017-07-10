/*1...Get USA and UK Customer's List and their Contact Information...*/
SELECT CustomerID,CompanyName,ContactTitle,Address,City,Country FROM Customers GROUP BY 
CustomerID,CompanyName,ContactTitle,Address,City,Country HAVING Country in('USA','UK')
/*2..Get Customer List who are from USA or from SP Region of Brazil.*/
SELECT CustomerID,CompanyName,ContactTitle,Address,City,Region,Country FROM Customers GROUP BY 
CustomerID,CompanyName,ContactTitle,Address,City,Region,Country HAVING ((Country ='USA' or (Country='Brazil' and Region='SP')))
/*..3.Get all the CustomerID and OrderID for order placed in third quarter of 1997..*/
/*july1 to sep 30..*/
SELECT CustomerID,OrderID,OrderDate FROM Orders GROUP BY 
CustomerID,OrderID,OrderDate HAVING OrderDate between '19970701' and '19970930'
/*4..Get the Customer who's Company Name starts with
 either A, B, C, D, E, F, or G and ends with N or E..*/
 SELECT CustomerID,CompanyName FROM Customers where CompanyName LIKE '[A-G]%%[NE]'
 /*5..Get the list of Customers where Company Name's 2nd letter is Consonant...*/
 SELECT CustomerID,CompanyName FROM Customers where CompanyName NOT LIKE '_[AEIOU]%'
 /*..We acquire new Shipper and it does not ship to PO Box.
  Generate the list of Customers which has PO Box address..*/
  SELECT CustomerID,PostalCode FROM Customers where PostalCode is not null
  /*
  Get the Customer Count by (Table: Customers)
            i. Country
            ii. Country, Region
            iii. Country, Region, City
*/
/*...i..*/

SELECT Country,COUNT(CustomerID)AS Count FROM Customers GROUP BY Country
/*...ii..*/

SELECT Country,Region,COUNT(CustomerID)AS Count FROM Customers GROUP BY Country,Region

/*...iii..*/

SELECT Country,Region,City,COUNT(CustomerID)AS Count FROM Customers GROUP BY Country,Region,City

/*..The Company wants to increase its relationship with
 higher raking officers of Customer. Get the Count of Contact's person by their title..*/

 SELECT ContactTitle,COUNT(ContactName)AS Count FROM Customers GROUP BY ContactTitle

 /*..Get the list of Customers and Number of Orders placed by each customer till date...*/
 SELECT CustomerID,COUNT(OrderID) AS NoOfOrders,ShippedDate FROM Orders GROUP BY CustomerID,ShippedDate HAVING 
 ShippedDate IS NOT NULL

 /*..Get the top 10 Customers who has placed most order till date...*/
 SELECT TOP 10 CustomerID,COUNT(OrderID) AS NoOfOrders  FROM Orders GROUP BY CustomerID ORDER BY COUNT(OrderID) DESC

 /*..Get Customers list who has placed 5 or more Orders...*/
 SELECT  CustomerID,COUNT(OrderID) AS NoOfOrders  FROM Orders GROUP BY CustomerID HAVING COUNT(OrderID)>=5

 /*..
 Get the Order Count by (Table:Orders)
            I. Each Year 
          ii. Each quarter in each year 
         iii. Each Month in each year ....*/

		 /*..i..*/
		 SELECT YEAR(OrderDate) AS YEAR,COUNT(OrderID)AS NoOfOrders FROM Orders 
		 GROUP BY YEAR(OrderDate) ORDER BY YEAR(OrderDate)

		 /*..ii..*/
		 
    SELECT DATEPART(YEAR,OrderDate) AS YEAR,
 DATEPART(QUARTER,OrderDate) AS Quarter, COUNT(OrderID) NoOfOrders
FROM Orders GROUP BY DATEPART(YEAR,OrderDate),DATEPART(QUARTER,OrderDate)
ORDER BY YEAR

		  /*..iii..*/
		 SELECT DATEPART(YEAR,OrderDate) AS YEAR,DATEPART(MONTH,OrderDate) AS 
		 MONTH,COUNT(OrderID)AS NoOfOrders FROM Orders 
		 GROUP BY DATEPART(YEAR,OrderDate),DATEPART(MONTH,OrderDate) ORDER BY YEAR

/*...Calculate Average, Total, Minimum, and Maximum Frieght paid (Table:Orders)
            i. For each Order
            ii. For each Company
            iii. For each Country on all orders
            iiv. for Each Carrier (ShipVia)

..*/
/*..i..*/
SELECT OrderID,AVG(Freight)AS AVG ,COUNT(Freight) AS COUNT,MIN(Freight) AS
 MIN,MAX(Freight) AS MAX FROM Orders GROUP BY OrderID

 /*..ii..*/
SELECT ShipName AS Company,AVG(Freight)AS AVG ,COUNT(Freight) AS COUNT,MIN(Freight) AS
 MIN,MAX(Freight) AS MAX FROM Orders GROUP BY ShipName

 /*..iii..*/
SELECT ShipCountry AS Country,AVG(Freight)AS AVG ,COUNT(Freight) AS COUNT,MIN(Freight) AS
 MIN,MAX(Freight) AS MAX FROM Orders GROUP BY ShipCountry

 /*..iv..*/
SELECT ShipVia AS Carrier,AVG(Freight)AS AVG ,COUNT(Freight) AS COUNT,MIN(Freight) AS
 MIN,MAX(Freight) AS MAX FROM Orders GROUP BY ShipVia

 /*...List Total Sale for each Product in each Order...*/

 SELECT OrderID,ProductID,UnitPrice,Quantity,Discount,((UnitPrice*Quantity)-(UnitPrice*Quantity*Discount))
  AS [Total Sale] FROM [Order Details]

  /*..For each Order Calculate (Table: [Orders Details])
            i. Types of Products Ordered (Hint: Count on Product)
            ii. Total Sale for each Order....*/

/*....i...*/
SELECT OrderID,Count(ProductID) AS [Type Of Product] FROM [Order Details]  group by OrderID
/*...ii...*/
  go  
  create view OrderDetailsView
  as
  SELECT OrderID,ProductID,UnitPrice,Quantity,Discount,((UnitPrice*Quantity)-(UnitPrice*Quantity*Discount))
  AS [Total Sale] FROM [Order Details]

  select OrderID,Sum(((UnitPrice*Quantity)-(UnitPrice*Quantity*Discount)))
  AS [Total Sale] FROM OrderDetailsView group by OrderID order by OrderID

  /*..List total Quantity Ordered for Each Product on all orders...*/  

  select ProductID,Sum(Quantity) AS [Total Quantity] FROM [Order Details] group by ProductID  order by ProductID

  /*...List top 10 Most Sold products in quantity in an order...*/

  select top 10 ProductID,count(Quantity)as [Most Sold] from [Order Details]
   group by ProductID order by  count(Quantity) desc

  /*...Provide a SQL statement and sample result set that will count orders
   for all Customers within the SP (Brazil) state during the 1997 calendar year sorted by Customer name. ...*/

   select Orders.OrderID,count(Orders.OrderID) as [Total Count] from Orders inner join Customers 
   on Orders.CustomerID=Customers.CustomerID
     where 	 (Customers.Region='SP'and Customers.Country='Brazil' and (Orders.OrderDate between '19970101' and '19971231')) 
	 group by Customers.ContactName,Orders.OrderID

	 /*...Provide a SQL statement and sample result set that will list all Customers 
	 within the SP (Brazil) state that have placed 7 or more orders during the 1998 calendar year. ..*/

	 select  Customers.CustomerID as [Customer] from Orders inner join Customers 
   on Orders.CustomerID=Customers.CustomerID
     where 	 (Customers.Region='SP'and Customers.Country='Brazil' 
	  and (Orders.OrderDate between '19980101' and '19981231')) 
	 group by Customers.CustomerID,Orders.OrderID having Count(Orders.OrderID)>=7



  


  
