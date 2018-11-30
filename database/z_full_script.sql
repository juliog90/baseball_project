select 'insertando tablas' AS '';
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
catId int not null,
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
select 'Llaves foraneas' AS '';
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
select 'antes de error' AS '';
alter table matches
add constraint FK_Matches_Category foreign key (catId) references categories(catId);
select 'despues de error' AS '';

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
select 'Vistas' AS '';
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
select 'Inserts Estaticos' AS '';
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

select 'Inserts de prueba' AS '';
-- Persons
-- Coaches
INSERT INTO persons (perFirstName,perLastName) VALUES 
-- coaches
("Nero","Mcleod"),
("Kane","Glenn"),
("Hamilton","Austin"),
("Nicholas","Morin"),
-- players
("Abel","Lewis"),
("Ivan","Woodward"),
("Rogan","Lopez"),
("Cairo","Mcpherson"),
("Christopher","Hansen"),
("Jelani","Castillo"),
("Ishmael","George"),
("Fitzgerald","Lang"),
("Alfonso","Santana"),
("Rudyard","Murray"),
("Kibo","Rivas"),
("Kenneth","Greene"),

("Wayne","Gibbs"),
("Zeph","Ortega"),
("Rogan","Huff"),
("Scott","Velasquez"),
("Adam","Wooten"),
("Addison","Santana"),
("Basil","Campos"),
("Yuli","Mcdaniel"),
("Tarik","Bruce"),
("Orlando","Booth"),
("Curran","Booth"),
("Kelly","Campbell"),

("Elmo","Salas"),
("Upton","Stark"),
("Oscar","Mcknight"),
("Mohammad","Hays"),
("Driscoll","Serrano"),
("Erasmus","Ingram"),
("Carter","Alford"),


("Laurel","Horne"),
("Xantha","Soto"),
("Iona","Haynes"),
("Christine","Mooney"),
("Wendy","Ferguson"),



("Martin","Spence"),
("Cade","Mclaughlin"),
("Nicholas","Hensley"),
("Jerome","Nguyen"),
("Talon","Mosley"),
("Amos","Banks"),
("Ferris","Figueroa"),
("Fritz","Berger"),
("Grant","Lindsey"),
("Lewis","Guy"),
("Stuart","Meadows"),
("Stephany","Carroll"),

("Dalton","Duncan"),
("Alden","Wheeler"),
("Shad","Zimmerman"),
("Aidan","Burgess"),
("Carter","Henry"),
("Dustin","Odonnell"),
("Donovan","Drake"),
("Zachery","Carrillo"),
("Zachary","Howe"),
("Reese","Ochoa"),
("Wing","Carson"),
("Mary","Reynolds"),

("Damian","Norman"),
("Hiram","Franco"),
("Jonas","Clements"),
("Castor","Baird"),
("Tobias","Knowles"),
("Troy","Rodriquez"),
("Slade","David"),
("Sawyer","Travis"),
("Joel","Hendricks"),
("Dane","Anthony"),
("Ishmael","Buckner"),
("Driscoll","Cochran"),

("Kasimir","Mayo"),
("Carl","Cantrell"),
("Philip","Roberts"),
("Brendan","Daniels"),
("Harding","Parrish"),
("Wang","Mccarty"),
("Carson","Guerra"),
("Marsden","Booth"),
("Sebastian","Rivers"),
("Solomon","Douglas"),
("Erasmus","Stevens"),
("Vannesa","Brock"),

("Christian","Schwartz"),
("Quentin","Mcfarland"),
("Akeem","Mcmillan"),
("Kibo","Mcfadden"),
("Raymond","Ryan"),
("Davis","Hobbs"),
("Amos","Gentry"),
("Dustin","Mcmillan"),
("Price","Lucas"),
("Mohammad","Dixon"),
("Caleb","Houston"),
("Nicole","Marquez"),

("Murphy","Poole"),
("Colorado","Burgess"),
("Kelly","House"),
("Malachi","Clarke"),
("Abel","Dickson"),
("Mufutau","Hebert"),
("Kenyon","Hunt"),
("Hayden","Brown"),
("Gregory","Barker"),
("Cody","Sosa"),
("Mason","James"),
("Brenda","Shields"),

("Emery","Haynes"),
("Barry","Flores"),
("Levi","Wiley"),
("Drake","Moss"),
("Micah","Lucas"),
("Erich","Phillips"),
("Anthony","Burton"),
("Oleg","Herring"),
("Blake","Mckinney"),
("Dean","Kelley"),
("Russell","Everett"),
("Dennise","Poole"),

("Nehru","Riddle"),
("Darius","Mueller"),
("Logan","Atkins"),
("Abbot","Acosta"),
("Ethan","Newman"),
("Baxter","Nichols"),
("Ivan","Singleton"),
("Joseph","Mcleod"),
("Todd","Giles"),
("Yuli","Anderson"),
("Jesse","Glenn"),
("Clarisse","England"),

("Walker","Burnett"),
("Timothy","Wilder"),
("Kane","Lucas"),
("Caesar","Wade"),
("Stephen","Irwin"),
("Rudyard","Barrera"),
("Malik","Guthrie"),
("Jonah","Todd"),
("Judah","Hardy"),
("Cooper","Harvey"),
("Mason","Howard"),
("Nasima","Middleton"),

("Nolan","Rodriguez"),
("Camden","Luna"),
("Benedict","Stone"),
("Gray","Dunlap"),
("Travis","Higgins"),
("Preston","Ramsey"),
("Colorado","Allen"),
("Slade","Sloan"),
("Hall","Taylor"),
("Cameron","Gilbert"),
("Ulric","Sampson"),
("Gray","Valentine"),

("Benedict","Rowe"),
("Simon","Webb"),
("Ivan","Wade"),
("Vaughan","Gay"),
("Eric","Chambers"),
("Callum","Henderson"),
("Tucker","Wyatt"),
("Reece","Mcdonald"),
("Grady","Cooper"),
("Alfonso","Ballard"),
("Christian","Gallegos"),
("Ramona","Casey"),

("Eric","Mckee"),
("Bert","Orr"),
("Kasimir","Gutierrez"),
("Francis","Sherman"),
("Lee","Santana"),
("Tyrone","Ramirez"),
("Benedict","Knapp"),
("Martin","Bradley"),
("Tobias","Mcdowell"),
("Neville","Wiggins"),
("Emery","Slater"),
("Fernanda","Maldonado"),

("Forrest","Blankenship"),
("Wesley","Hanson"),
("Mark","Rowe"),
("Daquan","Bauer"),
("Tucker","Alston"),
("Melvin","Hughes"),
("Drew","Castillo"),
("Arden","Mccarthy"),
("Elijah","Hood"),
("Zachery","Pitts"),
("Holmes","Moon"),
("Pamela","Nunez"),

("Abel","Diaz"),
("Wyatt","Chang"),
("Jin","Chapman"),
("Robert","Riggs"),
("Lyle","Dorsey"),
("Hashim","Hart"),
("Jackson","Garza"),
("Upton","Nguyen"),
("Thane","Spencer"),
("Yuli","Kidd"),
("Ian","Martinez"),
("Merlinda","Baldwin"),

("Scott","Bowen"),
("Kasimir","Riley"),
("Macon","Wise"),
("Leonard","Mcguire"),
("Baxter","Olsen"),
("Ulysses","Holmes"),
("Marsden","Barry"),
("Merritt","Herring"),
("Zeph","Kidd"),
("Kenyon","Calhoun"),
("Aristotle","Garza"),
("Linda","Wood"),

("Branden","Rosales"),
("Emerson","Morales"),
("Raymond","Hays"),
("Lionel","Adams"),
("Kadeem","Whitaker"),
("Mark","Nielsen"),
("Driscoll","Guthrie"),
("Victor","Mcfarland"),
("Martin","Moss"),
("Giacomo","Mcneil"),
("Sylvester","Ryan"),
("Josefina","Haynes"),

("Nero","Tillman"),
("Mannix","Carlson"),
("Andrew","Mayer"),
("Garrett","Dawson"),
("Sawyer","Hall"),
("Hasad","Eaton"),
("Isaiah","Merrill"),
("Jonah","Carroll"),
("Damian","Matthews"),
("Caesar","Bradshaw"),
("Byron","Carver"),
("Susana","Gutierrez"),

("Lane","Hendricks"),
("Richard","Ochoa"),
("Cedric","Wallace"),
("Colby","Salas"),
("Merritt","Mcbride"),
("Ralph","Kelly"),
("Aladdin","Hicks"),
("Thane","Fuentes"),
("Austin","Miranda"),
("Grady","Patterson"),
("Palmer","Sherman"),
("Martha","Glenn"),

("Plato","Gallegos"),
("Wallace","Foreman"),
("Sean","Cooper"),
("Matthew","Washington"),
("Eagan","Dickson"),
("Dustin","Rosa"),
("Jasper","Maxwell"),
("Byron","Schroeder"),
("Tyler","Coffey"),
("Dexter","Durham"),
("Scott","Campbell"),
("Teresa","Church"),

("Benjamin","Sharpe"),
("Dennis","Simon"),
("Oliver","Christian"),
("Tyrone","Rivers"),
("Cade","Key"),
("Noble","Small"),
("Lewis","Koch"),
("Jackson","Mosley"),
("Rashad","Mccoy"),
("Daquan","Williamson"),
("Oren","Mann"),
("Dorothy","Lowe"),

("Timothy","Hendricks"),
("Gannon","Bowman"),
("Martin","Michael"),
("Emmanuel","Farrell"),
("Colby","French"),
("Kieran","Michael"),
("Fitzgerald","Meyer"),
("Connor","Kinney"),
("Davis","Lawrence"),
("Cullen","Baker"),
("Xavier","Gaines"),
("Seledonia","Haney"),

("Vance","Horton"),
("Sebastian","Blake"),
("Mannix","Salas"),
("Mufutau","Ward"),
("Herman","Houston"),
("Tucker","Keller"),
("Tucker","Burks"),
("Baxter","Olson"),
("Bernard","Morton"),
("Vernon","Alvarado"),
("Baker","Sampson"),
("Maggy","Herman"),

("Blaze","Burks"),
("Damon","Henry"),
("Kenyon","Stark"),
("Malik","Gould"),
("Solomon","Mckenzie"),
("Harding","Powers"),
("Marsden","Kinney"),
("Howard","Phillips"),
("Wesley","Tyson"),
("Gary","Olsen"),
("Burke","Vazquez"),
("Karen","Thompson"),

("Kenyon","Watkins"),
("Dolan","Ewing"),
("Judah","Johnston"),
("Oscar","Neal"),
("Erasmus","Atkins"),
("Hop","Meadows"),
("Zeph","Alvarez"),
("Byron","Pitts"),
("Kamal","Sims"),
("Erich","Hamilton"),
("Erasmus","James"),
("Erika","Best"),

("Herrod","Monroe"),
("Ralph","Sims"),
("Kane","Rosa"),
("Declan","Daugherty"),
("Abraham","Ayala"),
("Sebastian","Kent"),
("Chase","Simon"),
("Oren","Hooper"),
("Byron","Ross"),
("Gil","Hubbard"),
("Salvador","Doyle"),
("Dana","Stafford"),


("Emery","Gould"),
("Owen","Allen"),
("Donovan","Hicks"),
("Fuller","Allen"),
("Baxter","Sykes"),
("Howard","Lambert"),
("Keaton","Skinner"),
("Jason","Patrick"),
("Alan","Montgomery"),
("Fitzgerald","Nash"),
("Ciaran","Romero"),
("Hu","Chan"),
("Darius","Lowery"),
("Raja","Davis"),
("Lee","Donaldson"),
("Elijah","Lang"),
("Wang","Sheppard"),
("Micah","Reyes"),
("Kennan","Conley"),
("Todd","Pittman"),
("Steel","Sanchez"),
("Dean","Reyes"),
("Cadman","Rice"),
("Jarrod","Sargent"),
-- users
("Zachary","Stevens"),
("Oliver","Oliver"),
("Quamar","Mcmahon"),
("Wang","Roberts"),
("Keefe","Welch"),
("Kibo","Mcdonald"),
("Cadman","Wiggins"),
("Rashad","Morton"),
("Luke","Mcdonald"),
("Oscar","Davis");

