CREATE TABLE SalesTransactions (OrderID VARCHAR(10), CustomerName VARCHAR(50), ProductCategory VARCHAR(30), Region VARCHAR(20), SalesAmount DECIMAL(10,2), Profit DECIMAL(10,2), OrderDate DATE);
INSERT INTO SalesTransactions VALUES
('ORD1001', 'TechCorp Mumbai', 'Hardware', 'West', 150000, 25000, '2025-01-15'),
('ORD1002', 'Apex Financials', 'Software', 'North', 85000, 18000, '2025-02-10'),
('ORD1003', 'Metro Logistics', 'Consulting', 'South', 210000, 45000, '2025-03-05'),
('ORD1004', 'Horizon Retail', 'Hardware', 'West', 95000, 12000, '2025-04-18'),
('ORD1005', 'NextGen Tech', 'Software', 'East', 175000, 32000, '2025-05-22'),
('ORD1006', 'BlueStar Industries', 'Hardware', 'North', 310000, 60000, '2025-06-11'),
('ORD1007', 'Sun Infotech', 'Consulting', 'West', 125000, 22000, '2025-07-19'),
('ORD1008', 'Global Exports', 'Software', 'South', 240000, 50000, '2025-08-30')
GO
ALTER PROCEDURE GetRegionSales
    @RegionName VARCHAR(20)
AS
BEGIN
    SELECT 
        OrderID,
        CustomerName,
        SalesAmount,
        Profit
    FROM SalesTransactions
    WHERE Region = @RegionName;
END;
GO
EXEC GetRegionSales @RegionName = 'West';
GO
CREATE VIEW vw_HighValueSales AS
SELECT 
    OrderID,
    CustomerName,
    ProductCategory,
    SalesAmount,
    Profit
FROM SalesTransactions
WHERE SalesAmount >= 150000;
GO
SELECT * FROM vw_HighValueSales;
CREATE INDEX idx_Sales_Region
ON SalesTransactions (Region);
SELECT 
    OrderID,
    CustomerName,
    Region,
    SalesAmount,
    ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SalesAmount DESC) AS SalesRank
FROM SalesTransactions;
WITH RankedSales AS (
    SELECT 
        OrderID,
        CustomerName,
        Region,
        SalesAmount,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SalesAmount DESC) AS SalesRank
    FROM SalesTransactions
)
SELECT 
    OrderID,
    CustomerName,
    Region,
    SalesAmount
FROM RankedSales
WHERE SalesRank = 1;