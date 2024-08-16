DECLARE @Databasename NVARCHAR(128) = 'warehousedb';

-- Test condition to check if database exists
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = @Databasename)
BEGIN
	DECLARE @sql NVARCHAR(MAX)='CREATE DATABASE '+QUOTENAME(@Databasename);
    EXEC sp_executesql @sql;
END

USE warehousedb;

DROP TABLE [dbo].fmcg;

CREATE TABLE [dbo].fmcg (
    Ware_house_ID VARCHAR(20),
    WH_Manager_ID VARCHAR(20),
    Location_type VARCHAR(20),
    WH_capacity_size VARCHAR(20),
    zone VARCHAR(20),
    WH_regional_zone VARCHAR(20),
    num_refill_req_l3m INT,
    transport_issue_l1y INT,
    Competitor_in_mkt INT,
    retail_shop_num INT,
    wh_owner_type VARCHAR(20),
    distributor_num INT,
    flood_impacted INT,
    flood_proof INT,
    electric_supply INT,
    dist_from_hub INT,
    workers_num INT,
    wh_est_year INT,
    storage_issue_reported_l3m INT,
    temp_reg_mach INT,
    approved_wh_govt_certificate VARCHAR(20),
    wh_breakdown_l3m INT,
    govt_check_l3m INT,
    product_wg_ton INT
);

BULK INSERT fmcg FROM 'D:/FMCG_data.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2          -- skip the header from records
);

select * from fmcg;

-- 1. Show number of records
select count(*) as Num_of_Records from fmcg;

-- 2. Write a Query to Find WareHouse with Maximum Capacity of Storage (Top 5)
select Top(5) Ware_house_ID, product_wg_ton from fmcg order by product_wg_ton DESC;

-- 3. Write a Query to Find WareHouse with Minimum Capacity of Storage (Bottom 5)
select Top(5) Ware_house_ID, product_wg_ton from fmcg order by product_wg_ton;

-- 4. Find the Total Number of WH Regional Zone Count of Each Category.
select WH_regional_zone, count(*) as Total_count from fmcg 
group by WH_regional_zone
order by WH_regional_zone;

-- 5. Find average, minimum, maximum, median distance from HUB for warehouse with 
-- minimum capacity 10000, and location type is urban.
WITH MedianCTE AS (
    SELECT dist_from_hub, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY dist_from_hub) OVER()
	AS MedianPrice
    FROM fmcg WHERE product_wg_ton > 10000 and Location_type = 'Urban'
)
SELECT MIN(dist_from_hub),
	AVG(dist_from_hub),
	MAX(dist_from_hub),
	MAX(MedianPrice)
FROM MedianCTE;


-- 6. Window Function - In SQL Server window function performs calculations across set of table rows.
-- Unlike aggregate functions which returns only a single value for group of rows. 
-- window functions return a valeu for each row in result set.

SELECT Ware_house_ID, Location_type, zone, wh_owner_type, product_wg_ton, Competitor_in_mkt,
RANK() OVER(PARTITION BY Competitor_in_mkt ORDER BY product_wg_ton DESC)
AS Wh_Rank FROM fmcg;

select * from fmcg;

-- Same values for same categories would return the same rank
SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, Competitor_in_mkt,
RANK() OVER(PARTITION BY zone ORDER BY product_wg_ton ASC)
AS Wh_Rank FROM fmcg;

-- DENSE_RANK : Eliminates the issue with RANK function allowing different ranks for repeating values for the same category
SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, Competitor_in_mkt,
DENSE_RANK() OVER(PARTITION BY zone ORDER BY dist_from_hub ASC)
AS Wh_Rank FROM fmcg;

-- TOP 5 Ranks
-- Using CTE
WITH Rank_CTE as (SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, Competitor_in_mkt,
RANK() OVER(PARTITION BY zone ORDER BY product_wg_ton ASC)
AS Wh_Rank FROM fmcg)
select * from Rank_CTE where Wh_Rank <= 5;

-- Using SubQuery
SELECT * FROM (SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, Competitor_in_mkt,
RANK() OVER(PARTITION BY zone ORDER BY product_wg_ton ASC)
AS Wh_Rank FROM fmcg) Wh_Rank where Wh_Rank.Wh_Rank <= 5;

-- LAG and LEAD
SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, workers_num,
LAG(product_wg_ton, 1) OVER(PARTITION BY zone ORDER BY product_wg_ton DESC)
AS Prev_wg_ton FROM fmcg

SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, workers_num,
LEAD(product_wg_ton, 1) OVER(PARTITION BY zone ORDER BY product_wg_ton DESC)
AS Prev_wg_ton FROM fmcg

-- NTILE() - is used to specify which Quartile the value belongs
SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, workers_num,
NTILE(4) OVER(ORDER BY product_wg_ton)
AS Quartiles FROM fmcg

-- PERCENT_RANK() - Returns the percentile value ranging between 0 and 1
SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, workers_num,
PERCENT_RANK() OVER(ORDER BY product_wg_ton)
AS Percent_rank FROM fmcg

-- show all records where number of workers comes in range (0th - 40th percentile)
select * from (SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, workers_num,
PERCENT_RANK() OVER(ORDER BY workers_num)
AS Percent_rank FROM fmcg where workers_num >=0) Percent_rank where Percent_rank <= 0.40;

-- Find the difference between current value of Product_wg_ton  and compare it with previous 2 values [Lag(2)]
-- and rank it according to the difference
with wg_rank_cte as (SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, workers_num,
LAG(product_wg_ton, 2) OVER(ORDER BY product_wg_ton DESC) - product_wg_ton as prev_wg_ton
FROM fmcg) 
select *, DENSE_RANK() OVER( ORDER BY prev_wg_ton DESC) as rank_wg from wg_rank_cte;


