clear

*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme white_tableau
graph set window fontface "Arial Narrow"

cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"


copy "https://just-the-covid-facts.neuwirth.priv.at/download_data/COVID_19_Oesterreich.xlsx" "./raw/AT_hospital_data.xlsx", replace





**** Sheet 1 cases
import excel using "./raw/AT_hospital_data.xlsx", first clear sheet(Registriert)

ren Datum date
format date %tdDD-Mon-yy

*drop Gesamt

foreach x of varlist B - Gesamt {
ren `x' cases_`x'
}

reshape long cases_, i(date) j(BDL) string

replace BDL = "Burgenland" 			if BDL=="B"
replace BDL = "Kärnten" 			if BDL=="K"
replace BDL = "Niederösterreich" 	if BDL=="N"
replace BDL = "Oberösterreich" 		if BDL=="O"
replace BDL = "Salzburg" 			if BDL=="Sa"
replace BDL = "Steiermark" 			if BDL=="St"
replace BDL = "Tirol" 				if BDL=="T"
replace BDL = "Voralberg" 			if BDL=="V"
replace BDL = "Wien" 				if BDL=="W"

sort BDL date
ren cases_ cases
compress
save ./temp/AT_cases.dta, replace

**** Sheet 2 tested

import excel using "./raw/AT_hospital_data.xlsx", first clear sheet(Tests)

ren Datum date
format date %tdDD-Mon

*drop Gesamt

foreach x of varlist B - Gesamt {
ren `x' tests_`x'
}

reshape long tests_, i(date) j(BDL) string

replace BDL = "Burgenland" 			if BDL=="B"
replace BDL = "Kärnten" 			if BDL=="K"
replace BDL = "Niederösterreich" 	if BDL=="N"
replace BDL = "Oberösterreich" 		if BDL=="O"
replace BDL = "Salzburg" 			if BDL=="Sa"
replace BDL = "Steiermark" 			if BDL=="St"
replace BDL = "Tirol" 				if BDL=="T"
replace BDL = "Voralberg" 			if BDL=="V"
replace BDL = "Wien" 				if BDL=="W"

sort BDL date
ren tests_ tests
compress
save ./temp/AT_tests.dta, replace


**** Sheet 3 hospitalized

import excel using "./raw/AT_hospital_data.xlsx", first clear sheet(Hospitalisiert)

ren Datum date
format date %tdDD-Mon

*drop Gesamt

foreach x of varlist B - Gesamt {
ren `x' hosp_`x'
}

reshape long hosp_, i(date) j(BDL) string

replace BDL = "Burgenland" 			if BDL=="B"
replace BDL = "Kärnten" 			if BDL=="K"
replace BDL = "Niederösterreich" 	if BDL=="N"
replace BDL = "Oberösterreich" 		if BDL=="O"
replace BDL = "Salzburg" 			if BDL=="Sa"
replace BDL = "Steiermark" 			if BDL=="St"
replace BDL = "Tirol" 				if BDL=="T"
replace BDL = "Voralberg" 			if BDL=="V"
replace BDL = "Wien" 				if BDL=="W"
*replace BDL = "Total" 				if BDL=="Gesamt"

sort BDL date
ren hosp_ hosp
compress
save ./temp/AT_hosp.dta, replace


*** Sheet 4 Intensiv


import excel using "./raw/AT_hospital_data.xlsx", first clear sheet(Intensiv)

ren Datum date
format date %tdDD-Mon

*drop Gesamt

foreach x of varlist B - Gesamt {
ren `x' intensiv_`x'
}

reshape long intensiv_, i(date) j(BDL) string

replace BDL = "Burgenland" 			if BDL=="B"
replace BDL = "Kärnten" 			if BDL=="K"
replace BDL = "Niederösterreich" 	if BDL=="N"
replace BDL = "Oberösterreich" 		if BDL=="O"
replace BDL = "Salzburg" 			if BDL=="Sa"
replace BDL = "Steiermark" 			if BDL=="St"
replace BDL = "Tirol" 				if BDL=="T"
replace BDL = "Voralberg" 			if BDL=="V"
replace BDL = "Wien" 				if BDL=="W"

sort BDL date
ren intensiv_ intensiv
compress
save ./temp/AT_intensiv.dta, replace



