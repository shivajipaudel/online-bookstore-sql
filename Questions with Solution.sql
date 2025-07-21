-- Switch to the database
use OnlineBookstore; 

-- 1) Retrieve all books in the "Fiction" genre:
SELECT 
    *
FROM
    Books
WHERE
    Genre = 'Fiction';


-- 2) Find books published after the year 1950:
SELECT 
    *
FROM
    Books
WHERE
    Published_Year > 1950;

-- 3) List all customers from the Canada:
SELECT 
    *
FROM
    customers
WHERE
    Country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT 
    *
FROM
    orders
WHERE
    YEAR(Order_Date) = 2023
        AND MONTH(Order_Date) = 11;

-- 5) Retrieve the total stock of books available:
SELECT 
    SUM(Stock) AS total_stock_books
FROM
    books;

-- 6) Find the details of the most expensive book:
SELECT 
    *
FROM
    books
WHERE
    price = (SELECT 
            MAX(Price)
        FROM
            books);


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT 
    *
FROM
    customers
        JOIN
    orders ON customers.Customer_ID = orders.Customer_ID
WHERE
    orders.Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds(means greater than $20) $20:
SELECT 
    *
FROM
    orders
WHERE
    Total_Amount > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT
    Genre
FROM
    books;

-- 10) Find the book with the lowest stock:
SELECT 
    *
FROM
    books
WHERE
    Stock = (SELECT 
            MIN(Stock)
        FROM
            books);

-- 11) Calculate the total revenue generated from all orders:
SELECT 
    SUM(b.Price * o.Quantity) AS Total_Revenue
FROM
    orders o
        JOIN
    books b ON o.Book_ID = b.Book_ID;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT 
    b.Genre, SUM(o.Quantity) AS total_sold_books
FROM
    books b
        JOIN
    orders o ON b.Book_ID = o.Book_ID
GROUP BY Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT 
    AVG(Price) AS avg_fantasy_price
FROM
    books
WHERE
    genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:
SELECT 
    c.Customer_ID, c.name AS Name, COUNT(*) AS total_orders
FROM
    Customers c
        JOIN
    orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.name , c.Customer_ID
HAVING total_orders >= 2;


-- 4) Find the most frequently ordered book:
SELECT 
    b.Book_ID, b.Title, SUM(o.Quantity) AS most_ordered_book
FROM
    books b
        JOIN
    orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title , b.Book_ID
ORDER BY most_ordered_book DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
with cte as(select *, 
dense_rank() over (order by price desc) as dr
from books
where Genre = 'Fantasy')
select Book_ID,Title,Author,Genre,Published_Year,Price,Stock 
from cte
where dr<=3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT 
    b.Author, SUM(o.Quantity) AS total_books_Quanties
FROM
    books b
        JOIN
    orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Author;

-- 7) List the cities where customers who spent over $30 are located:
SELECT 
    c.city
FROM
    customers c
        JOIN
    orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID , c.city
HAVING SUM(o.Total_Amount) > 30;


-- 8) Find the customer who spent the most on orders:
SELECT 
    c.Customer_ID, c.name, SUM(o.Total_Amount) AS max_order
FROM
    Customers c
        JOIN
    orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID , c.name
ORDER BY max_order DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders: 
SELECT 
    b.Book_ID,
    b.Title,
    b.Stock - IFNULL(SUM(o.Quantity), 0) AS remaining_stock
FROM
    books b
        LEFT JOIN
    orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID , b.Title , b.Stock;
