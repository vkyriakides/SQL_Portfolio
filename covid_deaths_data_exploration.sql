/* CREATED BY : VALERIA KYRIAKIDES
CREATE DATE: 08/02/2023
PURPOSE: DEMONSTRATE DATA EXPLORATION SKILLS ON SQL USING COVID-19 DATA
*/

-- Lookint at total cases vs. total deaths in the U.S. (what percentage of cases resutled in death?)
-- Demonstrates likelihood of death due to covid (in the U.S.)

SELECT
	total_cases,
    total_deaths,
    (total_deaths/total_cases)*100
FROM
	CovidDeaths
WHERE
	location LIKE '%states%'
ORDER BY
	location, date

-- Total cases vs. population in the U.S.
-- Demonstrates percentage of U.S. population that contracted covid
SELECT
	total_cases,
    population,
    (total_cases/population)*100
FROM
	CovidDeaths
WHERE
	location LIKE '%states%'
ORDER BY
	1,2
    
    
-- What countries have the highest rate of covid infection?

SELECT
	location,
    population,
    MAx(total_cases) AS HighestInfectionCount,
    MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM
	CovidDeaths
GROUP BY
	population,
    location
ORDER BY
	PercentPopulationInfected DESC
    
-- Looking at countries with the highest death rate due to covid 
-- converting total_deaths into integer

SELECT
	location,
    MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM
	CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
    location
ORDER BY
	TotalDeathCount DESC
    
-- Global numbers:

SELECT
	date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM
	CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	date
ORDER BY
	1,2
    
