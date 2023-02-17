--1. What range of years for baseball games played does the provided database cover? 
SELECT *
FROM people;

SELECT min(year),max(year)
FROM homegames;

--2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT people.namegiven AS full_name, min(height) AS height, appearances.g_all AS games_played, appearances.yearID, teams.name AS team_name
FROM people INNER JOIN appearances USING (playerid)
			INNER JOIN teams USING (teamid)										  
GROUP BY people.namegiven, height, games_played, teams.name, appearances.yearID
ORDER BY height ASC
LIMIT 1;

--3. Find all players in the database who played at Vanderbilt University. 
SELECT *
FROM schools
WHERE schoolname ILIKE '%Vanderbilt%';

SELECT DISTINCT schoolname, namegiven
FROM people
INNER JOIN collegeplaying USING (playerid)
INNER JOIN schools USING (schoolid)
WHERE schoolname ILIKE '%Vanderbilt%';
--Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
SELECT DISTINCT schoolname, namegiven, salary
FROM people
INNER JOIN collegeplaying USING (playerid)
INNER JOIN schools USING (schoolid)
INNER JOIN salaries USING (playerid)
WHERE schoolname ILIKE '%Vanderbilt%'
ORDER BY salary DESC;

--Sort this list in descending order by the total salary earned. 
SELECT DISTINCT schoolname, namegiven, salary
FROM people
INNER JOIN collegeplaying USING (playerid)
INNER JOIN schools USING (schoolid)
INNER JOIN salaries USING (playerid)
WHERE schoolname ILIKE '%Vanderbilt%'
ORDER BY salary DESC;

--Which Vanderbilt player earned the most money in the majors?
SELECT DISTINCT schoolname, namefirst, namelast, playerid, namegiven, SUM(salary) AS salary, collegeplaying.yearid
FROM people
INNER JOIN collegeplaying USING (playerid)
INNER JOIN schools USING (schoolid)
INNER JOIN salaries USING (playerid)
WHERE schoolname ILIKE '%Vanderbilt%'
GROUP BY schoolname, namefirst, namelast, playerid, namegiven, collegeplaying.yearid
ORDER BY salary DESC;
-- ANSWER David Price

--4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", 
-- those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
--Determine the number of putouts made by each of these three groups in 2016.
SELECT *
FROM fielding

SELECT CASE 
WHEN f.pos IN('SS','1B','2B','3B') THEN 'infield'
WHEN F.POS='OF' THEN 'OUTFIELD'
WHEN f.pos IN ('P','C') THEN 'Battery' END AS position,sum(po) AS putouts
from fielding As F
WHERE yearid=2016
GROUP BY position;


--5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. 
--Do the same for home runs per game. Do you see any trends?

SELECT *
FROM teams

SELECT p.playerid,b.playerid, p.namefirst, p.namelast,b.sb,b.cs,b.yearid, ROUND((b.sb::decimal/(b.sb::decimal+b.cs::decimal)*100),2)AS percentsuccess
FROM people AS p
INNER JOIN batting AS b ON b.playerid = p.playerid
WHERE b.sb IS NOT NULL
AND b.cs IS NOT NULL
AND yearid = '2016'
AND b.sb+b.cs >= 20
ORDER BY percentsuccess DESC;


