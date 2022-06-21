
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 8: Triple Difference (DDD) Estimate of the Impact of Being Exposed to the Cycle Program on Girl's Enrollment in Eighth Grade (Placebo Test)*/

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
use dlhs-reg-data.dta
drop if bihar==.

* Now for all regressions, the dependent variable of interest will be HIGHSCHOOL - the dummy for if the child has ever entered high school *
* 13/14 control group *
* Defining locals *
* Local = Demographics *

local demographic sc st obc hindu muslim

* Local = Household level characteristics *

local household hhheadschool hhheadmale land bpl media electricity

* Local = Village level characteristics 

local village middle bank postoff lcurrpop

* Distance to Different Facilities

local dist busdist towndist railwaydist hqdist


/* Table 8 */

* Triple Difference (w.r.t. Jharkhand) *
* The treatment group is 13 and 14 while the control group is 15 and 16 *

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar [pw = hhwt] if treat5 ~= ., robust cluster(village)
estimates store a1

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' [pw = hhwt] if treat5 ~= ., robust cluster(village)
estimates store a2

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' `household' [pw = hhwt] if treat5 ~= ., robust cluster(village)
estimates store a3

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' `household' `village' `dist' [pw = hhwt] if treat5 ~= ., robust cluster(village)
estimates store a4

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-8.xls", dec(3) replace



