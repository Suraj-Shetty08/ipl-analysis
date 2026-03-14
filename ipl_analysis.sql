-- Query 1: Overall wins by team
SELECT
	m.winner AS team,
    COUNT(m.winner) AS matches_won,
    total.total_matches,
    ROUND(COUNT(winner)/(total.total_matches)*100,2) AS win_pct
FROM matches AS m
LEFT JOIN(
	SELECT team, COUNT(*) AS total_matches 
    FROM(
		SELECT team1 AS team FROM matches
		UNION ALL
		SELECT team2 AS team FROM matches
        ) AS all_teams
	GROUP BY team) AS total ON total.team= winner
GROUP BY winner, total.total_matches
HAVING total.total_matches>50
ORDER BY win_pct DESC;

-- Query 2: Toss impact on match outcome
SELECT
  toss_decision,
  COUNT(*) AS total_matches,
  SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS won_after_toss,
  ROUND(SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END)/ COUNT(*) * 100.0, 2) AS win_rate
FROM matches
WHERE winner IS NOT NULL
GROUP BY toss_decision;


-- Query 3: Top 10 batters by total runs
SELECT 
	batsman,
    SUM(CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END) as total_fours,
    SUM(CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END) AS total_sixes,
    ROUND(SUM(batsman_runs)/COUNT(*)*100,2) AS strike_rate,
    SUM(batsman_runs) AS total_runs
FROM deliveries
WHERE extras_type!='wides'
GROUP BY batsman
ORDER BY total_runs DESC
LIMIT 10;

-- Query 4: Top 10 Bowlers by total wickets

SELECT
  bowler,
  SUM(is_wicket) AS total_wickets,
  ROUND(
    SUM(CASE WHEN extras_type NOT IN ('byes', 'legbyes') THEN total_runs ELSE 0 END) * 6.0
    /
    SUM(CASE WHEN extras_type NOT IN ('wides', 'noballs') THEN 1 ELSE 0 END)
  , 2) AS economy_rate
FROM deliveries
WHERE dismissal_kind NOT IN ('retired hurt', 'obstructing the field', 'retired out')
   OR dismissal_kind IS NULL
GROUP BY bowler
ORDER BY total_wickets DESC
LIMIT 10;


-- Query 5: Win % batting first vs chasing by venue

SELECT
	venue,
    ROUND(SUM(CASE WHEN result = 'runs' THEN 1 ELSE 0 END)*100/COUNT(*),2)AS bat_first_win_pct,
    ROUND(SUM(CASE WHEN result = 'wickets' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS chasing_pct
FROM matches
GROUP BY venue
HAVING COUNT(*) >=10;

-- QUERY 6: Average first innings score per season

SELECT
  m.season,
  COUNT(DISTINCT m.id) AS matches_played,
  ROUND(AVG(innings_total.total), 1) AS avg_first_innings_score
FROM matches m
LEFT JOIN (
  SELECT match_id, SUM(total_runs) AS total
  FROM deliveries
  WHERE inning = 1
  GROUP BY match_id
) AS innings_total ON m.id = innings_total.match_id
GROUP BY m.season
ORDER BY m.season;

-- Query 7: Most MOTM awards

SELECT
player_of_match,
COUNT(*) AS motm
FROM matches
GROUP BY player_of_match
ORDER BY motm DESC
LIMIT 10;

-- Query 8: Powerplay Runs

SELECT
  batting_team,
  ROUND(AVG(pp_runs), 1) AS avg_powerplay_runs
FROM (
  SELECT match_id, batting_team, SUM(total_runs) AS pp_runs
  FROM deliveries
  WHERE over_num<6
  GROUP BY match_id, batting_team
) AS pp
GROUP BY batting_team
ORDER BY avg_powerplay_runs DESC;
