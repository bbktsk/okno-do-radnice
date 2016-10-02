-- name: testcount

select count(*) from testtable;

-- name: testsumby

select name, sum(size) from testtable group by name;

-- name: clean-organs!
delete from organy where id_organ >= 10000 and id_organ < 11000;
-- name: clean-hl_hlasovani!
delete from hl_hlasovani where id_organ >= 10000 and id_organ < 11000;
--name: clean-hl_poslanec!
delete from hl_poslanec where id_poslanec >= 10000 and id_poslanec < 11000;
-- name: clean-osoby!
delete from osoby where id_osoba >= 10000 and id_osoba < 11000;

-- name: create-hmp!
insert into organy (id_organ, zkratka, nazev_organu_cz, od_organ, do_organ)
       values (10000, 'MHMP', 'Magistrat hlavniho mesta Prahy', '2014/10/13', '2018/10/31')

-- name: insert-hlasovani!
insert into hl_hlasovani (id_organ, id_hlasovani, datum, vysledek, nazev_dlouhy, nazev_kratky)
       values (10000, :id_hlasovani, :datum::date, :vysledek, :url, :nazev)

-- name: insert-hl_poslanec!
insert into hl_poslanec (id_poslanec, id_hlasovani, vysledek)
       values (:id_poslanec, :id_hlasovani, :vysledek)

-- name: insert-osoby!
insert into osoby (id_osoba, pred, jmeno, prijmeni, za, pohlavi)
       values (:id_osoba, :pred, :jmeno, :prijmeni, :za, :pohlavi)

-- name: presence
select jmeno, prijmeni, pohlavi, absent, total, 100*absent/total as percentage
from
        osoby,
        (select id_poslanec,
                sum(case when vysledek in ('K', 'M') then 1 else 0 end) as absent,
                count(vysledek) as total
         from hl_poslanec
         where id_poslanec >= 10000
         group by id_poslanec) as sums
where  sums.id_poslanec = osoby.id_osoba
order by percentage;
