-- 3 csv files are being taken in this project---
-- Tables must have atleast one common column with same column name and same data type.

CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;


DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
 Book_ID INT PRIMARY KEY,
 Title VARCHAR(100),
 Author VARCHAR(100),
 Genre VARCHAR(50),
 Published_Year INT,
 Price NUMERIC(10,2),
 Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
  Customer_Id INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(100),
  City VARCHAR(100),
  Country VARCHAR(100)
);
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
 Order_Id INT PRIMARY KEY,
 Customer_id INT REFERENCES customers(Customer_Id),
 Book_Id INT REFERENCES Books(Book_Id),
 Order_Date DATE,
 Quantity INT,
 Total_Amount NUMERIC(10,2)
)
SELECT*FROM Books;
SELECT*FROM customers;
SELECT*FROM Orders;

-- now running queries----
-- 1.Retreive all books in the "fiction genre"
SELECT * FROM Books WHERE Genre="Fiction";
-- 2. find books published after the year 1950.
SELECT*FROM Books WHERE Published_Year>1950;

-- 3.List all customers from canada.
SELECT*FROM customers WHERE Country ="canada";
-- 4.Show orders placed in november 2023.
SELECT*FROM orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';
-- 5.Retrieve the total stock of books available.--
SELECT SUM(Stock) AS STOCK_SUM
FROM books;
-- 6.FIND details of most expensive book.
SELECT*FROM Books
ORDER BY  Price DESC LIMIT 1;
-- 7.SHOW all CUStomers who ordered more than 1 quantity of book;
SELECT*FROM orders
WHERE Quantity>1;
-- 8.Retrieve all orders where the total amount exceeds $20.
SELECT*FROM orders
WHERE Total_Amount>20;
-- 9.List all the genre avialable in books;
SELECT DISTINCT Genre FROM Books;
--  10.find the books with lowest stock;
SELECT*FROM Books
ORDER BY Stock ASC LIMIT 1;
-- 11. Calculate the total revenue generated from all order..
SELECT SUM(Total_Amount)AS REVENUE FROM Orders;

-------- ADVANCED QUERIES------.........
-- 1.Retrieve the total number of books sold for each genre.
SELECT b.Genre,SUM(o.Quantity)AS Total_Books_Sold
FROM orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

-- 2. Find the average price of books in the "Fantasy" genre.
SELECT AVG(Price) AS AVERAGE_PRICE
FROM Books
WHERE Genre='Fantasy';
-- 3.List customers who have placed at least 2 orders.
SELECT Customer_id,COUNT(Order_Id)AS ORDER_COUNT
FROM Orders
GROUP BY Customer_id
HAVING COUNT(Order_Id)>=2;

-- 4.Fnd most frequently ordered book--
SELECT Book_Id ,COUNT(Order_Id)AS ORDER_COUNT
FROM Orders 
GROUP BY Book_Id
ORDER BY ORDER_COUNT DESC LIMIT 1;


SELECT O.Book_Id,b.Title ,COUNT(O.Order_Id) AS ORDER_COUNT
FROM Orders O
JOIN Books b ON O.Book_Id = b.Book_ID
GROUP BY O.Book_Id, B.Title
ORDER BY ORDER_COUNT DESC
LIMIT 1;

-- 5. Show the top three most expensive books of 'fantansy' genre--

SELECT*FROM Books
WHERE Genre='Fantasy'
ORDER BY Price DESC LIMIT 3;

-- 6.reterive the total quanitity of books sold by each author;
SELECT b.Author,sum(o.Quantity) AS TOTAL_QUANTITY_SOLD
FROM Orders o
JOIN Books b ON o.Book_Id=b.Book_ID
GROUP BY b.Author;

-- 7.List the cities where  customers who spent over $30 are located;
SELECT distinct c.City,Total_Amount
FROM Orders o
JOIN customers c ON o.customer_id=c.Customer_Id
WHERE o.Total_Amount >30;
-- 8.Find the customer who spent most on orders--
SELECT c.Customer_Id,c.Name, SUM(o.Total_Amount) AS TOTAL_SPENT
FROM Orders o
JOIN customers c ON c.Customer_Id=o.Customer_id
GROUP BY c.Customer_id,c.Name
ORDER BY Total_SPENT DESC LIMIT 1;

-- 9. calculate the stock remaining after fulfilling all order:
SELECT b.Book_ID,b.Stock,b.Title ,COALESCE(SUM(o.Quantity),0) AS ORDER_QUANTITY,
b.Stock-COALESCE(SUM(o.Quantity),0) AS REMAINING_QUANTITY
FROM Books b
LEFT JOIN Orders o ON b.Book_ID=o.Book_Id
GROUP BY b.Book_ID
ORDER BY b.Book_ID;






















