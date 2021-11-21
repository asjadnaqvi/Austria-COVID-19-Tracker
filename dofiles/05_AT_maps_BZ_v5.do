clear

*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme white_tableau
graph set window fontface "Arial Narrow"

cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"


cd GIS/


*spshape2dta STATISTIK_AUSTRIA_POLBEZ_20200101Polygon, replace saving(bezirk)



use bezirk.dta, clear
destring _all, replace
save, replace
drop if id>900


merge 1:m id using "../master/austria_covid19.dta"

drop if _m !=3
drop _m


***** baseline map



summ date

local date: display %tdd_m_y `r(max)'
display "`date'"

local date2 = subinstr(trim("`date'"), " ", "_", .)
display "`date2'"


			



gen  cases_pop = ( cases / pop) * 10000
gen deaths_pop = (deaths / pop) * 10000
gen active_pop = (active / pop) * 10000

format cases %9.0fc
format cases_pop %9.0fc

format deaths %9.0fc
format deaths_pop %9.0fc

format active %9.0fc
format active_pop %9.0fc

sort bezirk date		
bysort bezirk: gen deaths_pastx = deaths - deaths[_n-14]		 
recode deaths_pastx (0=.)	


recode cases* deaths* active* deaths_pastx (0=.)  // for mapping


replace name = "Wien" if name=="Wien(Stadt)"

preserve
	summ date
	keep if date==`r(max)'
	gen name2 = name + " (" +  string(cases_daily) + ")"  			if cases_daily	!=.
	gen name3 = name + " (" +  string(active) + ")"  				if active		!=.
	gen name4 = name + " (" +  string(deaths_pastx) + ")"  			if deaths_pastx	!=.
	gen name5 = name + " (" +  string(active_pop, "%9.0f") + ")" 	if active_pop	!=.
	gen name6 = name + " (" +  string(deaths, "%12.0f") + ")" 
	gen name7 = name + " (" +  string(deaths_pop, "%12.0f") + ")" 
	gen name8 = name + " (" +  string(cases, "%12.0f") + ")" 
	gen name9 = name + " (" +  string(cases_pop, "%12.0f") + ")" 
	*drop if name2==""
	save map_labels.dta, replace
restore		




sort date id



*********** map deaths		
		
summ date		
summ deaths_daily if date==`r(max)'
local diff = `r(sum)'

display `diff'	

*colorpalette matplotlib autumn, n(10) reverse nograph
*colorpalette gs14 gs4, ipolate(12) reverse nograph
*colorpalette red orange gs14, ipolate(9) reverse nograph
colorpalette viridis, n(9) reverse nograph
local colors `r(p)'

summ date
	
	
***** DEATHS ON LAST REPORTED DATE (dead map. no more daily deaths. See deaths last 14 days map below)	
	
/*
spmap deaths_daily using "bezirk_shp.dta" if date==`r(max)', ///
id(_ID) cln(5)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(white ..) ndocolor(gs8 ..) ndsize(vvthin ..) ndlabel("No cases") ///
		legend(pos(11) size(*1.2) symx(*1) symy(*1) forcesize) legstyle(2)   ///
  	    polygon(data("NUTS2_shp")  ocolor(black)  osize(thin) legenda(on) legl("Bundesländer")) ///
		label(data("map_labels.dta") x(_CX) y(_CY) label(name6) size(*0.5 ..) length(30)) ///
		title("{fontface Merriweather:COVID-19 new dea (`date')}", size(large)) ///
		subtitle("Total = `diff'", size(small)) ///
		note("Map layer: Statistik Austria. Data: https://covid19-dashboard.ages.at/", size(tiny))
		graph export "../figures/covid19_austria_deaths.png", replace wid(3000)	
*/

*** map cases

summ date		
summ cases_daily if date==`r(max)', d
local diff = `r(sum)'

display `diff'	
*colorpalette red orange gs14, ipolate(8) reverse nograph
colorpalette viridis, n(9) reverse nograph
local colors `r(p)'

summ date
	

