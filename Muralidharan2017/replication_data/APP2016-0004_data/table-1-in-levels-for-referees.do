
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 1 in Levels for Referees: Testing the Parallel Trends Assumption */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off

use "bh_enroll_data_reg.dta", clear

drop if enrollment == 0

* Generating Interactions for testing parallel trend assumption *
gen n_year=year-2002

gen year_female = n_year*female

gen female_state = female*treat

gen state_year = treat*n_year

gen female_year_state = female*n_year*treat

/* Dependent variable: (9th Grade Enrollment by School, Gender, and Year) */

/* PANEL A: Testing Parallel Trends for the Difference-in-Difference (DD) */
reg enrollment year_female female n_year if class == 9 & statecode==1, robust cluster(district_code)
estimates store a1

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-1-PANEL-A-(Levels).xls", dec(3) replace


/* PANEL B: Testing Parallel Trends for the Triple Difference (DDD) */
reg enrollment female_year_state year_female  female_state state_year female n_year treat if class == 9, robust cluster(district_code)
estimates store b1

outreg2 [b*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-1-PANEL-B-(Levels).xls", dec(3) replace



























