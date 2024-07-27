USE DB84;

--1
SELECT * FROM customer;
--π Κωδικος_Πελάτη, ΑΦΜ, Επωνυμία, Διεύθυνση, Τηλέφωνο (Πελάτης)

--2
SELECT custcode, amount
FROM payment
WHERE paydate BETWEEN '2022-05-12' AND '2022-05-22';
--π Κωδικό_Πελάτη(σ Ημερομηνία ≥ 12/5/2022 AND Ημερομηνία ≤ 22/5/2022 (Πληρωμές)

--3
SELECT ordcode, orderDate, prcode
FROM orders;
--π Ημερομηνία_Παραγγελίας, Κωδικός_Αναφοράς, Κωδικός_Προϊόντος(σ(Παραγγελία))

--4
SELECT price * (1.3)
FROM product;
--π τιμη*(1.3)(Προϊόν)

--5
SELECT SUM(amount) AS Total, AVG(amount) AS Average
FROM payment
WHERE YEAR(paydate) = 2022
GROUP BY MONTH(paydate);

--6
SELECT customer.SSN, customer.brand
FROM customer, orders, product, quantity
WHERE YEAR(orders.orderDate) = 2023
AND orders.orderDate BETWEEN '2023-01-01' AND '2023-01-31'
AND customer.custcode = orders.custcode
AND orders.prcode = product.prcode
AND product.prcode = quantity.prcode
AND (quantity.quantity * product.price) >= 2500;

--7
SELECT SUM(product.price * quantity.quantity)
FROM orders, quantity, product, category
WHERE orders.prcode = product.prcode AND  product.catcode = category.catcode AND
orders.prcode = quantity.prcode
GROUP BY category.catcode;

--8
SELECT AVG(product.price * quantity.quantity) AS Average, geoArea.name, category.title
FROM orders
JOIN quantity ON orders.prcode = quantity.prcode
JOIN product ON orders.prcode = product.prcode
JOIN category ON product.catcode = category.catcode
JOIN customer ON orders.custcode = customer.custcode
JOIN geoArea ON customer.geocode = geoArea.geocode
GROUP BY geoArea.name, category.title;

--9
WITH totalSales AS (
	SELECT COUNT(orders.ordcode) as yearlySales
	FROM orders
	WHERE YEAR(orders.orderDate) = 2022
),
monthlySales AS (
	SELECT MONTH(orders.orderDate) as month, COUNT(orders.ordcode) as monthlySales
	FROM orders
	WHERE YEAR(orders.orderDate) = 2022
	GROUP BY MONTH(orders.orderDate)
)
SELECT monthlySales.month, (monthlySales / yearlySales) * 100 AS percentage
FROM monthlySales, totalSales;

--10
SELECT MONTH(orderDate) as Month, COUNT(DISTINCT custcode) as Customers
FROM orders 
JOIN product ON orders.prcode = product.prcode
WHERE price > (SELECT AVG(price) FROM product WHERE MONTH(orderDate) = MONTH(orderDate))
GROUP BY MONTH(orderDate);

--11
SELECT MONTH(orders.orderDate) as Month, 
	(SUM(product.price * quantity.quantity) / (SELECT SUM(p.price * q.quantity) FROM orders o JOIN product p ON o.prcode = p.prcode JOIN quantity q ON o.ordcode = q.ordcode WHERE YEAR(o.orderDate) = 2021 AND MONTH(o.orderDate) = MONTH(o.orderDate)) - 1) * 100 as SalesIncreasePercentage
FROM orders
JOIN product ON orders.prcode = product.prcode
JOIN quantity ON orders.ordcode = quantity.ordcode
WHERE YEAR(orders.orderDate) = 2022
GROUP BY MONTH(orders.orderDate);

--12
WITH Sales AS (
	SELECT MONTH(orders.orderDate) as Month, AVG(product.price * quantity.quantity) as AvgSales
    FROM orders
    JOIN product ON orders.prcode = product.prcode
    JOIN quantity ON orders.ordcode = quantity.ordcode
    WHERE YEAR(orders.orderDate) = 2022
    GROUP BY MONTH(orders.orderDate))
SELECT s1.Month, s1.AvgSales as AvgSalesThisMonth, (SELECT AVG(s2.AvgSales) FROM Sales s2 WHERE s2.Month < s1.Month) as AvgSalesPreviousMonths
FROM Sales s1;

--13
SELECT product.prcode
FROM product
JOIN purchase ON product.prcode = purchase.prcode
JOIN supplier ON purchase.supcode = supplier.supcode
GROUP BY product.prcode
HAVING COUNT(DISTINCT supplier.geocode) = 1;

--14
SELECT orders.ordcode
FROM orders
JOIN product ON orders.prcode = product.prcode
WHERE (
	SELECT COUNT(DISTINCT supplier.supcode)
	FROM supplier
	JOIN purchase ON supplier.supcode = purchase.supcode
	WHERE purchase.prcode = product.prcode
) >= 5;
