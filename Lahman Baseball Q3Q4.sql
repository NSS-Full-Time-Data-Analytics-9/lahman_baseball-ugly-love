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


