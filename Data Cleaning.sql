use my_project2;
select * from books;

create table books2
like books;

select * from books2;

insert into books2
select * from books;

select distinct(isbn)
from books2
order by 1;

select author, count(*) as duplicate_count
from books2
group by author
having count(*) > 1;



create table branch2
like branch;

select * from branch2;

insert into branch2
select * from branch;

select distinct(manager_id)
from branch2;


create table employees2
like employees;

select * from employees2;

insert into employees2
select * from employees;

select distinct(position)
from employees2;


create table issued_status2
like issued_status;

select * from issued_status2;

insert into issued_status2
select * from issued_status;

select issued_date, str_to_date(issued_date, '%Y/%m/%d')
from issued_status2;

update issued_status2
set issued_date = str_to_date(issued_date, '%Y-%m-%d');

alter table issued_status2
modify column issued_date date;


create table members2
like members;

select * from members2;

insert into members2
select * from members;

select member_address, count(*) as duplicate_count
from members2
group by member_address
having count(*) > 1 order by 2 desc;


create table return_status2
like return_status;

select * from return_status2;

insert into return_status2
select * from return_status;

select return_date, date(return_date)
from return_status2;

update return_status2
set return_date = date(return_date);

alter table return_status2
modify column return_date date;


describe issued_status2;

