create database inventory_project;
SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = ON;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

USE inventory_project;

CREATE TABLE IF NOT EXISTS historical_product_demand_staging (
    Product_Code VARCHAR(50),
    Warehouse VARCHAR(20),
    Product_Category VARCHAR(30),
    `Date` DATE,
    Order_Demand BIGINT
);



LOAD DATA LOCAL INFILE
'C:/Users/Hp/Desktop/Projects/Inventory optimision Analysis/Cleaned Inventory Project Datasset.csv'
INTO TABLE historical_product_demand_staging
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@product, @warehouse, @category, @date, @demand)
SET
    Product_Code = NULLIF(TRIM(@product), ''),
    Warehouse = NULLIF(TRIM(@warehouse), ''),
    Product_Category = NULLIF(TRIM(@category), ''),
    `Date` = STR_TO_DATE(NULLIF(TRIM(@date), ''), '%Y-%m-%d'),
    Order_Demand = NULLIF(TRIM(@demand), '');
    
    
select count(*) as total_rows from historical_product_demand_staging;
    
select * from historical_product_demand_staging limit 10;

describe historical_product_demand_staging;

select count(*) as Total_Rows,
count(distinct product_Code) as unique_products,
count(distinct product_Category) as unique_Category,
count(distinct Warehouse) as Warehouse,
sum("Date" is null) as Missing_dates,
sum("Order_Demand" is null) as missing_demand
from historical_product_demand_staging;

with top as (
select product_code,sum(order_demand) as demand
 from historical_product_demand_staging group by product_code
 order by sum(order_demand) desc limit 10)
 select *,
 dense_rank() over(order by demand desc) as "Rank"
 from top;
 
 
 
select warehouse,sum(order_demand)as Total_demand 
from historical_product_demand_staging group by warehouse
order by sum(order_demand) desc ;

select product_category,sum(order_demand) as Total_demand
from historical_product_demand_staging group by product_category
order by Total_demand desc limit 5;



select year(`Date`)as `Year`, month(`Date`) as `Month`,sum(order_demand)as Total_demand 
from historical_product_demand_staging group by `Year`,`month` order by `year`,`month` asc;



select year(`Date`) as `Year`, sum(order_demand) as Total_demand from historical_product_demand_staging
 group by `year` order by `year` asc;


with ye as(
select year(`Date`) as `Year`, sum(order_demand) as Current_Year_demand from historical_product_demand_staging
 group by `year`),
yee as(select *,
 lag(Current_Year_demand,1) over(order by `year` asc) as previous_Year_demand
 from ye)
 select*,
 (Current_Year_demand-previous_Year_demand) as difference 
 from yee  order by `year` asc ;
 
with ye as(
select year(`Date`) as `Year`, sum(order_demand) as Current_Year_demand 
from historical_product_demand_staging group by `year`),
yee as(select *,
 lag(Current_Year_demand,1) over(order by `year` asc) as previous_Year_demand
 from ye)
 select *,
 round((current_year_demand - previous_year_demand)/nullif(previous_year_demand,0)*100,2) as precentage_changes
 from yee;
 
 
 with ware as(
 select warehouse,sum(order_demand) as Demand from historical_product_demand_staging 
 group by warehouse )
 select *,
 dense_rank() over(order by demand desc) as 'Rank'
 from ware ;


with pdc as (
 select year(`date`) as `Year`,month(`date`) as `Month`, product_category,sum(order_demand) as Total_demand
 from historical_product_demand_staging group by `Year`,`Month`,product_category )
 select *,
 dense_rank() over(order by total_demand desc) as 'Rank'
 from pdc;



select Product_code,warehouse,sum(order_demand) as Total_demand
from historical_product_demand_staging group by product_code,warehouse order by Total_demand desc limit 10; 

-- Calculating demand variability by products

select product_code,
avg(order_demand) as Average_Demand,
min(order_demand) as Minimum_order_demand,
max(order_demand) as Maximum_order_demand
from historical_product_demand_staging group by product_code 
order by Maximum_order_demand desc;


with dmd as(
select product_code,
min(order_demand) as Minimum_order_demand,
max(order_demand) as Maximum_order_demand
from historical_product_demand_staging group by product_code 
order by Maximum_order_demand desc)
select *, max(Maximum_order_demand)-min(Minimum_order_demand) as demand_range
from dmd group by product_code ;

select product_code,stddev_pop(order_demand)as demand_stddev
from historical_product_demand_staging group by product_code;


with stdd as (
select product_code,stddev_pop(order_demand) as demand_stddev 
from historical_product_demand_staging group by product_code
order by demand_stddev desc limit 10) 
select *, dense_rank() over(order by demand_stddev desc) as demand_rank
from stdd;


with ware as
(select warehouse,min(order_demand) as Minimum_demand,
max(order_demand) as Maximum_demand from historical_product_demand_staging
group by warehouse)
select * , maximum_demand-minimum_demand as Demand_range
from ware ;


select product_category,avg(order_demand) as average_demand
from historical_product_demand_staging group by product_category ;


select warehouse, stddev_pop(order_demand) as demand_stddev
from historical_product_demand_staging group by warehouse;


select month(`date`) as `Month`, sum(order_demand) as Demand
from historical_product_demand_staging group by `Month` order by `Month`;


select product_code, avg(order_demand) as Average_demand
from historical_product_demand_staging group by product_code order by Average_demand desc limit 10;


with yde as(
select year(`Date`) as `Year` , sum(order_demand) as current_year_demand
from historical_product_demand_staging group by `year`),
lg as
(select *,
lag(current_year_demand,1) over(order by `year` asc) as previous_year_demand 
from yde)
select * , 
round((current_year_demand- previous_year_demand)/nullif(previous_year_demand,0) * 100 , 2) as Precentage_change
from lg ;



with pdc as(
select product_code,sum(order_demand) as product_demand from historical_product_demand_staging
group by product_code)
select * , round(product_demand/(select sum(order_demand) from historical_product_demand_staging) * 100,20) as pdp
from pdc;



select product_code, avg(order_demand) as Average_demand, sum(order_demand) as Total_demand 
from historical_product_demand_staging
group by product_code order by Average_demand asc limit 10;

select * from historical_product_demand_staging;