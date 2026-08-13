/* ============================================================
   SUPER MART T-SQL CAPSTONE PROJECT
   Database: SuperMart_Db
   Developer: MARTIN KAMOGELO SHAI
   Date: 2026
   ============================================================ */


/* ============================================================
   ACTIVITY 1 – CREATE DATABASE
   ============================================================ */

-- Create the SuperMart database
CREATE DATABASE SuperMart_Db;
GO

-- Select the database
USE SuperMart_Db;
GO


/* ============================================================
   ACTIVITY 1 – CREATE TABLES
   ============================================================ */

-- ------------------------------------------------------------
-- Customers Table
-- Phone is the only column allowed to contain NULL
-- ------------------------------------------------------------

CREATE TABLE Customers
(
    CustomerId INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Phone VARCHAR(20) NULL,
    Email VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Customers
        PRIMARY KEY (CustomerId)
);
GO


-- ------------------------------------------------------------
-- Orders Table
-- ------------------------------------------------------------

CREATE TABLE Orders
(
    OrderId INT NOT NULL,
    CustomerId INT NOT NULL,
    OrderDate DATE NOT NULL,
    StatusCode CHAR(1) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Orders
        PRIMARY KEY (OrderId),

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerId)
        REFERENCES Customers(CustomerId),

    CONSTRAINT CK_Orders_Status
        CHECK (StatusCode IN ('P', 'D', 'C'))
);
GO


/* ============================================================
   ACTIVITY 2 – POPULATE DATABASE
   ============================================================ */

-- Insert 7 customers
-- At least two customers will have no orders.
-- Some customers have NULL phone numbers.

INSERT INTO Customers
(CustomerId,        FirstName,      LastName,        Country,             City,                Phone,             Email                   )

VALUES

(1,                 'Thabo',        'Mokoena',      'South Africa',     'Johannesburg',     '0821112233',       'thabo.mokoena@email.com'),
(2,                 'Lerato',       'Molefe',       'South Africa',     'Pretoria',         NULL,               'lerato.molefe@email.com'),
(3,                 'Sipho',        'Dlamini',      'South Africa',     'Cape Town',        '0833334455',       'sipho.dlamini@email.com'),
(4,                 'Naledi',       'Mabena',       'South Africa',     'Johannesburg',     NULL,               'naledi.mabena@email.com'),
(5,                 'Kagiso',       'Mokoena',      'South Africa',     'Pretoria',         '0715556677',       'kagiso.mokoena@email.com'),
(6,                 'Aisha',        'Khan',         'South Africa',     'Cape Town',        '0798889900',       'aisha.khan@email.com'),
(7,                 'Mpho',         'Ndlovu',       'South Africa',     'Johannesburg',     NULL,               'mpho.ndlovu@email.com');
GO


-- Insert 10 orders
INSERT INTO Orders
(
    OrderId,
    CustomerId,
    OrderDate,
    StatusCode,
    TotalAmount
)
VALUES
(1001,      1,      '2026-01-05',       'D',    1250.00),
(1002,      2,      '2026-01-18',       'P',    850.50),
(1003,      1,      '2026-02-10',       'D',    2300.75),
(1004,      3,      '2026-03-25',       'C',    450.00),
(1005,      4,      '2026-04-12',       'D',    1750.25),
(1006,      5,      '2026-06-03',       'P',    920.00),
(1007,      3,      '2026-07-15',       'D',    3100.00),
(1008,      4,      '2026-08-20',       'P',    670.80),
(1009,      1,      '2026-10-05',       'D',    4500.00),
(1010,      5,      '2026-12-15',       'P',    1150.50);
GO


/* ============================================================
   ACTIVITY 3 – BASIC DATA RETRIEVAL
   Customer Contact Report
   ============================================================ */

SELECT
    CustomerId,
    CONCAT(FirstName, ' ', LastName) AS [Customer Name],
    Country,
    City,
    COALESCE(Phone, 'No Phone Number') AS Phone
FROM Customers;
GO
M

/* ============================================================
   ACTIVITY 4A – FILTERING DATA
   Customers from Gauteng
   Using IN operator
   ============================================================ */

SELECT
    CONCAT(FirstName, ' ', LastName) AS [Customer Name],
    Email,
    City
FROM Customers
WHERE City IN ('Johannesburg', 'Pretoria');
GO


/* ============================================================
   ACTIVITY 4B – ORDERS DURING FIRST QUARTER OF 2026
   Using BETWEEN
   ============================================================ */

SELECT
    OrderId,
    CustomerId,
    OrderDate,
    StatusCode AS Status,
    TotalAmount
FROM Orders
WHERE OrderDate BETWEEN '2026-01-01' AND '2026-03-31';
GO


/* ============================================================
   ACTIVITY 5 – SQL JOINS
   ============================================================ */


/* ------------------------------------------------------------
   INNER JOIN
   Customers who have placed orders
   ------------------------------------------------------------ */

SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS [Customer Name],
    o.OrderId,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerId = o.CustomerId;
GO


/* ------------------------------------------------------------
   LEFT JOIN
   All customers including customers with no orders
   ------------------------------------------------------------ */

SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS [Customer Name],
    o.OrderId,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerId = o.CustomerId;
GO


/* ------------------------------------------------------------
   RIGHT JOIN
   Every order including unmatched orders
   ------------------------------------------------------------ */

SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS [Customer Name],
    o.OrderId,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o
    ON c.CustomerId = o.CustomerId;
GO


/* ------------------------------------------------------------
   FULL OUTER JOIN
   All customers and all orders
   ------------------------------------------------------------ */

SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS [Customer Name],
    o.OrderId,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
FULL OUTER JOIN Orders o
    ON c.CustomerId = o.CustomerId;
GO


