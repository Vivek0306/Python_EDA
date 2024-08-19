DECLARE @Databasename NVARCHAR(128) = 'employeedb';

-- Test condition to check if database exists
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = @Databasename)
BEGIN
	DECLARE @sql NVARCHAR(MAX)='CREATE DATABASE '+QUOTENAME(@Databasename);
    EXEC sp_executesql @sql;
END

USE employeedb;

CREATE TABLE employee (
    Attrition VARCHAR(50),
    Business_Travel VARCHAR(50),
    CF_age_band VARCHAR(50),
    CF_attrition_label VARCHAR(50),
    Department VARCHAR(50),
    Education_Field VARCHAR(50),
    emp_no VARCHAR(50),
    Employee_Number INT,
    Gender VARCHAR(50),
    Job_Role VARCHAR(50),
    Marital_Status VARCHAR(50),
    Over_Time VARCHAR(50),
    Over18 VARCHAR(50),
    Training_Times_Last_Year INT,
    Age INT,
    CF_current_Employee INT,
    Daily_Rate INT,
    Distance_From_Home INT,
    Education VARCHAR(50),
    Employee_Count INT,
    Environment_Satisfaction INT,
    Hourly_Rate INT,
    Job_Involvement INT,
    Job_Level INT,
    Job_Satisfaction INT,
    Monthly_Income INT,
    Monthly_Rate INT,
    Num_Companies_Worked INT,
    Percent_Salary_Hike INT,
    Performance_Rating INT,
    Relationship_Satisfaction INT,
    Standard_Hours INT,
    Stock_Option_Level INT,
    Total_Working_Years INT,
    Work_Life_Balance INT,
    Years_At_Company INT,
    Years_In_Current_Role INT,
    Years_Since_Last_Promotion INT,
    Years_With_Curr_Manager INT
);

BULK INSERT employee FROM 'D:/HR_Employee.csv'
WITH
(
	FIELDTERMINATOR = ',', -- '|'	';'	'\t'	' '
	ROWTERMINATOR = '0x0A', -- \r\n - Carriage and New Line Return,
	FIRSTROW = 2          -- skip the header from records
);

select * from employee


-- a) Return the shape of the table
SELECT count(*) as no_row,
(SELECT count(*) FROM INFORMATION_SCHEMA.COLUMNS) as no_col
FROM employee;

-- b) Calculate the cumulative sum of total working years for each department
SELECT 
	emp_no, Department ,Total_Working_Years,
	SUM(Total_Working_Years) OVER(PARTITION BY Department ORDER BY Total_Working_Years ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Cumulative_total_years
FROM employee

-- c) Which gender have higher strength as workforce in each department
SELECT Department, Gender, Gender_Count 
FROM 
(SELECT *,
	RANK() OVER(PARTITION BY Department ORDER BY Gender_Count DESC) as Gender_Rank
FROM
	(SELECT Department, Gender, count(*) as Gender_Count
	FROM employee
	GROUP BY Department, Gender) as GenderCountCTE) GenderRankCTE
WHERE Gender_Rank = 1;

-- Conclusion: The Male gender has the highest workforce in each department

-- d) Create a new column AGE_BAND and Show Distribution of Employee's Age band group
-- (Below 25, 25-34, 35-44, 45-55. ABOVE 55).
SELECT
    CF_age_band, COUNT(*) AS EmployeeCount
FROM employee
GROUP BY CF_age_band
ORDER BY
    CASE
        WHEN CF_age_band = 'Under 25' THEN 1
        WHEN CF_age_band = '25 - 34' THEN 2
        WHEN CF_age_band = '35 - 44' THEN 3
        WHEN CF_age_band = '45 - 54' THEN 4
        WHEN CF_age_band = 'Over 55' THEN 5
        ELSE 6
    END;
	
-- e) Compare all marital status of employee and find the most frequent marital status
SELECT 
	TOP(1) Marital_Status, count(*) as Emp_Count 
FROM employee
GROUP BY Marital_Status;

-- Conclusion: Most frequent marital status is Married

-- f) Show the Job Role with Highest Attrition Rate (Percentage)
SELECT TOP(1) 
	Job_Role,
    ROUND(CAST(Yes_count AS FLOAT) / Emp_Count * 100, 2) AS Attrition_Rate
FROM (
    SELECT 
        Job_Role, 
        COUNT(*) AS Emp_Count,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Yes_count,
        SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS No_count
    FROM employee
    GROUP BY Job_Role
) AttritionCountCTE
ORDER BY Attrition_Rate DESC;


