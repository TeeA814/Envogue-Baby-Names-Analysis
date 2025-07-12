-- answering business questions
-- what type of popularity does each name in the dataset has?

SELECT name, SUM(births),
CASE WHEN COUNT(year) > 100 THEN 'Classic'
WHEN COUNT(year) > 80 THEN 'semi-classic'
WHEN COUNT(year) > 50 THEN 'semi-trendy'
ELSE 'Trendy' END AS popularity_type
FROM names 
GROUP BY name
ORDER BY name;

-- identifying top ranked name by gender
SELECT name, SUM(births),
RANK () OVER(ORDER BY SUM(births) DESC) as name_rank
FROM names
WHERE gender = 'F'
GROUP BY name
LIMIT 10;

-- identifying instances of multiple males sharing the same names
--first, we check for the year and maximum number of babies given male names
SELECT year, MAX(births) as max_num
FROM names
WHERE gender = 'M'
GROUP BY year;

-- then we identify the top male names over the years
SELECT n.year, n.name, n.births
FROM names as n
INNER JOIN (
SELECT year, MAX(births) as max_num
FROM names
WHERE gender = 'M'
GROUP BY YEAR) as subquery
ON subquery.year = n.year
AND subquery.max_num = n.births
ORDER BY year DESC;

-- most popular name by region
SELECT region, gender, name, total_count
FROM (
    SELECT r.region,n.gender, n.name, SUM(n.births) AS total_count,
           RANK() OVER (PARTITION BY r.region ORDER BY SUM(n.births) DESC) AS name_rank
    FROM names n
    JOIN regions r ON n.state = r.state
    GROUP BY r.region, n.name, n.gender
) ranked
WHERE name_rank = 1;




