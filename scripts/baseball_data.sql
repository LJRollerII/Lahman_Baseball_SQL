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

--Alternate with a subq in the WHERE
SELECT namefirst, namelast, height, weight, g_all, teamID
FROM people
LEFT JOIN appearances
USING(playerid)
WHERE height = (SELECT MIN(height)
			   	FROM people)

-- Answer: Eddie Gaedel aka Edward Carl. Height is 43 inches, played for SLA (St. Louis Browns), and only played one game on 8/19/1951 */
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

--Alternate with subq in the WHERE instead of JOIN
SELECT playerid,
		namefirst,
		namelast,
		SUM(salary)
FROM people
LEFT JOIN salaries
USING(playerid)
WHERE playerid IN (SELECT playerid
					FROM collegeplaying
					WHERE schoolid = 'vandy')
AND salary IS NOT NULL
GROUP BY playerid, namefirst, namelast
ORDER BY SUM(salary) DESC;

--Checking for duplication to make sure my salaries are right (they were not)
-- SELECT namefirst, namelast, salary, playerid
-- FROM people
-- LEFT JOIN salaries
-- USING(playerid)
-- LEFT JOIN collegeplaying
-- USING(playerid)
-- WHERE schoolid = 'vandy' AND playerid = 'sandesc01'

-- SELECT *
-- FROM collegeplaying
-- WHERE playerid = 'sandesc01'

-- SELECT *
-- FROM salaries
-- WHERE playerid = 'sandesc01'

-- SELECT schoolid, MAX(yearid), playerid
-- 		   FROM collegeplaying
-- 		   WHERE playerid = 'sandesc01'
-- 		   GROUP BY schoolid, playerid

--Checking to see if adding DISTINCT to the salary sum would affect the result (it does)
-- SELECT playerid, salary
-- FROM salaries
-- WHERE playerid = 'priceda01'
-- ORDER BY salary

-- SELECT playerid, salary
-- FROM salaries
-- WHERE playerid = 'sandesc01'
-- ORDER BY salary


-- Answer: David Price earned the most money in the majors ($81,851,296)*/
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

--With a formula instead of a GROUP BY
SELECT (yearid)/10*10 AS decade, 
		SUM(so) as so_batter, SUM(soa) as so_pitcher, 
		ROUND(CAST(SUM(so) as dec) / CAST(SUM(g/2) as dec), 2) as so_per_game,
		ROUND(CAST(SUM(hr) as dec) / CAST(SUM(g/2) as dec), 2) as hr_per_game
FROM teams
WHERE (yearid)/10*10 > 1910
GROUP BY decade
ORDER BY decade;


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
/*7.

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


WITH winnies AS (
	SELECT yearid, teamid, w, wswin,
	MAX(w) OVER(PARTITION BY yearid) AS most_wins,
	CASE WHEN wswin = 'Y' THEN CAST(1 AS numeric)
		ELSE CAST(0 AS numeric) END AS ynbin
	FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
		AND yearid != 1981
		AND wswin IS NOT NULL)

SELECT SUM(ynbin) AS most_wins_wswin, COUNT(DISTINCT yearid) AS all_years, ROUND(SUM(ynbin)/COUNT(DISTINCT yearid), 3) AS perc_most_wins_wswin
FROM winnies
WHERE w = most_wins;

--Answer: Pt.1: 116 largest number of wins for a team that did not win the world series. 
-- Pt.2: 63 is the smallest number of wins for a team that did win the world series. The low number of wins was due to the MLB strike of 1981.
-- Pt.3: When redoing the query 83 is the smallest number of wins for a team that did win the world series.	
-- Pt.4: 12 times was the case that a team with the most wins also won the world series. This happened 26.7% of the time.
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



--Answer:Pt 1: LAN (Los Angeles Dodgers), LOS03 (Dodger Stadium), 45719 (average attendance). The next four would be St. Louis, Toronto, San Fransico, Chicago Cubs 
-- Pt 2: TBA (Tampa Bay Rays), STP01 (Tropicana Field), 15878 (average attendance) The next four would be Oakland, Cleveland Miami, Chicago White Sox */
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


-- SELECT teamid, yearid, playerid
-- FROM managers
-- WHERE yearid IN (1988, 1990, 1992, 1997, 2006, 2012)
-- 	AND playerid IN ('leylaji99', 'johnsda02')




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