spmap cases_daily using "bezirk_shp.dta" if date==`r(max)', ///
id(_ID) cln(6) fcolor("`colors'")  /// 
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(white ..) ndocolor(gs8 ..) ndsize(vvthin ..) ndlabel("No cases") ///
		legend(pos(11) size(*1.2) symx(*1) symy(*1) forcesize) legstyle(2)   ///
  	    polygon(data("NUTS2_shp")  ocolor(black)  osize(thin) legenda(on) legl("Bundesländer")) ///
		label(data("map_labels.dta") x(_CX) y(_CY) label(name2) size(*0.5 ..) length(30)) ///
		title("{fontface Arial Bold:COVID-19 New Cases (`date')}", size(large)) ///
		subtitle("Total = `diff'", size(small)) ///
		note("Map layer: Statistik Austria. Data: https://covid19-dashboard.ages.at/", size(vsmall))
		graph export "../figures/covid19_austria_cases.png", replace wid(3000)	



*********** active cases

summ date		
summ active if date==`r(max)', d
local diff = `r(sum)'
local diff : di %9.0fc `diff'


colorpalette red orange gs14, n(12) reverse nograph
colorpalette viridis, n(13) reverse nograph
local colors `r(p)'

summ date
	

spmap active using "bezirk_shp.dta" if date==`r(max)', ///
id(_ID) clm(k) cln(10) fcolor("`colors'")  /// 
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(white ..) ndocolor(gs8 ..) ndsize(vvthin ..) ndlabel("No cases") ///
		legend(pos(11) size(*1.2) symx(*1) symy(*1) forcesize) legstyle(2)   ///
  	    polygon(data("NUTS2_shp")  ocolor(black)  osize(thin) legenda(on) legl("Bundesländer")) ///
		label(data("map_labels.dta") x(_CX) y(_CY) label(name3) size(*0.5 ..) length(30)) ///
		title("{fontface Arial Bold:COVID-19 Active Cases (`date')}", size(large)) ///
		subtitle("Total = `diff'", size(small)) ///
		note("Map layer: Statistik Austria. Data: https://covid19-dashboard.ages.at/", size(vsmall))
		graph export "../figures/covid19_austria_active.png", replace wid(3000)	



*********** active per pop

summ date		
summ active_pop if date==`r(max)', d
local diff = `r(mean)'
local diff : di %9.0fc `diff'


colorpalette red orange gs14, n(12) reverse nograph
colorpalette viridis, n(13) reverse nograph
local colors `r(p)'

summ date
	

spmap active_pop using "bezirk_shp.dta" if date==`r(max)', ///
id(_ID) cln(10)   fcolor("`colors'")  /// 
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(white ..) ndocolor(gs8 ..) ndsize(vvthin ..) ndlabel("No cases") ///
		legend(pos(11) size(*1.2) symx(*1) symy(*1) forcesize) legstyle(2)   ///
  	    polygon(data("NUTS2_shp")  ocolor(black)  osize(thin) legenda(on) legl("Bundesländer")) ///
		label(data("map_labels.dta") x(_CX) y(_CY) label(name5) size(*0.5 ..) length(30)) ///
		title("{fontface Arial Bold:COVID-19 Active Cases per 10,000 population (`date')}", size(large)) ///
		subtitle("Average = `diff'", size(small)) ///
		note("Map layer: Statistik Austria. Data: https://covid19-dashboard.ages.at/", size(vsmall))
		graph export "../figures/covid19_austria_active_pop.png", replace wid(3000)	


		
		
*** deaths in the past 14 days

format deaths_pastx %9.0f
		
summ date		
summ deaths_pastx if date==`r(max)', d
local diff = `r(sum)'

display `diff'			
colorpalette red orange gs14, ipolate(7) reverse nograph
colorpalette viridis, n(7) reverse nograph

local colors `r(p)'		
summ date		
		
spmap deaths_pastx using "bezirk_shp.dta" if date==`r(max)', ///
id(_ID) clm(k) cln(6)  fcolor("`colors'")  /// 
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(white ..) ndocolor(gs8 ..) ndsize(vvthin ..) ndlabel("No deaths") ///
		legend(pos(11) size(*1.2) symx(*1) symy(*1) forcesize) legstyle(2)   ///
  	    polygon(data("NUTS2_shp")  ocolor(black)  osize(thin) legenda(on) legl("Bundesländer")) ///
		label(data("map_labels.dta") x(_CX) y(_CY) label(name4) size(*0.5 ..) length(30)) ///
		title("{fontface Arial Bold:COVID-19 Deaths in the past 14 days (`date')}", size(large)) ///
		subtitle("Total = `diff'", size(small)) ///
		note("Map layer: Statistik Austria. Data: https://covid19-dashboard.ages.at/", size(vsmall))
		graph export "../figures/covid19_austria_deaths.png", replace wid(3000)	

				

// reset the directory

cd ..				
				
				
********* END OF FILE ***********		


