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
/*4.

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
/* 5.

SELECT ROUND(AVG(so / g),2) AS avg_strikeout_game, 
ROUND(AVG(hr / g),2) AS avg_homerun_game,
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
FROM teams
WHERE yearid >= 1920
GROUP BY decade
ORDER BY avg_strikeout_game DESC

-- Answer: The number of homeruns and strikeouts generally tends to increase each decade since 1920. This can be due to many factors such as natural progression, intergration, steriods, and league expansion (adding more teams). */
=====================================================================================================================================================================================================================================
--sb= stolen base
--cs= caught stealing

/*6.SELECT
	p.namefirst,
	p.namelast,
	p.playerid,
	b.yearid,
	SUM(b.sb) AS total_stolen,
	SUM(b.sb + b.cs) AS total_attempts,
	SUM(b.sb) * 100.0 / NULLIF(SUM(b.sb + b.cs),0) AS percent_success
FROM people AS p
LEFT JOIN batting AS b
ON p.playerid = b.playerid
GROUP BY
	p.namefirst,
	p.namelast,
	p.playerid,
	b.yearid,
	b.sb,
	b.cs
HAVING SUM(b.sb + b.cs) > 20
AND yearid = 2016
ORDER BY percent_success DESC;

--Answer:Chris Ownings */
========================================================================================================================================================================================================================================
7.

SELECT *
FROM teams

SELECT teamid, name, yearid, MAX(w) 
FROM teams
WHERE wswin = 'N'
AND yearid BETWEEN 1970 AND 2016
GROUP BY teamid, name, yearid
ORDER BY MAX(w) DESC

SELECT teamid, name, yearid, MIN(w) 
FROM teams
WHERE wswin = 'Y'
AND yearid BETWEEN 1970 AND 2016
GROUP BY teamid, name, yearid
ORDER BY MIN(w)

SELECT teamid, name, yearid, MIN(w) 
FROM teams
WHERE wswin = 'Y'
AND yearid BETWEEN 1970 AND 2016
AND yearid <> 1981
GROUP BY teamid, name, yearid
ORDER BY MIN(w)

SELECT teamid, name, wswin, yearid, MAX(w) 
FROM teams
WHERE wswin = 'Y'
AND yearid BETWEEN 1970 AND 2016
GROUP BY teamid, name, yearid, wswin
ORDER BY MAX(w) DESC

/*(SELECT teamid, name, yearid, MAX(w) 
FROM teams
WHERE wswin = 'N'
AND yearid BETWEEN 1970 AND 2016
GROUP BY teamid, name, yearid
ORDER BY MAX(w) DESC) AS subquery*/

--Answer: Pt.1: 116 largest number of wins for a team that did not win the world series. 
-- Pt.2: 63 is the smallest number of wins for a team that did win the world series. The low number of wins was due to the MLB strike of 1981.
-- Pt.3: When redoing the query 83 is the smallest number of wins for a team that did win the world series.	   
================================================================================================================================================================================================================================================================================================================================	   
/*8. SELECT *
FROM homegames

SELECT attendance,
			team,
			park,
		    games,
			attendance / games AS avg_attendance
FROM homegames
WHERE year=2016
AND games >= 10
ORDER BY avg_attendance DESC
LIMIT 5

SELECT attendance,
			team,
			park,
		    games,
			attendance / games AS avg_attendance
FROM homegames
WHERE year=2016
AND games >= 10
ORDER BY avg_attendance
LIMIT 5



--Answer:Pt 1: LAN (Los Angeles Dodgers), LOS03 (Dodger Stadium), 45719 (average attendance)
-- Pt 2: TBA (Tampa Bay Rays), STP01 (Tropicana Field), 15878 (average attendance) */
========================================================================================================================================================================================================================================================================================================================================

9.

SELECT playerid, awardid, yearid, lgid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year'


SELECT playerid, awardid, yearid, lgid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year'
AND lgid ='AL'

SELECT playerid, awardid, yearid, lgid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year'
AND lgid ='NL'

SELECT playerid, awardid, yearid, lgid, COUNT(awardid) AS num_awards
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year'
AND lgid ='AL'
OR lgid = 'NL'
GROUP BY playerid, awardid, yearid,  lgid
ORDER BY playerid


WITH NL AS (
SELECT *
FROM awardsmanagers
where lgid = 'NL'),
AL AS (
SELECT *
FROM awardsmanagers
WHERE lgid = 'AL')
SELECT DISTINCT NL.playerid,
p.namefirst,
p.namelast,
m.teamid,
m.yearid,
NL.awardid,
AL.awardid,
NL.lgid,
AL.lgid
FROM NL
INNER JOIN AL
ON NL.playerid = AL.playerid
LEFT JOIN people AS p
ON NL.playerid = p.playerid
LEFT JOIN managers AS m
ON p.playerid = m.playerid
WHERE NL.awardid ILIKE '%TSN Manager%'
AND AL.awardid ILIKE '%TSN Manager%'


--CTE Chapter 3 of Immeidate SQL in datacamp for reference.

--Ansewer: Davie Johnson with the Baltimore Orioles (AL) in 1997 and Washington Nationals (NL) in 2012
-- Jim Leyland with the Detriot Tigers (AL) in 2006 and Pittsburgh Pirates (NL) in 1990.
========================================================================================================================================================================================================================================================================================================================================
10.

SELECT namefirst, namelast, hr




========================================================================================================================================================================================================================================================================================================================================
SELECT t.teamid, t.name, t.wswin, t.yearid, MAX(t.w) 
FROM teams AS t
WHERE t.wswin = 'Y'
AND yearid BETWEEN 1970 AND 2016
--GROUP BY t.teamid, t.name, t.yearid, t.wswin
--ORDER BY MAX(w) DESC
JOIN
(SELECT teamid, name, yearid, MAX(w) 
FROM teams
WHERE wswin = 'N'
AND yearid BETWEEN 1970 AND 2016
GROUP BY teamid, name, yearid
ORDER BY MAX(w) DESC) AS subquery
ON t.w = subquery.w

SELECT teamid, name, wswin, yearid, MAX(w) 
FROM teams
WHERE wswin = 'Y'
AND yearid BETWEEN 1970 AND 2016
GROUP BY teamid, name, yearid, wswin
ORDER BY yearid 

SELECT teamid, name, wswin, yearid, MAX(w) 
FROM teams
WHERE wswin = 'N'
AND yearid BETWEEN 1970 AND 2016
GROUP BY teamid, name, yearid, wswin
ORDER BY yearid 


--USE CTE for reference
WITH home AS (
  SELECT m.id, m.date, 
       t.team_long_name AS hometeam, m.home_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.hometeam_id = t.team_api_id),
-- Declare and set up the away CTE
away as (
  SELECT m.id, m.date, 
       t.team_long_name AS awayteam, m.away_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.awayteam_id = t.team_api_id)
-- Select date, home_goal, and away_goal
SELECT 
  home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
-- Join away and home on the id column
FROM home
INNER JOIN away
ON home.id = away.id;


	   