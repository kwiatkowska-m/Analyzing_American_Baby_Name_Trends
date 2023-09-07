CREATE TABLE usa_baby_names(year INT,first_name VARCHAR, sex VARCHAR, num INT)
SELECT* FROM usa_baby_names

/*
Select first names and the total babies with that first_name and
filter for those names that appear in all 101 years
*/

SELECT first_name, SUM(num)
FROM usa_baby_names
GROUP BY first_name
HAVING COUNT(year) = 101
ORDER BY SUM(num) DESC;

/*
Classify first names as 'Classic', 'Semi-classic', 'Semi-trendy', or 'Trendy'.
Select first_name, the sum of babies who have ever had that name, and popularity_type.
*/

SELECT first_name, SUM(num),
    CASE WHEN COUNT(year) > 80 THEN 'Classic'
        WHEN COUNT(year) > 50 THEN 'Semi-classic'
        WHEN COUNT(year) > 20 THEN 'Semi-trendy'
        ELSE 'Trendy' END AS popularity_type
FROM usa_baby_names
GROUP BY first_name
ORDER BY popularity_type;

/* RANK female names by the sum of babies who have ever had that name,
Limit to ten results*/

SELECT
    RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
    first_name, SUM(num)
FROM usa_baby_names
WHERE sex = 'F'
GROUP BY first_name
LIMIT 10;


--Filter for results where sex is 'F', year is greater than 2015, and first_name ends in 'a'

SELECT first_name
FROM usa_baby_names
WHERE sex = 'F' AND year > 2015
    AND first_name LIKE '%a'
GROUP BY first_name
ORDER BY SUM(num) DESC;

--Sum the cumulative babies who have been named Olivia up to that year

SELECT year, first_name, num,
    SUM(num) OVER (ORDER BY year) AS cumulative_olivias
FROM usa_baby_names
WHERE first_name = 'Olivia'
ORDER BY year;

--What that top male name is for each year in our dataset.

WITH subquery AS(
    SELECT year, MAX(num) as max_num
    FROM usa_baby_names
    WHERE sex = 'M'
    GROUP BY year)

SELECT b.year, b.first_name, b.num
FROM usa_baby_names AS b
INNER JOIN subquery 
ON subquery.year = b.year 
    AND subquery.max_num = b.num
ORDER BY b.year DESC;

-- Select first_name and a count of years it was the top name in the last task

WITH top_male_names AS (
    SELECT b.year, b.first_name, b.num
    FROM usa_baby_names AS b
    INNER JOIN (
        SELECT year, MAX(num) num
        FROM usa_baby_names
        WHERE sex = 'M'
        GROUP BY year) AS subquery 
    ON subquery.year = b.year 
        AND subquery.num = b.num
    ORDER BY b.year DESC
    )
SELECT first_name, COUNT(first_name) as count_top_name
FROM top_male_names
GROUP BY first_name
ORDER BY COUNT(first_name) DESC;