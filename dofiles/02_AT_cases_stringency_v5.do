clear


// install the schemes and packages
*ssc install colorpalette, replace
*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme white_tableau
graph set window fontface "Arial Narrow"



cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"



use ./master/austria_covid19.dta, clear
collapse (sum) cases cases_daily deaths deaths_daily recovered recovered_daily pop, by(BDL date)



encode BDL, gen(BDL2)				
order BDL BDL2 date				
xtset BDL2 date


bysort date: egen cases_daily_tot = sum(cases_daily)


		


// merge with the stringency file
merge m:1 date using "./master/austria_stringency"
drop if _m==2					
drop _m
				
egen tag = tag(date)    // these are the unique observations for stringency date




// format the date for display
summ date

local date: display %tdd_m_y `r(max)'
display "`date'"

local date2 = subinstr(trim("`date'"), " ", "_", .)
display "`date2'"


// smooth the data

sort BDL date		 			
	tssmooth ma cases_ma 		= cases_daily, w(2 1 0)
	tssmooth ma deaths_ma 		= deaths_daily, w(2 1 0)


gen cases_ma_smooth =. 

levelsof BDL2, local(lvls)
foreach x of local lvls {
lowess cases_ma date if BDL2==`x', bwid(0.15) gen(temp`x') nograph
replace cases_ma_smooth =temp`x'  if BDL2==`x'
drop temp`x'
}


summ date
egen rank = rank(cases_ma_smooth) if date==`r(max)', f


levelsof BDL, local(lvls)
 
foreach x of local lvls {
 display "`x'"
 
 qui summ rank if BDL=="`x'"  // summarize the rank of country x
 cap replace rank = `r(max)' if BDL=="`x'" & rank==.
 }



summ date 
local x1 = `r(min)'
local x2 = `r(max)' + 10 
local today = `r(max)'

local dist = `x2' - `x1'


sort BDL date
bysort BDL: gen diff = cases_ma_smooth - cases_ma_smooth[_n-1]
replace diff=0 if diff==.

gen angle = atan2(1, diff * 3/5 * `dist' / 4000)  * (-180 / _pi)


// sort the stringency stuff

foreach x of varlist c1_schoolclosing c2_workplaceclosing c3_cancelpublicevents c4_restrictionsongatherings ///
		c5_closepublictransport c6_stayathomerequirements c7_restrictionsoninternalmovemen ///
		c8_internationaltravelcontrols e1_incomesupport h2_testingpolicy h3_contacttracing h6_facialcoverings {

replace `x' = 0.05 		if `x'==0
replace `x' = 0.5 	    if `x'==1
replace `x' = 0.75 	    if `x'==2
replace `x' = 1.5 		if `x'==3
replace `x' = 2 		if `x'==4
}




gen c1 = 1000
gen c2 = 1250
gen c3 = 1500
gen c4 = 1750
gen c5 = 2000
gen c6 = 2250
gen c7 = 2500
gen c8 = 2750
gen c9 = 3000

summ date 
gen xmarker = 21895 in 1/9   // dont change this

gen ymarker = .
replace ymarker = 1000 in 1
replace ymarker = 1250 in 2
replace ymarker = 1500 in 3 
replace ymarker = 1750 in 4
replace ymarker = 2000 in 5
replace ymarker = 2250 in 6 
replace ymarker = 2500 in 7 
replace ymarker = 2750 in 8 
replace ymarker = 3000 in 9 

gen pmarker = "" 
replace pmarker = "Schools closed" 	  				if ymarker==1000
replace pmarker = "Work place closed" 				if ymarker==1250 
replace pmarker = "Limit public events" 			if ymarker==1500
replace pmarker = "Restrict gatherings" 			if ymarker==1750
replace pmarker = "Restrict public transport" 		if ymarker==2000
replace pmarker = "Stay at home" 					if ymarker==2250
replace pmarker = "Restrict internal movement" 		if ymarker==2500
replace pmarker = "Restrict international travel" 	if ymarker==2750
replace pmarker = "Masks" 							if ymarker==3000


gen label = BDL + "  (" + string(cases_daily, "%9.0f") + ")" // if tag_BDL==1




******* DRAW ****


		
summ date
local x1 = `r(min)' - 80
local x2 = `r(max)' + 80 			
local today = `r(max)'

summ cases_daily if date==`today'
local casestoday = `r(sum)'



levelsof rank, local(lvls)
foreach y of local lvls {
qui summ angle if rank == `y' & date == `today'
local angle`y' = `r(mean)' 
}

	
sort  date	 BDL
colorpalette viridis, n(11) reverse nograph
		
