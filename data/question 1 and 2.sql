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
--5
SELECT batting.yearid/10*10 AS decades_batting,pitching.yearid/10*10 AS pitching_year,
round(avg(batting.so),2) AS avg_batting,round(avg(pitching.so),2) AS avg_pitching,round(avg(batting.hr),2) AS avg_batting_hr,round(avg(pitching.hr),2) AS avg_pitching_hr
FROM PEOPLE INNER JOIN batting USING (playerid) 
			INNER JOIN pitching USING (playerid)
WHERE batting.so IS NOT NULL
group BY batting.so,batting.so,pitching.so,batting.hr,pitching.hr,batting.yearid/10*10,pitching.yearid/10*10
ORDER BY batting.yearid/10*10,pitching.yearid/10*10
