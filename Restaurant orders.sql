-- Identifying no.of different items present in the menu
Select count(distinct mi.menu_item_id) as count_items
from menu_items mi;

-- Differnt types of cuisine offered by the restaurant
select category,
count(category) as items_category,
max(price) as max_price,
min(price) as min_price,
round(avg(price),2) as avg_price
from menu_items 
group by 1;

-- The least expensive and most expensive item in the menu
-- Most expensive item
Select *
from menu_items
order by 4 desc
limit 1;
-- Lease expensive item
Select *
from menu_items
order by 4 asc limit 1;

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
select 
count(menu_item_id)
from menu_items 
where category = 'Italian';

-- Least expensive item in Italian cuisine
Select 
item_name,
price
from menu_items 
where category = 'Italian'
group by 1
order by 2 asc
limit 1 ;

-- Most expensive item in Italian cuisine
Select 
item_name,
price
from menu_items 
where category = 'Italian'
group by 1
order by 2 desc
limit 1 ;

-- Drilldown order_details
-- Total unique orders and number of unique items ordered
Select 
count(distinct od.order_id) as no_of_unique_orders,
count(item_id) as no_of_items_ordered
from order_details od
order by 2 desc;

-- Day to day orders and number of items sold
Select 
order_date,
count(distinct order_id) as no_of_unique_orders,
count(item_id) as no_of_items_ordered
from order_details
group by 1
order by 2 desc;

-- Orders with most no.of items sold
Select 
order_id,
count(item_id) no_of_items
from order_details
group by 1
order by 2 desc;

-- count of Order ids  which sold more than 12 items per order
Select 
count(distinct order_id) as orders_with_most_items
from order_details
where order_id in (Select 
					order_id
					from order_details
					group by 1
					having count(item_id) > 12);

-- Joining the tables order details with menu items
Select * from order_details od
left join menu_items mi on mi.menu_item_id = od.item_id;

-- Most selling item
Select  od.item_id,mi.item_name,mi.category,mi.price,count(od.item_id) as number_times_order_placed
from order_details od
left join menu_items mi on mi.menu_item_id = od.item_id
where item_id is not null
group by 1,2,3,4
order by 5 desc
limit 1;

-- Least selling item
with cte as (Select mi.item_name,
mi.category,
count(od.item_id) as number_times_order_placed
from order_details od
left join menu_items mi on mi.menu_item_id = od.item_id
where item_id is not null
group by 1,2
order by 3 ASC
limit 1
)
Select item_name, category from cte;

-- What were the top 5 orders that spent the most money?
Select order_id,sum(price) as total_purchase_value
from order_details od
left join menu_items mi on mi.menu_item_id = od.item_id
group by 1
order by 2 desc
limit 5;

-- View the details of the highest spend order. Which specific items were purchased?
with cte as (Select order_id,sum(price) as total_purchase_value
			from order_details od
			left join menu_items mi on mi.menu_item_id = od.item_id
			group by 1
			order by 2 desc
			limit 1),
main as (Select od.order_id,od.item_id,mi.item_name,mi.category,mi.price
		from order_details od
		left join menu_items mi on mi.menu_item_id = od.item_id)
Select 
main.item_name, count(main.item_name) as quantity_ordered
from main
join cte on cte.order_id = main.order_id
group by 1
;

--  View the details of the top 5 highest spend orders
with cte as (Select order_id,sum(price) as total_purchase_value
from order_details od
left join menu_items mi on mi.menu_item_id = od.item_id
group by 1
order by 2 desc
limit 5),
main as (Select od.order_id,od.item_id,mi.item_name,mi.category,mi.price
from order_details od
left join menu_items mi on mi.menu_item_id = od.item_id)
Select 
main.item_name, count(main.item_name) as quantity_ordered
from main
join cte on cte.order_id = main.order_id
group by 1
order by 2 desc
;