--Alternative/Better way to find answer

WITH tsn_nl AS
(SELECT playerid, awardid, yearid, lgid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year'
	AND lgid = 'NL'),

tsn_al AS
(SELECT playerid, awardid, yearid, lgid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year'
	AND lgid = 'AL'),
	
winners_only AS
(SELECT tsn_nl.playerid, namefirst, namelast,
	tsn_nl.awardid, 
	tsn_nl.yearid AS nl_year, 
	tsn_al.yearid AS al_year
FROM tsn_nl
INNER JOIN tsn_al
USING(playerid)
LEFT JOIN people
USING(playerid))

SELECT subq.playerid, namefirst, namelast, team, awardid, year, league
FROM(SELECT nl_year AS year, playerid, namefirst, namelast, awardid
	 FROM winners_only
	 UNION
	 SELECT al_year, playerid, namefirst, namelast, awardid
	 FROM winners_only) AS subq
LEFT JOIN
(SELECT nl_year AS year, 'nl' AS league
	 FROM winners_only
	 UNION
	 SELECT al_year AS year, 'al'
	 FROM winners_only) AS subq2
USING(year)
LEFT JOIN 
(SELECT playerid, yearid, teamid, name AS team
FROM managers
LEFT JOIN teams
USING(teamid, yearid)) AS subq3
ON subq.playerid = subq3.playerid AND subq.year = subq3.yearid
ORDER BY year;

--Checking Jim and Davey's teams in their TSN award years
-- SELECT teamid, yearid, playerid
-- FROM managers
-- WHERE yearid IN (1988, 1990, 1992, 1997, 2006, 2012)
-- 	AND playerid IN ('leylaji99', 'johnsda02')

--Exploring the relationship between the managers and teams tables
--Fun note: in the 1800's, they were called the Boston Red and Chicago White Stockings
-- SELECT playerid, teamid, yearid, name
-- FROM managers AS m
-- LEFT JOIN teams AS t
-- USING(teamid, yearid)
-- ORDER BY playerid



--Answer: Davie Johnson with the Baltimore Orioles (AL) in 1997 and Washington Nationals (NL) in 2012
-- Jim Leyland with the Detriot Tigers (AL) in 2006 and Pittsburgh Pirates (NL) in 1990.
========================================================================================================================================================================================================================================================================================================================================
10.

WITH NOT2016 AS (
SELECT MAX(hr), playerid
FROM batting
WHERE yearid <> 2016
GROUP BY batting.playerid)
SELECT p.namefirst,
		p.namelast,
		p.playerid,
		b.yearid,
		b.hr,
		MAX(b.hr) AS max_hr_career,
		b.g, 
		b.stint,
		MAX(b.hr) OVER(PARTITION BY b.yearid) AS hr_season,
		(CAST(p.finalgame AS date) - CAST(p.debut AS date)) / 365 AS years_played,
		g_all
FROM people AS p
JOIN batting AS b
ON p.playerid = b.playerid
LEFT JOIN appearances AS a
ON b.playerid = a.playerid
WHERE b.yearid = 2016
AND hr >= 1
AND (CAST(p.finalgame AS date) - CAST(p.debut AS date)) / 365 >= 10
GROUP BY p.namefirst,
		p.namelast,
		p.playerid,
		b.yearid,
		b.hr,
		b.hr,
		b.g, 
		b.stint,
		g_all
ORDER BY hr DESC


SELECT p.namelast,
	p.namefirst,
	MAX(b.hr),
	COUNT(b.yearid) AS seasons_played
FROM people AS p
LEFT JOIN batting AS b
USING (playerid)
HAVING COUNT(b.hr) >= 1
GROUP BY p.namelast, p.namefirst
ORDER BY p.namelast, p.namefirst;

--Alternative/Better ways to find answer

--For 2016, is there one entry per player? No - Will have two entries if switched teams mid year
-- SELECT COUNT(playerid) - COUNT(DISTINCT playerid)
-- FROM batting
-- WHERE yearid = 2016;

WITH hr_sixteen AS
(SELECT playerid, yearid, SUM(hr) as player_hr_sixteen
FROM batting
WHERE yearid = 2016
GROUP by playerid, yearid
ORDER BY player_hr_sixteen DESC),

