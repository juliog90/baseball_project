create table persons(
perId int primary key AUTO_INCREMENT not null,
perFirstName varchar(25) not null,
perLastName varchar(25) not null
);
alter table persons AUTO_INCREMENT=1;

create table players(
plaId int primary key AUTO_INCREMENT not null,
perId int not null, --  person id
staId tinyint not null, -- status id
teaId int, --  team id, puede no pertenecer a un equipo
plaNickname varchar(35),
plaBirthdate date not null,
plaDebut date, -- puede no haber debutado aun
plaImage varchar(50), -- puede no tener imagen supongo
plaNumber tinyint not null -- pos si no debuta no tiene numero ???, o puede que no este jugando
);
alter table  players AUTO_INCREMENT=1;

create table users(
usrId int primary key AUTO_INCREMENT not null,
perId int not null, --  person id
ulvId int not null, -- user level id
usrEmail varchar(50) not null,
usrPassword varchar(25) not null
);
alter table users AUTO_INCREMENT=1;

create table userPlayer(
plaId int not null,
usrId int not null
);
alter table userPlayer AUTO_INCREMENT=1;

create table userLevels(
ulvId int primary key AUTO_INCREMENT not null,
ulvDescription varchar(25) not null
);
alter table userLevels AUTO_INCREMENT=1;

create table coaches(
coaId int primary key AUTO_INCREMENT not null,
perId int not null -- person id
);
alter table coaches AUTO_INCREMENT=1;

create table teams(
teaId int primary key AUTO_INCREMENT not null,
staId tinyint not null,
teaName varchar(25) not null,
teaImage varchar(15) not null,
catId int not null, -- category id
coaId int not null, -- coach id
seaId int not null --  season id
);
alter table teams AUTO_INCREMENT=1;

create table status(
staId tinyint primary key not null,
staStatus varchar(25) not null
);
alter table status AUTO_INCREMENT=1;
-- ----------------------A LA HORA DE HACER EL LINE-UP ES NECESARIO HACER EL FILTRO POR 'STATUS' = 'ACTIVE'

create table playerStats(
pbsId int primary key AUTO_INCREMENT not null,
plaId int not null,
pbsPlayedGames smallint not null, -- PG
pbsWins smallint not null, -- W , G (W+L)
pbsLoses smallint not null, -- L, G
pbsHits smallint not null default 0, -- bat H
pbsHomeRuns smallint not null default 0, -- bat HR
pbsStrikes smallint not null default 0, -- bat st
pbsRuns smallint not null default 0, -- R
pbsBalls smallint not null default 0,	-- B
pbsOuts smallint not null default 0, -- O
pbsStolenBases smallint not null default 0 -- SB
);
alter table playerStats AUTO_INCREMENT=1;

create table teamStats(
tstId int primary key AUTO_INCREMENT not null,
teaId int not null,
tstWins smallint not null default 0,
tstLoses smallint not null default 0
);
alter table teamStats AUTO_INCREMENT=1;

create table categories( --  o division idk
catId int primary key AUTO_INCREMENT not null,
catName varchar(25) not null
);
alter table categories AUTO_INCREMENT=1;

create table seasons(
seaId int primary key AUTO_INCREMENT not null,
seaName varchar(25) not null
);
alter table seasons AUTO_INCREMENT=1;

create table matches(
matId int primary key AUTO_INCREMENT not null,
matHomeTeam int not null, -- team id
matGuestTeam int not null, -- team id
matField varchar(35) not null,
matStartTime datetime not null,
matEndTime datetime not null,
matRunsHomeTeam tinyint not null default 0,
matRunsGuestTeam tinyint not null default 0
--  winner deberia ser calculado no??
);
alter table matches AUTO_INCREMENT=1;

create table lineups(
lupId int primary key AUTO_INCREMENT not null,
plaId int not null, -- player id
teaId int not null, -- team id
lupBattingTurn tinyint not null,
posId char(2) not null, -- position id
matId int not null
-- se borrara al final de cada partido
);
alter table lineups AUTO_INCREMENT=1;

create table positions(
posId char(2) primary key not null,
posName varchar(25) not null
);
alter table positions AUTO_INCREMENT=1;

create table displayMatches(
matId int primary key not null, -- match id serviria de primaria tambien i guess
dmtEntry tinyint not null default 0,
dmtBatter int not null default 0, -- player id
dmtBalls tinyint not null default 0,
dmtStrikes tinyint not null default 0,
dmtOuts tinyint not null default 0,
dmtRunsHomeTeam tinyint not null default 0,
dmtRunsGuestTeam tinyint not null default 0,
dmtBase1 tinyint not null default 0, -- player id
dmtBase2 tinyint not null default 0, -- player id
dmtBase3 tinyint not null default 0 -- player id
);
alter table displayMatches AUTO_INCREMENT=1;

-- PENDIENTE de terminar (creo)
create table matchesHistory(
mthId int primary key AUTO_INCREMENT not null,
matId int not null, -- match id
plaId int not null, -- player id
-- teaId int not null, -- team id para filtro
actId char(4) not null, -- action id
mthDate datetime not null default CURRENT_TIMESTAMP, --  pues cuando
mthEntry tinyint not null -- en que entrada (servira de filtro)
);
alter table matchesHistory AUTO_INCREMENT=1;

create table actions(
actId char(4) primary key not null,
actDescription varchar(25) not null --  ball, strike, run, out,etc y donde paso en caso de ser necesario
);
alter table actions AUTO_INCREMENT=1;

/*
create table (
Id int primary key AUTO_INCREMENT not null,
);
alter table  AUTO_INCREMENT=1;
*/

-- --------------------------------------------- llaves

-- players
alter table players
add constraint FK_Person_Player foreign key (perId) references persons(perId);

alter table players
add constraint FK_Team_Player foreign key (teaId) references teams(teaId);

alter table players
add constraint FK_Status_Player foreign key (staId) references status(staId);


-- player stats
alter table playerStats
add constraint FK_Player_Stats foreign key (plaId) references players(plaId);

-- users
alter table users
add constraint FK_Person_User foreign key (perId) references persons(perId);

alter table users
add constraint FK_UserLevel_User foreign key (ulvId) references userLevels(ulvId);

-- user - player (en caso de ser un padre)

alter table userPlayer
add primary key(plaId, usrId);

alter table userPlayer
add constraint FK_User_UserPlayer foreign key (usrId) references users(usrId);

alter table userPlayer
add constraint FK_Player_UserPlayer foreign key (plaId) references players(plaId);

-- coaches
alter table coaches
add constraint FK_Person_Coach foreign key (perId) references persons(perId);

-- teams
alter table teams
add constraint FK_Coach_Team foreign key (coaId) references coaches(coaId);

alter table teams
add constraint FK_Category_Team foreign key (catId) references categories(catId);

alter table teams
add constraint FK_Status_Team foreign key (staId) references status(staId);

alter table teams
add constraint FK_Season_Team foreign key (seaId) references seasons(seaId);

-- teams stats

alter table teamStats
add constraint FK_Team_Stats foreign key (teaId) references teams(teaId);

-- lineups
alter table lineups
add constraint FK_Player_Lineup foreign key (plaId) references players(plaId);

alter table lineups
add constraint FK_Position_Lineup foreign key (posId) references positions(posId);

alter table lineups
add constraint FK_Match_Lineup foreign key (matId) references matches(matId);

-- matches
alter table matches
add constraint FK_HomeTeam_Match foreign key (matHomeTeam) references teams(teaId);

alter table matches
add constraint FK_GuestTeam_Match foreign key (matGuestTeam) references teams(teaId);


-- matches history

alter table matchesHistory
add constraint FK_Match_MatchHistory foreign key (matId) references matches(matId);

alter table matchesHistory
add constraint FK_Player_MatchHistory foreign key (plaId) references players(plaId);

