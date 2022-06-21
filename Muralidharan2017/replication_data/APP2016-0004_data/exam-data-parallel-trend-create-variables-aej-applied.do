
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Creating Data needed to run Table A.6: Testing the Parallel Trends Assumption Using Exam Data */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
capture log close
use "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\cycle_test_school-parallel-trend.dta"


drop allboys_ allgirls_ coed bb_90 bb_70 post bh_post female_post triple third_tot second_tot first_tot dist_tot appear_block pass_block third_block second_block first_block dist_block appear_dist pass_dist third_dist second_dist first_dist dist_dist lappear_block lappear_dist lpass_block lpass_dist ldist ldist_block ldist_dist lfirst lfirst_block lfirst_dist lsecond lsecond_block lsecond_dist lthird lthird_block lthird_dist treat


save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\exam_data_parallel_trend.dta", replace

