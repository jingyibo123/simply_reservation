CREATE TABLE MEMBRE (
	ID_USER INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	EMAIL VARCHAR(50) UNIQUE,
	NOM VARCHAR(50),
	PRENOM VARCHAR(50),
	MDP VARCHAR(50),
	DROIT INT(1) unsigned, /* 1 pour administrateur, 2 pour restaurateur */
	ACTIF INT(1) unsigned  /* 1 pour actif, 0 inactif*/
);

CREATE TABLE RESTAURANT (
	ID_RESTO INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_USER INT(10) unsigned NOT NULL,
	NOM_RESTO VARCHAR(100),
	ADRESSE VARCHAR(100),
	TELEPHONE VARCHAR(20),
	DESCRIPTIF VARCHAR(1000),
	IMAGE VARCHAR(200), /*répertoire images*/
	ACTIF INT(1) unsigned, /* 1 pour actif, 0 inactif*/
	FOREIGN KEY (ID_USER) REFERENCES MEMBRE(ID_USER) ON DELETE RESTRICT
);

/*Définition du calendrier hebdomadaire du restaurant*/
CREATE TABLE CALENDRIER_HEBDO (
	ID_RESTO INT(10) unsigned NOT NULL,
	JOUR enum('1','2','3','4','5','6','7') NOT NULL,/*  1 pour dimache, 2 pour lundi...7 pour samedi*/
	HORAIRE TIME,
	NB_TABLES INT(3),
	ACTIF INT(1) unsigned,
	PRIMARY KEY (ID_RESTO, JOUR, HORAIRE),
	FOREIGN KEY (ID_RESTO) REFERENCES RESTAURANT(ID_RESTO) ON DELETE RESTRICT
);

/*Définition des dates exceptionnelles du restaurant*/
CREATE TABLE CALENDRIER_EXCEPTION (
	ID_RESTO INT(10) unsigned NOT NULL,
	DATE_EXCEPTION DATE,
	HORAIRE TIME,
	NB_TABLES INT,
	ACTIF INT(1) unsigned,
    PRIMARY KEY (ID_RESTO, DATE_EXCEPTION, HORAIRE),
	FOREIGN KEY (ID_RESTO) REFERENCES RESTAURANT(ID_RESTO) ON DELETE RESTRICT
);

CREATE TABLE OFFRE (
	ID_OFFRE INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY, /*Doit être cohérente avec celle de la BDD de la plateforme*/
	ID_RESTO INT(10) unsigned NOT NULL,
	DESCRIPTIF VARCHAR(1000),
	ACTIF INT(1) unsigned,
	FOREIGN KEY (ID_RESTO) REFERENCES RESTAURANT(ID_RESTO) ON DELETE RESTRICT
);

CREATE TABLE CONNEXION_CLIENT (
	ID_OFFRE INT(10) unsigned NOT NULL,
	IP VARCHAR(15),
	URL VARCHAR(100),
	VISITE DATETIME,
	PRIMARY KEY (ID_OFFRE, IP, URL, VISITE),
	FOREIGN KEY (ID_OFFRE) REFERENCES OFFRE(ID_OFFRE) ON DELETE RESTRICT
);

CREATE TABLE CONNEXION_ERRONEE (
	IP VARCHAR(15),
	URL VARCHAR(100),
	VISITE DATETIME,
	PRIMARY KEY (IP, URL, VISITE)
);

CREATE TABLE RESERVATION (
	ID_RESA INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_OFFRE INT(10)unsigned NOT NULL,
	EMAIL_CLIENT VARCHAR(50),
	NOM VARCHAR(50),
	PRENOM VARCHAR(50),
	DATE_RESA DATETIME,
	NB_TABLES INT(3),
	NB_PRS INT(3),
	DATE_CREER DATETIME,
	ACTIF INT(1) unsigned,
	FOREIGN KEY (ID_OFFRE) REFERENCES OFFRE(ID_OFFRE) ON DELETE RESTRICT
);

