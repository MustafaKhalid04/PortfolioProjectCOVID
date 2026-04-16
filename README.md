🦠 COVID-19 Data Exploration using SQL
📌 Project Overview
This project explores global COVID-19 data using SQL to uncover key insights related to infection rates, death rates, and vaccination progress across countries and continents.
The analysis focuses on understanding trends in COVID-19 cases, mortality, and vaccination rollouts by leveraging SQL queries, aggregations, joins, and window functions.
📂 Dataset
The project uses two main datasets:
CovidDeaths – Contains data on cases, deaths, population, and location
CovidVaccinations – Contains vaccination data across countries
🎯 Objectives
Analyse COVID-19 infection and death trends
Compare infection rates across countries
Identify countries with the highest death counts
Evaluate vaccination progress globally
Use SQL techniques such as joins, CTEs, and window functions
🛠️ Tools & Technologies
SQL (MySQL / SQL Server compatible)
Data Cleaning & Transformation
Window Functions
Common Table Expressions (CTEs)
📊 Key Analysis & Queries
1. Data Exploration
Basic queries to inspect datasets and filter relevant data:
SELECT *
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL;
2. Case Fatality Rate
Understanding the likelihood of death after contracting COVID-19:
SELECT Location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.Coviddeaths;
3. Infection Rate vs Population
Percentage of population infected:
SELECT Location, population, MAX(total_cases),
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.Coviddeaths
GROUP BY Location, population;
4. Highest Infection Rates by Country
Identifies countries most impacted by COVID-19:
SELECT Location, MAX(total_cases) AS HighestInfectionCount
FROM PortfolioProject.Coviddeaths
GROUP BY Location
ORDER BY HighestInfectionCount DESC;
5. Death Count Analysis
Countries with highest total deaths:
SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;
6. Global Summary
Overall global COVID-19 statistics:
SELECT SUM(new_cases) AS TotalCases,
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
