-- 5. Find the average number of strikeouts per game by decade since 1920. 
-- Round the numbers you report to 2 decimal places. 
-- Do the same for home runs per game. Do you see any trends?

SELECT DISTINCT(batting.yearid)/10*10 AS b_decade, ROUND(AVG(batting.so)/10*10, 2) AS batting_so, ROUND(AVG(batting.hr)/10*10,2) AS b_hr, (pitching.yearid)/10*10 AS p_decade, ROUND(AVG(pitching.so)/10*10, 2) AS pitching_so,ROUND(AVG(pitching.hr)/10*10,2) AS p_hr 
FROM batting
INNER JOIN pitching USING (playerid)
WHERE batting.yearid > 1920
AND pitching.yearid > 1920
GROUP BY (batting.yearid)/10*10, (pitching.yearid)/10*10
ORDER BY b_decade ASC, p_decade ASC

SELECT (yearid)/10*10 AS decade, ROUND(AVG(so),2) AS avg_so, ROUND(AVG(hr)/10*10,2) AS avg_hr
FROM teams
WHERE yearid BETWEEN 1920 AND 2016
GROUP BY (yearid)/10*10
ORDER BY decade ASC;

-- consistent increase between SO & HR until 1970-1980 with a slight dip 






