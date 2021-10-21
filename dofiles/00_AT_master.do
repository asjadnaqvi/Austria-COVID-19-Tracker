clear


***********************
**  the one file to  ** 
**  to run them all  **
***********************

// install the schemes and packages
*ssc install colorpalette, replace
*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace

set scheme white_tableau
graph set window fontface "Arial Narrow"


// set your directory path here:
cap cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID AT"


// run all the files
do "./dofiles/01_AT_setup_v4.do"
do "./dofiles/02_AT_cases_stringency_v5.do"
do "./dofiles/03_AT_mobility.do"
do "./dofiles/04_AT_hospitalization.do"
do "./dofiles/05_AT_maps_BZ_v5.do"
do "./dofiles/06_AT setup_scrape_v1.do"
do "./dofiles/07_AT_incidence_by_vacc_agegrp_v1.do"
do "./dofiles/08_AT_vaccination_maps_v2.do"
do "./dofiles/09_AT_cases_by_age_v1.do"




**** END OF FILE *****