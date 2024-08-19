USE warehousedb;

select * from fmcg;

-- a) Find the Shape of the FMCG Table. 
select COUNT(*) as no_row from fmcg;
select count(*) as no_columns from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'fmcg';

-- b) Evaluate the Impact of Warehouse Age on Performance. 
-- Question: How does the age of a warehouse impact its operational performance, 
-- specifically in terms of storage issues reported in the last years?


select top(5) wh_est_year from fmcg ORDER BY wh_est_year DESC;

select (YEAR(GETDATE()) - wh_est_year) as Wh_age, 
avg(storage_issue_reported_l3m) as avg_storage_issue
from fmcg
where wh_est_year >= 0
group by YEAR(GETDATE()) - wh_est_year order by Wh_age asc;

-- Conclusion: Studying the result from the above query we get to know that there is a postive corelation between Warehouse age and storage issues.

-- c) Analyze the Relationship Between Flood-Proof Status and Transport Issues. 
-- Question: Is there a significant relationship between flood-proof status and the 
-- number of transport issues reported in the last years?

SELECT sum(transport_issue_l1y) as Toal_Trans_Issue, flood_proof from fmcg
group by flood_proof;

-- Conclusion: More transport issues has been reported if the warehouse is not flood proofed as compared to one that is flood proofed

-- d) Evaluate the Impact of Government Certification on Warehouse Performance. 
-- Question: How does having a government certification impact the performance of warehouses, particularly in 
-- terms of breakdowns and storage issues in last 3 months?

select approved_wh_govt_certificate, 
	avg(storage_issue_reported_l3m) as Storage_issues, 
	avg(wh_breakdown_l3m) as Wh_Breakdowns
from fmcg
group by approved_wh_govt_certificate
order by Storage_issues DESC;

-- e) Determine the Optimal Distance from Hub for Warehouses:
-- Question: What is the optimal distance from the hub for warehouses to minimize transport 
-- issues, based on the data provided?

select transport_issue_l1y, avg(dist_from_hub) as avg_dist from fmcg
group by transport_issue_l1y
order by transport_issue_l1y asc; 

-- Conclusion: Optimal distance from the hub for warehouses to minimize transport 
-- issues, based on the data provided is around 162 miles

-- f) Identify the Zones with the Most Operational Challenges.
-- Question: Which zones face the most operational challenges, considering factors like transport issues,
-- storage problems, and breakdowns?

select zone,avg(transport_issue_l1y), sum(transport_issue_l1y) as Transport_Issue, 
sum(storage_issue_reported_l3m) as Storage_Issue, 
sum(wh_breakdown_l3m) as Breakdown_Issue,
sum(transport_issue_l1y) + sum(storage_issue_reported_l3m) + sum(wh_breakdown_l3m) / 3 as Avg_Issue
from fmcg
group by zone
order by Avg_Issue;

-- g) Identify High-Risk Warehouses Based on Breakdown Incidents and Age. 
-- Question: Which warehouses are at high risk of breakdowns, especially 
-- considering their age and the number of breakdown incidents reported in the last 3 months?


SELECT Ware_house_ID,
(YEAR(GETDATE()) - wh_est_year) as Wh_age,
wh_breakdown_l3m,
CASE
	WHEN wh_breakdown_l3m > 4 THEN 'High Risk'
	WHEN wh_breakdown_l3m > 2 THEN 'Medium Risk'
	ELSE 'Low_Risk'
END AS Risk_level
from fmcg
where (YEAR(GETDATE()) - wh_est_year) > 15
order by wh_breakdown_l3m DESC;




-- h) Examine the Effectiveness of Warehouse Distribution Strategy. 
-- Question: How effective is the current distribution strategy in each zone, based 
-- on the number of distributors connected to warehouses and their respective product weights?

select * from fmcg;

select zone, sum(distributor_num) as Total_distribution, sum(product_wg_ton) as Total_product_wg_ton,
round(sum(product_wg_ton) / sum(distributor_num), 3) as Avg_Effec
from fmcg
group by zone
order by Avg_Effec ASC;

