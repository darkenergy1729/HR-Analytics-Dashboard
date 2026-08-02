/*====================================================================
Project      : HR Analytics Dashboard
Author       : Puneet Kaur
Database     : MySQL 8.0
Dataset      : HR_Analytics_Cleaned

Description:
This SQL script performs Exploratory Data Analysis (EDA) on the HR
Analytics dataset. The insights generated from these queries were used
to build an interactive HR Analytics Dashboard in Power BI.

Topics Covered
--------------
• Workforce Overview
• Department Analysis
• Employee Demographics
• Compensation Analysis
• Experience Analysis
• Attrition Overview

Dashboard Supported
-------------------
Dashboard 1 – Workforce Overview
Dashboard 2 – Attrition Analysis
Dashboard 3 – Compensation & Employee Experience

====================================================================*/


/*====================================================================
SECTION 1 : DATABASE SETUP
====================================================================*/

USE hr_analysis;

SELECT *
FROM hr_analytics_cleaned;


/*====================================================================
SECTION 2 : WORKFORCE OVERVIEW
====================================================================*/

-- Total Employees

SELECT
    COUNT(*) AS TotalEmployees
FROM hr_analytics_cleaned;


-- Overall Attrition Rate

SELECT
    ROUND(
        COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END)
        * 100.0 /
        COUNT(*),
        2
    ) AS AttritionRate
FROM hr_analytics_cleaned;


-- Total Employees by Department

SELECT
    Department,
    COUNT(*) AS TotalEmployees
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY TotalEmployees DESC;


/*====================================================================
SECTION 3 : DEPARTMENT ANALYSIS
====================================================================*/

-- Average Monthly Income by Department

SELECT
    Department,
    ROUND(AVG(MonthlyIncome),2) AS AverageMonthlyIncome
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AverageMonthlyIncome DESC;


-- Attrition Rate by Department

SELECT
    Department,
    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 4 : JOB ROLE ANALYSIS
====================================================================*/

-- Average Monthly Income by Job Role

SELECT
    JobRole,
    ROUND(AVG(MonthlyIncome),2) AS AverageMonthlyIncome
FROM hr_analytics_cleaned
GROUP BY JobRole
ORDER BY AverageMonthlyIncome DESC;


-- Attrition Rate by Job Role

SELECT
    JobRole,
    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate
FROM hr_analytics_cleaned
GROUP BY JobRole
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 5 : GENDER ANALYSIS
====================================================================*/

-- Employee Distribution by Gender

SELECT
    Gender,
    COUNT(*) AS TotalEmployees
FROM hr_analytics_cleaned
GROUP BY Gender;


-- Attrition Rate by Gender

SELECT
    Gender,
    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate
FROM hr_analytics_cleaned
GROUP BY Gender
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 6 : MARITAL STATUS ANALYSIS
====================================================================*/

-- Employee Distribution by Marital Status

SELECT
    MaritalStatus,
    COUNT(*) AS TotalEmployees
FROM hr_analytics_cleaned
GROUP BY MaritalStatus;


-- Attrition Rate by Marital Status

SELECT
    MaritalStatus,
    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate
FROM hr_analytics_cleaned
GROUP BY MaritalStatus
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 7 : EDUCATION ANALYSIS
====================================================================*/

-- Employee Distribution by Education Level

SELECT
    Education_Label,
    COUNT(*) AS TotalEmployees
FROM hr_analytics_cleaned
GROUP BY Education_Label;


-- Employee Distribution by Education Field

SELECT
    EducationField,
    COUNT(*) AS TotalEmployees
FROM hr_analytics_cleaned
GROUP BY EducationField;


-- Attrition Rate by Education Level

SELECT
    Education_Label,
    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate
FROM hr_analytics_cleaned
GROUP BY Education_Label
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 8 : AGE GROUP ANALYSIS
====================================================================*/

-- Employee Distribution by Age Group

SELECT
    AgeGroup,
    COUNT(*) AS TotalEmployees
FROM hr_analytics_cleaned
GROUP BY AgeGroup
ORDER BY TotalEmployees DESC;


-- Average Age by Department

SELECT
    Department,
    ROUND(AVG(Age),2) AS AverageAge
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AverageAge DESC;


-- Attrition Rate by Age Group

SELECT
    AgeGroup,
    ROUND(
        COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END)
        * 100.0 /
        COUNT(*),
        2
    ) AS AttritionRate
FROM hr_analytics_cleaned
GROUP BY AgeGroup
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 9 : COMPENSATION ANALYSIS
====================================================================*/

