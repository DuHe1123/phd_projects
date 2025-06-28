clear all

*import data
import delimited "D:\Github Desktop\phd_projects\data\Dataset_MGWR.csv"

*drop far away regions
drop if citycode == 650100 | citycode == 650200

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
