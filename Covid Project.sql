select *
from vaccinations
order by 3,4

select *
from covid_death



SELECT location,date,total_cases,new_cases,total_deaths,population
FROM covid_death
order by 1,2

--looking at total cases vs total death
--shows likelihood of dying if you contract covid in Egypt
SELECT location,date,total_cases,total_deaths, (CONVERT(float,total_deaths)/ NULLIF(CONVERT(float,total_cases),0)) * 100 as DeathPercentage
FROM covid_death
WHERE location like '%egy%'
order by 1,2

--looking at total cases vs population
SELECT location, date, total_cases, population, (total_cases/population)*100 as PercentageOfCases
FROM covid_death
where location = 'Egypt'
order by location,date

--looking at countries with highest infection rate compared to population
SELECT continent,location, population, MAX(total_cases) as TotalCases,(MAX(total_cases)/population)*100 as RateOfInfection
FROM covid_death
GROUP BY continent,location,population
ORDER BY RateOfInfection DESC


--showing countries with highest death count per population
SELECT location,population,MAX(CAST(total_deaths AS INT)) as TotalDeathCount, (MAX(total_deaths)/population)*100 as PercentageOfDeath
FROM covid_death
where continent is not null
GROUP BY location,population
ORDER BY TotalDeathCount DESC


--Breaking things down by continent
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeath
FROM covid_death
where continent is not null
GROUP BY continent
ORDER BY TotalDeath DESC


--Global numbers
SELECT sum(new_cases) as TotalCases, sum(CAST(new_deaths AS INT)) as TotalDeath
FROM covid_death
WHERE continent is not null
--GROUP BY date
ORDER BY 1


--looking at total population vs vaccinations
--using bigint here because using int made the variable overflow
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) AS PeopleVaccinated
FROM covid_death dea JOIN
covid_vaccinations vac ON
dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--USING CTE
WITH PopulationVsVacc(continent, location, date, population, new_vaccinations, PeopleVaccinated)
AS (
SELECT  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) AS PeopleVaccinated
FROM covid_death dea JOIN
covid_vaccinations vac ON
dea.date = vac.date
and dea.location = dea.location
WHERE dea.continent is not null
--ORDER BY 3
)
SELECT *
FROM PopulationVsVacc 

--temp taple

DROP Table if exists #PercentPopulationVacc
Create TABLE #PercentPopulationVacc(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric)

INSERT INTO #PercentPopulationVacc
SELECT  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) AS PeopleVaccinated
FROM covid_death dea JOIN
covid_vaccinations vac ON
dea.date = vac.date
and dea.location = dea.location
WHERE dea.continent is not null

SELECT *,(PeopleVaccinated/population)*100 
FROM #PercentPopulationVacc


--creating view to store data for visualizations

CREATE VIEW ContinentDeath
as
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeath
FROM covid_death
where continent is not null
GROUP BY continent

SELECT *
FROM ContinentDeath

--creating view looking at total population vs vaccinations
CREATE VIEW PopulationVaccinated as
SELECT  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) AS PeopleVaccinated
FROM covid_death dea JOIN
covid_vaccinations vac ON
dea.date = vac.date
and dea.location = dea.location
WHERE dea.continent is not null