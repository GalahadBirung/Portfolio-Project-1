-- Select *
-- From PortfolioProject2.. CovidVaccination
--order by 3, 4

--Select Data that we are going to be using

--Select Location,date, total_cases, new_cases, total_deaths, population
--from PortfolioProject2.. CovidDeaths$
--order by 1, 2


--Select *
--from PortfolioProject2..CovidVaccination
--order by 3,4

--Select *
--from PortfolioProject2..CovidDeaths$
--order by 3,4

--Looking  at Total Cases vs Total Deaths 

--Select Location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject2.. CovidDeaths$
--Where location like '%State%'
--order by 1, 2

--Looking  at Total Cases vs Total Deaths 
--Shows what percentage of population got Covid

Select Location,date, Population, total_cases,(total_cases/population)*100 as Total_Cases_Percentage
from PortfolioProject2.. CovidDeaths$
Where location like '%State%'
order by 1, 2


--Looking at Countries with Highest Infection Rate compared to Population

Select Location,Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject2.. CovidDeaths$
--Where location like '%State%'
group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject2.. CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

--Let's break things Down by continent

Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject2.. CovidDeaths$
where continent is  null
group by location
order by TotalDeathCount desc



Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject2.. CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc


--Global numbers
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int)) / sum (new_cases) *100 as DeathPercentage
from PortfolioProject2.. CovidDeaths$
Where continent is not null
Group by date
order by 1, 2

--Global number not sorted by date
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int)) / sum (new_cases) *100 as DeathPercentage
from PortfolioProject2.. CovidDeaths$
Where continent is not null
--Group by date
order by 1, 2


--Using CovidVaccination

Select *
from PortfolioProject2.. CovidDeaths$ dea
join PortfolioProject2.. CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date


--Looking for Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject2.. CovidDeaths$ dea
Join PortfolioProject2.. CovidVaccination vac
On dea.location = vac.location
and dea.continent is not null
order by 2, 3

--Use Sum
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling_PeopleVaccinated
 From PortfolioProject2.. CovidDeaths$ dea
Join PortfolioProject2.. CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccicnation, Rolling_PopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location
, dea.date) as Rolling_PeopleVaccinated
from PortfolioProject2.. CovidDeaths$ dea
Join PortfolioProject2.. CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)

Select *, (Rolling_PopleVaccinated/Population) * 100
From PopvsVac



--Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location
, dea.date) as Rolling_PeopleVaccinated
from PortfolioProject2.. CovidDeaths$ dea
Join PortfolioProject2.. CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

Select *, (Rolling_PeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated



--Creating View to store data in some other time

Create View PPercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location
, dea.date) as Rolling_PeopleVaccinated
from PortfolioProject2.. CovidDeaths$ dea
Join PortfolioProject2.. CovidVaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3


Select *
from #PercentPopulationVaccinated