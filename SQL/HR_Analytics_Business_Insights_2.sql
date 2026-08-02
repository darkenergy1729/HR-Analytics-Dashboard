/*====================================================================
Project      : HR Analytics Dashboard
Author       : Puneet Kaur
Database     : MySQL 8.0
Dataset      : HR_Analytics_Cleaned

Description:
This script contains advanced SQL analysis performed on the HR
Analytics dataset. The insights generated here were used to build
Dashboard 4 – Executive Insights.

Topics Covered
--------------
• Common Table Expressions (CTEs)
• Window Functions
• Ranking Functions
• NTILE()
• High-Risk Employee Analysis
• Salary Quartile Analysis
• Department Risk Score
• Executive Business Insights

====================================================================*/

USE hr_analysis;


/*====================================================================
SECTION 1 : ATTRITION RATE BY DEPARTMENT
====================================================================*/

SELECT
    Department,
    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate,
    ROUND(AVG(JobSatisfaction),2) AS AvgJobSatisfaction,
    ROUND(AVG(WorkLifeBalance),2) AS AvgWorkLifeBalance,
    ROUND(AVG(MonthlyIncome),2) AS AvgMonthlyIncome
FROM hr_analytics_cleaned
GROUP BY Department
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 2 : ATTRITION RATE BY JOB ROLE
====================================================================*/

SELECT
    JobRole,
    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate,
    ROUND(AVG(JobSatisfaction),2) AS AvgJobSatisfaction,
    ROUND(AVG(MonthlyIncome),2) AS AvgMonthlyIncome
FROM hr_analytics_cleaned
GROUP BY JobRole
ORDER BY AttritionRate DESC;


/*====================================================================
SECTION 3 : DEPARTMENT CONTRIBUTION
====================================================================*/

SELECT
    Department,
    COUNT(*) AS TotalEmployees,

    (
        SELECT COUNT(*)
        FROM hr_analytics_cleaned
    ) AS OverallEmployees,

    ROUND(
        COUNT(*)*100/
        (
            SELECT COUNT(*)
            FROM hr_analytics_cleaned
        ),
        2
    ) AS WorkforcePercentage
FROM hr_analytics_cleaned
GROUP BY Department;


/*====================================================================
SECTION 4 : JOB ROLE RANKING BY ATTRITION
====================================================================*/

WITH AttritionRate AS
(
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
)

SELECT
    JobRole,
    AttritionRate,

    ROW_NUMBER() OVER
    (
        ORDER BY AttritionRate DESC
    ) AS Ranking

FROM AttritionRate;


/*====================================================================
SECTION 5 : TOP 3 JOB ROLES WITH HIGHEST ATTRITION
====================================================================*/

WITH AttritionRate AS
(
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
),

Ranking AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            ORDER BY AttritionRate DESC
        ) AS Ranking
    FROM AttritionRate
)

SELECT *
FROM Ranking
WHERE Ranking <=3;


/*====================================================================
SECTION 6 : SALARY QUARTILES
====================================================================*/

WITH SalaryQuartile AS
(
    SELECT

        EmployeeID,
        Department,
        JobRole,
        MonthlyIncome,

        NTILE(4) OVER
        (
            ORDER BY MonthlyIncome DESC
        ) AS SalaryQuartile

    FROM hr_analytics_cleaned
)

SELECT
    SalaryQuartile,

    COUNT(*) AS Employees,

    ROUND(AVG(MonthlyIncome),2) AS AvgSalary

FROM SalaryQuartile
GROUP BY SalaryQuartile
ORDER BY SalaryQuartile;

/*====================================================================
SECTION 7 : HIGH-RISK EMPLOYEE IDENTIFICATION
====================================================================*/

-- Identify employees who are at high risk of attrition

SELECT
    EmployeeID,
    Department,
    JobRole,
    MonthlyIncome,
    TotalWorkingYears,
    YearsSinceLastPromotion,
    JobSatisfaction
FROM hr_analytics_cleaned
WHERE TotalWorkingYears > 10
    AND YearsSinceLastPromotion > 3
    AND MonthlyIncome <
        (
            SELECT AVG(MonthlyIncome)
            FROM hr_analytics_cleaned
        )
    AND JobSatisfaction <= 2;


/*====================================================================
SECTION 8 : HIGH-RISK EMPLOYEES BY DEPARTMENT
====================================================================*/

SELECT
    Department,
    COUNT(*) AS HighRiskEmployees
FROM hr_analytics_cleaned
WHERE TotalWorkingYears > 10
    AND YearsSinceLastPromotion > 3
    AND MonthlyIncome <
        (
            SELECT AVG(MonthlyIncome)
            FROM hr_analytics_cleaned
        )
    AND JobSatisfaction <= 2
GROUP BY Department
ORDER BY HighRiskEmployees DESC;


/*====================================================================
SECTION 9 : HIGH-RISK EMPLOYEES BY JOB ROLE
====================================================================*/

