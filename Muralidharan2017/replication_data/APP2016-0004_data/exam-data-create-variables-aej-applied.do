
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Creating the Data needed to run Table A.6: Testing the Parallel Trends Assumption Using Exam Data */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
capture log close
use "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\cycle_test_school.dta" 

/* keeping the relevant variables for the exam data */

drop allboys_ allgirls_ coed distdumm* blockdumm* bb90_dumm* bb70_dumm* post n_year fem_year bh_year triple_year bh_post female_post female_treat triple bb_90 bb_70 third_tot second_tot first_tot dist_tot appear_block pass_block third_block second_block first_block dist_block appear_dist pass_dist third_dist second_dist first_dist dist_dist  lappear lappear_block lappear_dist lpass lpass_block lpass_dist ldist ldist_block ldist_dist lfirst lfirst_block lfirst_dist lsecond lsecond_block lsecond_dist lthird lthird_block lthird_dist treat
drop if statename=="Bihar" & statecode ==2

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\exam_data.dta", replace
















