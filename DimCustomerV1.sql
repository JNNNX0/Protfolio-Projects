--Cleaned DIM Customers Table
SELECT 
      c.CustomerKey AS [CustomerKey]
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      ,c.FirstName AS [FirstName]
      --,[MiddleName]
      ,c.LastName AS [LastName]
	  , CONCAT(c.FirstName,' ',c.LastName)
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
      ,CASE c.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' End as Gender
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      --,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
      ,c.DateFirstPurchase AS [DateFirstPurchase]
      --,[CommuteDistance]
	  ,d.City AS City
  FROM 
  AdventureWorksDW2019.dbo.DimCustomer c
  LEFT JOIN AdventureWorksDW2019.dbo.DimGeography d 
  on c.GeographyKey = d.GeographyKey
  ORDER BY CustomerKey 