-- Conclusion: Current distribution plan is best in East Zone

-- i) Correlation Between Worker Numbers and Warehouse Issues. 
-- Question: Is there a correlation between the number of workers in a warehouse 
-- and the number of storage or breakdown issues reported?

select workers_num, 
	sum(storage_issue_reported_l3m) as avg_storage_issues
	from fmcg
where workers_num is not null
group by workers_num
order by workers_num, avg_storage_issues;


-- j) Assess the Zone-wise Distribution of Flood Impacted Warehouses.
-- Question: Which zones are most affected by flood impacts, and 
-- how does this affect their overall operational stability?

select zone, count(*) as Total_wh,
SUM(
CASE
	WHEN flood_impacted = 1 THEN 1
	ELSE 0
END) as Flood_impact_count,
SUM(
CASE
	WHEN flood_impacted = 1 THEN 1
	ELSE 0
END) * 100 / COUNT(*) as Flood_impact_percentage
from fmcg group by zone
order by Flood_impact_percentage desc;


-- k) Calculate the Cumulative Sum of Total Working Years for Each Zone. 
-- Question: How can you calculate the cumulative sum of total working years for each zone?

select zone, 
sum(YEAR(GETDATE()) - wh_est_year) OVER(ORDER BY zone ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Sum_year 
from fmcg ;

select zone,YEAR(GETDATE()) - wh_est_year from fmcg order by zone;

-- Calculate cucmulative sum of total workers for each warehouse govt. rating
select approved_wh_govt_certificate, workers_num,
sum(workers_num) OVER(partition by approved_wh_govt_certificate 
ORDER BY approved_wh_govt_certificate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Sum_Workers 
from fmcg ;

-- l) Rank Warehouses Based on Distance from Hub

select Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub,
DENSE_RANK() OVER(ORDER BY dist_from_hub ASC) AS Wh_Rank FROM fmcg;

-- m) Calculate the Running average of product weight in tons for each zone:
-- Running, Cumulative, Moving means the same

select zone, product_wg_ton,
avg(product_wg_ton) OVER(partition by zone order by product_wg_ton 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as  Running_Avg_wg
from fmcg;

-- n) Rank Warehouses Based on Total Number of Breakdown Incidents. 
-- Question: How can you rank warehouses based on the total number of breakdown incidents in the last 3 months?

select Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub,
DENSE_RANK() OVER(PARTITION BY wh_breakdown_l3m ORDER BY wh_breakdown_l3m ASC) AS Wh_Rank FROM fmcg;


-- o) Determine the Relation Between Transport Issues and Flood Impact.
-- Question: Is there any significant relationship between the number of transport issues and flood impact status of warehouses?

select sum(transport_issue_l1y) as avg_transport_issue, flood_impacted from fmcg
group by flood_impacted;


-- q) Window Functions: RAN, DENSE_RANK, LAG, LEAD
--Rank Warehouses by Product Weight within Each Zone:
--Question: How do you rank warehouses based on the product weight they handle within each zone, allowing ties?

select Ware_house_ID, zone, product_wg_ton, 
DENSE_RANK() OVER(PARTITION BY zone ORDER BY product_wg_ton DESC) as Wh_Rank from fmcg;


-- r) Question: How can you use DENSE_RANK to find the most efficient warehouses in terms of breakdown incidents within each zone?
select Ware_house_ID, zone, wh_breakdown_l3m, storage_issue_reported_l3m, transport_issue_l1y, dist_from_hub,
DENSE_RANK() OVER(PARTITION BY zone ORDER BY wh_breakdown_l3m, storage_issue_reported_l3m, transport_issue_l1y, dist_from_hub) as Wh_Rank from fmcg;

-- s) Calculate the Difference in Storage Issues Using LAG.
-- Question: How can you use LAG to calculate the difference in storage issues reported 
-- between consecutive warehouses within each zone?

SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub, product_wg_ton, storage_issue_reported_l3m,
LAG(storage_issue_reported_l3m, 1, 0) OVER(PARTITION BY zone ORDER BY Ware_house_ID)
AS Prev_Storage_issue, 
storage_issue_reported_l3m - LAG(storage_issue_reported_l3m, 1, 0) OVER(PARTITION BY zone ORDER BY Ware_house_ID) as Diff_Storage_ISsue
FROM fmcg

-- t) Compare Current and Next Warehouse's Distance Using LEAD:
-- Question: How can you compare the distance from the hub of the current warehouse to the next one using LEAD?

SELECT Ware_house_ID, Location_type, zone, wh_owner_type, dist_from_hub,
LEAD(dist_from_hub, 1, 0) OVER(ORDER BY zone)
AS Prev_Dist,
dist_from_hub - LEAD(dist_from_hub, 1, 0) OVER(ORDER BY zone)
AS Diff_Dist
FROM fmcg


-- u) Categorize Warehouses by Product Weight. 
-- Question: How can you categorize warehouses as 'Low', 'Medium', or 'High' 
-- based on the amount of product weight they handle?

select product_wg_ton,
case
	when Quartiles = 1 THEN 'Low'
	when Quartiles = 3  THEN 'High'
	else 'Medium'
END as Weight
from (SELECT product_wg_ton,
NTILE(3) OVER(ORDER BY product_wg_ton)
AS Quartiles FROM fmcg) weightCTE

-- w) Create a Stored Procedure to Fetch High-Risk Warehouses:
-- Question: How would you create a stored procedure that returns all warehouses
-- classified as 'High Risk' based on the number of breakdowns and storage issues?
CREATE PROCEDURE HighRiskWarehouse
AS
	BEGIN
		select Ware_house_ID,storage_issue_reported_l3m, transport_issue_l1y, wh_breakdown_l3m,
		CASE
			WHEN (storage_issue_reported_l3m > 10 or 
			wh_breakdown_l3m > 5) and transport_issue_l1y > 0 THEN 'High Risk'
			ELSE 'Low Risk'
		END as Risk_Factor from fmcg;
	END;
exec HighRiskWarehouse;

-- x) Create a Stored Procedure to Calculate Warehouse Efficiency:
-- Question: How would you create a stored procedure to calculate and return the efficiency 
-- of each warehouse based on its product weight and number of distributors?

CREATE PROCEDURE Warehouse_Efficiency
AS
	BEGIN
		SELECT Ware_house_ID, distributor_num, product_wg_ton,
		CASE 
			WHEN tiles = 1 THEN 'High Efficiency'
			WHEN tiles = 2 THEN 'Medium Efficiency'
			ELSE 'Low Efficiency'
		END as Efficiency
		FROM (SELECT Ware_house_ID, distributor_num, product_wg_ton,
		NTILE(3) OVER(ORDER BY efficiency) as tiles from 
		(select Ware_house_ID, distributor_num, product_wg_ton, 
		(product_wg_ton / distributor_num)  as efficiency 
		from fmcg) tile_table) main
	END

exec Warehouse_Efficiency


-- y) Create a View for Warehouse Overview:
-- Question: How can you create a view that shows an overview of warehouses, 
-- including their location, product weight, and flood-proof status?

CREATE VIEW Wh_overview AS
	select Ware_house_ID, Location_type, zone, product_wg_ton, distributor_num,flood_proof from fmcg;

select * from Wh_overview;

-- View is to create a temporary table. View is created using table or tables or a SQL query
-- View doesnt not store any records in it


-- z) Create a View for High-Capacity Warehouses. 
-- Question: How would you create a view to display only those warehouses 
-- with a product weight greater than 100 tons?

CREATE VIEW Product_Weights 
AS
	select Ware_house_ID, product_wg_ton from fmcg where product_wg_ton > 10000;

select * from Product_Weights;