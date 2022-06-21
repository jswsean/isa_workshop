
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table A.6: Testing the Parallel Trends Assumption Using Exam Data */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
capture log close
use "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\exam_data_parallel_trend.dta"


/* PANEL A: Testing Parallel Trends for the Difference-in-Difference (DD) */

** Log (Number of Candidates who Appeared for the 10th Grade Exam) **
reg lappear fem_year female n_year if inappear_sample ==1 & n_year<4.5 & bh == 1, robust
estimates store a1

** Log (Number of Candidates who Passed the 10th Grade Exam) **
reg lpass fem_year female n_year if inappear_sample ==1 & n_year<4.5 & bh == 1, robust
estimates store a2

outreg2 [a*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.6-Panel-A.xls", dec(3) replace 

/* PANEL B: Testing Parallel Trends for the Triple Difference (DDD) */

** Log (Number of Candidates who Appeared for the 10th Grade Exam) **
reg lappear triple_year fem_year female_treat bh_year female n_year bh  if inappear_sample ==1 & n_year < 4.5, robust
estimates store b1

** Log (Number of Candidates who Passed the 10th Grade Exam) **
reg lpass triple_year fem_year female_treat bh_year female n_year bh  if inappear_sample ==1 & n_year < 4.5, robust
estimates store b3

outreg2 [b*] using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\REPLICATION TABLES\TABLE-A.6-Panel-B.xls", dec(3) replace 


