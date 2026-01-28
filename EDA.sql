select * from branch2;
select * from employees2;
select * from books2;
select * from issued_status2;
select * from return_status2;
select * from members2;

select i.issued_member_id, i.issued_book_name, i.issued_date, r.return_date
from issued_status2 i
join return_status2 r
on i.issued_id = r.issued_id;

with limit_days as
(
select i.issued_member_id, i.issued_book_name, i.issued_date, r.return_date
from issued_status2 i
join return_status2 r
on i.issued_id = r.issued_id
),
overdue_books as (
select *, datediff(return_date, issued_date) as overdue_days
from limit_days
where datediff(return_date, issued_date) > 30
)
select *, ((overdue_days - 30) * 0.5) as overdue_fine
from overdue_books;


select r.return_id, r.return_date, b.status, r.book_quality
from return_status2 r
join books2 b
on r.return_book_isbn = b.isbn;

DELIMITER $$

create procedure book_status_update()
begin 
select r.return_date, b.status, r.book_quality,
CASE
when status = 'yes' and book_quality = 'good' then 'available'
when status = 'yes' and book_quality = 'fair' then 'check book condition'
when status = 'yes' and book_quality = 'damaged' then 'need maintenance'
when status = 'no' then 'unavailable'
END as book_availability_status
from return_status2 r
join books2 b
on r.return_book_isbn = b.isbn;
End$$

DELIMITER ;

call book_status_update;


select branch_id as Branch, count(emp_id) as no_of_employees
from employees2
group by branch_id
order by 1;

select e.branch_id as Branch, count(distinct(emp_id)) as no_of_employees, count(i.issued_id) as total_books_issued, 
	count(r.return_id) as total_books_returned, round(sum(b.rental_price), 2) as rental_revenue
from (((issued_status2 i
left join employees2 e on i.issued_emp_id = e.emp_id)
left join books2 b on i.issued_book_isbn = b.isbn)
left join return_status2 r on i.issued_id = r.issued_id)
group by branch_id
order by 1;


select max(issued_date), min(issued_date) from issued_status2;
select date_sub(max(issued_date), interval 60 day)  from issued_status2;

select distinct(m.member_id), m.reg_date, 
case 
when member_id in (select distinct(issued_member_id) from issued_status2
	where issued_date between (select date_sub(max(issued_date), interval 60 day) from issued_status2)
	and (select max(issued_date) from issued_status2))  then 'active'
when issued_member_id not in (select distinct(issued_member_id) from issued_status2
	where issued_date between (select date_sub(max(issued_date), interval 60 day) from issued_status2)
	and (select max(issued_date) from issued_status2)) then 'inactive'
else 'dormant' end as member_status
from members2 m
left join issued_status2 i on m.member_id = i.issued_member_id;



select issued_emp_id, count(issued_id) as no_of_books_issued
from issued_status2
group by issued_emp_id order by 2 desc;

select branch_id, count(distinct(issued_emp_id)) as no_of_employees, count(issued_id) as total_books_issued,
	round((count(issued_id)/count(distinct(issued_emp_id))), 0) as avg_books_per_emp
from issued_status2 i
left join employees2 e on i.issued_emp_id = e.emp_id
group by branch_id;

create table benchmark as
	select branch_id, count(distinct(issued_emp_id)) as no_of_employees, 
    count(issued_id) as total_books_issued,
	round((count(issued_id)/count(distinct(issued_emp_id))), 0) as avg_books_per_emp
from issued_status2 i
left join employees2 e on i.issued_emp_id = e.emp_id
group by branch_id;

select * from benchmark;

select e.emp_id, e.emp_name, e.position, e.branch_id as branch, count(i.issued_id) as total_books_issued,
 b.avg_books_per_emp as branch_benchmark, 
	case 
		when round((count(i.issued_id)/avg_books_per_emp) * 100, 0) >= 140 then 'top_performing'
		when round((count(i.issued_id)/avg_books_per_emp) * 100, 0) >= 100 then 'performing'
        else 'underperforming' 
	end as emp_performance 
from ((employees2 e
left join issued_status2 i on i.issued_emp_id = e.emp_id)
left join benchmark b on e.branch_id = b.branch_id)
group by e.emp_id, e.emp_name, e.position, e.branch_id, b.avg_books_per_emp
having emp_performance = 'top_performing';



select i.issued_member_id, r.book_quality from issued_status2 i
join return_status2 r on i.issued_id = r.issued_id
where book_quality = 'damaged';

with book_care as 
(
select i.issued_member_id, b.category, r.book_quality
from ((issued_status2 i
join return_status2 r on i.issued_id = r.issued_id)
join books2 b on i.issued_book_isbn = b.isbn)
where book_quality = 'damaged'
)
select *, row_number() over (partition by category) as category_count
from book_care
order by 4 desc;

