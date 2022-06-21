

/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table A.5: Heterogeneous Effects of Exposure to the Cycle Program on Girls' Enrollment in Secondary School */

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

* SC versus High Caste *

gen sc_highcaste = 0
replace sc_highcaste = 1 if sc==1|highcaste==1

* ST versus High Caste *

gen st_highcaste = 0
replace st_highcaste = 1 if st==1|highcaste==1

* OBC versus High Caste *

gen obc_highcaste = 0
replace obc_highcaste = 1 if obc==1|highcaste==1

* Muslims versus High Caste *

gen muslim_highcaste = 0
replace muslim_highcaste = 1 if muslim==1|highcaste==1



* DDDD with PCA_ASSET *
reg enrollment_secschool treat1_female_bihar_pca_asset treat1_female_pca_asset treat1_female_bihar female_bihar_pca_asset treat1_bihar_pca_asset treat1_female treat1_pca_asset treat1_bihar female_pca_asset female_bihar bihar_pca_asset treat1 female bihar pca_asset [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store a1

* If School > 3 km *
reg enrollment_secschool treat1_female_bihar_pca_asset treat1_female_pca_asset treat1_female_bihar female_bihar_pca_asset treat1_bihar_pca_asset treat1_female treat1_pca_asset treat1_bihar female_pca_asset female_bihar bihar_pca_asset treat1 female bihar pca_asset [pw = hhwt] if treat1 ~= . & longdist == 1, robust cluster(village)
estimates store a3

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.5-PCA-ASSET.xls", dec(3) replace


* DDDD with PCA_SES *
reg enrollment_secschool treat1_female_bihar_pca_ses treat1_female_pca_ses treat1_female_bihar female_bihar_pca_ses treat1_bihar_pca_ses treat1_female treat1_pca_ses treat1_bihar female_pca_ses female_bihar bihar_pca_ses treat1 female bihar pca_ses [pw = hhwt] if treat1 ~= ., robust cluster(village)
estimates store b1


* If School > 3 km *
reg enrollment_secschool treat1_female_bihar_pca_ses treat1_female_pca_ses treat1_female_bihar female_bihar_pca_ses treat1_bihar_pca_ses treat1_female treat1_pca_ses treat1_bihar female_pca_ses female_bihar bihar_pca_ses treat1 female bihar pca_ses [pw = hhwt] if treat1 ~= . & longdist == 1, robust cluster(village)
estimates store b3

outreg2 [b*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.5-PCA-SES.xls", dec(3) replace

* DDDD BY CASTE *
* SC vs. HIGH CASTE *
reg enrollment_secschool treat1_female_bihar_sc treat1_female_sc treat1_female_bihar female_bihar_sc treat1_bihar_sc treat1_female treat1_sc treat1_bihar female_sc female_bihar bihar_sc treat1 female bihar sc `household' `village' `dist' [pw = hhwt] if treat1 ~= . & sc_highcaste==1, robust cluster(village)
estimates store c2

* If School > 3 km *
reg enrollment_secschool treat1_female_bihar_sc treat1_female_sc treat1_female_bihar female_bihar_sc treat1_bihar_sc treat1_female treat1_sc treat1_bihar female_sc female_bihar bihar_sc treat1 female bihar sc `household' `village' `dist' [pw = hhwt] if treat1 ~= . & longdist == 1 & sc_highcaste==1, robust cluster(village)
estimates store c4

outreg2 [c*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.5-SC-GENERAL.xls", dec(3) replace

* ST vs. HIGH CASTE *
reg enrollment_secschool treat1_female_bihar_st treat1_female_st treat1_female_bihar female_bihar_st treat1_bihar_st treat1_female treat1_st treat1_bihar female_st female_bihar bihar_st treat1 female bihar st `household' `village' `dist' [pw = hhwt] if treat1 ~= . & st_highcaste==1, robust cluster(village)
estimates store d2


* If School > 3 km *
reg enrollment_secschool treat1_female_bihar_st treat1_female_st treat1_female_bihar female_bihar_st treat1_bihar_st treat1_female treat1_st treat1_bihar female_st female_bihar bihar_st treat1 female bihar st `household' `village' `dist' [pw = hhwt] if treat1 ~= . & longdist == 1 & st_highcaste==1, robust cluster(village)
estimates store d4

outreg2 [d*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.5-ST-GENERAL.xls", dec(3) replace

* OBC vs. HIGH CASTE *
reg enrollment_secschool treat1_female_bihar_obc treat1_female_obc treat1_female_bihar female_bihar_obc treat1_bihar_obc treat1_female treat1_obc treat1_bihar female_obc female_bihar bihar_obc treat1 female bihar obc `household' `village' `dist' [pw = hhwt] if treat1 ~= . & obc_highcaste==1, robust cluster(village)
estimates store e2

* If School > 3 km *
reg enrollment_secschool treat1_female_bihar_obc treat1_female_obc treat1_female_bihar female_bihar_obc treat1_bihar_obc treat1_female treat1_obc treat1_bihar female_obc female_bihar bihar_obc treat1 female bihar obc `household' `village' `dist' [pw = hhwt] if treat1 ~= . & longdist == 1 & obc_highcaste==1, robust cluster(village)
estimates store e4

outreg2 [e*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.5-OBC-GENERAL.xls", dec(3) replace


* MUSLIM vs. HIGH CASTE *
reg enrollment_secschool treat1_female_bihar_muslim treat1_female_muslim treat1_female_bihar female_bihar_muslim treat1_bihar_muslim treat1_female treat1_muslim treat1_bihar female_muslim female_bihar bihar_muslim treat1 female bihar muslim  `household' `village' `dist' [pw = hhwt] if treat1 ~= . & muslim_highcaste==1, robust cluster(village)
estimates store f2

* If School > 3 km *
reg enrollment_secschool treat1_female_bihar_muslim treat1_female_muslim treat1_female_bihar female_bihar_muslim treat1_bihar_muslim treat1_female treat1_muslim treat1_bihar female_muslim female_bihar bihar_muslim treat1 female bihar muslim  `household' `village' `dist' [pw = hhwt] if treat1 ~= . & longdist == 1 & muslim_highcaste==1, robust cluster(village)
estimates store f4

outreg2 [f*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.5-MUSLIM-GENERAL.xls", dec(3) replace