yearly_hr AS
(SELECT playerid, yearid, SUM(hr) AS hr_yearly,
 	MAX(SUM(hr)) OVER(PARTITION BY playerid) AS best_year_hrs
FROM batting
GROUP BY playerid, yearid),

yp AS
(SELECT COUNT(DISTINCT yearid) AS years_played, playerid
FROM batting
GROUP BY playerid)

SELECT playerid, namefirst, namelast, hr_yearly AS total_hr_2016, years_played
FROM yearly_hr
INNER JOIN hr_sixteen
USING(playerid)
INNER JOIN yp
USING(playerid)
INNER JOIN people
USING(playerid)
WHERE best_year_hrs = player_hr_sixteen
	AND hr_yearly > 0
	AND yearly_hr.yearid = 2016
	AND years_played >= 10
ORDER BY playerid

--Alternate
WITH maxhr AS (
	SELECT playerid,
			yearid,
			hr,
			MAX(hr) OVER (PARTITION BY playerid) AS maxhr,
			CASE WHEN hr = MAX(hr) OVER (PARTITION BY playerid) THEN 'yes'
			ELSE 'no' END AS career_high_2016
	FROM batting
)
SELECT p.playerid,
		p.namefirst,
		p.namelast,
		m.yearid,
		m.hr,
		m.maxhr
FROM people AS p
LEFT JOIN maxhr AS m
ON p.playerid = m.playerid
WHERE m.hr != 0
AND m.yearid = 2016
AND career_high_2016 = 'yes'
AND m.playerid IN (SELECT playerid
				  FROM batting
				  GROUP BY playerid
				  HAVING COUNT(DISTINCT yearid) >= 10)
GROUP BY 1,2,3,4,5,6

--Answer: Robinson Cano, Bartolo Colon, Rajai Davis, Edwin Encarnacion, Franciso Liriano, Mike Napoli, Angel Pagan, Justin Upton, Adam Wainwright
=================================================================================================================================================
11.

SELECT s.yearid, SUM(s.salary), s.teamid
FROM salaries AS s
LEFT JOIN teams AS t
ON s.teamid = t.teamid
WHERE s.yearid = 2000 
GROUP BY s.teamid, s.yearid
ORDER BY s.teamid, s.yearid, SUM(s.salary) DESC


SELECT s.yearid, SUM(s.salary) AS team_salary , s.teamid
FROM salaries AS s
LEFT JOIN teams AS t
ON s.teamid = t.teamid
WHERE s.yearid BETWEEN 2000 AND 2016
GROUP BY s.teamid, s.yearid
ORDER BY s.teamid, team_salary, s.yearid ASC





=========================================================================
========================================================================================================================================================================================================================================================================================================================================
--Notes/Scrapwork
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


================================================================================================================
--Notes From Taryn (Question in these notes are different from actual project)
==========================================================================================================================
QUESTION 1. Total walks allowed by manager over the course of their career
SELECT playerid, SUM(BBA) AS career_walks_allowed
FROM managers
LEFT JOIN teams
USING(teamid)
GROUP BY playerid
ORDER BY playerid
--The manager with the playerid actama99 has value of 211,053 for how many walks his teams allowed while he was managing them. That seems extremely high.

--First let's look at 'actama99' in managers
SELECT *
FROM managers
WHERE playerid = 'actama99'
--He's in there 6 times because there's an entry for each year he managed. Is that important? 

-- We see he managed WAS from 2007-2009 and then CLE from 2010-2012. Let's look at the BBA (walks allowed) with those filters in the teams table.
SELECT * 
FROM teams
WHERE yearid BETWEEN 2007 AND 2009
	AND teamid = 'WAS'
OR yearid BETWEEN 2010 AND 2012
	AND teamid = 'CLE'
--6 entries makes sense (3 years * 2 teams)

--Let's isolate BBA since those rows feel good.
SELECT SUM(BBA)
FROM teams
WHERE yearid BETWEEN 2007 AND 2009
	AND teamid = 'WAS'
OR yearid BETWEEN 2010 AND 2012
	AND teamid = 'CLE'
