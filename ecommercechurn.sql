-- ===== Step 1: Create Project Database and Table =====

CREATE DATABASE IF NOT EXISTS EcommerceChurnDB;
USE EcommerceChurnDB;

CREATE TABLE ecommercechurn (
    CustomerID INT PRIMARY KEY,
    Churn TINYINT,
    Tenure INT,
    PreferredLoginDevice VARCHAR(50),
    CityTier INT,
    WarehouseToHome INT,
    PreferredPaymentMode VARCHAR(50),
    Gender VARCHAR(10),
    HourSpendOnApp DECIMAL(5,2),
    NumberOfDeviceRegistered INT,
    PreferedOrderCat VARCHAR(50),
    SatisfactionScore INT,
    MaritalStatus VARCHAR(20),
    NumberOfAddress INT,
    Complain TINYINT,
    OrderAmountHikeFromLastYear INT,
    CouponUsed INT,
    OrderCount INT,
    DaySinceLastOrder INT,
    CashbackAmount DECIMAL(10,2)
);
/********************
** Data Cleaning **
********************/

-- 1. Find the total number of customers
SELECT COUNT(DISTINCT CustomerID) AS TotalNumberOfCustomers
FROM ecommercechurn;

-- 2. Check for duplicate rows
SELECT CustomerID, COUNT(CustomerID) AS CountPerCustomer
FROM ecommercechurn
GROUP BY CustomerID
HAVING COUNT(CustomerID) > 1;

-- 3. Check for NULL values in important columns
SELECT 'Tenure' AS ColumnName, COUNT(*) AS NullCount 
FROM ecommercechurn WHERE Tenure IS NULL
UNION
SELECT 'WarehouseToHome', COUNT(*) FROM ecommercechurn WHERE WarehouseToHome IS NULL
UNION
SELECT 'HourSpendOnApp', COUNT(*) FROM ecommercechurn WHERE HourSpendOnApp IS NULL
UNION
SELECT 'OrderAmountHikeFromLastYear', COUNT(*) FROM ecommercechurn WHERE OrderAmountHikeFromLastYear IS NULL
UNION
SELECT 'CouponUsed', COUNT(*) FROM ecommercechurn WHERE CouponUsed IS NULL
UNION
SELECT 'OrderCount', COUNT(*) FROM ecommercechurn WHERE OrderCount IS NULL
UNION
SELECT 'DaySinceLastOrder', COUNT(*) FROM ecommercechurn WHERE DaySinceLastOrder IS NULL;

-- 3.1 Handle null values by replacing with column average
SET SQL_SAFE_UPDATES = 0;

UPDATE ecommercechurn 
SET HourSpendOnApp = (SELECT ROUND(AVG(HourSpendOnApp),1) FROM (SELECT * FROM ecommercechurn) AS tmp)
WHERE HourSpendOnApp IS NULL;

UPDATE ecommercechurn 
SET Tenure = (SELECT ROUND(AVG(Tenure),0) FROM (SELECT * FROM ecommercechurn) AS tmp)
WHERE Tenure IS NULL;

UPDATE ecommercechurn 
SET OrderAmountHikeFromLastYear = (SELECT ROUND(AVG(OrderAmountHikeFromLastYear),0) FROM (SELECT * FROM ecommercechurn) AS tmp)
WHERE OrderAmountHikeFromLastYear IS NULL;

UPDATE ecommercechurn 
SET WarehouseToHome = (SELECT ROUND(AVG(WarehouseToHome),0) FROM (SELECT * FROM ecommercechurn) AS tmp)
WHERE WarehouseToHome IS NULL;

UPDATE ecommercechurn 
SET CouponUsed = (SELECT ROUND(AVG(CouponUsed),0) FROM (SELECT * FROM ecommercechurn) AS tmp)
WHERE CouponUsed IS NULL;

UPDATE ecommercechurn 
SET OrderCount = (SELECT ROUND(AVG(OrderCount),0) FROM (SELECT * FROM ecommercechurn) AS tmp)
WHERE OrderCount IS NULL;

UPDATE ecommercechurn 
SET DaySinceLastOrder = (SELECT ROUND(AVG(DaySinceLastOrder),0) FROM (SELECT * FROM ecommercechurn) AS tmp)
WHERE DaySinceLastOrder IS NULL;

-- 4. Create readable customer status labels
ALTER TABLE ecommercechurn ADD CustomerStatus VARCHAR(50);
UPDATE ecommercechurn
SET CustomerStatus = CASE 
    WHEN Churn = 1 THEN 'Churned'
    WHEN Churn = 0 THEN 'Stayed'
END;

-- 5. Create readable complaint labels
ALTER TABLE ecommercechurn ADD ComplainReceived VARCHAR(10);
UPDATE ecommercechurn
SET ComplainReceived = CASE
    WHEN Complain = 1 THEN 'Yes'
    WHEN Complain = 0 THEN 'No'
END;

-- 6. Data Accuracy Checks & Fixes
-- 6.1 Standardize PreferredLoginDevice values
UPDATE ecommercechurn SET PreferredLoginDevice = 'Phone'
WHERE LOWER(PreferredLoginDevice) IN ('mobile phone', 'phone');

