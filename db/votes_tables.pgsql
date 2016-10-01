-- MHlasování - Votes - 7 tables
-- https://www.psp.cz/sqw/hp.sqw?k=1302

CREATE TABLE hl_hlasovani(
    id_hlasovani    int, -- poll
    id_organ    int, -- ID body organs see: id_organ
    schuze  int, -- number of meetings
    cislo   int, -- number of votes
    bod int, -- Item on the agenda of the meeting; if it is less than 1, then it is a procedural vote or a vote on points at the time of the vote should not be assigned a number.
    datum   date, -- Date of vote
    čas time, -- (hour to minute)  time to vote
    pro int, -- Number of voters for
    proti   int, -- Number of voters against
    zdrzel  int, -- Number of voters abstained, ie. Pressed X
    nehlasoval  int, -- Number of applicants who have not pressed any button
    prihlaseno  int, -- The number of registered deputies
    kvorum  int, -- Quorum, the minimum number of votes to adopt the proposal
    druh_hlasovani  text, --    Type of vote: N - normal, R - Manual (not known individual MPs vote)
    vysledek    text, --    Result: A - accepted, R - rejected, otherwise confusing ballot
    nazev_dlouhy    text, --    Long point name poll
    nazev_kratky    text --    The short point name poll
);

CREATE TABLE hl_poslanec(
    id_poslanec int, -- Members identifier, see MP: id_poslanec
    id_hlasovani    int, -- ID poll, see hl_hlasovani: id_hlasovani
    vysledek    text -- Voting individual MPs. 'A' - yes, 'B' - not 'C' - delayed (pressed X) 'F' - did not vote (it was signed, but did not press any button), '@' - anonymous, 'M' - excused , 'W' - poll before taking the oath MPs 'K' - abstained / did not vote. See introductory explanation of the processing results of the vote.
);

CREATE TABLE omluvy(
    id_organ    int, -- Identifier election period, refer to the authority: id_or
    id_poslanec int, -- Members identifier, see MP: id_poslanec
    den date, --    Date apology
    datum_od  time, --  (hour to minute) Start time apologies if null , then the apology to is null and is an apology for the whole meeting day.
    datum_do  time --  (hour to minute)  End time apologies if null , then the apology from them null and is an apology for the whole meeting day.
);

CREATE TABLE  hl_check(
    id_hlasovani    int, -- ID poll, see hl_hlasovani: id_hlasovani which has been challenged.
    turn    int, -- Stenographic record number, in which the first mention of contesting the vote.
    mode    int, -- Type of challenge: 0 - request for repeat voting - in this case about the application without delay a vote and only if this application is accepted, the vote is repeated; 1 - only for communication stenozáznam not required to repeat the vote.
    id_h2   int, -- Identifier vote on the request for repeat voting, see hl_hlasovani: id_hlasovani. It records the last one that has not been challenged.
    id_h3   int --  The identifier of repeat voting, see hl_hlasovani: id_hlasovani and hl_check: id_hlasovani. It records the last one that has not been challenged.
);

CREATE TABLE hl_zposlanec(
    id_hlasovani    int, -- ID poll, see hl_hlasovani: id_hlasovani and hl_check: id_hlasovani which has been challenged.
    id_osoba    int, --     ID MP who questioned the vote; see persons: id_osoba.
    mode    int --  Type of challenge, see hl_check: mode.
);

CREATE TABLE hl_vazby(
    id_hlasovani    int, -- ID poll, see hl_hlasovani: id_hlasovani
    turn    int, -- stenographic record number
    typ int --  Type of bond: 0 - votes in the text explicitly mentioned and can thus create a link directly to the beginning of the vote, one - vote is not explicitly mentioned in the text, reference may be made only to stenozáznam as a whole.
);

CREATE TABLE zmatecne(
    id_hlasovani    int -- ID poll, see hl_hlasovani: id_hlasovani
);