TRUNCATE druh_predpisu; TRUNCATE funkce; TRUNCATE hl_check; TRUNCATE hl_hlasovani;
TRUNCATE hl_poslanec; TRUNCATE hl_vazby; TRUNCATE hl_zposlanec; TRUNCATE omluvy;
TRUNCATE organy; TRUNCATE osoby; TRUNCATE poslanec; TRUNCATE sb_pre;
TRUNCATE sbirka; TRUNCATE typ_funkce; TRUNCATE typ_organu; TRUNCATE zarazeni;
TRUNCATE zmatecne;

-- Insert rows for each table

COPY druh_predpisu(id_dp,nazev_druhu,priorita) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/druh_predpisu.csv' DELIMITER ',' CSV;

COPY funkce(id_funkce,id_organ,id_typ_funkce,nazev_funkce_cz,priorita) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/funkce.csv' DELIMITER ',' CSV;

COPY hl_check(id_hlasovani,turn,mode,id_h2,id_h3) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/hl2013z.csv' DELIMITER ',' CSV;

COPY hl_hlasovani(id_hlasovani,id_organ,schuze,cislo,bod,datum,čas,pro,proti,zdrzel,nehlasoval,prihlaseno,kvorum,druh_hlasovani,vysledek,nazev_dlouhy,nazev_kratky) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/hl2013s.csv' DELIMITER ',' CSV;

COPY hl_poslanec(id_poslanec,id_hlasovani,vysledek) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/hl2013h1.csv' DELIMITER ',' CSV;

COPY hl_vazby(id_hlasovani,turn,typ) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/hl2013v.csv' DELIMITER ',' CSV;

-- Two tables are incorrectly documented: hl_zposlanc is actually hl_poslanec
COPY hl_zposlanec(id_hlasovani,id_osoba,mode) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/hl2013x.csv' DELIMITER ',' CSV;

COPY omluvy(id_organ,id_poslanec,den,datum_od,datum_do) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/omluvy.csv' DELIMITER ',' CSV;

COPY organy(id_organ,organ_id_organ,id_typ_organu,zkratka,nazev_organu_cz,nazev_organu_en,od_organ,do_organ,priorita,cl_organ_base) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/organy.csv' DELIMITER ',' CSV;

COPY osoby(id_osoba,pred,jmeno,prijmeni,za,narozeni,pohlavi,zmena,umrti) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/osoby.csv' DELIMITER ',' CSV;

COPY poslanec(id_poslanec,id_osoba,id_kraj,id_kandidatka,id_obdobi,web,ulice,obec,psc,email,telefon,fax,psp_telefon,facebook,foto) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/poslanec.csv' DELIMITER ',' CSV;

COPY sb_pre(id_tisk,cz,id_sbirka,typ,zdroj,xzdroj) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/sb_pre.csv' DELIMITER ',' CSV;

COPY sbirka(id_sbirka,cislo,rok,id_dp,id_tisk,datum,castka) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/sbirka.csv' DELIMITER ',' CSV;

COPY typ_funkce(id_typ_funkce,id_typ_org,typ_funkce_cz,typ_funkce_en,priorita,typ_funkce_obecny) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/typ_funkce.csv' DELIMITER ',' CSV;

COPY typ_organu(id_typ_org,typ_id_typ_org,nazev_typ_org_cz,nazev_typ_org_en,typ_org_obecny,priorita) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/typ_organu.csv' DELIMITER ',' CSV;

COPY zarazeni(id_osoba,id_of,cl_funkce,od_o,do_o, od_f,do_f) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/zarazeni.csv' DELIMITER ',' CSV;

COPY zmatecne(id_hlasovani) 
FROM '/Users/jstephensii/src/okno-do-radice/okno-do-radnice/db/parliament/zmatecne.csv' DELIMITER ',' CSV;
