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
    lpep_pickup_datetime DATETIME,
    lpep_dropoff_datetime DATETIME,
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
from taxitrips where trip_distance > 0; 

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
from taxitrips 
--where total_amount>0;

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


--6. Create a New Column for Trip Distance Band and Show Distribution

alter table taxitrips
add Trip_Distance_Band varchar(50);

-- Update Trip_Distance_Band based on the trip_distance and ntile calculations
WITH DistanceCTE AS (
    SELECT
        trip_distance,
        NTILE(3) OVER(ORDER BY trip_distance) AS ntile
    FROM taxitrips
)
UPDATE taxitrips
SET Trip_Distance_Band = CASE
    WHEN DistanceCTE.ntile = 3 THEN 'LONG DISTANCE'
    WHEN DistanceCTE.ntile = 2 THEN 'MEDIUM DISTANCE'
    ELSE 'SHORT DISTANCE'
END
FROM taxitrips
JOIN DistanceCTE ON taxitrips.trip_distance = DistanceCTE.trip_distance;


select * from taxitrips


-- 7) Find the Most Frequent Pickup Location (Mode) with rides fare greater than average of ride fare
select TOP(5) PULocationID, count(PULocationID) as count from taxitrips 
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

-- 11) Find Top 20 Most Frequent Rides Routes. 
select TOP(20) PULocationID, DOLocationID, count(*) as frequent_route
from taxitrips
group by PULocationID, DOLocationID
order by frequent_route DESC;

-- 12) Calculate the Average Fare of Completed Trips vs. Cancelled Trips
select top(1) (select avg(fare_amount) from taxitrips where trip_distance != 0) as cancelled_fare,
(select avg(fare_amount) from taxitrips where trip_distance = 0) as completed_fare
from taxitrips;

-- 13)  Rank the Pickup Locations  
--by Average Trip Distance and Average Total Amount
-- rank pu location based on the value of avg location and avg_total_amount
-- so we group based on pu location and the average of distance and amount 
-- for that group of pu locations and we rank p location based on the highest distance and total

select PULocationID,
avg(trip_distance) as avg_trip_distance,
avg(total_amount) as avg_total_amount,
rank() over(order by avg(trip_distance) desc,avg(total_amount) desc) as  combined_rank
from taxitrips
group by PULocationID
order by combined_rank

-- 14) Find the Relationship Between Trip Distance & Fare Amount
select trip_distance,avg(fare_amount) as avg_fare from taxitrips
where fare_amount > 0
group by trip_distance order by trip_distance;
--insight : fare amount increases with trip distance

-- 15) Identify Trips with Outlier Fare Amounts within Each Pickup Location
-- values should be greater than 
select PULocationID, fare_amount from
(select PULocationID, fare_amount,
	PERCENTILE_CONT(0.25)  WITHIN GROUP (ORDER BY fare_amount) OVER() as Q1,
	PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY fare_amount) OVER() as Q2,
	PERCENTILE_CONT(0.75)  WITHIN GROUP (ORDER BY fare_amount) OVER() as Q3,
	PERCENTILE_CONT(0.75)  WITHIN GROUP (ORDER BY fare_amount) OVER() -
	PERCENTILE_CONT(0.25)  WITHIN GROUP (ORDER BY fare_amount) OVER() as IQR
from taxitrips) Quartiles
where fare_amount < Q1 - 1.5*IQR or fare_amount > Q3 + 1.5*IQR



-- 16) Categorize Trips Based on Distance Travelled
select *,
case
	when tile=1 then 'low_distance'
	when tile=2 then 'medium distance'
	else'high distance'
end as distance_category
from
(select trip_distance,
ntile(3) over(order by trip_distance) as tile
from taxitrips) as mytb

--17) Top 5 Busiest Pickup Locations, Drop Locations with Fare less than median total fare 
with medianfare as (select PERCENTILE_CONT(0.5) within group (order by total_amount) over() 
as MedianPrice
from taxitrips)
select top(5) PULocationID, DOLocationID, total_amount 
from taxitrips where total_amount<(select max(MedianPrice) from medianfare) and total_amount>0 
order by total_amount desc;


--18.Distribution of Payment Types
select payment_type, count(*) as count_type,
ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM taxitrips)), 2) AS percentage
from taxitrips 
group by(payment_type);

--19.Trips with Congestion Surcharge Applied and Its Percentage Count.
select PULocationID, congestion_surcharge,
case
	when total_amount>0 then round((congestion_surcharge * 100.0 / total_amount),2)
	else 0
end as percentage_charge
from taxitrips where congestion_surcharge>0;

--20) Top 10 Longest Trip by Distance and Its summary about total amount.
select top(10) trip_distance,total_amount 
from taxitrips order by trip_distance desc;

--21)Trips with a Tip Greater than 20% of the Fare
SELECT RatecodeID,lpep_pickup_datetime,lpep_dropoff_datetime,
fare_amount,
tip_amount
FROM taxitrips
WHERE tip_amount > 0.2 * fare_amount;

--22) average trip duration based on rate code
select RatecodeID,
avg(DATEDIFF(MINUTE, lpep_pickup_datetime, lpep_dropoff_datetime)) AS difference_in_minutes
from taxitrips where DATEDIFF(MINUTE, lpep_pickup_datetime, lpep_dropoff_datetime) >0
and RatecodeID is not null
group by RatecodeID
order by RatecodeID

--23)Total Trips Per Hour Of the Day
SELECT 
    DATEPART(HOUR, lpep_pickup_datetime) AS hour_of_day,
    COUNT(*) AS total_trips
FROM taxitrips
GROUP BY DATEPART(HOUR, lpep_pickup_datetime)
ORDER BY hour_of_day;
