/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 6: Robustness to Alternative Definitions of Treatment and Control Cohorts */
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



* TABLE - 6 - PANEL - C - ROW - 1 *
* Triple Difference (w.r.t. Jharkhand) *
* The treatment group is 13, 14 and 15 while the control group is 16 *


reg enrollment_secschool treat4_female_bihar treat4_female treat4_bihar female_bihar treat4 female bihar [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store a1

reg enrollment_secschool treat4_female_bihar treat4_female treat4_bihar female_bihar treat4 female bihar `demographic' [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store a2

reg enrollment_secschool treat4_female_bihar treat4_female treat4_bihar female_bihar treat4 female bihar `demographic' `household' [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store a3

reg enrollment_secschool treat4_female_bihar treat4_female treat4_bihar female_bihar treat4 female bihar `demographic' `household' `village' `dist' [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store a4

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-6-PANEL-C-ROW-1.xls", dec(3) replace



* TABLE - 6 - PANEL - C - ROW - 2 *
* Quadruple-Difference (w.r.t. Jharkhand and Distance)*
* The treatment group is 13, 14 and 15 while the control group is 16 - long-distance dummy (greater than 3km) *

reg enrollment_secschool treat4_female_bihar_longdist treat4_female_longdist treat4_female_bihar female_bihar_longdist treat4_bihar_longdist treat4_female treat4_longdist treat4_bihar female_longdist female_bihar bihar_longdist treat4 female bihar longdist [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store b1

reg enrollment_secschool treat4_female_bihar_longdist treat4_female_longdist treat4_female_bihar female_bihar_longdist treat4_bihar_longdist treat4_female treat4_longdist treat4_bihar female_longdist female_bihar bihar_longdist treat4 female bihar longdist `demographic' [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store b2

reg enrollment_secschool treat4_female_bihar_longdist treat4_female_longdist treat4_female_bihar female_bihar_longdist treat4_bihar_longdist treat4_female treat4_longdist treat4_bihar female_longdist female_bihar bihar_longdist treat4 female bihar longdist `demographic' `household' [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store b3

reg enrollment_secschool treat4_female_bihar_longdist treat4_female_longdist treat4_female_bihar female_bihar_longdist treat4_bihar_longdist treat4_female treat4_longdist treat4_bihar female_longdist female_bihar bihar_longdist treat4 female bihar longdist `demographic' `household' `village' `dist' [pw = hhwt] if treat4 ~= ., robust cluster(village)
estimates store b4

outreg2 [b*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-6-PANEL-C-ROW-2.xls.xls", dec(3) replace







