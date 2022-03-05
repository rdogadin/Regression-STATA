clear

use "OLS dataset.dta" 

corr immig_rate lsoc_expend gdp_growth lppp inf_mortality inflation life_expect unemployment fertility labor_partic muslim construction agriculture

* run the regression
reg immig_rate lsoc_expend gdp_growth lppp inf_mortality inflation life_expect unemployment fertility labor_partic muslim construction agriculture

**********************************************************
******************* Model Specification ******************
**********************************************************
* run model specification link test
linktest

* Ramsey RESET test 
ovtest

**********************************************************
*************** check for multicollinearity **************
**********************************************************
reg immig_rate gdp_growth lppp inf_mortality inflation unemployment fertility labor_partic muslim construction agriculture
* check for multicollinearity using the variance inflation factor
vif

**********************************************************
******** Check for unusual and influential data **********
**********************************************************

************** check for outliers ************************
* derive the studentized residuals
predict r, rstudent

* examine the residuals with a stem and leaf plot
stem r

* list countries with high z values
list r country if abs(r) > 2

*************** check for leverage ***********************
reg immig_rate gdp_growth lppp inf_mortality inflation unemployment fertility labor_partic muslim construction agriculture

* derive the leverage variable
predict lev, leverage

* examine the leverage with a stem and leaf plot
stem lev

* derive leverage point
g lev_point = (2*10+2)/31

* label the new variable
label var lev_point "Leverage point"

* list observations with high leverage
list country lev if lev > lev_point

* plot potential influential observations and outliers
lvr2plot, mlabel(country) name(Influencers, replace)

drop if inlist(country,"Iceland", "Cyprus", "Luxembourg", "Ireland")

**********************************************************
*********** check for normality of residuals *************
**********************************************************
reg immig_rate gdp_growth lppp inf_mortality inflation unemployment fertility labor_partic muslim construction agriculture
* predict
predict uhat, resid

* generate a density plot of residuals
kdensity uhat, normal name(Kdensity, replace)

* do another test for normality
swilk uhat

**********************************************************
******** Checking Heteroscedasticity of Residuals **********
**********************************************************
reg immig_rate gdp_growth lppp inf_mortality inflation unemployment fertility labor_partic muslim construction agriculture

* Plot residuals 
rvfplot, yline(0) name(Residuals, replace)

* Breusch-Pagan test 
hettest

corr immig_rate gdp_growth lppp inf_mortality inflation unemployment fertility labor_partic muslim construction agriculture
