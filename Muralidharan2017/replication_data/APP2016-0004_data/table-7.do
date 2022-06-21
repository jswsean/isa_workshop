


/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */


/* Table 7: Gender Gaps in Secondary Schooling by Age, State, and Distance to a Secondary School */
/* Alternate way to think about DD and DDD - In terms of Gender Gap */
/* This do file produces results for alternative DD and DDD. We use reduction in gender gap as the dependent variable [Boy vs Girl; BH vs. JH; and Long-distance vs. Short-distance] by age [13--17] */

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


* WE START WITH SINGLE DIFFERENCE IN BIHAR, I.E. GIRLS VS. BOYS. WE RUN SEPERATE REGRESSION FOR AGE 13 THOUGH 17 *

* SINGLE DIFFERENCE W.R.T BOYS IN BIHAR *
* TABLE 7 - PANEL - A *

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 1 & age == 13, robust cluster(village)
estimates store a1

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 1 & age == 14, robust cluster(village)
estimates store a2

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 1 & age == 15, robust cluster(village)
estimates store a3

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 1 & age == 16, robust cluster(village)
estimates store a4

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 1 & age == 17, robust cluster(village)
estimates store a5

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-7-Panel-A.xls", dec(3) replace


* WE START WITH SINGLE DIFFERENCE IN JHARKHAND, I.E. GIRLS VS. BOYS. WE RUN SEPERATE REGRESSION FOR AGE 13 THOUGH 17 *

* SINGLE DIFFERENCE W.R.T BOYS IN JHARKHAND *
* TABLE 7 - PANEL - B *

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 0 & age == 13, robust cluster(village)
estimates store b1

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 0 & age == 14, robust cluster(village)
estimates store b2

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 0 & age == 15, robust cluster(village)
estimates store b3

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 0 & age == 16, robust cluster(village)
estimates store b4

reg enrollment_secschool female `demographic' `household' `village' `dist'  [pw = hhwt] if bihar == 0 & age == 17, robust cluster(village)
estimates store b5


outreg2 [b*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-7-Panel-B.xls", dec(3) replace

* NOW WE WILL DO DIFF-IN-DIFF (GIRLS VS. BOYS; BH VS. JH) *
* TABLE 7 - PANEL - C *

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 13, robust cluster(village)
estimates store c1

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 14, robust cluster(village)
estimates store c2

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 15, robust cluster(village)
estimates store c3

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 16, robust cluster(village)
estimates store c4

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 17, robust cluster(village)
estimates store c5


outreg2 [c*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-7-Panel-C.xls", dec(3) replace



* NOW WE WILL DO DIFF-IN-DIFF (GIRLS VS. BOYS; BH VS. JH) FOR SHORT DISTANCE, I.E. IF SCHOOL IS GREATHER THAN 3 KMS *
* TABLE 7 - PANEL - D *

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 13 & longdist == 1, robust cluster(village)
estimates store d1

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 14 & longdist == 1, robust cluster(village)
estimates store d2

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 15 & longdist == 1, robust cluster(village)
estimates store d3

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 16 & longdist == 1, robust cluster(village)
estimates store d4

reg enrollment_secschool female_bihar female bihar `demographic' `household' `village' `dist'  [pw = hhwt] if age == 17 & longdist == 1, robust cluster(village)
estimates store d5

outreg2 [d*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-7-Panel-D.xls", dec(3) replace


* AVERAGE FOR BOYS IN BIHAR BY AGE *

mean enrollment_secschool if female == 0 & bihar == 1 & age == 13 

mean enrollment_secschool if female == 0 & bihar == 1 & age == 14 

mean enrollment_secschool if female == 0 & bihar == 1 & age == 15 

mean enrollment_secschool if female == 0 & bihar == 1 & age == 16 

mean enrollment_secschool if female == 0 & bihar == 1 & age == 17 


* AVERAGE FOR BOYS IN JHARKHAND BY AGE *

mean enrollment_secschool if female == 0 & bihar == 0 & age == 13 

mean enrollment_secschool if female == 0 & bihar == 0 & age == 14 

mean enrollment_secschool if female == 0 & bihar == 0 & age == 15

mean enrollment_secschool if female == 0 & bihar == 0 & age == 16 

mean enrollment_secschool if female == 0 & bihar == 0 & age == 17 



