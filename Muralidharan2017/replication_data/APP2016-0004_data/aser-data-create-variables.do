
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Creates variables needed to run Table A.9: Triple Difference Estimates of Exposure to Cycle Program on Enrollment in the ASER 2008 Dataset */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off
set matsize 5000

use aser_2008_reg.dta

rename highschool enrollment_secschool


keep hh_multiplier enrollment_secschool state dist village state_name district_name hh_id hh_no hh_size m_primary m_middle m_sec m_hsec_above media mobile electricity house_pucca livestock v_electricity road std_booth postoff pds bank primary middle secschool pvt_school year distborder inschool currgrade treat14_female_bihar treat14_female treat14_bihar female_bihar treat14 female bihar 

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\data-reg-aser2008.dta", replace
