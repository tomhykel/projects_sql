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

SELECT
    -- *
    ROUND(COUNT(1) / (SELECT COUNT(DISTINCT player_id ) FROM Activity), 2) AS fraction
FROM Activity
WHERE (player_id, DATE_SUB(event_date, INTERVAL 1 DAY)) IN (
    SELECT
        player_id,
        MIN(event_date)
    FROM Activity
    GROUP BY player_id
);

SELECT
    product_id,
    year AS first_year,
    quantity,
    price
FROM Sales
WHERE (product_id, year) IN (
    SELECT
        product_id,
        MIN(year)
    FROM Sales
    GROUP BY product_id
);

SELECT
    customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT(product_key)) = (
    SELECT
        COUNT(DISTINCT product_key)
    FROM Product
);

SELECT
    customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT(product_key)) = (
    SELECT
        COUNT(DISTINCT product_key)
    FROM Product
);

SELECT
    DISTINCT t1.num AS ConsecutiveNums
FROM Logs AS t1
INNER JOIN Logs AS t2 ON t1.id = t2.id + 1
INNER JOIN Logs AS t3 ON t2.id = t3.id + 1
WHERE 1 = 1
    AND t1.num = t2.num
    AND t2.num = t3.num;

SELECT
    product_id,
    new_price as price
FROM Products
WHERE (product_id, change_date) IN (
    SELECT
        product_id,
        MAX(change_date)
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
)
UNION
SELECT
    product_id,
    10 AS price
FROM Products
WHERE (product_id, change_date) IN (
    SELECT
        product_id,
        MIN(change_date)
    FROM Products
    GROUP BY product_id
    HAVING MIN(change_date) > '2019-08-16'
);

WITH max_id AS (
    SELECT MAX(id)
    FROM SEAT
)
SELECT
    CASE
        WHEN id % 2  = 0 THEN id - 1
        WHEN id = (SELECT * FROM max_id) AND id % 2 != 0 then id
        WHEN id % 2 != 0 THEN id + 1
    END AS id,
    student
FROM Seat
ORDER BY id ASC;

SELECT
    CASE
        WHEN id % 2  = 0 THEN id - 1
        WHEN id = (SELECT MAX(id) FROM Seat) AND id % 2 != 0 then id
        WHEN id % 2 != 0 THEN id + 1
    END AS id,
    student
FROM Seat
ORDER BY id ASC;

WITH cde_all_ids AS (
    SELECT
        requester_id AS id
    FROM RequestAccepted
    UNION ALL
    SELECT
        accepter_id AS id
    FROM RequestAccepted
)
SELECT
    id,
    COUNT(id) AS num
FROM cde_all_ids
GROUP BY id
ORDER BY num DESC
LIMIT 1;

SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product ASC) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date ASC;

SELECT
    p.product_name,
    SUM(o.unit) AS unit
FROM Orders AS o
INNER JOIN Products AS p ON o.product_id = p.product_id
WHERE YEAR(o.order_date) = 2020 AND MONTH(o.order_date) = 02
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

SELECT
    *
FROM Users
WHERE mail REGEXP '^[A-Za-z][a-zA-Z0-9_.-]*@leetcode[.]com$';

SELECT
    MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (
    SELECT
        MAX(salary)
    FROM Employee
);

WITH cte_total_weight AS (
SELECT
    person_name,
    weight,
    turn,
    SUM(weight) OVER(ORDER BY turn) AS total_weight
FROM Queue
)
SELECT
    person_name
FROM cte_total_weight
WHERE total_weight <= 1000
ORDER BY total_weight DESC
LIMIT 1;

WITH
cte_low AS (
    SELECT *
    FROM Accounts
    WHERE income < 20000
),
cte_average AS (
    SELECT *
    FROM Accounts
    WHERE income >= 20000 AND income <= 50000
),
cte_high AS (
    SELECT *
    FROM Accounts
    WHERE income > 50000
)
SELECT
    'Low Salary' AS category,
    COUNT(1) AS accounts_count
FROM cte_low
UNION
SELECT
    'Average Salary' AS category,
    COUNT(1) AS accounts_count
FROM cte_average
UNION
SELECT
    'High Salary' AS category,
    COUNT(1) AS accounts_count
FROM cte_high;

    SELECT
        'Low Salary' AS category,
        COUNT(1) AS accounts_count
    FROM Accounts
    WHERE income < 20000
UNION
    SELECT
        'Average Salary' AS category,
        COUNT(1) AS accounts_count
    FROM Accounts
    WHERE income >= 20000 AND income <= 50000
UNION
    SELECT
        'High Salary' AS category,
        COUNT(1) AS accounts_count
    FROM Accounts
    WHERE income > 50000;

    (SELECT
        u.name AS results
    FROM MovieRating AS r
    INNER JOIN Users AS u ON r.user_id = u.user_id
    GROUP BY r.user_id
    ORDER BY COUNT(r.rating) DESC, u.name ASC
    LIMIT 1)
UNION ALL
    (SELECT
        m.title AS results
    FROM MovieRating AS r
    INNER JOIN Movies AS m ON r.movie_id = m.movie_id
    WHERE YEAR(r.created_at) = 2020 AND MONTH(r.created_at) = 2
    GROUP BY m.title
    ORDER BY AVG(r.rating) DESC, m.title ASC
    LIMIT 1);

WITH cte_daily_amount AS (
    SELECT
        visited_on,
        SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
)
SELECT
    visited_on,
    SUM(daily_amount)
        OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
    ROUND(AVG(daily_amount)
        OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount
FROM cte_daily_amount
LIMIT 99999
OFFSET 6;

SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE
    1 = 1
    AND tiv_2015 IN (
        SELECT tiv_2015
        FROM Insurance
        GROUP BY tiv_2015
        HAVING COUNT(1) > 1
    )
    AND (lat, lon) IN (
        SELECT lat, lon
        FROM Insurance
        GROUP BY lat, lon
        HAVING COUNT(*) = 1
    );

WITH cte_top_salaries AS (
    SELECT
        e.name AS Employee,
        e.salary AS Salary,
        d.name AS Department,
        DENSE_RANK() OVER(PARTITION BY d.id ORDER BY salary DESC) AS top_salary
    FROM Employee AS e
    INNER JOIN Department AS d ON e.departmentId = d.id
)
SELECT
    Department,
    Employee,
    Salary
FROM cte_top_salaries
WHERE top_salary < 4;
