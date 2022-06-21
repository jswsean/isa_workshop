
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table A.7: Triple Difference (DDD) Estimate of the Impact of Being Exposed to the Cycle Program on Girl's Enrollment in Eighth Grade (Placebo Test) */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
use dlhs-reg-data.dta
drop if bihar==.


* Defining locals *
* Local = Demographics *

local demographic sc st obc hindu muslim

* Local = Household level characteristics *

local household hhheadschool hhheadmale land bpl media electricity

* Local = Village level characteristics 

local village bank postoff lcurrpop

* Distance to Different Facilities

local dist busdist towndist railwaydist hqdist

*** REGRESSIONS ***

* Triple Difference (w.r.t. Jharkhand) *
* treat5 "age 13/14 is treatment/age 15/16 is control *
* Panel A: No Middle School in the Village *

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar [pw = hhwt] if treat5 ~= . & middle == 0, robust cluster(village)
estimates store a1

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar  `demographic' [pw = hhwt] if treat5 ~= . & middle == 0, robust cluster(village)
estimates store a2

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' `household' [pw = hhwt] if treat5 ~= . & middle == 0, robust cluster(village)
estimates store a3

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' `household' `village' `dist' [pw = hhwt] if treat5 ~= . & middle == 0, robust cluster(village)
estimates store a4

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.7-PANEL-A.xls", dec(3) replace


* Triple Difference (w.r.t. Jharkhand) *
* treat5 "age 13/14 is treatment/age 15/16 is control *
* Panel B: Middle School in the Village *

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar [pw = hhwt] if treat5 ~= . & middle == 1, robust cluster(village)
estimates store a1

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' [pw = hhwt] if treat5 ~= . & middle == 1, robust cluster(village)
estimates store a2

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' `household' [pw = hhwt] if treat5 ~= . & middle == 1, robust cluster(village)
estimates store a3

reg enrollment_middleschool treat5_female_bihar treat5_female treat5_bihar female_bihar treat5 female bihar `demographic' `household' `village' `dist' [pw = hhwt] if treat5 ~= . & middle == 1, robust cluster(village)
estimates store a4


outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.7-PANEL-B.xls", dec(3) replace
