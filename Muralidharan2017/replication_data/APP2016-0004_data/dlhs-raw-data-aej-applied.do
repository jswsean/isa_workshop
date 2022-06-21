

/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* THIS DO FILE STARTS WITH THE RAW DLHS (HOUSEHOLD LEVEL AND VILLAGE LEVEL) DATA FOR THE STATES BIHAR AND JHARKHAND */
clear all
set mem 2000m
set more off

use "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\DLHS3HIND.DTA"


* Will only care about Bihar (code 10), Uttar Pradesh (code 9)and Jharkhand (code 20)*
*
keep if state==10 | state==20
*

* Only keep the variables that we will eventually care about in the long data set to speed things up *
keep psupop state dist psu hhno htehsil hlnr hdate hmonth hyear hhwt hv103* hv104* hv105* hv106* hv107* hv108* hv109* hv110* hv111* hv112* hv113* hv114*   


* To reshape as long, need to rename all variables that end in 01 to be 1 (only care about hv105-114) *

qui foreach num of numlist 1/9{
   foreach var of numlist 103/114{
      rename hv`var'_0`num' hv`var'_`num'
   }
}

* Reshape the dataset to be long *
reshape long hv103_@ hv104_@ hv105_@ hv106_@ hv107_@ hv108_@ hv109_@ hv110_@ hv111_@ hv112_@ hv113_@ hv114_@, i(state dist psu htehsil hhno) j(respondent)

* Rename variables *
rename hv103_ relationship
rename hv104_ residence
rename hv105_ sex
rename hv106_ age
rename hv107_ marry
rename hv108_ read
rename hv109_ everschool
rename hv110_ neverschool_reason
rename hv111_ grade
rename hv112_ school
rename hv113_ noschool_reason
rename hv114_ marry_id

* Get rid of the empty observations that were transposed *
drop if sex==. & age==.

* Add a unique identifier for the village as well as the individual *
gen village = dist*100 + psu

set type double
gen id = dist*1000000+hhno*100+respondent
format %12.0g id
set type float

order state dist psu village id

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\dlhs_long.dta", replace

* Now create a dataset of various household level variables that will be merged back in *

clear

use "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\DLHS3HIND.DTA" 

* Rural indicator variable *
gen village = dist*100 + psu
gen rural = 1 if htype == 1
replace rural = 0 if htype == 2

* Gender/years of schooling of head of household *

* Drop weird observations (where household head is not first listed, where someone else is listed as the head of household) *

drop if hv103_01 ~= 1
foreach num of numlist 2/9{
drop if hv103_0`num' == 1
}
foreach num of numlist 10/50{
drop if hv103_`num' == 1
}

gen hhheadmale = 1 if hv105_01 == 1
replace hhheadmale = 0 if hv105_01 == 2

gen hhheadschool = hv111_01
replace hhheadschool = 0 if hv109_01 == 2

* Drops some wierd observations

*drop if hv109_01 == 9
*drop if hhheadschool==99

* Male/female levels of schooling for primary adult in household - defined to be the head of household or the spouse *
gen maleadultschool = hhheadschool if hhheadmale == 1
gen femaleadultschool = hhheadschool if hhheadmale == 0

foreach num of numlist 2/9{
replace maleadultschool = hv111_0`num' if maleadultschool == . & hv103_0`num' == 2 & hv105_0`num' == 1
replace maleadultschool = 0 if maleadultschool == . & hv103_0`num' == 2 & hv105_0`num' == 1 & hv109_0`num' == 2

replace femaleadultschool = hv111_0`num' if femaleadultschool == . & hv103_0`num' == 2 & hv105_0`num' == 2
replace femaleadultschool = 0 if femaleadultschool == . & hv103_0`num' == 2 & hv105_0`num' == 2 & hv109_0`num' == 2

}

foreach num of numlist 10/50{
replace maleadultschool = hv111_`num' if maleadultschool == . & hv103_`num' == 2 & hv105_`num' == 1
replace maleadultschool = 0 if maleadultschool == . & hv103_`num' == 2 & hv105_`num' == 1 & hv109_`num' == 2

replace femaleadultschool = hv111_`num' if femaleadultschool == . & hv103_`num' == 2 & hv105_`num' == 2
replace femaleadultschool = 0 if femaleadultschool == . & hv103_`num' == 2 & hv105_`num' == 2 & hv109_`num' == 2

}

* Also keep various household level variables that will be useful *

keep state dist psu hhno village rural hhheadmale hhheadschool maleadultschool femaleadultschool hv115-hv139 hv140*

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\dlhs_aggsum.dta", replace

clear

* Now merge both datasets back together to save the final version *

use "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\dlhs_long.dta"

merge m:1 state village hhno using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\dlhs_aggsum.dta"
keep if _merge == 3
drop _merge

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\dlhs_long.dta", replace

* Now add in the village level variables (namely distance to the nearest school) *
rename psu vpsu
sort state dist vpsu
merge m:1 state dist vpsu using "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-28-05-2014\Analysis\DLHS3VIND.DTA", keepusing(state dist vpsu v101* v102* v110* v111* v112* v113* v115* v122*)
keep if _merge == 3
drop _merge

save dlhs_long_wdist.dta, replace



