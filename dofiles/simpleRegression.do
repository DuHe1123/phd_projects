clear all

*import data
import delimited "D:\Github Desktop\phd_projects\data\gdf.csv"

*generate new variable
gen lngdppc = log(gdp_percapita)
gen lngdppc2 = lngdppc*lngdppc

*set panel
xtset regionid year

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

