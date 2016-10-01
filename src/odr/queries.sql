-- name: testcount

select count(*) from testtable;

-- name: testsumby

select name, sum(size) from testtable group by name;
