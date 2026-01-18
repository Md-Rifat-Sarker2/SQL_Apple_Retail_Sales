-- ------------------------------------
-- ----Medium to Hard (5 Questions)----
-- ------------------------------------
--Task 1: Identify the least selling product in each country based on total units sold.
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

--Task 2: Calculate how many warranty claims were filed within 180 days of a product sale.
select 
	count (*) as w_within_180_days
from warranty as w
	left join sales as s
	on w.sale_id = s.sale_id
where (w.claim_date - s.sale_date) <= 180;

--Task 3: Determine how many warranty claims were filed for differnet products launched in the last two years.
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

--Task 4: List the months in the last three years where sales exceeded 5,000 units in the United States.
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

--Task 5: Identify the product category with product name and the most warranty claims filed in the last two years.
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













