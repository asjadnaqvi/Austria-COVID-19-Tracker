clear

cap cd "D:\Programs\Dropbox\Dropbox\PROJECT COVID AT"



import delimited using "https://info.gesundheitsministerium.at/data/COVID19_vaccination_municipalities.csv",  varn(1)


gen day   = substr(date,9,2)
gen month = substr(date,6,2)
gen year  = substr(date,1,4)
destring month day year, replace
drop date
gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-yy	
	
order date

ren municipality_id 		id
ren municipality_name		name
ren municipality_population pop

ren dose_1	dose1
ren dose_2	dose2
ren dose_3	dose3

gen vac_full = dose2
gen boost_full = dose3

ren valid_certificates 			certificates
ren valid_certificates_percent	certificates_share


gen share_vacc_full = (vac_full / pop) * 100
gen share_boost_full = (boost_full / pop) * 100

*sort id date
*bysort id: gen change_7days = share_vacc_full - share_vacc_full[_n-7]


format share_vacc_full 	%9.2f
format share_boost_full %9.2f

*gen share_vacc_any  = ((vac_full + vac_partial) / pop) * 100


summ date
gen last = 1 if date==`r(max)'

compress
save ./master/AT_vaccincation_gemeinde.dta, replace

**** merge with spatial layer: source Statistik Austria. (https://data.statistik.gv.at/web/meta.jsp?dataset=OGDEXT_GEM_1)

cd GIS
// just run this once.
*spshape2dta STATISTIK_AUSTRIA_GEM_20210101, replace saving(gem)
	




use gem, clear
destring _all, replace	
compress

replace id = 70370 if id==70327

merge m:1 id using ../master/AT_vaccincation_gemeinde.dta
drop _m



*********** double vaccinated

*kdensity share_vacc_full if last==1


summ date

local date: display %tdd_m_y `r(max)'
display "`date'"

local date2 = subinstr(trim("`date'"), " ", "_", .)
display "`date2'"

colorpalette viridis, n(10) reverse nograph
local colors `r(p)'


	
spmap share_vacc_full using "gem_shp.dta" if last==1, ///
id(_ID) clm(k) cln(10) fcolor("`colors'")  ///  
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(white ..) ndocolor(gs8 ..) ndsize(vvthin ..) ndlabel("No cases") ///
		legend(pos(11) size(2.5) symx(2.5) symy(1.5)) legtitle("% share") legstyle(2) ///
  	    polygon(data("NUTS2_shp")  ocolor(black)  osize(thin) legenda(on) legl("Bundesländer")) ///
		title("{fontface Arial Bold:Share of double vaccinated in Gemeinde population (`date')}", size(large)) ///
		note("Map layer: Statistik Austria, Data: Gesundheitsministerium.", size(vsmall))
		
	graph export "../figures/covid19_share_fullvac.png", replace wid(3000)	

		
*********** boosted

summ date

local date: display %tdd_m_y `r(max)'
display "`date'"

local date2 = subinstr(trim("`date'"), " ", "_", .)
display "`date2'"

colorpalette viridis, n(10) reverse nograph
local colors `r(p)'


	
spmap share_boost_full using "gem_shp.dta" if last==1, ///
id(_ID) clm(k) cln(10) fcolor("`colors'")  ///  
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(white ..) ndocolor(gs8 ..) ndsize(vvthin ..) ndlabel("No cases") ///
		legend(pos(11) size(2.5) symx(2.5) symy(1.5)) legtitle("% share") legstyle(2) ///
  	    polygon(data("NUTS2_shp")  ocolor(black)  osize(thin) legenda(on) legl("Bundesländer")) ///
		title("{fontface Arial Bold:Share of boosted in Gemeinde population (`date')}", size(large)) ///
		note("Map layer: Statistik Austria, Data: Gesundheitsministerium.", size(vsmall))
		graph export "../figures/covid19_share_boosted.png", replace wid(3000)	

		
		
cd ..		
		
*** END OF FILE ***


