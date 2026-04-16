# COVID-19 Data Analysis (SQL Project)

This project analyzes global COVID-19 data using SQL to uncover trends in cases, deaths, and vaccinations.

## Objectives
- Analyze infection and death rates across countries
- Compare cases relative to population
- Identify countries with highest impact
- Track vaccination progress over time

## Key Insights

1) Countries show large differences in infection rate relative to population  
2) Death percentage varies significantly across regions  
3) Continents like Europe and North America show high total deaths  
4) Vaccination rollout trends highlight differences in healthcare response  

## Tools Used
- SQL (MySQL / SQL Server)
- Joins

## Example Analysis

- Total Cases vs Total Deaths
- Population vs Infection Rate
- Country-level rankings
- Rolling vaccination counts using window functions

## Dataset
- COVID Deaths
- COVID Vaccinations

SUM(new_deaths) AS TotalDeaths,
(SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject.Coviddeaths;
7. Vaccination Analysis (Join)
Combining deaths and vaccination data:
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date;
8. Rolling Vaccination Count (Window Function)
Tracking cumulative vaccinations:
SUM(vac.new_vaccinations)
OVER (PARTITION BY dea.location ORDER BY dea.date)
AS RollingPeopleVaccinated
9. CTE for Vaccination Percentage
WITH PopvsVac AS (
   SELECT dea.location, dea.population, vac.new_vaccinations,
   SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date)
   AS RollingPeopleVaccinated
   FROM PortfolioProject.CovidDeaths dea
   JOIN PortfolioProject.CovidVaccinations vac
   ON dea.location = vac.location
   AND dea.date = vac.date
)
SELECT *,
(RollingPeopleVaccinated/population)*100 AS VaccinatedPercentage
FROM PopvsVac;
10. Temporary Table for Analysis
CREATE TABLE PercentPopulationVaccinated (...)
Used to store intermediate results for further analysis.
📈 Key Insights
Countries vary significantly in infection and death rates
Higher population does not always correlate with higher infection percentage
Vaccination rollout differs widely across regions
Window functions help track vaccination progress over time
🚀 What I Learned
Writing complex SQL queries for real-world datasets
Using window functions for cumulative analysis
Leveraging CTEs and temporary tables for cleaner workflows
Transforming raw data into meaningful insights
📌 Future Improvements
Create dashboards using Tableau / Power BI
Add data visualisations
Automate data pipeline
Include time-series trend analysis

📎 Author
Mustafa Khalid