insert into categories(catName) values('Biberon'),('Escuelita'),('Peewee'),('Infantil'),('Pony'),('Colt'),('Juvenil'), ('zapeta');

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
(1, 'Bulldozers', 'team23.png', 1, 23, 36),
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
(44 ,1,1, 'sha-doh'      ,'2013-02-24','2017-06-24','player40.png',42),
(45 ,1,1, 'amazingcoffee','2013-03-05','2017-07-02','player41.png',58),
(46 ,1,1, 'meanfox'      ,'2013-03-19','2017-07-08','player42.png',24),
(47 ,1,1, 'spotlessguy'  ,'2013-03-26','2017-07-09','player43.png',65),
(48 ,1,1, 'brightcolonel','2013-04-15','2017-07-27','player44.png',88),
(49 ,1,1, 'starkkit'     ,'2013-04-27','2017-08-12','player45.png',24),
(50 ,1,1, 'fruitpug'     ,'2013-05-12','2017-08-21','player46.png',47),
(51 ,1,1, 'amigoliath'   ,'2013-05-14','2017-09-03','player47.png',21),
(52 ,1,1, 'masteroid'    ,'2013-05-15','2017-09-10','player48.png',59),
-- escuelita
-- equipo 1
(53 ,1,2, 'sealixir'         ,'2010-11-23', '2016-12-15', 'player49.png',43),
(54 ,1,2, 'amighost'         ,'2010-12-03', '2017-01-05', 'player50.png',26),
(55 ,1,2, 'feistyrhino'      ,'2011-01-26', '2017-01-31', 'player51.png',27),
(56 ,1,2, 'trustywerewolf'   ,'2011-02-01', '2017-03-06', 'player52.png',9 ),
(57 ,1,2, 'rockmantis'       ,'2011-02-15', '2017-04-07', 'player53.png',69),
(58 ,1,2, 'phonycoconut'     ,'2011-03-23', '2017-05-03', 'player54.png',29),
(59 ,1,2, 'filthyrhino'      ,'2011-04-02', '2017-05-08', 'player55.png',37),
(60 ,1,2, 'bouncingcranberry','2011-04-18', '2017-06-29', 'player56.png',91),
(61 ,1,2, 'bambinosaur'      ,'2011-05-09', '2017-08-17', 'player57.png',78),
(62 ,1,2, 'panthermal'       ,'2011-05-12', '2017-10-16', 'player58.png',63),
(63 ,1,2, 'leopardon'        ,'2011-05-13', '2017-11-22', 'player59.png',10),
(64 ,1,2, 'dwarvos'          ,'2011-05-14', '2017-12-07', 'player60.png',92),
(65 ,1,2, 'antiqueape'       ,'2011-05-28', '2017-12-15', 'player61.png',11),
(66 ,1,2, 'riddlemallard'    ,'2011-06-05', '2018-01-22', 'player62.png',83),
(67 ,1,2, 'traveldroid'      ,'2011-06-17', '2018-02-04', 'player63.png',3 ),
(68 ,1,2, 'silversalmon'     ,'2011-06-23', '2018-02-13', 'player64.png',18),
(69 ,1,2, 'complexemu'       ,'2011-08-01', '2018-02-16', 'player65.png',9 ),
(70 ,1,2, 'enchantedgangster','2011-08-04', '2018-02-27', 'player66.png',38),
(71 ,1,2, 'turkiwi'          ,'2011-08-07', '2018-04-29', 'player67.png',56),
(72 ,1,2, 'wallaby'          ,'2011-08-18', '2018-05-11', 'player68.png',91),
(73 ,1,2, 'bambooccaneer'    ,'2011-08-21', '2018-06-24', 'player69.png',74),
(74 ,1,2, 'falcondor'        ,'2011-08-26', '2018-06-27', 'player70.png',34),
(75 ,1,2, 'swiftpredator'    ,'2011-09-08', '2018-07-04', 'player71.png',71),
(76 ,1,2, 'candypattern'     ,'2011-09-17', '2018-07-22', 'player72.png',73),
(77 ,1,2, 'handsomeurchin'   ,'2011-09-18', '2018-08-07', 'player73.png',90),
(78 ,1,2, 'carefuldove'      ,'2010-11-30', '2016-11-28', 'player74.png',61),
(79 ,1,2, 'rustyblizzard'    ,'2010-12-03', '2016-12-06', 'player75.png',41),
(80 ,1,2, 'purepheasant'     ,'2010-12-04', '2017-01-19', 'player76.png',68),
(81 ,1,2, 'devile'           ,'2010-12-05', '2017-02-02', 'player77.png',38),
(82 ,1,2, 'stingraycharles'  ,'2010-12-10', '2017-02-17', 'player78.png',41),
(83 ,1,2, 'guineapiggy'      ,'2010-12-20', '2017-03-19', 'player79.png',31),
(84 ,1,2, 'fellama'          ,'2011-01-02', '2017-03-23', 'player80.png',41),
(85 ,1,2, 'smoothbuffalo'    ,'2011-01-14', '2017-05-15', 'player81.png',55),
(86 ,1,2, 'autumnwallaby'    ,'2011-02-09', '2017-06-28', 'player82.png',20),
(87 ,1,2, 'fruitvanilla'     ,'2011-02-10', '2017-07-01', 'player83.png',65),
(88 ,1,2, 'miniant'          ,'2011-02-28', '2017-07-02', 'player84.png',94),
(89 ,1,2, 'memorykit'        ,'2011-03-05', '2017-07-03', 'player85.png',37),
(90 ,1,2, 'lakefrogger'      ,'2011-04-14', '2017-08-15', 'player86.png',25),
(91 ,1,2, 'lockroach'        ,'2011-05-16', '2017-09-13', 'player87.png',73),
(92 ,1,2, 'lazyhazy'         ,'2011-05-17', '2017-11-15', 'player88.png',55),
(93 ,1,2, 'daemonkey'        ,'2011-05-28', '2017-12-02', 'player89.png',18),
(94 ,1,2, 'knighttime'       ,'2011-06-27', '2017-12-17', 'player90.png',80),
(95 ,1,2, 'glamorousbadger'  ,'2011-07-20', '2017-12-27', 'player91.png',69),
(96 ,1,2, 'classicwasp'      ,'2011-07-30', '2018-01-10', 'player92.png',99),
(97 ,1,2, 'formalpineapple'  ,'2011-08-02', '2018-01-11', 'player93.png',99),
(98 ,1,2, 'diettucan'        ,'2011-08-03', '2018-03-31', 'player94.png',19),
(99 ,1,2, 'flamehazelnut'    ,'2011-08-20', '2018-05-04', 'player95.png',42),
(100,1,2, 'hammerpriestess'  ,'2011-08-21', '2018-08-11', 'player96.png',93),
(101,1,3, 'lamaster'           ,'2009-12-07','2016-04-21','player97.png',75), 
(102,1,3, 'archlizard'         ,'2009-12-21','2016-06-27','player98.png',14),
(103,1,3, 'hippony'            ,'2010-01-14','2016-10-06','player99.png',75),
(104,1,3, 'hedgehogger'        ,'2010-02-01','2016-10-15','player100.png',86),
(105,1,3, 'coldsparks'         ,'2010-02-06','2016-11-07','player101.png',58),
(106,1,3, 'coldmonster'        ,'2010-02-28','2016-12-28','player102.png',52),
(107,1,3, 'vainsalmon'         ,'2010-03-24','2017-02-13','player103.png',19),
(108,1,3, 'dapperblizzard'     ,'2010-03-28','2017-04-14','player104.png',72),
(109,1,3, 'tiredduck'          ,'2010-04-03','2017-05-20','player105.png',54),
(110,1,3, 'virtualpython'      ,'2010-04-14','2017-07-07','player106.png',31),
(111,1,3, 'ostritches'         ,'2010-04-24','2017-11-07','player107.png',25),
(112,1,3, 'blazebra'           ,'2010-04-29','2017-11-23','player108.png',62),
(113,1,3, 'wolveriot'          ,'2010-05-06','2017-12-17','player109.png',38),
(114,1,3, 'stenchanter'        ,'2010-05-08','2018-01-01','player110.png',84),
(115,1,3, 'roadbeetle'         ,'2010-05-21','2018-01-15','player111.png',57),
(116,1,3, 'arcticfrogger'      ,'2010-06-17','2018-03-02','player112.png',36),
(117,1,3, 'slowviper'          ,'2010-06-18','2018-03-24','player113.png',16),
(118,1,3, 'actionpiglet'       ,'2010-07-11','2018-05-23','player114.png',13),
(119,1,3, 'sadterror'          ,'2010-07-21','2018-06-20','player115.png',34),
(120,1,3, 'chillykitty'        ,'2010-07-25','2018-07-09','player116.png',54),
(121,1,3, 'pandame'            ,'2010-07-29','2018-07-12','player117.png',69),
(122,1,3, 'pixelephant'        ,'2010-08-20','2018-07-28','player118.png',69),
(123,1,3, 'antiger'            ,'2010-08-29','2018-08-14','player119.png',80),
(124,1,3, 'cheatah'            ,'2010-09-05','2018-09-05','player120.png',58),
(125,1,3, 'naughtyrogue'       ,'2010-09-10','2018-09-10','player121.png',2 ),
(126,1,3, 'giantfowl'          ,'2009-12-05','2015-12-10','player122.png',79),
(127,1,3, 'dirtycat'           ,'2009-12-07','2016-02-15','player123.png',82),
(128,1,3, 'intelligentnymph'   ,'2009-12-13','2016-04-01','player124.png',77),
(129,1,3, 'mysterioushalfling' ,'2009-12-19','2016-08-19','player125.png',15),
(130,1,3, 'heartpie'           ,'2009-12-28','2017-01-22','player126.png',90),
(131,1,3, 'rangutangle'        ,'2010-01-01','2017-04-22','player127.png',84),
(132,1,3, 'dinoscythe'         ,'2010-01-12','2017-04-23','player128.png',46),
(133,1,3, 'victorc'            ,'2010-02-17','2017-04-30','player129.png',93),
(134,1,3, 'porcupid'           ,'2010-03-10','2017-07-08','player130.png',27),
(135,1,3, 'dopeymuppet'        ,'2010-03-13','2017-07-21','player131.png',57),
(136,1,3, 'primemermaid'       ,'2010-03-15','2017-09-12','player132.png',12),
(137,1,3, 'cannonfrog'         ,'2010-03-19','2017-09-15','player133.png',74),
(138,1,3, 'crownhippo'         ,'2010-03-22','2017-10-05','player134.png',61),
(139,1,3, 'famousstorm'        ,'2010-04-03','2017-10-25','player135.png',96),
(140,1,3, 'gothiccyborg'       ,'2010-05-09','2017-11-05','player136.png',47),
(141,1,3, 'caterpixie'         ,'2010-05-11','2017-11-15','player137.png',38),
(142,1,3, 'demonkey'           ,'2010-05-14','2017-12-13','player138.png',59),
(143,1,3, 'fellama'            ,'2010-06-01','2018-01-29','player139.png',7 ),
(144,1,3, 'oysterminate'       ,'2010-06-04','2018-03-10','player140.png',59),
(145,1,3, 'loyalrascal'        ,'2010-06-17','2018-03-19','player141.png',48),
(146,1,3, 'needylice'          ,'2010-06-18','2018-04-02','player142.png',28),
(147,1,3, 'lunchbear'          ,'2010-06-24','2018-05-07','player143.png',74),
(148,1,3, 'hollowdoughnut'     ,'2010-06-25','2018-05-09','player144.png',74),
(149,1,4, 'lightningfurry'       ,'2008-11-30', '2014-11-2','player145.png',76),
(150,1,4, 'primespider'          ,'2008-12-07', '2015-02-0','player146.png',13),
(151,1,4, 'commandroid'          ,'2008-12-17', '2015-08-3','player147.png',34),
(152,1,4, 'tomatoad'             ,'2008-12-20', '2015-09-2','player148.png',97),
(153,1,4, 'hypnotastic'          ,'2008-12-27', '2015-11-0','player149.png',46),
(154,1,4, 'turbanshee'           ,'2009-01-24', '2015-11-1','player150.png',24),
(155,1,4, 'dietlord'             ,'2009-01-30', '2015-12-0','player151.png',90),
(156,1,4, 'smilingpegasus'       ,'2009-02-07', '2016-04-2','player152.png',55),
(157,1,4, 'hearttoad'            ,'2009-02-08', '2016-06-0','player153.png',80),
(158,1,4, 'gardenduck'           ,'2009-02-11', '2016-06-1','player154.png',71),
(159,1,4, 'frostygod'            ,'2009-03-18', '2016-07-0','player155.png',35),
(160,1,4, 'expertgrasshopper'    ,'2009-03-20', '2016-07-2','player156.png',44),
(161,1,4, 'vulturret'            ,'2009-04-02', '2016-10-1','player157.png',94),
(162,1,4, 'decorsair'            ,'2009-04-24', '2016-12-2','player158.png',68),
(163,1,4, 'griffinish'           ,'2009-05-09', '2017-03-1','player159.png',61),
(164,1,4, 'sincubus'             ,'2009-05-10', '2017-04-0','player160.png',21),
(165,1,4, 'insecuresquirrel'     ,'2009-05-12', '2017-05-1','player161.png',38),
(166,1,4, 'ninjapattern'         ,'2009-05-15', '2017-05-1','player162.png',99),
(167,1,4, 'scentedmango'         ,'2009-06-09', '2017-06-2','player163.png',44),
(168,1,4, 'battleogre'           ,'2009-06-25', '2017-11-0','player164.png',14),
(169,1,4, 'spookygeneral'        ,'2009-07-07', '2017-11-0','player165.png',84),
(170,1,4, 'forestenigma'         ,'2009-07-22', '2017-12-0','player166.png',86),
(171,1,4, 'nitwitch'             ,'2009-08-08', '2018-01-2','player167.png',43),
(172,1,4, 'gamerman'             ,'2009-08-12', '2018-03-0','player168.png',98),
(173,1,4, 'goghost'              ,'2009-08-24', '2018-05-1','player169.png',99),
(174,1,4, 'brasshopper'          ,'2008-12-07', '2015-01-0','player170.png',91),
(175,1,4, 'digitalnightelf'      ,'2008-12-19', '2015-01-2','player171.png',64),
(176,1,4, 'paperparrot'          ,'2008-12-26', '2015-02-0','player172.png',35),
(177,1,4, 'weirdfalcon'          ,'2009-01-19', '2015-02-1','player173.png',75),
(178,1,4, 'heartrat'             ,'2009-01-23', '2015-02-2','player174.png',19),
(179,1,4, 'caringdonkey'         ,'2009-01-28', '2015-03-1','player175.png',55),
(180,1,4, 'dimmaple'             ,'2009-01-31', '2015-04-1','player176.png',72),
(181,1,4, 'crickettle'           ,'2009-02-02', '2015-11-0','player177.png',60),
(182,1,4, 'kangarookie'          ,'2009-02-14', '2015-11-2','player178.png',6 ),
(183,1,4, 'capeshifter'          ,'2009-02-18', '2016-03-3','player179.png',92),
(184,1,4, 'ibiscuit'             ,'2009-03-09', '2016-04-2','player180.png',12),
(185,1,4, 'ancientrascal'        ,'2009-03-16', '2016-04-2','player181.png',53),
(186,1,4, 'scentedbeetle'        ,'2009-05-09', '2016-05-1','player182.png',20),
(187,1,4, 'oceanandroid'         ,'2009-05-10', '2016-07-0','player183.png',95),
(188,1,4, 'plushcat'             ,'2009-05-11', '2016-07-2','player184.png',61),
(189,1,4, 'antiquehorse'         ,'2009-06-13', '2017-04-1','player185.png',24),
(190,1,4, 'smilingcake'          ,'2009-06-27', '2017-05-2','player186.png',65),
(191,1,4, 'wrathhawk'            ,'2009-07-03', '2017-05-2','player187.png',60),
(192,1,4, 'devile'               ,'2009-07-22', '2017-06-1','player188.png',17),
(193,1,4, 'elephantom'           ,'2009-07-26', '2017-10-0','player189.png',79),
(194,1,4, 'candroid'             ,'2009-08-15', '2017-10-1','player190.png',58),
(195,1,4, 'sneakybandit'         ,'2009-08-16', '2017-10-2','player191.png',95),
(196,1,4, 'blushingdroid'        ,'2009-08-17', '2018-02-2','player192.png',62),
(197,1,5, 'surpriselime'         ,'2007-11-30', '2013-10-2','player193.png',81),
(198,1,5, 'sandmachine'          ,'2007-12-07', '2014-01-0','player194.png',44),
(199,1,5, 'quietpotato'          ,'2007-12-17', '2014-07-3','player195.png',46),
(200,1,5, 'surprisehopper'       ,'2007-12-20', '2014-08-2','player196.png',24),
(201,1,5, 'totemplar'            ,'2007-12-27', '2014-10-0','player197.png',24),
(202,1,5, 'gerbilbo'             ,'2008-01-24', '2014-10-1','player198.png',70),
(203,1,5, 'volcagnome'           ,'2008-01-30', '2014-11-0','player199.png',52),
(204,1,5, 'fowlee'               ,'2008-02-07', '2015-03-2','player200.png',76),
(205,1,5, 'viciousogre'          ,'2008-02-08', '2015-05-0','player201.png',58),
(206,1,5, 'cluelesswarhawk'      ,'2008-02-11', '2015-05-1','player202.png',5 ),
(207,1,5, 'trustyninja'          ,'2008-03-18', '2015-06-0','player203.png',55),
(208,1,5, 'juniorscorpion'       ,'2008-03-20', '2015-06-2','player204.png',40),
(209,1,5, 'euphoricsphinx'       ,'2008-04-02', '2015-9-16','player205.png',62),
(210,1,5, 'idioticweasel'        ,'2008-04-24', '2015-11-2','player206.png',34),
(211,1,5, 'sharctic'             ,'2008-05-09', '2016-02-1','player207.png',26),
(212,1,5, 'pelicannon'           ,'2008-05-10', '2016-03-0','player208.png',58),
(213,1,5, 'iconjurer'            ,'2008-05-12', '2016-04-1','player209.png',72),
(214,1,5, 'volcagnome'           ,'2008-05-15', '2016-04-1','player210.png',41),
(215,1,5, 'greatjudge'           ,'2008-06-09', '2016-05-2','player211.png',13),
(216,1,5, 'famousrat'            ,'2008-06-25', '2016-10-0','player212.png',80),
(217,1,5, 'greenchomper'         ,'2008-07-07', '2016-10-0','player213.png',71),
(218,1,5, 'naiveshark'           ,'2008-07-22', '2016-11-0','player214.png',98),
(219,1,5, 'flashyhedgehog'       ,'2008-08-08', '2017-00-2','player215.png',51),
(220,1,5, 'rhythmlice'           ,'2008-08-12', '2017-02-0','player216.png',92),
(221,1,5, 'rangerman'            ,'2008-08-24', '2017-04-1','player217.png',54),
(222,1,5, 'chinchillax'          ,'2007-12-07', '2014-00-0','player218.png',2 ),
(223,1,5, 'sparrowling'          ,'2007-12-19', '2014-00-2','player219.png',30),
(224,1,5, 'wahooligan'           ,'2007-12-26', '2014-01-0','player220.png',93),
(225,1,5, 'voyagedragon'         ,'2008-01-19', '2014-01-1','player221.png',8 ),
(226,1,5, 'moneycow'             ,'2008-01-23', '2014-01-2','player222.png',24),
(227,1,5, 'sciencesiren'         ,'2008-01-28', '2014-02-1','player223.png',64),
(228,1,5, 'bouncymantis'         ,'2008-01-31', '2014-03-1','player224.png',25),
(229,1,5, 'giftedmonk'           ,'2008-02-02', '2014-10-0','player225.png',52),
(230,1,5, 'graciousimp'          ,'2008-02-14', '2014-10-2','player226.png',29),
(231,1,5, 'womblast'             ,'2008-02-18', '2015-02-3','player227.png',14),
(232,1,5, 'pandamonium'          ,'2008-03-09', '2015-03-2','player228.png',4 ),
(233,1,5, 'cobrass'              ,'2008-03-16', '2015-03-2','player229.png',28),
(234,1,5, 'peafowlet'            ,'2008-05-09', '2015-04-1','player230.png',6 ),
(235,1,5, 'humorchimp'           ,'2008-05-10', '2015-06-0','player231.png',33),
(236,1,5, 'fatbanana'            ,'2008-05-11', '2015-06-2','player232.png',72),
(237,1,5, 'steelfowl'            ,'2008-06-13', '2016-03-1','player233.png',38),
(238,1,5, 'trustyfledgling'      ,'2008-06-27', '2016-04-2','player234.png',1 ),
(239,1,5, 'humblevalkyrie'       ,'2008-07-03', '2016-04-2','player235.png',74),
(240,1,5, 'candidheroine'        ,'2008-07-22', '2016-05-1','player236.png',43),
(241,1,5, 'guacamole'            ,'2008-07-26', '2016-9-03','player237.png',86),
(242,1,5, 'gangstereo'           ,'2008-08-15', '2016-9-11','player238.png',47),
(243,1,5, 'minerd'               ,'2008-08-16', '2016-9-29','player239.png',28),
(244,1,5, 'sparasite'            ,'2008-08-17', '2017-01-2','player240.png',51),
(245,1,6, 'weirdrabbit'          ,'2003-10-30', '2012-10-2','player241.png',24), 
(246,1,6, 'punygod'              ,'2003-11-07', '2013-01-0','player242.png',82),
(247,1,6, 'angerjuellyfish'      ,'2003-11-17', '2013-07-3','player243.png',99),
(248,1,6, 'writerjackal'         ,'2003-11-20', '2013-08-2','player244.png',63),
(249,1,6, 'bigmagpie'            ,'2003-11-27', '2013-10-0','player245.png',96),
(250,1,6, 'cluelessmandarin'     ,'2004-00-24', '2013-10-1','player246.png',83),
(251,1,6, 'ostricheyrich'        ,'2004-00-30', '2013-11-0','player247.png',56),
(252,1,6, 'guruse'               ,'2004-01-07', '2014-03-2','player248.png',16),
(253,1,6, 'sassassin'            ,'2004-01-08', '2014-05-0','player249.png',37),
(254,1,6, 'capeshifter'          ,'2004-01-11', '2014-05-1','player250.png',40),
(255,1,6, 'bronzeoracle'         ,'2004-02-18', '2014-06-0','player251.png',12),
(256,1,6, 'cluelessturtle'       ,'2004-02-20', '2014-06-2','player252.png',17),
(257,1,6, 'bigcyclops'           ,'2004-03-02', '2014-9-16','player253.png',57),
(258,1,6, 'mountainhydra'        ,'2004-03-24', '2014-11-2','player254.png',28),
(259,1,6, 'songapricot'          ,'2004-04-09', '2015-02-1','player255.png',42),
(260,1,6, 'liquidlamb'           ,'2004-04-10', '2015-03-0','player256.png',95),
(261,1,6, 'ownerd'               ,'2004-04-12', '2015-04-1','player257.png',65),
(262,1,6, 'sealixir'             ,'2004-04-15', '2015-04-1','player258.png',68),
(263,1,6, 'pignorant'            ,'2004-05-09', '2015-05-2','player259.png',67),
(264,1,6, 'rascalf'              ,'2004-05-25', '2015-10-0','player260.png',67),
(265,1,6, 'bravegerbil'          ,'2004-06-07', '2015-10-0','player261.png',59),
(266,1,6, 'bigbadpigeon'         ,'2004-06-22', '2015-11-0','player262.png',39),
(267,1,6, 'hilariouscamel'       ,'2004-07-08', '2016-00-2','player263.png',83),
(268,1,6, 'attractiveconqueror'  ,'2004-07-12', '2016-02-0','player264.png',35),
(269,1,6, 'megaboomer'           ,'2004-07-24', '2016-04-1','player265.png',15),
(270,1,6, 'enchantedturkey'      ,'2003-11-07', '2013-00-0','player266.png',29),
(271,1,6, 'videogre'             ,'2003-11-19', '2013-00-2','player267.png',56),
(272,1,6, 'gnunou'               ,'2003-11-26', '2013-01-0','player268.png',71),
(273,1,6, 'badept'               ,'2004-00-19', '2013-01-1','player269.png',92),
(274,1,6, 'laserpent'            ,'2004-00-23', '2013-01-2','player270.png',16),
(275,1,6, 'afternoondeer'        ,'2004-00-28', '2013-02-1','player271.png',58),
(276,1,6, 'bonycyborg'           ,'2004-00-31', '2013-03-1','player272.png',28),
(277,1,6, 'emotionalbullfrog'    ,'2004-01-02', '2013-10-0','player273.png',13),
(278,1,6, 'rudegrape'            ,'2004-01-14', '2013-10-2','player274.png',79),
(279,1,6, 'amusedwoodpecker'     ,'2004-01-18', '2014-02-3','player275.png',78),
(280,1,6, 'vagueibis'            ,'2004-02-09', '2014-03-2','player276.png',50),
(281,1,6, 'pyrogue'              ,'2004-02-16', '2014-03-2','player277.png',63),
(282,1,6, 'chimpanzy'            ,'2004-04-09', '2014-04-1','player278.png',78),
(283,1,6, 'sitcommander'         ,'2004-04-10', '2014-06-0','player279.png',96),
(284,1,6, 'paladino'             ,'2004-04-11', '2014-06-2','player280.png',2 ),
(285,1,6, 'flashyflower'         ,'2004-05-13', '2015-03-1','player281.png',78),
(286,1,6, 'blandapple'           ,'2004-05-27', '2015-04-2','player282.png',10),
(287,1,6, 'complexmantis'        ,'2004-06-03', '2015-04-2','player283.png',30),
(288,1,6, 'battlepumpkin'        ,'2004-06-22', '2015-05-1','player284.png',98),
(289,1,6, 'seaelephant'          ,'2004-06-26', '2015-9-03','player285.png',24),
(290,1,6, 'amazingbot'           ,'2004-07-15', '2015-9-11','player286.png',12),
(291,1,6, 'sharcade'             ,'2004-07-16', '2015-9-29','player287.png',86),
(292,1,6, 'bingoblin'            ,'2004-07-17', '2016-01-2','player288.png',72),
(293,1,7, 'unbanshee'           ,'2002-10-30', '2007-10-23','player289.png',14),
(294,1,7, 'pelicandy'           ,'2002-11-07', '2008-01-09','player290.png',50),
(295,1,7, 'radioactiverunner'   ,'2002-11-17', '2008-07-31','player291.png',19),
(296,1,7, 'jumbodino'           ,'2002-11-20', '2008-08-22','player292.png',80),
(297,1,7, 'angelblueberry'      ,'2002-11-27', '2008-10-05','player293.png',48),
(298,1,7, 'sisterjudge'         ,'2003-00-24', '2008-10-14','player294.png',67),
(299,1,7, 'loudlamb'            ,'2003-00-30', '2008-11-09','player295.png',70),
(300,1,7, 'historywarthog'      ,'2003-01-07', '2009-03-21','player296.png',75),
(301,1,7, 'plazy'               ,'2003-01-08', '2009-05-04','player297.png',90),
(302,1,7, 'sparasite'           ,'2003-01-11', '2009-05-17','player298.png',7 ),
(303,1,7, 'gorrilava'           ,'2003-02-18', '2009-06-09','player299.png',94),
(304,1,7, 'komodough'           ,'2003-02-20', '2009-06-24','player300.png',91),
(305,1,7, 'craftybullet'        ,'2003-03-02', '2009-09-16','player301.png' ,48),
(306,1,7, 'vainfalcon'          ,'2003-03-24', '2009-11-28','player302.png',36),
(307,1,7, 'activeyak'           ,'2003-04-09', '2010-02-13','player303.png',38),
(308,1,7, 'breakfastdwarf'      ,'2003-04-10', '2010-03-06','player304.png',43),
(309,1,7, 'sciencegnoll'        ,'2003-04-12', '2010-04-11','player305.png',14),
(310,1,7, 'secretsage'          ,'2003-04-15', '2010-04-15','player306.png',48),
(311,1,7, 'flaminghost'         ,'2003-05-09', '2010-05-27','player307.png',54),
(312,1,7, 'pandata'             ,'2003-05-25', '2010-10-02','player308.png',5 ),
(313,1,7, 'troutwards'          ,'2003-06-07', '2010-10-05','player309.png',24),
(314,1,7, 'chimpanther'         ,'2003-06-22', '2010-11-04','player310.png',57),
(315,1,7, 'kissytortoise'       ,'2003-07-08', '2011-00-24','player311.png',38),
(316,1,7, 'timeblossom'         ,'2003-07-12', '2011-02-02','player312.png',49),
(317,1,7, 'cheatgeneral'        ,'2003-07-24', '2011-04-18','player313.png',74),
(318,1,7, 'idlepanda'           ,'2002-11-07', '2008-00-02','player314.png',72),
(319,1,7, 'awfulchick'          ,'2002-11-19', '2008-00-21','player315.png',70),
(320,1,7, 'frightenedbison'     ,'2002-11-26', '2008-01-07','player316.png',32),
(321,1,7, 'hippony'             ,'2003-00-19', '2008-01-15','player317.png',72),
(322,1,7, 'bachelord'           ,'2003-00-23', '2008-01-21','player318.png',26),
(323,1,7, 'spiderby'            ,'2003-00-28', '2008-02-17','player319.png',92),
(324,1,7, 'flexecutioner'       ,'2003-00-31', '2008-03-14','player320.png',88),
(325,1,7, 'youngocelot'         ,'2003-01-02', '2008-10-04','player321.png',65),
(326,1,7, 'doompriest'          ,'2003-01-14', '2008-10-26','player322.png',64),
(327,1,7, 'coldsquab'           ,'2003-01-18', '2009-02-30','player323.png',96),
(328,1,7, 'ruderunner'          ,'2003-02-09', '2009-03-20','player324.png',93),
(329,1,7, 'blushingcub'         ,'2003-02-16', '2009-03-26','player325.png',73),
(330,1,7, 'glitteringboomer'    ,'2003-04-09', '2009-04-18','player326.png',23),
(331,1,7, 'snowmanta'           ,'2003-04-10', '2009-06-07','player327.png',96),
(332,1,7, 'cocowboy'            ,'2003-04-11', '2009-06-26','player328.png',97),
(333,1,7, 'herringmaster'       ,'2003-05-13', '2010-03-16','player329.png',33),
(334,1,7, 'komodough'           ,'2003-05-27', '2010-04-20','player330.png',29),
(335,1,7, 'grandrose'           ,'2003-06-03', '2010-04-22','player331.png',28),
(336,1,7, 'gamingshadow'        ,'2003-06-22', '2010-05-10','player332.png',31),
(337,1,7, 'fearlessraptor'      ,'2003-06-26', '2010-9-03','player333.png' ,15),
(338,1,7, 'aquacheetah'         ,'2003-07-15', '2010-9-11','player334.png' ,73),
(339,1,7, 'writerbat'           ,'2003-07-16', '2010-9-29','player335.png' ,64),
(340,1,7, 'bigbadwarlock'       ,'2003-07-17', '2011-01-21','player336.png',39);


