-- --------------------------------
-- ------------Complex-------------
-- --------------------------------

--Task 1: Determine the percentage chance of receiving warranty claims after each purchase for each country.
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

--Task 2: Analyze the year-by-year growth ratio for each store.
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

--Task 3: Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
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

--Task 4: Identify the store with the highest percentage of "Completed" claims relative to total claims filed.
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
	on tr.store_id = st.store_id

--Task 5: Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
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
from monthly_sales

--B.Q : Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
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








