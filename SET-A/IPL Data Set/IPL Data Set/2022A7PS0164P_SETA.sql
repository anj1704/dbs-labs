-- Data Base Solution Lab Test April 2024

-- Important Note:-  fill NA(not Applicable) in specific question if you are not attempting that specific question

use ipl12;
-- Q1.
select p.Name, t.Name, SUM(per.RunsScored) as total_runs
from players as p
join teams as t on t.TeamID = p.TeamID
join performance as per on per.PlayerID = p.PlayerID
group by p.PlayerID
having per.PlayerID =
(
	select per2.PlayerID from performance as per2
    where per2.RunsScored = 
		(
			select MAX(per1.RunsScored) 
			from performance per1
            where per1.PlayerID = per2.PlayerID
			group by per1.MatchID
		)
);
-- Q2.
select t.Name, COUNT(m.MatchID)
from teams t 
join matches m on m.WinnerTeamID = t.teamID
where m.VenueID = 55
group by t.TeamID;
-- Q3.
select p.Name, m.MatchID, per.WicketsTaken
from players p
join performance as per on per.PlayerID = p.PlayerID
join matches m on per.MatchID = per.MatchID
where p.Role LIKE "Bowler" AND per.WicketsTaken > 4;
-- Q4.
select v.Name, v.City, count(m.VenueID) as count_of_matches
from venues v
join matches m on m.VenueID = v.VenueID
group by v.VenueID
order by count_of_matches DESC
limit 1;
-- Q5.
select p.Name, per.WicketsTaken, per.RunsScored
from players p
join performance per on per.PlayerID = p.PlayerID
where per.WicketsTaken > 10 AND per.RunsScored > 100;
-- Q6.
select ranker.PlayerID, ranker.TeamID, ranker.WicketsTaken, ranker.RunsScored, MIN(ranker.ranks) as best_rank
from 
(
	select p1.PlayerID, p1.TeamID, per1.WicketsTaken, per1.RunsScored, rank() over (order by per1.RunsScored, per1.WicketsTaken) as ranks
	from players p1
	join performance per1 on per1.PlayerID = p1.PlayerID
) ranker
group by ranker.TeamID, ranker.PlayerID, ranker.TeamID, ranker.WicketsTaken, ranker.RunsScored
order by ranker.TeamID;

select ranker.PlayerID, ranker.TeamID, ranker.WicketsTaken, ranker.RunsScored, MIN(ranker.ranks) OVER (partition by ranker.TeamID) as best_rank
from 
(
	select p1.PlayerID, p1.TeamID, per1.WicketsTaken, per1.RunsScored, rank() over (order by per1.RunsScored, per1.WicketsTaken) as ranks
	from players p1
	join performance per1 on per1.PlayerID = p1.PlayerID
) ranker;
-- Q7.
-- NA
-- Q8.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION 
`GetBattingAverage`(PID INT) RETURNS DECIMAL(9,5)
 DETERMINISTIC
begin
declare av INT;
select SUM(per.RunsScored) over (partition by per.PlayerID)/count(*)  over (partition by per.PlayerID) as bat_av into av
from performance as per 
where per.PlayerID = PID
group by per.PerformanceID
order by bat_av desc
limit 1;
 return av;
end$$
DELIMITER ;

select GetBattingAverage(2);
-- Q9.
select per.MatchID, p.Name, per.RunsScored, per.WicketsTaken, per.CatchesTaken, 
rank() over (partition by per.MatchID, per.RunsScored + per.WicketsTaken*20 + per.CatchesTaken*10) as PerfomanceRank
from performance per
join players p on p.PlayerID = per.PlayerID
order by per.MatchID;
-- Q10.
-- NA
-- Q11.
select * from (
select p.Name as player_name, t.Name as team_name, 
	SUM(per.RunsScored) as total_runs, 
    SUM(per.WicketsTaken) as total_wickets, 
	SUM(per.CatchesTaken) as total_catches, 
    SUM(per.StumpsMade) as total_stumps
from players p
join teams t on t.TeamID = p.TeamID
join performance per on per.PlayerID = p.PlayerID
group by per.PlayerID)
PlayerPerformanceSummary;
-- Q12.
create view HighScoringVenues as
select v.Name, v.City, m.VenueID, AVG(s.Runs) as av
from matches m
join scores s on s.MatchID = m.MatchID
join venues v on v.VenueID = m.VenueID
group by s.MatchID
having  av > 150;

select * from HighScoringVenues;

