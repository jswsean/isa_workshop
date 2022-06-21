


/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 3: Quadruple Difference (DDDD) Estimate of the Impact of Being Exposed to the Cycle Program on Girl's Secondary School Enrollment by Distance to Secondary School */

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


* Treatment = Age 14-15 vs. Control = Age 16-17 *

reg enrollment_secschool treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a1

reg enrollment_secschool treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist `demographic' [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a2

reg enrollment_secschool treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist `demographic' `household' [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a3

reg enrollment_secschool treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist `demographic' `household' `village' `dist' [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a4

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-3.xls",  dec(3) replace