-- Average Monthly Income

SELECT
    ROUND(AVG(MonthlyIncome),2) AS AverageMonthlyIncome
FROM hr_analytics_cleaned;


-- Average Monthly Income by Education Field

SELECT
    EducationField,
    ROUND(AVG(MonthlyIncome),2) AS AverageMonthlyIncome
FROM hr_analytics_cleaned
GROUP BY EducationField
ORDER BY AverageMonthlyIncome DESC;


-- Average Monthly Income by Job Role

SELECT
    JobRole,
    ROUND(AVG(MonthlyIncome),2) AS AverageMonthlyIncome
FROM hr_analytics_cleaned
GROUP BY JobRole
ORDER BY AverageMonthlyIncome DESC;


-- Average Monthly Income by Job Level

SELECT
    JobLevel,
    ROUND(AVG(MonthlyIncome),2) AS AverageMonthlyIncome
FROM hr_analytics_cleaned
GROUP BY JobLevel
ORDER BY JobLevel;


/*====================================================================
SECTION 10 : EXPERIENCE ANALYSIS
====================================================================*/

-- Average Total Working Years

SELECT
    ROUND(AVG(TotalWorkingYears),2) AS AverageWorkingExperience
FROM hr_analytics_cleaned;


-- Average Total Working Years by Department

SELECT
    Department,
    ROUND(AVG(TotalWorkingYears),2) AS AverageWorkingExperience
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AverageWorkingExperience DESC;


-- Average Years at Company

SELECT
    ROUND(AVG(YearsAtCompany),2) AS AverageYearsAtCompany
FROM hr_analytics_cleaned;


-- Average Years at Company by Department

SELECT
    Department,
    ROUND(AVG(YearsAtCompany),2) AS AverageYearsAtCompany
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AverageYearsAtCompany DESC;


/*====================================================================
SECTION 11 : PROMOTION ANALYSIS
====================================================================*/

-- Average Years Since Last Promotion

SELECT
    ROUND(AVG(YearsSinceLastPromotion),2) AS AverageYearsSinceLastPromotion
FROM hr_analytics_cleaned;


-- Average Years Since Last Promotion by Job Role

SELECT
    JobRole,
    ROUND(AVG(YearsSinceLastPromotion),2) AS AverageYearsSinceLastPromotion
FROM hr_analytics_cleaned
GROUP BY JobRole
ORDER BY AverageYearsSinceLastPromotion DESC;


/*====================================================================
SECTION 12 : TRAINING ANALYSIS
====================================================================*/

-- Average Training Times Last Year

SELECT
    ROUND(AVG(TrainingTimesLastYear),2) AS AverageTrainingSessions
FROM hr_analytics_cleaned;


-- Average Training Times by Department

SELECT
    Department,
    ROUND(AVG(TrainingTimesLastYear),2) AS AverageTrainingSessions
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AverageTrainingSessions DESC;


/*====================================================================
SECTION 13 : JOB SATISFACTION ANALYSIS
====================================================================*/

-- Average Job Satisfaction

SELECT
    ROUND(AVG(JobSatisfaction),2) AS AverageJobSatisfaction
FROM hr_analytics_cleaned;


-- Average Job Satisfaction by Department

SELECT
    Department,
    ROUND(AVG(JobSatisfaction),2) AS AverageJobSatisfaction
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AverageJobSatisfaction DESC;


-- Average Work-Life Balance by Department

SELECT
    Department,
    ROUND(AVG(WorkLifeBalance),2) AS AverageWorkLifeBalance
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AverageWorkLifeBalance DESC;


/*====================================================================
SECTION 14 : SUMMARY STATISTICS
====================================================================*/

-- Overall Workforce Summary

SELECT
    COUNT(*) AS TotalEmployees,
    ROUND(AVG(Age),2) AS AverageAge,
    ROUND(AVG(MonthlyIncome),2) AS AverageMonthlyIncome,
    ROUND(AVG(JobSatisfaction),2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance),2) AS AverageWorkLifeBalance,
    ROUND(AVG(TotalWorkingYears),2) AS AverageWorkingExperience,
    ROUND(AVG(YearsAtCompany),2) AS AverageYearsAtCompany
FROM hr_analytics_cleaned;


/*====================================================================
END OF SCRIPT

This script supports:
✔ Dashboard 1 – Workforce Overview
✔ Dashboard 2 – Attrition Analysis (Base Metrics)
✔ Dashboard 3 – Compensation & Employee Experience

====================================================================*/
