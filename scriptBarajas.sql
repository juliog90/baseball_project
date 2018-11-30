select plaId, lineups.matId, lupId, matHomeTeam from lineups join matches on matches.matId = lineups.matId
where matches.matHomeTeam = lineups.teaId and matches.matId = 1;

