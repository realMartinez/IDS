--drop table JOIN_KAVIAREN_ZMES_ZRN;
--drop table JOIN_REAKCIA_KAVIARNE_ZAMESTNANEC;
--drop table JOIN_REAKCIA_KAVIARNE_UZIVATEL;
--drop table JOIN_REAKCIA_AKCIE_ZAMESTNANEC;
--drop table JOIN_REAKCIA_AKCIE_UZIVATEL;
--drop table REAKCIA_AKCIE;
--drop table RECENZIA_AKCIE;
--drop table JOIN_ZMES_ZRN;
--drop table REAKCIA_KAVIARNE;
--drop table RECENZIA_KAVIARNE;
--drop table UZIVATEL;
--drop table CUPPING_AKCIA;
--drop table ZAMESTNANEC;
--drop table KAVIAREN;
--drop table MAJITEL;
--drop table DRUH_KAVY;
--drop table ZMES_KAVOVYCH_ZRN;
--drop table KAVOVE_ZRNO;
--DROP MATERIALIZED VIEW AKTIVNE_KAVIARNE;
--DROP INDEX KAVIAREN_NAZOV_INDEX

create table KAVOVE_ZRNO
(
    ID              NUMBER generated as identity,
    ODRODA          VARCHAR2(100) not null,
    STUPEN_KYSLOSTI VARCHAR2(100) not null,
    AROMA           VARCHAR2(100) not null,
    CHUT            VARCHAR2(100) not null
)
/

create unique index KAVOVE_ZRNO_ID_UINDEX
    on KAVOVE_ZRNO (ID)
/

alter table KAVOVE_ZRNO
    add constraint KAVOVE_ZRNO_PK
        primary key (ID)
/

create table ZMES_KAVOVYCH_ZRN
(
    ID          NUMBER generated as identity,
    NAZOV_ZMESI VARCHAR2(100) not null
)
/

create unique index ZMES_KAVOVYCH_ZRN_ID_UINDEX
    on ZMES_KAVOVYCH_ZRN (ID)
/

alter table ZMES_KAVOVYCH_ZRN
    add constraint ZMES_KAVOVYCH_ZRN_PK
        primary key (ID)
/

create table DRUH_KAVY
(
    ID            NUMBER generated as identity,
    NAZOV         VARCHAR2(100) not null,
    OBLAST_POVODU VARCHAR2(100) not null,
    KVALITA       VARCHAR2(100) not null,
    POPIS_CHUTI   VARCHAR2(100) not null

)
/

create unique index DRUH_KAVY_ID_UINDEX
    on DRUH_KAVY (ID)
/

alter table DRUH_KAVY
    add constraint DRUH_KAVY_PK
        primary key (ID)
/