-- g) Show distribution of Employee's Promotion, Find the maximum chances of employee getting promoted.
-- TODO
WITH PromotionDistribution AS (
    SELECT
        Job_Level,
        CASE
            WHEN Years_At_Company BETWEEN 0 AND 1 THEN '0-1 Years'
            WHEN Years_At_Company BETWEEN 2 AND 3 THEN '2-3 Years'
            WHEN Years_At_Company BETWEEN 4 AND 5 THEN '4-5 Years'
            WHEN Years_At_Company BETWEEN 6 AND 10 THEN '6-10 Years'
            ELSE 'More than 10 Years'
        END AS Years_At_Company_Band,
        COUNT(*) AS Total_Employees,
        SUM(CASE WHEN Years_Since_Last_Promotion > 0 THEN 1 ELSE 0 END) AS Promoted_Employees,
        CAST(SUM(CASE WHEN Years_Since_Last_Promotion > 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Promotion_Rate_Percent
    FROM employee
    GROUP BY 
        Job_Level,
        CASE
            WHEN Years_At_Company BETWEEN 0 AND 1 THEN '0-1 Years'
            WHEN Years_At_Company BETWEEN 2 AND 3 THEN '2-3 Years'
            WHEN Years_At_Company BETWEEN 4 AND 5 THEN '4-5 Years'
            WHEN Years_At_Company BETWEEN 6 AND 10 THEN '6-10 Years'
            ELSE 'More than 10 Years'
        END
)
SELECT 
    Job_Level,
    Years_At_Company_Band,
    Total_Employees,
    Promoted_Employees,
    Promotion_Rate_Percent
FROM PromotionDistribution
ORDER BY Promotion_Rate_Percent DESC


-- h) Show the cumulative sum of total working years for each department.
SELECT 
	emp_no, Department ,Total_Working_Years,
	SUM(Total_Working_Years) OVER(
	PARTITION BY Department ORDER BY Total_Working_Years ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) as Cumulative_total_years
FROM employee;

-- i) Find the rank of employees within each department based on their monthly income
SELECT * 
FROM
(SELECT Department, emp_no, Monthly_Income,
RANK() OVER(PARTITION BY Department ORDER BY Monthly_Income DESC) as Emp_rank
FROM employee) Ranks

-- j) Calculate the running total of 'Total Working Years' for each employee within each 
-- department and age band.
SELECT 
	emp_no, Department, Job_Role , CF_age_band, Total_Working_Years,
	SUM(Total_Working_Years) OVER(
	PARTITION BY Department, CF_age_band ORDER BY Total_Working_Years ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) as Cumulative_total_years
FROM employee;

-- k) For each employee who left, calculate the number of years they worked before leaving and 
-- compare it with the average years worked by employees in the same department.

SELECT 
	e.emp_no, e.Department, e.Years_At_Company, 
	a.Avg_Emp_Years_At_Company
FROM employee e
JOIN 
	(SELECT 
		Department, avg(Years_At_Company) as Avg_Emp_Years_At_Company
	FROM employee 
	GROUP BY Department) as a
ON a.Department = e.Department
WHERE Attrition='Yes'

-- l) Rank the departments by the average monthly income of employees who have left.
SELECT 
	Department, Avg_Monthly_Income,
	RANK() OVER(ORDER BY Avg_Monthly_Income DESC) as Dept_Rank
FROM
(SELECT Department, avg(Monthly_Income) as Avg_Monthly_Income
FROM employee
WHERE Attrition = 'Yes'
GROUP BY Department) RankCTE

-- m) Find the if there is any relation between Attrition Rate and Marital Status of Employee.
SELECT 
    Marital_Status,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND((CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100), 2) AS Attrition_Rate_Percent
FROM employee
GROUP BY Marital_Status
ORDER BY Attrition_Rate_Percent DESC;

-- Conclusion: It is observed that employee who are single have higher attrition rate when compared to 
-- employees who are married or are divorced.

-- n) Show the Department with Highest Attrition Rate (Percentage)
SELECT TOP(1)
	Department,
	ROUND((CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as FLOAT) / COUNT(*) * 100), 2) as Attrition_Rate_Percent
FROM employee
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC

-- o) Calculate the moving average of monthly income over the past 3 employees for each job role.
SELECT
	emp_no, Job_Role, Monthly_Income,
	AVG(Monthly_Income) OVER(PARTITION BY Job_Role ORDER BY Monthly_Income ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as Moving_avg_income
FROM employee
-- TODO


-- p) Identify employees with outliers in monthly income within each job role. [ Condition : 
-- Monthly_Income < Q1 - (Q3 - Q1) * 1.5 OR Monthly_Income > Q3 + (Q3 - Q1) ]

