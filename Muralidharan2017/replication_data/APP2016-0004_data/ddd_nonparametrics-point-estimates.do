
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Prep files for Figure 2 */

/* Creates point estimates */
/* RUN THIS FIRST */
/* Next get point estimates on the DD coefficient for Bihar/Jharkhand, for the long distance grouping */
clear

use "data-for-fig-2.dta", clear

gen longdistgroup = round(secondarydist,1)
replace longdistgroup = 12 if secondarydist == 11
replace longdistgroup = 15 if secondarydist == 13 | secondarydist == 14
replace longdistgroup = 20 if secondarydist >= 16 & secondarydist <= 19
replace longdistgroup = 25 if secondarydist > 20


/* Establish village ID numbers to loop through (do it by distance to secondary school within each district) */
drop if treat14 == .
by state dist longdistgroup, sort: gen newid = _n
sort newid state dist longdistgroup
by newid: gen id2 = _n if newid == 1
sort state dist longdistgroup id2

/* Tempvill is the "ID" number for how many regressions we have to loop through */
by state dist longdistgroup: gen tempvill = sum(id2)
drop if tempvill == 14
replace tempvill = tempvill-1 if tempvill >= 14

/* Find the max */
egen dumb = max(tempvill)
local max = dumb
drop dumb newid id2


/* Do a diff in diff at the village level for age/boys */
gen treatcoeff = .
gen femcoeff = .
gen ddcoeff = .
forvalues i= 1/`max' {
qui reg highschool treat14 female treat14_female if tempvill == `i'
qui replace treatcoeff = _b[treat14] if tempvill == `i'
qui replace femcoeff = _b[female] if tempvill == `i'
qui replace ddcoeff = _b[treat14_female] if tempvill == `i'
}
by state dist tempvill, sort: egen numobs = count(id)
by state dist tempvill: keep if _n == 1
keep state dist tempvill longdistgroup treatcoeff femcoeff ddcoeff numobs

/* Do the lowess smoothing */
collapse (mean) ddcoeff, by(longdistgroup state)
reshape wide ddcoeff, i(longdistgroup) j(state)

lowess ddcoeff10 longdistgroup, msymbol(i) gen(dd10) nog
lowess ddcoeff20 longdistgroup, msymbol(i) gen(dd20) nog

keep longdistgroup dd10 dd20
save "ddd_long.dta", replace