/* ============================================================
   ACTIVITY 6 – SORTING, AGGREGATION,
   DATE AND STRING FUNCTIONS
   ============================================================ */


/* ------------------------------------------------------------
   TASK 1
   Customer directory
   UPPERCASE customer name
   LENGTH OF FIRST NAME
   Sort by FirstName ASC
   ------------------------------------------------------------ */

SELECT
    UPPER(CONCAT(FirstName, ' ', LastName)) AS [Customer Name],
    Country,
    LEN(FirstName) AS [First Name Length]
FROM Customers
ORDER BY FirstName ASC;
GO


/* ------------------------------------------------------------
   TASK 2
   Customer distribution by country
   ------------------------------------------------------------ */

SELECT
    Country,
    COUNT(*) AS [Total Customers]
FROM Customers
GROUP BY Country
ORDER BY [Total Customers] DESC;
GO


/* ------------------------------------------------------------
   TASK 3
   Order summary
   ------------------------------------------------------------ */

SELECT


    COUNT(*) AS [Total Orders],
    AVG(TotalAmount) AS [Average Order Amount],
    MAX(TotalAmount) AS [Highest Order Amount],
    MIN(TotalAmount) AS [Lowest Order Amount]
FROM Orders;
GO


/* ------------------------------------------------------------
   TASK 4
   Order activity
   YEAR()
   MONTH()
   DATEDIFF()
   ------------------------------------------------------------ */

SELECT
    OrderId,
    OrderDate,
    YEAR(OrderDate) AS [Order Year],
    MONTH(OrderDate) AS [Order Month],
    DATEDIFF(DAY, OrderDate, GETDATE()) AS [Days Since Order],
    TotalAmount
FROM Orders
ORDER BY TotalAmount DESC;
GO


/* ============================================================
   ACTIVITY 7 – ADVANCED QUERIES
   ============================================================ */


/* ------------------------------------------------------------
   SECTION A – SUBQUERY
   Customers who have placed at least one order
   ------------------------------------------------------------ */

SELECT
    CustomerId,
    CONCAT(FirstName, ' ', LastName) AS [Customer Name],
    Country
FROM Customers
WHERE CustomerId IN
(
    SELECT CustomerId
    FROM Orders
);
GO


/* ------------------------------------------------------------
   SECOND SUBQUERY
   Using EXISTS
   ------------------------------------------------------------ */

SELECT
    CustomerId,
    CONCAT(FirstName, ' ', LastName) AS [Customer Name],
    Country
FROM Customers c
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.CustomerId = c.CustomerId
);
GO


/* ============================================================
   SECTION B1 – CREATE VIEW
   ============================================================ */

CREATE VIEW CustomerOrders
AS
SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS [Customer Name],
    o.OrderDate,
    o.TotalAmount
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerId = o.CustomerId;
GO


-- Test the View
SELECT *
FROM CustomerOrders;
GO


/* ============================================================
   SECTION B2 – COMMON TABLE EXPRESSION (CTE)
   ============================================================ */

WITH CustomerOrderCount AS
(
    SELECT
        CustomerId,
        COUNT(*) AS [Number of Orders]
    FROM Orders
    GROUP BY CustomerId
)
SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS [Customer Name],
    COALESCE(coc.[Number of Orders], 0) AS [Number of Orders]
FROM Customers c
LEFT JOIN CustomerOrderCount coc
    ON c.CustomerId = coc.CustomerId;
GO


/* ============================================================
   SECTION C – STORED PROCEDURE
   ============================================================ */

CREATE PROCEDURE GetCustomerOrders
    @CustomerID INT
AS
BEGIN

    SELECT
        OrderId,
        OrderDate,
        StatusCode AS [Order Status],
        TotalAmount
    FROM Orders
    WHERE CustomerId = @CustomerID;

END;
GO


/* ------------------------------------------------------------
   Execute stored procedure for CustomerID = 1
   ------------------------------------------------------------ */

EXEC GetCustomerOrders @CustomerID = 1;
GO


/* ============================================================
   IF...ELSE LOGIC
   ============================================================ */

DECLARE @CustomerID INT = 1;
DECLARE @OrderCount INT;

SELECT @OrderCount = COUNT(*)
FROM Orders
WHERE CustomerId = @CustomerID;

IF @OrderCount > 0
BEGIN
    PRINT 'Customer has placed one or more orders.';
END
ELSE
BEGIN
    PRINT 'Customer has not placed any orders.';
END;
GO


/* ============================================================
   TRANSACTION
   Demonstration of transaction control
   ============================================================ */

BEGIN TRANSACTION;

BEGIN TRY

    INSERT INTO Orders
    (
        OrderId,
        CustomerId,
        OrderDate,
        StatusCode,
        TotalAmount
    )
    VALUES
    (
        1011,
        6,
        '2026-08-07',
        'P',
        750.00
    );

    COMMIT TRANSACTION;

    PRINT 'Transaction completed successfully.';

END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION;

    PRINT 'Transaction failed and was rolled back.';
    PRINT ERROR_MESSAGE();

END CATCH;
GO


/* ============================================================
   TRY...CATCH ERROR HANDLING
   ============================================================ */

BEGIN TRY

    -- This will intentionally cause an error
    INSERT INTO Orders
    (
        OrderId,
        CustomerId,
        OrderDate,
        StatusCode,
        TotalAmount
    )
    VALUES
    (
        1001,              -- Duplicate OrderId
        1,
        '2026-08-07',
        'D',
        500.00
    );

END TRY

BEGIN CATCH

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;

END CATCH;
GO


/* ============================================================
   FINAL VERIFICATION
   ============================================================ */

-- Display all customers
SELECT *
FROM Customers;
GO

-- Display all orders
SELECT *
FROM Orders;
GO