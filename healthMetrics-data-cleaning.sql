SELECT *
FROM HealthMetrics
WHERE Data_Value_Footnote IS NULL;


-- Check for missing values in the entire dataset
SELECT COUNT(*) AS NullCount
FROM HealthMetrics
WHERE Data_Value_Footnote IS NULL;

-- Deleting Columns That has too many missing values or unnecessary
ALTER TABLE HealthMetrics
DROP COLUMN Low_Confidence_Limit,High_Confidence_Limit,Data_Value_Alt,YearEnd,Topic,Class,DataSource,QuestionID,ClassID,TopicID,
DataValueTypeID,Data_Value_Type,StratificationCategoryId1,StratificationID1,Data_Value_Unit, Data_Value_Footnote_Symbol, Data_Value_Footnote, Total;

ALTER TABLE HealthMetrics
DROP COLUMN GeoLocation, Question, StratificationCategory1, Stratification1, Gender


-- Replace null values with a default value (adjust as needed) / Age_years, Education, Income, Race_Ethnicity
UPDATE HealthMetrics
SET Income = 'Not Available'
WHERE Income IS NULL;


-- Rename column from 'Education' to 'education' as well as other columns
EXEC sp_rename 'HealthMetrics.Education', 'education', 'COLUMN';


-- Get the data type of columns
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HealthMetrics'




-- Calculate percentage of 'Not Available' values for all columns in the 'HealthMetrics' table
DECLARE @tableName NVARCHAR(255) = 'HealthMetrics';
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += 
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, ' +
    'COUNT(*) AS TotalRows, ' +
    'SUM(CASE WHEN ' + COLUMN_NAME + ' = ''Not Available'' THEN 1 ELSE 0 END) AS NotAvailableCount, ' +
    'CAST(SUM(CASE WHEN ' + COLUMN_NAME + ' = ''Not Available'' THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(CAST(COUNT(*) AS FLOAT), 0) * 100 AS NotAvailablePercentage ' +
    'FROM ' + @tableName + ' UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @tableName
AND DATA_TYPE IN ('VARCHAR', 'NVARCHAR', 'CHAR', 'NCHAR'); -- Add more data types if needed

-- Remove the last 'UNION ALL'
SET @sql = LEFT(@sql, LEN(@sql) - LEN('UNION ALL'));

-- Execute the generated SQL
EXEC sp_executesql @sql;

-- Drop columns with a high percentage of 'Not Available' values
ALTER TABLE HealthMetrics
DROP COLUMN education, income, race_ethnicity;



