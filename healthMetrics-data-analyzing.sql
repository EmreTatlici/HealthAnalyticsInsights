-- Examine Data Types
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HealthMetrics';

-- Identify Unique Values
SELECT DISTINCT locationAbbr, locationDesc, age_years
FROM HealthMetrics;

-- Replace Not Available Values with NULL
UPDATE HealthMetrics
SET age_years = NULL
WHERE age_years = 'Not Available';

-- Analyze the distribution of data value across different age groups.
SELECT
  age_years,
  COUNT(*) AS Count,
  AVG(data_value) AS MeanDataValue
FROM HealthMetrics
WHERE data_value IS NOT NULL
GROUP BY age_years;

select * From HealthMetrics