--6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. 
--(A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
SELECT people.namegiven, batting.yearid, batting.sb, batting.cs
FROM people
INNER JOIN batting
USING (playerid)
WHERE batting.yearid = 2016 AND batting.sb > 20
ORDER BY batting.sb DESC


--7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? 
--Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
--Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
SELECT teams.name,W AS wins, L AS loss, Wswin
FROM teams
WHERE wswin IS NOT NULL
ORDER BY W DESC,L ASC, Wswin

--What is the smallest number of wins for a team that did win the world series?
SELECT teams.name, W AS wins, L AS loss, Wswin, yearid
FROM teams
WHERE Wswin IS NOT NULL AND teams.wswin = 'Y'
ORDER BY W ASC, L DESC, WSwin;

--How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
SELECT teams.name, W AS wins, L AS loss, Wswin, yearid
FROM teams
WHERE Wswin IS NOT NULL AND teams.wswin = 'Y' AND teams.yearid BETWEEN '1970' AND '2016'
ORDER BY W ASC, L DESC, WSwin;

--What percentage of the time?
WITH win AS (select yearid,max(teams.w) AS most_wins
			from teams  
			where yearid > 1969
			group by yearid
			ORDER BY yearid desc)
select(round(count(distinct teams.yearid)::decimal * 100,2)/47) AS perc_of_wins 
from win INNER JOIN teams USING (yearid)
where w= most_wins AND WSwin='Y';



--8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 
--(where average attendance is defined as total attendance divided by number of games). 
--Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
SELECT *
FROM homegames

--find the teams and parks which had the top 5 average attendance per game in 2016
SELECT ROUND(AVG(attendance/games),1) AS avg_attendance, park_name, team, year
FROM homegames
INNER JOIN parks USING (park)
WHERE year = '2016'
GROUP BY park_name, team, year, games
HAVING games > '10'
ORDER BY avg_attendance DESC
LIMIT 5;

--Repeat for the lowest 5 average attendance.
SELECT ROUND(AVG(attendance/games),1) AS avg_attendance, park_name, team, year
FROM homegames
INNER JOIN parks USING (park)
WHERE year = '2016'
GROUP BY park_name, team, year, games
HAVING games > '10'
ORDER BY avg_attendance ASC
LIMIT 5;

--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
--Give their full name and the teams that they were managing when they won the award.
SELECT DISTINCT CONCAT(p.namefirst, ' ', p.namelast) AS manager_name, m.teamid AS team, aw.lgid AS league, aw.yearid AS year
FROM people AS p
JOIN managers AS m USING (playerid)
JOIN awardsmanagers AS aw USING (playerid, yearid) 
WHERE playerid IN
	(WITH nl AS (SELECT p.playerid, aw.awardid, aw.lgid, aw.yearid
				FROM people AS p
				JOIN awardsmanagers AS aw ON p.playerid=aw.playerid
				WHERE aw.awardid LIKE 'TSN%' AND lgid = 'NL' 
				GROUP BY p.playerid, aw.awardid, aw.lgid, aw.yearid
				ORDER BY aw.yearid DESC),
	al AS 	    (SELECT p.playerid, aw.awardid, aw.lgid, aw.yearid
				FROM people AS p
				JOIN awardsmanagers AS aw ON p.playerid=aw.playerid
				WHERE aw.awardid LIKE 'TSN%' AND lgid = 'AL' 
				GROUP BY p.playerid, aw.awardid, aw.lgid, aw.yearid
				ORDER BY aw.yearid DESC)
	SELECT DISTINCT nl.playerid FROM nl
	JOIN al ON nl.playerid = al.playerid)
AND aw.yearid = m.yearid 
GROUP BY p.namefirst, p.namelast, m.teamid, aw.lgid, aw.yearid
ORDER BY manager_name, aw.yearid

--10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, 
--and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.
SELECT *
FROM people

SELECT *
FROM batting

SELECT DISTINCT namefirst, namelast, batting.yearid AS year, MAX(hr), debut
FROM people
INNER JOIN appearances USING (playerid)
INNER JOIN batting USING (playerid)
WHERE batting.yearid = '2016'
AND debut < '2006-31-12'
GROUP BY  namefirst, namelast, year, debut
ORDER BY MAX(hr) DESC
LIMIT 88;

--**OR**-- 

SELECT CONCAT(people.namefirst, ' ', people.namelast) AS "Player name", MAX(batting.hr) AS career_high_hrs
FROM people
JOIN batting USING (playerid)
WHERE people.playerid IN
	(WITH most AS (SELECT people.playerid, MAX(hr) AS most_hrs
				  FROM batting 
				  JOIN people USING (playerid)
				  GROUP BY people.playerid
				  ORDER BY most_hrs DESC),
	sixteen AS (SELECT people.playerid, batting.hr AS hr_2016
FROM people 
JOIN batting USING (playerid)
WHERE yearid = 2016
ORDER BY batting.hr DESC),
a AS (SELECT batting.playerid,
((people.finalgame::date)-(people.debut::date))/365 AS years_played
FROM people INNER JOIN batting USING(playerid))
SELECT DISTINCT most.playerid FROM most
JOIN sixteen ON most.playerid = sixteen.playerid
JOIN a ON sixteen.playerid = a.playerid
WHERE most_hrs = hr_2016 AND years_played > 9 AND most.most_hrs > 0)
GROUP BY people.namefirst, people.namelast
ORDER BY MAX(batting.hr) DESC;