twoway ///
	(line cases_ma_smooth date if rank==1 & date, lc("`r(p9)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==2 & date, lc("`r(p8)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==3 & date, lc("`r(p7)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==4 & date, lc("`r(p6)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==5 & date, lc("`r(p5)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==6 & date, lc("`r(p4)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==7 & date, lc("`r(p3)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==8 & date, lc("`r(p2)'") lw(thin)) ///
	(line cases_ma_smooth date if rank==9 & date, lc("`r(p1)'") lw(thin) lp(solid)) ///
		(scatter cases_ma_smooth date if rank==1 & date==`today', msangle(`angle1') mcolor("`r(p9)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==2 & date==`today', msangle(`angle2') mcolor("`r(p8)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==3 & date==`today', msangle(`angle3') mcolor("`r(p7)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==4 & date==`today', msangle(`angle4') mcolor("`r(p6)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==5 & date==`today', msangle(`angle5') mcolor("`r(p5)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==6 & date==`today', msangle(`angle6') mcolor("`r(p4)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==7 & date==`today', msangle(`angle7') mcolor("`r(p3)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==8 & date==`today', msangle(`angle8') mcolor("`r(p2)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
		(scatter cases_ma_smooth date if rank==9 & date==`today', msangle(`angle9') mcolor("`r(p1)'") msymbol(arrow) msize(medium) mlabel(label) mlabcolor(black) mlabsize(*0.8)) ///
			(scatter c1 date [aweight = c1_schoolclosing]					if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///
			(scatter c2 date [aweight = c2_workplaceclosing]				if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///
			(scatter c3 date [aweight = c3_cancelpublicevents]				if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///
			(scatter c4 date [aweight = c4_restrictionsongatherings]		if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///
			(scatter c5 date [fweight = c5_closepublictransport]			if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///
			(scatter c6 date [aweight = c6_stayathomerequirements]			if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///
			(scatter c7 date [aweight = c7_restrictionsoninternalmovemen]	if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///
			(scatter c8 date [aweight = c8_internationaltravelcontrols]		if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///	
			(scatter c9 date [aweight = h6_facialcoverings]					if tag==1, mcolor("gs8%10")  mlwidth(none)	msize(tiny) msymbol(smcircle)) ///	
			(scatter ymarker xmarker, mcolor(black) msymbol(none) mlabel(pmarker) mlabsize(*0.9) mlabcolor(black) mlabposition(3) mlabgap()) ///
			, ///
			xtitle("") ///
			ytitle("New cases (3-day moving average)" , size(small)) ///
				xlabel(`x1'(45)`x2', labsize(vsmall) angle(vertical) glwidth(vvthin) glpattern(solid)) ///
				ylabel(0(500)4000, labsize(vsmall) glwidth(vvthin) glpattern(solid)) ///
		title("{fontface Arial Bold:COVID-19 cases for Austria: `casestoday' on `date'}", size(medlarge)) ///
		note("Data: https://covid19-dashboard.ages.at/. Policy Stringency Data: Oxford COVID-19 Government Response Tracker. Strength of policy is indicated by marker size. Cases for the last reported date for each province given in brackets.", size(*0.6)) ///
		legend(off) 	xsize(2) ysize(1)
		
		
graph export "figures/AT_cases_stringency.png", replace wid(3000)		



************ END OF FILE *************