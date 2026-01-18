-- ----------------------------------------------
-- ---------Easy to Medium (10 Questions)--------
-- ----------------------------------------------

--Task 1: Find the number of stores in each country.
select 
	country,
	count (*) as total_store
from stores
group by 1
order by 2 desc;

--Task 2: Calculate the total number of units sold by each store.
select 
	st.store_id,
	st.store_name,
	sum(sl.quantity) as total_units
from sales as sl
	join stores as st
	on sl.store_id = st.store_id
group by 1,2
order by 3;

--Task 3: Identify how many sales occurred in December 2023.
select 
	count(*) as total_sale_dec
from sales
where to_char(sale_date,'MM-YYYY') = '12-2023';

--Task 4: Determine how many stores have never had a warranty claim filed.
select 
	count(*)
from stores
where store_id not in (
						select 
							distinct s.store_id
						from sales as s
							right join warranty as w
							on w.sale_id = s.sale_id);
							
--Task 5: Calculate the percentage of warranty claims marked as "Rejected".
select 
	round(
	count(*)/(select count(*) from warranty)::numeric * 100,2
	) as rejected_percentages
from warranty
where repair_status = 'Rejected';

--Task 6: Identify which store had the highest total units sold in the last two year.
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

--Task 7: Count the number of unique products sold in the last two year.
select 
	count(distinct product_id) as unique_product
from sales
where sale_date >= current_date - interval '2 year';

--Task 8: Find the average price of products in each category.
select
	c.category_name,
	round(avg(p.price)::numeric,0) as avg_price
from products as p
	join category as c
	on c.category_id = p.category_id
group by 1
order by 2 desc;

--Task 9: How many warranty claims were 'Completed' filed in 2024?
select 
	count(*) as total_competed_claim
from warranty
	where repair_status = 'Completed'
		and
		to_char(claim_date,'YYYY') = '2024'
		 --extract(year from claim_date) = 2024;

--Task 10: For each store, identify the best-selling day based on highest quantity sold.
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







