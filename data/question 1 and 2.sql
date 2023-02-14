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

