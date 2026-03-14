DROP DATABASE IF EXISTS ipl_analysis;
CREATE DATABASE IF NOT EXISTS ipl_analysis;
USE ipl_analysis;

CREATE TABLE matches (
  id INT PRIMARY KEY,
  season VARCHAR(50),
  city VARCHAR(100),
  date DATE,
  match_type VARCHAR(100),
  player_of_match VARCHAR(100),
  venue VARCHAR(100),
  team1 VARCHAR(100),
  team2 VARCHAR(100),
  toss_winner VARCHAR(100),
  toss_decision VARCHAR(50),
  winner VARCHAR(100),
  result VARCHAR(50),
  result_margin INT,
  target_runs INT,
  target_overs INT,
  super_over VARCHAR(50),
  method VARCHAR(50),
  umpire1 VARCHAR(100),
  umpire2 VARCHAR(100)
);

CREATE TABLE deliveries (
  match_id INT,
  inning INT,
  batting_team VARCHAR(100),
  bowling_team VARCHAR(100),
  over_num INT,
  ball INT,
  batsman VARCHAR(100),
  bowler VARCHAR(100),
  non_striker VARCHAR(100),
  batsman_runs INT,
  extra_runs INT,
  total_runs INT,
  extras_type VARCHAR(50),
  is_wicket int,
  player_dismissed VARCHAR(50),
  dismissal_kind VARCHAR(30),
  fielder VARCHAR(50),
  FOREIGN KEY(match_id) REFERENCES matches(id)
);

-- Importing data (Handling string values in the columns with int datatype)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/matches.csv'
INTO TABLE matches
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, season, city, date, match_type, player_of_match, venue, team1, team2,
 toss_winner, toss_decision, winner, result, @result_margin, @target_runs,
 @target_overs, super_over, method, umpire1, umpire2)
SET
  result_margin = NULLIF(@result_margin, 'NA'),
  target_runs   = NULLIF(@target_runs, 'NA'),
  target_overs  = NULLIF(@target_overs, 'NA');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/deliveries.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify Import
SELECT COUNT(*) FROM matches;
SELECT COUNT(*) FROM deliveries;

-- Updating team name for better understanding
SET SQL_SAFE_UPDATES = 0;
UPDATE matches 
SET team1 = 'Royal Challengers Bengaluru'
WHERE team1 = 'Royal Challengers Bangalore';

UPDATE matches 
SET team2 = 'Royal Challengers Bengaluru'
WHERE team2 = 'Royal Challengers Bangalore';

UPDATE matches 
SET toss_winner = 'Royal Challengers Bengaluru'
WHERE toss_winner = 'Royal Challengers Bangalore';

UPDATE matches 
SET winner = 'Royal Challengers Bengaluru'
WHERE winner = 'Royal Challengers Bangalore';

UPDATE deliveries 
SET batting_team = 'Royal Challengers Bengaluru'
WHERE batting_team = 'Royal Challengers Bangalore';

UPDATE deliveries 
SET bowling_team = 'Royal Challengers Bengaluru'
WHERE bowling_team = 'Royal Challengers Bangalore';

UPDATE matches
SET team1 = 'Punjab Kings'
WHERE team1 = 'Kings XI Punjab';

UPDATE matches
SET team2 = 'Punjab Kings'
WHERE team2 = 'Kings XI Punjab';

UPDATE matches
SET toss_winner = 'Punjab Kings'
WHERE toss_winner = 'Kings XI Punjab';

UPDATE matches
SET winner = 'Punjab Kings'
WHERE winner = 'Kings XI Punjab';

UPDATE deliveries
SET batting_team = 'Punjab Kings'
WHERE batting_team = 'Kings XI Punjab';

UPDATE deliveries
SET bowling_team = 'Punjab Kings'
WHERE bowling_team = 'Kings XI Punjab';

UPDATE matches
SET team1 = 'Delhi Capitals'
WHERE team1 = 'Delhi Daredevils';

UPDATE matches
SET team2 = 'Delhi Capitals'
WHERE team2 = 'Delhi Daredevils';

UPDATE matches
SET toss_winner = 'Delhi Capitals'
WHERE toss_winner = 'Delhi Daredevils';

UPDATE matches
SET winner = 'Delhi Capitals'
WHERE winner = 'Delhi Daredevils';

UPDATE deliveries
SET batting_team = 'Delhi Capitals'
WHERE batting_team = 'Delhi Daredevils';

UPDATE deliveries
SET bowling_team = 'Delhi Capitals'
WHERE bowling_team = 'Delhi Daredevils';

UPDATE matches
SET team1 = 'Rising Pune Supergiant'
WHERE team1 = 'Rising Pune Supergiants';

UPDATE matches
SET team2 = 'Rising Pune Supergiant'
WHERE team2 = 'Rising Pune Supergiants';

UPDATE matches
SET toss_winner = 'Rising Pune Supergiant'
WHERE toss_winner = 'Rising Pune Supergiants';

UPDATE matches
SET winner = 'Rising Pune Supergiant'
WHERE winner = 'Rising Pune Supergiants';

UPDATE deliveries
SET batting_team = 'Rising Pune Supergiant'
WHERE batting_team = 'Rising Pune Supergiants';

UPDATE deliveries
SET bowling_team = 'Rising Pune Supergiant'
WHERE bowling_team = 'Rising Pune Supergiants';
