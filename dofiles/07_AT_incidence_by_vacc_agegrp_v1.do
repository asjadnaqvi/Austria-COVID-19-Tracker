clear

set scheme white_tableau, perm

cap cd "D:\Programs\Dropbox\Dropbox\PROJECT COVID AT"

**https://www.ages.at/themen/krankheitserreger/coronavirus/


/*
Kein Impf-induzierter oder natürlich-erworbener Immunschutz wird angenommen bei Personen, die keine COVID19-Impfung erhalten haben UND die vor aktueller SARS-CoV-2-Infektion niemals PCR-positiv auf SARS-CoV-2 getestet wurden
	Impf-induzierter Immunschutz als unzureichend wird angenommen bei Status
	Geimpft mit 1 Dosis (jeder Impfstoff: J&J-, AZ-, BioNTec/Pfizer-, Moderna-Vakzin);
	Geimpft mit 2 Dosen (Impfschema, homolog, heterolog), wobei Dosis 2 ≤ 14 Tage oder > 180 Tage zurückliegt;
	Geimpft mit 3 Dosen, wobei Dosis 3 ≤ 7 Tage und Dosis 2 >180 Tage zurückliegt

Natürlich-erworbener Immunschutz (+/- Impfung) als unzureichend wird angenommen bei Status
	Geimpft (1x) + Genesen, wobei vorgehende Labordiagnose > 180 Tage zurückliegt;
	Genesen (ausschließlich), wobei vorgehende Labordiagnose > 180 Tage zurückliegt;
	Genesen + Geimpft (1x), wobei vorhergehende Impfung > 180 Tage zurückliegt

Impf-induzierter Immunschutz als ausreichend wird angenommen bei dem Status
	Geimpft mit 2 Dosen (Impfschema, homolog, heterolog), wobei Dosis 2 > 14 Tage und ≤ 180 Tage zurückliegt;
	Geimpft mit 3 Dosen (Impfschema, homolog, heterolog), wobei Dosis 3 > 7 Tage zurück liegt, oder Dosis 3 ≤ 7 Tage UND Dosis 2 ≤ 180 Tage zurück liegt

Natürlich-erworbener Immunschutz (+/- Impfung) als ausreichend wird angenommen bei Status
	Geimpft (1x) + Genesen, wobei vorgehende Labordiagnose ≤ 180 Tage zurückliegt;
	Geimpft (1x) + Genesen + Geimpft (1x), wobei vorhergehende Impfung ≤ 180 Tage zurückliegt;
	Geimpft (1x) + Genesen + Geimpft (2x);
	Geimpft (2x) gefolgt von Genesen, wobei vorhergehende Labordiagnose ≤ 180 Tage zurückliegt;
	Genesen + Geimpft (1x), wobei vorhergehende Impfung ≤ 180 Tage zurückliegt;
	Genesen + Geimpft (2x);
	Genesen (ausschließlich), wobei vorgehende Labordiagnose ≤ 180 Tage zurückliegt;
	Genesen (2x)

*/







// 12-17 age group


import delim using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_Immunschutz_12bis17Jahre.csv", clear varn(1)


cap drop v*

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

ren keinimpfinduzierterodernatürlich incd_unvacc
ren unzureichenderimpfinduzierterimm incd_minone
ren ausreichendernatürlicherworbener incd_fullvac

drop unzureichendernatürlicherworbene ausreichenderimpfinduzierterimmu


foreach x of varlist incd_* {
	replace `x' = subinstr(`x', ",", ".", .)
}


destring _all, replace
compress
save ./temp/incidence1.dta, replace



// 18-59 age group
import delim using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_Immunschutz_18bis59Jahre.csv", clear varn(1)

cap drop v*

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


ren keinimpfinduzierterodernatürlich incd_unvacc
ren unzureichenderimpfinduzierterimm incd_minone
ren ausreichendernatürlicherworbener incd_fullvac

drop unzureichendernatürlicherworbene ausreichenderimpfinduzierterimmu


foreach x of varlist incd_* {
	replace `x' = subinstr(`x', ",", ".", .)
}


destring _all, replace
compress
save ./temp/incidence2.dta, replace



// 60+ age group
import delim using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_Immunschutz_60plus.csv", clear varn(1)

cap drop v*

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

ren keinimpfinduzierterodernatürlich incd_unvacc
ren unzureichenderimpfinduzierterimm incd_minone
ren ausreichendernatürlicherworbener incd_fullvac

drop unzureichendernatürlicherworbene ausreichenderimpfinduzierterimmu


foreach x of varlist incd_* {
	replace `x' = subinstr(`x', ",", ".", .)
}


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


lab var date 			"Date"
lab var agegroup 		"Age group"
lab var incd_unvacc 	"7-day incidence per 10k pop - unvaccinated"
lab var incd_minone 	"7-day incidence per 10k pop - at least one vaccine"
lab var incd_fullvac	"7-day incidence per 10k pop - at least two vaccines"


gen share = incd_unvacc / incd_fullvac


order date 	
compress
save ./master/incidence_by_vacc_agegroup.dta, replace







**** graphs below

twoway ///
	(line incd_fullvac  date, lp(--) ) ///
	(line incd_minone 	date, lp(..-)	 ) ///
	(line incd_unvacc 	date 		 ) ///
		, ///
			ytitle("7-day incidence rate per 10k population") ///
			ylabel(, labsize(small)) ///
			xtitle("") ///
			xlabel(, labsize(vsmall) angle(vertical)) ///
			by(agegroup, title("Incidence rate by vaccination status and age group") note("Source: AGES (https://www.ages.at/themen/krankheitserreger/coronavirus/)", size(vsmall)) rows(1)) ///
			legend(order(1 "At least 2 vaccines" 2 "At least 1 vaccine" 3 "Unvaccinated") rows(1) size(medsmall)) ///		
			xsize(2) ysize(1) 

		graph export "./figures/covid19_austria_incidence1.png", replace wid(2000)					
			

 // share unvacc over full vac
twoway ///
	(line share date if agegroup==1) ///
	(line share date if agegroup==2) ///
	(line share date if agegroup==3) ///	
		, ///
			ytitle("Ratio of 7-day incidence rate") ///
			ylabel(, labsize(small)) ///
			xtitle("") ///
			xlabel(, labsize(vsmall) angle(vertical)) ///
			legend(order(1 "12-17 years" 2 "18-59 years" 3 "60+ years") cols(1) pos(11) ring(0) size(small)) ///
			title("Comparison of incidence rates by vaccination status and age group") ///
			note("Source: AGES (https://www.ages.at/themen/krankheitserreger/coronavirus/)", size(vsmall))

		graph export "./figures/covid19_austria_incidence2.png", replace wid(2000)	



	