-- temporales

insert into matches(catId, matHomeTeam, matGuestTeam, matField, matStartTime, matEndTime, matRunsHomeTeam, matRunsGuestTeam) values
(1,1, 2,'Baby Ruth','2000-10-10','2000-10-10', 1,10),
(1,1, 3,'Baby Ruth','2000-10-10','2000-10-10', 8,4 ),
(1,1, 4,'Baby Ruth','2000-10-10','2000-10-10', 9,8 ),
(1,2, 1,'Baby Ruth','2000-10-10','2000-10-10', 3,9 ),
(2,2, 3,'Baby Ruth','2000-10-10','2000-10-10', 9,7 ),
(2,2, 4,'Baby Ruth','2000-10-10','2000-10-10', 8,10),
(2,3, 4,'Baby Ruth','2000-10-10','2000-10-10', 8,9 ),
(2,3, 1,'Baby Ruth','2000-10-10','2000-10-10', 4,6 ),
(3,3, 2,'Baby Ruth','2000-10-10','2000-10-10', 8,3 ),
(3,4, 1,'Baby Ruth','2000-10-10','2000-10-10', 5,6 ),
(3,4, 2,'Baby Ruth','2000-10-10','2000-10-10', 1,10),
(3,4, 3,'Baby Ruth','2000-10-10','2000-10-10', 6,3 ),
(4,5, 6,'Baby Ruth','2000-10-10','2000-10-10', 9,9 ),
(4,5, 8,'Baby Ruth','2000-10-10','2000-10-10', 8,9 ),
(4,5, 7,'Baby Ruth','2000-10-10','2000-10-10', 9,7 ),
(4,6, 5,'Baby Ruth','2000-10-10','2000-10-10', 3,5 ),
(5,6, 7,'Baby Ruth','2000-10-10','2000-10-10', 9,7 ),
(5,6, 8,'Baby Ruth','2000-10-10','2000-10-10', 8,6 ),
(5,7, 8,'Baby Ruth','2000-10-10','2000-10-10', 3,9 ),
(5,7, 7,'Baby Ruth','2000-10-10','2000-10-10', 5,10),
(6,7, 8,'Baby Ruth','2000-10-10','2000-10-10', 6,5 ),
(6,8, 7,'Baby Ruth','2000-10-10','2000-10-10', 1,6 ),
(6,8, 5,'Baby Ruth','2000-10-10','2000-10-10', 7,4 ),
(6,8, 6,'Baby Ruth','2000-10-10','2000-10-10', 9,6 ),
(7,9, 11 ,'Melchor Javier','2000-10-10','2000-10-10', 3,3 ),
(7,9, 12 ,'Melchor Javier','2000-10-10','2000-10-10', 4,5 ),
(7,9, 10 ,'Melchor Javier','2000-10-10','2000-10-10', 6,4 ),
(7,10, 9 ,'Melchor Javier','2000-10-10','2000-10-10', 7,6 ),
(8,10, 12,'Melchor Javier','2000-10-10','2000-10-10', 1,10),
(8,10, 11,'Melchor Javier','2000-10-10','2000-10-10', 7,5 ),
(8,11, 9 ,'Melchor Javier','2000-10-10','2000-10-10', 6,7 ),
(8,11, 10,'Melchor Javier','2000-10-10','2000-10-10', 7,4 ),
(1,11, 12,'Melchor Javier','2000-10-10','2000-10-10', 7,4 ),
(1,12, 9 ,'Melchor Javier','2000-10-10','2000-10-10', 1,8 ),
(1,12, 10,'Melchor Javier','2000-10-10','2000-10-10', 7,4 ),
(1,12, 11,'Melchor Javier','2000-10-10','2000-10-10', 6,8 ),
(2,13, 14,'Melchor Javier','2000-10-10','2000-10-10', 5,5 ),
(2,13, 15,'Melchor Javier','2000-10-10','2000-10-10', 5,8 ),
(2,13, 16,'Melchor Javier','2000-10-10','2000-10-10', 9,9 ),
(2,14, 13,'Melchor Javier','2000-10-10','2000-10-10', 7,9 ),
(3,14, 15,'Melchor Javier','2000-10-10','2000-10-10', 7,9 ),
(3,14, 16,'Melchor Javier','2000-10-10','2000-10-10', 3,7 ),
(3,15, 13,'Melchor Javier','2000-10-10','2000-10-10', 7,3 ),
(3,15, 14,'Melchor Javier','2000-10-10','2000-10-10', 6,4 ),
(4,15, 16,'Melchor Javier','2000-10-10','2000-10-10', 6,9 ),
(4,16, 13,'Melchor Javier','2000-10-10','2000-10-10', 9,5 ),
(4,16, 14,'Melchor Javier','2000-10-10','2000-10-10', 6,3 ),
(4,16, 15,'Melchor Javier','2000-10-10','2000-10-10', 8,6 ),
(5,17, 18,'Melchor Javier','2000-10-10','2000-10-10', 7,10),
(5,17, 20,'Melchor Javier','2000-10-10','2000-10-10', 5,9 ),
(5,17, 19,'Melchor Javier','2000-10-10','2000-10-10', 5,10),
(5,18, 19,'Melchor Javier','2000-10-10','2000-10-10', 6,7 ),
(6,18, 17,'Melchor Javier','2000-10-10','2000-10-10', 8,5 ),
(6,18, 20,'Melchor Javier','2000-10-10','2000-10-10', 5,8 ),
(6,19, 18,'Melchor Javier','2000-10-10','2000-10-10', 8,3 ),
(6,19, 17,'Melchor Javier','2000-10-10','2000-10-10', 3,9 ),
(7,19, 20,'Melchor Javier','2000-10-10','2000-10-10', 7,5 ),
(7,20, 18,'Melchor Javier','2000-10-10','2000-10-10', 6,9 ),
(7,20, 17,'Melchor Javier','2000-10-10','2000-10-10', 9,4 ),
(7,20, 19,'Melchor Javier','2000-10-10','2000-10-10', 3,9 ),
(8,21, 24,'Melchor Javier','2000-10-10','2000-10-10', 5,3 ),
(8,21, 22,'Melchor Javier','2000-10-10','2000-10-10', 5,8 ),
(8,21, 23,'Melchor Javier','2000-10-10','2000-10-10', 5,4 ),
(8,22, 24,'Melchor Javier','2000-10-10','2000-10-10', 7,3 ),
(1,22, 23,'Melchor Javier','2000-10-10','2000-10-10', 1,3 ),
(1,22, 21,'Melchor Javier','2000-10-10','2000-10-10', 4,5 ),
(1,23, 24,'Melchor Javier','2000-10-10','2000-10-10', 3,3 ),
(1,23, 22,'Melchor Javier','2000-10-10','2000-10-10', 3,5 ),
(2,23, 21,'Melchor Javier','2000-10-10','2000-10-10', 9,3 ),
(2,24, 23,'Melchor Javier','2000-10-10','2000-10-10', 7,9 ),
(2,24, 22,'Melchor Javier','2000-10-10','2000-10-10', 1,10),
(2,24, 21,'Melchor Javier','2000-10-10','2000-10-10', 3,3 ),
(3,25, 27,'Melchor Javier','2000-10-10','2000-10-10', 6,5 ),
(3,25, 28,'Melchor Javier','2000-10-10','2000-10-10', 5,6 ),
(3,25, 26,'Melchor Javier','2000-10-10','2000-10-10', 5,9 ),
(3,26, 27,'Melchor Javier','2000-10-10','2000-10-10', 9,7 ),
(4,26, 25,'Melchor Javier','2000-10-10','2000-10-10', 3,6 ),
(4,26, 27,'Melchor Javier','2000-10-10','2000-10-10', 1,10),
(4,27, 28,'Melchor Javier','2000-10-10','2000-10-10', 6,8 ),
(4,27, 25,'Melchor Javier','2000-10-10','2000-10-10', 9,9 ),
(5,27, 26,'Melchor Javier','2000-10-10','2000-10-10', 3,9 ),
(5,28, 27,'Melchor Javier','2000-10-10','2000-10-10', 9,4 ),
(5,28, 25,'Melchor Javier','2000-10-10','2000-10-10', 4,10);

