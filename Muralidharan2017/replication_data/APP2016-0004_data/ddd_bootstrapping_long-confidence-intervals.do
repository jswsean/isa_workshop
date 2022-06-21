

/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Prep files for Figure 2 */

/* First Run the do file ddd_nonparametric-point-estimates */
/* Now do bootstrapping for confidence intervals for long distances */


clear
cd C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\NON-PARAMETRIC-03-08-2015
gen obs = .
forvalues i = 0/29{
gen dd`i' = .
}
save ddd_bootstraps_long, replace

set seed 339489376

local it = 10000
forvalues j = 1(1)`it' {

clear
use "data-for-fig-2.dta"
drop if treat14 == .
/* Manual fix- don't want to get a particular household ID that wont' work (tempvill == 14) */
drop if id == 1002002504
bsample, strata(dist) cluster(village)
sort state dist secondarydist

gen longdistgroup = round(secondarydist,1)
replace longdistgroup = 12 if secondarydist == 11
replace longdistgroup = 15 if secondarydist == 13 | secondarydist == 14
replace longdistgroup = 20 if secondarydist >= 16 & secondarydist <= 19
replace longdistgroup = 25 if secondarydist > 20

/* Create ID numbers */
by state dist longdistgroup, sort: gen newid = _n
sort newid state dist longdistgroup
by newid: gen id2 = _n if newid == 1
sort state dist longdistgroup id2

/* Tempvill is the "ID" number for how many regressions we have to loop through */
by state dist longdistgroup: gen tempvill = sum(id2)

/* Find the max */
egen dumb = max(tempvill)
local max = dumb
drop dumb newid id2


/* Do a diff in diff at the village level for age/boys */
gen treatcoeff = .
gen femcoeff = .
gen ddcoeff = .
qui forvalues i= 1/`max' {
capture reg highschool treat14 female treat14_female if tempvill == `i'
replace treatcoeff = _b[treat14] if tempvill == `i'
replace femcoeff = _b[female] if tempvill == `i'
replace ddcoeff = _b[treat14_female] if tempvill == `i'
}
by state dist tempvill, sort: egen numobs = count(id)
by state dist tempvill: keep if _n == 1
keep state dist tempvill longdistgroup treatcoeff femcoeff ddcoeff numobs

/* Do the lowess smoothing */
collapse (mean) ddcoeff, by(longdistgroup state)
lowess ddcoeff longdistgroup if state == 10, msymbol(i) gen(dd) nog
lowess ddcoeff longdistgroup if state == 20, msymbol(i) gen(ddest2) nog
replace dd=ddest2 if dd==.
keep state longdistgroup dd
sort state longdistgroup
gen obs = `j'
gen var = _n
replace var = var-1
drop longdistgroup state
reshape wide dd, i(obs) j(var)
append using ddd_bootstraps_long
save ddd_bootstraps_long, replace

}

clear
use ddd_bootstraps_long
forvalues i=0/14{
local j = `i'+15
gen diff`i' = dd`i'-dd`j'
}
save ddd_bootstraps_long, replace


/* Make shell for confidence intervals */
clear
gen longdistgroup = .
gen ci_low = .
gen ci_high = .
save ddd_bootstrap_ci_long, replace


forvalues i = 0/29{
clear
use ddd_bootstraps_long
sort dd`i'
keep dd`i'
gen obs = _n
gen dummy = 1
keep if obs == 250 | obs == 9750
reshape wide dd`i', i(dummy) j(obs)
drop dummy
keep dd`i'250 dd`i'9750
rename dd`i'250 ci_low
rename dd`i'9750 ci_high

gen longdistgroup = `i'
append using ddd_bootstrap_ci_long
save ddd_bootstrap_ci_long, replace
}

forvalues i = 0/14{
clear
use ddd_bootstraps_long
sort diff`i'
keep diff`i'
gen obs = _n
gen dummy = 1
keep if obs == 250 | obs == 9750
reshape wide diff`i', i(dummy) j(obs)
drop dummy
rename diff`i'250 ci_low
rename diff`i'9750 ci_high

gen longdistgroup = 30+`i'
append using ddd_bootstrap_ci_long
save ddd_bootstrap_ci_long, replace
}


sort longdistgroup
gen state=10 if longdistgroup <= 14
replace state=20 if longdistgroup > 14 & longdistgroup <= 29
replace state=30 if longdistgroup >= 30
replace longdistgroup = mod(longdistgroup,15)

reshape wide ci_low ci_high, i(longdistgroup) j(state)
replace longdistgroup = 15 if longdistgroup == 12
replace longdistgroup = 20 if longdistgroup == 13
replace longdistgroup = 25 if longdistgroup == 14
replace longdistgroup = 12 if longdistgroup == 11

merge 1:1 longdistgroup using ddd_long
gen diff = dd10-dd20
save ddd_long.dta, replace