SELECT
    JobRole,
    COUNT(*) AS HighRiskEmployees,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM hr_analytics_cleaned
            WHERE TotalWorkingYears > 10
                AND YearsSinceLastPromotion > 3
                AND MonthlyIncome <
                    (
                        SELECT AVG(MonthlyIncome)
                        FROM hr_analytics_cleaned
                    )
                AND JobSatisfaction <= 2
        ),
        2
    ) AS RiskPercentage
FROM hr_analytics_cleaned
WHERE TotalWorkingYears > 10
    AND YearsSinceLastPromotion > 3
    AND MonthlyIncome <
        (
            SELECT AVG(MonthlyIncome)
            FROM hr_analytics_cleaned
        )
    AND JobSatisfaction <= 2
GROUP BY JobRole
ORDER BY HighRiskEmployees DESC;


/*====================================================================
SECTION 10 : DEPARTMENT RISK SCORE
====================================================================*/

WITH DepartmentMetrics AS
(
    SELECT
        Department,
        ROUND(
            COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
            *100.0/COUNT(*),
            2
        ) AS AttritionRate,
        ROUND(AVG(JobSatisfaction),2) AS AvgJobSatisfaction,
        ROUND(AVG(WorkLifeBalance),2) AS AvgWorkLifeBalance,
        ROUND(AVG(MonthlyIncome),2) AS AvgSalary
    FROM hr_analytics_cleaned
    GROUP BY Department
)

SELECT
    Department,
    AttritionRate,
    AvgJobSatisfaction,
    AvgWorkLifeBalance,
    AvgSalary,

    (
        CASE WHEN AttritionRate > 20 THEN 1 ELSE 0 END +
        CASE WHEN AvgJobSatisfaction < 2.75 THEN 1 ELSE 0 END +
        CASE WHEN AvgWorkLifeBalance < 2.75 THEN 1 ELSE 0 END +
        CASE
            WHEN AvgSalary <
            (
                SELECT AVG(MonthlyIncome)
                FROM hr_analytics_cleaned
            )
            THEN 1
            ELSE 0
        END
    ) AS DepartmentRiskScore

FROM DepartmentMetrics
ORDER BY DepartmentRiskScore DESC;


/*====================================================================
SECTION 11 : SALARY QUARTILE ATTRITION
====================================================================*/

WITH SalaryQuartile AS
(
    SELECT
        EmployeeID,
        Attrition,
        NTILE(4) OVER(ORDER BY MonthlyIncome DESC) AS SalaryQuartile
    FROM hr_analytics_cleaned
)

SELECT
    SalaryQuartile,

    COUNT(*) AS Employees,

    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate

FROM SalaryQuartile
GROUP BY SalaryQuartile
ORDER BY SalaryQuartile;


/*====================================================================
SECTION 12 : ROOT CAUSE ANALYSIS (MEDIUM SALARY GROUP)
====================================================================*/

WITH SalaryQuartile AS
(
    SELECT
        EmployeeID,
        JobRole,
        NTILE(4) OVER(ORDER BY MonthlyIncome DESC) AS SalaryQuartile
    FROM hr_analytics_cleaned
)

SELECT
    JobRole,
    COUNT(*) AS Employees
FROM SalaryQuartile
WHERE SalaryQuartile = 2
GROUP BY JobRole
ORDER BY Employees DESC;


/*====================================================================
SECTION 13 : TRAINING VS ATTRITION
====================================================================*/

SELECT
    Attrition,
    ROUND(
        AVG(TrainingTimesLastYear),
        2
    ) AS AverageTrainingSessions
FROM hr_analytics_cleaned
GROUP BY Attrition;


/*====================================================================
SECTION 14 : PROMOTION VS ATTRITION
====================================================================*/

SELECT
    JobRole,

    ROUND(
        AVG(YearsSinceLastPromotion),
        2
    ) AS AvgYearsSincePromotion,

    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate

FROM hr_analytics_cleaned

GROUP BY JobRole

ORDER BY AttritionRate DESC,
         AvgYearsSincePromotion DESC;


/*====================================================================
SECTION 15 : EXECUTIVE INSIGHTS
====================================================================*/

-- Departments with lower satisfaction and higher attrition

SELECT
    Department,

    ROUND(
        COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
        *100.0/
        COUNT(*),
        2
    ) AS AttritionRate,

    ROUND(AVG(JobSatisfaction),2) AS AvgJobSatisfaction,

    ROUND(AVG(WorkLifeBalance),2) AS AvgWorkLifeBalance,

    ROUND(AVG(MonthlyIncome),2) AS AvgMonthlyIncome

FROM hr_analytics_cleaned

GROUP BY Department

ORDER BY AttritionRate DESC,
         AvgJobSatisfaction ASC;


/*====================================================================
END OF SCRIPT

This script supports:

✔ Dashboard 4 – Executive Insights

Advanced SQL Concepts Demonstrated

• Common Table Expressions (CTEs)
• Window Functions
• ROW_NUMBER()
• NTILE()
• Ranking
• Aggregate Functions
• CASE Statements
• Correlated Subqueries
• Business Insights
• Executive Analytics

====================================================================*/
