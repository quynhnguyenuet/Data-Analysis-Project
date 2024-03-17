Create view 
alter view join_table as 
select o.[order_id],
       p.product_id,
	   s.seller_id,
       [price],
       [freight_value],
       [order_purchase_timestamp] as order_date,
       [seller_city],
       [seller_state],
	   c.customer_id,
       [customer_city],
	   [customer_state],
       [product_category_name_english]
from [dbo].[orders] o left join [dbo].[order_item] oi on o.order_id = oi.order_id
left join [dbo].[product] p on oi.product_id = p.product_id
left join [dbo].[product_catagory] pc on p.product_category_name = pc.product_category_name
left join [dbo].[customer] c on o.customer_id = c.customer_id 
left join [dbo].[seller] s on oi.seller_id = s.seller_id

----Top products with the most orders
select top 5 [product_category_name_english],
	   count(order_id) as total_order
from join_table
group by [product_category_name_english]
order by total_order desc
---Top products that bring high revenue
select top 5 [product_category_name_english],
       sum(price) as total_revenue
from join_table
group by [product_category_name_english]
order by total_revenue desc

--Sort products by category
CREATE TABLE #product_sort (
    -- Define columns here
    order_id NVARCHAR(50),
    product_category_name_english NVARCHAR(50),
    product_group NVARCHAR(50)
);
INSERT INTO #product_sort(order_id,product_category_name_english,product_group)
SELECT order_id,
	  [product_category_name_english],
    CASE
		       WHEN [product_category_name_english] LIKE '%food%' OR [product_category_name_english] LIKE '%drink%' OR [product_category_name_english] LIKE '%cuisine%' THEN 'Food, Drink and Cuisine'
				WHEN [product_category_name_english] LIKE '%appliances%' OR [product_category_name_english] LIKE'%house%' OR [product_category_name_english] LIKE '%home%' OR [product_category_name_english] LIKE '%bed%' OR[product_category_name_english] LIKE '%furniture%' OR [product_category_name_english] LIKE '%flower%'  THEN 'Home Appliances and Decor'
				WHEN [product_category_name_english] LIKE '%fashion%' OR [product_category_name_english] LIKE '%cloth%' THEN 'Fashion'
				WHEN [product_category_name_english] LIKE '%sport%' OR [product_category_name_english] LIKE '%game%' THEN 'Sport and Game'
				WHEN [product_category_name_english] LIKE '%construction%' OR [product_category_name_english] LIKE '%tool%' THEN 'Construction and Repair Tools'
				WHEN [product_category_name_english] LIKE '%music%' OR [product_category_name_english] LIKE '%book%' THEN 'Books and Music'
				WHEN [product_category_name_english] LIKE '%pet%' THEN 'Pet Supplies'
				WHEN [product_category_name_english] LIKE '%art%' then 'Arts and Crafts'
				WHEN [product_category_name_english] LIKE '%supplie%' Then 'Party supply'
				WHEN [product_category_name_english] LIKE '%audio%' OR [product_category_name_english] LIKE '%photo%' OR [product_category_name_english] LIKE '%dvd%' then 'Sound and Image'
				WHEN [product_category_name_english] LIKE '%security%' then 'Security and Services'
				WHEN [product_category_name_english] LIKE '%toy%' OR [product_category_name_english] LIKE '%baby%' OR [product_category_name_english] LIKE '%diaper%'THEN 'Babies and Newborns'
                
			     WHEN [product_category_name_english] IN ('electronics', 'computers_accessories', 'tablets_printing_image', 'telephony', 'fixed_telephony','air_conditioning','computers') THEN 'Electronics'
                 WHEN [product_category_name_english] IN ('health_beauty','perfumery') THEN 'Health and Beauty'
				 WHEN [product_category_name_english] like '%auto%' then  'car'
				 WHEN  [product_category_name_english] IN ('stationery','watches_gifts','luggage_accessories') THEN 'Stationery, gifts and accessories'
        ELSE 'Other'
    END AS product_group
FROM join_table
---Product group has high orders and revenue
select top 5 count(distinct o.[order_id]) as total_order,
       --sum([price]) as total_revenue,
       product_group
from #product_sort ps
 join join_table
 o on o.order_id = ps.order_id
