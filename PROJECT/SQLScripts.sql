
select * from RetailStoreDB.dbo.fact_sales_normalized$;
select * from RetailStoreDB.dbo.dim_customers$;
select * from RetailStoreDB.dbo.dim_dates$;
select * from RetailStoreDB.dbo.dim_products$;
select * from RetailStoreDB.dbo.dim_stores$;


--------Converting to a normal date format
ALTER TABLE RetailStoreDB.dbo.fact_sales_normalized$ ADD Clean_Order_Date DATE;

UPDATE RetailStoreDB.dbo.fact_sales_normalized$
SET Clean_Order_Date = CONVERT(DATE, sales_date, 103); -- Use 103 for DD/MM/YYYY

ALTER TABLE RetailStoreDB.dbo.fact_sales_normalized$ DROP COLUMN sales_date;


---Finding customers who are online shoppers and spend above 1000 dollars
select c.[Full name], c.residential_location, c.customer_segment,f.total_amount as total_amount_spent from RetailStoreDB.dbo.dim_customers$ c
INNER JOIN RetailStoreDB.dbo.fact_sales_normalized$ f 
ON c.customer_sk = f.customer_sk
WHERE customer_segment = 'Online Shopper' and total_amount>1000;

------Finding products in the electronics category bought by customers using multiple joins across tables


SELECT 
    p.product_name,
    p.Category,
    s.store_name,
    f.total_amount
FROM RetailStoreDB.dbo.fact_sales_normalized$ AS f                          
INNER JOIN RetailStoreDB.dbo.dim_products$ AS p                   -- Join 1st Dimension
    ON f.product_sk = p.product_sk
INNER JOIN RetailStoreDB.dbo.dim_stores$ AS s                     -- Join 2nd Dimension
    ON f.store_sk = s.store_sk
WHERE p.Category = 'Electronics';               -- Filtering the result

----Products bought from Puma

select COUNT(product_name) from RetailStoreDB.dbo.dim_products$
where brand = 'Puma' 
GROUP BY category;
   


--------Found the max amount and avg amount spent by customers who were premium/luxury shoppers
select c.[Full name], MAX(f.total_amount) as [Maximum amount spent], AVG(f.total_amount) as [Average amount spent], c.customer_segment,c.residential_location from RetailStoreDB.dbo.fact_sales_normalized$ f
INNER JOIN RetailStoreDB.dbo.dim_customers$ AS c                   
    ON f.customer_sk = c.customer_sk
	WHERE customer_segment='Premium Shopper'
	GROUP BY c.[Full name], c.customer_segment, c.residential_location;


