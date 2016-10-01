-- Members and Parties - 7 tables
-- https://www.psp.cz/sqw/hp.sqw?k=1301

CREATE TABLE typ_organu (
    id_typ_org int,    -- Body type identifier
    typ_id_typ_org   int,           -- int	ID of the parent body type (typ_organu: id_typ_org) if it is null or empty, then it has superior type
    nazev_typ_org_cz  text,           -- Type the name of the institution in English
    nazev_typ_org_en text,          -- Type the name of the institution in English
    typ_org_obecny  int,  -- The general body type, if completed, the corresponding record in typ_organu: id_typ_org. Use this column can be found eg. All committees in various types of representative bodies.
    priorita int  -- Priority in the statement
);

CREATE TABLE typ_funkce (

	id_typ_funkce int, --	Type identifier functions
	id_typ_org int, --	Body type identifier, see typ_organu: id_typ_org
	typ_funkce_cz text, --	Name the type of functions in English
	typ_funkce_en text, --	Name the type of functions in English
	priorita int, --	Priority in the statement
	typ_funkce_obecny int --	The general type of function 1 - Chairman, 2 - Vice-3 - verifier, other values ​​are not used.
);

CREATE TABLE funkce (
	id_funkce int, --		The function identifier is used in the classification: id_fo
	id_organ int, --		ID body organs see: id_organ
	id_typ_funkce int, --		Type feature, see function_type: id_typ_funkce
	nazev_funkce_cz text, --		Name functions for internal use only
	priorita int --		priority listing
);


CREATE TABLE organy (
	id_organ int, --		ID body
	organ_id_organ int, --		ID of the parent body organs see: id_organ
	id_typ_organu int, --		Body type, see typ_organu: id_typ_organu
	zkratka text, --Acronym institution situated in some cases stands at the show is replaced with a different name
	nazev_organu_cz text, -- 	Name of the institution in English
	nazev_organu_en text, -- 	Name of the institution in English
	od_organ date, --		establishment of authority
	do_organ date, --		termination of authority
	priorita int, --		Priority dump bodies
	cl_organ_base int --	If set to 1, then when listing members do not appear in the records tabulkce situated where cl_funkce == 0. This behavior reflects the fact that some institutions are members, and only of them elected officials, but directly elected to a certain function.
);

CREATE TABLE osoby (
	id_osoba int, --	identifier persons
	pred text, --	Title before the name
	jmeno text, --	Name
	prijmeni text, --	Surnames, in some cases contains an addition of "Wed", "ml."
	za text, --	Degree behind name
	narozeni date, --	Date of birth, if unknown, then January 1, 1900.
	pohlavi text, --	Gender, "M" as a male, the other female values
	zmena date, --	Date of last change
	umrti date --	Date of death
);

CREATE TABLE zarazeni (
	id_osoba int, --	Identifier people see a person: id_osoba
	id_of int, --	Identifier authority or functions if he is also set location: cl_funkce == 0, then id_o corresponding organs: id_organ if cl_funkce == 1, then the corresponding function: id_funkce.
	cl_funkce int, --	Membership status or functions: if it is equal to 0, then the terms of membership, if one, then it is a function.
	od_o timestamp, -- (year to hour)	inclusion of
	do_o timestamp, -- (year to hour)	inclusion in
	od_f date, -- Mandate from . May not be completed if filled, determines the date of establishment of the mandate and location: od_o contains the date of elections.
	do_f date -- Mandate to . May not be completed if filled, determines the date of the end of the mandate and location: do_o includes an end date for inclusion.
);

CREATE TABLE poslanec (
	id_poslanec int, -- Members identifier
	id_osoba int, --	Identifier people see a person: id_osoba
	id_kraj int, --	Electoral region, see organs: id_organu
	id_kandidatka int, --	Political party / movement, see org: id_organu merely refers to the party / movement, for which he was elected, and may not be associated with membership in the Parliamentary Party.
	id_obdobi int, --	Election period and see organs: id_organu
	web text, --	URL own site Members
	ulice text, --	Address regional offices street.
	obec text, --	Address regional offices, village.
	psc text, --	Address regional offices, postal code.
	email text, --	E-mail address deputies or general posta@psp.cz.
	telefon text, --	Head of regional office phone.
	fax text, --	Address regional offices, fax.
	psp_telefon text, --	Telephone number of office buildings in PS.
	facebook text, --	Facebook page URL.
	foto int --	If it is equal to 1, there is a photo Members.
);

CREATE TABLE pkgps (
	id_poslanec	int, --	Members identifier, see MP: id_poslanec
	adresa text, --	Head offices, individual items are separated by a semicolon
	sirka text, --	North latitude, WGS 84 format GG.AABBCCC, GG = grade AA - minutes, BB - seconds, CCC - thousandths of seconds
	delka text --	East longitude, WGS 84 format GG.AABBCCC, GG = grade AA - minutes, BB - seconds, CCC - thousandths of seconds
);

