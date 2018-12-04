create database if not exists
baseball;

use baseball;

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
    teaImage varchar(35) not null,
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


INSERT INTO `teams` (`teaId`, `staId`, `teaName`, `teaImage`, `catId`, `coaId`, `seaId`) VALUES
(1,   1,  'Dodgers',     'team1.png',   1,            1,   36),  
(2,   1,  'bulldogs',    'team2.png',   1,   2,    36),
(3,   1,  'Angeles',     'team3.png',   1,            3,   36),  
(4,   1,  'Naranjeros',  'team4.png',   1,            4,   36),  
(5,   1,  'Toros',       'team5.png',   1,            5,   36),  
(6,   1,  'washington',  'team6.png',   1,   6,    36),
(7,   1,  'Tigers',      'team7.png',   1,            7,   36),  
(8,   1,  'Falcons',     'team8.png',   1,            8,   36),  
(9,   1,  'San Francisco','team9.png',  1,   9,    36),
(10,  1,  'Cardinales',  'team10.png',  2,            10,  36),  
(11,  1,  'Matanzas',    'team11.png',  2,            11,  36),  
(12,  1,  'Captains',    'team12.png',  2,            12,  36),  
(13,  1,  'Minners',     'team13.png',  2,            1,   36),  
(14,  1,  'Conodors',    'team14.png',  1,            14,  36),  
(15,  1,  'Gladiators',  'team15.png',  1,            15,  36),  
(16,  1,  'Buffalo',     'team16.png',  2,            16,  36),  
(17,  1,  'Toronto',     'team17.png',  2,            17,  36),  
(18,  1,  'Twins',       'team18.png',  2,            18,  36),  
(19,  1,  'Giants',      'team19.png',  2,            19,  36),  
(20,  1,  'Pirates',     'team20.png',  1,            20,  36),  
(21,  1,  'Rays',        'team21.png',  3,            21,  36),  
(22,  1,  'Mets',        'team22.png',  3,            22,  36),  
(23,  1,  'Texas',       'team23.png',  3,            23,  36),  
(24,  1,  'Padres',      'team24.png',  3,            24,  36),  
(25,  1,  'Rockies',     'team25.png',  4,            25,  36),  
(26,  1,  'Reds',        'team26.png',  4,            26,  36),  
(27,  1,  'Miami',       'team27.png',  4,            27,  36),  
(28,  1,  'Yankees',     'team28.png',  4,            28,  36);  

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
(41 ,1,4, 'gorillamp'    ,'2012-12-24','2018-04-28','player37.png',87),        
(42 ,1,4, 'gringoliath'  ,'2013-01-21','2018-06-29','player38.png',82),
(43 ,1,4, 'scraptor'     ,'2013-02-10','2017-06-10','player39.png',5),
(44 ,1,4, 'sha-doh'      ,'2013-02-24','2017-06-24','player40.png',42),
(45 ,1,4, 'amazingcoffee','2013-03-05','2017-07-02','player41.png',58),
(46 ,1,4, 'meanfox'      ,'2013-03-19','2017-07-08','player42.png',24),
(47 ,1,4, 'spotlessguy'  ,'2013-03-26','2017-07-09','player43.png',65),
(48 ,1,4, 'brightcolonel','2013-04-15','2017-07-27','player44.png',88),
(49 ,1,4, 'starkkit'     ,'2013-04-27','2017-08-12','player45.png',24),
(50 ,1,4, 'fruitpug'     ,'2013-05-12','2017-08-21','player46.png',47),
(51 ,1,4, 'amigoliath'   ,'2013-05-14','2017-09-03','player47.png',21),
(52 ,1,4, 'masteroid'    ,'2013-05-15','2017-09-10','player48.png',59),
-- escuelita
-- equipo 1
(53 ,1,5 , 'sealixir'         ,'2010-11-23', '2016-12-15', 'player49.png',43),
(54 ,1,5 , 'amighost'         ,'2010-12-03', '2017-01-05', 'player50.png',26),
(55 ,1,5 , 'feistyrhino'      ,'2011-01-26', '2017-01-31', 'player51.png',27),
(56 ,1,5 , 'trustywerewolf'   ,'2011-02-01', '2017-03-06', 'player52.png',9 ),
(57 ,1,5 , 'rockmantis'       ,'2011-02-15', '2017-04-07', 'player53.png',69),
(58 ,1,5 , 'phonycoconut'     ,'2011-03-23', '2017-05-03', 'player54.png',29),
(59 ,1,5 , 'filthyrhino'      ,'2011-04-02', '2017-05-08', 'player55.png',37),
(60 ,1,5 , 'bouncingcranberry','2011-04-18', '2017-06-29', 'player56.png',91),
(61 ,1,5 , 'bambinosaur'      ,'2011-05-09', '2017-08-17', 'player57.png',78),
(62 ,1,5 , 'panthermal'       ,'2011-05-12', '2017-10-16', 'player58.png',63),
(63 ,1,5 , 'leopardon'        ,'2011-05-13', '2017-11-22', 'player59.png',10),
(64 ,1,5 , 'dwarvos'          ,'2011-05-14', '2017-12-07', 'player60.png',92),
(65 ,1,6 , 'antiqueape'       ,'2011-05-28', '2017-12-15', 'player61.png',11),
(66 ,1,6 , 'riddlemallard'    ,'2011-06-05', '2018-01-22', 'player62.png',83),
(67 ,1,6 , 'traveldroid'      ,'2011-06-17', '2018-02-04', 'player63.png',3 ),
(68 ,1,6 , 'silversalmon'     ,'2011-06-23', '2018-02-13', 'player64.png',18),
(69 ,1,6 , 'complexemu'       ,'2011-08-01', '2018-02-16', 'player65.png',9 ),
(70 ,1,6 , 'enchantedgangster','2011-08-04', '2018-02-27', 'player66.png',38),
(71 ,1,6 , 'turkiwi'          ,'2011-08-07', '2018-04-29', 'player67.png',56),
(72 ,1,6 , 'wallaby'          ,'2011-08-18', '2018-05-11', 'player68.png',91),
(73 ,1,6 , 'bambooccaneer'    ,'2011-08-21', '2018-06-24', 'player69.png',74),
(74 ,1,6 , 'falcondor'        ,'2011-08-26', '2018-06-27', 'player70.png',34),
(75 ,1,6 , 'swiftpredator'    ,'2011-09-08', '2018-07-04', 'player71.png',71),
(76 ,1,6 , 'candypattern'     ,'2011-09-17', '2018-07-22', 'player72.png',73),
(77 ,1,7 , 'handsomeurchin'   ,'2011-09-18', '2018-08-07', 'player73.png',90),
(78 ,1,7 , 'carefuldove'      ,'2010-11-30', '2016-11-28', 'player74.png',61),
(79 ,1,7 , 'rustyblizzard'    ,'2010-12-03', '2016-12-06', 'player75.png',41),
(80 ,1,7 , 'purepheasant'     ,'2010-12-04', '2017-01-19', 'player76.png',68),
(81 ,1,7 , 'devile'           ,'2010-12-05', '2017-02-02', 'player77.png',38),
(82 ,1,7 , 'stingraycharles'  ,'2010-12-10', '2017-02-17', 'player78.png',41),
(83 ,1,7 , 'guineapiggy'      ,'2010-12-20', '2017-03-19', 'player79.png',31),
(84 ,1,7 , 'fellama'          ,'2011-01-02', '2017-03-23', 'player80.png',41),
(85 ,1,7 , 'smoothbuffalo'    ,'2011-01-14', '2017-05-15', 'player81.png',55),
(86 ,1,7 , 'autumnwallaby'    ,'2011-02-09', '2017-06-28', 'player82.png',20),
(87 ,1,7 , 'fruitvanilla'     ,'2011-02-10', '2017-07-01', 'player83.png',65),
(88 ,1,7 , 'miniant'          ,'2011-02-28', '2017-07-02', 'player84.png',94),
(89 ,1,8 , 'memorykit'        ,'2011-03-05', '2017-07-03', 'player85.png',37),
(90 ,1,8 , 'lakefrogger'      ,'2011-04-14', '2017-08-15', 'player86.png',25),
(91 ,1,8 , 'lockroach'        ,'2011-05-16', '2017-09-13', 'player87.png',73),
(92 ,1,8 , 'lazyhazy'         ,'2011-05-17', '2017-11-15', 'player88.png',55),
(93 ,1,8 , 'daemonkey'        ,'2011-05-28', '2017-12-02', 'player89.png',18),
(94 ,1,8 , 'knighttime'       ,'2011-06-27', '2017-12-17', 'player90.png',80),
(95 ,1,8 , 'glamorousbadger'  ,'2011-07-20', '2017-12-27', 'player91.png',69),
(96 ,1,8 , 'classicwasp'      ,'2011-07-30', '2018-01-10', 'player92.png',99),
(97 ,1,8 , 'formalpineapple'  ,'2011-08-02', '2018-01-11', 'player93.png',99),
(98 ,1,8 , 'diettucan'        ,'2011-08-03', '2018-03-31', 'player94.png',19),
(99 ,1,8 , 'flamehazelnut'    ,'2011-08-20', '2018-05-04', 'player95.png',42),
(100,1,8 , 'hammerpriestess'  ,'2011-08-21', '2018-08-11', 'player96.png',93),
(101,1,9 , 'lamaster'           ,'2009-12-07','2016-04-21','player97.png',75), 
(102,1,9 , 'archlizard'         ,'2009-12-21','2016-06-27','player98.png',14),
(103,1,9 , 'hippony'            ,'2010-01-14','2016-10-06','player99.png',75),
(104,1,9 , 'hedgehogger'        ,'2010-02-01','2016-10-15','player100.png',86),
(105,1,9 , 'coldsparks'         ,'2010-02-06','2016-11-07','player101.png',58),
(106,1,9 , 'coldmonster'        ,'2010-02-28','2016-12-28','player102.png',52),
(107,1,9 , 'vainsalmon'         ,'2010-03-24','2017-02-13','player103.png',19),
(108,1,9 , 'dapperblizzard'     ,'2010-03-28','2017-04-14','player104.png',72),
(109,1,9 , 'tiredduck'          ,'2010-04-03','2017-05-20','player105.png',54),
(110,1,9 , 'virtualpython'      ,'2010-04-14','2017-07-07','player106.png',31),
(111,1,9 , 'ostritches'         ,'2010-04-24','2017-11-07','player107.png',25),
(112,1,9 , 'blazebra'           ,'2010-04-29','2017-11-23','player108.png',62),
(113,1,10, 'wolveriot'          ,'2010-05-06','2017-12-17','player109.png',38),
(114,1,10, 'stenchanter'        ,'2010-05-08','2018-01-01','player110.png',84),
(115,1,10, 'roadbeetle'         ,'2010-05-21','2018-01-15','player111.png',57),
(116,1,10, 'arcticfrogger'      ,'2010-06-17','2018-03-02','player112.png',36),
(117,1,10, 'slowviper'          ,'2010-06-18','2018-03-24','player113.png',16),
(118,1,10, 'actionpiglet'       ,'2010-07-11','2018-05-23','player114.png',13),
(119,1,10, 'sadterror'          ,'2010-07-21','2018-06-20','player115.png',34),
(120,1,10, 'chillykitty'        ,'2010-07-25','2018-07-09','player116.png',54),
(121,1,10, 'pandame'            ,'2010-07-29','2018-07-12','player117.png',69),
(122,1,10, 'pixelephant'        ,'2010-08-20','2018-07-28','player118.png',69),
(123,1,10, 'antiger'            ,'2010-08-29','2018-08-14','player119.png',80),
(124,1,10, 'cheatah'            ,'2010-09-05','2018-09-05','player120.png',58),
(125,1,11, 'naughtyrogue'       ,'2010-09-10','2018-09-10','player121.png',2 ),
(126,1,11, 'giantfowl'          ,'2009-12-05','2015-12-10','player122.png',79),
(127,1,11, 'dirtycat'           ,'2009-12-07','2016-02-15','player123.png',82),
(128,1,11, 'intelligentnymph'   ,'2009-12-13','2016-04-01','player124.png',77),
(129,1,11, 'mysterioushalfling' ,'2009-12-19','2016-08-19','player125.png',15),
(130,1,11, 'heartpie'           ,'2009-12-28','2017-01-22','player126.png',90),
(131,1,11, 'rangutangle'        ,'2010-01-01','2017-04-22','player127.png',84),
(132,1,11, 'dinoscythe'         ,'2010-01-12','2017-04-23','player128.png',46),
(133,1,11, 'victorc'            ,'2010-02-17','2017-04-30','player129.png',93),
(134,1,11, 'porcupid'           ,'2010-03-10','2017-07-08','player130.png',27),
(135,1,11, 'dopeymuppet'        ,'2010-03-13','2017-07-21','player131.png',57),
(136,1,11, 'primemermaid'       ,'2010-03-15','2017-09-12','player132.png',12),
(137,1,12, 'cannonfrog'         ,'2010-03-19','2017-09-15','player133.png',74),
(138,1,12, 'crownhippo'         ,'2010-03-22','2017-10-05','player134.png',61),
(139,1,12, 'famousstorm'        ,'2010-04-03','2017-10-25','player135.png',96),
(140,1,12, 'gothiccyborg'       ,'2010-05-09','2017-11-05','player136.png',47),
(141,1,12, 'caterpixie'         ,'2010-05-11','2017-11-15','player137.png',38),
(142,1,12, 'demonkey'           ,'2010-05-14','2017-12-13','player138.png',59),
(143,1,12, 'fellama'            ,'2010-06-01','2018-01-29','player139.png',7 ),
(144,1,12, 'oysterminate'       ,'2010-06-04','2018-03-10','player140.png',59),
(145,1,12, 'loyalrascal'        ,'2010-06-17','2018-03-19','player141.png',48),
(146,1,12, 'needylice'          ,'2010-06-18','2018-04-02','player142.png',28),
(147,1,12, 'lunchbear'          ,'2010-06-24','2018-05-07','player143.png',74),
(148,1,12, 'hollowdoughnut'     ,'2010-06-25','2018-05-09','player144.png',74),
(149,1,13, 'lightningfurry'       ,'2008-11-30', '2014-11-2','player145.png',76),
(150,1,13, 'primespider'          ,'2008-12-07', '2015-02-0','player146.png',13),
(151,1,13, 'commandroid'          ,'2008-12-17', '2015-08-3','player147.png',34),
(152,1,13, 'tomatoad'             ,'2008-12-20', '2015-09-2','player148.png',97),
(153,1,13, 'hypnotastic'          ,'2008-12-27', '2015-11-0','player149.png',46),
(154,1,13, 'turbanshee'           ,'2009-01-24', '2015-11-1','player150.png',24),
(155,1,13, 'dietlord'             ,'2009-01-30', '2015-12-0','player151.png',90),
(156,1,13, 'smilingpegasus'       ,'2009-02-07', '2016-04-2','player152.png',55),
(157,1,13, 'hearttoad'            ,'2009-02-08', '2016-06-0','player153.png',80),
(158,1,13, 'gardenduck'           ,'2009-02-11', '2016-06-1','player154.png',71),
(159,1,13, 'frostygod'            ,'2009-03-18', '2016-07-0','player155.png',35),
(160,1,13, 'expertgrasshopper'    ,'2009-03-20', '2016-07-2','player156.png',44),
(161,1,14, 'vulturret'            ,'2009-04-02', '2016-10-1','player157.png',94),
(162,1,14, 'decorsair'            ,'2009-04-24', '2016-12-2','player158.png',68),
(163,1,14, 'griffinish'           ,'2009-05-09', '2017-03-1','player159.png',61),
(164,1,14, 'sincubus'             ,'2009-05-10', '2017-04-0','player160.png',21),
(165,1,14, 'insecuresquirrel'     ,'2009-05-12', '2017-05-1','player161.png',38),
(166,1,14, 'ninjapattern'         ,'2009-05-15', '2017-05-1','player162.png',99),
(167,1,14, 'scentedmango'         ,'2009-06-09', '2017-06-2','player163.png',44),
(168,1,14, 'battleogre'           ,'2009-06-25', '2017-11-0','player164.png',14),
(169,1,14, 'spookygeneral'        ,'2009-07-07', '2017-11-0','player165.png',84),
(170,1,14, 'forestenigma'         ,'2009-07-22', '2017-12-0','player166.png',86),
(171,1,14, 'nitwitch'             ,'2009-08-08', '2018-01-2','player167.png',43),
(172,1,14, 'gamerman'             ,'2009-08-12', '2018-03-0','player168.png',98),
(173,1,15, 'goghost'              ,'2009-08-24', '2018-05-1','player169.png',99),
(174,1,15, 'brasshopper'          ,'2008-12-07', '2015-01-0','player170.png',91),
(175,1,15, 'digitalnightelf'      ,'2008-12-19', '2015-01-2','player171.png',64),
(176,1,15, 'paperparrot'          ,'2008-12-26', '2015-02-0','player172.png',35),
(177,1,15, 'weirdfalcon'          ,'2009-01-19', '2015-02-1','player173.png',75),
(178,1,15, 'heartrat'             ,'2009-01-23', '2015-02-2','player174.png',19),
(179,1,15, 'caringdonkey'         ,'2009-01-28', '2015-03-1','player175.png',55),
(180,1,15, 'dimmaple'             ,'2009-01-31', '2015-04-1','player176.png',72),
(181,1,15, 'crickettle'           ,'2009-02-02', '2015-11-0','player177.png',60),
(182,1,15, 'kangarookie'          ,'2009-02-14', '2015-11-2','player178.png',6 ),
(183,1,15, 'capeshifter'          ,'2009-02-18', '2016-03-3','player179.png',92),
(184,1,15, 'ibiscuit'             ,'2009-03-09', '2016-04-2','player180.png',12),
(185,1,16, 'ancientrascal'        ,'2009-03-16', '2016-04-2','player181.png',53),
(186,1,16, 'scentedbeetle'        ,'2009-05-09', '2016-05-1','player182.png',20),
(187,1,16, 'oceanandroid'         ,'2009-05-10', '2016-07-0','player183.png',95),
(188,1,16, 'plushcat'             ,'2009-05-11', '2016-07-2','player184.png',61),
(189,1,16, 'antiquehorse'         ,'2009-06-13', '2017-04-1','player185.png',24),
(190,1,16, 'smilingcake'          ,'2009-06-27', '2017-05-2','player186.png',65),
(191,1,16, 'wrathhawk'            ,'2009-07-03', '2017-05-2','player187.png',60),
(192,1,16, 'devile'               ,'2009-07-22', '2017-06-1','player188.png',17),
(193,1,16, 'elephantom'           ,'2009-07-26', '2017-10-0','player189.png',79),
(194,1,16, 'candroid'             ,'2009-08-15', '2017-10-1','player190.png',58),
(195,1,16, 'sneakybandit'         ,'2009-08-16', '2017-10-2','player191.png',95),
(196,1,16, 'blushingdroid'        ,'2009-08-17', '2018-02-2','player192.png',62),
(197,1,17, 'surpriselime'         ,'2007-11-30', '2013-10-2','player193.png',81),
(198,1,17, 'sandmachine'          ,'2007-12-07', '2014-01-0','player194.png',44),
(199,1,17, 'quietpotato'          ,'2007-12-17', '2014-07-3','player195.png',46),
(200,1,17, 'surprisehopper'       ,'2007-12-20', '2014-08-2','player196.png',24),
(201,1,17, 'totemplar'            ,'2007-12-27', '2014-10-0','player197.png',24),
(202,1,17, 'gerbilbo'             ,'2008-01-24', '2014-10-1','player198.png',70),
(203,1,17, 'volcagnome'           ,'2008-01-30', '2014-11-0','player199.png',52),
(204,1,17, 'fowlee'               ,'2008-02-07', '2015-03-2','player200.png',76),
(205,1,17, 'viciousogre'          ,'2008-02-08', '2015-05-0','player201.png',58),
(206,1,17, 'cluelesswarhawk'      ,'2008-02-11', '2015-05-1','player202.png',5 ),
(207,1,17, 'trustyninja'          ,'2008-03-18', '2015-06-0','player203.png',55),
(208,1,17, 'juniorscorpion'       ,'2008-03-20', '2015-06-2','player204.png',40),
(209,1,18, 'euphoricsphinx'       ,'2008-04-02', '2015-9-16','player205.png',62),
(210,1,18, 'idioticweasel'        ,'2008-04-24', '2015-11-2','player206.png',34),
(211,1,18, 'sharctic'             ,'2008-05-09', '2016-02-1','player207.png',26),
(212,1,18, 'pelicannon'           ,'2008-05-10', '2016-03-0','player208.png',58),
(213,1,18, 'iconjurer'            ,'2008-05-12', '2016-04-1','player209.png',72),
(214,1,18, 'volcagnome'           ,'2008-05-15', '2016-04-1','player210.png',41),
(215,1,18, 'greatjudge'           ,'2008-06-09', '2016-05-2','player211.png',13),
(216,1,18, 'famousrat'            ,'2008-06-25', '2016-10-0','player212.png',80),
(217,1,18, 'greenchomper'         ,'2008-07-07', '2016-10-0','player213.png',71),
(218,1,18, 'naiveshark'           ,'2008-07-22', '2016-11-0','player214.png',98),
(219,1,18, 'flashyhedgehog'       ,'2008-08-08', '2017-00-2','player215.png',51),
(220,1,18, 'rhythmlice'           ,'2008-08-12', '2017-02-0','player216.png',92),
(221,1,19, 'rangerman'            ,'2008-08-24', '2017-04-1','player217.png',54),
(222,1,19, 'chinchillax'          ,'2007-12-07', '2014-00-0','player218.png',2 ),
(223,1,19, 'sparrowling'          ,'2007-12-19', '2014-00-2','player219.png',30),
(224,1,19, 'wahooligan'           ,'2007-12-26', '2014-01-0','player220.png',93),
(225,1,19, 'voyagedragon'         ,'2008-01-19', '2014-01-1','player221.png',8 ),
(226,1,19, 'moneycow'             ,'2008-01-23', '2014-01-2','player222.png',24),
(227,1,19, 'sciencesiren'         ,'2008-01-28', '2014-02-1','player223.png',64),
(228,1,19, 'bouncymantis'         ,'2008-01-31', '2014-03-1','player224.png',25),
(229,1,19, 'giftedmonk'           ,'2008-02-02', '2014-10-0','player225.png',52),
(230,1,19, 'graciousimp'          ,'2008-02-14', '2014-10-2','player226.png',29),
(231,1,19, 'womblast'             ,'2008-02-18', '2015-02-3','player227.png',14),
(232,1,19, 'pandamonium'          ,'2008-03-09', '2015-03-2','player228.png',4 ),
(233,1,20, 'cobrass'              ,'2008-03-16', '2015-03-2','player229.png',28),
(234,1,20, 'peafowlet'            ,'2008-05-09', '2015-04-1','player230.png',6 ),
(235,1,20, 'humorchimp'           ,'2008-05-10', '2015-06-0','player231.png',33),
(236,1,20, 'fatbanana'            ,'2008-05-11', '2015-06-2','player232.png',72),
(237,1,20, 'steelfowl'            ,'2008-06-13', '2016-03-1','player233.png',38),
(238,1,20, 'trustyfledgling'      ,'2008-06-27', '2016-04-2','player234.png',1 ),
(239,1,20, 'humblevalkyrie'       ,'2008-07-03', '2016-04-2','player235.png',74),
(240,1,20, 'candidheroine'        ,'2008-07-22', '2016-05-1','player236.png',43),
(241,1,20, 'guacamole'            ,'2008-07-26', '2016-9-03','player237.png',86),
(242,1,20, 'gangstereo'           ,'2008-08-15', '2016-9-11','player238.png',47),
(243,1,20, 'minerd'               ,'2008-08-16', '2016-9-29','player239.png',28),
(244,1,20, 'sparasite'            ,'2008-08-17', '2017-01-2','player240.png',51),
(245,1,21, 'weirdrabbit'          ,'2003-10-30', '2012-10-2','player241.png',24), 
(246,1,21, 'punygod'              ,'2003-11-07', '2013-01-0','player242.png',82),
(247,1,21, 'angerjuellyfish'      ,'2003-11-17', '2013-07-3','player243.png',99),
(248,1,21, 'writerjackal'         ,'2003-11-20', '2013-08-2','player244.png',63),
(249,1,21, 'bigmagpie'            ,'2003-11-27', '2013-10-0','player245.png',96),
(250,1,21, 'cluelessmandarin'     ,'2004-00-24', '2013-10-1','player246.png',83),
(251,1,21, 'ostricheyrich'        ,'2004-00-30', '2013-11-0','player247.png',56),
(252,1,21, 'guruse'               ,'2004-01-07', '2014-03-2','player248.png',16),
(253,1,21, 'sassassin'            ,'2004-01-08', '2014-05-0','player249.png',37),
(254,1,21, 'capeshifter'          ,'2004-01-11', '2014-05-1','player250.png',40),
(255,1,21, 'bronzeoracle'         ,'2004-02-18', '2014-06-0','player251.png',12),
(256,1,21, 'cluelessturtle'       ,'2004-02-20', '2014-06-2','player252.png',17),
(257,1,22, 'bigcyclops'           ,'2004-03-02', '2014-9-16','player253.png',57),
(258,1,22, 'mountainhydra'        ,'2004-03-24', '2014-11-2','player254.png',28),
(259,1,22, 'songapricot'          ,'2004-04-09', '2015-02-1','player255.png',42),
(260,1,22, 'liquidlamb'           ,'2004-04-10', '2015-03-0','player256.png',95),
(261,1,22, 'ownerd'               ,'2004-04-12', '2015-04-1','player257.png',65),
(262,1,22, 'sealixir'             ,'2004-04-15', '2015-04-1','player258.png',68),
(263,1,22, 'pignorant'            ,'2004-05-09', '2015-05-2','player259.png',67),
(264,1,22, 'rascalf'              ,'2004-05-25', '2015-10-0','player260.png',67),
(265,1,22, 'bravegerbil'          ,'2004-06-07', '2015-10-0','player261.png',59),
(266,1,22, 'bigbadpigeon'         ,'2004-06-22', '2015-11-0','player262.png',39),
(267,1,22, 'hilariouscamel'       ,'2004-07-08', '2016-00-2','player263.png',83),
(268,1,22, 'attractiveconqueror'  ,'2004-07-12', '2016-02-0','player264.png',35),
(269,1,23, 'megaboomer'           ,'2004-07-24', '2016-04-1','player265.png',15),
(270,1,23, 'enchantedturkey'      ,'2003-11-07', '2013-00-0','player266.png',29),
(271,1,23, 'videogre'             ,'2003-11-19', '2013-00-2','player267.png',56),
(272,1,23, 'gnunou'               ,'2003-11-26', '2013-01-0','player268.png',71),
(273,1,23, 'badept'               ,'2004-00-19', '2013-01-1','player269.png',92),
(274,1,23, 'laserpent'            ,'2004-00-23', '2013-01-2','player270.png',16),
(275,1,23, 'afternoondeer'        ,'2004-00-28', '2013-02-1','player271.png',58),
(276,1,23, 'bonycyborg'           ,'2004-00-31', '2013-03-1','player272.png',28),
(277,1,23, 'emotionalbullfrog'    ,'2004-01-02', '2013-10-0','player273.png',13),
(278,1,23, 'rudegrape'            ,'2004-01-14', '2013-10-2','player274.png',79),
(279,1,23, 'amusedwoodpecker'     ,'2004-01-18', '2014-02-3','player275.png',78),
(280,1,23, 'vagueibis'            ,'2004-02-09', '2014-03-2','player276.png',50),
(281,1,24, 'pyrogue'              ,'2004-02-16', '2014-03-2','player277.png',63),
(282,1,24, 'chimpanzy'            ,'2004-04-09', '2014-04-1','player278.png',78),
(283,1,24, 'sitcommander'         ,'2004-04-10', '2014-06-0','player279.png',96),
(284,1,24, 'paladino'             ,'2004-04-11', '2014-06-2','player280.png',2 ),
(285,1,24, 'flashyflower'         ,'2004-05-13', '2015-03-1','player281.png',78),
(286,1,24, 'blandapple'           ,'2004-05-27', '2015-04-2','player282.png',10),
(287,1,24, 'complexmantis'        ,'2004-06-03', '2015-04-2','player283.png',30),
(288,1,24, 'battlepumpkin'        ,'2004-06-22', '2015-05-1','player284.png',98),
(289,1,24, 'seaelephant'          ,'2004-06-26', '2015-9-03','player285.png',24),
(290,1,24, 'amazingbot'           ,'2004-07-15', '2015-9-11','player286.png',12),
(291,1,24, 'sharcade'             ,'2004-07-16', '2015-9-29','player287.png',86),
(292,1,24, 'bingoblin'            ,'2004-07-17', '2016-01-2','player288.png',72),
(293,1,25, 'unbanshee'           ,'2002-10-30', '2007-10-23','player289.png',14),
(294,1,25, 'pelicandy'           ,'2002-11-07', '2008-01-09','player290.png',50),
(295,1,25, 'radioactiverunner'   ,'2002-11-17', '2008-07-31','player291.png',19),
(296,1,25, 'jumbodino'           ,'2002-11-20', '2008-08-22','player292.png',80),
(297,1,25, 'angelblueberry'      ,'2002-11-27', '2008-10-05','player293.png',48),
(298,1,25, 'sisterjudge'         ,'2003-00-24', '2008-10-14','player294.png',67),
(299,1,25, 'loudlamb'            ,'2003-00-30', '2008-11-09','player295.png',70),
(300,1,25, 'historywarthog'      ,'2003-01-07', '2009-03-21','player296.png',75),
(301,1,25, 'plazy'               ,'2003-01-08', '2009-05-04','player297.png',90),
(302,1,25, 'sparasite'           ,'2003-01-11', '2009-05-17','player298.png',7 ),
(303,1,25, 'gorrilava'           ,'2003-02-18', '2009-06-09','player299.png',94),
(304,1,25, 'komodough'           ,'2003-02-20', '2009-06-24','player300.png',91),
(305,1,26, 'craftybullet'        ,'2003-03-02', '2009-09-16','player301.png' ,48),
(306,1,26, 'vainfalcon'          ,'2003-03-24', '2009-11-28','player302.png',36),
(307,1,26, 'activeyak'           ,'2003-04-09', '2010-02-13','player303.png',38),
(308,1,26, 'breakfastdwarf'      ,'2003-04-10', '2010-03-06','player304.png',43),
(309,1,26, 'sciencegnoll'        ,'2003-04-12', '2010-04-11','player305.png',14),
(310,1,26, 'secretsage'          ,'2003-04-15', '2010-04-15','player306.png',48),
(311,1,26, 'flaminghost'         ,'2003-05-09', '2010-05-27','player307.png',54),
(312,1,26, 'pandata'             ,'2003-05-25', '2010-10-02','player308.png',5 ),
(313,1,26, 'troutwards'          ,'2003-06-07', '2010-10-05','player309.png',24),
(314,1,26, 'chimpanther'         ,'2003-06-22', '2010-11-04','player310.png',57),
(315,1,26, 'kissytortoise'       ,'2003-07-08', '2011-00-24','player311.png',38),
(316,1,26, 'timeblossom'         ,'2003-07-12', '2011-02-02','player312.png',49),
(317,1,27, 'cheatgeneral'        ,'2003-07-24', '2011-04-18','player313.png',74),
(318,1,27, 'idlepanda'           ,'2002-11-07', '2008-00-02','player314.png',72),
(319,1,27, 'awfulchick'          ,'2002-11-19', '2008-00-21','player315.png',70),
(320,1,27, 'frightenedbison'     ,'2002-11-26', '2008-01-07','player316.png',32),
(321,1,27, 'hippony'             ,'2003-00-19', '2008-01-15','player317.png',72),
(322,1,27, 'bachelord'           ,'2003-00-23', '2008-01-21','player318.png',26),
(323,1,27, 'spiderby'            ,'2003-00-28', '2008-02-17','player319.png',92),
(324,1,27, 'flexecutioner'       ,'2003-00-31', '2008-03-14','player320.png',88),
(325,1,27, 'youngocelot'         ,'2003-01-02', '2008-10-04','player321.png',65),
(326,1,27, 'doompriest'          ,'2003-01-14', '2008-10-26','player322.png',64),
(327,1,27, 'coldsquab'           ,'2003-01-18', '2009-02-30','player323.png',96),
(328,1,27, 'ruderunner'          ,'2003-02-09', '2009-03-20','player324.png',93),
(329,1,28, 'blushingcub'         ,'2003-02-16', '2009-03-26','player325.png',73),
(330,1,28, 'glitteringboomer'    ,'2003-04-09', '2009-04-18','player326.png',23),
(331,1,28, 'snowmanta'           ,'2003-04-10', '2009-06-07','player327.png',96),
(332,1,28, 'cocowboy'            ,'2003-04-11', '2009-06-26','player328.png',97),
(333,1,28, 'herringmaster'       ,'2003-05-13', '2010-03-16','player329.png',33),
(334,1,28, 'komodough'           ,'2003-05-27', '2010-04-20','player330.png',29),
(335,1,28, 'grandrose'           ,'2003-06-03', '2010-04-22','player331.png',28),
(336,1,28, 'gamingshadow'        ,'2003-06-22', '2010-05-10','player332.png',31),
(337,1,28, 'fearlessraptor'      ,'2003-06-26', '2010-9-03','player333.png' ,15),
(338,1,28, 'aquacheetah'         ,'2003-07-15', '2010-9-11','player334.png' ,73),
(339,1,28, 'writerbat'           ,'2003-07-16', '2010-9-29','player335.png' ,64),
(340,1,28, 'bigbadwarlock'       ,'2003-07-17', '2011-01-21','player336.png',39);

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


