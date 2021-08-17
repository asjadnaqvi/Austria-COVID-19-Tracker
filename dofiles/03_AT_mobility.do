clear

*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme white_tableau
graph set window fontface "Arial Narrow"


cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"


{
**** 01 index of identifiers. need to run one time unless IDs change

/*
insheet using "https://storage.googleapis.com/covid19-open-data/v2/index.csv", clear 
	ren v13 iso_3166_1_alpha2
	ren v14 iso_3166_1_alpha3

	compress
		save ./temp/01_index.dta, replace
*/


***** 08 mobility. Heavy file. Update infrequently.

/*
insheet using "https://storage.googleapis.com/covid19-open-data/v2/mobility.csv", clear 
compress
save ./temp/08_mobility.dta, replace
*/
}

*** set up the data
use ./temp/01_index.dta, clear
merge 1:m key using ./temp/08_mobility.dta

keep if country_code=="AT"
keep if length(key)==4

destring _all, replace

drop subregion2_code subregion2_name locality_code locality_name iso_3166_1_alpha2 iso_3166_1_alpha3 _merge
drop key wikidata datacommons country_code country_name

rename subregion1_name region
rename subregion1_code code

tab region

replace region="Oberösterreich" if region=="Upper Austria"
replace region="Niederösterreich" if region=="Lower Austria"
replace region="Wien" if region=="Vienna"
replace region="Kärnten" if region=="Carinthia"
replace region="Tirol" if region=="Tyrol"
replace region="Steiermark" if region=="Styria"
replace region="Österreich" if region==""

replace code = 99 if code==.



gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yy
gen date2 = date

summ date
drop if date>=r(max) - 2


compress
save ./master/AT_mobility.dta, replace



**** figure below

order code date date2
xtset code date

ren mobility_* mb_*


foreach x of varlist mb* {
tssmooth ma `x'2 = `x', w(6 1 0)
lab var `x'2 "Percentage change"
}

drop if date < 21975


**** generate a rank based on the last date
summ date
gen tick = .


levelsof region, local(lvls)
foreach x of local lvls {
summ date if region=="`x'"
replace tick=1 if date == `r(max)' & region=="`x'"  // mark the last entry
}


tab date tick

foreach x of varlist mb*2 {
egen rank_`x' = rank(`x') if tick==1, u	
}

levelsof region, local(lvls)
foreach x of local lvls {
foreach y of varlist mb*2 {
	display "`x'"
	
	qui summ rank_`y' if region=="`x'"
	cap replace rank_`y' = `r(max)' if region=="`x'" & rank_`y'==.
	}
}
	
	


****************
*** graph 1 **** workplace
****************

sort  date


**** generate a marker for the last entry
gen marker = region + " (" + string(mb_workplaces2, "%9.2f") + ")" if tick==1


levelsof rank_mb_workplaces2, local(lvls)   
local items = r(r)            

foreach x of local lvls {
 
	colorpalette cividis, n(`items') nograph
		local customline `customline' (line mb_workplaces2 date if rank_mb_workplaces2 == `x', lc("`r(p`x')'") lp(solid) lw(*0.8)) ||
		}		
			

summ date
local start = r(min)
local end   = r(max) + 50	


twoway `customline' ///
	(scatter mb_workplaces2 date if tick==1, mcolor(black) msymbol(point) mlabel(marker) mlabsize(*0.7) mlabcolor(black)) ///
	, ///
		yline(0, lc(black) lw(thin) lp(solid)) ///
		xlabel(`start'(30)`end', labsize(vsmall) angle(vertical)) ///
		ytitle(, size(small)) ///		
		xtitle("") ///
		title("Population going to work: % change from baseline") ///
		note("Source: Google mobility trends", size(vsmall)) ///
		legend(off)	xsize(2) ysize(1)	
		graph export "figures/covid19_mobility_workplace.png", replace wid(2000)	
		


	


****************
*** graph 2 **** residential
****************

