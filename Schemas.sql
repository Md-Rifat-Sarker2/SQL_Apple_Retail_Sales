-- -------------------------------------------
-- Apple Retails Millions Rows Sales Schemas
-- -------------------------------------------

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