--So since 'actama99' managed WAS from 2007 - 2009, then CLE from 2010-2012, it seems like our number should be 3,375 instead of 211,053. This number seems more reasonable. 

--Let's look again at the managers table, but this time join teams onto it to see exactly what's happening without BBA numbers. You can select all, but to make it easier (and perhaps a lot faster depending on how many rows of data you have), you could select only the columns that are relevant to the issue. Keep in mind, we're suspicious of the yearid contributed by the managers table.
SELECT playerid, teamid, managers.yearid, BBA
FROM managers
LEFT JOIN teams
USING(teamid)
WHERE playerid = 'actama99'
-- A couple findings here: 1. Since we feel confident our actual BBA number is 3375, we don't have to calculate these 408 rows to guess that this output might be higher than that. 2. Years are showing up multiple times for other fields that are staying consistent - for example there are many rows where the teamid is 'WAS' and the yearid is '2009'

--Since it seems like yearid in the managers table is probably the issue, let's try matching our join on the yearid key in addition to the teamid
SELECT playerid, SUM(BBA) AS career_walks_allowed
FROM managers
LEFT JOIN teams
USING(teamid, yearid)
GROUP BY playerid
ORDER BY playerid
--Now actama99's BBA is 3375. If the number had been something else, we would have known to try another method.


-- QUESTION 2. career homeruns of everyone who went to rice
SELECT playerid, SUM(hr) AS career_homeruns
FROM people
LEFT JOIN collegeplaying
USING(playerid)
LEFT JOIN batting
USING(playerid)
WHERE schoolid = 'rice'
GROUP BY playerid
ORDER BY career_homeruns DESC;

--The playerid 'berkmla01' is giving us a career homeruns number of 1098. Seems high, but how do we check? First, let's see what the batting table looks like. We can be pretty confident the following output will give us the right number for career homeruns because there is no join involved to give us duplicates.
SELECT playerid, SUM(hr) AS career_homeruns
FROM batting
WHERE playerid = 'berkmla01'
GROUP BY playerid

--336. So which table is giving us trouble (or both)? Let's get a feel for our other tables. Since they all have playerid in them, we can filter for berkmla01 for both.
SELECT *
FROM people
WHERE playerid = 'berkmla01'
--Just one row in people (makes sense); probably not affecting our output

--What about collegeplaying?
SELECT *
FROM collegeplaying
WHERE playerid = 'berkmla01'
--collegeplaying has a row for each year the player attended college there. Since the years someone went to school have nothing to do with their batting average, we have no use for this column. You can deal with this selection using a subquery.

--Here are two ways to go about it:

--1. Subquery in your WHERE: take out the JOIN to collegeplaying entirely and recreate your WHERE to indicate you only want playerids from a subquery where schoolid = 'rice'. Now it's not pulling in any information about years in the collegeplaying table, it's only grabbing the ids we're interested in
SELECT playerid, SUM(hr) AS career_homeruns
FROM people
-- LEFT JOIN collegeplaying
-- USING(playerid)
LEFT JOIN batting
USING(playerid)
--WHERE schoolid = 'rice'
WHERE playerid IN (SELECT playerid
					FROM collegeplaying
					WHERE schoolid = 'rice')
GROUP BY playerid
ORDER BY career_homeruns DESC;


--2. Subquery in your FROM (or CTE you join to): We only brought the collegetable table in to link playerid to schoolid, so in this case we can pick any of these rows at random. In this case, we're going to use MAX() since either MAX() or MIN() will give us exactly one row without combining anything together.
SELECT playerid, SUM(hr) AS career_homeruns
FROM people
--Selecting schoolid in our subquery because we reference it in the WHERE to filter for 'rice'. We select playerid because we need it to join to the other tables. Finally, MAX(yearid) comes in so we are only selecting one row from the collegeplaying table.
LEFT JOIN (SELECT schoolid, playerid, MAX(yearid)
		   FROM collegeplaying
		   GROUP BY schoolid, playerid) as subq
USING(playerid)
LEFT JOIN batting
USING(playerid)
WHERE schoolid = 'rice'
GROUP BY playerid
ORDER BY career_homeruns DESC;
--If you use this method, make sure you have a good understanding of exactly what is happening in your tables.

--Why do we use a subquery to fix this issue, but JOIN on multiple keys to fix our first issue?	   