alter table matchesHistory
add constraint FK_Action_MatchHistory foreign key (actId) references actions(actId);


-- displayMatches

alter table displayMatches
add constraint FK_Match_DisplayMatch foreign key (matId) references matches(matId);


-- -------------------------- views

create view MatchTeamResults
as
select m.matId,
case
when m.matRunsGuestTeam < matRunsHomeTeam then matHomeTeam
when matRunsGuestTeam > matRunsHomeTeam then matGuestTeam
else null
end W,
case
when m.matRunsGuestTeam > matRunsHomeTeam then matHomeTeam
when matRunsGuestTeam < matRunsHomeTeam then matGuestTeam
else null
end L,
case
when m.matRunsGuestTeam = matRunsHomeTeam then 1
else 0
end tie
from matches m;

-- scraped
/*
create view playerStats
as
select p.plaId id,
bs.pbsPlayedGames + count(mr.W) + count(mr.L) + count(tie) PG, -- played games
bs.pbsWins + count(mr.W) W,
bs.pbsLoses + count(mr.L) L,
bs.pbsHits + bs.pbsStrikes + (select count(*) from matcheshistory mh where mh.actId = 'H' or mh.actId = 'st' and mh.plaId = bs.plaId) bats,
bs.pbsHits + (select count(*) from matcheshistory mh where mh.actId = 'H' and mh.plaId = bs.plaId) H,
bs.pbsHits + bs.pbsHomeRuns + (select count(*) from matcheshistory mh where mh.actId = 'H' or mh.actId = 'HR' and mh.plaId = bs.plaId) HR,
bs.pbsStrikes + (select count(*) from matcheshistory mh where mh.actId = 'st' and mh.plaId = bs.plaId) strikes,
bs.pbsRuns + (select count(*) from matcheshistory mh where mh.actId = 'R' and mh.plaId = bs.plaId) R,
bs.pbsBalls + (select count(*) from matcheshistory mh where mh.actId = 'B' and mh.plaId = bs.plaId) B,
bs.pbsOuts + (select count(*) from matcheshistory mh where mh.actId = 'GO' or mh.actId = 'FO' and mh.plaId = bs.plaId) O,
bs.pbsStolenBases + (select count(*) from matcheshistory mh where mh.actId = 'SB' and mh.plaId = bs.plaId) SB
from players p
join playerStats bs on p.plaId = bs.plaId
join matchesHistory mh on p.plaId = mh.plaId
join MatchTeamResults mr on mr.matId = mh.matId
where mr.tie is not 0
*/

-- --------------------- static inserts

-- actions
insert into actions (actId, actDescription) VALUES
('H', 'Hit'),
('HR', 'Home Run'),
('st', 'Strike'),
('R', 'Run'),
('B', 'Ball'),
('FO', 'Fly Out'),
('GO', 'Ground Out'),
('SB', 'Stolen Base');

-- status
insert into status (staId, staStatus) VALUES
(1, 'Active'),
(2, 'Inactive'),
(3, 'Wounded');


-- positions

insert into positions (posId, posName) VALUES
('P', 'Pitcher'),
('C', 'Catcher'),
('1B', 'First Base'),
('2B', 'Second Base'),
('3B', 'Third Base'),
('SS', 'Short Stop'),
('CF', 'Center Field'),
('LF', 'Left Field'),
('RF', 'RightField');

-- user levels

