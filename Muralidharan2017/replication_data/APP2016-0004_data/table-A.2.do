
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table A.2: Difference-in-Difference (DD) Estimate of the Impact of Being Exposed to the Cycle Program on Girl's Secondary School Enrollment */

clear

cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
use dlhs-reg-data.dta
drop if bihar==.

* Treatment Group = 14 and 15 vs 16/17 as Control Group *
* Defining locals *
* Local = Demographics *

local demographic sc st obc hindu muslim

* Local = Household level characteristics *

local household hhheadschool hhheadmale land bpl media electricity

* Local = Village level characteristics 

local village middle bank postoff lcurrpop

* Distance to Different Facilities

local dist busdist towndist railwaydist hqdist

* Simple double-diff (only Bihar) *
* Regression Results - Appendix Table A.2 *


reg enrollment_secschool treat1_female treat1 female [pw = hhwt] if treat1 ~= . & bihar==1, robust cluster(village)
estimates store a1

reg enrollment_secschool treat1_female treat1 female `demographic' [pw = hhwt] if treat1 ~= . & bihar==1, robust cluster(village)
estimates store a2

reg enrollment_secschool treat1_female treat1 female `demographic' `household' [pw = hhwt] if treat1 ~= . & bihar==1, robust cluster(village)
estimates store a3

reg enrollment_secschool treat1_female treat1 female `demographic' `household' `village' `dist' [pw = hhwt] if treat1 ~= . & bihar==1, robust cluster(village)
estimates store a4

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.2.xls", dec(3) replace
