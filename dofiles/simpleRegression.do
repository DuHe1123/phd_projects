clear all

*import data
import delimited "D:\Github Desktop\phd_projects\data\Dataset_MGWR.csv"

*drop far away regions
drop if citycode == 650100 | citycode == 650200

*replace intensityw = log(intensityw)

*set global var
global yvar intensityw 
global xvar ln_avg_wage ln_avg_wage_c_sq /// 
secondary_gdp_ratio tertiary_gdp_ratio /// 
cons_gdp_ratio hospital_beds_per10k gdp_growth pop_density invest_gdp_ratio ln_edu_exp_pc univ_students_per10k rd_intensity invpat_grant_per10k unemployment_rate ln_employed_population medical_insurance_coverage

*do summarize 
* Drop if missing y variable
drop if missing(${yvar})

* Drop if missing any of the x variables
foreach var of global xvar {
    drop if missing(`var')
}

* summarize
summarize

*run ols
reg ${yvar} ${xvar}

reg ${yvar} ln_avg_wage ln_avg_wage_c_sq








* Standardize y
summarize ${yvar}
gen z_${yvar} = (${yvar} - r(mean)) / r(sd)

* Standardize all x variables
foreach var of global xvar {
    summarize `var'
    gen z_`var' = (`var' - r(mean)) / r(sd)
}

* Run standardized OLS: with all controls
reg z_${yvar} ///
    z_ln_avg_wage z_ln_avg_wage_c_sq ///
    z_secondary_gdp_ratio z_tertiary_gdp_ratio ///
    z_cons_gdp_ratio z_hospital_beds_per10k z_gdp_growth ///
    z_pop_density z_invest_gdp_ratio z_ln_edu_exp_pc ///
    z_univ_students_per10k z_rd_intensity z_invpat_grant_per10k ///
    z_unemployment_rate z_ln_employed_population /// 
	z_medical_insurance_coverage, r
	
display "Adjusted R-squared = " e(r2_a)

* Run standardized OLS: without controls
reg z_${yvar} z_ln_avg_wage z_ln_avg_wage_c_sq, r 

display "Adjusted R-squared = " e(r2_a)
