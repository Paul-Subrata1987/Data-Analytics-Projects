/*My SQL Project Assessment - Subrata Paul
SQL for Data Analytics*/

--Go to Database "SQLProjectAssessment"
USE SQLProjectAssessment;


--Select All data from the table
SELECT * FROM insurance;

EXEC sp_help 'Insurance';



-- Task 1: Managing and Querying Insurance Premium Data using SQL --
/*Retrieve records where BMI is between 25 and 30 (inclusive)*/

SELECT * FROM insurance
WHERE bmi BETWEEN 25 AND 30;


/*Insert a new record for an insured individual with the following details:
Age: 35, Sex: Female, BMI: 28, Children: 1, Smoker: No, Region: Southeast, Charges: 5,000*/

INSERT INTO insurance(id, age, sex, bmi, children, smoker, region, expenses)
VALUES (1339, 35, 'female',28,1,'No','Southeast',5000);

SELECT * FROM insurance WHERE id = 1339;



UPDATE insurance
SET region = 'Southeast'
WHERE id = 1339;

/*Delete records of insured individuals from the Southwest region who are non-smokers.*/

DELETE FROM insurance
WHERE region = 'Southeast' AND smoker = 'No';





-- Task 2: Advanced SQL Operations --
/*Calculate the average charges for insured individuals based on their smoking status.*/

SELECT
	smoker AS Smoker,
	FORMAT(AVG(expenses),'N2') AS AvgExpenses
FROM insurance
GROUP BY smoker;



/*Create a new table named high_bmi_insured containing records of individuals with a BMI greater than 30*/

SELECT id, age, sex, bmi, children, smoker, region, expenses 
INTO high_bmi_insured FROM insurance WHERE bmi > 30;


SELECT * FROM high_bmi_insured;


EXEC sp_rename 'high_bmi_insured', 'claims';

SELECT * FROM claims;

/*Perform a right join to display records from the claims table and matched records from the insurance table.*/

SELECT * FROM insurance As i
RIGHT JOIN claims AS c
ON i.id = c.id;


-- Task 3: SQL for Data Analysis and Visualization --
/*Identify the proportion of smokers vs non-smokers within each region.*/

SELECT 
	region,
	smoker,
	COUNT(*) AS total_number,
	FORMAT(CAST(COUNT(*) AS float)/SUM(COUNT(*)) OVER(),'P') AS proportion
FROM insurance
GROUP BY region, smoker
ORDER BY region ASC;


/*Display the distribution of BMI values using histogram-like queries for specified ranges.*/

SELECT
	MIN(bmi) AS minvlaue,
	MAX(bmi) AS maxvalue
FROM insurance;


SELECT 
	CASE 
		WHEN bmi >= 15 AND bmi <25 THEN '15-25 bmi'
		WHEN bmi >= 25 AND bmi <35 THEN '25-35 bmi'
		WHEN bmi >= 35 AND bmi <45 THEN '35-45 bmi'
		WHEN bmi >= 45 AND bmi <55 THEN '45-55 bmi'
		ELSE 'Unknown'
	END AS bin_bmi,
	COUNT(*) AS count_bmi
FROM insurance
GROUP BY 
	CASE 
		WHEN bmi >= 15 AND bmi <25 THEN '15-25 bmi'
		WHEN bmi >= 25 AND bmi <35 THEN '25-35 bmi'
		WHEN bmi >= 35 AND bmi <45 THEN '35-45 bmi'
		WHEN bmi >= 45 AND bmi <55 THEN '45-55 bmi'
		ELSE 'Unknown'
	END
ORDER BY bin_bmi ASC;



/*Dashboard 1: Regional Premium Insights (showing average and total charges by region).
Dashboard 2: Demographic Breakdown (visualizing age, BMI, and smoking status distributions).*/

SELECT
	region,
	COUNT(*) AS TotalRecord,
	FORMAT(AVG(expenses),'C') AS avg_charges,
	FORMAT(SUM(expenses),'C') AS total_charges
FROM insurance
GROUP BY region;


SELECT
	MIN(age) AS minage,
	MAX(age) AS maxage
FROM insurance;

SELECT 
	CASE 
		WHEN age >= 15 AND age <25 THEN '15-25 age'
		WHEN age >= 25 AND age <35 THEN '25-35 age'
		WHEN age >= 35 AND age <45 THEN '35-45 age'
		WHEN age >= 45 AND age <55 THEN '45-55 age'
		WHEN age >= 55 AND age <65 THEN '45-55 age'
		ELSE 'Unknown'
	END AS bin_age,
	COUNT(*) AS count_age
FROM insurance
GROUP BY 
	CASE 
		WHEN age >= 15 AND age <25 THEN '15-25 age'
		WHEN age >= 25 AND age <35 THEN '25-35 age'
		WHEN age >= 35 AND age <45 THEN '35-45 age'
		WHEN age >= 45 AND age <55 THEN '45-55 age'
		WHEN age >= 55 AND age <65 THEN '45-55 age'
		ELSE 'Unknown'
	END
ORDER BY bin_age ASC;

SELECT 
	CASE 
		WHEN bmi >= 15 AND bmi <25 THEN '15-25 bmi'
		WHEN bmi >= 25 AND bmi <35 THEN '25-35 bmi'
		WHEN bmi >= 35 AND bmi <45 THEN '35-45 bmi'
		WHEN bmi >= 45 AND bmi <55 THEN '45-55 bmi'
		ELSE 'Unknown'
	END AS bin_bmi,
	COUNT(*) AS count_bmi
FROM insurance
GROUP BY 
	CASE 
		WHEN bmi >= 15 AND bmi <25 THEN '15-25 bmi'
		WHEN bmi >= 25 AND bmi <35 THEN '25-35 bmi'
		WHEN bmi >= 35 AND bmi <45 THEN '35-45 bmi'
		WHEN bmi >= 45 AND bmi <55 THEN '45-55 bmi'
		ELSE 'Unknown'
	END
ORDER BY bin_bmi ASC;


SELECT 
	smoker,
	COUNT(*) AS count_smoker
FROM insurance
GROUP BY smoker;



-- Task 4: Advanced SQL for Data Preparation and Analysis --
/*Calculate the total charges and average BMI for each region.*/

SELECT * FROM insurance;


SELECT 
	region,
	FORMAT(SUM(expenses),'C') AS total_charges,
	FORMAT(AVG(bmi), 'N1') AS avg_bmi
FROM insurance
GROUP BY region;


/*Extract a refined subset of data where insured individuals have a BMI above 30, are smokers, and have more than 2 children.*/
SELECT * FROM(
SELECT * FROM claims
WHERE bmi > 30 
	AND smoker = 'yes' 
	AND children >2
)AS refined_data;



SELECT * FROM insurance
WHERE id IN (
			SELECT id FROM claims
			WHERE smoker = 'yes' 
					AND children >2);


SELECT * FROM insurance
WHERE EXISTS(
			SELECT * FROM claims
			WHERE insurance.id=claims.id AND smoker = 'yes' 
					AND children >2);