insert into userLevels (ulvId, ulvDescription) VALUES
(1, 'Viewer'),
(2, 'Tutor'),
(3, 'Coach'),
(4, 'Scorekeeper'),
(5, 'Admin');
-- Persons
-- Coaches
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nero","Mcleod");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kane","Glenn");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hamilton","Austin");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nicholas","Morin");
-- Jugadores
-- Equipo 1-1
INSERT INTO persons (perFirstName,perLastName) VALUES ("Abel","Lewis");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ivan","Woodward");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Rogan","Lopez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cairo","Mcpherson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Christopher","Hansen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jelani","Castillo");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ishmael","George");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Fitzgerald","Lang");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Alfonso","Santana");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Rudyard","Murray");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kibo","Rivas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kenneth","Greene");
-- equipo 1-2
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wayne","Gibbs");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Zeph","Ortega");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Rogan","Huff");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Scott","Velasquez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Adam","Wooten");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Addison","Santana");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Basil","Campos");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Yuli","Mcdaniel");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tarik","Bruce");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Orlando","Booth");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Curran","Booth");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kelly","Campbell");
-- equipo 1-3
INSERT INTO persons (perFirstName,perLastName) VALUES ("Elmo","Salas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Upton","Stark");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Oscar","Mcknight");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mohammad","Hays");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Driscoll","Serrano");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Erasmus","Ingram");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Carter","Alford");
-- Mujeres
---------------------
INSERT INTO persons (perFirstName,perLastName) VALUES ("Laurel","Horne");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Xantha","Soto");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Iona","Haynes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Christine","Mooney");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wendy","Ferguson");
--- Termina 3 equipos
-- Jugadores segunda inserccion 51 en adelante
-- equipo 1-4
INSERT INTO persons (perFirstName,perLastName) VALUES ("Martin","Spence");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cade","Mclaughlin");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nicholas","Hensley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jerome","Nguyen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Talon","Mosley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Amos","Banks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ferris","Figueroa");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Fritz","Berger");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Grant","Lindsey");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Lewis","Guy");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Stuart","Meadows");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Stephany","Carroll");
-- equipo 2-1
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dalton","Duncan");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Alden","Wheeler");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Shad","Zimmerman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Aidan","Burgess");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Carter","Henry");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dustin","Odonnell");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Donovan","Drake");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Zachery","Carrillo");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Zachary","Howe");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Reese","Ochoa");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wing","Carson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mary","Reynolds");
-- equipo 2-2
INSERT INTO persons (perFirstName,perLastName) VALUES ("Damian","Norman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hiram","Franco");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jonas","Clements");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Castor","Baird");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tobias","Knowles");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Troy","Rodriquez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Slade","David");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Sawyer","Travis");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Joel","Hendricks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dane","Anthony");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ishmael","Buckner");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Driscoll","Cochran");
-- equipo 2-3
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kasimir","Mayo");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Carl","Cantrell");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Philip","Roberts");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Brendan","Daniels");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Harding","Parrish");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wang","Mccarty");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Carson","Guerra");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Marsden","Booth");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Sebastian","Rivers");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Solomon","Douglas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Erasmus","Stevens");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Vannesa","Brock");
-- equipo 2-4
INSERT INTO persons (perFirstName,perLastName) VALUES ("Christian","Schwartz");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Quentin","Mcfarland");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Akeem","Mcmillan");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kibo","Mcfadden");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Raymond","Ryan");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Davis","Hobbs");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Amos","Gentry");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dustin","Mcmillan");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Price","Lucas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mohammad","Dixon");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Caleb","Houston");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nicole","Marquez");
-- equipo 3-1
INSERT INTO persons (perFirstName,perLastName) VALUES ("Murphy","Poole");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Colorado","Burgess");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kelly","House");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Malachi","Clarke");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Abel","Dickson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mufutau","Hebert");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kenyon","Hunt");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hayden","Brown");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Gregory","Barker");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cody","Sosa");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mason","James");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Brenda","Shields");
-- equipo 3-2
INSERT INTO persons (perFirstName,perLastName) VALUES ("Emery","Haynes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Barry","Flores");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Levi","Wiley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Drake","Moss");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Micah","Lucas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Erich","Phillips");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Anthony","Burton");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Oleg","Herring");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Blake","Mckinney");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dean","Kelley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Russell","Everett");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dennise","Poole");
-- equipo 3-3
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nehru","Riddle");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Darius","Mueller");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Logan","Atkins");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Abbot","Acosta");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ethan","Newman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Baxter","Nichols");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ivan","Singleton");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Joseph","Mcleod");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Todd","Giles");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Yuli","Anderson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jesse","Glenn");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Clarisse","England");
-- equipo 3-4
INSERT INTO persons (perFirstName,perLastName) VALUES ("Walker","Burnett");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Timothy","Wilder");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kane","Lucas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Caesar","Wade");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Stephen","Irwin");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Rudyard","Barrera");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Malik","Guthrie");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jonah","Todd");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Judah","Hardy");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cooper","Harvey");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mason","Howard");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nasima","Middleton");
-- equipo 4-1
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nolan","Rodriguez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Camden","Luna");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Benedict","Stone");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Gray","Dunlap");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Travis","Higgins");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Preston","Ramsey");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Colorado","Allen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Slade","Sloan");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hall","Taylor");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cameron","Gilbert");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ulric","Sampson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Gray","Valentine");
-- equipo 4-2
INSERT INTO persons (perFirstName,perLastName) VALUES ("Benedict","Rowe");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Simon","Webb");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ivan","Wade");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Vaughan","Gay");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Eric","Chambers");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Callum","Henderson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tucker","Wyatt");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Reece","Mcdonald");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Grady","Cooper");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Alfonso","Ballard");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Christian","Gallegos");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ramona","Casey");
-- equipo 4-3
INSERT INTO persons (perFirstName,perLastName) VALUES ("Eric","Mckee");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Bert","Orr");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kasimir","Gutierrez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Francis","Sherman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Lee","Santana");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tyrone","Ramirez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Benedict","Knapp");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Martin","Bradley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tobias","Mcdowell");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Neville","Wiggins");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Emery","Slater");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Fernanda","Maldonado");
-- equipo 4-4
INSERT INTO persons (perFirstName,perLastName) VALUES ("Forrest","Blankenship");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wesley","Hanson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mark","Rowe");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Daquan","Bauer");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tucker","Alston");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Melvin","Hughes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Drew","Castillo");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Arden","Mccarthy");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Elijah","Hood");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Zachery","Pitts");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Holmes","Moon");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Pamela","Nunez");
-- equipo 5-1
INSERT INTO persons (perFirstName,perLastName) VALUES ("Abel","Diaz");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wyatt","Chang");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jin","Chapman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Robert","Riggs");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Lyle","Dorsey");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hashim","Hart");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jackson","Garza");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Upton","Nguyen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Thane","Spencer");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Yuli","Kidd");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ian","Martinez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Merlinda","Baldwin");
-- equipo 5-2
INSERT INTO persons (perFirstName,perLastName) VALUES ("Scott","Bowen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kasimir","Riley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Macon","Wise");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Leonard","Mcguire");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Baxter","Olsen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ulysses","Holmes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Marsden","Barry");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Merritt","Herring");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Zeph","Kidd");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kenyon","Calhoun");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Aristotle","Garza");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Linda","Wood");
-- equipo 5-3
INSERT INTO persons (perFirstName,perLastName) VALUES ("Branden","Rosales");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Emerson","Morales");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Raymond","Hays");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Lionel","Adams");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kadeem","Whitaker");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mark","Nielsen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Driscoll","Guthrie");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Victor","Mcfarland");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Martin","Moss");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Giacomo","Mcneil");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Sylvester","Ryan");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Josefina","Haynes");
-- equipo 5-4
INSERT INTO persons (perFirstName,perLastName) VALUES ("Nero","Tillman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mannix","Carlson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Andrew","Mayer");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Garrett","Dawson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Sawyer","Hall");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hasad","Eaton");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Isaiah","Merrill");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jonah","Carroll");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Damian","Matthews");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Caesar","Bradshaw");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Byron","Carver");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Susana","Gutierrez");
-- equipo 6-1
INSERT INTO persons (perFirstName,perLastName) VALUES ("Lane","Hendricks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Richard","Ochoa");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cedric","Wallace");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Colby","Salas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Merritt","Mcbride");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ralph","Kelly");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Aladdin","Hicks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Thane","Fuentes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Austin","Miranda");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Grady","Patterson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Palmer","Sherman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Martha","Glenn");
-- equipo 6-2
INSERT INTO persons (perFirstName,perLastName) VALUES ("Plato","Gallegos");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wallace","Foreman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Sean","Cooper");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Matthew","Washington");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Eagan","Dickson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dustin","Rosa");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jasper","Maxwell");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Byron","Schroeder");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tyler","Coffey");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dexter","Durham");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Scott","Campbell");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Teresa","Church");
-- equipo 6-3
INSERT INTO persons (perFirstName,perLastName) VALUES ("Benjamin","Sharpe");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dennis","Simon");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Oliver","Christian");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tyrone","Rivers");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cade","Key");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Noble","Small");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Lewis","Koch");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jackson","Mosley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Rashad","Mccoy");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Daquan","Williamson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Oren","Mann");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dorothy","Lowe");
-- equipo 6-4
INSERT INTO persons (perFirstName,perLastName) VALUES ("Timothy","Hendricks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Gannon","Bowman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Martin","Michael");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Emmanuel","Farrell");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Colby","French");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kieran","Michael");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Fitzgerald","Meyer");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Connor","Kinney");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Davis","Lawrence");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cullen","Baker");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Xavier","Gaines");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Seledonia","Haney");
-- equipo 7-1
INSERT INTO persons (perFirstName,perLastName) VALUES ("Vance","Horton");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Sebastian","Blake");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mannix","Salas");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Mufutau","Ward");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Herman","Houston");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tucker","Keller");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Tucker","Burks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Baxter","Olson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Bernard","Morton");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Vernon","Alvarado");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Baker","Sampson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Maggy","Herman");
-- equipo 7-2
INSERT INTO persons (perFirstName,perLastName) VALUES ("Blaze","Burks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Damon","Henry");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kenyon","Stark");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Malik","Gould");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Solomon","Mckenzie");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Harding","Powers");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Marsden","Kinney");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Howard","Phillips");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wesley","Tyson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Gary","Olsen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Burke","Vazquez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Karen","Thompson");
-- equipo 7-3
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kenyon","Watkins");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dolan","Ewing");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Judah","Johnston");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Oscar","Neal");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Erasmus","Atkins");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hop","Meadows");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Zeph","Alvarez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Byron","Pitts");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kamal","Sims");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Erich","Hamilton");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Erasmus","James");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Erika","Best");
-- equipo 7-4
INSERT INTO persons (perFirstName,perLastName) VALUES ("Herrod","Monroe");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ralph","Sims");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kane","Rosa");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Declan","Daugherty");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Abraham","Ayala");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Sebastian","Kent");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Chase","Simon");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Oren","Hooper");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Byron","Ross");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Gil","Hubbard");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Salvador","Doyle");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dana","Stafford");

