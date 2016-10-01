-- Sbírka zákonů - Laws - 3 tables
-- https://www.psp.cz/sqw/hp.sqw?k=1306

CREATE TABLE druh_predpisu(
    id_dp   int, -- The identifier type of regulation.
    nazev_druhu text, --    Species name prescription
    priorita    int -- Priority Listing type of regulation.
);


CREATE TABLE sbirka(
    id_sbirka   int, -- Item identifier in the Collection
    cislo   int, -- Item number in the Collection
    rok int, -- Year items in the Collection
    id_dp   int, -- Kind of regulation, see druh_predpisu: id_dp
    id_tisk int, -- ID printing, see Printing: id_tisk; link to the Chamber of Deputies ( filled only if the legislation is the result of the parliamentary press. Currently available data prints only the current parliamentary term, ie. not all the references are correct )
    datum   date, --    Release date in the Collection
    castka  int -- amount Collections
);

CREATE TABLE sb_pre(
    id_tisk int, -- Identifier printing. If sb_pre: source = 1, then it is the Chamber of Deputies, see Printing: id_tisk if the resource = 2, then it is the Senate Print see se_tisk: id_tisk.
    cz  int, -- print number after the slash in which the first mention of the change.
    id_sbirka   int, -- print number after the slash in which the first mention of the change.
    typ int, -- Type of change: 31 - changing the regulation, 32 - abolishes regulation 0 - No change
    zdroj   int, -- Source Printing: 1 - Parliamentary Press, 2 - Senate Press
    xzdroj  int -- Source Changes: 0 - document printing, 1 - another way (eg. Suggested in the debate, found the change and others)
);
