clear all

*import data
import delimited "D:\Github Desktop\phd_projects\data\df_mergedWithCensus.csv"

*generate new variable
gen lngdppc = log(人均地区生产总值)
gen lngdppc2 = lngdppc*lngdppc 

summarize lngdppc, meanonly
scalar lngdppc_mean = r(mean)
gen lngdppc_centered = lngdppc - lngdppc_mean
gen lngdppc2c = lngdppc_centered^2


gen lnvlpc = log(vl2m * 10000)
gen lnvlpc2 = lnvlpc * lnvlpc
gen unem = 年末城镇登记失业人员数人 / (户籍人口万人 *10000)
gen unemin = 失业保险参保人数人 / (户籍人口万人 *10000)
gen mi = 职工基本医疗保险参保人数 / (户籍人口万人 *10000)
gen conspc = 社会消费品零售总额 / (户籍人口万人 *10000) 
gen lncons = log(社会消费品零售总额)
gen wage = 城镇非私营单位在岗职工平均工资元
gen lnwage = log(城镇非私营单位在岗职工平均工资元)
gen lnconspc = log(conspc)
gen pat = 发明专利授权数件
gen pm25 = 细颗粒物pm25年平均浓度微克立方米

* regression candidates
reghdfe ratiow lngdppc lngdppc2 unem conspc, absorb(regionid year) cluster(regionid)
reghdfe ratiow lngdppc lngdppc2 unem conspc pat, absorb(regionid year) cluster(regionid)
reghdfe ratiow lngdppc lngdppc2 unem conspc pat pm25, absorb(regionid year) cluster(regionid)
*set panel
xtset regionid year

*generate growth rate
gen gr = lngdppc / L.lngdppc

*do regression
*with ratioW
reg ratiow lngdppc 
outreg2 using "D:\Github Desktop\phd_projects\results\tab01.tex", replace keep(ratiow lngdppc) ctitle(Pooled OLS) addstat(R2_a,e(r2_a)) addtext(Regional FE, NO, Year FE, NO) dec(3) label nocons nor2
reghdfe ratiow lngdppc, absorb(regionid year) cluster(regionid) 
outreg2 using "D:\Github Desktop\phd_projects\results\tab01.tex", append keep(ratiow lngdppc) ctitle(TWFE) addstat(R2_a,e(r2_a)) addtext(Regional FE, YES, Year FE, YES) dec(3) label nocons nor2
reg ratiow lngdppc lngdppc2
outreg2 using "D:\Github Desktop\phd_projects\results\tab01.tex", append keep(ratiow lngdppc lngdppc2) ctitle(Pooled OLS) addstat(R2_a,e(r2_a)) addtext(Regional FE, NO, Year FE, NO) dec(3) label nocons nor2
reghdfe ratiow lngdppc lngdppc2, absorb(regionid year) cluster(regionid)
outreg2 using "D:\Github Desktop\phd_projects\results\tab01.tex", append keep(ratiow lngdppc lngdppc2) ctitle(TWFE) addstat(R2_a,e(r2_a)) addtext(Regional FE, YES, Year FE, YES) dec(3) label nocons nor2

*with intensityW
reg intensityw lngdppc 
outreg2 using "D:\Github Desktop\phd_projects\results\tab02.tex", replace keep(intensityw lngdppc) ctitle(Pooled OLS) addstat(R2_a,e(r2_a)) addtext(Regional FE, NO, Year FE, NO) dec(3) label nocons nor2
reghdfe intensityw lngdppc, absorb(regionid year) cluster(regionid) 
outreg2 using "D:\Github Desktop\phd_projects\results\tab02.tex", append keep(intensityw lngdppc) ctitle(TWFE) addstat(R2_a,e(r2_a)) addtext(Regional FE, YES, Year FE, YES) dec(3) label nocons nor2
reg intensityw lngdppc lngdppc2
outreg2 using "D:\Github Desktop\phd_projects\results\tab02.tex", append keep(intensityw lngdppc lngdppc2) ctitle(Pooled OLS) addstat(R2_a,e(r2_a)) addtext(Regional FE, NO, Year FE, NO) dec(3) label nocons nor2
reghdfe intensityw lngdppc lngdppc2, absorb(regionid year) cluster(regionid)
outreg2 using "D:\Github Desktop\phd_projects\results\tab02.tex", append keep(intensityw lngdppc lngdppc2) ctitle(TWFE) addstat(R2_a,e(r2_a)) addtext(Regional FE, YES, Year FE, YES) dec(3) label nocons nor2