-- mas coaches
INSERT INTO persons (perFirstName,perLastName) VALUES ("Emery","Gould");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Owen","Allen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Donovan","Hicks");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Fuller","Allen");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Baxter","Sykes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Howard","Lambert");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Keaton","Skinner");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jason","Patrick");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Alan","Montgomery");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Fitzgerald","Nash");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Ciaran","Romero");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Hu","Chan");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Darius","Lowery");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Raja","Davis");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Lee","Donaldson");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Elijah","Lang");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Wang","Sheppard");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Micah","Reyes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Kennan","Conley");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Todd","Pittman");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Steel","Sanchez");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Dean","Reyes");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Cadman","Rice");
INSERT INTO persons (perFirstName,perLastName) VALUES ("Jarrod","Sargent");
insert into categories(catName) values('Biberon'),('Escuelita'),('Peewee'),('Infantil'),('Pony'),('Colt'),('Juvenil');
insert into seasons(seaName) values
('Spring 2010'),
('Summer 2010'),
('Autumn 2010'),
('Winter 2010'),
('Spring 2011'),
('Summer 2011'),
('Autumn 2011'),
('Winter 2011'),
('Spring 2012'),
('Summer 2012'),
('Autumn 2012'),
('Winter 2012'),
('Spring 2013'),
('Summer 2013'),
('Autumn 2013'),
('Winter 2013'),
('Spring 2014'),
('Summer 2014'),
('Autumn 2014'),
('Winter 2014'),
('Spring 2015'),
('Summer 2015'),
('Autumn 2015'),
('Winter 2015'),
('Spring 2016'),
('Summer 2016'),
('Autumn 2016'),
('Winter 2016'),
('Spring 2017'),
('Summer 2017'),
('Autumn 2017'),
('Winter 2017'),
('Spring 2018'),
('Summer 2018'),
('Autumn 2018'),
('Winter 2018');
insert into coaches(perId)
values (1),
       (2),
       (3),
       (4),
       (341),
       (342),
       (343),
       (344),
       (345),
       (346),
       (347),
       (348),
       (349),
       (350),
       (351),
       (352),
       (353),
       (354),
       (355),
       (356),
       (357),
       (358),
       (359),
       (360),
       (361),
       (362),
       (363),
       (364);
