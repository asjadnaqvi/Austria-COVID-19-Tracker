clear

*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme white_tableau
graph set window fontface "Arial Narrow"

cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"


// change in data structure (21 Nov 2021)

copy "https://just-the-covid-facts.neuwirth.priv.at/download_data/COVID_Daten_Oesterreich.xlsx" "./raw/AT_hospital_data.xlsx", replace




*** clean up the file

import excel using "./raw/AT_hospital_data.xlsx", first clear 


ren Datum date
format date %tdDD-Mon-yy
gen date2 = date  // for controling Stata dates


ren Bundesland 		BDL
ren BundeslandID 	BDLid

// using only BMI data
ren Tests_alle_BMI 	tests_all
ren Tests_PCR_BMI 	tests_pcr
ren Hospital_BMI 	hospital
ren cases_BMI		cases
ren Intensiv_BMI 	intensive
ren Tot_BMI 		dead
ren Genesen_BMI 	recovered


drop if BDLid==10
xtset BDLid date

lab var date "Date"

sort BDL date
foreach x of varlist cases recovered dead   {
	bysort BDL: gen `x'_daily = `x' - `x'[_n-1]
}

ren hospital	hospital_daily
ren intensiv 	intensive_daily
ren tests_all	tests_all_daily


recode *daily (-10000/0 = 0)
*recode tests_daily (0 = .)





*** CFR: case fatality rate = dead / cases 
*** CFR <= IFR (reported vs actual infected)

cap drop CFR
cap drop TIR

gen CFR = (dead / cases) * 100
gen TIR = (cases / tests_all) * 100  // tests to infection rate

tssmooth ma tests_daily_ma 	= tests_all_daily,  w(6 1 0)
format date %tdMon-yy	
	

colorpalette tableau, nograph

twoway ///
	(line hospital_daily date	, sort lp()     lw(thin) ) ///
	(line intensive_daily date	, sort yaxis(2) lw(thin) ) ///
		if BDL!="Gesamt", ///
		ytitle("Blue = Hospitalized (left y-axis), Orange = Intensive care (right y-axis)", size(small)) ///
			xtitle("") ///
			xlabel(#10, labsize(vsmall) angle(vertical)) ///
			ylabel(, labcolor("`r(p1)'")) ///
			ylabel(, labcolor("`r(p2)'") axis(2)) ///
			by(, title("{fontface Arial Bold: COVID-19 Hopitalized and Intensive care in Austria}") ///
			note("Source: Erich Neuwirth's COVID-19 database (https://just-the-covid-facts.neuwirth.priv.at/).", size(1.6))) ///
			by(, legend(off)) ///
			by(BDL, yrescale)	///
			subtitle(, lcolor(none)) 	xsize(2) ysize(1)
		graph export "./figures/covid19_austria_tests2.png", replace wid(2000)			


		
********* END OF FILE ***********