/*Enregistrement des annulations des réservations*/
CREATE TABLE ANNULATION_RESA (
	ID_RESA INT(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	MOTIF VARCHAR(500),
	FOREIGN KEY (ID_RESA) REFERENCES RESERVATION(ID_RESA) ON DELETE RESTRICT
);




INSERT INTO `MEMBRE`(`ID_USER`, `EMAIL`, `NOM`, `PRENOM`, `MDP`, `DROIT`, `ACTIF`) VALUES
 ('','David11313@yahoo.fr','David','ROBERT','7581f38742fbcc46d3f3a56f47b987fa', 2,1),/*MDP: minesnantes */ 
 ('','josephchutin@gmail.com','Joseph','Chutin','3594cfc4c0384af96c5a56954b580776', 2,1),/*MDP: vivelafrance */ 
 ('','paul19830611@hotmail.com','Paul','DUVAL','ddb2ae308bb0d4bb02d778516d215c18', 1,1), /*MDP: simpleCE */
 ('','baptisterobert@gmail.com','Baptiste','ROBERT','482c811da5d5b4bc6d497ffa98491e38',1,1);  /*MDP: password123 */

INSERT INTO `RESTAURANT`(`ID_RESTO`, `ID_USER`,`NOM_RESTO`, `ADRESSE`, `TELEPHONE`, `DESCRIPTIF`, `IMAGE`, `ACTIF`) VALUES
 ('',1,'La Bonne franquette','4 Allée Jean 44400 Nantes','+33 02 51 92 37 22','Très bonne','images/pomme.jpg',1),
 ('',1,'Le ventre plein','7 Place Royal 44400 Nantes','+33 02 19 64 87 34','Moyenne ...','images/gateau.jpg',1);

INSERT INTO `CALENDRIER_HEBDO`(`ID_RESTO`, `JOUR`, `HORAIRE`, `NB_TABLES`, `ACTIF`) VALUES
 (1,1,'11:00:00',2,1),
 (1,1,'13:00:00',2,1),
 (1,1,'15:00:00',3,1),
 (1,2,'12:00:00',2,1),
 (1,2,'14:00:00',2,1),
 (1,2,'16:00:00',3,1),
 (1,3,'13:00:00',2,1),
 (1,3,'15:00:00',2,1),
 (1,4,'14:00:00',3,1),
 (1,4,'16:00:00',2,1),
 (1,4,'18:00:00',2,1),
 (1,5,'15:00:00',3,1),
 (1,5,'17:00:00',1,1),
 (1,6,'16:00:00',2,1),
 (1,6,'18:30:00',2,1);

INSERT INTO `CALENDRIER_EXCEPTION`(`ID_RESTO`, `DATE_EXCEPTION`, `HORAIRE`, `NB_TABLES`, `ACTIF`) VALUES
 (1,'2015-3-18','15:00:00',0,1),
 (1,'2015-3-18','21:00:00',1,1),
 (1,'2015-3-22','15:00:00',1,1);

INSERT INTO `OFFRE`(`ID_OFFRE`, `ID_RESTO`, `DESCRIPTIF`, `ACTIF`) VALUES
 ('','1','15% de remise sur les menus',1),
 ('','1','un dessert gratuit',1),
 ('','2','10% de remise sur tous les entrées',1);

INSERT INTO `CONNEXION_CLIENT`(`ID_OFFRE`, `IP`, `URL`, `VISITE`) VALUES
 (1,'53.164.48.166','','2015-3-16 14:30:16'),
 (1,'53.164.48.166','','2015-3-17 12:05:55'),
 (2,'78.161.244.13','','2015-2-16 19:12:03');

INSERT INTO `CONNEXION_ERRONEE`(`IP`, `URL`, `VISITE`) VALUES
 ('88.188.188.93', '','2015-4-16 22:30:15'),
 ('88.188.188.93', '' ,'2015-4-16 22:30:13'),
 ('88.188.188.93', '' ,'2015-4-16 22:30:19'),
 ('88.188.188.93', '' ,'2015-4-16 22:30:22'),
 ('202.106.196.115', '' ,'2015-4-16 11:15:20'),
 ('202.106.196.115', '' ,'2015-4-16 11:15:25'),
 ('202.106.196.115', '' ,'2015-4-16 11:15:29'),
 ('202.106.196.115', '' ,'2015-4-16 11:15:44');

INSERT INTO `RESERVATION`(`ID_RESA`, `ID_OFFRE`, `EMAIL_CLIENT`, `NOM`, `PRENOM`, `DATE_RESA`, `NB_TABLES`, `NB_PRS` , `DATE_CREER`,`ACTIF`) VALUES
 ('',1,'johndoe@webmail.com','Doe','JOHN','2015-6-11 12:00:00', 1,2, '2015-6-11 12:00:00',1),
 ('',2,'julie1442@yahoo.fr','Julie','DGL','2015-5-09 19:00:00', 1,3, '2015-4-4 19:00:00',1),
 ('',2,'poisson@rouge.com','Edouard','Dutronc','2015-6-03 19:00:00', 1,3,'2015-5-12 09:00:00',1),
 ('',3,'clementespaze@webmail.com','Clement','ESPAZE','2015-4-11 17:00:00', 2,6,'2015-6-13 17:00:00',1);