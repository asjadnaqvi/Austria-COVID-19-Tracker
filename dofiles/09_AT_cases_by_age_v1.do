clear


// install the schemes and packages
*ssc install colorpalette, replace
*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme white_tableau
graph set window fontface "Arial Narrow"


cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"

use ./master/austria_covid19_by_agegender.dta, clear

ren total_infected cases 

sort province gender agegrp date

bysort province gender agegrp: gen cases_daily = cases - cases[_n-1]

bysort province gender agegrp: gen cases_daily_ma = (cases_daily[_n-3] + cases_daily[_n-2] + cases_daily[_n-1] + cases_daily[_n] + cases_daily[_n+1] + cases_daily[_n+2] + cases_daily[_n+3]) / 7


twoway ///
	(line cases_daily date if gender==1) ///
	(line cases_daily date if gender==2) ///
		if province=="Österreich", ///
			by(, legend(off)) by(agegrp, yrescale)



twoway ///
	(line cases_daily_ma date if gender==1) ///
	(line cases_daily_ma date if gender==2) ///
		if province=="Österreich", ///
			by(, legend(off)) by(agegrp, yrescale)			
			
			
gen cases_daily_per100k 	= (cases_daily 		/ pop) * 100000
gen cases_daily_ma_per100k 	= (cases_daily_ma 	/ pop) * 100000





*reshape wide total_infected total_recovered total_dead pop, i(date agegrp province ) j(gender)

/*
summ date 
local xmin = `r(min)'
local xmax = `r(max)'


heatplot cases_daily_per100k i.agegrp date if province=="Wien", ///
	levels(20) color(, reverse) p(lc(white) lw(0.04)) ///
	xtitle("") /// 
	ramp(bottom length(80) space(10) subtitle("")) by(gender, note("") ) ///
	xlabel(`xmin'(30)`xmax', labsize(2) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
	xsize(2) ysize(1) ///
	title("Daily cases per 100k population - Vienna")
*/



summ date 
local xmin = `r(min)'
local xmax = `r(max)'	

heatplot cases_daily_per100k i.agegrp date if province=="Österreich", ///
	levels(20) color(inferno) xbins(100) p(lalign(center)) ///  // p(lc(black) lalign(center) lw(0.01))
	xtitle("") /// 
	ramp(bottom length(80) space(8) subtitle("")) ///
	xlabel(`xmin'(30)`xmax', labsize(2) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
	xsize(2) ysize(1) ///
	title("Daily cases per 100k population - Austria")

	graph export "figures/AT_cases_by_agegender_overall.png", replace wid(2000)		


summ date 
local xmin = `r(min)'
local xmax = `r(max)'	

heatplot cases_daily_ma_per100k i.agegrp date if province=="Österreich", ///
	levels(20) color(inferno) xbins(100) p(lalign(center)) ///  // p(lc(black) lalign(center) lw(0.01))
	xtitle("") /// 
	ramp(bottom length(80) space(8) subtitle("")) ///
	xlabel(`xmin'(30)`xmax', labsize(2) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
	xsize(2) ysize(1) ///
	title("Daily cases per 100k population - Austria")

	graph export "figures/AT_cases_ma_by_agegender_overall.png", replace wid(2000)		
	
	
	
	
summ date 
local xmin = `r(min)'
local xmax = `r(max)'	
	
levelsof province, local(lvls)

foreach x of local lvls {
	
	heatplot cases_daily_per100k i.agegrp date if province=="`x'", ///
	levels(20) color(inferno) xbins(100) p(lalign(center)) ///
	xtitle("") /// 
	ramp(bottom length(80) space(8) subtitle("")) by(gender, note("") ) ///
	xlabel(`xmin'(30)`xmax', labsize(2) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
	xsize(2) ysize(1) ///
	title("Daily cases per 100k population - `x'")
	
	graph export "figures/AT_cases_by_agegender_`x'.png", replace wid(2000)		
}
	

	
**** reshape for totals and ratios 

reshape wide cases total_recovered pop total_dead cases_daily cases_daily_ma cases_daily_per100k cases_daily_ma_per100k, i(date agegrp province) j(gender)
	

gen popT 			= pop1 + pop2	
gen casesT 			= cases1 + cases2	
gen cases_dailyT 	= cases_daily1 + cases_daily2	

gen ratioFM			= cases_daily_per100k2/ cases_daily_per100k1
gen diffFM			= cases_daily_per100k2 - cases_daily_per100k1

gen ratioFM_ma		= cases_daily_ma_per100k2 / cases_daily_ma_per100k1
gen diffFM_ma		= cases_daily_ma_per100k2 - cases_daily_ma_per100k1


replace ratioFM = 2   if ratioFM > 2   & ratioFM!=.
replace ratioFM = 0.5 if ratioFM < 0.5 & ratioFM!=.

replace ratioFM_ma = 2   if ratioFM_ma > 2   & ratioFM_ma!=.
replace ratioFM_ma = 0.5 if ratioFM_ma < 0.5 & ratioFM_ma!=.


summ date 
local xmin = `r(min)'
local xmax = `r(max)'


heatplot ratioFM_ma i.agegrp date if province=="Österreich", ///
	cuts(0(0.1)2) xbins(180) color(hsv purplegreen, reverse) p(lc(white) lw(0.06))  /// // 
	xtitle("") /// 
	ramp(bottom length(80) space(10) subtitle("") label(0 "Twice more men" 1 "Equal" 2 "Twice more women"))  ///
	xlabel(`xmin'(30)`xmax', labsize(2) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
	xsize(2) ysize(1) ///
	title("Female-to-Male daily active cases ratio - Österreich") ///
	note("Values are normalized by 100k population per gender and age group before calculating the ratio. 7-day moving average used.", size(2))

	
	graph export "figures/AT_cases_by_agegender_ratio.png", replace wid(2000)			

	
************ END OF FILE *************


		
		