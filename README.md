
# ![Apple Logo](https://github.com/Md-Rifat-Sarker2/SQL_Apple_Retail_Sales/blob/main/Apple_Changsha_RetailTeamMembers.jpg) Apple Retail Sales SQL Project - Analyzing Millions of Sales Rows

**Get the datasets here**: [Get the Project Datasets](https://www.kaggle.com/datasets/amangarg08/apple-retail-sales-dataset)

## Project Overview

This project is designed to showcase advanced SQL querying techniques through the analysis of over 1 million rows of Apple retail sales data. The dataset includes information about products, stores, sales transactions, and warranty claims across various Apple retail locations globally. By tackling a variety of questions, from basic to complex, you'll demonstrate your ability to write sophisticated SQL queries that extract valuable insights from large datasets.

The project is ideal for data analysts looking to enhance their SQL skills by working with a large-scale dataset and solving real-world business questions.

## Entity Relationship Diagram (ERD)

![ERD](https://github.com/Md-Rifat-Sarker2/SQL_Apple_Retail_Sales/blob/main/EDR.png)

Here’s the shortened and improved version of the "What’s Included" and "Why Choose This Project" sections : 

---

### What’s Included:
- **20 Advanced SQL Queries**: Step-by-step solutions for complex queries, enhancing your skills in performance tuning and optimization.
- **5 Detailed Tables**: Comprehensive datasets with over 1 million rows, including sales, stores, product categories, products, and warranties.
- **Query Performance Tuning**: Learn to optimize queries for real-world data handling.

### Why Choose This Project?
- **Hands-on Learning**: Practical experience with complex datasets and advanced business problem-solving.
- **Comprehensive Coverage**: Each table provides new opportunities to explore SQL concepts.

## Database Schema

The project uses five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## Objectives
**Set up the Library Management System Database**: Set up the Library Management System Database by creating and populating structured tables for branches, employees, members, books, issued status, and return status, ensuring proper relationships and data integrity to support efficient library operations and transaction tracking.
```sql
--Drop Table Command
drop table if exists warranty;
drop table if exists sales;
drop table if exists products;
drop table if exists category;
drop table if exists stores;

--Create Table Command
--Store Table
create table stores(
	Store_ID varchar(5) primary key,
	Store_Name varchar(30),
	City varchar(25),
	Country varchar(25)
);

--Category Table
create table category(
	category_id varchar(10) primary key,
	category_name varchar(20)
);

--Product Table
create table products(
	Product_ID	varchar(10) primary key,
	Product_Name varchar(35),
	Category_ID	varchar(10),
	Launch_Date	date,
	Price float,
	constraint fk_category foreign key (Category_ID) references category(category_id)
);

--Sales Table
create table sales(
	sale_id	varchar(15) primary key,
	sale_date date,
	store_id varchar(10),
	product_id varchar(10),
	quantity int,
	constraint fk_store foreign key (store_id) references stores (Store_ID),
	constraint fk_products foreign key (product_id) references products (Product_ID)
);


create table warranty(
	claim_id varchar(10) primary key,
	claim_date date,
	sale_id	varchar(15),
	repair_status varchar(15),
	constraint fk_orders foreign key (sale_id) references sales(sale_id)
);

-- Successful Message
select 'Schema Created Successfully.' as Success_Message;
```
**Query Optimization Techniques in SQL**: Applied SQL query optimization techniques to improve database performance and efficiency while working with large datasets. This included writing optimized queries, reducing execution time, improving indexing strategies, and ensuring efficient data retrieval. The work demonstrates a strong understanding of performance tuning and best practices essential for scalable and high-performing database systems.
```sql
select * from category;
select * from products;
select * from sales;
select * from stores;
select * from warranty;

-- ----------------------------
-- Improving Query Permformance
-- ----------------------------

explain analyze           
select * from sales
where product_id = 'P-44';
--Execution Time : 373.752ms
--Planning Time : 0.105ms

create index sales_product_id on sales(product_id);
--After Index
--Execution Time : 11.204ms
--Planning Time : 0.159ms

explain analyze
select * from sales
where store_id = 'ST-31';
--Execution Time : 245.050ms
--Planning Time : 0.106ms

create index sales_store_id on sales(store_id);
--After Index
--Execution Time : 12.721ms
--Planning Time : 0.164ms

create index sales_sale_date on sales(sale_date);
```
**The project is split into three tiers of questions to test SQL skills of increasing complexity:**

### Easy to Medium (10 Questions)

Task 1: Find the number of stores in each country.
```sql
select 
	country,
	count (*) as total_store
from stores
group by 1
order by 2 desc;
```
Task 2: Calculate the total number of units sold by each store.
```sql
select 
	st.store_id,
	st.store_name,
	sum(sl.quantity) as total_units
from sales as sl
	join stores as st
	on sl.store_id = st.store_id
group by 1,2
order by 3;
```
Task 3: Identify how many sales occurred in December 2023.
```sql
select 
	count(*) as total_sale_dec
from sales
where to_char(sale_date,'MM-YYYY') = '12-2023';
```
Task 4: Determine how many stores have never had a warranty claim filed.
```sql
select 
	count(*)
from stores
where store_id not in (
						select 
							distinct s.store_id
						from sales as s
							right join warranty as w
							on w.sale_id = s.sale_id);
```
Task 5: Calculate the percentage of warranty claims marked as "Rejected".
```sql
select 
	round(
	count(*)/(select count(*) from warranty)::numeric * 100,2
	) as rejected_percentages
from warranty
where repair_status = 'Rejected';
```
Task 6: Identify which store had the highest total units sold in the last two year.
```sql
select 
	st.store_name,
	sum(s.quantity) as total_units
from sales as s
join stores as st
on st.store_id = s.store_id
where sale_date>=current_date - interval '2 year'
group by 1
order by 2 desc
limit 1;
```
Task 7: Count the number of unique products sold in the last two year.
```sql
select 
	count(distinct product_id) as unique_product
from sales
where sale_date >= current_date - interval '2 year';
```
Task 8: Find the average price of products in each category.
```sql
select
	c.category_name,
	round(avg(p.price)::numeric,0) as avg_price
from products as p
	join category as c
	on c.category_id = p.category_id
group by 1
order by 2 desc;
```
Task 9: How many warranty claims were 'Completed' filed in 2024?
```sql
select 
	count(*) as total_competed_claim
from warranty
	where repair_status = 'Completed'
		and
		to_char(claim_date,'YYYY') = '2024'
		 --extract(year from claim_date) = 2024;
```
Task 10: For each store, identify the best-selling day based on highest quantity sold.
```sql
select * from
			(select 
				store_id,
				to_char(sale_date,'Day') as day_name,
				sum(quantity) as total_sell,
				rank() over(partition by store_id order by sum(quantity) desc) as rank
			from sales
			group by 1,2
			) as t1
where rank = 1;
```
### Medium to Hard (5 Questions)

Task 1: Identify the least selling product in each country based on total units sold.
```sql
with product_rank
as
(
select 
	st.country,
	p.product_name,
	sum(s.quantity) as total_sell,
	rank() over(partition by st.country order by sum(s.quantity)) as rank
from sales as s
	join stores as st
	on s.store_id = st.store_id
	join products as p
	on p.product_id = s.product_id
group by 1,2
)

select * from product_rank
where rank =1;

```
Task 2: Calculate how many warranty claims were filed within 180 days of a product sale.
```sql
select 
	count (*) as w_within_180_days
from warranty as w
	left join sales as s
	on w.sale_id = s.sale_id
where (w.claim_date - s.sale_date) <= 180;
```
Task 3: Determine how many warranty claims were filed for differnet products launched in the last two years.
```sql
select 
	p.product_name,
	count(w.claim_id) as total_claim,
	sum(s.quantity) as total_sell
from warranty as w
	right join sales as s
	on s.sale_id = w.sale_id
	join products as p
	on p.product_id = s.product_id
where p.launch_date >= current_date - interval '2 year'
group by 1
having count(w.claim_id)>0;
```
Task 4: List the months in the last three years where sales exceeded 5,000 units in the United States.
```sql
select 
	extract (year from s.sale_date) as year,
	to_char(s.sale_date,'Month') as month,
	sum(s.quantity) as tota_sell
from sales as s
	join stores as st
	on st.store_id = s.store_id
where 
	st.country = 'United States'
	and 
	s.sale_date >= current_date - interval '3 year'
group by 1,2
having sum(s.quantity)>=5000
order by 1;

```
Task 5: Identify the product category with product name and the most warranty claims filed in the last two years.
```sql
select * 
from (
		select 
				c.category_name,
				p.product_name,
				count (w.claim_id) as total_claim,
				rank() over(partition by c.category_name order by count (w.claim_id) desc) as rank
			from warranty as w
				left join sales as s
				on s.sale_id = w.sale_id
				join products as p
				on p.product_id = s.product_id
				join category as c
				on c.category_id = p.category_id
			where w.claim_date 	>= current_date - interval '2 year'
			group by 1,2
	   ) as t1
where rank =1;
```
### Complex (5 Questions)

Task 1: Determine the percentage chance of receiving warranty claims after each purchase for each country.
```sql
select 
	country,
	total_sales,
	total_cliam,
	round((total_cliam::numeric/total_sales::numeric)*100,2) as risk_percentage
from
	(
	select 
		st.country,
		sum(s.quantity) as total_sales,
		count(w.claim_id) as total_cliam
	from sales as s
		join stores as st
		on s.store_id = st.store_id
		left join warranty as w
		on w.sale_id = s.sale_id
	group by 1
	) as t1
order by 4 desc;
```
Task 2: Analyze the year-by-year growth ratio for each store.
```sql
with yearly_sales
as
(
	select 
		st.store_id,
		st.store_name,
		extract(year from s.sale_date) as year,
		sum(s.quantity * p.price) as total_price
	from sales as s
	join stores as st
	on s.store_id = st.store_id
	join products as p
	on p.product_id = s.product_id
	group by 1,2,3
	order by 2,3
),
growth_ratio
as
(
	select 
		store_name,
		year,
		lag(total_price,1) over(partition by store_name order by year) as last_year_sale,
		total_price as current_year_sale
	from yearly_sales
)
select 
	store_name,
	year,
	last_year_sale,
	current_year_sale,
	round((current_year_sale - last_year_sale)::numeric/last_year_sale::numeric * 100,2)  as sale_growth
from growth_ratio
where last_year_sale is not null;
```
Task 3: Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
```sql
select 
	case
		when p.price<500 then 'Less Expensive Price'
		when p.price between 500 and 1000 then 'Mid Expensive Price'
		else 'High Expensive Price'
	end as price_segment,
	count(w.claim_id) as total_count
from warranty as w
	left join sales as s
	on s.sale_id = w.sale_id
	join products as p
	on p.product_id = s.product_id
where w.claim_date >= current_date - interval '5 year'
group by 1;
```
Task 4: Identify the store with the highest percentage of "Completed" claims relative to total claims filed.
```sql
with completed_repair
as
(
select 
	s.store_id,
	count(w.claim_id) as total_repair_completed
from sales as s
	right join warranty as w
	on w.sale_id = s.sale_id
where w.repair_status = 'Completed'
group by 1
),

total_repaired
as
(
select 
	s.store_id,
	count(w.claim_id) as total_repair
from sales as s
	right join warranty as w
	on w.sale_id = s.sale_id
group by 1
)

select 
	tr.store_id,
	st.store_name,
	cr.total_repair_completed,
	tr.total_repair,
	round(cr.total_repair_completed::numeric/tr.total_repair::numeric * 100,2) as percentage_completed_repaired
from completed_repair as cr
	join total_repaired as tr
	on cr.store_id = tr.store_id
	join stores as st
	on tr.store_id = st.store_id;
```
Task 5: Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
```sql
with monthly_sales
as
(
select 
	s.store_id,
	extract (year from s.sale_date) as year,
	extract (month from s.sale_date) as month,
	sum(s.quantity * p.price) as total_revenue
from sales as s
join products as p
on p.product_id = s.product_id
group by 1,2,3
order by 1,2,3
)
select 
	store_id,
	year,
	month,
	total_revenue,
	sum(total_revenue) over(partition by store_id order by year,month) as running_revenue
from monthly_sales;
```
### Bonus Question

B.Q : Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
```sql
select 
	p.product_name,
	case
		when s.sale_date between p.launch_date and p.launch_date + interval '6 month' then '0-6 months'
		when s.sale_date between p.launch_date + interval '6 month' and  p.launch_date + interval '12 month' then '6-12 months'
		when s.sale_date between p.launch_date + interval '12 month' and p.launch_date + interval '18 month' then '12-18 months'
		else '18+ months'
	end as product_life_cycle,
	sum(s.quantity)
from sales as s
join products as p
on p.product_id = s.product_id
group by 1,2
order by 1,3;
```
## Project Focus

This project primarily focuses on developing and showcasing the following SQL skills:

- **Complex Joins and Aggregations**: Demonstrating the ability to perform complex SQL joins and aggregate data meaningfully.
- **Window Functions**: Using advanced window functions for running totals, growth analysis, and time-based queries.
- **Data Segmentation**: Analyzing data across different time frames to gain insights into product performance.
- **Correlation Analysis**: Applying SQL functions to determine relationships between variables, such as product price and warranty claims.
- **Real-World Problem Solving**: Answering business-related questions that reflect real-world scenarios faced by data analysts.


## Dataset

- **Size**: 1 million+ rows of sales data.
- **Period Covered**: The data spans multiple years, allowing for long-term trend analysis.
- **Geographical Coverage**: Sales data from Apple stores across various countries.

## Conclusion

By completing this project, I have developed advanced SQL querying skills, enhanced my ability to handle large datasets efficiently, and gained hands-on experience in solving complex data analysis problems that are critical for effective business decision-making. This project has strengthened my portfolio and clearly demonstrates my practical expertise in SQL to potential employers.

---
