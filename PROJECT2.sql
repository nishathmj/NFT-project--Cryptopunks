USE  cryptopunk;
SELECT * from pricedata;

/*9 Return a unioned query that contains the highest price each NFT was bought for and
 a new column called status saying “highest” with a query that has the lowest price each NFT was bought for and 
 the status column saying “lowest”. The table should have a name column, a price column called price, and a status column. 
 Order the result set by the name of the NFT, and the status, in ascending order.*/
 CREATE TEMPORARY TABLE temp1 as (select  name, MAX(usd_price) OVER(PARTITION BY name) AS max_price from pricedata);
 CREATE TEMPORARY TABLE highest_price
 select pricedata.name, usd_price, max_price, 
 CASE
  WHEN usd_price >= max_price then "highest" END AS status_of_price
 from pricedata JOIN temp1 ON pricedata.name = temp1.name;
 
 CREATE TEMPORARY TABLE  temp2 as (select  name, MIN(usd_price) OVER(PARTITION BY name) AS min_price from pricedata);
 CREATE TEMPORARY TABLE lowest_price select pricedata.name, usd_price, min_price, 
 CASE
  WHEN usd_price <= min_price then "lowest" END AS status_of_price
 from pricedata JOIN temp2 ON pricedata.name = temp2.name;
 
 select name, usd_price as price, status_of_price as status from highest_price where status_of_price="highest" 
 UNION
 select name, usd_price as price, status_of_price as status from lowest_price where status_of_price="lowest" order by name;
 
 
 
 
 
/*10 What NFT sold the most each month / year combination? Also, what was the name and the price in USD? Order in chronological format.*/
 CREATE TEMPORARY TABLE table1 AS (SELECT COUNT(name) AS max_nft, name, DATE_FORMAT(event_date, '%y-%m') AS month_of_the_year, 
 AVG(usd_price) as avg_usd from pricedata 
group by name, month_of_the_year);

 CREATE TEMPORARY TABLE table2 AS (SELECT name, max_nft, avg_usd,  month_of_the_year, 
 row_number() OVER (PARTITION BY month_of_the_year order by max_nft, avg_usd desc) AS ral 
from  table1 ORDER BY month_of_the_year)

 CREATE TEMPORARY TABLE nft_sold_most_per_month AS (select month_of_the_year, name, max_nft, avg_usd, 
 MAX(max_nft) OVER(PARTITION BY month_of_the_year ORDER BY avg_usd desc) AS max_overall_per_month,
 MAX(avg_usd) OVER(PARTITION BY month_of_the_year ORDER BY avg_usd desc) AS max_avg_overall_per_month
 from table2)

select month_of_the_year, name, max_overall_per_month AS  max_nft_sold_per_month, max_avg_overall_per_month as max_avg_usd_per_month
from nft_sold_most_per_month where max_nft>=max_overall_per_month AND avg_usd>=max_avg_overall_per_month ORDER BY month_of_the_year DESC;




/*11 Return the total volume (sum of all sales), round to the nearest hundred on a monthly basis (month/year).*/
SELECT  ROUND(SUM(usd_price),-2) AS sum_of_all_sales, DATE_FORMAT(event_date, '%y-%m') AS month_of_the_year 
from pricedata
Group by month_of_the_year 
HAVING SUM(usd_price);





/*12 Count how many transactions the wallet "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"had over this time period.*/
SELECT COUNT(*) FROM pricedata where transaction_hash="0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685" 





/*13 Create an “estimated average value calculator” that has a representative price of the collection every day based off of these criteria:
 - Exclude all daily outlier sales where the purchase price is below 10% of the daily average price
 - Take the daily average of remaining transactions
 a) First create a query that will be used as a subquery. Select the event date, the USD price,
 and the average USD price for each day using a window function. Save it as a temporary table.
 b) Use the table you created in Part A to filter out rows where the USD prices is below 10% of the daily average and 
 return a new estimated value which is just the daily average of the filtered date*/
 
 /*a*/
CREATE TEMPORARY TABLE avg_usd_price_each_day AS
(SELECT event_date, usd_price, AVG(usd_price) OVER( PARTITION BY DATE_FORMAT(event_date, '%y-%m-%d')) AS avg_usd_price_per_day 
from pricedata);

/*b*/
 SELECT event_date, usd_price AS "usd_price_above_10%_of_avg_per_day", avg_usd_price_per_day  FROM avg_usd_price_each_day 
 WHERE usd_price>= (avg_usd_price_per_day*0.1);











