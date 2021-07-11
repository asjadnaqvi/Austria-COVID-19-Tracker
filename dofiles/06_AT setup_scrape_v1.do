clear
set scheme white_tableau, perm

cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"



**** scrapped data


import excel using "./raw/austria_scrapped_data.xlsx", first clear
ren anzahl* cases*
drop if id==.
compress
save "./temp/austria_scrapped_data.dta", replace


**** WIEN only data

gen wien = regexm(bezirk, "Wien")
*keep if temp==1
replace wien = 0 if bezirk=="Wien(Stadt)" | bezirk=="Wiener Neustadt(Land)" | bezirk=="Wiener Neustadt(Stadt)"

ren id id2
gen id = id2
replace id = 900 if wien==1

order id id2


// vienna breakdown was given for this dates only. aggregating them.
foreach x of varlist cases_0322 -  cases_0325 {
	egen temp_`x' = total(`x') if wien==1
	replace `x' = temp_`x' if wien==1
}

drop temp*
replace id = 900 if wien==1

duplicates drop id, force
replace bezirk="Wien (Stadt)" if id==900


drop wien
drop id2 bezirk2

ren cases_* d*

reshape long d, i(id bezirk) j(date2) string

ren d cases_old

gen month = substr(date2,1,2)
gen day   = substr(date2,3,4)
destring month day, replace

gen date = mdy(month,day,2020)
format date %tdDD-Mon-yy
drop date2 month day

order id date
xtset id date

compress
save ./master/austria_covid19_scrapped.dta, replace

**** merge with actual data

merge 1:1 id date using ./master/austria_covid19
keep if _m==3

gen diff    = cases - cases_old
gen diff_per = ((cases - cases_old)/cases_old) * 100


lab var cases 		"Cases (official data)"
lab var cases_old 	"Cases (scrapped data)"
lab var diff		"Difference (official - scraped)"
lab var diff_per	"Percentage difference (official - scraped)"


twoway ///
	(scatter cases_old cases, mcolor(%40) msize(small)) ///
	(function y = x, range(0 20000) lw(thin)), legend(off) ///
	xtitle("Cases (official)") ytitle("Cases (scraped)") 
graph export ./figures/difference_scrapped.png, replace wid(2000)

/*
twoway (dropline diff cases, mc(%40) lwidth(vvthin)),  aspect(1) xsize(1) ysize(1)
graph export ./figures/difference_scrapped2.png, replace wid(2000)


twoway (scatter diff_per cases if cases > 20, msize(small) mc(%20) lwidth(vvthin) lc(%20)),  aspect(1) xsize(1) ysize(1)
graph export ./figures/difference_scrapped3.png, replace wid(2000)
*/

