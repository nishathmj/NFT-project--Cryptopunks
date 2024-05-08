USE  cryptopunk;
SELECT * FROM pricedata LIMIT 10;
SELECT * from pricedata order by event_date asc;




/*1 How many sales occurred during this time period */
SELECT COUNT(*) AS total_sales_during_this_period FROM pricedata;




/*2 Return the top 5 most expensive transactions (by USD price) for this data set.
 Return the name, ETH price, and USD price, as well as the date.*/
 SELECT name, eth_price, event_date, usd_price 
 FROM pricedata ORDER BY usd_price DESC LIMIT 5;
 

 
 /*3 Return a table with a row for each transaction with an event column, a USD price column, and 
 a moving average of USD price that averages the last 50 transactions.*/
 SELECT event_date, usd_price, 
 AVG(usd_price) OVER(ORDER BY event_date DESC ROWS BETWEEN 50 preceding AND CURRENT ROW) AS moving_avg
 FROM pricedata; 
 
 
 
 /*4 Return all the NFT names and their average sale price in USD.
 Sort descending. Name the average column as average_price.*/
 SELECT name, AVG(usd_price) AS avgerage_price 
 FROM pricedata 
 GROUP BY name 
 HAVING avgerage_price 
 ORDER BY avgerage_price DESC; 
 
 
 
 
 
 /*5 Return each day of the week and the number of sales that occurred on that day of the week, 
 as well as the average price in ETH. Order by the count of transactions in ascending order.*/
 SELECT dayofweek(event_date) AS day_of_week, 
 COUNT(*) AS number_of_sales,
 AVG(eth_price) AS avg_eth_price
 FROM pricedata 
 GROUP BY day_of_week 
 HAVING avg_eth_price
 ORDER BY number_of_sales;
 
 
 
 
 /*6 Construct a column that describes each sale and is called summary. 
 The sentence should include who sold the NFT name, who bought the NFT, who sold the NFT, the date, and 
 what price it was sold for in USD rounded to the nearest thousandth.
 Here’s an example summary:
 “CryptoPunk #1139 was sold for $194000 to 0x91338ccfb8c0adb7756034a82008531d7713009d from 0x1593110441ab4c5f2c133f21b0743b2b43e297cb on 2022-01-14”*/
SELECT CONCAT(name, "  was sold for $", ROUND(usd_price,-1)," to ",buyer_address," from ",seller_address, " on ",event_date) AS summary
FROM pricedata




/*7 Create a view called “1919_purchases” and contains any sales where “0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685” was the buyer.*/
CREATE VIEW 1919_purchases AS
SELECT * FROM pricedata WHERE buyer_address="0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"


/*8 Create a histogram of ETH price ranges. Round to the nearest hundred value.*/
SELECT ROUND(eth_price,-2) AS bucket, 
COUNT(*) AS count,
RPAD('',COUNT(*), '*') AS bar
FROM pricedata
GROUP BY bucket
ORDER BY bucket;

