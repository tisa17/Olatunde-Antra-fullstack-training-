--1
SELECT DISTINCT CITY
FROM CUSTOMERS
WHERE CITY IN (SELECT CITY FROM EMPLOYEES)

--2A

SELECT DISTINCT CITY
FROM CUSTOMERS 
WHERE CITY NOT IN (SELECT CITY FROM EMPLOYEES)

--2B
SELECT DISTINCT C.CITY 
FROM CUSTOMERS C, EMPLOYEES E 
WHERE C.CITY <> E.CITY;

--3
SELECT P.PRODUCTNAME , SUM(OD.QUANTITY) [TOTAL ORDER QUANTITIES]
FROM PRODUCTS P INNER JOIN [ORDER DETAILS] OD
ON OD.PRODUCTID = P.PRODUCTID 
GROUP BY P.PRODUCTNAME

--4
SELECT  B.CITY , SUM(P.PRODUCTID) [TOTAL PRODUCTS]
FROM PRODUCTS P INNER JOIN [ORDER DETAILS] OD
ON OD.PRODUCTID = P.PRODUCTID INNER JOIN ORDERS A 
ON A.ORDERID = OD.ORDERID INNER JOIN CUSTOMERS B
ON B.CUSTOMERID = A.CUSTOMERID
GROUP BY B.CITY;


--5A
SELECT CITY 
FROM CUSTOMERS 
GROUP BY CITY 
HAVING COUNT(CUSTOMERID) = 2
UNION
SELECT CITY 
FROM CUSTOMERS 
GROUP BY CITY
HAVING COUNT(CUSTOMERID) > 2;
--5B.
SELECT CITY 
FROM CUSTOMERS 
WHERE CITY IN (SELECT CITY
FROM CUSTOMERS 
GROUP BY CITY
HAVING COUNT(CUSTOMERID) >= 2);

--6
SELECT C..CITY , COUNT(DISTINCT P.PRODUCTID) [TOTAL PRODUCTS]
FROM PRODUCTS P INNER JOIN [ORDER DETAILS] OD
ON OD.PRODUCTID = P.PRODUCTID INNER JOIN ORDERS A 
ON A.ORDERID = OD.ORDERID INNER JOIN CUSTOMERS C 
ON C.CUSTOMERID = A.CUSTOMERID 
GROUP BY C.CITY 
HAVING COUNT(DISTINCT P.PRODUCTID) >= 2

--7
SELECT DISTINCT C.COMPANYNAME,C.CUSTOMERID ,C.CITY ,O.SHIPCITY
FROM ORDERS O
INNER JOIN CUSTOMERS C  ON C.CUSTOMERID = O.CUSTOMERID 
WHERE C.CITY <> O.SHIPCITY

--8
SELECT TOP 5  P.PRODUCTNAME, AVG(P.UNITPRICE) [AVERAGE PRICE], C.CITY 
FROM PRODUCTS P INNER JOIN [ORDER DETAILS] OD ON OD.PRODUCTID = P.PRODUCTID 
INNER JOIN ORDERS O ON O.ORDERID = OD.ORDERID
INNER JOIN CUSTOMERS C  ON C.CUSTOMERID = O.CUSTOMERID 
GROUP BY P.PRODUCTNAME, C.CITY 
ORDER BY SUM(OD.QUANTITY) DESC 

--9A
SELECT CITY
FROM CUSTOMERS
WHERE CITY  IN (SELECT CITY  
FROM CUSTOMERS c 
LEFT JOIN ORDERS o ON c.CUSTOMERID =o.CUSTOMERID 
AND
o.EMPLOYEEID IN (SELECT EMPLOYEEID 
FROM ORDERS)
GROUP BY c.CITY 
HAVING COUNT(ORDERID) = 0) 
--9B

SELECT c.CITY , COUNT(ORDERID) 
FROM CUSTOMERS c 
LEFT JOIN ORDERS o ON c.CUSTOMERID  = o.CUSTOMERID 
LEFT JOIN EMPLOYEES e ON e.EMPLOYEEID = o.EMPLOYEEID 
GROUP BY c.CITY 
HAVING COUNT(ORDERID) =0 

--10
SELECT DISTINCT  c1.CITY
FROM ORDERS o INNER JOIN CUSTOMERS c1 ON o.CUSTOMERID = c1.CUSTOMERID
WHERE c1.CITY IN (SELECT TOP 1 c2.CITY 
FROM PRODUCTS p 
INNER JOIN [ORDER DETAILS] od ON od.PRODUCTID = p.PRODUCTID 
INNER JOIN ORDERS o ON o.ORDERID = od.ORDERID
INNER JOIN CUSTOMERS c2  ON c2.CUSTOMERID = o.CUSTOMERID 
GROUP BY c2.CITY 
ORDER BY COUNT(o.ORDERID) DESC)
AND 
c1.CITY IN (SELECT TOP 1 D.CITY  FROM 
PRODUCTS B INNER JOIN [ORDER DETAILS] od ON od.PRODUCTID = B.PRODUCTID 
INNER JOIN DBO.ORDERS C ON C.ORDERID = od.ORDERID
INNER JOIN DBO.CUSTOMERS D  ON D.CUSTOMERID = C.CUSTOMERID 
GROUP BY D.CITY 
ORDER BY COUNT(od.PRODUCTID) DESC)

--11 USE THE GROUP BY TO FIND DUPLICATES , THEN USE THE DELETE STATEMENTS 
