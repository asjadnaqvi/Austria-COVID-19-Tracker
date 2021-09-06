clear

cap cd "D:\Programs\Dropbox\Dropbox\PROJECT COVID AT"



import delimited using "https://info.gesundheitsministerium.gv.at/data/impfungen-gemeinden.csv",  varn(1)


gen day   = substr(datum,9,2)
gen month = substr(datum,6,2)
gen year  = substr(datum,1,4)
destring month day year, replace
drop datum
gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-yy	
	
order date

ren gemeindecode 			id
ren bevölkerung 			pop
ren teilgeimpfte			vac_partial
ren teilgeimpftepro100		vac_partial_per100k
ren vollimmunisierte		vac_full
ren vollimmunisiertepro100	vac_full_per100k

gen share_vacc_full = (vac_full / pop) * 100

*sort id date
*bysort id: gen change_7days = share_vacc_full - share_vacc_full[_n-7]


format share_vacc_full 	%9.2f
format change_7days 	%9.2f

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

merge m:1 id using ../master/AT_vaccincation_gemeinde.dta
drop _m



*********** active cases

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
		title("{fontface Arial Bold:Share of fully vaccinated in Gemeinde population (`date')}", size(large)) ///
		note("Map layer: Statistik Austria, Data: Gesundheitsministerium.", size(vsmall))
		graph export "../figures/covid19_share_fullvac.png", replace wid(3000)	

		

		
		
*** END OF FILE ***


