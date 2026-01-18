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







