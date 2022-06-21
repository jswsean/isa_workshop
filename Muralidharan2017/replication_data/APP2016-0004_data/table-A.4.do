
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table A.4: Do Socioeconomic Characteristics of the Estimation Sample Change Significantly across Treatment and Control Groups? */


clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
use dlhs-reg-data.dta
drop if bihar==.


* Defining locals *
* Local = Demographics *

* Local = Demographics *

local demographic sc st obc hindu muslim

* Local = Household level characteristics *

local household hhheadschool hhheadmale land bpl media electricity

* Local = Village level characteristics 

local village middle bank postoff lcurrpop

* Distance to Different Facilities

local dist busdist towndist railwaydist hqdist

*** REGRESSIONS ***
*** Dependent Variables are Controls from Table 2 Column 3  ***
*** DDDD with Controls as Dependent Variable ***

* HH Head Education *

reg hhheadschool treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a1

* Gender of HH Head *

reg hhheadmale treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a2

* Land *

reg land treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a3

* BPL *

reg bpl treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a4

* TV/Radio *

reg media treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a5

* Electricity *

reg electricity treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a6

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.4.xls", dec(3) replace

