use parks_and_recreation;



-- SELECT STATEMENT (used to retrieve data)

SELECT * FROM parks_and_recreation.employee_demographics;

SELECT * FROM employee_salary;

SELECT first_name, last_name, age
FROM employee_demographics;



-- DISTINCT (returns only unique (non-duplicate) values)

SELECT DISTINCT first_name
FROM employee_demographics;

SELECT DISTINCT gender
FROM employee_demographics;



-- WHERE CLAUSE (USE OPERATORS) (used to filter records and return only those that meet a specific condition)

SELECT first_name, last_name
FROM employee_demographics
WHERE age > 40;

SELECT first_name, last_name, salary
FROM employee_salary
WHERE salary <= 50000;

SELECT first_name, last_name, age, gender
FROM employee_demographics
WHERE gender = "Female";

SELECT first_name, last_name, gender
FROM employee_demographics
WHERE gender != "Female";



-- GROUP BY AND ORDER BY
-- GROUP BY (used to group rows that have the same values in specified columns, often used with aggregate functions like COUNT(), SUM(), AVG())
-- ORDER BY (used to sort the result set by one or more columns, in ascending (ASC) or descending (DESC) order.)

SELECT first_name, last_name, salary, avg(salary)
FROM employee_salary
GROUP BY first_name, last_name, salary;

SELECT gender, AVG(age), MIN(age), MAX(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT first_name, last_name, age
FROM employee_demographics
ORDER BY age ASC;

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
ORDER BY gender;

SELECT AVG(age)
FROM employee_demographics;



-- HAVING Vs WHERE
-- HAVING IS USED TO DETERMINE AGGREGATE FUNCTIONS USED IN GROUP BY CLAUSE
-- WHERE USED FOR SIMPLE COLUMNS DETERMINATION

SELECT AVG(salary)
FROM employee_salary;

SELECT first_name, last_name, salary, MAX(salary),
(SELECT AVG(salary) FROM employee_salary) AS avg_sal
FROM employee_salary
GROUP BY first_name, last_name, salary
HAVING AVG(salary) > 50000;

SELECT first_name, last_name, salary, AVG(salary)
FROM employee_salary
WHERE first_name LIKE '%n%'
GROUP BY first_name, last_name, salary
HAVING AVG(salary) > 50000
ORDER BY first_name ASC;



-- LIMIT AND ALIASING
-- LIMIT (used to restrict the number of rows returned by a query)
-- ALIASING (Aliasing gives a temporary name to a column or table to make results easier to read)

SELECT first_name, last_name
FROM employee_demographics
ORDER BY first_name ASC
LIMIT 5;

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender;



-- JOINS (Joins two or more tables)

-- INNER JOIN (gives common columns in output)

SELECT * 
FROM employee_demographics AS dep
INNER JOIN employee_salary AS sal
	ON dep.employee_id = sal.employee_id;
    
SELECT dep.first_name, dep.last_name, gender, age, salary
FROM employee_demographics AS dep
JOIN employee_salary AS sal
	ON dep.employee_id = sal.employee_id;
    
-- OUTER JOIN (LEFT JOIN, RIGHT JOIN)
-- LEFT JOIN (OUTPUTS ALL THE ROW PRESENT FROM LEFT TABLE BUT MATCHING ROWS IN RIGHT TABLE)

SELECT *
FROM employee_demographics dem
LEFT OUTER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
	
-- LEFT JOIN (OUTPUTS ALL THE ROW PRESENT FROM RIGHT TABLE BUT MATCHING ROWS IN LEFT TABLE)

SELECT dem.first_name, dem.last_name, gender, age, salary, occupation
FROM employee_demographics dem
RIGHT JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
-- SELF JOIN (JOINS ITS OWN TABLE)

SELECT *
FROM employee_demographics dem1
JOIN employee_demographics dem2
	ON dem1.employee_id = dem2.employee_id;
    
SELECT sal1.employee_id santas_id, sal1.first_name santas_first_name, sal1.last_name santas_last_name,
sal2.employee_id, sal2.first_name, sal2.last_name
FROM employee_salary sal1
JOIN employee_salary sal2
	ON sal1.employee_id + 1 = sal2.employee_id;

-- MULTIPLE JOIN (JOIN MULTIPLE TABLES)

SELECT * 
FROM employee_demographics AS dep
JOIN employee_salary AS sal
	ON dep.employee_id = sal.employee_id
JOIN parks_departments AS parks
	ON sal.dept_id = parks.department_id;



-- STRING FUNCTIONS (used to manipulate and process text (string) data in SQL)
-- LENGTH, UPPPER, LOWER, TRIM, LTRIM, RTRIM, LEFT, RIGHT, SUBSTRING, REPLACE, LOCATE, CONCAT, CONCAT_WS(Concatination with separator)

SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;

SELECT LENGTH('Manisha');
SELECT first_name, LENGTH(first_name)
FROM employee_demographics;

SELECT UPPER('sky Fall');
SELECT LOWER('SKY fALL');
SELECT first_name, UPPER(first_name), LOWER(first_name)
FROM employee_demographics;

SELECT TRIM('     skyfall          ') TRIMED,
LTRIM('     skyfall          ') LTRIMED,
RTRIM('     skyfall          ') RTRIMED;

SELECT first_name, 
LEFT(first_name, 4) left_name,
RIGHT(first_name, 4) right_name,
birth_date,
SUBSTRING(birth_date, 6,2) month_name
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

SELECT LOCATE('a', 'manisha');
SELECT first_name, LOCATE('An', first_name)
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) full_name
FROM employee_demographics;



