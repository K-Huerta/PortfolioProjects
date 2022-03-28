

--COVID DATA that we will be looking at -- 

select top 100*
from covid_deaths$
order by 3

select top 100* 
from covid_vacc$
order by 3



Select distinct(location)
from covid_deaths$

Select distinct(continent)
from covid_deaths$

select distinct(location)
from covid_deaths$
where continent is NULL

-- When Continent column is NUll it autopopulated the Location column with a 'continent'
-- 'where continent is NOT NULL' Omits values that had a Continent in the location column 
Select location , date, total_cases, new_cases, total_deaths, population
from covid_deaths$
where continent is NOT NULL
order by 1,2


--Total cases vs total deaths 
-- Probability of death if you contract COVID
Select location , date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths$
where continent is NOT NULL
order by 1,2

-- U.S death percentage 
Select location , date, new_cases, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths$
where location like '%state%'
order by 1,2


---Total Case vs Population , Percentage of U.S population that has contracted COVID
Select location , date, total_cases,population, (total_cases/population)*100 as PopulationInfected
from covid_deaths$
where location like '%state%'
order by 1,2


--Countries that have the highest Infection rate 
Select location, MAX(total_cases),population, MAX((total_cases/population))*100 as PopulationInfected
from covid_deaths$
where continent is NOT NULL
group by location, population
order by 4 desc

--Countries with the highest death count 
Select location ,MAX(CAST(total_deaths as int)) as Total_DeatCount
from covid_deaths$
where continent is not NULL
group by location
order by 2 desc

--Continents with the highest death count
Select location ,MAX(CAST(total_deaths as int))as TotalDeathCount
from covid_deaths$
where continent is NULL
group by location
order by 2 desc


-- Global Numbers
Select
SUM(new_cases) as TotalCases,
SUM(cast(new_deaths as int))as TotalDeaths,
SUM(cast(new_deaths as int))/nullif(sum(new_cases),0)*100 as DeathPercentage
from covid_deaths$
order by 1,2

Select date,
SUM(new_cases) as TotalCases,
SUM(cast(new_deaths as int)) as TotalDeaths,
SUM(cast(new_deaths as int))/nullif(sum(new_cases),0)*100 as DeathPercentage
from covid_deaths$
group by date
order by 1,2


--- Table we are also looking at Covid_Vacc

select top 100* 
from covid_vacc$


--Joining Covid_Deaths and Covid_Vacc
Select top 100*
from covid_deaths$ D
JOIN covid_vacc$ V
	on d.location=v.location
	and d.date=v.date


--Global PeopleVaccinated rate

Select d.continent,d.location,d.date,d.population,v.new_vaccinations,
SUM(Convert(bigint,v.new_vaccinations)) OVER (Partition by d.location)
from covid_deaths$ d
JOIN covid_vacc$ v
	on d.location=v.location
	and d.date=v.date
where d.continent is not null 
order by 2,3

--Global Population Vaccination  , rolling count 
Select d.continent,d.location,d.date,d.population,v.new_vaccinations,
SUM(Convert(bigint,v.new_vaccinations)) OVER (Partition by d.location order by d.location,d.date) as RollinCountPplVacc
from covid_deaths$ d
JOIN covid_vacc$ v
	on d.location=v.location
	and d.date=v.date
where d.continent is not null 
order by 2,3



--Creating VIEW to make Dashboards/Visualizations 

create view DeathCountperCountry as
Select location ,MAX(CAST(total_deaths as int)) as Total_DeatCount
from covid_deaths$
where continent is not NULL
group by location






--CTE example 

WITH PopulationVacc(Continent, location, date, population, new_vaccinations, RollingCountPplVacc)
as 
(Select d.continent,d.location,d.date,d.population,v.new_vaccinations,
SUM(Convert(bigint,v.new_vaccinations)) OVER (Partition by d.location order by d.location,d.date) as RollinCountPplVacc
from covid_deaths$ d
JOIN covid_vacc$ v
	on d.location=v.location
	and d.date=v.date
where d.continent is not null )
Select * , (RollingCountPplVacc/population)*100
from PopulationVacc