-- 6.2 Standardize PreferedOrderCat values
UPDATE ecommercechurn SET PreferedOrderCat = 'Mobile Phone'
WHERE LOWER(PreferedOrderCat) IN ('mobile');

-- 6.3 Standardize PreferredPaymentMode values
UPDATE ecommercechurn SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

-- 6.4 Correct WarehouseToHome outliers
UPDATE ecommercechurn SET WarehouseToHome = 27 WHERE WarehouseToHome = 127;
UPDATE ecommercechurn SET WarehouseToHome = 26 WHERE WarehouseToHome = 126;

-----------------------------------------------------
-- Data Exploration & Business Questions
-----------------------------------------------------

-- 1. What is the overall customer churn rate?
SELECT 
    t.TotalCustomers, 
    c.ChurnedCustomers,
    ROUND((c.ChurnedCustomers / t.TotalCustomers) * 100, 2) AS ChurnRate
FROM
    (SELECT COUNT(*) AS TotalCustomers FROM ecommercechurn) AS t,
    (SELECT COUNT(*) AS ChurnedCustomers FROM ecommercechurn WHERE CustomerStatus = 'Churned') AS c;

-- 2. How does the churn rate vary based on the preferred login device?
SELECT PreferredLoginDevice, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY PreferredLoginDevice;

-- 3. Distribution of customers across city tiers
SELECT CityTier, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY CityTier
ORDER BY ChurnRate DESC;

-- 4. Correlation between warehouse-to-home distance and churn
ALTER TABLE ecommercechurn ADD WarehouseToHomeRange VARCHAR(50);
UPDATE ecommercechurn
SET WarehouseToHomeRange = CASE
    WHEN WarehouseToHome <= 10 THEN 'Very Close'
    WHEN WarehouseToHome <= 20 THEN 'Close'
    WHEN WarehouseToHome <= 30 THEN 'Moderate'
    ELSE 'Far'
END;

SELECT WarehouseToHomeRange, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY WarehouseToHomeRange
ORDER BY ChurnRate DESC;

-- 5. Most preferred payment mode among churned customers
SELECT PreferredPaymentMode, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY PreferredPaymentMode
ORDER BY ChurnRate DESC;

-- 6. Typical tenure for churned customers
ALTER TABLE ecommercechurn ADD TenureRange VARCHAR(50);
UPDATE ecommercechurn
SET TenureRange = CASE
    WHEN Tenure <= 6 THEN '6 Months'
    WHEN Tenure > 6 AND Tenure <= 12 THEN '1 Year'
    WHEN Tenure > 12 AND Tenure <= 24 THEN '2 Years'
    ELSE 'More than 2 Years'
END;

SELECT TenureRange, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY TenureRange
ORDER BY ChurnRate DESC;

-- 7. Churn rate difference by gender
SELECT Gender, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY Gender
ORDER BY ChurnRate DESC;

-- 8. Average time spent on app by churn status
SELECT CustomerStatus, AVG(HourSpendOnApp) AS AverageHourSpentOnApp
FROM ecommercechurn
GROUP BY CustomerStatus;

-- 9. Impact of number of registered devices on churn
SELECT NumberOfDeviceRegistered, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY NumberOfDeviceRegistered
ORDER BY ChurnRate DESC;

-- 10. Preferred order category among churned customers
SELECT PreferedOrderCat, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY PreferedOrderCat
ORDER BY ChurnRate DESC;

-- 11. Relationship between satisfaction score and churn
SELECT SatisfactionScore, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY SatisfactionScore
ORDER BY ChurnRate DESC;

-- 12. Influence of marital status on churn behavior
SELECT MaritalStatus, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY MaritalStatus
ORDER BY ChurnRate DESC;

-- 13. Average number of addresses churned customers have
SELECT AVG(NumberOfAddress) AS AverageNumOfChurnedCustomerAddress
FROM ecommercechurn
WHERE CustomerStatus = 'Churned';

-- 14. Influence of customer complaints on churn
SELECT ComplainReceived, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY ComplainReceived
ORDER BY ChurnRate DESC;

-- 15. Usage of coupons among churned vs non-churned customers
SELECT CustomerStatus, SUM(CouponUsed) AS SumOfCouponUsed
FROM ecommercechurn
GROUP BY CustomerStatus;

-- 16. Average days since last order for churned customers
SELECT AVG(DaySinceLastOrder) AS AverageNumOfDaysSinceLastOrder
FROM ecommercechurn
WHERE CustomerStatus = 'Churned';

-- 17. Correlation between cashback amount and churn
ALTER TABLE ecommercechurn ADD CashbackAmountRange VARCHAR(50);
UPDATE ecommercechurn
SET CashbackAmountRange = CASE
    WHEN CashbackAmount <= 100 THEN 'Low Cashback Amount'
    WHEN CashbackAmount > 100 AND CashbackAmount <= 200 THEN 'Moderate Cashback Amount'
    WHEN CashbackAmount > 200 AND CashbackAmount <= 300 THEN 'High Cashback Amount'
    ELSE 'Very High Cashback Amount'
END;

SELECT CashbackAmountRange, COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
       ROUND(SUM(Churn) / COUNT(*) * 100, 2) AS ChurnRate
FROM ecommercechurn
GROUP BY CashbackAmountRange
ORDER BY ChurnRate DESC;
