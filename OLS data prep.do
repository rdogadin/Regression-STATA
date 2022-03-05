cd /Users/rdogadin/Desktop/Metrics/Paper/CSV/Test

clear

import delimited "exp_soc.csv", varnames(1)
save exp_soc.dta, replace

clear

import delimited "gdp_growth.csv", varnames(1)
save gdp_growth.dta, replace

clear

import delimited "gdp_per_capita.csv", varnames(1)
save gdp_per_capita.dta, replace

clear

import delimited "immigration.csv", varnames(1)
save immigration.dta, replace

clear

import delimited "inf_mortality.csv", varnames(1)
save inf_mortality.dta, replace

clear

import delimited "inflation.csv", varnames(1)
save inflation.dta, replace

clear

import delimited "life_expect.csv", varnames(1)
save life_expect.dta, replace

clear

import delimited "population.csv", varnames(1)
save population.dta, replace

clear

import delimited "unemployment.csv", varnames(1)
save unemployment.dta, replace

clear

import delimited "construction.csv", varnames(1)
save construction.dta, replace

clear

import delimited "agriculture.csv", varnames(1)
save agriculture.dta, replace

clear

import delimited "fertility.csv", varnames(1)
replace country = "Austria" if country == "AUT"
replace country = "Belgium" if country == "BEL"
replace country = "Bulgaria" if country == "BGR"
replace country = "Switzerland" if country == "CHE"
replace country = "Cyprus" if country == "CYP"
replace country = "Czechia" if country == "CZE"
replace country = "Germany" if country == "DEU"
replace country = "Denmark" if country == "DNK"
replace country = "Spain" if country == "ESP"
replace country = "Estonia" if country == "EST"
replace country = "Finland" if country == "FIN"
replace country = "France" if country == "FRA"
replace country = "United Kingdom" if country == "GBR"
replace country = "Greece" if country == "GRC"
replace country = "Croatia" if country == "HRV"
replace country = "Hungary" if country == "HUN"
replace country = "Ireland" if country == "IRL"
replace country = "Iceland" if country == "ISL"
replace country = "Italy" if country == "ITA"
replace country = "Lithuania" if country == "LTU"
replace country = "Luxembourg" if country == "LUX"
replace country = "Latvia" if country == "LVA"
replace country = "Malta" if country == "MLT"
replace country = "Netherlands" if country == "NLD"
replace country = "Norway" if country == "NOR"
replace country = "Poland" if country == "POL"
replace country = "Portugal" if country == "PRT"
replace country = "Romania" if country == "ROU"
replace country = "Slovakia" if country == "SVK"
replace country = "Slovenia" if country == "SVN"
replace country = "Sweden" if country == "SWE"

save fertility.dta, replace

clear 

import delimited "labor_partic.csv", varnames(1)
replace country = "Austria" if country == "AUT"
replace country = "Belgium" if country == "BEL"
replace country = "Bulgaria" if country == "BGR"
replace country = "Switzerland" if country == "CHE"
replace country = "Cyprus" if country == "CYP"
replace country = "Czechia" if country == "CZE"
replace country = "Germany" if country == "DEU"
replace country = "Denmark" if country == "DNK"
replace country = "Spain" if country == "ESP"
replace country = "Estonia" if country == "EST"
replace country = "Finland" if country == "FIN"
replace country = "France" if country == "FRA"
replace country = "United Kingdom" if country == "GBR"
replace country = "Greece" if country == "GRC"
replace country = "Croatia" if country == "HRV"
replace country = "Hungary" if country == "HUN"
replace country = "Ireland" if country == "IRL"
replace country = "Iceland" if country == "ISL"
replace country = "Italy" if country == "ITA"
replace country = "Lithuania" if country == "LTU"
replace country = "Luxembourg" if country == "LUX"
replace country = "Latvia" if country == "LVA"
replace country = "Malta" if country == "MLT"
replace country = "Netherlands" if country == "NLD"
replace country = "Norway" if country == "NOR"
replace country = "Poland" if country == "POL"
replace country = "Portugal" if country == "PRT"
replace country = "Romania" if country == "ROU"
replace country = "Slovakia" if country == "SVK"
replace country = "Slovenia" if country == "SVN"
replace country = "Sweden" if country == "SWE"

save labor_partic.dta, replace

clear 
use immigration.dta

merge 1:1 country using exp_soc.dta
drop _merge

merge 1:1 country using gdp_growth.dta
drop _merge

merge 1:1 country using gdp_per_capita.dta
drop _merge

merge 1:1 country using inf_mortality.dta
drop _merge

merge 1:1 country using inflation.dta
drop _merge

merge 1:1 country using life_expect.dta
drop _merge

merge 1:1 country using population.dta
drop _merge

merge 1:1 country using unemployment.dta
drop _merge

merge 1:1 country using fertility.dta
drop _merge

merge 1:1 country using labor_partic.dta
drop _merge

merge 1:1 country using muslim.dta
drop _merge

merge 1:1 country using construction.dta
drop _merge

merge 1:1 country using agriculture.dta
drop _merge

* cleanup
replace immigration = "" if immigration == ":"
replace soc_expend = "" if soc_expend == ":"
replace gdp_growth = "" if gdp_growth == ":"
replace gdp_per_capita = "" if gdp_per_capita == ":"
replace inf_mortality = "" if inf_mortality == ":"
replace inflation = "" if inflation == ":"
replace life_expect = "" if life_expect == ":"
replace population = "" if population == ":"
replace unemployment = "" if unemployment == ":"

replace immigration = subinstr(immigration,",","",.)
replace soc_expend = subinstr(soc_expend,",","",.)
replace gdp_growth = subinstr(gdp_growth,",","",.)
replace gdp_per_capita = subinstr(gdp_per_capita,",","",.)
replace inf_mortality = subinstr(inf_mortality,",","",.)
replace inflation = subinstr(inflation,",","",.)
replace life_expect = subinstr(life_expect,",","",.)
replace population = subinstr(population,",","",.)
replace unemployment = subinstr(unemployment,",","",.)

* convert strings to numeric
destring immigration soc_expend gdp_growth gdp_per_capita inf_mortality inflation life_expect population unemployment labor_partic fertility muslim construction agriculture, replace

* drop Liechtenstein - too many values missing
drop if missing(immigration) | country == "Liechtenstein"

* generate new var with mean unemployment
egen missrev = mean(unemployment)

* replace missing values for unempl with the mean
replace unemployment = missrev if missing(unemployment)

* round to the first decimal
replace unemployment = round(unemployment,0.1)

* drop the mean
drop missrev

* round soc_expend
replace soc_expend = round(soc_expend)

* create the immigration rate variable
gen immig_rate = round((immigration/population)*100,0.1)

* create log variables
g lppp = log(gdp_per_capita)
g lsoc_expend = log(soc_expend)

* label variables
label var country "Country name"
label var immigration "Number of immigrants in the year"
label var soc_expend "Expenditure on social protection per inhabitant"
label var gdp_growth "GDP growth rate"
label var gdp_per_capita "GDP per capita"
label var inf_mortality "Infant mortality rate"
label var inflation "Inflation rate"
label var life_expect "Life expectancy, in years"
label var population "Country population"
label var unemployment "Unemployment rate"
label var fertility "Fertility rate"
label var labor_partic "Labor participation rate"
label var immig_rate "Immigration rate"
label var muslim "Muslim population rate"
label var lppp "Log of GDP per capita"
label var lsoc_expend "Log of expenditure on social protection per inhabitant"
label var construction "Share of construction in GDP"
label var agriculture "Share of agriculture in GDP"

* save the final dataset
save final_dataset, replace
