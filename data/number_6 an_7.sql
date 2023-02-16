--6
SELECT p.playerid,b.playerid, p.namefirst, p.namelast,b.sb,b.cs,b.yearid, ROUND((b.sb::decimal/(b.sb::decimal+b.cs::decimal)*100),2)AS percentsuccess
FROM people AS p
INNER JOIN batting AS b ON b.playerid = p.playerid
WHERE b.sb IS NOT NULL
AND b.cs IS NOT NULL
AND yearid = '2016'
AND b.sb+b.cs >= 20
ORDER BY percentsuccess DESC;
--7
SELECT teams.name,W AS wins , L AS loses
FROM teams
WHERE Wswin IS NOT NULL
ORDER BY W DESC,L asc,wswin;
--7b
SELECT teams.name,W AS wins , L AS loses,WSwin,yearid
FROM teams
WHERE Wswin IS NOT NULL AND teams.wswin='Y' AND teams.yearid Between '1970' AND '2016'
ORDER BY W asc,L desc,wswin;
--
WITH win AS (select yearid,max(teams.w) AS most_wins
			from teams  
			where yearid > 1969
			group by yearid
			ORDER BY yearid desc)
select(round(count(distinct teams.yearid)::decimal * 100,2)/47) AS perc_of_wins 
from win INNER JOIN teams USING (yearid)
where w= most_wins AND WSwin='Y';