-- CASE STATEMENTS (allows you to add conditional logic to your SQL queries)

SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;

SELECT first_name, last_name, age,
CASE
	WHEN age <= 30 THEN 'YOUNG'
    WHEN age BETWEEN 30 AND 50 THEN 'OLD'
    WHEN age > 50 THEN 'ON DEATHS DOOR'
END age_group
FROM employee_demographics;

SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
END New_salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.10
END Bonus
FROM employee_salary;



-- SUBQUERIES (query inside another query)

SELECT *
FROM employee_demographics
WHERE employee_id IN (SELECT employee_id 
					  FROM employee_salary
                      WHERE dept_id = 1);

SELECT AVG(max_age) FROM 
(SELECT gender, AVG(age) AS avg_age, MAX(age) AS max_age, MIN(age) AS min_age, COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender) AS sub;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age) 
FROM employee_demographics
GROUP BY gender;



-- WINDOW FUNCTIONS (analyze data row-by-row) 
-- ROW_NUMBER (Assigns the number in sequence)
-- RANK (Assigns Rank Positionally)
-- DENSE_RANK (Asssigns Rank Numerically)

SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;

SELECT gender, AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

SELECT gender, AVG(salary)
OVER() avg_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

SELECT gender, AVG(salary)
OVER(PARTITION BY gender) avg_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, salary, gender, AVG(salary)
OVER(PARTITION BY gender) avg_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, gender, salary, SUM(salary)
OVER(PARTITION BY gender ORDER BY dem.employee_id) Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;    
    
SELECT dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;   
  
SELECT dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;  
    
SELECT dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;     



-- CTEs(COMMON TABLE EXPRESSIONS) (temporary result set you define with a name using the WITH keyword)

SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;


WITH CTE_Example AS (
SELECT gender,  AVG(salary) avg_sal, Max(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example ;

WITH CTE_Example AS (
SELECT gender,  AVG(salary) avg_sal, Max(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example ;

WITH CTE_Example1 AS(
SELECT employee_id, first_name, last_name, birth_date
FROM employee_demographics
WHERE birth_date > '1980-01-01'
), CTE_Example2 AS (
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example1 dem
JOIN CTE_Example2 sal
	ON dem.employee_id = sal.employee_id;