--Question 1 min and max showing the range
SELECT min(year),max(year)
FROM homegames;

--2 
select people.namegiven AS full_name,min(height) AS height,appearances.g_all As games_played,appearances.yearID,teams.name As team_name
from people INNER JOIN appearances USING (playerid)
			INNER JOIN teams USING (teamid) 
group by people.namegiven,height,games_played,teams.name,appearances.yearID
ORDER By height asc
limit 1;

--3
select people.playerid,people.namegiven,schools.schoolname,sum(salaries.salary),collegeplaying.yearid
FROM schools INNER JOIN collegeplaying USING (schoolid) INNER JOIN people USING (playerid) INNER JOIN salaries USING (playerid)  
where schools.schoolname ILIKE '%Vanderbilt%'
GROUP BY people.namegiven,schools.schoolname,salaries.salary,collegeplaying.yearid,people.playerid
ORDER By salaries.salary desc;
--4
SELECT CASE 
WHEN f.pos IN('SS','1B','2B','3B') THEN 'infield'
WHEN F.POS='OF' THEN 'OUTFIELD'
WHEN f.pos IN ('P','C') THEN 'Battery' END AS position,sum(po) AS putouts
from fielding As F
WHERE yearid=2016
GROUP BY position;
--5 theres more strike outs though the decades
SELECT (yearid)/10*10 AS decade, ROUND(AVG(so),2) AS avg_strike, ROUND(AVG(hr)/10*10,2) AS avg_homerun
FROM teams
WHERE yearid BETWEEN 1920 AND 2016
GROUP BY (yearid)/10*10
ORDER BY decade ASC;
--6
SELECT p.playerid,b.playerid, p.namefirst, p.namelast,b.sb,b.cs,b.yearid, ROUND((b.sb::decimal/(b.sb::decimal+b.cs::decimal)*100),2)AS percentsuccess
FROM people AS p
INNER JOIN batting AS b ON b.playerid = p.playerid
WHERE b.sb IS NOT NULL
AND b.cs IS NOT NULL
AND yearid = '2016'
AND b.sb+b.cs >= 20
ORDER BY percentsuccess DESC;

