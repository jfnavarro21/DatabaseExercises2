
# select database
USE classicmodels;

################### Subquery ###################
# query that is nested inside another query such as SELECT, INSERT, UPDATE or DELETE. 

# what is the maximum payment
SELECT MAX(amount) FROM payments;

# customer who made the maximum payment
SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount = (SELECT 
            MAX(amount)
        FROM
            payments);

# all payments greater than average payment
# the outer query filters payments that are greater than the average payment returned by the subquery
SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount > (SELECT 
            AVG(amount)
        FROM
            payments);   
            
# customers who have ordered atleast 1 product (IN operator) 
SELECT 
    customerName,
	contactFirstName,
    contactLastName,
    phone
FROM
    customers
WHERE
    customerNumber IN (SELECT 
            customerNumber
        FROM
            orders);

# customers who have not ordered any products (NOT IN operator)
SELECT 
    customerName,
	contactFirstName,
    contactLastName,
    phone
FROM
    customers
WHERE
    customerNumber NOT IN (SELECT
            customernumber
        FROM
            orders);

################### Subquery with EXIST ###################

# EXISTS or NOT EXISTS operator - returns a Boolean value of TRUE or FALSE. 
# customers who have ordered atleast 1 product (EXISTS) 
SELECT 
    customerName,
	contactFirstName,
    contactLastName,
    phone
FROM
    customers
WHERE
    EXISTS( SELECT 
            *
        FROM
            orders
        WHERE
            customers.customerNumber = orders.customerNumber);

# customers who have not ordered any products (NOT EXISTS)
SELECT 
    customerName,
	contactFirstName,
    contactLastName,
    phone
FROM
    customers
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            orders
        WHERE
            customers.customerNumber = orders.customerNumber);

# customers who have placed at least one order greater than 10K
SELECT 
    customerName, 
    contactFirstName, 
    contactLastName, 
    phone
FROM
    customers
WHERE
    EXISTS( SELECT 
            *
        FROM
            orderdetails
                INNER JOIN
            orders
        WHERE
            customers.customerNumber = orders.customerNumber
                AND orderdetails.orderNumber = orders.orderNumber
                AND priceEach * quantityOrdered > 10000);

################ Subquery in FROM clause ###############

# maximum, minimum and average number of items in sale orders
SELECT 
    MAX(items) AS maxItems, 
    MIN(items) AS minItems, 
    AVG(items) AS avgItems
FROM
    (SELECT 
        orderNumber, COUNT(orderNumber) AS items
    FROM
        orderdetails
    GROUP BY orderNumber) AS lineitems;

# list all products whose buy price is greater than all the Harley products - ALL
SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice > ALL (SELECT 
            buyPrice
        FROM
            products
        WHERE
            productName LIKE '%Harley%'); 
   
# average buy price of a product whose buy price is greater than all the Harley products - ALL
SELECT 
    AVG(buyPrice) AS avgBuyPrice
FROM
    products
WHERE
    buyPrice > ALL (SELECT 
            buyPrice
        FROM
            products
        WHERE
            productName LIKE '%Harley%'); 
  
# list all products whose buy price is greater than any of the Harley products - ANY 
SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice > ANY (SELECT 
            buyPrice
        FROM
            products
        WHERE
            productName LIKE '%Harley%');   

# products whose buy prices are greater than the average buy price of products within their product line
SELECT 
    productName, productLine, buyPrice
FROM
    products AS p
WHERE
    buyPrice > (SELECT 
            AVG(buyPrice)
        FROM
            products
        WHERE
            productline = p.productline);
            
################ Subquery in SELECT clause ###############
#Used when you wish to compute an aggregate value, but you do not want the aggregate function to apply to the main query.

SELECT 
    productName,
    buyPrice,
    (SELECT 
            MAX(buyPrice)
        FROM
            products
        WHERE
            productline = p.productline) maxBuyPriceInLine,
     (SELECT 
            AVG(buyPrice)
        FROM
            products
        WHERE
            productline = p.productline) avgBuyPriceInLine,
     (SELECT 
            MIN(buyPrice)
        FROM
            products
        WHERE
            productline = p.productline) minBuyPriceInLine                       
FROM
    products p;