SELECT
	Job_Role, Monthly_Income
FROM
(SELECT 
	Job_Role, Monthly_Income,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Monthly_Income) OVER(PARTITION BY Job_Role) as Q1,
	PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY Monthly_Income) OVER(PARTITION BY Job_Role) as Q2,
	PERCENTILE_CONT(0.75)  WITHIN GROUP (ORDER BY Monthly_Income) OVER(PARTITION BY Job_Role) as Q3,
	PERCENTILE_CONT(0.75)  WITHIN GROUP (ORDER BY Monthly_Income) OVER(PARTITION BY Job_Role) -
	PERCENTILE_CONT(0.25)  WITHIN GROUP (ORDER BY Monthly_Income) OVER(PARTITION BY Job_Role) as IQR
FROM employee) as Quartiles
WHERE Monthly_Income < Q1 - 1.5*IQR or Monthly_Income > Q3 + 1.5*IQR


-- q) Gender distribution within each job role, show each job role with its gender domination. 
-- [Male_Domination or Female_Domination] 

SELECT Job_Role,
	CASE
		WHEN Gender_Rank = 1 and Gender = 'Male' THEN 'Male_Domination'
		ELSE 'Female_Domination'
	END as Gender_Domination
FROM (SELECT *,
RANK() OVER(PARTITION BY Job_Role ORDER BY Gender_Count DESC) as Gender_Rank
FROM
	(SELECT Job_Role, Gender, count(*) as Gender_Count
	FROM employee
	GROUP BY Job_Role, Gender) as GenderCountCTE) GenderRankCTE
WHERE Gender_Rank = 1;


-- r) Percent rank of employees based on training times last year
SELECT emp_no, Training_Times_Last_year,
	PERCENT_RANK() OVER(ORDER BY Training_Times_Last_Year) as Emp_Percent_Rank
FROM employee
ORDER BY Training_Times_Last_Year DESC;


-- s) Divide employees into 5 groups based on training times last year [Use NTILE ()]
SELECT
	emp_no, Job_Role, Training_Times_Last_Year,
	NTILE(5) OVER(ORDER BY Training_Times_Last_Year) as Emp_Training_Group
FROM employee

-- t) Categorize employees based on training times last year as - Frequent Trainee, Moderate Trainee, Infrequent Trainee.
SELECT *,
	CASE 
		WHEN Emp_Training_Group = 1 THEN 'Frequent Trainee'
		WHEN Emp_Training_Group = 2 THEN 'Moderate Trainee'
		ELSE 'Infrequent Trainee'
	END as Emp_Training_Category
FROM
(SELECT
	emp_no, Job_Role, Training_Times_Last_Year,
	NTILE(3) OVER(ORDER BY Training_Times_Last_Year DESC) as Emp_Training_Group
FROM employee) as EmpGroup

-- u) Categorize employees as 'High', 'Medium', or 'Low' performers based on their performance 
-- rating, using a CASE WHEN statement.
SELECT 
	emp_no, Performance_Rating,
	CASE 
		WHEN Performance_Rating > 3 THEN 'High'
		WHEN Performance_Rating < 3 THEN 'Low'
		ELSE 'Medium'
	END as Emp_Performance
FROM employee

-- v) Use a CASE WHEN statement to categorize employees into 'Poor', 'Fair', 'Good', or 'Excellent' 
-- work-life balance based on their work-life balance score.
SELECT emp_no, Job_Role, Work_Life_Balance,
	CASE 
		WHEN Work_Life_Balance = 5 THEN 'Excellent'
		WHEN Work_Life_Balance = 4 THEN 'High'
		WHEN Work_Life_Balance = 3 THEN 'Good'
		ELSE 'Poor'
	END as Emp_Work_Life_Status
FROM employee

-- w) Group employees into 3 groups based on their stock option level using the [NTILE] function.
SELECT
	emp_no, Job_Role,
	Stock_Option_Level,
	NTILE(3) OVER(ORDER BY Stock_Option_Level) as Stock_Option_Group
FROM employee

-- x) Find key reasons for Attrition in Company
SELECT
    Department,
    Job_Role,
    AVG(Environment_Satisfaction) AS Avg_Environment_Satisfaction,
    AVG(Job_Satisfaction) AS Avg_Job_Satisfaction,
    AVG(Distance_From_Home) AS Avg_Distance_From_Home,
    AVG(Age) AS Avg_Age,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Attrition_Rate_Percent
FROM employee
GROUP BY Department, Job_Role
ORDER BY Attrition_Rate_Percent DESC, Department, Job_Role;
