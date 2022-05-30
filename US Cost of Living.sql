--I downloaded the cost of living data in the U.S. from the advisorsmith.com article by Adrain Mak. In excel, I added a region column, turned each region into its own sheet/ table(in sql) 
--and worked on querying the data in SSMS.
--https://advisorsmith.com/data/coli/#city is the link to the data being used.
--COLI = Cost of Living Index

 

--Name of DB is COLI_PROJECT
USE COLI_PROJECT

--Cost of living across each of the four U.S regions, by state and from highest to lowest cost of living index, per the dataset.

--Midwest
SELECT city, state, col_index
FROM mw_col
ORDER BY col_index DESC
;

--Northeast
SELECT city, state, col_index 
FROM ne_col
ORDER BY col_index DESC
;
--South
SELECT city, state, col_index 
FROM south_col
ORDER BY col_index DESC
;

--West
SELECT city, state, col_index 
FROM west_col
ORDER BY col_index DESC
;


--Using the aggregate function AVG to find the average cost of living index for each state in the Midwest, per the dataset.
SELECT state as 'State', AVG(col_index) AS 'MW AVG COLI'
FROM mw_col
GROUP BY State
ORDER BY 'MW AVG COLI' DESC
;

--Finding the average cost of living index in the Midwest from the dataset. AVG COLI = 90.025, per the dataset
SELECT AVG(col_index) AS 'MW AVG COLI'
FROM mw_col
;

--Querying the Midwest States above or equal to the average cost of living in the Midwest, per dataset.
SELECT state as 'State', AVG(col_index) AS 'MW STATES COLI >= MW AVG COLI'
FROM mw_col
GROUP BY State
HAVING AVG(col_index) >= 90.025
ORDER BY 'MW STATES COLI >= MW AVG COLI' DESC
;

--Querying the Midwest States below the avergae cost of living in the Midwest, per dataset.
SELECT state as 'State', AVG(col_index) AS 'MW STATES COLI < AVG MW COLI'
FROM mw_col
GROUP BY State
HAVING AVG(col_index) < 90.025
ORDER BY 'MW STATES COLI < AVG MW COLI' DESC
;

--Using the aggregate function AVG to find the average cost of living index for each state in the Northeast, per dataset.
SELECT state AS 'State', AVG(col_index) AS 'NE AVG COLI'
FROM ne_col
GROUP BY State
ORDER BY 'NE AVG COLI' DESC
;

--Finding the average cost of living index in the Northeast from the dataset. Northeast AVG COLI = 100.1466667, per dataset
SELECT AVG(col_index) AS 'NE AVG COLI'
FROM ne_col
;

--Finding the States in the Northeast with a higher cost of living index than the Northeast average, per dataset.
SELECT state as 'State', AVG(col_index) AS 'NE STATES COLI >= NE AVG COLI'
FROM ne_col
Group by State
Having AVG(col_index) >= 100.146666
ORDER BY 'NE STATES COLI >= NE AVG COLI' DESC
;

--Finding the States in the Northeast with a lower cost of living index than the Northeast average, per dataset.
SELECT state as 'State', AVG(col_index) AS 'NE STATES COLI < NE AVG COLI'
FROM ne_col
WHERE col_index < 100.146666
Group by State
ORDER BY 'NE STATES COLI < NE AVG COLI' DESC
;

--Using the aggregate function AVG to find the average cost of living index for each State in the South, per dataset.
SELECT state AS 'State', AVG(col_index) AS 'SOUTHERN STATES AVG COLI'
FROM south_col
GROUP BY State
ORDER BY 'SOUTHERN STATES AVG COLI' DESC
;

--Finding the average cost of living in Southern U.S., per dataset in the U.S. U.S. South Avg = 91.6143612
SELECT AVG(col_index) As 'SOUTHERN STATES AVG COLI'
FROM south_col
;

--Finding the States in the Southern U.S. with a higher or equal to the average cost of living in the South, per dataset in the U.S.
SELECT state AS 'State', AVG(col_index) As 'SOUTHERN STATES COLI >= SOUTHERN AVG COLI'
FROM south_col
GROUP BY State
HAVING AVG(col_index) >= 91.6143612
ORDER BY [SOUTHERN STATES COLI >= SOUTHERN AVG COLI] DESC
;

--Finding the States in the South with a higher or equal to the average cost of living in the South, per dataset in the U.S.
SELECT state AS 'State', AVG(col_index) As 'SOUTHERN STATES COLI < SOUTHERN AVG COLI'
FROM south_col 
GROUP BY State
HAVING AVG(col_index) < 91.6143612
ORDER BY [SOUTHERN STATES COLI < SOUTHERN AVG COLI] DESC
;

--Using the aggregate function AVG to find the average cost of living index for each state in Western U.S., per dataset.
SELECT state, AVG(col_index) AS 'WEST COAST AVG COLI'
FROM west_col
Group by State
ORDER BY 'WEST COAST AVG COLI' DESC
;
--Finding the average cost of living in Western U.S., per dataset in the U.S. U.S. South Avg = 109.722608696
SELECT AVG(col_index) AS 'AVG WEST COAST COLI'
FROM west_col
;

--Finding the States in the West with a higher or equal to the average cost of living in the West, per dataset in the U.S.
SELECT state AS 'State', AVG(col_index) As 'WEST COAST COLI >= Avg WEST COAST COLI'
FROM west_col
GROUP BY State
HAVING  AVG(col_index) >= 109.722608696
ORDER BY [WEST COAST COLI >= Avg WEST COAST COLI] DESC
;