*** Sheet 5 Recovered


import excel using "./raw/AT_hospital_data.xlsx", first clear sheet(Genesen)

ren Datum date
format date %tdDD-Mon

*drop Gesamt

foreach x of varlist B - Gesamt {
ren `x' recovered_`x'
}

reshape long recovered_, i(date) j(BDL) string

replace BDL = "Burgenland" 			if BDL=="B"
replace BDL = "Kärnten" 			if BDL=="K"
replace BDL = "Niederösterreich" 	if BDL=="N"
replace BDL = "Oberösterreich" 		if BDL=="O"
replace BDL = "Salzburg" 			if BDL=="Sa"
replace BDL = "Steiermark" 			if BDL=="St"
replace BDL = "Tirol" 				if BDL=="T"
replace BDL = "Voralberg" 			if BDL=="V"
replace BDL = "Wien" 				if BDL=="W"

sort BDL date
ren recovered_ recovered
compress
save ./temp/AT_recovered.dta, replace


*** Sheet 6 Dead


import excel using "./raw/AT_hospital_data.xlsx", first clear sheet(Verstorben)

ren Datum date
format date %tdDD-Mon-yy

*drop Gesamt

foreach x of varlist B - Gesamt {
ren `x' dead_`x'
}

reshape long dead_, i(date) j(BDL) string

replace BDL = "Burgenland" 			if BDL=="B"
replace BDL = "Kärnten" 			if BDL=="K"
replace BDL = "Niederösterreich" 	if BDL=="N"
replace BDL = "Oberösterreich" 		if BDL=="O"
replace BDL = "Salzburg" 			if BDL=="Sa"
replace BDL = "Steiermark" 			if BDL=="St"
replace BDL = "Tirol" 				if BDL=="T"
replace BDL = "Voralberg" 			if BDL=="V"
replace BDL = "Wien" 				if BDL=="W"

sort BDL date
ren dead_ dead
compress
save ./temp/AT_dead.dta, replace


***** merge them all

use ./temp/AT_cases.dta, clear
merge 1:1 BDL date using ./temp/AT_tests.dta
drop _m

merge 1:1 BDL date using ./temp/AT_hosp.dta
drop _m

merge 1:1 BDL date using ./temp/AT_intensiv.dta
drop _m

merge 1:1 BDL date using ./temp/AT_recovered.dta
drop _m

merge 1:1 BDL date using ./temp/AT_dead.dta
drop _m


compress
save ./master/AT_hospitalization.dta, replace



*** figure here

gen date2 = date

encode BDL, gen(BDL2)
order BDL BDL2 date date2

xtset BDL2 date

lab var date "Date"

sort BDL date
foreach x of varlist cases recovered dead tests {
	bysort BDL: gen `x'_daily = `x' - `x'[_n-1]
}

ren hosp hosp_daily
ren intensiv intensive_daily

recode *daily (-10000/0 = 0)
recode tests_daily (0 = .)





*** CFR: case fatality rate = dead / cases 
*** CFR <= IFR (reported vs actual infected)

cap drop CFR
cap drop TIR

gen CFR = (dead / cases) * 100
gen TIR = (cases / tests) * 100  // tests to infection rate

tssmooth ma tests_daily_ma 	= tests_daily,  w(6 1 0)
format date %tdMon-yy	
	



twoway ///
	(line hosp_daily date		, sort yaxis(2)   lw(thin)) ///
	(line intensive_daily date	, sort 			  lw(thin)) ///
		if BDL!="Gesamt", ///
			ytitle("Yellow = Hospitalized (left y-axis), Blue = Intensive care (right y-axis)") ///
			ytitle(, size(small)) ///
			xtitle("") ///
			xlabel(#10, labsize(vsmall) angle(vertical)) ///
			by(, title("{fontface Arial Bold: COVID-19 Hopitalized and Intensive care in Austria}") ///
			note("Source: Eric Neuwirth's COVID-19 database.", size(vsmall))) ///
			by(, legend(off)) ///
			by(BDL, yrescale)	///
			subtitle(, lcolor(none)) 
		graph export "./figures/covid19_austria_tests2.png", replace wid(2000)			


		
********* END OF FILE ***********