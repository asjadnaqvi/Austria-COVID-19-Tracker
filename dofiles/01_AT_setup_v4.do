clear

cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"




*** getting the raw data from https://covid19-dashboard.ages.at/


copy "https://covid19-dashboard.ages.at/data/data.zip" "./raw/data.zip", replace
cd raw
unzipfile data.zip, replace
cd ..


insheet using "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline_GKZ.csv", clear delim(;)


ren gkz id
ren anzeinwohner pop
ren anzahlfaelle cases_daily
ren anzahlfaellesum cases
ren anzahlfaelle7tage cases_7day
ren anzahltottaeglich deaths_daily
ren anzahltotsum deaths 
ren anzahlgeheilttaeglich recovered_daily 
ren anzahlgeheiltsum recovered
ren siebentageinzidenzfaelle incidence_7day

cap ren Time time

replace incidence_7day = subinstr(incidence_7day, ",",".",.)
destring incidence_7day, replace

gen day   = substr(time,1,2)
gen month = substr(time,4,2)
gen year  = substr(time,7,4)

destring month day year, replace

drop time

gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-yy

order date

sort date id

drop if id==.

merge m:1 id using ./raw/austria_bz_bdl
drop if _m!=3
drop _m


gen active = cases - deaths - recovered

sort bezirk date

order BDL BDL_id bezirk id date

compress
save "master/austria_covid19.dta", replace




**** Stringency file here

insheet using "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv", clear



keep if countryname=="Austria"
ren stringencyindexfordisplay stringency

tostring date, replace

gen year  = substr(date,1,4)
gen month = substr(date,5,2)
gen day   = substr(date,7,2)

destring month day year, replace

drop date

gen date = mdy(month,day,year)
format date %tdDD-Mon-yy

drop month day year
order date

compress
save ./master/austria_stringency.dta, replace


************ END OF FILE *************