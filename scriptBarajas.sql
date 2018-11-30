select perFirstName, perLastName, lineups.plaId, lineups.matId, lupId 
from lineups join matches 
on matches.matId = lineups.matId
join players on lineups.plaId = players.plaId
join persons on players.perId = persons.perId
where matches.matHomeTeam = lineups.teaId and matches.matId = 1;

