
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 1: Testing the Parallel Trends Assumption */

clear
if "`c(username)' == wb564190" {
	cd "C:\Users\wb564190\OneDrive - WBG\Documents\Indo_Econ_Workshop\Muralidharan2017\113676-V1\APP2016-0004_data"	
}

if "`c(username)'" == "Sean Hambali" {
	cd "C:\Users\Sean Hambali\Documents\GitHub\wb_isa_workshop\Muralidharan2017\replication_data\APP2016-0004_data"
}

set more off

use "bh_enroll_data_reg.dta", clear

* Converting enrollment in logs as the population base for Bihar and Jharkhand is different *
gen lenrollment = log(enrollment)

* Generating Interactions for testing parallel trend assumption *
gen n_year=year-2002

gen year_female = n_year*female

gen female_state = female*treat

gen state_year = treat*n_year

gen female_year_state = female*n_year*treat

/* Dependent variable: Log (9th Grade Enrollment by School, Gender, and Year) */

/* PANEL A: Testing Parallel Trends for the Difference-in-Difference (DD) */
reg lenrollment year_female female n_year if class == 9 & statecode==1, robust cluster(district_code)
estimates store a1

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-1-PANEL-A.xls", dec(3) replace


/* PANEL B: Testing Parallel Trends for the Triple Difference (DDD) */
reg lenrollment female_year_state year_female  female_state state_year female n_year treat if class == 9, robust cluster(district_code)
estimates store b1

outreg2 [b*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-1-PANEL-B.xls", dec(3) replace

