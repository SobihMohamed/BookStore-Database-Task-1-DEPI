-- Task 1 Design the database schema
CREATE DATABASE BookStore
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);


CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL
);


CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    Stock INT NOT NULL CHECK (Stock >= 0),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);


CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    City VARCHAR(100) NOT NULL
);


CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    BookID INT,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
-- Task 2 Insert sample data that covers all the scenarios.
INSERT INTO Categories (CategoryName) 
VALUES 
('Novels'), 
('History'), 
('Self-Development'), 
('Technology');

INSERT INTO Authors (AuthorName) 
VALUES 
('Naguib Mahfouz'), 
('Ahmed Khaled Tawfik'), 
('Taha Hussein'), 
('Ibrahim El Feki'),
('Robert C. Martin');

INSERT INTO Books (Title, AuthorID, CategoryID, Price, Stock) 
VALUES 
('Utopia', 2, 1, 150.00, 20),
('The Thief and the Dogs', 1, 1, 120.00, 15),
('Paranormal - The Myth of the Cave', 2, 1, 80.00, 30),
('Paranormal - The Myth of the House', 2, 1, 80.00, 25),
('Children of the Alley', 1, 1, 200.00, 10),
('Miramar', 1, 1, 130.00, 12),
('The Days', 3, 2, 110.00, 18),
('Ten Keys to Ultimate Success', 4, 3, 180.00, 25),
('Clean Architecture in .NET', 5, 4, 350.00, 10);

INSERT INTO Customers (FullName, Email, City) 
VALUES 
('Mohamed Sobieh', 'mohamed@example.com', 'Cairo'),
('Essam', 'essam@example.com', 'Giza'),
('Hussam', 'hussam@example.com', 'Alexandria'),
('7olom', '7olom@example.com', 'Cairo'),
('Bisko', 'bisko@example.com', 'Cairo');

INSERT INTO Orders (CustomerID, OrderDate) 
VALUES 
(1, '2026-04-15'),
(2, '2026-04-20'),
(1, '2026-05-10'),
(3, '2026-05-25'),
(5, '2026-06-01');

INSERT INTO OrderItems (OrderID, BookID, Quantity, UnitPrice) 
VALUES 
(1, 1, 2, 150.00),
(1, 8, 1, 180.00),
(2, 3, 5, 80.00),
(3, 5, 1, 200.00),
(4, 2, 3, 120.00),
(5, 9, 1, 350.00);

-- Task 3 List all books sorted by price from highest
SELECT Title, Price 
FROM Books 
ORDER BY Price DESC;

-- Task 4 Show book titles in uppercase and author names in lowercase
SELECT 
    UPPER(B.Title) AS BookTitle, 
    LOWER(A.AuthorName) AS AuthorName
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID;

-- Task 5 Show every book with its category and its author
SELECT 
    B.Title AS BookTitle, 
    C.CategoryName, 
    A.AuthorName
FROM Books B
JOIN Categories C ON B.CategoryID = C.CategoryID
JOIN Authors A ON B.AuthorID = A.AuthorID;

-- Task 6: Show every customer with the number of purchases they have made.
SELECT 
    C.FullName, 
    COUNT(O.OrderID) AS NumberOfPurchases
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FullName;

-- Task 7: List the top 5 best-selling books.
SELECT TOP 5 
    B.Title, 
    SUM(OI.Quantity) AS TotalSold
FROM Books B
JOIN OrderItems OI ON B.BookID = OI.BookID
GROUP BY B.Title
ORDER BY TotalSold DESC;

-- Task 8: Find the city with the highest number of customers.
SELECT TOP 1 
    City, 
    COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
GROUP BY City
ORDER BY NumberOfCustomers DESC;

-- Task 9: List categories that have more than 5 books.
SELECT 
    C.CategoryName, 
    COUNT(B.BookID) AS NumberOfBooks
FROM Categories C
JOIN Books B ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryName
HAVING COUNT(B.BookID) > 5;

-- Task 10: Find all books that cost more than the average book price.
SELECT Title, Price
FROM Books
WHERE Price > (SELECT AVG(Price) FROM Books);

-- Task 11: Find customers who have never made a purchase.
SELECT FullName
FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- Task 12: Show the total revenue for each month.
SELECT 
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    SUM(OI.Quantity * OI.UnitPrice) AS TotalRevenue
FROM Orders O
JOIN OrderItems OI ON O.OrderID = OI.OrderID
GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate)

-- Task 13: Create a view that combines book title, category, author, and price.
CREATE VIEW vw_BookDetails AS
SELECT 
    B.Title AS BookTitle, 
    C.CategoryName, 
    A.AuthorName, 
    B.Price
FROM Books B
JOIN Categories C ON B.CategoryID = C.CategoryID
JOIN Authors A ON B.AuthorID = A.AuthorID;

SELECT * FROM vw_BookDetails;

-- Task 14: Create a stored procedure that returns all purchases of a given customer with the totals.

CREATE PROCEDURE sp_GetCustomerPurchases
    @CustomerID INT
AS
BEGIN
    SELECT 
        O.OrderID,
        O.OrderDate,
        B.Title AS BookTitle,
        OI.Quantity,
        OI.UnitPrice,
        (OI.Quantity * OI.UnitPrice) AS TotalPrice
    FROM Orders O
    JOIN OrderItems OI ON O.OrderID = OI.OrderID
    JOIN Books B ON OI.BookID = B.BookID
    WHERE O.CustomerID = @CustomerID;
END;

EXEC sp_GetCustomerPurchases @CustomerID = 1;

EXEC sp_GetCustomerPurchases @CustomerID = 2;