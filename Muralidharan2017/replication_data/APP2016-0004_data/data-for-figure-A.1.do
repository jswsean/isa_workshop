
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Data for Figure A.1: Distribution of Villages by Distance to Nearest Secondary School */

clear all
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set mem 1000m
use dlhs-reg-data.dta

drop if secondarydist > 25

keep state dist vpsu village secondarydist
by state dist village, sort: keep if _n == 1

merge m:1 state dist vpsu using DLHS3VIND, keepusing(state dist vpsu v101b psupop) nogen keep(matches)

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\dlhs-figure-A.1.dta"


