SELECT *
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL
ORDER By 3,4;

SELECT *
FROM PortfolioProject.Covidvaccinations
ORDER By 3,4;

-- Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.Coviddeaths;

-- Looking at Total Case VS Total Deaths
-- (Shows the likelihood of dying if you contract COVID)

SELECT Location, date, population, MAX(total_cases), total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.Coviddeaths
Where location like '%United States%';


-- Looking at Total Case VS Population
-- (Shows what percentage of population contract COVID)

SELECT Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject.Coviddeaths
Where location like '%United Kingdom%';

-- Looking at countries with Highest Infection Rate compared to Population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject.Coviddeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC; 

-- Trying to understand what it the total infected cases by each country
SELECT Location, MAX(cast(total_cases as UNSIGNED)) as highest_case_count
FROM PortfolioProject.Coviddeaths
GROUP BY Location;

-- Arranging by country with maximun number of infected people
SELECT Location, MAX(cast(total_cases as UNSIGNED)) as highest_case_count
FROM PortfolioProject.Coviddeaths
GROUP BY Location
ORDER BY highest_case_count DESC;

SELECT Location, MAX(cast(total_cases as UNSIGNED)) as highest_case_count
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY highest_case_count DESC;

-- Looking at Countries with Hightest death count per population
SELECT Location, MAX(cast(total_deaths as UNSIGNED)) as highest_death_count
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY highest_death_count DESC;

-- Looking at Countries with Hightest death count per population

SELECT Location, population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as PercentPopulationDeath
FROM PortfolioProject.Coviddeaths
GROUP BY Location, Population
ORDER BY PercentPopulationDeath DESC;

-- Or use the below query

SELECT Location, MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Lets break things down by continent

-- Showing the continents with the highest death count per population
-- This Syntax is Final
SELECT Location, MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
FROM PortfolioProject.Coviddeaths
WHERE Location IN ('World','Asia','Europe', 'North America', 'South America', 'Africa', 'Oceania', 'International', 'European Union')GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Showing the countries with the highest death count per population
SELECT Location, MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
FROM PortfolioProject.Coviddeaths
WHERE Location NOT IN ('World','Asia','Europe', 'North America', 'South America', 'Africa', 'Oceania', 'International', 'European Union')GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- 

SELECT continent, MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL and Continent NOT IN ('')
GROUP BY continent
ORDER BY TotalDeathCount DESC; 




-- Global Numbers

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.Coviddeaths
Where Continent IS NOT NULL; 


-- Looking at total deaths accross the world (Overall)
SELECT Sum(new_cases) as New_TotalCases, Sum(new_deaths) as New_TotalDeaths, Sum(new_deaths)/Sum(new_cases)*100 as New_DeathPercentage 
FROM PortfolioProject.Coviddeaths
WHERE Continent IS NOT NULL;


-- Looking at Total Population vs Vaccinations	
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date;


-- Looking at Total number of vaccinations being administered
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date;

-- Looking at how many people in a country are vaccinated


-- USE CTE

With PopvsVac (Continent, Location, Data, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
)
SELECT *
FROM PopvsVac;


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date;


With PopvsVac (Continent, Location, Data, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;




-- TEMP TABLE

Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated;




