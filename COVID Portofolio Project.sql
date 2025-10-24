-- Select data that we are going to be using

Select * from deaths
	where continent is not null
order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
from deaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select 
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	(total_deaths/total_cases)*100 as death_percentage
from deaths
	where location ILIKE '%indonesia%'
order by 1,2

-- Looking at the total cases vs population
-- Percentage of population got Covid
Select 
	location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 as case_percentage
from deaths
order by 1,2

-- Countries with highest infection rate compare to population
Select 
	location,
	population,
	MAX(total_cases) as highestinfectioncount,
	Max((total_cases/population))*100 as percentpopulationinfected
from deaths
group by location, population
order by percentpopulationinfected desc

-- Showing Countries with highest death count compare to population
Select 
	location,
	MAX(cast(total_deaths as int)) as TotalDeathCount
from deaths
	where continent is not null
group by location
order by TotalDeathCount desc

-- BY CONTINENT

-- Showing the continent with the highest death count
Select 
	continent,
	MAX(cast(total_deaths as int)) as TotalDeathCount
from deaths
	where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers
Select 
	SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from deaths
	where continent is not null
order by 1,2

-- Looking at Total Population vs Vaccinations
-- Total amount in the world that got vaccination

-- use CTE (Common Table Expression / semacam Temporary Table)
With PopvsVac (Continent,Location,Date,Population, New_Vaccinations, RollingPeopleVaccinated)
	as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	from deaths dea
	join vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
Select * , (RollingPeopleVaccinated/Population)*100
	from PopvsVac

-- Temp Table

DROP TABLE IF EXISTS PercentPopulationVaccinated;
-- 1️⃣ Buat tabel sementara dengan tipe data
CREATE TEMP TABLE PercentPopulationVaccinated (
    Continent VARCHAR(255),
    Location VARCHAR(255),
    Date TIMESTAMP,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- 2️⃣ Isi datanya dengan SELECT
INSERT INTO PercentPopulationVaccinated (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS NUMERIC)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM deaths dea
JOIN vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- 3️⃣ Ambil hasil akhirnya
SELECT *,
       (RollingPeopleVaccinated / Population) * 100 AS PercentVaccinated
FROM PercentPopulationVaccinated
ORDER BY Location, Date;

-- Create a view to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	from deaths dea
	join vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2,3


Select *
from PercentPopulationVaccinated

