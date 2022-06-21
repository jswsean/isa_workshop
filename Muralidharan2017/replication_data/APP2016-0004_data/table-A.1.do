
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table A.1: Descriptive Statistics in Estimation Sample */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
use dlhs-reg-data.dta
drop if bihar==.


/* PANEL A (Dependent Variable (control group means) for Bihar */

/* Enrolled in or completed grade 9 (among 16-17 year old boys) */
tabstat enrollment_secschool if treat1 == 0 & bihar==1 & female == 0,  statistics(mean, sd, N)

/* Enrolled in or completed grade 9 (among 16-17 year old girls) */
tabstat enrollment_secschool if treat1 == 0 & bihar==1 & female == 1,  statistics(mean, sd, N)


/* PANEL A (Dependent Variable (control group means) for Jharkhand */

/* Enrolled in or completed grade 9 (among 16-17 year old boys) */
tabstat enrollment_secschool if treat1 == 0 & bihar==0 & female == 0,  statistics(mean, sd, N)

/* Enrolled in or completed grade 9 (among 16-17 year old girls) */
tabstat enrollment_secschool if treat1 == 0 & bihar==0 & female == 1,  statistics(mean, sd, N)

 
/* PANEL B, C, D, E Descriptive Statistics for Bihar */

tabstat treat1 female sc st obc hindu muslim hhheadschool hhheadmale land bpl media electricity primary middle secschool bank postoff busdist towndist railwaydist hqdist lcurrpop if treat1 ~= . & bihar==1, statistics(mean, sd, N)


/* PANEL B, C, D, E Descriptive Statistics for Jharkhand */

tabstat treat1 female sc st obc hindu muslim hhheadschool hhheadmale land bpl media electricity primary middle secschool bank postoff busdist towndist railwaydist hqdist lcurrpop if treat1 ~= . & bihar==0, statistics(mean, sd, N)
