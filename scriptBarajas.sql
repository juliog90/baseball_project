select perFirstName, perLastName, lineups.plaId, lineups.matId, lupId 
from lineups join matches 
on matches.matId = lineups.matId
join players on lineups.plaId = players.plaId
join persons on players.perId = persons.perId
where matches.matHomeTeam = lineups.teaId and matches.matId = 1;


--mejorada
select l.lupId,pl.plaId, l.teaId,lupBattingTurn,l.posId,m.catId,matHomeTeam,matGuestTeam,matField,
matStartTime,matEndTime,matRunsHomeTeam,matRunsGuestTeam,plaImage, planumber ,perFirstName,perLastName
from lineups l join matches m 
on m.matId = l.matId
join players pl on l.plaId = pl.plaId
join persons p on pl.perId = p.perId
where m.matHomeTeam = l.teaId and m.matId = 1;