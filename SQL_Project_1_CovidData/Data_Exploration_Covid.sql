SELECT *
FROM [portfolio project].dbo.CovidDeaths$
where continent is not null
order by 3,4

--SELECT *
--FROM [portfolio project].dbo.CovidVaccinations$
--where continent is not null
--order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [portfolio project].dbo.CovidDeaths$
where continent is not null
order by 1,2

--Shows likelihood of dying if you contract Covid in India
SELECT Location, date, total_cases, total_deaths, population,(total_deaths/total_cases) * 100 as DeathPercentage
FROM [portfolio project].dbo.CovidDeaths$
WHERE location like '%india%'
order by 1,2

--Total cases vs population - How much percentage of population got covid
SELECT Location, date, total_cases, population,(total_cases/population) * 100 as CovidPercentage
FROM [portfolio project].dbo.CovidDeaths$
--WHERE location like '%india%'
order by 1,2

--Looking at countries with highest infection rate compared to population
SELECT Location, population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population) * 100 as CovidPercentage
FROM [portfolio project].dbo.CovidDeaths$
--WHERE location like '%india%'
group by Location, Population
order by CovidPercentage desc

--Showing the countries with highest death count per population
SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM [portfolio project].dbo.CovidDeaths$
--WHERE location like '%india%'
where continent is not null
group by Location
order by TotalDeathCount desc

--Continentwise
SELECT location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM [portfolio project].dbo.CovidDeaths$
--WHERE location like '%india%'
where continent is not null
group by location
order by TotalDeathCount desc


--Showing continents with highest death count
SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount
FROM [portfolio project].dbo.CovidDeaths$
--WHERE location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers
SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int)) / SUM(cast(new_deaths as int)) as DeathPercentage
FROM [portfolio project].dbo.CovidDeaths$
--WHERE location like '%india%'
where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
From [portfolio project].dbo.CovidDeaths$ dea
Join [portfolio project].dbo.CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
order by 1,2,3

--CTE use
With PopsvsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
--partitioning the data 
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) * 100
From [portfolio project].dbo.CovidDeaths$ dea
Join [portfolio project].dbo.CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100
From PopsvsVac


--TEMP Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) * 100
From [portfolio project].dbo.CovidDeaths$ dea
Join [portfolio project].dbo.CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated

--Creating view to store data for later visualisation

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) * 100
From [portfolio project].dbo.CovidDeaths$ dea
Join [portfolio project].dbo.CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated