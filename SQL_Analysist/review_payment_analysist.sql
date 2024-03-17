alter VIEW order_review_payment
AS
SELECT 
    r.[review_id],
    o.[order_id],
    o.[order_delivered_customer_date],
    o.[order_estimated_delivery_date],
    r.[review_score],
    r.[review_creation_date],
    r.[review_answer_timestamp],
    op.[payment_type],
    op.[payment_installments],
    op.[payment_value]
FROM 
    [dbo].[orders] o
LEFT JOIN 
    [dbo].[order_reviews] r ON o.[order_id] = r.[order_id]
LEFT JOIN 
    [dbo].[order_payment] op ON o.[order_id] = op.[order_id];
select * from order_review_payment
select count(distinct review_id) from order_review_payment

---Analyze customer satisfaction levels
select 
	   AVG([review_score]) as average_review_score
from order_review_payment
--Satisfaction rate
SELECT
    count([review_id]) as total_review,
    COUNT(review_id) * 100.0 / (SELECT COUNT(*) FROM order_reviews) AS percentage,
    review_score
FROM
    order_review_payment
GROUP BY
    review_score
order by  COUNT(review_id) * 100.0 / (SELECT COUNT(*) FROM order_reviews) desc
--Delivery date affects customer satisfaction
SELECT AVG(DATEDIFF(HOUR, review_creation_date, review_answer_timestamp)) AS average_response_time
FROM order_review_payment
---
SELECT 
    delivery_status,
    [1] AS review_score_1,
    [2] AS review_score_2,
    [3] AS review_score_3,
    [4] AS review_score_4,
    [5] AS review_score_5
FROM 
(
    SELECT 
        CASE 
            WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late Delivery'
            ELSE 'Early Delivery'
        END AS delivery_status,
        COUNT(DISTINCT review_id) AS total_review,
        review_score
    FROM 
	   order_review_payment
    GROUP BY
        CASE 
            WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late Delivery'
            ELSE 'Early Delivery'
        END,
        review_score
) AS SourceTable
PIVOT
(
    SUM(total_review)
    FOR review_score IN ([1], [2], [3], [4], [5])
) AS PivotTable
ORDER BY 
    delivery_status;

----Total orders according to reviews
     
select count(distinct [order_id] ) as total_order,
      count(distinct(review_id)) as total_review,
	  100*cast(count(distinct review_id ) as decimal(10,2))/cast(count(distinct [order_id] ) as decimal(10,2)) as pct_review_order
from order_review_payment

--Payment Method Analysis
select top 5 * from [dbo].[order_payment]
select 
       count(distinct o.[order_id]) as total_order,
	   [payment_type]
from [dbo].[order_payment] op right join [dbo].[orders] o on op.[order_id] = o.[order_id]
WHERE [payment_type] is not null
group by [payment_type]
order by total_order desc
----
WITH OrdersWithInstallments AS (
    SELECT 
        COUNT(distinct order_id) AS total_order,
        SUM(CASE WHEN payment_installments > 1 THEN 1 ELSE 0 END) AS with_installments,
        SUM(CASE WHEN payment_installments <= 1 THEN 1 ELSE 0 END) AS without_installments
    FROM
     order_review_payment

),
InstallmentGroups AS (
    SELECT
        CASE 
            WHEN payment_installments >= 2 AND payment_installments <= 5 THEN '2-5'
            WHEN payment_installments >= 6 AND payment_installments <= 9 THEN '6-9'
            ELSE 'Others'
        END AS installment_group,
        payment_installments
   from order_review_payment
)
SELECT
    ig.installment_group,
    SUM(CASE WHEN ig.payment_installments > 1 THEN 1 ELSE 0 END) AS with_installments,
    (SUM(CASE WHEN ig.payment_installments > 1 THEN 1 ELSE 0 END) * 100.0) / owi.total_order AS percentage
FROM
    InstallmentGroups ig
LEFT JOIN
    OrdersWithInstallments owi ON 1 = 1
GROUP BY
    ig.installment_group, owi.total_order
ORDER BY
    ig.installment_group;
---Analyze the Number of Payment Periods
select count(distinct[order_id]) as total_order,
       [payment_type]
from order_review_payment
group by
		[payment_type]
order by total_order desc
---Payment Value Analysis
select avg([payment_value]) as avg_value,
        [payment_type]
from order_review_payment
group by [payment_type]
order by avg_value desc

----