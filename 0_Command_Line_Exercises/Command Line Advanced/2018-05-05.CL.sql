     1	\d
     2	\l
     3	\q
     4	\l
     5	\l
     6	\l
     7	this is one linejkkjk;
     8	this is one linejkkjk;
     9	this is one linejkkjk;
    10	this is one linejkjhjkhkjhk jk;
    11	this is" ;";
    12	\l
    13	\d
    14	\q
    15	\h
    16	\h
    17	\h fetch
    18	\h
    19	\! pwd
    20	\! pwd
    21	\!pwd
    22	\! ls -l
    23	\! ls -l
    24	\! pwd
    25	\! cd ..
    26	\! pwd
    27	\cd ..
    28	\! pwd
    29	CREATE DATABASE networking;
    30	CReAtE DaTABASE networking2;
    31	CReAtE DaTABASE NetWorking3;
    32	\l
    33	DROP DATABASE networking2;
    34	DROP DATABASE networking3;
    35	\l
    36	\c networking 
    37	CREATE TABLE friends (nombre VARCHAR,edad INT,email VARCHAR);
    38	\l
    39	\d
    40	\d friends 
    41	DROP TABLE friends ;
    42	CREATE TABLE friends (nombre VARCHAR,edad INT,email VARCHAR);
    43	INSERT INTO friends VALUES ('Lionel Messi', 30, "messi@fcbarca.com");
    44	INSERT INTO friends VALUES ('Lionel Messi', 30, 'messi@fcbarca.com');
    45	INSERT INTO friends VALUES (Ivanka Trump', 40);select * from friends ;';);
    46	INSERT INTO friends VALUES ('Ivanka Trump', 40);
    47	INSERT INTO friends VALUES ('Donald Trump', ,'donald@supertramp.com');
    48	INSERT INTO friends (nombre, email) VALUES ('Donald Trump', ,'donald@supertramp.com');
    49	INSERT INTO friends VALUES ('Mario', 25, 'this'), ('Jose', 32, 'that');
    50	SELECT * from friends ;
    51	SELECT nombre, edad from friends ;
    52	SELECT nombre, edad from friends where edad>31;
    53	SELECT nombre, email from friends where edad>31;
    54	SELECT nombre, email from friends where nombre LIKE '%T';
    55	SELECT nombre, email from friends where nombre LIKE '%I';
    56	SELECT nombre, email from friends where nombre LIKE '%I%';
    57	SELECT nombre, email from friends where nombre LIKE 'I%';
    58	SELECT nombre, email from friends where nombre LIKE 'I%';
    59	SELECT nombre, email from friends where nombre LIKE 'T%';
    60	SELECT nombre, email from friends where nombre LIKE '%T%';
    61	SELECT nombre, email from friends where nombre LIKE '%t%';
    62	SELECT nombre, email from friends where nombre LIKE '%t%';
    63	SELECT nombre, email from friends where lower(nombre) LIKE '%t%';
    64	SELECT lower(nombre), email from friends where lower(nombre) LIKE '%t%';
    65	SELECT lower(nombre), email from friends where lower(nombre) NOT LIKE '%t%';
    66	select * from friends where edad is NULL;
    67	delete from friends where edad>40;
    68	delete from friends where edad>30;
    69	delete from friends where edad is NULL;
    70	delet from friends;
    71	delete from friends;
    72	\d
    73	CREATE TABLE facebook (name VARCHAR, age INT,residence VARCHAR,email VARCHAR);
    74	INSERT INTO facebook VALUES ('Messi', 30, 'Barcelona', 'messi@bcn.com'),('Modric', 30, 'Madrid', 'modro@rm.com'),('Kovacic', 25, 'madrid', 'kova@rm.com'),('Toni', 33, 'Madrid', 'toni@gmail.com'),('Jose', 17, 'Getafe', 'jose@a.com');
    75	select * from facebook ;
    76	select * from facebook where age<18 or age>65;
    77	select * from facebook where upper(residence) != "MADRID"  ;
    78	select * from facebook where upper(residence) != 'MADRID'  ;
    79	select * from facebook where upper(residence) != 'MADRID'  ;
    80	select * from facebook ;
    81	CREATE TABLE facebook (name VARCHAR, age INT,residence VARCHAR,email VARCHAR,PRIMARY KEY (email) );
    82	CREATE TABLE facebook2 (name VARCHAR, age INT,residence VARCHAR,email VARCHAR,PRIMARY KEY (email) );
    83	\d facebook2
    84	ALTER table facebook ADD PRIMARY KEY (email);
    85	\d facebook
    86	ALTER TABLE friends ADD COLUMN telefono VARCHAR;
    87	\d friends 
    88	ALTER TABLE 
    89	ALTER TABLE facebook ADD COLUMN state VARCHAR;
    90	select * from facebook ;
    91	UPDATE facebook SET state = 'blocked' WHERE edad<18;
    92	UPDATE facebook SET state = 'blocked' WHERE age<18;
    93	select * from facebook ;
    94	UPDATE facebook SET age=34 WHERE email='toni@gmail.com';
    95	select * from facebook ;
    96	ALTER TABLE facebook DROP COLUMN state;
    97	select * from facebook ;
    98	ALTER TABLE facebook DROP COLUMN state;
    99	ALTER TABLE facebook ADD COLUMN telefono VARCHAR, ADD COLUMN usuario VARCHAR;
   100	select * from facebook ;
   101	UPDATE facebook SET usuario = 'm' where email='messi@bcn.com';
   102	UPDATE facebook SET usuario = 'lm' where email='modro@rm';
   103	UPDATE facebook SET usuario = 'lm' where email='modro@rm.com';
   104	UPDATE facebook SET usuario = 'kova' where email='kova@rm.com';
   105	UPDATE facebook SET usuario = 'joselito' where email='jose@a.com';
   106	UPDATE facebook SET usuario = 'tttonit' where email='toni@gmail.com';
   107	select * from facebook;
   108	wget https://raw.githubusercontent.com/masterdatascience/postgres/master/my_fb_friends.csv;
   109	\d
   110	select * from facebook;
   111	ALTER TABLE facebook RENAME TO facebook_old;
   112	CREATE TABLE facebook AS SELECT name, age, residence, email FROM facebook_old ;
   113	select * from facebook;
   114	DROP TABLE facebook;
   115	CREATE TABLE facebook AS SELECT name, age, residence, email as correo_electronicoFROM facebook_old ;
   116	select * from facebook;
   117	DROP TABLE facebook;
   118	CREATE TABLE facebook AS SELECT name, age, residence, email as e-mailFROM facebook_old ;
   119	select * from facebook;
   120	\! pwd
   121	\! ls
   122	\cd dsc
   123	\! ls
   124	select * from facebook;
   125	select distinct residence from facebook;
   126	select distinct upper(residence) from facebook;
   127	select *, (edad*2) as double_edad from facebook; 
   128	select *, (age*2) as double_edad from facebook; 
   129	select *, (age*2) as double_edad from facebook where (age*2) <50;
   130	select * from facebook order by age;
   131	select * from facebook order by age DESC;
   132	select * from facebook order by age ASC;
   133	select * from facebook order by age DESC, residence;
   134	select * from facebook order by age DESC, residence DESC;
   135	select * from facebook order by age LIMIT 5;
   136	select * from facebook order by age OFFSET 2 LIMIT 5;
   137	select * from facebook where age IN (17, 30);
   138	select * from facebook where age IN (17, 30) or name = 'Igor';
   139	select * from facebook where age IN (17, 30) and name = 'Jose';
   140	select * from facebook where age IN (17, 30) and name NOT 'Jose';
   141	select * from facebook where age IN (17, 30) and name != 'Jose';
   142	select avg(age), min(age), mac(age) from facebook;
   143	select avg(age), min(age), maz(age) from facebook;
   144	select avg(age), min(age), max(age) from facebook;
   145	select avg(age), min(age), max(age) from facebook;
   146	select count(*) from facebook;
   147	select count(*) as number_of_reg from facebook;
   148	select residence, count(*), avg(age) from facebook group by residence;
   149	select residence, count(*), avg(age) from facebook group by residence;
   150	select residence, age, count(*), avg(age) from facebook group by residence;
   151	select residence, age, count(*), avg(age) from facebook group by residence, age;
   152	select upper(residence), age, count(*), avg(age) from facebook group by upper(residence), age;
   153	select residence, age, count(*), avg(age) from facebook group by upper(residence), age;
   154	select  age, count(*), avg(age) from facebook group by upper(residence), age;
   155	select residence, count(*), avg(age) from facebook group by residence;
   156	select upper(residence), count(*), avg(age) from facebook group by upper(residence);
   157	select upper(residence), count(*), avg(age) from facebook group by upper(residence) having avg(age)>30;
   158	select upper(residence), count(*), avg(age) from facebook where upper(residence) != 'BERLIN' group by upper(residence) having avg(age)>30;
   159	select *, (select avg(age) from facebook where upper(residence)='MADRID') as mad_avg from facebook;
   160	select residence from facebook group by residence having avg(age)>30); 
   161	CREATE TABLE facebook2 (name VARCHAR, age INT,residence VARCHAR,email VARCHAR,PRIMARY KEY (email) );
   162	DROP TABLE facebook2;
   163	DROP TABLE facebook2;
   164	DROP TABLE if exists linkedin;
   165	CREATE TABLE linkedin ( contact VARCHAR,  company VARCHAR,  email VARCHAR);
   166	DROP TABLE if exists linkedin;
   167	CREATE TABLE linkedin ( contact VARCHAR,  company VARCHAR,  email VARCHAR);
   168	DROP TABLE if exists linkedin;
   169	DROP TABLE if exists linkedin;
   170	DROP TABLE if exists linkedin;
   171	DROP TABLE if exists linkedin;
   172	DROP TABLE if exists linkedin;
   173	CREATE TABLE linkedin ( contact VARCHAR,  company VARCHAR,  email VARCHAR);
   174	\d
   175	!\ pwd
   176	\! pwd
   177	;
   178	\! pwd
   179	\! ls 
   180	\copy linkedin from './my_ldin_contacts.csv' delimiter "^" csv header
   181	\copy linkedin from './my_ldin_contacts.csv' delimiter '^' csv header
   182	cd ~;
   183	\cd ~
   184	\cd '~'
   185	\! pwd
   186	\cd /home/dsc
   187	\d
   188	select * from linkedin ;
   189	select fb.e_mail from facebook as fbINNER JOINlinkedin as lnONfb.e_mail=ln.email; 
   190	select fb.*,ln.*  from facebook as fbINNER JOINlinkedin as lnONfb.e_mail=ln.email; 
   191	create table twitter (email varchar, account varchar);
   192	insert into twitter values ('isra@centerofworld.com', 'isra_opps'), ('kiko@centerofworld', 'KIko');
   193	select * from twitter;
   194	select fb.e_mail as email, fb.nombre as fb, ln.contact as ln, tw.account as tw FROM facebook as fbINNER JOIN linkedin AS ln ON fb.e_mail=ln.emailINNER JOIN twitter AS tw ON tw.email=fb.email;
   195	select fb.e_mail as email, fb.nombre as fb, ln.contact as ln, tw.account as tw FROM facebook as fbINNER JOIN linkedin AS ln ON fb.e_mail=ln.emailINNER JOIN twitter AS tw ON tw.email=fb.e_mail;
   196	select fb.e_mail as email, fb.name as fb, ln.contact as ln, tw.account as tw FROM facebook as fbINNER JOIN linkedin AS ln ON fb.e_mail=ln.emailINNER JOIN twitter AS tw ON tw.email=fb.e_mail;
   197	insert into twitter values ('isra@centerofworld.com', 'isra_opps'), ('kiko@centerofworld', 'KIko');
   198	select * from twitter ;
   199	select email, count(*) as duplicates from twitter group by email order by count(*) DESC; 
   200	select fb.*, tw.email, tw.account FROMfacebook as fbLEFT OUTER JOIN twitter as twon fb.e_mail=tw.email;
   201	select count(*) from facebook;
   202	select ln.*, fb.name, fb.age, fb.residence from facebook as fbRIGHT OUTER JOINlinkedin as lnON fb.e_mail=ln.email;
   203	select count(*) from linkedin ;
   204	select ln.*, fb.* from facebook as fb FULL JOIN linkedin as ln on fb.e_mail=ln.email;
   205	select ln.*, fb.* from facebook as fb FULL JOIN linkedin as ln on fb.e_mail=ln.email;
   206	select ln.account, ln.company,  CASE WHENln.email is NULL THEN fb.e_mailELSEln.emailEND as email,fb.name, fb.residence, fb.agefrom facebook as fb FULL JOIN linkedin as ln on fb.e_mail=ln.email;
   207	select  ln.company,  CASE WHENln.email is NULL THEN fb.e_mailELSEln.emailEND as email,fb.name, fb.residence, fb.agefrom facebook as fb FULL JOIN linkedin as ln on fb.e_mail=ln.email;
   208	select  ln.company,  CASE WHENln.email is NULL THEN fb.e_mailELSEln.emailEND as email,fb.name, fb.residence, fb.agefrom facebook as fb FULL JOIN linkedin as ln on fb.e_mail=ln.email;
   209	\cd Data
   210	\cd ./opentraveldata/
   211	\! ls
   212	\i create_optd_aircraft.sql 
   213	\d
