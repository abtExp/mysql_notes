/*
	CASE statements introduce condition statement to sql.
	It is used to create a filter based on multiple conditions, and works like switch case or if else statements in any other programming language.

	Sample CASE query : 
*/

SELECT name, AVG(salary),
	CASE
		WHEN age > 16 AND age < 25 THEN "Too Young"
		WHEN age BETWEEN 25 AND 30 THEN "Good Age"
		ELSE "Too Old"
	END AS age_criteria,
	COUNT(DISTINCT team_name) as num_teams

FROM players
WHERE height >= 165
GROUP BY name
HAVING COUNT(DISTINCT team_name) > 1
ORDER BY salary
LIMIT 10;

/*

The above query, selects name, average salary and then creates a new column age_criteria, 
the value for which is decided using the CASE conditionals, and is one of Too Young, Good Age, or Too Old,
and then it filters players only having height >= 165 and then groups players using name and then filters players 
that have played for more than one team and orders the players in ascending order of their salary and returns the top 10.

*/