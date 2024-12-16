-- LeetCode SQL problems (my solutions)

SELECT 
   product_id
FROM Products
WHERE 1 = 1
   AND low_fats = 'Y'
   AND recyclable = 'Y';

SELECT name
FROM Customer
WHERE referee_id != 2
   OR referee_id IS NULL;

SELECT
   name,
   area,
   population
FROM World
WHERE area >= 3000000
   OR population >= 25000000;

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY author_id ASC;

SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;

SELECT
    EmployeeUNI.unique_id,
    Employees.name
FROM Employees
LEFT JOIN EmployeeUNI ON Employees.id = EmployeeUNI.id;

SELECT
    Product.product_name,
    Sales.year,
    Sales.price
FROM Sales
JOIN Product ON Sales.product_id = Product.product_id;

SELECT
    Visits.customer_id,
    COUNT(1) AS count_no_trans
FROM Visits
LEFT JOIN Transactions ON Visits.visit_id = Transactions.visit_id
WHERE transaction_id is NULL
GROUP BY Visits.customer_id;

SELECT
    a.id
FROM weather as a
INNER JOIN weather AS b ON a.recordDate = DATE_ADD(b.recordDate, INTERVAL 1 DAY)
WHERE a.temperature > b.temperature;

SELECT
    a.machine_id,
    ROUND(AVG(b.timestamp - a.timestamp), 3) AS processing_time
FROM Activity AS a 
INNER JOIN Activity AS b 
    ON a.process_id = b.process_id
    AND a.machine_id = b.machine_id
    AND a.activity_type = 'start' and b.activity_type = 'end'
GROUP BY a.machine_id;

SELECT
    e.name,
    b.bonus
FROM Employee AS e
LEFT JOIN Bonus AS b ON e.empId = b.empId
WHERE b.bonus < 1000
    OR b.bonus IS NULL;

SELECT
    st.student_id,
    st.student_name,
    sb.subject_name,
    COUNT(ex.student_id) AS attended_exams 
FROM Students as st
CROSS JOIN Subjects as sb
LEFT JOIN Examinations as ex 
    ON st.student_id = ex.student_id
    AND sb.subject_name = ex.subject_name
GROUP BY st.student_id, st.student_name, sb.subject_name
ORDER BY st.student_id, sb.subject_name;

SELECT *
FROM Cinema
WHERE 1 = 1
    AND id % 2 != 0
    AND description != 'boring'
ORDER BY rating DESC;

SELECT
    pr.product_id,
    CASE 
        WHEN SUM(us.units) > 0 THEN ROUND(SUM(us.units * pr.price ) / SUM(us.units), 2)
        ELSE 0
    END AS average_price
FROM Prices AS pr
LEFT JOIN UnitsSold AS us 
        ON pr.product_id = us.product_id
        AND us.purchase_date BETWEEN pr.start_date AND pr.end_date
GROUP BY pr.product_id
ORDER BY pr.product_id;