DECLARE @Databasename NVARCHAR(128) = 'taxitripsdb';

-- Test condition to check if database exists
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = @Databasename)
BEGIN
	DECLARE @sql NVARCHAR(MAX)='CREATE DATABASE '+QUOTENAME(@Databasename);
    EXEC sp_executesql @sql;
END

USE taxitripsdb;

CREATE TABLE taxitrips (
    VendorID INT,
    lpep_pickup_datetime VARCHAR(50),
    lpep_dropoff_datetime VARCHAR(50),
    store_and_fwd_flag VARCHAR(5),
    RatecodeID INT,
    PULocationID INT,
    DOLocationID INT,
    passenger_count INT,
    trip_distance FLOAT,
    fare_amount FLOAT,
    extra FLOAT,
    mta_tax FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    ehail_fee FLOAT NULL, -- This can be NULL as some entries have empty values
    improvement_surcharge FLOAT,
    total_amount FLOAT,
    payment_type INT,
    trip_type INT,
    congestion_surcharge FLOAT
);

BULK INSERT taxitrips FROM 'D:/2021_Green_Taxi_Trip_Data.csv'
WITH
(
	FIELDTERMINATOR = ',', -- '|'	';'	'\t'	' '
	ROWTERMINATOR = '0x0A', -- \r\n - Carriage and New Line Return,
	FIRSTROW = 2          -- skip the header from records
);

select * from taxitrips;


-- 1) Shape of the Table (Number of Rows and Columns)
select count(*) as row_num, (select count(*) from INFORMATION_SCHEMA.COLUMNS) as col_num from taxitrips;

-- 2) Show Summary of Green Taxi Rides – Total Rides, Total Customers, Total Sales
select ROUND(sum(total_amount), 2) as Total_Sales, 
sum(passenger_count) as Total_Passenger, 
count(*) as Total_Rides 
from taxitrips where total_amount > 0 and passenger_count > 1; 

-- 3) Total Rides with Surcharge and its percentage. 
select VendorID, lpep_pickup_datetime, total_amount, 
(congestion_surcharge + improvement_surcharge) as total_surcharge,
round(((congestion_surcharge + improvement_surcharge) / total_amount) * 100, 2) as surcharge_percent
from taxitrips where total_amount > 0;

-- 4) Cumulative Sum of Total Fare Amount for Each Pickup Location
select PULocationID, total_amount,
SUM(total_amount) OVER(PARTITION BY PULocationID 
ORDER BY PULocationID, total_amount asc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
as cumulative_total_amount
from taxitrips where total_amount>0;

-- 5) Which Payment Type is Most Common in Each Drop-off Location
select DOLocationID, max(payment_count) as Payment_Count from
(select DOLocationID, payment_type, count(*) as payment_count
from taxitrips
where payment_type is not NULL
group by DOLocationID, payment_type) as do_count
group by DOLocationID
order by DOLocationID


-- 6) Create a New Column for Trip Distance Band and Show Distribution
select trip_distance, count(*) as count_dist from taxitrips where trip_distance > 0 
group by trip_distance
order by trip_distance, count_dist desc;

-- 7) Find the Most Frequent Pickup Location (Mode) with rides fare greater than average of ride fare
select TOP(1) PULocationID, count(PULocationID) as count from taxitrips 
where fare_amount > (select avg(fare_amount) from taxitrips)
group by PULocationID
order by count DESC

-- 8) Show the Rate Code with the Highest Percentage of Usage
select RatecodeID, count(*)/(select count(*) from taxitrips) as rate_count from taxitrips
where RatecodeID is not NULL
group by RatecodeID
order by rate_count DESC;

select * from(
select *,
PERCENT_RANK() OVER(ORDER BY rate_count) as percent_rank
from
(
select RatecodeID, count(*) as rate_count from taxitrips
where RatecodeID is not NULL
group by RatecodeID
) as main) Rate_Usage
where percent_rank = 1



-- 9) Show Distribution of Tips, Find the Maximum Chances of Getting a Tip
select
	trip_type, count(tip_amount) as tipcount
from taxitrips where trip_type is not null
group by trip_type
order by trip_type;

-- 10) Calculate the Rank of Trips Based on Fare Amount within Each Pickup Location
select PULocationID, fare_amount,
DENSE_RANK() OVER(PARTITION BY PULocationID ORDER BY fare_amount) as fare_rank
from taxitrips
where fare_amount > 0;

-- 11) Find Top 20 Most Frequent Rides Routes. 
select TOP(20) PULocationID, DOLocationID, count(*) as frequent_route
from taxitrips
group by PULocationID, DOLocationID
order by frequent_route DESC;

-- 12) Calculate the Average Fare of Completed Trips vs. Cancelled Trips
select top(1) (select avg(fare_amount) from taxitrips where trip_distance != 0) as cancelled_fare,
(select avg(fare_amount) from taxitrips where trip_distance = 0) as completed_fare
from taxitrips;


-- 14) Find the Relationship Between Trip Distance & Fare Amount
select trip_distance, fare_amount from taxitrips
where trip_distance > 0 and fare_amount > 0
group by trip_distance, fare_amount
order by trip_distance, fare_amount