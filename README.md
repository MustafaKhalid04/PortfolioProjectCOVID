![COVID-19 Data Analysis](https://images.unsplash.com/photo-1584036561566-baf8f5f1b144)

# COVID-19 Data Analysis (SQL Project)

This project analyzes global COVID-19 data using SQL to uncover trends in infections, deaths, and vaccination progress. The goal is to turn raw data into meaningful insights using structured queries and analytical techniques.

---

## Objectives
- Analyze infection and death rates across countries
- Compare COVID impact relative to population
- Identify countries with highest infection and death rates
- Track vaccination progress over time
- Apply advanced SQL techniques for real-world analysis

---

## Key Highlights:
- Countries show significant variation in infection rates relative to population
- Death percentages highlight differences in healthcare impact across regions
- Continent-level analysis reveals areas with the highest total deaths
- Vaccination trends using rolling totals show progress over time

---

## Tools Used
- SQL (MySQL / SQL Server)
- Joins
- Aggregations
- Window Functions
- Common Table Expressions (CTEs)
- Temporary Tables

---

## SQL Analysis

### 1. Global Death Percentage
```sql
SUM(new_deaths) AS TotalDeaths,
(SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject.Coviddeaths;
