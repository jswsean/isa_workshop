
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table A.8: Further Robustness (Border Districts and Clustering) */

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

* Panel A: Impact of Being Exposed to the Cycle Program on Girl's Secondary School Enrollment (Border Districts Only) *

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar [pw = hhwt] if treat1 ~= . & distborder==1, robust cluster(village)
estimates store a1

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' [pw = hhwt] if treat1 ~= . & distborder==1, robust cluster(village)
estimates store a2

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' `household' [pw = hhwt] if treat1 ~= . & distborder==1 , robust cluster(village)
estimates store a3

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' `household' `village' `dist' [pw = hhwt] if treat1 ~= . & distborder==1, robust cluster(village)
estimates store a4

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.8-PANEL-A.xls", dec(3) replace


* Panel B: Clustering at District Level (instead of village-level) *

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar [pw = hhwt] if treat1 ~= ., robust cluster(dist)
estimates store b1

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' [pw = hhwt] if treat1 ~= ., robust cluster(dist)
estimates store b2

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' `household' [pw = hhwt] if treat1 ~= ., robust cluster(dist)
estimates store b3

reg enrollment_secschool treat1_female_bihar treat1_female treat1_bihar female_bihar treat1 female bihar `demographic' `household' `village' `dist' [pw = hhwt] if treat1 ~= ., robust cluster(dist)
estimates store b4

outreg2 [b*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.8-PANEL-B.xls", dec(3) replace





