
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 4: Impact of Exposure to the Cycle Program on Girls' Appearance in and Performance on Grade 10 Board Exams */


clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
capture log close
use "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\exam_data.dta" 

/* The Policy was implemented in Bihar in the year 2006, therefore the 10th Grade Exams after the Cycle Policy were conducted in 2008. However we omit year 2008 as its the transition year and treat year 2009-2010 as Post years. We use Pre years as 2004, 2005, 2006, 2007 */

*** Omit 2008 as its the transition year ***
drop if year == 2008

gen post = .
replace post = 1 if year == 2009|year==2010
replace post = 0 if year==2004|year==2005|year == 2006|year==2007
label var post "Indicator variable for Post Years"

******************************************************************************

//** Collapsing **//

collapse (mean) appear_tot pass_tot district_code, by (school_code statecode post gender statename)

//** Bihar is the Treatment State **//

gen treat = 1 if statecode == 1
replace treat = 0 if statecode == 2
label var treat "State Bihar is the Treatment State"

//** Gender Dummy **//

gen male = (gender == 1)
gen female = (gender == 2)
label var male "Male Dummy"
label var female "Female Dummy"

/* Generating Interaction between treatment state and post year */

/** Double Difference **/

gen bh_post = treat*post
label var bh_post "DD Interaction, Bihar*Post Years"

gen female_post = female*post
label var female_post "DD Interaction, Female*Post Years"

gen female_treat = female*treat
label var female_treat "DD Interaction, Female*Bihar"

** Triple Difference **
gen triple = treat*post*female
label var triple "DDD Interaction, Female*Post*Bihar"

** Creating Dependent Variable in Logs **

gen lappear = log(appear_tot)
label var lappear "Log (Number of Candidates who Appeared for the 10th Grade Exam)"

gen lpass = log(pass_tot)
label var lpass "Log (Number of Candidates who Passed the 10th Grade Exam)"

** Creating an Indicator for whether a school has non-zero data for a given gender in both pre and post periods **

by school_code gender, sort: egen sch_gender_prepost_appear = count(lappear)
label var sch_gender_prepost_appear "Indicator for school in pre and post periods (Appear)"
by school_code gender, sort: egen sch_gender_prepost_pass = count(lpass)
label var sch_gender_prepost_pass "Indicator for school in pre and post periods (Pass)"

/** If the indicators above are 2 then the school is valid to use for our estimation. Note that this will include 3 types of schools: co-ed schools with non-zero pre & post data 
for both genders; single-sex schools with non-zero pre & post data and co-ed schools with non-zero pre & post data for any one gender (the other gender for that schoool will get 
dropped because of the absence of pre & post data) **/


//*** Regression for Table 4 ***//

//* Triple Difference Results *// 

* SCHOOL LEVEL, Dependent variable = Log(Total Appeared)

reg lappear triple female_treat bh_post female_post female treat post if sch_gender_prepost_appear==2, robust 
estimates store a1

* SCHOOL LEVEL, Dependent variable = Log(Total Passed)

reg lpass triple female_treat bh_post female_post female treat post if sch_gender_prepost_pass==2, robust 
estimates store a2

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-4.xls", dec(3) replace 
