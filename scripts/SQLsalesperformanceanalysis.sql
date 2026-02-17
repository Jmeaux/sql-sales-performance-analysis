WITH MaxDate AS (
  SELECT MAX(OrderDate) AS MaxOrderDate
  FROM Sales.SalesOrderHeader
)
SELECT
  DATEFROMPARTS(YEAR(h.OrderDate), MONTH(h.OrderDate), 1) AS YearMonth,
  t.Name AS Territory,
  SUM(d.LineTotal) AS TotalSales,
  COUNT(DISTINCT h.CustomerID) AS TotalCustomers
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d
  ON h.SalesOrderID = d.SalesOrderID
LEFT JOIN Sales.SalesTerritory t
  ON h.TerritoryID = t.TerritoryID
CROSS JOIN MaxDate m
WHERE h.OrderDate >= DATEADD(YEAR, -3, m.MaxOrderDate)
GROUP BY
  DATEFROMPARTS(YEAR(h.OrderDate), MONTH(h.OrderDate), 1),
  t.Name
ORDER BY
  YearMonth, Territory;