create table MAJITEL
(
    ID         NUMBER generated as identity,
    MENO       VARCHAR2(100) not null,
    PRIEZVISKO VARCHAR2(100) not null,
    KONTAKT    VARCHAR2(100) not null
    constraint MAJITEL_KONTAKT_FORMAT
        check(REGEXP_LIKE(KONTAKT, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+$'))
)
/

create unique index MAJITEL_ID_UINDEX
    on MAJITEL (ID)
/

create unique index MAJITEL_KONTAKT_UINDEX
    on MAJITEL (KONTAKT)
/

alter table MAJITEL
    add constraint MAJITEL_PK
        primary key (ID)
/

create table KAVIAREN
(
    ID             NUMBER generated as identity,
    NAZOV          VARCHAR2(100) not null,
    ADRESA         VARCHAR2(200) not null,
    OD             VARCHAR2(5) not null
       constraint OD_FORMAT
        check(REGEXP_LIKE(OD, '^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$')),
    DO             VARCHAR2(5) not null
      constraint DO_FORMAT
        check(REGEXP_LIKE(DO, '^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$')),
    KAPACITA_MIEST NUMBER
    constraint KAPACITA_MIEST_FORMAT
        check(KAPACITA_MIEST > 0),
    POPIS          VARCHAR2(1000),
    MAJITEL        NUMBER
        constraint KAVIAREN_MAJITEL_ID_FK
            references MAJITEL
                on delete set null
)
/

create unique index KAVIAREN_ID_UINDEX
    on KAVIAREN (ID)
/

alter table KAVIAREN
    add constraint KAVIAREN_PK
        primary key (ID)
/

create table ZAMESTNANEC
(
    ID         NUMBER generated as identity,
    MENO       VARCHAR2(100) not null,
    PRIEZVISKO VARCHAR2(100) not null,
    KONTAKT    VARCHAR2(100) not null
    constraint ZAMESTNANEC_KONTAKT_FORMAT
        check(REGEXP_LIKE(KONTAKT, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+$')),
    KAVIAREN   NUMBER        not null
        constraint ZAMESTNANEC_KAVIAREN_ID_FK
            references KAVIAREN
                on delete cascade
)
/

create unique index ZAMESTNANEC_ID_UINDEX
    on ZAMESTNANEC (ID)
/

alter table ZAMESTNANEC
    add constraint ZAMESTNANEC_PK
        primary key (ID)
/

create table CUPPING_AKCIA
(
    ID                  NUMBER generated as identity,
    NAZOV               VARCHAR2(100) not null,
    DATUM_KONANIA       DATE          not null,
    CENA_OCHUTNAVKY_CZK NUMBER,
    VOLNE_MIESTA        NUMBER        not null
        constraint VOLNE_MIESTA_FORMAT
        check(VOLNE_MIESTA >= 0),
    DRUH_KAVY           NUMBER
        constraint CUPPING_AKCIA_DRUH_KAVY_ID_FK
            references DRUH_KAVY
                on delete set null,
    KAVIAREN            NUMBER        not null
        constraint CUPPING_AKCIA_KAVIAREN_ID_FK
            references KAVIAREN
                on delete cascade
)
/

create unique index CUPPING_AKCIA_ID_UINDEX
    on CUPPING_AKCIA (ID)
/

alter table CUPPING_AKCIA
    add constraint CUPPING_AKCIA_PK
        primary key (ID)
/

create table UZIVATEL
(
    ID                       NUMBER generated as identity,
    MENO                     VARCHAR2(100) not null,
    PRIEZVISKO               VARCHAR2(100) not null,
    POCET_VYPITYCH_KAV_DENNE NUMBER
    constraint POCET_VYPITYCH_KAV_DENNE_FORMAT
        check(POCET_VYPITYCH_KAV_DENNE >= 0),
    OBLUBENA_PRIPRAVA_KAVY            VARCHAR2(100),
    OBLUBENA_KAVIAREN        NUMBER
        constraint UZIVATEL_KAVIAREN_ID_FK
            references KAVIAREN
                on delete set null,
    OBLUBENY_DRUH_KAVY       NUMBER
        constraint UZIVATEL_DRUH_KAVY_ID_FK
            references DRUH_KAVY
                on delete set null
)
/

create unique index UZIVATEL_ID_UINDEX
    on UZIVATEL (ID)
/

alter table UZIVATEL
    add constraint UZIVATEL_PK
        primary key (ID)
/

create table RECENZIA_KAVIARNE
(
    ID                NUMBER generated as identity,
    POPIS             VARCHAR2(2000),
    POCET_HVIEZDICIEK NUMBER
        check (POCET_HVIEZDICIEK >= 0 and POCET_HVIEZDICIEK <= 5),
    DATUM_NAVSTEVY    DATE             not null,
    KAVIAREN          NUMBER           not null
        constraint RECENZIA_KAVIAREN_ID_FK
            references KAVIAREN
                on delete cascade,
    AUTOR             NUMBER           not null
        constraint RECENZIA_KAVIARNE_UZIVATEL_ID_FK
            references UZIVATEL
                on delete cascade,
    POCET_PALCOV_HORE NUMBER default 0 not null,
    POCET_PALCOV_DOLE NUMBER default 0 not null
)
/

create unique index RECENZIA_ID_UINDEX
    on RECENZIA_KAVIARNE (ID)
/

alter table RECENZIA_KAVIARNE
    add constraint RECENZIA_PK
        primary key (ID)
/

create table REAKCIA_KAVIARNE
(
    ID                NUMBER generated as identity,
    DATUM_VYTVORENIA  DATE             not null,
    NAZOR             VARCHAR2(2000),
    RECENZIA_KAVIARNE NUMBER           not null
        constraint REAKCIA_KAVIARNE_RECENZIA_KAVIARNE_ID_FK
            references RECENZIA_KAVIARNE
                on delete cascade,
    POCET_PALCOV_HORE NUMBER default 0 not null
        check (POCET_PALCOV_HORE >= 0),
    POCET_PALCOV_DOLE NUMBER default 0 not null
        check (POCET_PALCOV_DOLE >= 0)

)
/

create unique index REAKCIA_ID_UINDEX
    on REAKCIA_KAVIARNE (ID)
/

alter table REAKCIA_KAVIARNE
    add constraint REAKCIA_PK
        primary key (ID)
/

create table JOIN_ZMES_ZRN
(
    ID_ZMESI NUMBER not null
        constraint JOIN_ZMES_ZRN_ZMES_KAVOVYCH_ZRN_ID_FK
            references ZMES_KAVOVYCH_ZRN
                on delete cascade,
    ID_ZRNA  NUMBER not null
        constraint JOIN_ZMES_ZRN_KAVOVE_ZRNO_ID_FK
            references KAVOVE_ZRNO
                on delete cascade
)
/

create table RECENZIA_AKCIE
(
    ID                NUMBER generated as identity,
    POPIS             VARCHAR2(2000),
    POCET_HVIEZDICIEK NUMBER           not null
        check (POCET_HVIEZDICIEK >= 0 and POCET_HVIEZDICIEK <= 5),
    DATUM_NAVSTEVY    DATE             not null,
    AKCIA             NUMBER           not null
        constraint RECENZIA_AKCIE_CUPPING_AKCIA_ID_FK
            references CUPPING_AKCIA
                on delete cascade,
    AUTOR             NUMBER           not null
        constraint RECENZIA_AKCIE_UZIVATEL_ID_FK
            references UZIVATEL
                on delete cascade,
    POCET_PALCOV_HORE NUMBER default 0 not null
        check (POCET_PALCOV_HORE >= 0),
    POCET_PALCOV_DOLE NUMBER default 0 not null
        check (POCET_PALCOV_DOLE >= 0)
)
/

create unique index RECENZIA_AKCIE_ID_UINDEX
    on RECENZIA_AKCIE (ID)
/

alter table RECENZIA_AKCIE
    add constraint RECENZIA_AKCIE_PK
        primary key (ID)
/

create table REAKCIA_AKCIE
(
    ID                NUMBER generated as identity,
    DATUM_VYTVORENIA  DATE             not null,
    NAZOR             VARCHAR2(2000)   not null,
    POCET_PALCOV_HORE NUMBER default 0 not null
        check (POCET_PALCOV_HORE >= 0),
    POCET_PALCOV_DOLE NUMBER default 0 not null
        check (POCET_PALCOV_DOLE >= 0),
    RECENZIA_AKCIE    NUMBER           not null
        constraint REAKCIA_AKCIE_RECENZIA_AKCIE_ID_FK
            references RECENZIA_AKCIE
                on delete cascade
)
/

create unique index REAKCIA_AKCIE_ID_UINDEX
    on REAKCIA_AKCIE (ID)
/

alter table REAKCIA_AKCIE
    add constraint REAKCIA_AKCIE_PK
        primary key (ID)
/

create table JOIN_REAKCIA_AKCIE_UZIVATEL
(
    ID_UZIVATELA NUMBER not null
        constraint JOIN_REAKCIA_UZIVATEL_UZIVATEL_ID_FK
            references UZIVATEL
                on delete cascade,
    ID_REAKCIE   NUMBER not null
        constraint JOIN_REAKCIA_UZIVATEL_REAKCIA_ID_FK
            references REAKCIA_AKCIE
                on delete cascade
)
/

create table JOIN_REAKCIA_AKCIE_ZAMESTNANEC
(
    ID_ZAMESTNANCA NUMBER not null
        constraint JOIN_REAKCIA_ZAMESTNANEC_ZAMESTNANEC_ID_FK
            references ZAMESTNANEC
                on delete cascade,
    ID_REAKCIE     NUMBER not null
        constraint JOIN_REAKCIA_ZAMESTNANEC_REAKCIA_ID_FK
            references REAKCIA_AKCIE
                on delete cascade
)
/

create table JOIN_REAKCIA_KAVIARNE_UZIVATEL
(
    ID_UZIVATELA NUMBER not null
        constraint JOIN_REAKCIA_KAVIARNE_UZIVATEL_UZIVATEL_ID_FK
            references UZIVATEL
                on delete cascade,
    ID_REAKCIE   NUMBER not null
        constraint JOIN_REAKCIA_KAVIARNE_UZIVATEL_REAKCIA_KAVIARNE_ID_FK
            references REAKCIA_KAVIARNE
                on delete cascade
)
/

create table JOIN_REAKCIA_KAVIARNE_ZAMESTNANEC
(
    ID_ZAMESTNANCA NUMBER not null
        constraint JOIN_REAKCIA_KAVIARNE_ZAMESTNANEC_ZAMESTNANEC_ID_FK
            references ZAMESTNANEC
                on delete cascade,
    ID_REAKCIE     NUMBER not null
        constraint JOIN_REAKCIA_KAVIARNE_ZAMESTNANEC_REAKCIA_KAVIARNE_ID_FK
            references REAKCIA_KAVIARNE
                on delete cascade
)
/

create table JOIN_KAVIAREN_ZMES_ZRN
(
    ID_KAVIARNE NUMBER not null
        constraint JOIN_KAVIAREN_ZMES_ZRN_KAVIAREN_ID_FK
            references KAVIAREN
                on delete cascade,
    ID_ZMESI    NUMBER not null
        constraint JOIN_KAVIAREN_ZMES_ZRN_ZMES_KAVOVYCH_ZRN_ID_FK
            references ZMES_KAVOVYCH_ZRN
                on delete cascade
)
/

INSERT INTO KAVOVE_ZRNO (ODRODA, STUPEN_KYSLOSTI, AROMA, CHUT) values ('Arabika','vy????ia', 'siln??', 'ovocn??');
INSERT INTO KAVOVE_ZRNO (ODRODA, STUPEN_KYSLOSTI, AROMA, CHUT) values ('Robusta','ni????ia', 'slab??', 'hork??');
INSERT INTO KAVOVE_ZRNO (ODRODA, STUPEN_KYSLOSTI, AROMA, CHUT) values ('Bourbon','stredn??', 'siln??', 'ovocn??');
INSERT INTO KAVOVE_ZRNO (ODRODA, STUPEN_KYSLOSTI, AROMA, CHUT) values ('Typica','stredn??', 'v??razn??', 'hork??');
INSERT INTO KAVOVE_ZRNO (ODRODA, STUPEN_KYSLOSTI, AROMA, CHUT) values ('Geisha','stredn??', 'stredn??', 'sladk??');

INSERT INTO ZMES_KAVOVYCH_ZRN (NAZOV_ZMESI) values ('CF No1');
INSERT INTO ZMES_KAVOVYCH_ZRN (NAZOV_ZMESI) values ('CF No2');
INSERT INTO ZMES_KAVOVYCH_ZRN (NAZOV_ZMESI) values ('CF No3');
INSERT INTO ZMES_KAVOVYCH_ZRN (NAZOV_ZMESI) values ('CF No4');
INSERT INTO ZMES_KAVOVYCH_ZRN (NAZOV_ZMESI) values ('CF No5');

INSERT INTO DRUH_KAVY (NAZOV, OBLAST_POVODU, KVALITA, POPIS_CHUTI ) values ('Espresso','Taliansko','vysok??', 'hork??');
INSERT INTO DRUH_KAVY (NAZOV, OBLAST_POVODU, KVALITA, POPIS_CHUTI ) values ('Latte','Taliansko','vysok??', 'jemn??');
INSERT INTO DRUH_KAVY (NAZOV, OBLAST_POVODU, KVALITA, POPIS_CHUTI ) values ('Cappuccino','Taliansko','vysok??', 'jemne hork??');
INSERT INTO DRUH_KAVY (NAZOV, OBLAST_POVODU, KVALITA, POPIS_CHUTI ) values ('Flat Wide','Anglicko','vysok??', 'jemne hork??');
INSERT INTO DRUH_KAVY (NAZOV, OBLAST_POVODU, KVALITA, POPIS_CHUTI ) values ('Viedensk?? K??va','Rak??sko','vysok??', 'hork??');

INSERT INTO MAJITEL (MENO, PRIEZVISKO, KONTAKT ) values ('Filip', 'Vojn??k', 'filipvojnik758@gmail.com');
INSERT INTO MAJITEL (MENO, PRIEZVISKO, KONTAKT ) values ('Dominik', 'Gabris', 'bigdomco4@gmail.com');
INSERT INTO MAJITEL (MENO, PRIEZVISKO, KONTAKT ) values ('Fero', 'Fudor', 'ferendo@gmail.com');

INSERT INTO KAVIAREN (NAZOV, ADRESA, OD, DO, KAPACITA_MIEST, POPIS, MAJITEL ) values ('Caf?? Momenta','Zelny trh 314/2 Brno','08:00','22:00',28,'KUCHYNE: Medzin??rodn??, Kaviare??, Stredoeur??pske,
Eur??pske, Vhodn?? pre vegetari??nov
 POKRMY: Ra??ajky Neskor?? ra??ajky',1);
INSERT INTO KAVIAREN (NAZOV, ADRESA, OD, DO, KAPACITA_MIEST, POPIS, MAJITEL ) values ('V Melounov??m cukru','Frantishkanska 494/17, Brno','08:00','18:00',13,'KUCHYNE: Kaviare??, Eur??pske
 POKRMY: Ra??ajky, Neskor?? ra??ajky
FUNKCIE: Vonkaj??ie sedenie, Sedenie, Bezbari??rov?? dostupnos??, Pod??va alkohol, Obsluha',2);
INSERT INTO KAVIAREN (NAZOV, ADRESA, OD, DO, KAPACITA_MIEST, POPIS, MAJITEL ) values ('Bavard cafe a bar','Po??tovsk?? 4, Brno','09:00','17:00',20,'KUCHYNE: Kaviare??, Eur??pske, ??esk??
Vhodn?? pre vegetari??nov, Pre veg??nov
 POKRMY: Ra??ajky, Neskor?? ra??ajky, Obed',2);
INSERT INTO KAVIAREN (NAZOV, ADRESA, OD, DO, KAPACITA_MIEST, POPIS, MAJITEL ) values ('Cafe Mitte','Panska 11, Brno','08:00','20:00',31,'KUCHYNE: Kaviare??
 POKRMY: Ra??ajky, Ve??era
FUNKCIE: So sebou, Sedenie, Obsluha',3);

INSERT INTO ZAMESTNANEC (MENO, PRIEZVISKO, KONTAKT, KAVIAREN) values ('Marek', 'Nov??k', 'marek.novak@gmail.com', 1);
INSERT INTO ZAMESTNANEC (MENO, PRIEZVISKO, KONTAKT, KAVIAREN) values ('Jano', 'Py??n??', 'jano.pysny@gmail.com', 1);
INSERT INTO ZAMESTNANEC (MENO, PRIEZVISKO, KONTAKT, KAVIAREN) values ('Samuel', 'Novotn??', 'samuel.novotny@gmail.com', 2);
INSERT INTO ZAMESTNANEC (MENO, PRIEZVISKO, KONTAKT, KAVIAREN) values ('Ondrej', 'Mal??', 'ondrej.maly@gmail.com', 2);
INSERT INTO ZAMESTNANEC (MENO, PRIEZVISKO, KONTAKT, KAVIAREN) values ('Adam', 'Hudec', 'adamhudec@gmail.com', 3);
INSERT INTO ZAMESTNANEC (MENO, PRIEZVISKO, KONTAKT, KAVIAREN) values ('Ondrej', 'Studen??', 'ondrej.studeny@gmail.com', 3);

INSERT INTO CUPPING_AKCIA (NAZOV, DATUM_KONANIA, CENA_OCHUTNAVKY_CZK, VOLNE_MIESTA, DRUH_KAVY, KAVIAREN) values ('Espresso party',TO_DATE('2021/04/10 15:00:00', 'yyyy/mm/dd hh24:mi:ss'),20,10,1,1);
INSERT INTO CUPPING_AKCIA (NAZOV, DATUM_KONANIA, CENA_OCHUTNAVKY_CZK, VOLNE_MIESTA, DRUH_KAVY, KAVIAREN) values ('K??vopi?? 2021',TO_DATE('2021/06/19 10:00:00', 'yyyy/mm/dd hh24:mi:ss'),40,20,3,2);


INSERT INTO UZIVATEL (MENO, PRIEZVISKO, POCET_VYPITYCH_KAV_DENNE, OBLUBENA_PRIPRAVA_KAVY, OBLUBENA_KAVIAREN, OBLUBENY_DRUH_KAVY )VALUES ('Jakub', 'Gombik', 2, 'French Press', 1, 2);
INSERT INTO UZIVATEL (MENO, PRIEZVISKO, POCET_VYPITYCH_KAV_DENNE, OBLUBENA_PRIPRAVA_KAVY, OBLUBENA_KAVIAREN, OBLUBENY_DRUH_KAVY )VALUES ('Ondrej', 'Janko', 3, 'Kavovar', 3, 3);
INSERT INTO UZIVATEL (MENO, PRIEZVISKO, POCET_VYPITYCH_KAV_DENNE, OBLUBENA_PRIPRAVA_KAVY, OBLUBENA_KAVIAREN, OBLUBENY_DRUH_KAVY )VALUES ('Zuzana', '??abkov??', 2, 'Aero Press', 3, 3);
INSERT INTO UZIVATEL (MENO, PRIEZVISKO, POCET_VYPITYCH_KAV_DENNE, OBLUBENA_PRIPRAVA_KAVY, OBLUBENA_KAVIAREN, OBLUBENY_DRUH_KAVY )VALUES ('Matus', 'Stig', 2, 'Turek', 2, 1);
INSERT INTO UZIVATEL (MENO, PRIEZVISKO, POCET_VYPITYCH_KAV_DENNE, OBLUBENA_PRIPRAVA_KAVY, OBLUBENA_KAVIAREN, OBLUBENY_DRUH_KAVY )VALUES ('Marta', 'Gomb??kov??', 2, 'French Press', 1, 2);

INSERT INTO RECENZIA_KAVIARNE (POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, KAVIAREN, AUTOR, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values ('Ve??mi dobr?? k??va', 4, TO_DATE('2021/04/01 09:30:00', 'yyyy/mm/dd hh24:mi:ss'), 1, 1, 0, 0);
INSERT INTO RECENZIA_KAVIARNE (POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, KAVIAREN, AUTOR, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values ('Vynikaj??ca obsluha, dobr?? k??va', 4, TO_DATE('2021/04/01 09:30:09', 'yyyy/mm/dd hh24:mi:ss'), 3, 1, 5, 2);
INSERT INTO RECENZIA_KAVIARNE (POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, KAVIAREN, AUTOR, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values ('Skvel?? prostredie, dobr?? obsluha', 5, TO_DATE('2021/04/01 12:30:08', 'yyyy/mm/dd hh24:mi:ss'), 2, 3, 0, 9);
INSERT INTO RECENZIA_KAVIARNE (POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, KAVIAREN, AUTOR, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values ('V??born?? obsluha ale k??va chutila divne', 3, TO_DATE('2021/04/01 10:30:05', 'yyyy/mm/dd hh24:mi:ss'), 2, 4, 0, 0);
INSERT INTO RECENZIA_KAVIARNE (POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, KAVIAREN, AUTOR, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values ('Nikdy viac', 0, TO_DATE('2021/04/01 09:30:00', 'yyyy/mm/dd hh24:mi:ss'), 3, 2, 1, 1);

INSERT INTO REAKCIA_KAVIARNE (DATUM_VYTVORENIA, NAZOR, RECENZIA_KAVIARNE, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values (TO_DATE('2021-04-04 16:05:09','yyyy/mm/dd hh24:mi:ss' ),'S??hlas??m, vyborn?? obsluha',1,0,0);
INSERT INTO REAKCIA_KAVIARNE (DATUM_VYTVORENIA, NAZOR, RECENZIA_KAVIARNE, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values (TO_DATE('2021-07-04 13:06:05','yyyy/mm/dd hh24:mi:ss' ),'Presne, aj mne chutila divne',3,0,0);
INSERT INTO REAKCIA_KAVIARNE (DATUM_VYTVORENIA, NAZOR, RECENZIA_KAVIARNE, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values (TO_DATE('2021-06-05 18:13:51','yyyy/mm/dd hh24:mi:ss' ),'Sme radi, ??e v??m u n??s chutilo',4,0,0);

INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (1,1);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (1,2);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (2,1);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (2,3);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (2,4);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (3,1);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (3,3);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (4,1);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (4,4);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (4,5);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (5,1);
INSERT INTO JOIN_ZMES_ZRN(ID_ZMESI, ID_ZRNA) values (5,2);

INSERT INTO RECENZIA_AKCIE(POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, AKCIA, AUTOR,POCET_PALCOV_HORE, POCET_PALCOV_DOLE ) values ('Z??bavn?? akcia',5,TO_DATE('2021-04-10 15:00:00','yyyy/mm/dd hh24:mi:ss'),1,2,0,0);
INSERT INTO RECENZIA_AKCIE(POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, AKCIA, AUTOR,POCET_PALCOV_HORE, POCET_PALCOV_DOLE ) values ('Skvel?? akcia, v??borne som sa zabavil',5,TO_DATE('2021-04-10 15:00:00','yyyy/mm/dd hh24:mi:ss'),1,3,0,0);
INSERT INTO RECENZIA_AKCIE(POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, AKCIA, AUTOR,POCET_PALCOV_HORE, POCET_PALCOV_DOLE ) values ('V??born?? k??va ale trochu drah??ia ochutn??vka',4,TO_DATE('2021-06-19 10:00:00','yyyy/mm/dd hh24:mi:ss'),2,4,0,0);
INSERT INTO RECENZIA_AKCIE(POPIS, POCET_HVIEZDICIEK, DATUM_NAVSTEVY, AKCIA, AUTOR,POCET_PALCOV_HORE, POCET_PALCOV_DOLE ) values ('Drah??ia ochutn??vka ale st??lo to za to',5,TO_DATE('2021-06-19 10:00:00','yyyy/mm/dd hh24:mi:ss'),2,3,0,0);

INSERT INTO REAKCIA_AKCIE(DATUM_VYTVORENIA, NAZOR, RECENZIA_AKCIE, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values (TO_DATE('2021-06-04 09:11:39','yyyy/mm/dd hh24:mi:ss'), 'Ano, drah??ia ako minule', 3, 0, 0);
INSERT INTO REAKCIA_AKCIE(DATUM_VYTVORENIA, NAZOR, RECENZIA_AKCIE, POCET_PALCOV_HORE, POCET_PALCOV_DOLE) values (TO_DATE('2021-04-04 16:19:13','yyyy/mm/dd hh24:mi:ss'), 'Mrz?? n??s vy????ia ??iastka za ochutn??vku ale d??fame ??e ste si akciu aspo?? u??ili', 4, 0, 0);

INSERT INTO JOIN_REAKCIA_AKCIE_UZIVATEL(ID_UZIVATELA, ID_REAKCIE) values (3, 1);

INSERT INTO JOIN_REAKCIA_AKCIE_ZAMESTNANEC(ID_ZAMESTNANCA, ID_REAKCIE) values (3, 2);

INSERT INTO JOIN_REAKCIA_KAVIARNE_UZIVATEL(ID_UZIVATELA, ID_REAKCIE) values (2, 1);
INSERT INTO JOIN_REAKCIA_KAVIARNE_UZIVATEL(ID_UZIVATELA, ID_REAKCIE) values (4, 2);

INSERT INTO JOIN_REAKCIA_KAVIARNE_ZAMESTNANEC(ID_ZAMESTNANCA, ID_REAKCIE) values (2, 1);
INSERT INTO JOIN_REAKCIA_KAVIARNE_ZAMESTNANEC(ID_ZAMESTNANCA, ID_REAKCIE) values (4, 2);

INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (1,1);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (1,2);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (2,3);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (2,5);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (3,1);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (3,2);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (3,3);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (4,1);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (4,3);
INSERT INTO JOIN_KAVIAREN_ZMES_ZRN(ID_KAVIARNE, ID_ZMESI) values (4,4);

--Vyp????e kaviarne ich adresy a meno a kontakt majitela
SELECT KAVIAREN.NAZOV AS KAVIAREN, KAVIAREN.ADRESA, MAJITEL.MENO, MAJITEL.PRIEZVISKO, MAJITEL.KONTAKT FROM KAVIAREN INNER JOIN MAJITEL ON KAVIAREN.MAJITEL = MAJITEL.ID;
--Vyp????e zamestnancov pod??a kaviarne a kontakt na dan??ch zamestnancov
SELECT KAVIAREN.NAZOV AS KAVIAREN, ZAMESTNANEC.MENO, ZAMESTNANEC.PRIEZVISKO, ZAMESTNANEC.KONTAKT FROM ZAMESTNANEC INNER JOIN KAVIAREN ON ZAMESTNANEC.KAVIAREN = KAVIAREN.ID;
--Vyp????e zoznam cupping akci, d??tum konania, druh pod??vabnej k??vy a n??zov kaviarne konania
SELECT CUPPING_AKCIA.NAZOV AS NAZOV_AKCIE, CUPPING_AKCIA.DATUM_KONANIA AS DATUM_KONANIA, DRUH_KAVY.NAZOV AS PODAVANA_KAVA, KAVIAREN.NAZOV AS KAVIAREN FROM CUPPING_AKCIA INNER JOIN DRUH_KAVY ON CUPPING_AKCIA.DRUH_KAVY = DRUH_KAVY.ID INNER JOIN KAVIAREN ON CUPPING_AKCIA.KAVIAREN = KAVIAREN.ID;

--Vyp????e po??et zamestnancov kaviarn??
SELECT KAVIAREN.NAZOV, COUNT(ZAMESTNANEC.ID) AS POCET_ZAMESTNANCOV FROM ZAMESTNANEC LEFT JOIN KAVIAREN ON KAVIAREN.ID = ZAMESTNANEC.KAVIAREN GROUP BY KAVIAREN.NAZOV;
--Vyp????e priemern?? po??et hviezdi??iek recenzi?? na kaviare??
SELECT KAVIAREN.NAZOV AS KAVIAREN, AVG(RECENZIA_KAVIARNE.POCET_HVIEZDICIEK) AS PRIEMERNE_HODNOTENIE FROM RECENZIA_KAVIARNE LEFT JOIN KAVIAREN ON KAVIAREN.ID = RECENZIA_KAVIARNE.KAVIAREN GROUP BY KAVIAREN.NAZOV;

--Vyp????e kaviarne bez recenzie
SELECT KAVIAREN.NAZOV AS KAVIAREN FROM KAVIAREN WHERE NOT EXISTS(SELECT RECENZIA_KAVIARNE.ID FROM RECENZIA_KAVIARNE WHERE RECENZIA_KAVIARNE.KAVIAREN = KAVIAREN.ID);

--Vyp????e kaviarne s kapacitou v??????ou ako 20
SELECT NAZOV, ADRESA, OD, DO, KAPACITA_MIEST, POPIS FROM KAVIAREN WHERE KAPACITA_MIEST IN (SELECT KAVIAREN.KAPACITA_MIEST FROM KAVIAREN WHERE KAPACITA_MIEST >= 20);


--MATERIALIZED VIEW

CREATE MATERIALIZED VIEW AKTIVNE_KAVIARNE
AS SELECT KAVIAREN.NAZOV FROM KAVIAREN LEFT JOIN CUPPING_AKCIA ON KAVIAREN.ID = CUPPING_AKCIA.KAVIAREN WHERE CUPPING_AKCIA.datum_konania >= TO_DATE('2021/04/15', 'yyyy/mm/dd');



SELECT * FROM AKTIVNE_KAVIARNE;

UPDATE CUPPING_AKCIA SET DATUM_KONANIA = TO_DATE('2021/04/15', 'yyyy/mm/dd') WHERE DATUM_KONANIA <= TO_DATE('2021/04/15', 'yyyy/mm/dd');

--Po update tabulky sa view nezmen??
SELECT * FROM AKTIVNE_KAVIARNE;


--PRIVILEGES
GRANT ALL on DRUH_KAVY to xfudor00;
GRANT ALL on CUPPING_AKCIA to xfudor00;
GRANT ALL on KAVIAREN to xfudor00;
GRANT ALL on RECENZIA_AKCIE to xfudor00;
GRANT ALL on RECENZIA_KAVIARNE to xfudor00;
GRANT ALL on REAKCIA_AKCIE to xfudor00;
GRANT ALL on REAKCIA_KAVIARNE to xfudor00;
GRANT ALL on KAVOVE_ZRNO to xfudor00;
GRANT ALL on ZMES_KAVOVYCH_ZRN to xfudor00;

GRANT ALL ON USER_REVIEWS_AND_REACTIONS to xfudor00;

--Trigger ktor?? zmen?? hodnotu pocet vypit??ch kav denne na 0 ak bola vkladana hodnota NULL
CREATE OR REPLACE TRIGGER POCET_KAV_DEFAULT
BEFORE INSERT
    ON UZIVATEL
    FOR EACH ROW
    WHEN ( new.POCET_VYPITYCH_KAV_DENNE IS NULL )
BEGIN
    :new.POCET_VYPITYCH_KAV_DENNE := 0;
END;

--Vklad??me u????vatela s NULL poctom vypitych kav denne
INSERT INTO UZIVATEL (MENO, PRIEZVISKO, POCET_VYPITYCH_KAV_DENNE, OBLUBENA_PRIPRAVA_KAVY, OBLUBENA_KAVIAREN, OBLUBENY_DRUH_KAVY )VALUES ('Trigger', 'Triggerovi??', NULL, 'Kavovar', 3, 3);

--Pocet vypitych kav denne sa zmen?? na 0
SELECT MENO, POCET_VYPITYCH_KAV_DENNE FROM UZIVATEL WHERE MENO = 'Trigger';



--Proced??ra vyp????e na dmbs_output akcie, ktor?? sa konaj?? dan?? t????de?? pomocou kurzoru a premenn??ch s typom %type
CREATE OR REPLACE PROCEDURE VYPIS_AKCIE_TOHTO_TYZDNA AS
    C_NAZOV CUPPING_AKCIA.NAZOV%type;
    C_DATUM CUPPING_AKCIA.DATUM_KONANIA%type;

    CURSOR C_AKCIE is
        SELECT NAZOV, DATUM_KONANIA FROM CUPPING_AKCIA WHERE DATUM_KONANIA BETWEEN TO_DATE('2021/04/05', 'yyyy/mm/dd')
                            AND TO_DATE('2021/04/11', 'yyyy/mm/dd');
BEGIN
    OPEN C_AKCIE;
    LOOP
    FETCH C_AKCIE into C_NAZOV, C_DATUM;
        EXIT WHEN C_AKCIE%NOTFOUND;
        dbms_output.put_line('Akcia ' || C_NAZOV || ' uz tento tyzden ' || C_DATUM ||', Nezmeskaj!');
    END LOOP;
    CLOSE C_AKCIE;
END;
/

CALL VYPIS_AKCIE_TOHTO_TYZDNA();


--Proced??ra over??, ??i po??et voln??ch miest akcie nie je v???????? ako kapacita kaviarne, obsahuje vlastn?? v??nimku
CREATE OR REPLACE PROCEDURE KONTROLA_KAPACITY AS
    e_neocakavana_kapacita EXCEPTION;
    PRAGMA exception_init( e_neocakavana_kapacita, -2001 );
    KAPACITA_KAVIARNE NUMBER;
    KAPACITA_AKCIE NUMBER;
    ID_AKCIE CUPPING_AKCIA.ID%TYPE;
       CURSOR C_AKCIA is
            SELECT CUPPING_AKCIA.ID, KAVIAREN.KAPACITA_MIEST, CUPPING_AKCIA.VOLNE_MIESTA FROM CUPPING_AKCIA INNER JOIN KAVIAREN ON CUPPING_AKCIA.KAVIAREN = KAVIAREN.ID;
BEGIN
    OPEN C_AKCIA;
    LOOP
    FETCH C_AKCIA into ID_AKCIE, KAPACITA_KAVIARNE, KAPACITA_AKCIE;
        EXIT WHEN C_AKCIA%NOTFOUND;
        IF KAPACITA_AKCIE > KAPACITA_KAVIARNE THEN
            UPDATE CUPPING_AKCIA SET VOLNE_MIESTA = KAPACITA_KAVIARNE WHERE ID = ID_AKCIE;
            RAISE e_neocakavana_kapacita;
        END IF;
    END LOOP;
    EXCEPTION
        WHEN e_neocakavana_kapacita THEN
            dbms_output.put_line('Volnych miest akcie bolo viac ako kapacita kaviarne. Automaticky sme nastavili najvyssiu moznu hodnotu.');
END;
/

--Vlo??enie testovacej akcie s viac voln??mi miestami ako kapacita kaviarne, v ktorej sa akcia m?? uskuto??ni??
INSERT INTO CUPPING_AKCIA (NAZOV, DATUM_KONANIA, CENA_OCHUTNAVKY_CZK, VOLNE_MIESTA, DRUH_KAVY, KAVIAREN) values ('TEST',TO_DATE('2021/04/10 15:00:00', 'yyyy/mm/dd hh24:mi:ss'),20,600,1,1);

--Vyp????e akcie s kapacitami pred volan??m funkcie
SELECT CUPPING_AKCIA.ID, KAVIAREN.KAPACITA_MIEST, CUPPING_AKCIA.VOLNE_MIESTA FROM CUPPING_AKCIA INNER JOIN KAVIAREN ON CUPPING_AKCIA.KAVIAREN = KAVIAREN.ID;

CALL KONTROLA_KAPACITY();

--Vyp????e akcie s kapacitami po volan?? funkcie, s upraven??mi hodnotami
SELECT CUPPING_AKCIA.ID, KAVIAREN.KAPACITA_MIEST, CUPPING_AKCIA.VOLNE_MIESTA FROM CUPPING_AKCIA INNER JOIN KAVIAREN ON CUPPING_AKCIA.KAVIAREN = KAVIAREN.ID;


--EXPLAIN PLAN PRED INDEXOM
EXPLAIN PLAN FOR
    SELECT KAVIAREN.NAZOV AS KAVIAREN, AVG(RECENZIA_KAVIARNE.POCET_HVIEZDICIEK) AS PRIEMERNE_HODNOTENIE FROM RECENZIA_KAVIARNE LEFT JOIN KAVIAREN ON KAVIAREN.ID = RECENZIA_KAVIARNE.KAVIAREN GROUP BY KAVIAREN.NAZOV;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY);




--VYTVORENIE INDEXU PRE NAZOV KAVIARNE
CREATE INDEX KAVIAREN_NAZOV_INDEX ON KAVIAREN (NAZOV);

--EXPLAIN PLAN PO INDEXE
EXPLAIN PLAN FOR
    SELECT KAVIAREN.NAZOV AS KAVIAREN, AVG(RECENZIA_KAVIARNE.POCET_HVIEZDICIEK) AS PRIEMERNE_HODNOTENIE FROM RECENZIA_KAVIARNE LEFT JOIN KAVIAREN ON KAVIAREN.ID = RECENZIA_KAVIARNE.KAVIAREN GROUP BY KAVIAREN.NAZOV;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY);


COMMIT;