insert into teams(staId, teaName, teaImage, catId, coaId, seaId) values
-- Categoria Biberon
(1, 'The Hitmen', 'team1.png', 1, 1, 36),
(1, 'Sliders', 'team2.png', 1, 2, 36),
(1, 'Boomers', 'team3.png', 1, 3, 36),
(1, 'Rhinos', 'team4.png', 1, 4, 36),
-- Categoria Escuelita
(1, 'Bearcats', 'team5.png', 1, 5, 36),
(1, 'Travelers', 'team6.png', 1, 6, 36),
(1, 'Tigers', 'team7.png', 1, 7, 36),
(1, 'Defenders', 'team8.png', 1, 8, 36),
-- Categoria Peweee
(1, 'Whitecaps', 'team9.png', 1, 9, 36),
(1, 'Blue Birds', 'team10.png', 1, 10, 36),
(1, 'Flyers', 'team11.png', 1, 11, 36),
(1, 'Raptors', 'team12.png', 1, 12, 36),
-- Categoria Infantil
(1, 'Mexicans', 'team13.png', 1, 1, 36),
(1, 'The Bandits', 'team14.png', 1, 14, 36),
(1, 'Perfecto\'s', 'team15.png', 1, 15, 36),
(1, 'The Wild', 'team16.png', 1, 16, 36),
-- Categoria Pony
(1, 'Falcons', 'team17.png', 1, 17, 36),
(1, 'Marlins', 'team18.png', 1, 18, 36),
(1, 'Flash', 'team19.png', 1, 19, 36),
(1, 'Homers', 'team20.png', 1, 20, 36),
-- Categoria Colt
(1, 'Nuggets', 'team21.png', 1, 21, 36),
(1, 'Rampage', 'team22.png', 1, 22, 36),
(1, 'Marlins', 'team23.png', 1, 23, 36),
(1, 'Saints', 'team24.png', 1, 24, 36),
-- Categoria Juvenil
(1, 'Sounders', 'team25.png', 1, 25, 36),
(1, 'Independence', 'team26.png', 1, 26, 36),
(1, 'Tsunami', 'team27.png', 1, 27, 36),
(1, 'Pistons', 'team28.png', 1, 28, 36);
insert into players(perId, staId, teaId, plaNickname, plaBirthdate, plaDebut, plaImage, plaNumber) values
-- Biberon
-- Jugadores Equipo 1
(5,1, 1, 'minislugger', '2013-10-05', '2016-08-07', 'player1.png', 6),
(6,1, 1, 'undertaker','2012-11-05','2017-05-05','player2.png' ,60),
(7,1, 1,  'machine',  '2012-12-03','2017-05-18','player3.png' ,81),
(8,1, 1,  'beau',     '2012-12-10','2017-05-26','player4.png' ,51),
(9,1, 1,  'bullet',   '2012-12-17','2017-05-30','player5.png' ,23),
(10,1, 1, 'bash',     '2013-01-14','2017-06-13','player6.png' ,62),
(11,1, 1, 'guns',     '2013-01-21','2017-06-14','player7.png' ,68),
(12,1, 1, 'shade',    '2013-01-28','2017-06-20','player8.png' ,13),
(13,1, 1, 'rip',      '2013-03-11','2017-09-01','player9.png' ,37),
(14,1, 1, 'poncho',   '2013-03-18','2017-09-20','player10.png',87),
(15,1, 1, 'double',   '2013-04-01','2017-09-22','player11.png',8 ),
(16,1, 1, 'pogo',     '2013-04-08','2017-09-28','player12.png',74),
-- jugadoes equipo 2
(17,1, 2, 'genius',   '2013-04-15','2017-10-06','player13.png',85),
(18,1, 2, 'moose',    '2013-04-22','2017-10-24','player14.png',18),
(19,1, 2, 'deedee',   '2013-05-06','2017-10-26','player15.png',44),
(20,1, 2, 'bird',     '2013-06-03','2017-11-09','player16.png',55),
(21,1, 2, 'scoop',    '2013-06-10','2017-11-16','player17.png',35),
(22,1, 2, 'lock',     '2013-07-01','2017-11-24','player18.png',81),
(23,1, 2, 'hooks',    '2013-07-22','2017-12-14','player19.png',75),
(24,1, 2, 'slide',    '2012-10-30','2017-12-20','player20.png',39),
(25,1, 2, 'fancy',    '2012-11-06','2018-01-10','player21.png',19),
(26,1, 2, 'horse',    '2012-12-20','2018-01-31','player22.png',25),
(27,1, 2, 'groovy',   '2012-12-26','2018-03-09','player23.png',38),
(28,1, 2, 'dice',     '2013-02-07','2018-03-27','player24.png',85),
-- jugadores equipo 3
(29,1, 3, 'sparky',   '2013-02-12','2018-03-28','player25.png',92),
(30,1, 3, 'fire',     '2013-02-19','2018-05-29','player26.png',87),
(31,1, 3, 'duke',     '2013-03-21','2017-05-10','player27.png',10),
(32,1, 3, 'snake',    '2013-03-26','2017-05-24','player28.png',47),
(33,1, 3, 'freak',    '2013-03-28','2017-06-02','player29.png',63),
(34,1, 3, 'jolly',    '2013-04-16','2017-06-08','player30.png',29),
(35,1, 3, 'bo',       '2013-04-17','2017-06-09','player31.png',70),
(36,1, 3, 'flash',    '2013-04-25','2017-06-27','player32.png',93),
(37,1, 3, 'gibbs',    '2013-05-15','2017-07-12','player33.png',29),
(38,1, 3, 'pretzel',  '2013-06-11','2017-07-21','player34.png',52),
(39,1, 3, 'blondie',  '2013-07-10','2017-08-03','player35.png',26),
(40,1, 3, 'turk',     '2013-07-16','2017-08-10','player36.png',64),
-- segunda ola de inserciones
-- equipo 4
(41 ,1,1, 'gorillamp'    ,'2012-12-24','2018-04-28','player37.png',87),        
(42 ,1,1, 'gringoliath'  ,'2013-01-21','2018-06-29','player38.png',82),
(43 ,1,1, 'scraptor'     ,'2013-02-10','2017-06-10','player39.png',5),
(44 ,1,1, 'sha-doh'      ,'2013-02-24','2017-06-24','player41.png',42),
(45 ,1,1, 'amazingcoffee','2013-03-05','2017-07-02','player42.png',58),
(46 ,1,1, 'meanfox'      ,'2013-03-19','2017-07-08','player43.png',24),
(47 ,1,1, 'spotlessguy'  ,'2013-03-26','2017-07-09','player44.png',65),
(48 ,1,1, 'brightcolonel','2013-04-15','2017-07-27','player45.png',88),
(49 ,1,1, 'starkkit'     ,'2013-04-27','2017-08-12','player46.png',24),
(50 ,1,1, 'fruitpug'     ,'2013-05-12','2017-08-21','player47.png',47),
(51 ,1,1, 'amigoliath'   ,'2013-05-14','2017-09-03','player48.png',21),
(52 ,1,1, 'masteroid'    ,'2013-05-15','2017-09-10','player49.png',59),
-- escuelita
-- equipo 1
(53 ,1,2, 'sealixir'         ,'2010-11-23', '2016-12-15', 'player50.png',43),
(54 ,1,2, 'amighost'         ,'2010-12-03', '2017-01-05', 'player51.png',26),
(55 ,1,2, 'feistyrhino'      ,'2011-01-26', '2017-01-31', 'player52.png',27),
(56 ,1,2, 'trustywerewolf'   ,'2011-02-01', '2017-03-06', 'player53.png',9 ),
(57 ,1,2, 'rockmantis'       ,'2011-02-15', '2017-04-07', 'player54.png',69),
(58 ,1,2, 'phonycoconut'     ,'2011-03-23', '2017-05-03', 'player55.png',29),
(59 ,1,2, 'filthyrhino'      ,'2011-04-02', '2017-05-08', 'player56.png',37),
(60 ,1,2, 'bouncingcranberry','2011-04-18', '2017-06-29', 'player57.png',91),
(61 ,1,2, 'bambinosaur'      ,'2011-05-09', '2017-08-17', 'player58.png',78),
(62 ,1,2, 'panthermal'       ,'2011-05-12', '2017-10-16', 'player59.png',63),
(63 ,1,2, 'leopardon'        ,'2011-05-13', '2017-11-22', 'player60.png',10),
(64 ,1,2, 'dwarvos'          ,'2011-05-14', '2017-12-07', 'player61.png',92),
(65 ,1,2, 'antiqueape'       ,'2011-05-28', '2017-12-15', 'player62.png',11),
(66 ,1,2, 'riddlemallard'    ,'2011-06-05', '2018-01-22', 'player63.png',83),
(67 ,1,2, 'traveldroid'      ,'2011-06-17', '2018-02-04', 'player64.png',3 ),
(68 ,1,2, 'silversalmon'     ,'2011-06-23', '2018-02-13', 'player65.png',18),
(69 ,1,2, 'complexemu'       ,'2011-08-01', '2018-02-16', 'player66.png',9 ),
(70 ,1,2, 'enchantedgangster','2011-08-04', '2018-02-27', 'player67.png',38),
(71 ,1,2, 'turkiwi'          ,'2011-08-07', '2018-04-29', 'player68.png',56),
(72 ,1,2, 'wallaby'          ,'2011-08-18', '2018-05-11', 'player69.png',91),
(73 ,1,2, 'bambooccaneer'    ,'2011-08-21', '2018-06-24', 'player70.png',74),
(74 ,1,2, 'falcondor'        ,'2011-08-26', '2018-06-27', 'player71.png',34),
(75 ,1,2, 'swiftpredator'    ,'2011-09-08', '2018-07-04', 'player72.png',71),
(76 ,1,2, 'candypattern'     ,'2011-09-17', '2018-07-22', 'player73.png',73),
(77 ,1,2, 'handsomeurchin'   ,'2011-09-18', '2018-08-07', 'player74.png',90),
(78 ,1,2, 'carefuldove'      ,'2010-11-30', '2016-11-28', 'player75.png',61),
(79 ,1,2, 'rustyblizzard'    ,'2010-12-03', '2016-12-06', 'player76.png',41),
(80 ,1,2, 'purepheasant'     ,'2010-12-04', '2017-01-19', 'player77.png',68),
(81 ,1,2, 'devile'           ,'2010-12-05', '2017-02-02', 'player78.png',38),
(82 ,1,2, 'stingraycharles'  ,'2010-12-10', '2017-02-17', 'player79.png',41),
(83 ,1,2, 'guineapiggy'      ,'2010-12-20', '2017-03-19', 'player80.png',31),
(84 ,1,2, 'fellama'          ,'2011-01-02', '2017-03-23', 'player81.png',41),
(85 ,1,2, 'smoothbuffalo'    ,'2011-01-14', '2017-05-15', 'player82.png',55),
(86 ,1,2, 'autumnwallaby'    ,'2011-02-09', '2017-06-28', 'player83.png',20),
(87 ,1,2, 'fruitvanilla'     ,'2011-02-10', '2017-07-01', 'player84.png',65),
(88 ,1,2, 'miniant'          ,'2011-02-28', '2017-07-02', 'player85.png',94),
(89 ,1,2, 'memorykit'        ,'2011-03-05', '2017-07-03', 'player86.png',37),
(90 ,1,2, 'lakefrogger'      ,'2011-04-14', '2017-08-15', 'player87.png',25),
(91 ,1,2, 'lockroach'        ,'2011-05-16', '2017-09-13', 'player88.png',73),
(92 ,1,2, 'lazyhazy'         ,'2011-05-17', '2017-11-15', 'player89.png',55),
(93 ,1,2, 'daemonkey'        ,'2011-05-28', '2017-12-02', 'player90.png',18),
(94 ,1,2, 'knighttime'       ,'2011-06-27', '2017-12-17', 'player91.png',80),
(95 ,1,2, 'glamorousbadger'  ,'2011-07-20', '2017-12-27', 'player92.png',69),
(96 ,1,2, 'classicwasp'      ,'2011-07-30', '2018-01-10', 'player93.png',99),
(97 ,1,2, 'formalpineapple'  ,'2011-08-02', '2018-01-11', 'player94.png',99),
(98 ,1,2, 'diettucan'        ,'2011-08-03', '2018-03-31', 'player95.png',19),
(99 ,1,2, 'flamehazelnut'    ,'2011-08-20', '2018-05-04', 'player96.png',42),
(100,1,2, 'hammerpriestess'  ,'2011-08-21', '2018-08-11', 'player97.png',93),
(101,1,3, 'lamaster'           ,'2009-12-07','2016-04-21','player98.png',75), 
(102,1,3, 'archlizard'         ,'2009-12-21','2016-06-27','player99.png',14),
(103,1,3, 'hippony'            ,'2010-01-14','2016-10-06','player100.png',75),
(104,1,3, 'hedgehogger'        ,'2010-02-01','2016-10-15','player101.png',86),
(105,1,3, 'coldsparks'         ,'2010-02-06','2016-11-07','player102.png',58),
(106,1,3, 'coldmonster'        ,'2010-02-28','2016-12-28','player103.png',52),
(107,1,3, 'vainsalmon'         ,'2010-03-24','2017-02-13','player104.png',19),
(108,1,3, 'dapperblizzard'     ,'2010-03-28','2017-04-14','player105.png',72),
(109,1,3, 'tiredduck'          ,'2010-04-03','2017-05-20','player106.png',54),
(110,1,3, 'virtualpython'      ,'2010-04-14','2017-07-07','player107.png',31),
(111,1,3, 'ostritches'         ,'2010-04-24','2017-11-07','player108.png',25),
(112,1,3, 'blazebra'           ,'2010-04-29','2017-11-23','player109.png',62),
(113,1,3, 'wolveriot'          ,'2010-05-06','2017-12-17','player110.png',38),
(114,1,3, 'stenchanter'        ,'2010-05-08','2018-01-01','player111.png',84),
(115,1,3, 'roadbeetle'         ,'2010-05-21','2018-01-15','player112.png',57),
(116,1,3, 'arcticfrogger'      ,'2010-06-17','2018-03-02','player113.png',36),
(117,1,3, 'slowviper'          ,'2010-06-18','2018-03-24','player114.png',16),
(118,1,3, 'actionpiglet'       ,'2010-07-11','2018-05-23','player115.png',13),
(119,1,3, 'sadterror'          ,'2010-07-21','2018-06-20','player116.png',34),
(120,1,3, 'chillykitty'        ,'2010-07-25','2018-07-09','player117.png',54),
(121,1,3, 'pandame'            ,'2010-07-29','2018-07-12','player118.png',69),
(122,1,3, 'pixelephant'        ,'2010-08-20','2018-07-28','player119.png',69),
(123,1,3, 'antiger'            ,'2010-08-29','2018-08-14','player120.png',80),
(124,1,3, 'cheatah'            ,'2010-09-05','2018-09-05','player121.png',58),
(125,1,3, 'naughtyrogue'       ,'2010-09-10','2018-09-10','player122.png',2 ),
(126,1,3, 'giantfowl'          ,'2009-12-05','2015-12-10','player123.png',79),
(127,1,3, 'dirtycat'           ,'2009-12-07','2016-02-15','player124.png',82),
(128,1,3, 'intelligentnymph'   ,'2009-12-13','2016-04-01','player125.png',77),
(129,1,3, 'mysterioushalfling' ,'2009-12-19','2016-08-19','player126.png',15),
(130,1,3, 'heartpie'           ,'2009-12-28','2017-01-22','player127.png',90),
(131,1,3, 'rangutangle'        ,'2010-01-01','2017-04-22','player128.png',84),
(132,1,3, 'dinoscythe'         ,'2010-01-12','2017-04-23','player129.png',46),
(133,1,3, 'victorc'            ,'2010-02-17','2017-04-30','player130.png',93),
(134,1,3, 'porcupid'           ,'2010-03-10','2017-07-08','player131.png',27),
(135,1,3, 'dopeymuppet'        ,'2010-03-13','2017-07-21','player132.png',57),
(136,1,3, 'primemermaid'       ,'2010-03-15','2017-09-12','player133.png',12),
(137,1,3, 'cannonfrog'         ,'2010-03-19','2017-09-15','player134.png',74),
(138,1,3, 'crownhippo'         ,'2010-03-22','2017-10-05','player135.png',61),
(139,1,3, 'famousstorm'        ,'2010-04-03','2017-10-25','player136.png',96),
(140,1,3, 'gothiccyborg'       ,'2010-05-09','2017-11-05','player137.png',47),
(141,1,3, 'caterpixie'         ,'2010-05-11','2017-11-15','player138.png',38),
(142,1,3, 'demonkey'           ,'2010-05-14','2017-12-13','player139.png',59),
(143,1,3, 'fellama'            ,'2010-06-01','2018-01-29','player140.png',7 ),
(144,1,3, 'oysterminate'       ,'2010-06-04','2018-03-10','player141.png',59),
(145,1,3, 'loyalrascal'        ,'2010-06-17','2018-03-19','player142.png',48),
(146,1,3, 'needylice'          ,'2010-06-18','2018-04-02','player143.png',28),
(147,1,3, 'lunchbear'          ,'2010-06-24','2018-05-07','player144.png',74),
(148,1,3, 'hollowdoughnut'     ,'2010-06-25','2018-05-09','player145.png',74),
(149,1,4, 'lightningfurry'       ,'2008-11-30', '2014-11-2','player146.png',76),
(150,1,4, 'primespider'          ,'2008-12-07', '2015-02-0','player147.png',13),
(151,1,4, 'commandroid'          ,'2008-12-17', '2015-08-3','player148.png',34),
(152,1,4, 'tomatoad'             ,'2008-12-20', '2015-09-2','player149.png',97),
(153,1,4, 'hypnotastic'          ,'2008-12-27', '2015-11-0','player150.png',46),
(154,1,4, 'turbanshee'           ,'2009-01-24', '2015-11-1','player151.png',24),
(155,1,4, 'dietlord'             ,'2009-01-30', '2015-12-0','player152.png',90),
(156,1,4, 'smilingpegasus'       ,'2009-02-07', '2016-04-2','player153.png',55),
(157,1,4, 'hearttoad'            ,'2009-02-08', '2016-06-0','player154.png',80),
(158,1,4, 'gardenduck'           ,'2009-02-11', '2016-06-1','player155.png',71),
(159,1,4, 'frostygod'            ,'2009-03-18', '2016-07-0','player156.png',35),
(160,1,4, 'expertgrasshopper'    ,'2009-03-20', '2016-07-2','player157.png',44),
(161,1,4, 'vulturret'            ,'2009-04-02', '2016-10-1','player158.png',94),
(162,1,4, 'decorsair'            ,'2009-04-24', '2016-12-2','player159.png',68),
(163,1,4, 'griffinish'           ,'2009-05-09', '2017-03-1','player160.png',61),
(164,1,4, 'sincubus'             ,'2009-05-10', '2017-04-0','player161.png',21),
(165,1,4, 'insecuresquirrel'     ,'2009-05-12', '2017-05-1','player162.png',38),
(166,1,4, 'ninjapattern'         ,'2009-05-15', '2017-05-1','player163.png',99),
(167,1,4, 'scentedmango'         ,'2009-06-09', '2017-06-2','player164.png',44),
(168,1,4, 'battleogre'           ,'2009-06-25', '2017-11-0','player165.png',14),
(169,1,4, 'spookygeneral'        ,'2009-07-07', '2017-11-0','player166.png',84),
(170,1,4, 'forestenigma'         ,'2009-07-22', '2017-12-0','player167.png',86),
(171,1,4, 'nitwitch'             ,'2009-08-08', '2018-01-2','player168.png',43),
(172,1,4, 'gamerman'             ,'2009-08-12', '2018-03-0','player169.png',98),
(173,1,4, 'goghost'              ,'2009-08-24', '2018-05-1','player170.png',99),
(174,1,4, 'brasshopper'          ,'2008-12-07', '2015-01-0','player171.png',91),
(175,1,4, 'digitalnightelf'      ,'2008-12-19', '2015-01-2','player172.png',64),
(176,1,4, 'paperparrot'          ,'2008-12-26', '2015-02-0','player173.png',35),
(177,1,4, 'weirdfalcon'          ,'2009-01-19', '2015-02-1','player174.png',75),
(178,1,4, 'heartrat'             ,'2009-01-23', '2015-02-2','player175.png',19),
(179,1,4, 'caringdonkey'         ,'2009-01-28', '2015-03-1','player176.png',55),
(180,1,4, 'dimmaple'             ,'2009-01-31', '2015-04-1','player177.png',72),
(181,1,4, 'crickettle'           ,'2009-02-02', '2015-11-0','player178.png',60),
(182,1,4, 'kangarookie'          ,'2009-02-14', '2015-11-2','player179.png',6 ),
(183,1,4, 'capeshifter'          ,'2009-02-18', '2016-03-3','player180.png',92),
(184,1,4, 'ibiscuit'             ,'2009-03-09', '2016-04-2','player181.png',12),
(185,1,4, 'ancientrascal'        ,'2009-03-16', '2016-04-2','player182.png',53),
(186,1,4, 'scentedbeetle'        ,'2009-05-09', '2016-05-1','player183.png',20),
(187,1,4, 'oceanandroid'         ,'2009-05-10', '2016-07-0','player184.png',95),
(188,1,4, 'plushcat'             ,'2009-05-11', '2016-07-2','player185.png',61),
(189,1,4, 'antiquehorse'         ,'2009-06-13', '2017-04-1','player186.png',24),
(190,1,4, 'smilingcake'          ,'2009-06-27', '2017-05-2','player187.png',65),
(191,1,4, 'wrathhawk'            ,'2009-07-03', '2017-05-2','player188.png',60),
(192,1,4, 'devile'               ,'2009-07-22', '2017-06-1','player189.png',17),
(193,1,4, 'elephantom'           ,'2009-07-26', '2017-10-0','player190.png',79),
(194,1,4, 'candroid'             ,'2009-08-15', '2017-10-1','player191.png',58),
(195,1,4, 'sneakybandit'         ,'2009-08-16', '2017-10-2','player192.png',95),
(196,1,4, 'blushingdroid'        ,'2009-08-17', '2018-02-2','player193.png',62),
(197,1,5, 'surpriselime'         ,'2007-11-30', '2013-10-2','player194.png',81),
(198,1,5, 'sandmachine'          ,'2007-12-07', '2014-01-0','player195.png',44),
(199,1,5, 'quietpotato'          ,'2007-12-17', '2014-07-3','player196.png',46),
(200,1,5, 'surprisehopper'       ,'2007-12-20', '2014-08-2','player197.png',24),
(201,1,5, 'totemplar'            ,'2007-12-27', '2014-10-0','player198.png',24),
(202,1,5, 'gerbilbo'             ,'2008-01-24', '2014-10-1','player199.png',70),
(203,1,5, 'volcagnome'           ,'2008-01-30', '2014-11-0','player200.png',52),
(204,1,5, 'fowlee'               ,'2008-02-07', '2015-03-2','player201.png',76),
(205,1,5, 'viciousogre'          ,'2008-02-08', '2015-05-0','player202.png',58),
(206,1,5, 'cluelesswarhawk'      ,'2008-02-11', '2015-05-1','player203.png',5 ),
(207,1,5, 'trustyninja'          ,'2008-03-18', '2015-06-0','player204.png',55),
(208,1,5, 'juniorscorpion'       ,'2008-03-20', '2015-06-2','player205.png',40),
(209,1,5, 'euphoricsphinx'       ,'2008-04-02', '2015-9-16','player206.png',62),
(210,1,5, 'idioticweasel'        ,'2008-04-24', '2015-11-2','player207.png',34),
(211,1,5, 'sharctic'             ,'2008-05-09', '2016-02-1','player208.png',26),
(212,1,5, 'pelicannon'           ,'2008-05-10', '2016-03-0','player209.png',58),
(213,1,5, 'iconjurer'            ,'2008-05-12', '2016-04-1','player210.png',72),
(214,1,5, 'volcagnome'           ,'2008-05-15', '2016-04-1','player211.png',41),
(215,1,5, 'greatjudge'           ,'2008-06-09', '2016-05-2','player212.png',13),
(216,1,5, 'famousrat'            ,'2008-06-25', '2016-10-0','player213.png',80),
(217,1,5, 'greenchomper'         ,'2008-07-07', '2016-10-0','player214.png',71),
(218,1,5, 'naiveshark'           ,'2008-07-22', '2016-11-0','player215.png',98),
(219,1,5, 'flashyhedgehog'       ,'2008-08-08', '2017-00-2','player216.png',51),
(220,1,5, 'rhythmlice'           ,'2008-08-12', '2017-02-0','player217.png',92),
(221,1,5, 'rangerman'            ,'2008-08-24', '2017-04-1','player218.png',54),
(222,1,5, 'chinchillax'          ,'2007-12-07', '2014-00-0','player219.png',2 ),
(223,1,5, 'sparrowling'          ,'2007-12-19', '2014-00-2','player220.png',30),
(224,1,5, 'wahooligan'           ,'2007-12-26', '2014-01-0','player221.png',93),
(225,1,5, 'voyagedragon'         ,'2008-01-19', '2014-01-1','player222.png',8 ),
(226,1,5, 'moneycow'             ,'2008-01-23', '2014-01-2','player223.png',24),
(227,1,5, 'sciencesiren'         ,'2008-01-28', '2014-02-1','player224.png',64),
(228,1,5, 'bouncymantis'         ,'2008-01-31', '2014-03-1','player225.png',25),
(229,1,5, 'giftedmonk'           ,'2008-02-02', '2014-10-0','player226.png',52),
(230,1,5, 'graciousimp'          ,'2008-02-14', '2014-10-2','player227.png',29),
(231,1,5, 'womblast'             ,'2008-02-18', '2015-02-3','player228.png',14),
(232,1,5, 'pandamonium'          ,'2008-03-09', '2015-03-2','player229.png',4 ),
(233,1,5, 'cobrass'              ,'2008-03-16', '2015-03-2','player230.png',28),
(234,1,5, 'peafowlet'            ,'2008-05-09', '2015-04-1','player231.png',6 ),
(235,1,5, 'humorchimp'           ,'2008-05-10', '2015-06-0','player232.png',33),
(236,1,5, 'fatbanana'            ,'2008-05-11', '2015-06-2','player233.png',72),
(237,1,5, 'steelfowl'            ,'2008-06-13', '2016-03-1','player234.png',38),
(238,1,5, 'trustyfledgling'      ,'2008-06-27', '2016-04-2','player235.png',1 ),
(239,1,5, 'humblevalkyrie'       ,'2008-07-03', '2016-04-2','player236.png',74),
(240,1,5, 'candidheroine'        ,'2008-07-22', '2016-05-1','player237.png',43),
(241,1,5, 'guacamole'            ,'2008-07-26', '2016-9-03','player238.png',86),
(242,1,5, 'gangstereo'           ,'2008-08-15', '2016-9-11','player239.png',47),
(243,1,5, 'minerd'               ,'2008-08-16', '2016-9-29','player240.png',28),
(244,1,5, 'sparasite'            ,'2008-08-17', '2017-01-2','player241.png',51),
(245,1,6, 'weirdrabbit'          ,'2003-10-30', '2012-10-2','player242.png',24), 
(246,1,6, 'punygod'              ,'2003-11-07', '2013-01-0','player243.png',82),
(247,1,6, 'angerjuellyfish'      ,'2003-11-17', '2013-07-3','player244.png',99),
(248,1,6, 'writerjackal'         ,'2003-11-20', '2013-08-2','player245.png',63),
(249,1,6, 'bigmagpie'            ,'2003-11-27', '2013-10-0','player246.png',96),
(250,1,6, 'cluelessmandarin'     ,'2004-00-24', '2013-10-1','player247.png',83),
(251,1,6, 'ostricheyrich'        ,'2004-00-30', '2013-11-0','player248.png',56),
(252,1,6, 'guruse'               ,'2004-01-07', '2014-03-2','player249.png',16),
(253,1,6, 'sassassin'            ,'2004-01-08', '2014-05-0','player250.png',37),
(254,1,6, 'capeshifter'          ,'2004-01-11', '2014-05-1','player251.png',40),
(255,1,6, 'bronzeoracle'         ,'2004-02-18', '2014-06-0','player252.png',12),
(256,1,6, 'cluelessturtle'       ,'2004-02-20', '2014-06-2','player253.png',17),
(257,1,6, 'bigcyclops'           ,'2004-03-02', '2014-9-16','player254.png',57),
(258,1,6, 'mountainhydra'        ,'2004-03-24', '2014-11-2','player255.png',28),
(259,1,6, 'songapricot'          ,'2004-04-09', '2015-02-1','player256.png',42),
(260,1,6, 'liquidlamb'           ,'2004-04-10', '2015-03-0','player257.png',95),
(261,1,6, 'ownerd'               ,'2004-04-12', '2015-04-1','player258.png',65),
(262,1,6, 'sealixir'             ,'2004-04-15', '2015-04-1','player259.png',68),
(263,1,6, 'pignorant'            ,'2004-05-09', '2015-05-2','player260.png',67),
(264,1,6, 'rascalf'              ,'2004-05-25', '2015-10-0','player261.png',67),
(265,1,6, 'bravegerbil'          ,'2004-06-07', '2015-10-0','player262.png',59),
(266,1,6, 'bigbadpigeon'         ,'2004-06-22', '2015-11-0','player263.png',39),
(267,1,6, 'hilariouscamel'       ,'2004-07-08', '2016-00-2','player264.png',83),
(268,1,6, 'attractiveconqueror'  ,'2004-07-12', '2016-02-0','player265.png',35),
(269,1,6, 'megaboomer'           ,'2004-07-24', '2016-04-1','player266.png',15),
(270,1,6, 'enchantedturkey'      ,'2003-11-07', '2013-00-0','player267.png',29),
(271,1,6, 'videogre'             ,'2003-11-19', '2013-00-2','player268.png',56),
(272,1,6, 'gnunou'               ,'2003-11-26', '2013-01-0','player269.png',71),
(273,1,6, 'badept'               ,'2004-00-19', '2013-01-1','player270.png',92),
(274,1,6, 'laserpent'            ,'2004-00-23', '2013-01-2','player271.png',16),
(275,1,6, 'afternoondeer'        ,'2004-00-28', '2013-02-1','player272.png',58),
(276,1,6, 'bonycyborg'           ,'2004-00-31', '2013-03-1','player273.png',28),
(277,1,6, 'emotionalbullfrog'    ,'2004-01-02', '2013-10-0','player274.png',13),
(278,1,6, 'rudegrape'            ,'2004-01-14', '2013-10-2','player275.png',79),
(279,1,6, 'amusedwoodpecker'     ,'2004-01-18', '2014-02-3','player276.png',78),
(280,1,6, 'vagueibis'            ,'2004-02-09', '2014-03-2','player277.png',50),
(281,1,6, 'pyrogue'              ,'2004-02-16', '2014-03-2','player278.png',63),
(282,1,6, 'chimpanzy'            ,'2004-04-09', '2014-04-1','player279.png',78),
(283,1,6, 'sitcommander'         ,'2004-04-10', '2014-06-0','player280.png',96),
(284,1,6, 'paladino'             ,'2004-04-11', '2014-06-2','player281.png',2 ),
(285,1,6, 'flashyflower'         ,'2004-05-13', '2015-03-1','player282.png',78),
(286,1,6, 'blandapple'           ,'2004-05-27', '2015-04-2','player283.png',10),
(287,1,6, 'complexmantis'        ,'2004-06-03', '2015-04-2','player284.png',30),
(288,1,6, 'battlepumpkin'        ,'2004-06-22', '2015-05-1','player285.png',98),
(289,1,6, 'seaelephant'          ,'2004-06-26', '2015-9-03','player286.png',24),
(290,1,6, 'amazingbot'           ,'2004-07-15', '2015-9-11','player287.png',12),
(291,1,6, 'sharcade'             ,'2004-07-16', '2015-9-29','player288.png',86),
(292,1,6, 'bingoblin'            ,'2004-07-17', '2016-01-2','player289.png',72),
(293,1,7, 'unbanshee'           ,'2002-10-30', '2007-10-23','player290.png',14),
(294,1,7, 'pelicandy'           ,'2002-11-07', '2008-01-09','player291.png',50),
(295,1,7, 'radioactiverunner'   ,'2002-11-17', '2008-07-31','player292.png',19),
(296,1,7, 'jumbodino'           ,'2002-11-20', '2008-08-22','player293.png',80),
(297,1,7, 'angelblueberry'      ,'2002-11-27', '2008-10-05','player294.png',48),
(298,1,7, 'sisterjudge'         ,'2003-00-24', '2008-10-14','player295.png',67),
(299,1,7, 'loudlamb'            ,'2003-00-30', '2008-11-09','player296.png',70),
(300,1,7, 'historywarthog'      ,'2003-01-07', '2009-03-21','player297.png',75),
(301,1,7, 'plazy'               ,'2003-01-08', '2009-05-04','player298.png',90),
(302,1,7, 'sparasite'           ,'2003-01-11', '2009-05-17','player299.png',7 ),
(303,1,7, 'gorrilava'           ,'2003-02-18', '2009-06-09','player300.png',94),
(304,1,7, 'komodough'           ,'2003-02-20', '2009-06-24','player301.png',91),
(305,1,7, 'craftybullet'        ,'2003-03-02', '2009-09-16','player302.png' ,48),
(306,1,7, 'vainfalcon'          ,'2003-03-24', '2009-11-28','player303.png',36),
(307,1,7, 'activeyak'           ,'2003-04-09', '2010-02-13','player304.png',38),
(308,1,7, 'breakfastdwarf'      ,'2003-04-10', '2010-03-06','player305.png',43),
(309,1,7, 'sciencegnoll'        ,'2003-04-12', '2010-04-11','player306.png',14),
(310,1,7, 'secretsage'          ,'2003-04-15', '2010-04-15','player307.png',48),
(311,1,7, 'flaminghost'         ,'2003-05-09', '2010-05-27','player308.png',54),
(312,1,7, 'pandata'             ,'2003-05-25', '2010-10-02','player309.png',5 ),
(313,1,7, 'troutwards'          ,'2003-06-07', '2010-10-05','player310.png',24),
(314,1,7, 'chimpanther'         ,'2003-06-22', '2010-11-04','player311.png',57),
(315,1,7, 'kissytortoise'       ,'2003-07-08', '2011-00-24','player312.png',38),
(316,1,7, 'timeblossom'         ,'2003-07-12', '2011-02-02','player313.png',49),
(317,1,7, 'cheatgeneral'        ,'2003-07-24', '2011-04-18','player314.png',74),
(318,1,7, 'idlepanda'           ,'2002-11-07', '2008-00-02','player315.png',72),
(319,1,7, 'awfulchick'          ,'2002-11-19', '2008-00-21','player316.png',70),
(320,1,7, 'frightenedbison'     ,'2002-11-26', '2008-01-07','player317.png',32),
(321,1,7, 'hippony'             ,'2003-00-19', '2008-01-15','player318.png',72),
(322,1,7, 'bachelord'           ,'2003-00-23', '2008-01-21','player319.png',26),
(323,1,7, 'spiderby'            ,'2003-00-28', '2008-02-17','player320.png',92),
(324,1,7, 'flexecutioner'       ,'2003-00-31', '2008-03-14','player321.png',88),
(325,1,7, 'youngocelot'         ,'2003-01-02', '2008-10-04','player322.png',65),
(326,1,7, 'doompriest'          ,'2003-01-14', '2008-10-26','player323.png',64),
(327,1,7, 'coldsquab'           ,'2003-01-18', '2009-02-30','player324.png',96),
(328,1,7, 'ruderunner'          ,'2003-02-09', '2009-03-20','player325.png',93),
(329,1,7, 'blushingcub'         ,'2003-02-16', '2009-03-26','player326.png',73),
(330,1,7, 'glitteringboomer'    ,'2003-04-09', '2009-04-18','player327.png',23),
(331,1,7, 'snowmanta'           ,'2003-04-10', '2009-06-07','player328.png',96),
(332,1,7, 'cocowboy'            ,'2003-04-11', '2009-06-26','player329.png',97),
(333,1,7, 'herringmaster'       ,'2003-05-13', '2010-03-16','player330.png',33),
(334,1,7, 'komodough'           ,'2003-05-27', '2010-04-20','player331.png',29),
(335,1,7, 'grandrose'           ,'2003-06-03', '2010-04-22','player332.png',28),
(336,1,7, 'gamingshadow'        ,'2003-06-22', '2010-05-10','player333.png',31),
(337,1,7, 'fearlessraptor'      ,'2003-06-26', '2010-9-03','player334.png' ,15),
(338,1,7, 'aquacheetah'         ,'2003-07-15', '2010-9-11','player335.png' ,73),
(339,1,7, 'writerbat'           ,'2003-07-16', '2010-9-29','player336.png' ,64),
(340,1,7, 'bigbadwarlock'       ,'2003-07-17', '2011-01-21','player337.png',39);