insert into users(perId, ulvId, usrEmail, usrPassword) values
(365, 1,'bdthomas@gmail.net'  , SHA1('12345')),
(366, 1,'bogjobber@gmail.com' , SHA1('12345')),
(367, 2,'jrifkin@gmail.com'   , SHA1('12345')),
(368, 2,'rafasgj@gmail.net'   , SHA1('12345')),
(369, 3,'bjornk@gmail.net'    , SHA1('12345')),
(370, 3,'gozer@gmail.com'     , SHA1('12345')),
(371, 4,'kimvette@outlook.com', SHA1('12345')),
(372, 4,'jlbaumga@gmail.com'  , SHA1('12345')),
(373, 5,'dimensio@gmail.com'  , SHA1('12345')),
(374, 5,'frostman@yahoo.ca'   , SHA1('12345'));

insert into userPlayer(plaId, usrId) values
(330, 1);

insert into lineups(plaId, teaId, lupBattingTurn, posId, matId) values
(5, 1, 2, '2B', 1),
(6, 1, 3, '3B', 1),
(7, 1, 4, 'C ', 1),
(8, 1, 5, 'CF', 1),
(9, 1, 6, 'LF', 1),
(10, 1, 7, 'P ', 1),
(11, 1, 8, 'RF', 1),
(12, 1, 9, 'SS', 1),
(13, 1, 1, '1B', 1),
(17, 2, 2, '2B', 1),
(18, 2, 3, '3B', 1),
(19, 2, 4, 'C ', 1),
(20, 2, 5, 'CF', 1),
(21, 2, 6, 'LF', 1),
(22, 2, 7, 'P ', 1),
(23, 2, 8, 'RF', 1),
(24, 2, 9, 'SS', 1),
(25, 2, 1, '1B', 1),
(29, 3, 2, '2B', 2),
(30, 3, 3, '3B', 2),
(31, 3, 4, 'C ', 2),
(32, 3, 5, 'CF', 2),
(33, 3, 6, 'LF', 2),
(34, 3, 7, 'P ', 2),
(35, 3, 8, 'RF', 2),
(36, 3, 9, 'SS', 2),
(37, 3, 1, '1B', 2),
(41, 4, 2, '2B', 2),
(42, 4, 3, '3B', 2),
(43, 4, 4, 'C ', 2),
(44, 4, 5, 'CF', 2),
(45, 4, 6, 'LF', 2),
(46, 4, 7, 'P ', 2),
(47, 4, 8, 'RF', 2),
(48, 4, 9, 'SS', 2),
(49, 4, 1, '1B', 2),
(53, 5, 2, '2B', 3),
(54, 5, 3, '3B', 3),
(55, 5, 4, 'C ', 3),
(56, 5, 5, 'CF', 3),
(57, 5, 6, 'LF', 3),
(58, 5, 7, 'P ', 3),
(59, 5, 8, 'RF', 3),
(60, 5, 9, 'SS', 3),
(61, 5, 1, '1B', 3);



