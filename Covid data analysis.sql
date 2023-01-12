select *
from PortfolioProject..coviddeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..covidvaccinations
--where continent is not null
--order by 3,4

--selecting data to be used

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..coviddeaths
where continent is not null
order by 1,2

-- Looking at the total cases vs total deaths
-- shows the likelihood of dying if you contract covid in India
select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..coviddeaths
where Location like '%india%' and continent is not null
order by 1,2


-- looking at the total cases vs population
-- shows what % of population got covid

select Location, date, Population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..coviddeaths
--where Location like '%india%'
where continent is not null
order by 1,2

-- looking at countries with highest infection rates compared to population

select Location, Population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..coviddeaths
--where Location like '%india%'
where continent is not null
group by Location, Population
order by PercentPopulationInfected desc

--showing the countries with highest death count per population

select Location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..coviddeaths
--where Location like '%india%'
where continent is not null
group by Location
order by TotalDeathCount desc

-- breaking things down by continent

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..coviddeaths
--where Location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..coviddeaths
--where Location like '%india%'
where continent is null
group by location
order by TotalDeathCount desc


-- showing the continents with the highest death count per population

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..coviddeaths
--where Location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers 

select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..coviddeaths 
--where Location like '%india%' and
where continent is not null
--group by date
order by 1,2


select * 
from PortfolioProject..covidvaccinations dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date

--looking at total pop vs vaccinations
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by 
dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

SET ANSI_WARNINGS OFF
GO
-- sum(cast(vac.new_vaccinations as int)) or sum(convert(int,vac.new_vaccinations))

-- using cte

with PopvsVac (Continent, Location, Date, Population, New_vaccinations,
RollingPeopleVaccinated)
as 
(select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by 
dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null)
--order by 2,3
select * , (RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp Table
Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by 
dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
select * , (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- creating view to store data for later visualizations

create view PerecentPopulationVaccinated as 
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by 
dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PerecentPopulationVaccinated


