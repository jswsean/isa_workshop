
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 2: Triple Difference (DDD) Estimate of the Impact of Being Exposed to the Cycle Program on Girl's Secondary School Enrollment */

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

local village middle bank postoff lcurrpop

* Distance to Different Facilities

local dist busdist towndist railwaydist hqdist

* Triple Difference (w.r.t. Jharkhand) *
* Regression Results - Table 2 *
* Treatment = Age 14-15 vs. Control = Age 16-17 *

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a1

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a2

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' `household' [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a3

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' `household' `village' `dist' [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a4

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-2.xls", dec(3) replace

