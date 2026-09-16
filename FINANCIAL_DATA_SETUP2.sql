CREATE TABLE CompanyExpenses (
    ExpenseID VARCHAR(10),
    Department VARCHAR(30),
    ExpenseCategory VARCHAR(30),
    AmountSpent DECIMAL(10,2),
    ApprovedBy VARCHAR(50),
    ExpenseDate DATE);
INSERT INTO CompanyExpenses VALUES
('EXP5001', 'Marketing', 'Digital Ads', 45000, 'Financial Controller', '2025-01-05'),
('EXP5002', 'IT Operations', 'Cloud Infrastructure', 120000, 'IT Head', '2025-01-20'),
('EXP5003', 'Finance', 'Audit & Compliance', 85000, 'Finance Manager', '2025-02-12'),
('EXP5004', 'Marketing', 'Event Sponsorship', 150000, 'CMO', '2025-03-15'),
('EXP5005', 'Sales & Infra', 'Travel & Client Dinners', 62000, 'Sales Director', '2025-04-10'),
('EXP5006', 'IT Operations', 'Software Licenses', 98000, 'IT Head', '2025-05-18'),
('EXP5007', 'Marketing', 'Influencer Campaign', 75000, 'Financial Controller', '2025-06-25');
GO
CREATE PROCEDURE GetDepartmentExpense
    @DeptName VARCHAR(30)
AS
BEGIN
    SELECT 
        Department,
        SUM(AmountSpent) AS TotalExpense
    FROM CompanyExpenses
    WHERE Department = @DeptName
    GROUP BY Department;
END;
GO
EXEC GetDepartmentExpense @DeptName = 'Marketing';
GO
ALTER PROCEDURE GetDepartmentExpense
    @DeptName VARCHAR(30),
    @MinAmount DECIMAL(10,2)
AS
BEGIN
    SELECT 
        Department,
        SUM(AmountSpent) AS TotalExpense
    FROM CompanyExpenses
    WHERE Department = @DeptName 
      AND AmountSpent >= @MinAmount
    GROUP BY Department;
END;
GO
EXEC GetDepartmentExpense @DeptName = 'Marketing', @MinAmount = 50000;
GO
CREATE VIEW vw_DepartmentSummary AS
SELECT 
    Department,
    SUM(AmountSpent) AS TotalExpense
FROM CompanyExpenses
GROUP BY Department;
GO
CREATE INDEX idx_Expenses_Department
ON CompanyExpenses (Department);
SELECT * FROM vw_DepartmentSummary;
WITH RankedExpenses AS (
    SELECT 
        ExpenseID,
        Department,
        ExpenseCategory,
        AmountSpent,
        ROW_NUMBER() OVER (PARTITION BY Department ORDER BY AmountSpent DESC) AS ExpenseRank
    FROM CompanyExpenses
)
SELECT 
    ExpenseID,
    Department,
    ExpenseCategory,
    AmountSpent
FROM RankedExpenses
WHERE ExpenseRank = 1;