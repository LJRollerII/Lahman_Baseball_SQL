=========================================================================================================================================================================================================================================
/*1. SELECT MIN(yearid), MAX(yearid)
FROM batting
Asnwer: Range of years of years is from 1871 - 2016 */
=========================================================================================================================================================================================================================================
/*2. SELECT playerid, namefirst, namelast, namegiven, MIN(height), debut, finalgame
FROM people
GROUP BY playerid
ORDER BY weight

SELECT p.playerid, p.namefirst, p.namelast, p.namegiven, MIN(p.height), p.debut, p.finalgame, a.teamid 
FROM people AS p
INNER JOIN appearances AS a
ON p.playerid = a.playerid
GROUP BY p.playerid, a.teamid
ORDER BY MIN(p.height)

-- Answer: Eddie Gaedel aka Edward Carl. Height is 43 inches, played for SLA, and only played one game on 8/19/1951 */
========================================================================================================================================================================================================================================
/* 3.SELECT *
FROM collegeplaying
ORDER BY schoolid DESC
--Vanderbilt = vandy in schoolid

SELECT p.playerid, p.namefirst, p.namelast, p.namegiven, s.salary, c.schoolid
FROM people AS p
LEFT JOIN salaries AS s
ON p.playerid = s.playerid
LEFT JOIN collegeplaying AS c 
ON p.playerid = c.playerid
WHERE c.schoolid = 'vandy'
AND s.salary IS NOT NULL 
ORDER BY s.salary DESC

-- Answer: David Price earned the most money in the majors */
========================================================================================================================================================================================================================================
/*4. SELECT *
FROM fielding

SELECT SUM(po),
     CASE WHEN pos = 'OF' THEN 'Outfield'
     WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
     WHEN pos IN ('P', 'C') THEN 'Battery' END AS position
FROM fielding
WHERE yearid = 2016
GROUP BY position
ORDER BY SUM(po) DESC

--Answer: Infield: 58934, Battery: 41424, Outfield: 29560 */
=====================================================================================================================================================================================================================================
/* 5.SELECT *
FROM batting

SELECT ROUND(AVG(so),2) AS avg_strikeout, 
ROUND(AVG(hr),2) AS avg_homerun,
      CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
      WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
      WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
      WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
      WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
      WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
      WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
      WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
      WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
      WHEN yearid BETWEEN 2010 AND 2016 THEN '2010s' END AS decade
FROM batting
WHERE yearid >= 1920
GROUP BY decade
ORDER BY avg_strikeout DESC

-- Answer: The number of homeruns and strikeouts generally tends to increase each decade since 1920. This can be due to many factors such as natural progression, intergration, steriods, and league expansion (adding more teams). */
=====================================================================================================================================================================================================================================
--sb= stolen base
--cs= caught stealing


SELECT p.namefirst, 
p.namelast,
p.namegiven, 
SUM(b.sb) AS succesful_sb, 
SUM(b.sb + b.cs) AS total_attempts
SUM(succesful_sb) * 100.0 / NULLIF(SUM(total_attempts), 0) AS percent_successful
FROM people AS p
INNER JOIN batting AS b
ON p.playerid = b.playerid
WHERE yearid = 2016
AND total_attempts > 20
ORDER BY percent_successful DESC