group by product_group
order by  total_order desc
----Overview of the distribution of retailers
select count([seller_id]) as count_seller,
       [seller_city],
      [seller_state]
from join_table
group by  [seller_city],[seller_state]
order by  count_seller desc
--- Top areas with high revenue
SELECT TOP 5
    [seller_state],
    SUM(price) AS total_revenue,
    100.0 * SUM(price) / (SELECT SUM(price) FROM join_table) AS pct_revenue
FROM
    join_table
GROUP BY
    [seller_state]
ORDER BY
    total_revenue DESC;
---
SELECT TOP 5
    [seller_state],
    count(distinct order_id) AS total_order,
    100.0 *  count(distinct order_id) / (select count(distinct order_id) FROM join_table) AS pct_order
FROM
    join_table
GROUP BY
    [seller_state]
ORDER BY
    total_order DESC;
---Select cities in each region that bring in high revenue
DECLARE @seller_state VARCHAR(255);
DECLARE @total_revenue DECIMAL(18, 2);
DECLARE @city_cursor CURSOR;
SET @city_cursor = CURSOR FOR
SELECT [seller_state], [total_revenue]
from( 
SELECT TOP 5
    [seller_state],
    SUM(price) AS total_revenue,
    100.0 * SUM(price) / (SELECT SUM(price) FROM join_table) AS pct_revenue
FROM
    join_table
GROUP BY
    [seller_state]
ORDER BY
    total_revenue DESC
	) as subquery
OPEN @city_cursor;
    FETCH NEXT FROM @city_cursor INTO @seller_state, @total_revenue;
    
 WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get the top 3 cities with the highest revenue for each state
        SELECT TOP 3
		    [seller_state],
            [seller_city],
            SUM(price) AS total_revenue,
            100.0 * SUM(price) / (select sum(price) from join_table) as pct_revenue
        FROM
            join_table
        WHERE
            [seller_state] = @seller_state
        GROUP BY
            [seller_city],[seller_state]
        ORDER BY
            total_revenue DESC;

        FETCH NEXT FROM @city_cursor INTO @seller_state, @total_revenue;
    END;
------Select cities in each region that have high orders

DECLARE @seller_state VARCHAR(255);
DECLARE @total_order DECIMAL(18, 2);
DECLARE @city_cursor CURSOR;
SET @city_cursor = CURSOR FOR
SELECT [seller_state], [total_order]
from( 
SELECT TOP 5
    [seller_state],
    count(distinct order_id) AS total_order,
    100.0 * count(distinct order_id) / (SELECT count(distinct order_id) FROM join_table) AS pct_order
FROM
    join_table
GROUP BY
    [seller_state]
ORDER BY
    total_order DESC
	) as subquery
OPEN @city_cursor;
    FETCH NEXT FROM @city_cursor INTO @seller_state, @total_order;
    
 WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Lấy top 3 thành phố có doanh thu cao nhất cho mỗi state
        SELECT TOP 3
		    [seller_state],
            [seller_city],
            count(distinct order_id) AS total_order,
    100.0 * count(distinct order_id) / (SELECT count(distinct order_id) FROM join_table) AS pct_order
        FROM
            join_table
        WHERE
            [seller_state] = @seller_state
        GROUP BY
            [seller_city],[seller_state]
        ORDER BY
            total_order DESC;

        FETCH NEXT FROM @city_cursor INTO @seller_state, @total_order;
    END;
----revenue by year
SELECT 
    DATEPART(YEAR, order_date) AS year,
    sum(price) as total_revenue,
	100*sum(price)/ (select sum(price) from join_table) as pct_revenue
FROM  
    join_table
GROUP BY 
    DATEPART(YEAR, order_date) 
ORDER BY 
   year
---revenue by month, avg revenue

SELECT AVG(Total_Revenue) AS AverageRevenue
FROM (
    SELECT 
        MONTH(order_date) AS month,
        SUM(price) AS Total_Revenue
    FROM  
        Join_table
    GROUP BY 
        MONTH(order_date)
) AS subquery;

---
SELECT 
    DATEPART(Month, order_date) AS month,
    sum(price) as total_revenue,
	100*sum(price)/ (select sum(price) from join_table) as pct_revenue
FROM  
    join_table
GROUP BY 
    DATEPART(Month, order_date) 
ORDER BY 
   month