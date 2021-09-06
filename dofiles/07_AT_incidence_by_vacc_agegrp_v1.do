clear

set scheme white_tableau, perm

cap cd "D:\Programs\Dropbox\Dropbox\PROJECT COVID AT"



import delimited using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_vollstaendig_unvollstaendig_geimpft_2021-08-20.csv", clear varn(1)



// 12-17 age group
import delim using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_Impfstatus_12bis17Jahre.csv", clear varn(1)

gen day   = substr(datum,1,2)
gen month = substr(datum,4,2)
gen year  = substr(datum,7,4)
destring month day year, replace
drop datum
gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-yy	

gen agegroup = 1	
order date agegroup

ren vollständiggeimpft 			inzidence_fullvac
ren unvollständignichtgeimpft 	inzidence_rest

replace inzidence_fullvac 	= subinstr(inzidence_fullvac, ",", ".", .)
replace inzidence_rest 		= subinstr(inzidence_rest, ",", ".", .)

destring _all, replace
compress
save ./temp/incidence1.dta, replace



// 18-59 age group
import delim using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_Impfstatus_18bis59Jahre.csv", clear varn(1)

gen day   = substr(datum,1,2)
gen month = substr(datum,4,2)
gen year  = substr(datum,7,4)
destring month day year, replace
drop datum
gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-yy	

gen agegroup = 2	
order date agegroup

ren vollständiggeimpft 			inzidence_fullvac
ren unvollständignichtgeimpft 	inzidence_rest

replace inzidence_fullvac 	= subinstr(inzidence_fullvac, ",", ".", .)
replace inzidence_rest 		= subinstr(inzidence_rest, ",", ".", .)

destring _all, replace
compress
save ./temp/incidence2.dta, replace



// 60+ age group
import delim using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_Impfstatus_60plus.csv", clear varn(1)

gen day   = substr(datum,1,2)
gen month = substr(datum,4,2)
gen year  = substr(datum,7,4)
destring month day year, replace
drop datum
gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-yy	

gen agegroup = 3	
order date agegroup

ren vollständiggeimpft 			inzidence_fullvac
ren unvollständignichtgeimpft 	inzidence_rest

replace inzidence_fullvac 	= subinstr(inzidence_fullvac, ",", ".", .)
replace inzidence_rest 		= subinstr(inzidence_rest, ",", ".", .)

destring _all, replace
compress
save ./temp/incidence3.dta, replace



*** put the all together

use ./temp/incidence1, clear
append using ./temp/incidence2
append using ./temp/incidence3


drop if date==.

lab de agerange 1 "12-17 years" 2 "18-59 years" 3 "60+ years", replace
lab val agegroup agerange


lab var date 				"Date"
lab var agegroup 			"Age group"
lab var inzidence_fullvac 	"7-day incidence rate fully vaccinated per 10k pop"
lab var inzidence_rest 		"7-day incidence rate not fully vaccinated per 10k pop"



gen share = inzidence_rest / inzidence_fullvac


order date 	
compress
save ./master/incidence_by_vacc_agegroup.dta, replace







**** graphs below

twoway ///
	(line inzidence_fullvac date, lp(--) ) ///
	(line inzidence_rest 	date 		) ///
		, ///
			ytitle("7-day incidence rate per 10k population") ///
			ylabel(, labsize(small)) ///
			xtitle("") ///
			xlabel(, labsize(vsmall) angle(vertical)) ///
			by(agegroup, title("Incidence rate by vaccination status and age group") note("Source: AGES (https://www.ages.at/themen/krankheitserreger/coronavirus/)", size(vsmall)) rows(1)) ///
			legend(order(1 "Fully vaccinated" 2 "Not fully vaccinated") rows(1) size(small)) ///		
			xsize(2) ysize(1) 

		graph export "./figures/covid19_austria_incidence1.png", replace wid(2000)					
			


twoway ///
	(line share date if agegroup==1) ///
	(line share date if agegroup==2) ///
	(line share date if agegroup==3) ///	
		, ///
			ytitle("Ratio of 7-day incidence rate of not fully vaccinated/fully vaccinated") ///
			ylabel(, labsize(small)) ///
			xtitle("") ///
			xlabel(, labsize(vsmall) angle(vertical)) ///
			legend(order(1 "12-17 years" 2 "18-59 years" 3 "60+ years") cols(1) pos(11) ring(0) size(small)) ///
			title("Comparison of incidence rates by vaccination status and age group") ///
			note("Source: AGES (https://www.ages.at/themen/krankheitserreger/coronavirus/)", size(vsmall))

		graph export "./figures/covid19_austria_incidence2.png", replace wid(2000)	



	