insert into teamStats (teaId, tstWins, tstLoses)values (1,3,4),
(2,2,5),
(2,1,6),
(3,5,2),
(4,0,7),
(5,3,4),
(6,5,2),
(7,3,4),
(8,4,3),
(9,5,2),
(10,3,4),
(11,5,2),
(12,2,4),
(13,4,3),
(14,6,1),
(15,2,5),
(16,4,3),
(17,1,6),
(18,5,2),
(19,3,4),
(20,2,5),
(21,5,2),
(22,3,4),
(23,5,2),
(24,3,4),
(25,1,6),
(26,2,5),
(27,1,6),
(28,6,1);

INSERT INTO `playerStats` (`pbsId`, `plaId`, `pbsPlayedGames`, `pbsWins`, `pbsLoses`, `pbsHits`, `pbsHomeRuns`, `pbsStrikes`, `pbsRuns`, `pbsBalls`, `pbsOuts`, `pbsStolenBases`) VALUES
(1, 1, 3, 3, 0, 1, 1, 14, 10, 12, 14, 2),
(2, 2, 7, 4, 3, 10, 6, 9, 3, 16, 3, 3),
(3, 3, 1, 1, 0, 1, 0, 11, 12, 7, 7, 1),
(4, 4, 2, 1, 1, 33, 7, 12, 18, 5, 13, 4),
(5, 5, 7, 7, 0, 1, 4, 31, 6, 16, 14, 3),
(6, 6, 5, 3, 2, 10, 5, 8, 4, 16, 11, 3),
(7, 7, 7, 3, 4, 10, 2, 3, 2, 11, 7, 3),
(8, 8, 4, 4, 0, 5, 2, 30, 11, 9, 2, 2),
(9, 9, 6, 5, 1, 5, 5, 11, 11, 6, 13, 4),
(10, 10, 8, 4, 4, 32, 5, 6, 15, 10, 7, 2),
(11, 11, 6, 4, 2, 27, 7, 6, 9, 13, 8, 4),
(12, 12, 5, 2, 3, 22, 5, 17, 4, 17, 5, 4),
(13, 13, 4, 4, 0, 39, 5, 12, 8, 5, 11, 4),
(14, 14, 8, 7, 1, 29, 2, 39, 9, 7, 14, 3),
(15, 15, 7, 5, 2, 16, 5, 6, 18, 15, 13, 2),
(16, 16, 4, 2, 2, 2, 5, 31, 18, 16, 18, 2),
(17, 17, 4, 4, 0, 4, 2, 35, 12, 13, 15, 3),
(18, 18, 2, 1, 1, 8, 0, 21, 14, 12, 4, 3),
(19, 19, 6, 6, 0, 33, 0, 39, 13, 18, 13, 2),
(20, 20, 8, 2, 6, 2, 6, 23, 1, 6, 15, 4),
(21, 21, 5, 4, 1, 29, 6, 3, 8, 11, 11, 3),
(22, 22, 3, 3, 0, 25, 2, 5, 12, 10, 5, 1),
(23, 23, 5, 3, 2, 37, 3, 14, 5, 8, 15, 3),
(24, 24, 5, 3, 2, 21, 1, 39, 16, 18, 19, 3),
(25, 25, 8, 7, 1, 29, 3, 25, 9, 7, 12, 2),
(26, 26, 7, 5, 2, 5, 3, 17, 8, 18, 13, 2),
(27, 27, 8, 1, 7, 4, 3, 25, 6, 18, 18, 1),
(28, 28, 1, 1, 0, 13, 6, 16, 3, 18, 11, 2),
(29, 29, 4, 1, 3, 29, 3, 12, 15, 19, 10, 1),
(30, 30, 4, 1, 3, 37, 1, 10, 8, 11, 2, 4),
(31, 31, 6, 3, 3, 6, 3, 20, 14, 9, 4, 2),
(32, 32, 9, 8, 1, 5, 7, 21, 18, 19, 10, 3),
(33, 33, 6, 4, 2, 33, 2, 21, 3, 5, 11, 4),
(34, 34, 3, 3, 0, 37, 7, 15, 7, 8, 5, 1),
(35, 35, 3, 3, 0, 24, 0, 9, 4, 9, 19, 3),
(36, 36, 2, 2, 0, 23, 0, 8, 15, 17, 16, 3),
(37, 37, 1, 1, 0, 34, 7, 15, 19, 18, 2, 2),
(38, 38, 5, 1, 4, 21, 5, 29, 6, 16, 13, 2),
(39, 39, 9, 5, 4, 7, 5, 2, 11, 14, 18, 1),
(40, 40, 3, 2, 1, 27, 1, 5, 11, 15, 6, 4),
(41, 41, 3, 3, 0, 25, 4, 6, 4, 18, 16, 4),
(42, 42, 1, 1, 0, 28, 2, 10, 11, 8, 18, 1),
(43, 43, 5, 3, 2, 12, 2, 15, 9, 18, 13, 4),
(44, 44, 6, 3, 3, 36, 7, 2, 10, 11, 10, 2),
(45, 45, 8, 3, 5, 18, 0, 30, 4, 13, 12, 3),
(46, 46, 4, 4, 0, 38, 0, 37, 4, 9, 5, 4),
(47, 47, 6, 6, 0, 38, 1, 27, 10, 9, 7, 3),
(48, 48, 1, 1, 0, 13, 1, 34, 15, 9, 8, 3),
(49, 49, 8, 4, 4, 24, 0, 30, 16, 18, 11, 3),
(50, 50, 8, 4, 4, 15, 5, 26, 17, 14, 16, 3),
(51, 51, 3, 3, 0, 26, 7, 27, 9, 15, 10, 3),
(52, 52, 3, 2, 1, 5, 1, 32, 11, 14, 11, 3),
(53, 53, 3, 3, 0, 8, 1, 12, 4, 18, 10, 4),
(54, 54, 2, 2, 0, 16, 3, 23, 2, 8, 19, 3),
(55, 55, 9, 7, 2, 32, 1, 17, 6, 8, 13, 2),
(56, 56, 5, 5, 0, 28, 6, 4, 3, 6, 8, 2),
(57, 57, 4, 2, 2, 16, 3, 2, 5, 14, 10, 1),
(58, 58, 2, 2, 0, 24, 0, 39, 16, 17, 14, 3),
(59, 59, 9, 2, 7, 3, 7, 36, 13, 17, 8, 4),
(60, 60, 2, 2, 0, 11, 2, 14, 5, 16, 17, 4),
(61, 61, 3, 3, 0, 33, 4, 21, 18, 6, 4, 4),
(62, 62, 7, 4, 3, 26, 7, 38, 8, 11, 5, 1),
(63, 63, 3, 3, 0, 9, 6, 26, 13, 11, 10, 1),
(64, 64, 8, 8, 0, 15, 3, 13, 3, 19, 12, 1),
(65, 65, 8, 3, 5, 24, 1, 32, 16, 15, 3, 4),
(66, 66, 2, 2, 0, 16, 6, 32, 3, 19, 11, 2),
(67, 67, 6, 5, 1, 32, 1, 7, 1, 16, 6, 1),
(68, 68, 5, 3, 2, 6, 4, 35, 8, 7, 12, 4),
(69, 69, 6, 1, 5, 24, 3, 3, 11, 16, 6, 1),
(70, 70, 7, 1, 6, 3, 1, 16, 16, 14, 8, 1),
(71, 71, 4, 4, 0, 7, 4, 15, 11, 13, 5, 4),
(72, 72, 7, 5, 2, 14, 7, 28, 4, 9, 8, 2),
(73, 73, 8, 2, 6, 19, 2, 15, 18, 16, 2, 1),
(74, 74, 2, 2, 0, 37, 2, 36, 11, 10, 15, 4),
(75, 75, 7, 1, 6, 29, 0, 35, 17, 16, 19, 3),
(76, 76, 9, 7, 2, 12, 6, 38, 1, 11, 16, 1),
(77, 77, 6, 2, 4, 13, 2, 32, 7, 9, 8, 4),
(78, 78, 8, 4, 4, 28, 6, 26, 19, 9, 12, 2),
(79, 79, 7, 7, 0, 12, 4, 21, 8, 9, 18, 2),
(80, 80, 9, 3, 6, 14, 7, 36, 3, 10, 15, 3),
(81, 81, 6, 4, 2, 10, 3, 30, 10, 5, 18, 3),
(82, 82, 9, 1, 8, 5, 2, 23, 7, 15, 15, 4),
(83, 83, 8, 1, 7, 25, 7, 39, 18, 6, 8, 1),
(84, 84, 5, 5, 0, 22, 4, 19, 17, 10, 14, 1),
(85, 85, 1, 1, 0, 2, 6, 23, 12, 18, 8, 4),
(86, 86, 2, 2, 0, 29, 7, 9, 4, 7, 10, 4),
(87, 87, 9, 6, 3, 17, 2, 13, 8, 11, 10, 4),
(88, 88, 9, 3, 6, 23, 1, 37, 17, 7, 12, 2),
(89, 89, 9, 1, 8, 17, 0, 3, 13, 6, 18, 3),
(90, 90, 3, 3, 0, 29, 2, 18, 1, 6, 9, 1),
(91, 91, 7, 7, 0, 38, 4, 13, 2, 14, 17, 1),
(92, 92, 3, 3, 0, 28, 7, 31, 12, 15, 5, 2),
(93, 93, 3, 3, 0, 25, 6, 10, 8, 15, 4, 4),
(94, 94, 3, 3, 0, 35, 4, 5, 10, 17, 10, 4),
(95, 95, 5, 3, 2, 30, 2, 18, 4, 14, 17, 1),
(96, 96, 1, 1, 0, 30, 0, 25, 5, 14, 16, 3),
(97, 97, 4, 4, 0, 21, 4, 36, 4, 7, 8, 2),
(98, 98, 2, 2, 0, 31, 1, 2, 7, 16, 6, 4),
(99, 99, 6, 6, 0, 19, 3, 7, 8, 10, 14, 3),
(100, 100, 2, 2, 0, 39, 4, 36, 7, 19, 9, 2),
(101, 101, 3, 3, 0, 17, 4, 8, 3, 18, 10, 1),
(102, 102, 3, 3, 0, 16, 3, 14, 8, 10, 2, 4),
(103, 103, 1, 1, 0, 32, 0, 10, 5, 12, 19, 1),
(104, 104, 3, 3, 0, 30, 3, 8, 13, 17, 9, 2),
(105, 105, 5, 1, 4, 32, 2, 21, 13, 8, 3, 4),
(106, 106, 3, 3, 0, 32, 4, 10, 17, 13, 18, 2),
(107, 107, 7, 2, 5, 26, 1, 4, 4, 18, 13, 4),
(108, 108, 4, 4, 0, 25, 5, 23, 18, 5, 18, 1),
(109, 109, 1, 1, 0, 18, 1, 34, 4, 10, 4, 1),
(110, 110, 4, 4, 0, 11, 7, 36, 5, 8, 4, 1),
(111, 111, 7, 3, 4, 37, 4, 18, 17, 15, 17, 2),
(112, 112, 2, 2, 0, 7, 7, 22, 7, 18, 11, 2),
(113, 113, 9, 5, 4, 15, 3, 32, 18, 19, 11, 4),
(114, 114, 7, 5, 2, 36, 3, 21, 9, 15, 8, 3),
(115, 115, 1, 1, 0, 10, 4, 17, 19, 18, 4, 3),
(116, 116, 1, 1, 0, 4, 7, 39, 8, 5, 5, 3),
(117, 117, 8, 2, 6, 19, 7, 24, 17, 18, 2, 2),
(118, 118, 4, 4, 0, 2, 5, 8, 4, 15, 16, 1),
(119, 119, 1, 1, 0, 7, 3, 24, 13, 10, 18, 1),
(120, 120, 9, 7, 2, 21, 4, 15, 6, 17, 17, 1),
(121, 121, 2, 1, 1, 32, 2, 26, 8, 13, 11, 2),
(122, 122, 5, 3, 2, 12, 7, 9, 4, 9, 19, 4),
(123, 123, 4, 4, 0, 24, 6, 25, 14, 17, 19, 2),
(124, 124, 8, 7, 1, 19, 5, 34, 7, 5, 12, 3),
(125, 125, 3, 3, 0, 31, 6, 32, 2, 10, 16, 3),
(126, 126, 7, 1, 6, 22, 2, 10, 8, 12, 9, 2),
(127, 127, 5, 3, 2, 18, 0, 20, 13, 6, 15, 3),
(128, 128, 8, 7, 1, 19, 7, 33, 13, 11, 19, 2),
(129, 129, 1, 1, 0, 26, 4, 18, 16, 7, 3, 4),
(130, 130, 7, 5, 2, 24, 0, 9, 9, 19, 11, 1),
(131, 131, 3, 2, 1, 6, 0, 26, 2, 11, 11, 1),
(132, 132, 1, 1, 0, 8, 7, 36, 6, 5, 11, 4),
(133, 133, 7, 1, 6, 36, 5, 37, 9, 15, 9, 1),
(134, 134, 1, 1, 0, 24, 0, 37, 6, 11, 4, 4),
(135, 135, 2, 2, 0, 1, 4, 5, 18, 17, 3, 1),
(136, 136, 8, 7, 1, 25, 2, 3, 14, 14, 6, 3),
(137, 137, 3, 3, 0, 11, 5, 16, 5, 17, 8, 4),
(138, 138, 4, 1, 3, 35, 7, 18, 15, 12, 16, 3),
(139, 139, 7, 2, 5, 35, 7, 32, 17, 7, 18, 3),
(140, 140, 6, 6, 0, 28, 7, 16, 13, 16, 5, 2),
(141, 141, 5, 4, 1, 20, 6, 30, 15, 7, 9, 1),
(142, 142, 4, 4, 0, 15, 7, 31, 5, 6, 18, 1),
(143, 143, 6, 3, 3, 33, 3, 21, 10, 14, 6, 3),
(144, 144, 1, 1, 0, 25, 1, 4, 6, 8, 2, 2),
(145, 145, 1, 1, 0, 16, 1, 32, 8, 17, 17, 1),
(146, 146, 2, 2, 0, 38, 3, 33, 10, 13, 5, 4),
(147, 147, 6, 1, 5, 38, 0, 6, 10, 7, 4, 4),
(148, 148, 4, 2, 2, 32, 0, 25, 15, 18, 19, 4),
(149, 149, 7, 4, 3, 20, 3, 23, 13, 12, 9, 3),
(150, 150, 6, 5, 1, 26, 0, 26, 18, 11, 12, 4),
(151, 151, 4, 1, 3, 33, 7, 39, 13, 12, 8, 3),
(152, 152, 3, 1, 2, 4, 1, 24, 17, 13, 16, 3),
(153, 153, 4, 2, 2, 21, 2, 21, 14, 19, 10, 3),
(154, 154, 3, 3, 0, 19, 7, 28, 1, 17, 11, 4),
(155, 155, 1, 1, 0, 20, 6, 38, 4, 19, 6, 2),
(156, 156, 4, 4, 0, 39, 6, 21, 16, 8, 3, 2),
(157, 157, 4, 1, 3, 23, 0, 37, 10, 7, 5, 1),
(158, 158, 3, 3, 0, 16, 0, 15, 2, 5, 11, 4),
(159, 159, 2, 2, 0, 12, 2, 13, 6, 10, 11, 1),
(160, 160, 5, 5, 0, 32, 5, 27, 13, 15, 9, 2),
(161, 161, 3, 3, 0, 36, 7, 27, 15, 7, 15, 4),
(162, 162, 9, 4, 5, 4, 7, 31, 1, 17, 19, 3),
(163, 163, 1, 1, 0, 31, 2, 29, 8, 12, 12, 3),
(164, 164, 3, 3, 0, 27, 6, 15, 19, 14, 14, 3),
(165, 165, 1, 1, 0, 33, 4, 8, 12, 10, 10, 1),
(166, 166, 9, 6, 3, 29, 6, 31, 13, 6, 13, 2),
(167, 167, 6, 6, 0, 10, 4, 19, 2, 6, 17, 1),
(168, 168, 3, 2, 1, 1, 1, 10, 1, 11, 16, 4),
(169, 169, 7, 5, 2, 35, 1, 36, 5, 8, 12, 4),
(170, 170, 9, 4, 5, 33, 7, 26, 14, 14, 2, 3),
(171, 171, 3, 3, 0, 30, 6, 18, 6, 11, 4, 2),
(172, 172, 2, 2, 0, 16, 5, 15, 19, 18, 9, 1),
(173, 173, 5, 4, 1, 3, 7, 11, 18, 6, 4, 2),
(174, 174, 3, 2, 1, 20, 2, 21, 5, 9, 3, 1),
(175, 175, 1, 1, 0, 5, 4, 29, 15, 18, 4, 4),
(176, 176, 6, 3, 3, 4, 6, 4, 5, 14, 4, 3),
(177, 177, 6, 3, 3, 12, 6, 27, 6, 18, 5, 4),
(178, 178, 8, 7, 1, 10, 1, 15, 5, 15, 17, 3),
(179, 179, 9, 8, 1, 28, 2, 4, 3, 6, 11, 4),
(180, 180, 4, 4, 0, 7, 2, 25, 8, 14, 14, 4),
(181, 181, 9, 2, 7, 10, 6, 28, 11, 18, 3, 2),
(182, 182, 5, 4, 1, 35, 6, 6, 4, 15, 14, 2),
(183, 183, 9, 3, 6, 10, 1, 28, 4, 11, 11, 4),
(184, 184, 7, 5, 2, 8, 6, 22, 14, 12, 15, 3),
(185, 185, 3, 2, 1, 7, 1, 16, 19, 17, 12, 1),
(186, 186, 1, 1, 0, 10, 7, 23, 19, 7, 14, 2),
(187, 187, 5, 5, 0, 19, 0, 16, 4, 16, 5, 3),
(188, 188, 1, 1, 0, 34, 1, 15, 8, 12, 9, 3),
(189, 189, 1, 1, 0, 38, 2, 14, 3, 6, 9, 1),
(190, 190, 5, 5, 0, 37, 1, 29, 17, 10, 18, 4),
(191, 191, 2, 2, 0, 30, 7, 16, 5, 10, 14, 4),
(192, 192, 3, 3, 0, 6, 6, 19, 3, 11, 3, 4),
(193, 193, 4, 3, 1, 18, 2, 39, 1, 7, 5, 2),
(194, 194, 6, 6, 0, 38, 0, 32, 9, 11, 7, 1),
(195, 195, 7, 1, 6, 14, 6, 36, 13, 8, 17, 3),
(196, 196, 8, 6, 2, 11, 6, 31, 13, 18, 2, 3),
(197, 197, 5, 5, 0, 9, 6, 32, 4, 16, 15, 4),
(198, 198, 9, 2, 7, 1, 5, 18, 4, 18, 15, 4),
(199, 199, 6, 5, 1, 14, 6, 6, 3, 11, 7, 3),
(200, 200, 2, 2, 0, 4, 2, 6, 15, 16, 17, 2),
(201, 201, 1, 1, 0, 11, 1, 39, 4, 16, 6, 3),
(202, 202, 6, 2, 4, 9, 0, 36, 2, 15, 6, 2),
(203, 203, 4, 4, 0, 29, 0, 13, 10, 14, 13, 4),
(204, 204, 7, 6, 1, 4, 1, 38, 11, 16, 18, 3),
(205, 205, 7, 4, 3, 25, 1, 1, 17, 13, 17, 1),
(206, 206, 4, 1, 3, 37, 0, 25, 17, 10, 9, 1),
(207, 207, 7, 7, 0, 27, 6, 22, 7, 9, 2, 3),
(208, 208, 5, 3, 2, 8, 5, 13, 19, 9, 19, 4),
(209, 209, 8, 2, 6, 28, 6, 21, 9, 10, 6, 3),
(210, 210, 9, 6, 3, 1, 1, 34, 11, 11, 3, 4),
(211, 211, 1, 1, 0, 36, 2, 35, 19, 8, 2, 2),
(212, 212, 9, 6, 3, 30, 7, 29, 13, 6, 11, 1),
(213, 213, 5, 5, 0, 16, 1, 15, 6, 17, 7, 2),
(214, 214, 6, 3, 3, 20, 4, 9, 5, 5, 6, 1),
(215, 215, 9, 5, 4, 11, 5, 24, 10, 19, 9, 3),
(216, 216, 8, 1, 7, 39, 2, 6, 6, 10, 19, 1),
(217, 217, 6, 6, 0, 23, 4, 17, 11, 15, 13, 3),
(218, 218, 9, 3, 6, 20, 4, 36, 10, 14, 5, 4),
(219, 219, 9, 6, 3, 10, 7, 11, 19, 15, 2, 2),
(220, 220, 3, 3, 0, 6, 1, 11, 5, 5, 9, 2),
(221, 221, 4, 3, 1, 6, 5, 2, 19, 16, 19, 1),
(222, 222, 1, 1, 0, 4, 4, 27, 19, 10, 8, 1),
(223, 223, 9, 6, 3, 24, 4, 35, 8, 8, 8, 2),
(224, 224, 6, 6, 0, 3, 1, 19, 10, 6, 5, 4),
(225, 225, 8, 2, 6, 27, 2, 6, 6, 18, 14, 4),
(226, 226, 2, 2, 0, 23, 1, 34, 18, 5, 2, 3),
(227, 227, 8, 7, 1, 16, 6, 18, 13, 13, 4, 1),
(228, 228, 1, 1, 0, 31, 4, 17, 9, 6, 10, 1),
(229, 229, 6, 6, 0, 22, 2, 28, 5, 14, 2, 3),
(230, 230, 8, 4, 4, 37, 1, 9, 9, 16, 7, 2),
(231, 231, 5, 1, 4, 31, 7, 28, 19, 7, 18, 4),
(232, 232, 9, 5, 4, 15, 0, 4, 7, 16, 10, 2),
(233, 233, 2, 2, 0, 5, 1, 6, 9, 6, 15, 3),
(234, 234, 2, 2, 0, 23, 2, 34, 3, 6, 12, 2),
(235, 235, 4, 4, 0, 1, 4, 7, 16, 10, 13, 2),
(236, 236, 2, 2, 0, 13, 4, 16, 15, 7, 11, 4),
(237, 237, 3, 3, 0, 38, 2, 35, 18, 8, 18, 1),
(238, 238, 3, 3, 0, 30, 1, 2, 11, 19, 9, 4),
(239, 239, 3, 3, 0, 14, 2, 32, 10, 5, 18, 1),
(240, 240, 4, 4, 0, 17, 6, 8, 7, 10, 16, 1),
(241, 241, 5, 5, 0, 27, 0, 13, 5, 16, 3, 1),
(242, 242, 7, 7, 0, 27, 6, 25, 19, 18, 17, 4),
(243, 243, 5, 5, 0, 21, 3, 15, 1, 18, 17, 2),
(244, 244, 6, 4, 2, 18, 3, 35, 5, 9, 10, 2),
(245, 245, 2, 2, 0, 12, 0, 21, 14, 12, 7, 4),
(246, 246, 4, 4, 0, 39, 3, 35, 7, 10, 17, 4),
(247, 247, 7, 1, 6, 24, 5, 7, 9, 19, 4, 3),
(248, 248, 6, 2, 4, 4, 3, 20, 3, 12, 14, 3),
(249, 249, 6, 3, 3, 18, 6, 38, 1, 6, 11, 2),
(250, 250, 3, 2, 1, 23, 0, 2, 1, 10, 12, 2),
(251, 251, 8, 5, 3, 3, 6, 6, 8, 6, 18, 1),
(252, 252, 8, 8, 0, 4, 6, 36, 4, 16, 15, 3),
(253, 253, 4, 4, 0, 2, 4, 22, 13, 8, 13, 4),
(254, 254, 1, 1, 0, 8, 0, 3, 18, 14, 13, 1),
(255, 255, 5, 5, 0, 9, 0, 29, 1, 19, 7, 3),
(256, 256, 2, 2, 0, 12, 2, 13, 6, 12, 19, 3),
(257, 257, 5, 3, 2, 39, 3, 25, 10, 12, 2, 2),
(258, 258, 9, 6, 3, 34, 1, 9, 5, 5, 6, 4),
(259, 259, 3, 3, 0, 7, 0, 25, 6, 6, 2, 1),
(260, 260, 6, 6, 0, 7, 7, 23, 2, 8, 5, 2),
(261, 261, 2, 2, 0, 6, 5, 22, 14, 13, 2, 3),
(262, 262, 7, 7, 0, 9, 0, 13, 2, 9, 5, 3),
(263, 263, 5, 4, 1, 27, 5, 12, 12, 9, 17, 2),
(264, 264, 3, 1, 2, 7, 6, 37, 1, 18, 17, 1),
(265, 265, 8, 5, 3, 32, 3, 17, 12, 15, 8, 1),
(266, 266, 9, 5, 4, 14, 0, 23, 7, 11, 15, 3),
(267, 267, 7, 4, 3, 33, 4, 16, 13, 10, 7, 1),
(268, 268, 4, 4, 0, 2, 1, 6, 9, 19, 10, 3),
(269, 269, 8, 1, 7, 1, 0, 38, 18, 12, 8, 2),
(270, 270, 9, 2, 7, 18, 6, 12, 4, 9, 5, 2),
(271, 271, 3, 3, 0, 8, 1, 4, 3, 13, 8, 2),
(272, 272, 1, 1, 0, 18, 7, 5, 2, 16, 13, 3),
(273, 273, 7, 6, 1, 20, 7, 2, 2, 11, 9, 1),
(274, 274, 6, 5, 1, 26, 6, 36, 18, 5, 15, 1),
(275, 275, 4, 4, 0, 37, 7, 19, 12, 12, 10, 3),
(276, 276, 8, 1, 7, 3, 2, 4, 13, 12, 11, 3),
(277, 277, 9, 3, 6, 9, 1, 29, 14, 19, 2, 4),
(278, 278, 7, 2, 5, 35, 4, 33, 8, 17, 7, 4),
(279, 279, 8, 7, 1, 7, 7, 15, 11, 12, 12, 2),
(280, 280, 1, 1, 0, 18, 7, 15, 7, 10, 4, 2),
(281, 281, 9, 3, 6, 38, 1, 36, 9, 16, 16, 2),
(282, 282, 6, 3, 3, 10, 5, 21, 15, 15, 14, 3),
(283, 283, 4, 1, 3, 39, 5, 25, 3, 10, 18, 4),
(284, 284, 4, 4, 0, 32, 4, 6, 14, 5, 17, 1),
(285, 285, 9, 5, 4, 36, 5, 4, 12, 8, 17, 2),
(286, 286, 1, 1, 0, 27, 5, 11, 14, 14, 19, 1),
(287, 287, 4, 3, 1, 26, 6, 33, 19, 14, 9, 1),
(288, 288, 5, 2, 3, 7, 4, 27, 13, 15, 15, 1),
(289, 289, 8, 6, 2, 37, 3, 17, 15, 18, 7, 3),
(290, 290, 2, 2, 0, 19, 0, 36, 4, 13, 13, 3),
(291, 291, 4, 2, 2, 30, 7, 4, 13, 13, 15, 3),
(292, 292, 1, 1, 0, 28, 0, 38, 11, 13, 16, 1),
(293, 293, 2, 1, 1, 35, 6, 36, 10, 11, 10, 4),
(294, 294, 6, 4, 2, 9, 7, 1, 1, 7, 7, 3),
(295, 295, 4, 4, 0, 25, 2, 33, 14, 6, 16, 4),
(296, 296, 8, 1, 7, 28, 7, 21, 2, 19, 8, 3),
(297, 297, 6, 5, 1, 11, 2, 21, 12, 18, 19, 2),
(298, 298, 5, 1, 4, 20, 5, 35, 13, 19, 5, 4),
(299, 299, 6, 6, 0, 7, 1, 31, 2, 15, 12, 2),
(300, 300, 1, 1, 0, 35, 1, 2, 13, 11, 10, 4),
(301, 301, 3, 1, 2, 14, 0, 16, 17, 10, 12, 3),
(302, 302, 3, 2, 1, 10, 0, 37, 6, 6, 8, 2),
(303, 303, 5, 4, 1, 31, 1, 23, 19, 8, 16, 2),
(304, 304, 5, 3, 2, 4, 6, 10, 8, 18, 14, 1),
(305, 305, 6, 5, 1, 21, 2, 33, 4, 10, 8, 2),
(306, 306, 2, 1, 1, 28, 4, 3, 13, 9, 19, 1),
(307, 307, 9, 1, 8, 22, 3, 33, 12, 12, 18, 2),
(308, 308, 6, 4, 2, 38, 6, 7, 5, 8, 10, 4),
(309, 309, 8, 1, 7, 25, 4, 31, 4, 13, 3, 4),
(310, 310, 6, 6, 0, 11, 3, 23, 6, 10, 17, 3),
(311, 311, 5, 2, 3, 28, 7, 32, 18, 18, 15, 4),
(312, 312, 4, 3, 1, 33, 3, 15, 11, 18, 9, 4),
(313, 313, 4, 4, 0, 13, 2, 32, 15, 16, 17, 1),
(314, 314, 1, 1, 0, 36, 5, 21, 6, 14, 13, 2),
(315, 315, 1, 1, 0, 12, 5, 27, 1, 8, 5, 4),
(316, 316, 9, 2, 7, 21, 5, 20, 4, 11, 18, 2),
(317, 317, 3, 2, 1, 17, 7, 7, 18, 18, 18, 3),
(318, 318, 1, 1, 0, 30, 4, 31, 14, 9, 16, 2),
(319, 319, 6, 6, 0, 29, 2, 5, 13, 19, 16, 3),
(320, 320, 5, 3, 2, 29, 5, 11, 12, 17, 9, 2),
(321, 321, 8, 2, 6, 30, 2, 31, 15, 12, 6, 2),
(322, 322, 1, 1, 0, 16, 6, 16, 14, 15, 17, 1),
(323, 323, 7, 7, 0, 3, 6, 38, 7, 8, 9, 3),
(324, 324, 8, 3, 5, 18, 1, 28, 8, 8, 10, 3),
(325, 325, 7, 2, 5, 37, 7, 32, 17, 7, 19, 2),
(326, 326, 3, 3, 0, 36, 0, 3, 8, 11, 3, 2),
(327, 327, 4, 1, 3, 7, 3, 5, 7, 7, 14, 4),
(328, 328, 1, 1, 0, 29, 7, 24, 18, 5, 18, 3),
(329, 329, 3, 3, 0, 6, 1, 24, 1, 19, 18, 4),
(330, 330, 7, 7, 0, 8, 0, 30, 12, 19, 16, 2),
(331, 331, 5, 3, 2, 4, 4, 31, 3, 18, 5, 1),
(332, 332, 6, 3, 3, 2, 7, 39, 3, 16, 4, 2),
(333, 333, 3, 2, 1, 19, 1, 19, 4, 13, 10, 4),
(334, 334, 7, 7, 0, 5, 1, 3, 16, 13, 11, 3),
(335, 335, 6, 6, 0, 39, 0, 12, 9, 19, 6, 3),
(336, 336, 7, 6, 1, 32, 0, 11, 12, 8, 13, 3);