local customline
cap drop marker


sort  date


**** generate a marker for the last entry
gen marker = region + " (" + string(mb_residential2, "%9.2f") + ")" if tick==1


levelsof rank_mb_residential2, local(lvls)   
local items = r(r)            

foreach x of local lvls {
 
	colorpalette cividis, n(`items') nograph
		local customline `customline' (line mb_residential2 date if rank_mb_residential2 == `x', lc("`r(p`x')'") lp(solid) lw(*0.8)) ||
		}		
			

summ date
local start = r(min)
local end   = r(max) + 50	


twoway `customline' ///
	(scatter mb_residential2 date if tick==1, mcolor(black) msymbol(point) mlabel(marker) mlabsize(*0.7) mlabcolor(black)) ///
	, ///
		yline(0, lc(black) lw(thin) lp(solid)) ///
		xlabel(`start'(30)`end', labsize(vsmall) angle(vertical)) ///
		ytitle(, size(small)) ///		
		xtitle("") ///
		title("Population staying home: % change from baseline") ///
		note("Source: Google mobility trends", size(vsmall)) ///
		legend(off)		xsize(2) ysize(1)
		graph export "figures/covid19_mobility_stayathome.png", replace wid(2000)	
		

		

****************
*** graph 3 **** parks
****************

local customline
cap drop marker


sort  date


**** generate a marker for the last entry
gen marker = region + " (" + string(mb_parks2, "%9.2f") + ")" if tick==1


levelsof rank_mb_parks2, local(lvls)   
local items = r(r)            

foreach x of local lvls {
 
	colorpalette cividis, n(`items') nograph
		local customline `customline' (line mb_parks2 date if rank_mb_parks2 == `x', lc("`r(p`x')'") lp(solid) lw(*0.8)) ||
		}		
			

summ date
local start = r(min)
local end   = r(max) + 50	


twoway `customline' ///
	(scatter mb_parks2 date if tick==1, mcolor(black) msymbol(point) mlabel(marker) mlabsize(*0.7) mlabcolor(black)) ///
	, ///
		yline(0, lc(black) lw(thin) lp(solid)) ///
		xlabel(`start'(30)`end', labsize(vsmall) angle(vertical)) ///
		ytitle(, size(small)) ///		
		xtitle("") ///
		title("Population going to parks: % change from baseline") ///
		note("Source: Google mobility trends", size(vsmall)) ///
		legend(off)		xsize(2) ysize(1)
		graph export "figures/covid19_mobility_parks.png", replace wid(2000)	
		



****************
*** graph 4 **** retail and recreation
****************

local customline
cap drop marker


sort  date


**** generate a marker for the last entry
gen marker = region + " (" + string(mb_retail_and_recreation2, "%9.2f") + ")" if tick==1


levelsof rank_mb_retail_and_recreation2, local(lvls)   
local items = r(r)            

foreach x of local lvls {
 
	colorpalette cividis, n(`items') nograph
		local customline `customline' (line mb_retail_and_recreation2 date if rank_mb_retail_and_recreation2 == `x', lc("`r(p`x')'") lp(solid) lw(*0.8)) ||
		}		
			

summ date
local start = r(min)
local end   = r(max) + 50	


twoway `customline' ///
	(scatter mb_retail_and_recreation2 date if tick==1, mcolor(black) msymbol(point) mlabel(marker) mlabsize(*0.7) mlabcolor(black)) ///
	, ///
		yline(0, lc(black) lw(thin) lp(solid)) ///
		xlabel(`start'(30)`end', labsize(vsmall) angle(vertical)) ///
		ytitle(, size(small)) ///		
		xtitle("") ///
		title("Population going shopping/recreation: % change from baseline") ///
		note("Source: Google mobility trends", size(vsmall)) ///
		legend(off)	xsize(2) ysize(1)
		graph export "figures/covid19_mobility_retail.png", replace wid(2000)	
		





********* END OF FILE ***********

