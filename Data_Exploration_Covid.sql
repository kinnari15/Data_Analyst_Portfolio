SELECT *
FROM [portfolio project].dbo.CovidDeaths$
order by 3,4

--SELECT *
--FROM [portfolio project].dbo.CovidVaccinations$
--order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [portfolio project].dbo.CovidDeaths$
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
SELECT Location, date, Max(total_cases) as HighestInfectionCount, Population, Max(total_deaths/total_cases) * 100 as CovidPercentage
FROM [portfolio project].dbo.CovidDeaths$
--WHERE location like '%india%'
group by Location, Population
order by CovidPercentage desc
