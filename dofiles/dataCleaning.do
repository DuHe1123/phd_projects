clear all

*import data
import delimited "D:\Github Desktop\phd_projects\data\df_mergedWithCensus.csv"

rename regionid citycode
* Create derived variables 

* Persional income and domination
gen cons_per_capita = 社会消费品零售总额万元 / (户籍人口万人 * 10000)
gen ln_cons_per_capita = ln(cons_per_capita)
gen cons_gdp_ratio = 社会消费品零售总额万元 / 地区生产总值万元

* Medical and health security
gen hospital_beds_per1000 = 医院卫生院床位数张 / (户籍人口万人 * 10)

* Economic development and motivation
gen ln_gdp_per_capita = ln(人均地区生产总值元)
gen ln_total_gdp = ln(地区生产总值万元)

gen secondary_gdp_ratio = 第二产业增加值万元 / 地区生产总值万元
gen tertiary_gdp_ratio = 第三产业增加值万元 / 地区生产总值万元

gen rd_intensity = rd内部经费支出万元 / 地区生产总值万元
gen rd_workers_per10k = rd人员人 / (户籍人口万人)

gen invpat_grant_per10k = 发明专利授权数件 / 户籍人口万人

* Labor market
gen unemployment_rate = 年末城镇登记失业人员数人 / (户籍人口万人 * 10000)

gen private_emp_10k = 城镇私营和个体从业人员数人 / 10000
gen total_employment_10k = 城镇非私营单位从业人员数万人 + private_emp_10k
gen ln_employed_population = ln(total_employment_10k)
gen employment_rate = total_employment_10k / 户籍人口万人

* Social insurance
gen unemployment_insurance_coverage = 失业保险参保人数人 / (户籍人口万人 * 10000)
gen medical_insurance_coverage = 职工基本医疗保险参保人数人 / (户籍人口万人 * 10000)

sum ln_gdp_per_capita
gen ln_gdp_pc_c = ln_gdp_per_capita - r(mean)
gen ln_gdp_pc_c_sq = ln_gdp_pc_c^2

sum


* Save a temporary copy of 2020 overwork
preserve
keep if year == 2020
keep citycode ratiow 
rename ratiow overwork2020
tempfile overwork
save overwork, replace
restore

* Keep data from 2013 to 2019 for averaging
keep if year >= 2013 & year <= 2019

* Collapse to city-level means
* Keep only variables needed for collapse and citycode
keep citycode ///
    ln_cons_per_capita /// 
	cons_gdp_ratio ///
    hospital_beds_per1000 ///
	ln_gdp_per_capita ///
	ln_gdp_pc_c_sq /// 
    secondary_gdp_ratio ///
	tertiary_gdp_ratio ///
	rd_intensity /// 
	rd_workers_per10k ///
	invpat_grant_per10k /// 
	unemployment_rate /// 
	ln_employed_population ///
	employment_rate ///
	unemployment_insurance_coverage ///
	medical_insurance_coverage
	
* Now collapse city-level means
ds citycode, not
collapse (mean) `r(varlist)', by(citycode)

* Merge back with 2020 overwork
merge 1:1 citycode using overwork, keep(match) nogen

* Check colinearity
pwcorr ///    
    ln_cons_per_capita /// 
	cons_gdp_ratio ///
    hospital_beds_per1000 ///
	ln_gdp_per_capita ///
	ln_gdp_pc_c_sq /// 
    secondary_gdp_ratio ///
	tertiary_gdp_ratio ///
	rd_intensity /// 
	rd_workers_per10k ///
	invpat_grant_per10k /// 
	unemployment_rate /// 
	ln_employed_population ///
	employment_rate ///
	unemployment_insurance_coverage ///
	medical_insurance_coverage, sig
	
* Do regression
ds overwork2020 citycode ln_cons_per_capita employment_rate unemployment_insurance_coverage rd_workers_per10k, not
regress overwork2020 `r(varlist)'
vif 

* Drop multicolinearity issued variables
drop ln_cons_per_capita employment_rate unemployment_insurance_coverage rd_workers_per10k

* Export to csv
export delimited using "D:\Github Desktop\phd_projects\data\Dataset_MGWR.csv", replace