/* (5   ,1 */    
/* (6   ,1 */
/* (7   ,1 */
/* (8   ,1 */
/* (9   ,1 */
/* (10  ,1 */
/* (11  ,1 */
/* (12  ,1 */
/* (13  ,1 */
/* (14  ,2 */
/* (15  ,2 */
/* (16  ,2 */
/* (17  ,2 */
/* (18  ,2 */
/* (19  ,2 */
/* (20  ,2 */
/* (21  ,2 */
/* (22  ,2 */
/* (23  ,3 */
/* (24  ,3 */
/* (25  ,3 */
/* (26  ,3 */
/* (27  ,3 */
/* (28  ,3 */
/* (29  ,3 */
/* (30  ,3 */
/* (31  ,3 */
/* (32  ,4 */
/* (33  ,4 */
/* (34  ,4 */
/* (35  ,4 */
/* (36  ,4 */
/* (37  ,4 */
/* (38  ,4 */
/* (39  ,4 */
/* (40  ,4 */
/* (41  ,5 */
/* (42  ,5 */
/* (43  ,5 */
/* (44  ,5 */
/* (45  ,5 */
/* (46  ,5 */
/* (47  ,5 */
/* (48  ,5 */
/* (49  ,5 */
/* (50  ,6 */
/* (51  ,6 */
/* (52  ,6 */
/* (53  ,6 */
/* (54  ,6 */
/* (55  ,6 */
/* (56  ,6 */
/* (57  ,6 */
/* (58  ,6 */
/* (59  ,7 */
/* (60  ,7 */
/* (61  ,7 */
/* (62  ,7 */
/* (63  ,7 */
/* (64  ,7 */
/* (65  ,7 */
/* (66  ,7 */
/* (67  ,7 */
/* (68  ,8 */
/* (69  ,8 */
/* (70  ,8 */
/* (71  ,8 */
/* (72  ,8 */
/* (73  ,8 */
/* (74  ,8 */
/* (75  ,8 */
/* (76  ,8 */
/* (77  ,9 */
/* (78  ,9 */
/* (79  ,9 */
/* (80  ,9 */
/* (81  ,9 */
/* (82  ,9 */
/* (83  ,9 */
/* (84  ,9 */
/* (85  ,9 */
/* (86  ,10 */
/* (87  ,10 */
/* (88  ,10 */
/* (89  ,10 */
/* (90  ,10 */
/* (91  ,10 */
/* (92  ,10 */
/* (93  ,10 */
/* (94  ,10 */
/* (95  ,11 */
/* (96  ,11 */
/* (97  ,11 */
/* (98  ,11 */
/* (99  ,11 */
/* (100 ,11 */
/* (101 ,11 */
/* (102 ,11 */
/* (103 ,11 */
/* (104 ,12 */
/* (105 ,12 */
/* (106 ,12 */
/* (107 ,12 */
/* (108 ,12 */
/* (109 ,12 */
/* (110 ,12 */
/* (111 ,12 */
/* (112 ,12 */
/* (113 ,13 */
/* (114 ,13 */
/* (115 ,13 */
/* (116 ,13 */
/* (117 ,13 */
/* (118 ,13 */
/* (119 ,13 */
/* (120 ,13 */
/* (121 ,13 */
/* (122 ,14 */
/* (123 ,14 */
/* (124 ,14 */
/* (125 ,14 */
/* (126 ,14 */
/* (127 ,14 */
/* (128 ,14 */
/* (129 ,14 */
/* (130 ,14 */
/* (131 ,15 */
/* (132 ,15 */
/* (133 ,15 */
/* (134 ,15 */
/* (135 ,15 */
/* (136 ,15 */
/* (137 ,15 */
/* (138 ,15 */
/* (139 ,15 */
/* (140 ,16 */
/* (141 ,16 */
/* (142 ,16 */
/* (143 ,16 */
/* (144 ,16 */
/* (145 ,16 */
/* (146 ,16 */
/* (147 ,16 */
/* (148 ,16 */
/* (149 ,17 */
/* (150 ,17 */
/* (151 ,17 */
/* (152 ,17 */
/* (153 ,17 */
/* (154 ,17 */
/* (155 ,17 */
/* (156 ,17 */
/* (157 ,17 */
/* (158 ,18 */
/* (159 ,18 */
/* (160 ,18 */
/* (161 ,18 */
/* (162 ,18 */
/* (163 ,18 */
/* (164 ,18 */
/* (165 ,18 */
/* (166 ,18 */
/* (167 ,19 */
/* (168 ,19 */
/* (169 ,19 */
/* (170 ,19 */
/* (171 ,19 */
/* (172 ,19 */
/* (173 ,19 */
/* (174 ,19 */
/* (175 ,19 */
/* (176 ,20 */
/* (177 ,20 */
/* (178 ,20 */
/* (179 ,20 */
/* (180 ,20 */
/* (181 ,20 */
/* (182 ,20 */
/* (183 ,20 */
/* (184 ,20 */
/* (185 ,21 */
/* (186 ,21 */
/* (187 ,21 */
/* (188 ,21 */
/* (189 ,21 */
/* (190 ,21 */
/* (191 ,21 */
/* (192 ,21 */
/* (193 ,21 */
/* (194 ,22 */
/* (195 ,22 */
/* (196 ,22 */
/* (197 ,22 */
/* (198 ,22 */
/* (199 ,22 */
/* (200 ,22 */
/* (201 ,22 */
/* (202 ,22 */
/* (203 ,23 */
/* (204 ,23 */
/* (205 ,23 */
/* (206 ,23 */
/* (207 ,23 */
/* (208 ,23 */
/* (209 ,23 */
/* (210 ,23 */
/* (211 ,23 */
/* (212 ,24 */
/* (213 ,24 */
/* (214 ,24 */
/* (215 ,24 */
/* (216 ,24 */
/* (217 ,24 */
/* (218 ,24 */
/* (219 ,24 */
/* (220 ,24 */
/* (221 ,25 */
/* (222 ,25 */
/* (223 ,25 */
/* (224 ,25 */
/* (225 ,25 */
/* (226 ,25 */
/* (227 ,25 */
/* (228 ,25 */
/* (229 ,25 */
/* (230 ,26 */
/* (231 ,26 */
/* (232 ,26 */
/* (233 ,26 */
/* (234 ,26 */
/* (235 ,26 */
/* (236 ,26 */
/* (237 ,26 */
/* (238 ,26 */
/* (239 ,27 */
/* (240 ,27 */
/* (241 ,27 */
/* (242 ,27 */
/* (243 ,27 */
/* (244 ,27 */
/* (245 ,27 */
/* (246 ,27 */
/* (247 ,27 */
/* (248 ,28 */
/* (249 ,28 */
/* (250 ,28 */
/* (251 ,28 */
/* (252 ,28 */
/* (253 ,28 */
/* (254 ,28 */
/* (255 ,28 */
/* (256 ,28 */
/* (257 ,29 */
/* (258 ,29 */
/* (259 ,29 */
/* (260 ,29 */
/* (261 ,29 */
/* (262 ,29 */
/* (263 ,29 */
/* (264 ,29 */
/* (265 ,29 */
/* (266 ,30 */
/* (267 ,30 */
/* (268 ,30 */
/* (269 ,30 */
/* (270 ,30 */
/* (271 ,30 */
/* (272 ,30 */
/* (273 ,30 */
/* (274 ,30 */
/* (275 ,31 */
/* (276 ,31 */
/* (277 ,31 */
/* (278 ,31 */
/* (279 ,31 */
/* (280 ,31 */
/* (281 ,31 */
/* (282 ,31 */
/* (283 ,31 */
/* (284 ,32 */
/* (285 ,32 */
/* (286 ,32 */
/* (287 ,32 */
/* (288 ,32 */
/* (289 ,32 */
/* (290 ,32 */
/* (291 ,32 */
/* (292 ,32 */
/* (293 ,33 */
/* (294 ,33 */
/* (295 ,33 */
/* (296 ,33 */
/* (297 ,33 */
/* (298 ,33 */
/* (299 ,33 */
/* (300 ,33 */
/* (301 ,33 */
/* (302 ,34 */
/* (303 ,34 */
/* (304 ,34 */
/* (305 ,34 */
/* (306 ,34 */
/* (307 ,34 */
/* (308 ,34 */
/* (309 ,34 */
/* (310 ,34 */
/* (311 ,35 */
/* (312 ,35 */
/* (313 ,35 */
/* (314 ,35 */
/* (315 ,35 */
/* (316 ,35 */
/* (317 ,35 */
/* (318 ,35 */
/* (319 ,35 */
/* (320 ,36 */
/* (321 ,36 */
/* (322 ,36 */
/* (323 ,36 */
/* (324 ,36 */
/* (325 ,36 */
/* (326 ,36 */
/* (327 ,36 */
/* (328 ,36 */
/* (329 ,37 */
/* (330 ,37 */
/* (331 ,37 */
/* (332 ,37 */
/* (333 ,37 */
/* (334 ,37 */
/* (335 ,37 */
/* (336 ,37 */
/* (337 ,37 */
/* (338 ,38 */
/* (339 ,38 */
/* (340 ,38 */
/* (341 ,38 */
/* (342 ,38 */
/* (343 ,38 */
/* (344 ,38 */
/* (345 ,38 */
/* (346 ,38 */
/* (347 ,39 */
/* (348 ,39 */
/* (349 ,39 */
/* (350 ,39 */
/* (351 ,39 */
/* (352 ,39 */
/* (353 ,39 */
/* (354 ,39 */
/* (355 ,39 */
/* (356 ,40 */
/* (357 ,40 */
/* (358 ,40 */
/* (359 ,40 */
/* (360 ,40 */
/* (361 ,40 */
/* (362 ,40 */
/* (363 ,40 */
/* (364 ,40 */
/* (365 ,41 */
/* (366 ,41 */
/* (367 ,41 */
/* (368 ,41 */
/* (369 ,41 */
/* (370 ,41 */
/* (371 ,41 */
/* (372 ,41 */
/* (373 ,41 */
/* (374 ,42 */
/* (375 ,42 */
/* (376 ,42 */
/* (377 ,42 */
/* (378 ,42 */
/* (379 ,42 */
/* (380 ,42 */
/* (381 ,42 */
/* (382 ,42 */
/* (383 ,43 */
/* (384 ,43 */
/* (385 ,43 */
/* (386 ,43 */
/* (387 ,43 */
/* (388 ,43 */
/* (389 ,43 */
/* (390 ,43 */
/* (391 ,43 */
/* (392 ,44 */
/* (393 ,44 */
/* (394 ,44 */
/* (395 ,44 */
/* (396 ,44 */
/* (397 ,44 */
/* (398 ,44 */
/* (399 ,44 */
/* (400 ,44 */
/* (401 ,45 */
/* (402 ,45 */
/* (403 ,45 */
/* (404 ,45 */
/* (405 ,45 */
/* (406 ,45 */
/* (407 ,45 */
/* (408 ,45 */
/* (409 ,45 */
/* (410 ,46 */
/* (411 ,46 */
/* (412 ,46 */
/* (413 ,46 */
/* (414 ,46 */
/* (415 ,46 */
/* (416 ,46 */
/* (417 ,46 */
/* (418 ,46 */
/* (419 ,47 */
/* (420 ,47 */
/* (421 ,47 */
/* (422 ,47 */
/* (423 ,47 */
/* (424 ,47 */
/* (425 ,47 */
/* (426 ,47 */
/* (427 ,47 */
/* (428 ,48 */
/* (429 ,48 */
/* (430 ,48 */
/* (431 ,48 */
/* (432 ,48 */
/* (433 ,48 */
/* (434 ,48 */
/* (435 ,48 */
/* (436 ,48 */
/* (437 ,49 */
/* (438 ,49 */
/* (439 ,49 */
/* (440 ,49 */
/* (441 ,49 */
/* (442 ,49 */
/* (443 ,49 */
/* (444 ,49 */
/* (445 ,49 */
/* (446 ,50 */
/* (447 ,50 */
/* (448 ,50 */
/* (449 ,50 */
/* (450 ,50 */
/* (451 ,50 */
/* (452 ,50 */
/* (453 ,50 */
/* (454 ,50 */
/* (455 ,51 */
/* (456 ,51 */
/* (457 ,51 */
/* (458 ,51 */
/* (459 ,51 */
/* (460 ,51 */
/* (461 ,51 */
/* (462 ,51 */
/* (463 ,51 */
/* (464 ,52 */
/* (465 ,52 */
/* (466 ,52 */
/* (467 ,52 */
/* (468 ,52 */
/* (469 ,52 */
/* (470 ,52 */
/* (471 ,52 */
/* (472 ,52 */
/* (473 ,53 */
/* (474 ,53 */
/* (475 ,53 */
/* (476 ,53 */
/* (477 ,53 */
/* (478 ,53 */
/* (479 ,53 */
/* (480 ,53 */
/* (481 ,53 */
/* (482 ,54 */
/* (483 ,54 */
/* (484 ,54 */
/* (485 ,54 */
/* (486 ,54 */
/* (487 ,54 */
/* (488 ,54 */
/* (489 ,54 */
/* (490 ,54 */
/* (491 ,55 */
/* (492 ,55 */
/* (493 ,55 */
/* (494 ,55 */
/* (495 ,55 */
/* (496 ,55 */
/* (497 ,55 */
/* (498 ,55 */
/* (499 ,55 */
/* (500 ,56 */
/* (501 ,56 */
/* (502 ,56 */
/* (503 ,56 */
/* (504 ,56 */
/* (505 ,56 */
/* (506 ,56 */
/* (507 ,56 */
/* (508 ,56 */
/* (509 ,57 */
/* (510 ,57 */
/* (511 ,57 */
/* (512 ,57 */
/* (513 ,57 */
/* (514 ,57 */
/* (515 ,57 */
/* (516 ,57 */
/* (517 ,57 */
/* (518 ,58 */
/* (519 ,58 */
/* (520 ,58 */
/* (521 ,58 */
/* (522 ,58 */
/* (523 ,58 */
/* (524 ,58 */
/* (525 ,58 */
/* (526 ,58 */
/* (527 ,59 */
/* (528 ,59 */
/* (529 ,59 */
/* (530 ,59 */
/* (531 ,59 */
/* (532 ,59 */
/* (533 ,59 */
/* (534 ,59 */
/* (535 ,59 */
/* (536 ,60 */
/* (537 ,60 */
/* (538 ,60 */
/* (539 ,60 */
/* (540 ,60 */
/* (541 ,60 */
/* (542 ,60 */
/* (543 ,60 */
/* (544 ,60 */
/* (545 ,61 */
/* (546 ,61 */
/* (547 ,61 */
/* (548 ,61 */
/* (549 ,61 */
/* (550 ,61 */
/* (551 ,61 */
/* (552 ,61 */
/* (553 ,61 */
/* (554 ,62 */
/* (555 ,62 */
/* (556 ,62 */
/* (557 ,62 */
/* (558 ,62 */
/* (559 ,62 */
/* (560 ,62 */
/* (561 ,62 */
/* (562 ,62 */
/* (563 ,63 */
/* (564 ,63 */
/* (565 ,63 */
/* (566 ,63 */
/* (567 ,63 */
/* (568 ,63 */
/* (569 ,63 */
/* (570 ,63 */
/* (571 ,63 */
/* (572 ,64 */
/* (573 ,64 */
/* (574 ,64 */
/* (575 ,64 */
/* (576 ,64 */
/* (577 ,64 */
/* (578 ,64 */
/* (579 ,64 */
/* (580 ,64 */
/* (581 ,65 */
/* (582 ,65 */
/* (583 ,65 */
/* (584 ,65 */
/* (585 ,65 */
/* (586 ,65 */
/* (587 ,65 */
/* (588 ,65 */
/* (589 ,65 */
/* (590 ,66 */
/* (591 ,66 */
/* (592 ,66 */
/* (593 ,66 */
/* (594 ,66 */
/* (595 ,66 */
/* (596 ,66 */
/* (597 ,66 */
/* (598 ,66 */
/* (599 ,67 */
/* (600 ,67 */
/* (601 ,67 */
/* (602 ,67 */
/* (603 ,67 */
/* (604 ,67 */
/* (605 ,67 */
/* (606 ,67 */
/* (607 ,67 */
/* (608 ,68 */
/* (609 ,68 */
/* (610 ,68 */
/* (611 ,68 */
/* (612 ,68 */
/* (613 ,68 */
/* (614 ,68 */
/* (615 ,68 */
/* (616 ,68 */
/* (617 ,69 */
/* (618 ,69 */
/* (619 ,69 */
/* (620 ,69 */
/* (621 ,69 */
/* (622 ,69 */
/* (623 ,69 */
/* (624 ,69 */
/* (625 ,69 */
/* (626 ,70 */
/* (627 ,70 */
/* (628 ,70 */
/* (629 ,70 */
/* (630 ,70 */
/* (631 ,70 */
/* (632 ,70 */
/* (633 ,70 */
/* (634 ,70 */
/* (635 ,71 */
/* (636 ,71 */
/* (637 ,71 */
/* (638 ,71 */
/* (639 ,71 */
/* (640 ,71 */
/* (641 ,71 */
/* (642 ,71 */
/* (643 ,71 */
/* (644 ,72 */
/* (645 ,72 */
/* (646 ,72 */
/* (647 ,72 */
/* (648 ,72 */
/* (649 ,72 */
/* (650 ,72 */
/* (651 ,72 */
/* (652 ,72 */
/* (653 ,73 */
/* (654 ,73 */
/* (655 ,73 */
/* (656 ,73 */
/* (657 ,73 */
/* (658 ,73 */
/* (659 ,73 */
/* (660 ,73 */
/* (661 ,73 */
/* (662 ,74 */
/* (663 ,74 */
/* (664 ,74 */
/* (665 ,74 */
/* (666 ,74 */
/* (667 ,74 */
/* (668 ,74 */
/* (669 ,74 */
/* (670 ,74 */
/* (671 ,75 */
/* (672 ,75 */
/* (673 ,75 */
/* (674 ,75 */
/* (675 ,75 */
/* (676 ,75 */
/* (677 ,75 */
/* (678 ,75 */
/* (679 ,75 */
/* (680 ,76 */
/* (681 ,76 */
/* (682 ,76 */
/* (683 ,76 */
/* (684 ,76 */
/* (685 ,76 */
/* (686 ,76 */
/* (687 ,76 */
/* (688 ,76 */
/* (689 ,77 */
/* (690 ,77 */
/* (691 ,77 */
/* (692 ,77 */
/* (693 ,77 */
/* (694 ,77 */
/* (695 ,77 */
/* (696 ,77 */
/* (697 ,77 */
/* (698 ,78 */
/* (699 ,78 */
/* (700 ,78 */
/* (701 ,78 */
/* (702 ,78 */
/* (703 ,78 */
/* (704 ,78 */
/* (705 ,78 */
/* (706 ,78 */
/* (707 ,79 */
/* (708 ,79 */
/* (709 ,79 */
/* (710 ,79 */
/* (711 ,79 */
/* (712 ,79 */
/* (713 ,79 */
/* (714 ,79 */
/* (715 ,79 */
/* (716 ,80 */
/* (717 ,80 */
/* (718 ,80 */
/* (719 ,80 */
/* (720 ,80 */
/* (721 ,80 */
/* (722 ,80 */
/* (723 ,80 */
/* (724 ,80 */
/* (725 ,81 */
/* (726 ,81 */
/* (727 ,81 */
/* (728 ,81 */
/* (729 ,81 */
/* (730 ,81 */
/* (731 ,81 */
/* (732 ,81 */
/* (733 ,81 */
/* (734 ,82 */
/* (735 ,82 */
/* (736 ,82 */
/* (737 ,82 */
/* (738 ,82 */
/* (739 ,82 */
/* (740 ,82 */
/* (741 ,82 */
/* (742 ,82 */
/* (743 ,83 */
/* (744 ,83 */
/* (745 ,83 */
/* (746 ,83 */
/* (747 ,83 */
/* (748 ,83 */
/* (749 ,83 */
/* (750 ,83 */
/* (751 ,83 */
/* (752 ,84 */
/* (753 ,84 */
/* (754 ,84 */
/* (755 ,84 */
/* (756 ,84 */
/* (757 ,84 */
/* (758 ,84 */
/* (759 ,84 */
/* (760 ,84 */
/* (761 ,85 */
/* (762 ,85 */
/* (763 ,85 */
/* (764 ,85 */
/* (765 ,85 */
/* (766 ,85 */
/* (767 ,85 */
/* (768 ,85 */
/* (769 ,85 */
/* (770 ,86 */
/* (771 ,86 */
/* (772 ,86 */
/* (773 ,86 */
/* (774 ,86 */
/* (775 ,86 */
/* (776 ,86 */
/* (777 ,86 */
/* (778 ,86 */
/* (779 ,87 */
/* (780 ,87 */
/* (781 ,87 */
/* (782 ,87 */
/* (783 ,87 */
/* (784 ,87 */
/* (785 ,87 */
/* (786 ,87 */
/* (787 ,87 */
/* (788 ,88 */
/* (789 ,88 */
/* (790 ,88 */
/* (791 ,88 */
/* (792 ,88 */
/* (793 ,88 */
/* (794 ,88 */
/* (795 ,88 */
/* (796 ,88 */
/* (797 ,89 */
/* (798 ,89 */
/* (799 ,89 */
/* (800 ,89 */
/* (801 ,89 */
/* (802 ,89 */
/* (803 ,89 */
/* (804 ,89 */
/* (805 ,89 */
/* (806 ,90 */
/* (807 ,90 */
/* (808 ,90 */
/* (809 ,90 */
/* (810 ,90 */
/* (811 ,90 */
/* (812 ,90 */
/* (813 ,90 */
/* (814 ,90 */
/* (815 ,91 */
/* (816 ,91 */
/* (817 ,91 */
/* (818 ,91 */
/* (819 ,91 */
/* (820 ,91 */
/* (821 ,91 */
/* (822 ,91 */
/* (823 ,91 */
/* (824 ,92 */
/* (825 ,92 */
/* (826 ,92 */
/* (827 ,92 */
/* (828 ,92 */
/* (829 ,92 */
/* (830 ,92 */
/* (831 ,92 */
/* (832 ,92 */
/* (833 ,93 */
/* (834 ,93 */
/* (835 ,93 */
/* (836 ,93 */
/* (837 ,93 */
/* (838 ,93 */
/* (839 ,93 */
/* (840 ,93 */
/* (841 ,93 */
/* (842 ,94 */
/* (843 ,94 */
/* (844 ,94 */
/* (845 ,94 */
/* (846 ,94 */
/* (847 ,94 */
/* (848 ,94 */
/* (849 ,94 */
/* (850 ,94 */
/* (851 ,95 */
/* (852 ,95 */
/* (853 ,95 */
/* (854 ,95 */
/* (855 ,95 */
/* (856 ,95 */
/* (857 ,95 */
/* (858 ,95 */
/* (859 ,95 */
/* (860 ,96 */
/* (861 ,96 */
/* (862 ,96 */
/* (863 ,96 */
/* (864 ,96 */
/* (865 ,96 */
/* (866 ,96 */
/* (867 ,96 */
/* (868 ,96 */
/* (869 ,97 */
/* (870 ,97 */
/* (871 ,97 */
/* (872 ,97 */
/* (873 ,97 */
/* (874 ,97 */
/* (875 ,97 */
/* (876 ,97 */
/* (877 ,97 */
/* (878 ,98 */
/* (879 ,98 */
/* (880 ,98 */
/* (881 ,98 */
/* (882 ,98 */
/* (883 ,98 */
/* (884 ,98 */
/* (885 ,98 */
/* (886 ,98 */
/* (887 ,99 */
/* (888 ,99 */
/* (889 ,99 */
/* (890 ,99 */
/* (891 ,99 */
/* (892 ,99 */
/* (893 ,99 */
/* (894 ,99 */
/* (895 ,99 */
/* (896 ,100 */
/* (897 ,100 */
/* (898 ,100 */
/* (899 ,100 */
/* (900 ,100 */
/* (901 ,100 */
/* (902 ,100 */
/* (903 ,100 */
/* (904 ,100 */
/* (905 ,101 */
/* (906 ,101 */
/* (907 ,101 */
/* (908 ,101 */
/* (909 ,101 */
/* (910 ,101 */
/* (911 ,101 */
/* (912 ,101 */
/* (913 ,101 */
/* (914 ,102 */
/* (915 ,102 */
/* (916 ,102 */
/* (917 ,102 */
/* (918 ,102 */
/* (919 ,102 */
/* (920 ,102 */
/* (921 ,102 */
/* (922 ,102 */
/* (923 ,103 */
/* (924 ,103 */
/* (925 ,103 */
/* (926 ,103 */
/* (927 ,103 */
/* (928 ,103 */
/* (929 ,103 */
/* (930 ,103 */
/* (931 ,103 */
/* (932 ,104 */
/* (933 ,104 */
/* (934 ,104 */
/* (935 ,104 */
/* (936 ,104 */
/* (937 ,104 */
/* (938 ,104 */
/* (939 ,104 */
/* (940 ,104 */
/* (941 ,105 */
/* (942 ,105 */
/* (943 ,105 */
/* (944 ,105 */
/* (945 ,105 */
/* (946 ,105 */
/* (947 ,105 */
/* (948 ,105 */
/* (949 ,105 */
/* (950 ,106 */
/* (951 ,106 */
/* (952 ,106 */
/* (953 ,106 */
/* (954 ,106 */
/* (955 ,106 */
/* (956 ,106 */
/* (957 ,106 */
/* (958 ,106 */
/* (959 ,107 */
/* (960 ,107 */
/* (961 ,107 */
/* (962 ,107 */
/* (963 ,107 */
/* (964 ,107 */
/* (965 ,107 */
/* (966 ,107 */
/* (967 ,107 */
/* (968 ,108 */
/* (969 ,108 */
/* (970 ,108 */
/* (971 ,108 */
/* (972 ,108 */
/* (973 ,108 */
/* (974 ,108 */
/* (975 ,108 */
/* (976 ,108 */
/* (977 ,109 */
/* (978 ,109 */
/* (979 ,109 */
/* (980 ,109 */
/* (981 ,109 */
/* (982 ,109 */
/* (983 ,109 */
/* (984 ,109 */
/* (985 ,109 */
/* (986 ,110 */
/* (987 ,110 */
/* (988 ,110 */
/* (989 ,110 */
/* (990 ,110 */
/* (991 ,110 */
/* (992 ,110 */
/* (993 ,110 */
/* (994 ,110 */
/* (995 ,111 */
/* (996 ,111 */
/* (997 ,111 */
/* (998 ,111 */
/* (999 ,111 */
/* (1000,111 */
/* (1001,111 */
/* (1002,111 */
/* (1003,111 */
/* (1004,112 */
/* (1005,112 */
/* (1006,112 */
/* (1007,112 */
/* (1008,112 */
/* (1009,112 */
/* (1010,112 */
/* (1011,112 */
/* (1012,112 */
/* (1013,113 */
/* (1014,113 */
/* (1015,113 */
/* (1016,113 */
/* (1017,113 */
/* (1018,113 */
/* (1019,113 */
/* (1020,113 */
/* (1021,113 */
/* (1022,114 */
/* (1023,114 */
/* (1024,114 */
/* (1025,114 */
/* (1026,114 */
/* (1027,114 */
/* (1028,114 */
/* (1029,114 */
/* (1030,114 */
/* (1031,115 */
/* (1032,115 */
/* (1033,115 */
/* (1034,115 */
/* (1035,115 */
/* (1036,115 */
/* (1037,115 */
/* (1038,115 */
/* (1039,115 */
/* (1040,116 */
/* (1041,116 */
/* (1042,116 */
/* (1043,116 */
/* (1044,116 */
/* (1045,116 */
/* (1046,116 */
/* (1047,116 */
/* (1048,116 */
/* (1049,117 */
/* (1050,117 */
/* (1051,117 */
/* (1052,117 */
/* (1053,117 */
/* (1054,117 */
/* (1055,117 */
/* (1056,117 */
/* (1057,117 */
/* (1058,118 */
/* (1059,118 */
/* (1060,118 */
/* (1061,118 */
/* (1062,118 */
/* (1063,118 */
/* (1064,118 */
/* (1065,118 */
/* (1066,118 */
/* (1067,119 */
/* (1068,119 */
/* (1069,119 */
/* (1070,119 */
/* (1071,119 */
/* (1072,119 */
/* (1073,119 */
/* (1074,119 */
/* (1075,119 */
/* (1076,120 */
/* (1077,120 */
/* (1078,120 */
/* (1079,120 */
/* (1080,120 */
/* (1081,120 */
/* (1082,120 */
/* (1083,120 */
/* (1084,120 */
/* (1085,121 */
/* (1086,121 */
/* (1087,121 */
/* (1088,121 */
/* (1089,121 */
/* (1090,121 */
/* (1091,121 */
/* (1092,121 */
/* (1093,121 */
/* (1094,122 */
/* (1095,122 */
/* (1096,122 */
/* (1097,122 */
/* (1098,122 */
/* (1099,122 */
/* (1100,122 */
/* (1101,122 */
/* (1102,122 */
/* (1103,123 */
/* (1104,123 */
/* (1105,123 */
/* (1106,123 */
/* (1107,123 */
/* (1108,123 */
/* (1109,123 */
/* (1110,123 */
/* (1111,123 */
/* (1112,124 */
/* (1113,124 */
/* (1114,124 */
/* (1115,124 */
/* (1116,124 */
/* (1117,124 */
/* (1118,124 */
/* (1119,124 */
/* (1120,124 */
/* (1121,125 */
/* (1122,125 */
/* (1123,125 */
/* (1124,125 */
/* (1125,125 */
/* (1126,125 */
/* (1127,125 */
/* (1128,125 */
/* (1129,125 */
/* (1130,126 */
/* (1131,126 */
/* (1132,126 */
/* (1133,126 */
/* (1134,126 */
/* (1135,126 */
/* (1136,126 */
/* (1137,126 */
/* (1138,126 */
/* (1139,127 */
/* (1140,127 */
/* (1141,127 */
/* (1142,127 */
/* (1143,127 */
/* (1144,127 */
/* (1145,127 */
/* (1146,127 */
/* (1147,127 */
/* (1148,128 */
/* (1149,128 */
/* (1150,128 */
/* (1151,128 */
/* (1152,128 */
/* (1153,128 */
/* (1154,128 */
/* (1155,128 */
/* (1156,128 */
/* (1157,129 */
/* (1158,129 */
/* (1159,129 */
/* (1160,129 */
/* (1161,129 */
/* (1162,129 */
/* (1163,129 */
/* (1164,129 */
/* (1165,129 */
/* (1166,130 */
/* (1167,130 */
/* (1168,130 */
/* (1169,130 */
/* (1170,130 */
/* (1171,130 */
/* (1172,130 */
/* (1173,130 */
/* (1174,130 */
/* (1175,131 */
/* (1176,131 */
/* (1177,131 */
/* (1178,131 */
/* (1179,131 */
/* (1180,131 */
/* (1181,131 */
/* (1182,131 */
/* (1183,131 */
/* (1184,132 */
/* (1185,132 */
/* (1186,132 */
/* (1187,132 */
/* (1188,132 */
/* (1189,132 */
/* (1190,132 */
/* (1191,132 */
/* (1192,132 */
/* (1193,133 */
/* (1194,133 */
/* (1195,133 */
/* (1196,133 */
/* (1197,133 */
/* (1198,133 */
/* (1199,133 */
/* (1200,133 */
/* (1201,133 */
/* (1202,134 */
/* (1203,134 */
/* (1204,134 */
/* (1205,134 */
/* (1206,134 */
/* (1207,134 */
/* (1208,134 */
/* (1209,134 */
/* (1210,134 */
/* (1211,135 */
/* (1212,135 */
/* (1213,135 */
/* (1214,135 */
/* (1215,135 */
/* (1216,135 */
/* (1217,135 */
/* (1218,135 */
/* (1219,135 */
/* (1220,136 */
/* (1221,136 */
/* (1222,136 */
/* (1223,136 */
/* (1224,136 */
/* (1225,136 */
/* (1226,136 */
/* (1227,136 */
/* (1228,136 */
/* (1229,137 */
/* (1230,137 */
/* (1231,137 */
/* (1232,137 */
/* (1233,137 */
/* (1234,137 */
/* (1235,137 */
/* (1236,137 */
/* (1237,137 */
/* (1238,138 */
/* (1239,138 */
/* (1240,138 */
/* (1241,138 */
/* (1242,138 */
/* (1243,138 */
/* (1244,138 */
/* (1245,138 */
/* (1246,138 */
/* (1247,139 */
/* (1248,139 */
/* (1249,139 */
/* (1250,139 */
/* (1251,139 */
/* (1252,139 */
/* (1253,139 */
/* (1254,139 */
/* (1255,139 */
/* (1256,140 */
/* (1257,140 */
/* (1258,140 */
/* (1259,140 */
/* (1260,140 */
/* (1261,140 */
/* (1262,140 */
/* (1263,140 */
/* (1264,140 */
/* (1265,141 */
/* (1266,141 */
/* (1267,141 */
/* (1268,141 */
/* (1269,141 */
/* (1270,141 */
/* (1271,141 */
/* (1272,141 */
/* (1273,141 */
/* (1274,142 */
/* (1275,142 */
/* (1276,142 */
/* (1277,142 */
/* (1278,142 */
/* (1279,142 */
/* (1280,142 */
/* (1281,142 */
/* (1282,142 */
/* (1283,143 */
/* (1284,143 */
/* (1285,143 */
/* (1286,143 */
/* (1287,143 */
/* (1288,143 */
/* (1289,143 */
/* (1290,143 */
/* (1291,143 */
/* (1292,144 */
/* (1293,144 */
/* (1294,144 */
/* (1295,144 */
/* (1296,144 */
/* (1297,144 */
/* (1298,144 */
/* (1299,144 */
/* (1300,144 */
/* (1301,145 */
/* (1302,145 */
/* (1303,145 */
/* (1304,145 */
/* (1305,145 */
/* (1306,145 */
/* (1307,145 */
/* (1308,145 */
/* (1309,145 */
/* (1310,146 */
/* (1311,146 */
/* (1312,146 */
/* (1313,146 */
/* (1314,146 */
/* (1315,146 */
/* (1316,146 */
/* (1317,146 */
/* (1318,146 */
/* (1319,147 */
/* (1320,147 */
/* (1321,147 */
/* (1322,147 */
/* (1323,147 */
/* (1324,147 */
/* (1325,147 */
/* (1326,147 */
/* (1327,147 */
/* (1328,148 */
/* (1329,148 */
/* (1330,148 */
/* (1331,148 */
/* (1332,148 */
/* (1333,148 */
/* (1334,148 */
/* (1335,148 */
/* (1336,148 */
/* (1337,149 */
/* (1338,149 */
/* (1339,149 */
/* (1340,149 */
/* (1341,149 */
/* (1342,149 */
/* (1343,149 */
/* (1344,149 */
/* (1345,149 */
/* (1346,150 */
/* (1347,150 */
/* (1348,150 */
/* (1349,150 */
/* (1350,150 */
/* (1351,150 */
/* (1352,150 */
/* (1353,150 */
/* (1354,150 */
/* (1355,151 */
/* (1356,151 */
/* (1357,151 */
/* (1358,151 */
/* (1359,151 */
/* (1360,151 */
/* (1361,151 */
/* (1362,151 */
/* (1363,151 */
/* (1364,152 */
/* (1365,152 */
/* (1366,152 */
/* (1367,152 */
/* (1368,152 */
/* (1369,152 */
/* (1370,152 */
/* (1371,152 */
/* (1372,152 */
/* (1373,153 */
/* (1374,153 */
/* (1375,153 */
/* (1376,153 */
/* (1377,153 */
/* (1378,153 */
/* (1379,153 */
/* (1380,153 */
/* (1381,153 */
/* (1382,154 */
/* (1383,154 */
/* (1384,154 */
/* (1385,154 */
/* (1386,154 */
/* (1387,154 */
/* (1388,154 */
/* (1389,154 */
/* (1390,154 */
/* (1391,155 */
/* (1392,155 */
/* (1393,155 */
/* (1394,155 */
/* (1395,155 */
/* (1396,155 */
/* (1397,155 */
/* (1398,155 */
/* (1399,155 */
/* (1400,156 */
/* (1401,156 */
/* (1402,156 */
/* (1403,156 */
/* (1404,156 */
/* (1405,156 */
/* (1406,156 */
/* (1407,156 */
/* (1408,156 */
/* (1409,157 */
/* (1410,157 */
/* (1411,157 */
/* (1412,157 */
/* (1413,157 */
/* (1414,157 */
/* (1415,157 */
/* (1416,157 */
/* (1417,157 */
/* (1418,158 */
/* (1419,158 */
/* (1420,158 */
/* (1421,158 */
/* (1422,158 */
/* (1423,158 */
/* (1424,158 */
/* (1425,158 */
/* (1426,158 */
/* (1427,159 */
/* (1428,159 */
/* (1429,159 */
/* (1430,159 */
/* (1431,159 */
/* (1432,159 */
/* (1433,159 */
/* (1434,159 */
/* (1435,159 */
/* (1436,160 */
/* (1437,160 */
/* (1438,160 */
/* (1439,160 */
/* (1440,160 */
/* (1441,160 */
/* (1442,160 */
/* (1443,160 */
/* (1444,160 */
/* (1445,161 */
/* (1446,161 */
/* (1447,161 */
/* (1448,161 */
/* (1449,161 */
/* (1450,161 */
/* (1451,161 */
/* (1452,161 */
/* (1453,161 */
/* (1454,162 */
/* (1455,162 */
/* (1456,162 */
/* (1457,162 */
/* (1458,162 */
/* (1459,162 */
/* (1460,162 */
/* (1461,162 */
/* (1462,162 */
/* (1463,163 */
/* (1464,163 */
/* (1465,163 */
/* (1466,163 */
/* (1467,163 */
/* (1468,163 */
/* (1469,163 */
/* (1470,163 */
/* (1471,163 */
/* (1472,164 */
/* (1473,164 */
/* (1474,164 */
/* (1475,164 */
/* (1476,164 */
/* (1477,164 */
/* (1478,164 */
/* (1479,164 */
/* (1480,164 */
/* (1481,165 */
/* (1482,165 */
/* (1483,165 */
/* (1484,165 */
/* (1485,165 */
/* (1486,165 */
/* (1487,165 */
/* (1488,165 */
/* (1489,165 */
/* (1490,166 */
/* (1491,166 */
/* (1492,166 */
/* (1493,166 */
/* (1494,166 */
/* (1495,166 */
/* (1496,166 */
/* (1497,166 */
/* (1498,166 */
/* (1499,167 */
/* (1500,167 */
/* (1501,167 */
/* (1502,167 */
/* (1503,167 */
/* (1504,167 */
/* (1505,167 */
/* (1506,167 */
/* (1507,167 */
/* (1508,168 */
/* (1509,168 */
/* (1510,168 */
/* (1511,168 */
/* (1512,168 */
/* (1513,168 */
/* (1514,168 */
/* (1515,168 */
/* (1516,168 */
