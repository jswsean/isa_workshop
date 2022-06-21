clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off

use "Cycle_Enrol_reg.dta", clear

* Here we test parallel trend assumption using administrative data from Bihar and Jharkhand  *
keep if year < 2007

* Drop unnecessary variables *
drop if statecode==3


* Keeping variables needed for the regression *

keep statename statecode district district_code distborder blockname block_code schoolname school_code year_established allboys_ allgirls_ coed class year gender enrollment male female bh jh treat    

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\bh_enroll_data_reg", replace

