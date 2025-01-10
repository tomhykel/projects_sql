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

SELECT
    p.project_id,
    ROUND(AVG(experience_years), 2) AS average_years
FROM Employee AS e
LEFT JOIN Project AS p ON e.employee_id = p.employee_id
WHERE p.project_id IS NOT NULL
GROUP BY p.project_id;

SELECT
    p.project_id,
    ROUND(AVG(experience_years), 2) AS average_years
FROM Employee AS e
INNER JOIN Project AS p ON e.employee_id = p.employee_id
GROUP BY p.project_id
ORDER BY p.project_id;

WITH total_users AS (
    SELECT COUNT(1)
    FROM Users
)
SELECT
    contest_id,
    ROUND(COUNT(DISTINCT user_id) / (SELECT * FROM total_users) * 100, 2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC;

SELECT
    contest_id,
    ROUND(COUNT(DISTINCT user_id) / (SELECT COUNT(1) FROM Users) * 100, 2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC;

SELECT
    query_name,
    ROUND(AVG(rating / position), 2)
        AS quality,
    ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) / COUNT(1) * 100, 2)
        AS poor_query_percentage
FROM Queries
GROUP BY query_name;

SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;

SELECT
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;

SELECT
    class
FROM Courses
GROUP BY class
HAVING COUNT(class) >= 5;

SELECT
    user_id,
    COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC;

SELECT
    MAX(num) AS num
FROM MyNumbers
WHERE num IN (
    SELECT
        num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
);

SELECT
    MAX(num) AS num
FROM (
    SELECT
        num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
) AS single_numbers;

SELECT
    e1.reports_to        AS employee_id,
    (
    SELECT e2.name
    FROM Employees AS e2
    WHERE e2.employee_id = e1.reports_to
    )                    AS name,
    COUNT(e1.reports_to) AS reports_count,
    ROUND(AVG(e1.age))   AS average_age
FROM Employees AS e1
WHERE 1 = 1
    AND e1.reports_to IS NOT NULL
    AND e1.reports_to > 0
GROUP BY e1.reports_to
ORDER BY e1.reports_to;

SELECT
    employee_id,
    department_id
FROM Employee
WHERE
    primary_flag = 'Y'
    OR employee_id IN (
        SELECT employee_id
        FROM Employee
        GROUP BY employee_id
        HAVING COUNT(primary_flag) = 1
    );

SELECT
    *,
    CASE
        WHEN x + y > z AND y + z > x AND x + z > y THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle;

SELECT
    employee_id
FROM Employees
WHERE 1 = 1
    AND salary < 30000
    AND manager_id NOT IN (
        SELECT employee_id
        FROM Employees
    )
ORDER BY employee_id;

SELECT
    user_id,
    CONCAT(
        UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2, LENGTH(name)))
    ) AS name
FROM Users
ORDER BY user_id;

SELECT
    *
FROM Patients
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%';

DELETE p1
FROM Person AS p1
CROSS JOIN Person AS p2
WHERE 1 = 1
    AND p1.email = p2.email
    AND p1.id > p2.id;

DELETE p1
FROM Person AS p1, Person AS p2
WHERE 1 = 1
    AND p1.email = p2.email
    AND p1.id > p2.id;

WITH first_email AS (
    SELECT MIN(id) AS id
    FROM Person
    GROUP BY email
)
DELETE FROM Person
WHERE id NOT IN (
    SELECT id
    FROM first_email
);

SELECT
    a.name
    FROM Employee AS a
JOIN (
    SELECT
    managerId,
    COUNT(id)
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(id) >=5
    ) AS b
ON a.id = b.managerId;

SELECT
    name
FROM Employee
WHERE id IN (
    SELECT
        managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) >= 5
    );

SELECT
    s.user_id,
    CASE
        WHEN c.user_id IS NULL THEN 0
        ELSE ROUND(SUM(c.action = 'confirmed') / COUNT(c.user_id), 2)
    END AS confirmation_rate
FROM Signups AS s
LEFT JOIN Confirmations AS c
ON s.user_id = c.user_id
GROUP BY s.user_id;

SELECT
    DATE_FORMAT(trans_date, "%Y-%m") AS month,
    country,
    COUNT(1) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END ) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, "%Y-%m"), country;

SELECT
    ROUND(AVG(order_date = customer_pref_delivery_date) * 100, 2) AS immediate_percentage
FROM DELIVERY
WHERE (customer_id, order_date) IN (
    SELECT
    customer_id,
    MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
);
