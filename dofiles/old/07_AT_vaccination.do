clear

set scheme white_tableau, perm

cap cd "D:\Programs\Dropbox\Dropbox\PROJECT COVID AT"



import delimited using "https://www.ages.at/fileadmin/AGES2015/Themen/Krankheitserreger_Dateien/Coronavirus/Inzidenz_Impfstatus/Inzidenz_vollstaendig_unvollstaendig_geimpft_2021-08-20.csv",  varn(1)

drop datum

replace inzidenz = subinstr(inzidenz, ",", ".", .)

replace vollständiggeimpft = "1" if vollständiggeimpft=="Ja"
replace vollständiggeimpft = "0" if vollständiggeimpft=="Nein"
	

replace altersgruppe = "1" if altersgruppe=="12-17 Jahre"
replace altersgruppe = "2" if altersgruppe=="18-59 Jahre"
replace altersgruppe = "3" if altersgruppe=="60+ Jahre"



destring _all, replace


ren vollständiggeimpft vaccinated
lab de yesno 1 "Yes" 0 "No"
lab val vaccinated yesno

	
ren altersgruppe agegroup
lab de agerange 1 "12-17 years" 2 "18-59 years" 3 "60+ years", replace
lab val agegroup agerange




gen day   = substr(datum_formatiert,1,2)
gen month = substr(datum_formatiert,4,2)
gen year  = substr(datum_formatiert,7,4)
destring month day year, replace
drop datum_formatiert
gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-yy	
	
ren inzidenz incidence

lab var date 		"Date"
lab var agegroup 	"Age group"
lab var vaccinated 	"Fully vaccinated"
lab var incidence 	"7-day incidence rate per 10k population"



order date 	








**** graphs below

twoway ///
	(line incidence date if vaccinated==0) ///
	(line incidence date if vaccinated==1) ///
		, ///
			ylabel(, labsize(small)) ///
			xtitle("") ///
			xlabel(, labsize(vsmall) angle(vertical)) ///
			by(agegroup, note("Source: AGES (https://www.ages.at/themen/krankheitserreger/coronavirus/)", size(vsmall)) rows(1)) ///
			legend(order(1 "Not vaccinated" 2 "Fully vaccinated") rows(1) size(small)) ///
			xsize(2) ysize(1) 

		graph export "./figures/covid19_austria_incidence1.png", replace wid(2000)					
			
*** reshape 

reshape wide incidence, i(date agegroup) j(vaccinated)

sort agegroup date

gen share = incidence0 / incidence1


twoway ///
	(line share date if agegroup==1) ///
	(line share date if agegroup==2) ///
	(line share date if agegroup==3) ///	
		, ///
			ytitle("Ratio of 7-day incidence rate of not vaccinated/fully vaccinated") ///
			ylabel(, labsize(small)) ///
			xtitle("") ///
			xlabel(, labsize(vsmall) angle(vertical)) ///
			legend(order(1 "12-17 years" 2 "18-59 years" 3 "60+ years") cols(1) pos(11) ring(0) size(small)) ///
			note("Source: AGES (https://www.ages.at/themen/krankheitserreger/coronavirus/)", size(vsmall))

		graph export "./figures/covid19_austria_incidence2.png", replace wid(2000)	



	