--Finding the States in the West with a lower cost of living to the average cost of living in the West, per dataset in the U.S.
SELECT state AS 'State', AVG(col_index) As 'WEST COAST COLI < Avg WEST COAST COLI'
FROM west_col
GROUP BY State
HAVING  AVG(col_index) < 109.722608696
ORDER BY [WEST COAST COLI < Avg WEST COAST COLI] DESC
;


--Creating a temp table with the four regions/ tables.
CREATE TABLE #temp_US_coli (
CITY VARCHAR(20),
State VARCHAR(2),
COL_INDEX FLOAT NULL,
REGION VARCHAR(15)
);

-- Inserting the four seperate region tables into a temp table, realized/ performed after, I could do all at once with a UNION clause. The UNION clause insert is below.
--INSERT INTO #temp_US_coli
--SELECT * 
--FROM mw_col
--;

--INSERT INTO #temp_US_coli
--SELECT * 
--FROM ne_col
--;

--INSERT INTO #temp_US_coli
--SELECT * 
--FROM south_col
--;

--INSERT INTO #temp_US_coli
--SELECT * 
--FROM west_col
--;

--Inserting all the four region tables using a UNION clause.
INSERT INTO #temp_US_coli
SELECT * 
FROM mw_col
UNION
SELECT *
FROM ne_col
UNION 
SELECT * 
FROM west_col
UNION 
SELECT * 
FROM south_col
;

--Making sure all the rows and columns were added to the temp table.
SELECT * 
FROM #temp_US_coli
;
-- Finding the average cost of living across all four regions o fthe U.S., per dataset. U.S. AVG COLI = 96.54098
SELECT AVG(col_index) AS 'U.S. COLI Avg'
FROM #temp_US_coli
;

--Finding the individual regions' COLI.
SELECT REGION, AVG(col_index) AS 'COLI per Region'
FROM #temp_US_coli
GROUP BY REGION
ORDER BY [COLI per Region] DESC
;

-- Similar to above query, finding individual States COLI in the U.S. in the temp table.
SELECT STATE, AVG(col_index) AS 'STATE COLI', REGION
FROM #temp_us_coli
GROUP BY STATE, REGION
ORDER BY [STATE COLI] DESC
;

--Finding States w/ higher or equal average cost of living index in the U.S.,per dataset. 
SELECT state as 'State', AVG(col_index) AS 'States >= U.S. Avg. COL INDEX'
FROM #temp_US_coli
GROUP BY State
HAVING AVG(col_index) >= 96.56098
ORDER BY 2 DESC
;

--Finding States below average cost of living index in the U.S.,per dataset. 
SELECT state as 'State', AVG(col_index) AS 'States < U.S. Avg. COL INDEX'
FROM #temp_US_coli
GROUP BY State
HAVING AVG(col_index) < 96.56098
ORDER BY 2 DESC
;

--Using UNION clauses to show all of the prior SELECT statement together.
--Used HAVING statement in order to find States w/ higher or equal average cost of living index in the U.S.,per dataset. 
--Average cost of living index for this data set is 96.54098039.
--Dataset does not have the same about amount of cities per state, so results are skewed.
--Had done this before inserting the temp table, knew the average by calculating the avg in excel.
SELECT state as 'State', AVG(col_index) AS 'Above Avg. COL INDEX'
FROM mw_col
GROUP BY State
HAVING AVG(col_index) >= 96.56098
UNION
SELECT state, AVG(col_index)
FROM ne_col
GROUP BY State
HAVING AVG(col_index) >= 96.56098
UNION
SELECT state, AVG(col_index)
FROM south_col
GROUP BY State
HAVING AVG(col_index) >= 96.56098
UNION
SELECT state, AVG(col_index)
FROM west_col
GROUP BY State
HAVING AVG(col_index) >= 96.56098
ORDER BY [Above Avg. COL INDEX] DESC
;


--Using UNION clauses to show all of the prior SELECT statement together.
--Used a WHERE statement in order to find States w/ lower than the average cost of living. 
--Average cost of living index for this data set is 96.54098039.
SELECT state as 'State', AVG(col_index) AS 'Below Avg. COL INDEX'
FROM mw_col
GROUP BY State
HAVING AVG(col_index) < 96.56098
UNION
SELECT state, AVG(col_index)
FROM ne_col
GROUP BY State
HAVING AVG(col_index) < 96.56098
UNION
SELECT state, AVG(col_index)
FROM south_col
GROUP BY State
HAVING AVG(col_index) < 96.56098
UNION
SELECT state, AVG(col_index)
FROM west_col
GROUP BY State
HAVING AVG(col_index) < 96.56098
ORDER BY [Below Avg. COL INDEX] DESC
;

--After reveiwing the UNION query for below avg coli, I noticed I had misplaced one town in Ohio as being in the South region/ table
--To correct, I performed the steps below.
--SELECT * 
--FROM south_col
--WHERE State = 'OH'

--Moving the Ohio data point from the South to Midwest.
--INSERT INTO mw_col
--SELECT * 
--FROM south_col
--WHERE State = 'OH'
--;

--Deleting the Ohio data point from the South table.
--DELETE FROM south_col
--WHERE State = 'OH'
;
