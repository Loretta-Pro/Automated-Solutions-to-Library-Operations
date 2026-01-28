# Automated Solutions to Library Operations

**Author:** Loretta Chimezie   
**Date:** 2026-01-09

## Project Background
This project analyzes operational datasets and introduces automated solutions to optimize performance, improve service delivery, and reduce operational costs across library processes. The solution improves process accuracy, reduces processing time and enhances organizational effectiveness for strategic decision-making.  

## Project Objective
To create SQL queries or procedures that addresses each of the following issues:
1.	Identify the scope of overdue book problem – how many members with unreturned books and how much losses
2.	Instantly updates books status
3.	Shows performance metrics across all branches
4.	Identify active and inactive members
5.	To track staff productivity besides manager’s observations
6.	Identifies members with damaged book(s) history in order to reduce annual replacement cost

## Datasets Description
- **books.csv** 
- **branch.csv**
- **employees.csv**
- **members.csv**
- **issued_status.csv**
- **return_status.csv**
- **Key fields** — member_id, reg_date, branch_id, emp_id, issued_date, return_date, book_name, book_quality, book_title, category, status

## Data Cleaning
•	Converted string dates using STR_TO_DATE()

## Key KPIs
Total books issued - 420
Total books returned - 150
Most borrowed category - History
Damaged books count - 22
Active members - 32
Overdue books count – 72


## Sample SQL Snippets
```sql																					
with category_count as 																	select r.return_date, b.status, r.book_quality,
(																						CASE
select i.issued_member_id, b.category													when status = 'yes' and book_quality = 'good' then 'available'
from issued_status2 i																	when status = 'yes' and book_quality = 'fair' then 'check book condition'
join books2 b on i.issued_book_isbn = b.isbn											when status = 'yes' and book_quality = 'damaged' then 'need maintenance'	
)																						when status = 'no' then 'unavailable'
select *, row_number() over (partition by category) as most_borrowed_category			END as book_availability_status
from category_count																		from return_status2 r	
order by 3 desc;																		join books2 b on r.return_book_isbn = b.isbn;
																						








## Summary of Findings
•	B005 generates more revenue than the two previous branches before it. B001 generates the highest revenue
•	Each employee makes an average of 89 in revenue in branch B005 while average of 59 in revenue in branch B002
•	420 members have borrowed books out of which only 32 are active (have borrowed books in the last 60days)
•	Over 3000 members are registered but have never borrowed books
•	On the average, each staff is meant to issue at least 9books across branches.
•	Identified five staffs who are considered as top performers and twenty staffs as under-performing
•	Book category that are returned damaged are usually the science fiction and children’s books
•	Most borrowed books are in the History category, followed by Fiction and then Thriller

## Recommendations
•	I suggest we re-introduce the "Summer Reading Challenge" promotion or any other promotions to encourage more numbers to be active
•	Increase overdue fines to encourage members to return books on or before due date
•	Branch B005 is doing well in terms of performance and revenue compared to other branches
•	Target re-engagement campaigns for dormant members
•	Training program for underperforming staff
•	Do a staff reshuffling across branches if possible
•	Have informed conversations with members who usually borrow science fiction and children books about book care
•	Carry out another member satisfaction ratings related to service speed in the nearest future to check for improved rate

## Tools & Technologies
-	SQL (MySQL)
-	MySQL Workbench

## Project Files (included)
-	`Data_cleaning.sql` — Data cleaning and transformation in SQL
-	`EDA.sql` — Exploratory Data Analysis
-	`/books/` — raw data files used for analysis (csv)
- 	`/branch/` — raw data files used for analysis (csv)
-	`/employees/` — raw data files used for analysis (csv)
-	`/issued_status/` — raw data files used for analysis (csv)
-	`/members/` — raw data files used for analysis (csv)
-	`/return_status/` — raw data files used for analysis (csv)
-	`Presentation.pdf` — boardroom slide deck (16 slides)
-	`README.md` — this documentation

## How to Run / View
1.	Import the datasets into your SQL environment
2.	Open script file in SQL editor
3.	Run the queries in the queries folder
4.	Review the results tables
5.	Refer to `Presentation.pdf` for a summary of insights and recommended actions

## Contact 
Loretta Chimezie   
Email: _chimezieloretta@gmail.com_    
LinkedIn: _ https://www.linkedin.com/in/loretta-chimezie/_
