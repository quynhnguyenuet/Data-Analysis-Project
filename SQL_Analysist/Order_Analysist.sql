--Order  analysis
--- Total Orders by year
select count([order_id]) as Total_order from [dbo].[orders]
-----
SELECT 
    DATEPART(YEAR, [order_purchase_timestamp]) AS year,
    COUNT([order_id]) AS total_order,
    (COUNT([order_id]) * 100.0) / (SELECT COUNT([order_id]) FROM [dbo].[orders]) AS percentage
FROM  
    [dbo].[orders]
GROUP BY 
    DATEPART(YEAR, [order_purchase_timestamp]) 
ORDER BY 
    COUNT([order_id]) DESC

--Change in orders in percentage over the years
WITH OrderCounts AS (
    SELECT 
        DATEPART(YEAR, [order_purchase_timestamp]) AS year,
        COUNT([order_id]) AS total_order
    FROM  
        [dbo].[orders]
    GROUP BY 
        DATEPART(YEAR, [order_purchase_timestamp])
)

SELECT 
    oc1.year,
    oc1.total_order,
    cast(100 * (oc1.total_order - COALESCE(oc2.total_order, 0)) / NULLIF(oc2.total_order, 0) as float) AS percent_change
FROM 
    OrderCounts oc1
LEFT JOIN 
    OrderCounts oc2 ON oc1.year = oc2.year + 1
ORDER BY 
    oc1.year;
----
SELECT AVG(total_orders) AS average_orders_per_day
FROM (
    SELECT COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY DATENAME(WEEKDAY, [order_purchase_timestamp])
) AS subquery;



---Total number of orders by time group and by time of day
select 
      DATEPART(HOUR,[order_purchase_timestamp]) as hour_of_day,
	  count([order_id]) as total_order
from  [dbo].[orders]
group by DATEPART(HOUR,[order_purchase_timestamp]) 
order by count([order_id]) desc
--
SELECT 
    FORMAT(order_purchase_timestamp, 'tt') AS Moment
FROM 
    [orders];
--
select count(order_id) as total_order,
       TimeGroup
 from(    
SELECT 
    CASE 
        WHEN DATEPART(HOUR,[order_purchase_timestamp]) < 3 THEN '12:00 AM - 2:59 AM'
        WHEN DATEPART(HOUR, [order_purchase_timestamp]) < 6 THEN '3:00 AM - 5:59 AM'
        WHEN DATEPART(HOUR, [order_purchase_timestamp]) < 9 THEN '6:00 AM - 8:59 AM'
        WHEN DATEPART(HOUR,[order_purchase_timestamp]) < 12 THEN '9:00 AM - 11:59 AM'
        WHEN DATEPART(HOUR, [order_purchase_timestamp]) < 15 THEN '12:00 PM - 2:59 PM'
        WHEN DATEPART(HOUR, [order_purchase_timestamp]) < 18 THEN '3:00 PM - 5:59 PM'
        WHEN DATEPART(HOUR, [order_purchase_timestamp]) < 21 THEN '6:00 PM - 8:59 PM'
        ELSE '9:00 PM - 11:59 PM'
    END AS TimeGroup,
	[order_id]
FROM 
    [orders]) as subquery
group by TimeGroup
Order by total_order desc

---Total number of orders by day of the week
SELECT 
    DATENAME(WEEKDAY, [order_purchase_timestamp]) AS day_of_week,
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    DATENAME(WEEKDAY, [order_purchase_timestamp])
ORDER BY 
    CASE
        WHEN DATENAME(WEEKDAY, [order_purchase_timestamp]) = 'Sunday' THEN 1
        WHEN DATENAME(WEEKDAY, [order_purchase_timestamp]) = 'Monday' THEN 2
        WHEN DATENAME(WEEKDAY, [order_purchase_timestamp]) = 'Tuesday' THEN 3
        WHEN DATENAME(WEEKDAY, [order_purchase_timestamp]) = 'Wednesday' THEN 4
        WHEN DATENAME(WEEKDAY, [order_purchase_timestamp]) = 'Thursday' THEN 5
        WHEN DATENAME(WEEKDAY, [order_purchase_timestamp])= 'Friday' THEN 6
        ELSE 7
    END;

----Month
SELECT 
    DATEPART(MONTH,[order_purchase_timestamp] ) AS Month,
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    DATEPART(MONTH, [order_purchase_timestamp])
Order by  DATEPART(MONTH,[order_purchase_timestamp] ) asc

--- Avg. Time_delivery, Avg. Approved_time
select  AVG(DATEDIFF(HOUR,[order_purchase_timestamp],[order_approved_at])) from  [dbo].[orders]
select  AVG(DATEDIFF(DAY, [order_delivered_carrier_date], [order_delivered_customer_date])) from [dbo].[orders]

---Number of orders delivered compared to expected
SELECT count(order_id) as total_order,
    COUNT(CASE WHEN [order_delivered_customer_date] > [order_estimated_delivery_date] THEN [order_id] END) AS late_deliveries,
	 CAST(100*COUNT(CASE WHEN [order_delivered_customer_date] > [order_estimated_delivery_date] THEN [order_id] END) as decimal(10,2))/CAST(count(order_id) as decimal(10,2)) as pct_order_late,
    COUNT(CASE WHEN [order_delivered_customer_date] < [order_estimated_delivery_date] THEN [order_id] END) AS early_deliveries,
	 CAST(100*COUNT(CASE WHEN [order_delivered_customer_date] < [order_estimated_delivery_date] THEN [order_id] END) as decimal(10,2))/CAST(count(order_id) as decimal(10,2)) as pct_order_early,
    COUNT(CASE WHEN [order_delivered_customer_date] = [order_estimated_delivery_date] THEN [order_id] END) AS on_time_deliveries
FROM 
    [dbo].[orders]

---order_status
select count([order_id]) as count_order,
       [order_status] 
from [dbo].[orders]
group by [order_status]