


/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Figure 1 (Panel A and B) */
/* This program runs the smoothing procedures to get the gradient charts */

clear all
cd "/Users/Levere/Dropbox/LevereDLHS"
set mem 2000m
set more off

/* First, for Bihar, get the school/age gradients */
log using "gradients.log", replace

use dlhs_raw_kids, clear

keep if state==10


lowess inschool age, msymbol(i) gen(inschool_sm_bihar) nog
lowess inschool age if sex==1, msymbol(i) gen(inschool_sm_bihar_male) nog
lowess inschool age if sex==2, msymbol(i) gen(inschool_sm_bihar_female) nog
by age, sort: egen inschool_bihar = mean(inschool_sm_bihar)
by age: egen inschool_bihar_male = mean(inschool_sm_bihar_male)
by age: egen inschool_bihar_female = mean(inschool_sm_bihar_female)
by age: keep if _n == 1
keep age inschool_bihar inschool_bihar_female inschool_bihar_male
save schoolage, replace

/* Next, enrollment in secondary school by distance for kids aged 16-17 */
use dlhs_raw_kids, clear

keep if state == 10
keep if age == 16 | age == 17

/* Truncate distance at 15 km */
drop if secondarydist > 15

/* Variable highschool "Indicator variable for enrolled in or completed grade 9 (secondary school)" */

lowess highschool secondarydist, msymbol(i) gen(highschool_sm_bihar) nog
lowess highschool secondarydist if sex==1, msymbol(i) gen(highschool_sm_bihar_male) nog
lowess highschool secondarydist if sex==2, msymbol(i) gen(highschool_sm_bihar_female) nog

by secondarydist, sort: egen highschool_bihar = mean(highschool_sm_bihar)
by secondarydist: egen highschool_bihar_male = mean(highschool_sm_bihar_male)
by secondarydist: egen highschool_bihar_female = mean(highschool_sm_bihar_female)
by secondarydist: keep if _n == 1
keep secondarydist highschool_bihar highschool_bihar_female highschool_bihar_male
save schooldist, replace


/************************************************************************/
/************************************************************************/
/************************************************************************/

/* Now do same exercise but for all of India */
/* First, get the school/age gradients */

use dlhs_raw_kids, clear

lowess inschool age, msymbol(i) gen(inschool_sm_india) nog
lowess inschool age if sex==1, msymbol(i) gen(inschool_sm_india_male) nog
lowess inschool age if sex==2, msymbol(i) gen(inschool_sm_india_female) nog
by age, sort: egen inschool_india = mean(inschool_sm_india)
by age: egen inschool_india_male = mean(inschool_sm_india_male)
by age: egen inschool_india_female = mean(inschool_sm_india_female)
by age: keep if _n == 1
keep age inschool_india inschool_india_female inschool_india_male
merge 1:1 age using schoolage
drop _merge
save schoolage, replace

/* Next, enrollment in secondary school by distance for kids aged 16-17 */
use dlhs_raw_kids, clear

keep if age == 16 | age == 17

/* Truncate distance at 15 km */
drop if secondarydist > 15

lowess highschool secondarydist, msymbol(i) gen(highschool_sm_india) nog
lowess highschool secondarydist if sex==1, msymbol(i) gen(highschool_sm_india_male) nog
lowess highschool secondarydist if sex==2, msymbol(i) gen(highschool_sm_india_female) nog

by secondarydist, sort: egen highschool_india = mean(highschool_sm_india)
by secondarydist: egen highschool_india_male = mean(highschool_sm_india_male)
by secondarydist: egen highschool_india_female = mean(highschool_sm_india_female)
by secondarydist: keep if _n == 1
keep secondarydist highschool_india highschool_india_female highschool_india_male
merge 1:1 secondarydist using schooldist
drop _merge
save schooldist, replace

/* This do file produces two data sets - schooldist.dta and schoolage.dta using dlhs_raw_kids - After this do file, run gradient in R to produce Charts - Figure 1 */


log close
