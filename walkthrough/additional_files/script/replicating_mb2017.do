/*
	Author		: Martinez-Bravo, adapted by Sean Hambali
	Project		: Replicating Martinez-Bravo (2017)
	Last update	: 2022-06-23 -- V.00 -- File creation
*/

// removing prior work environment 
clear all
clear matrix
clear mata
set more off

// setting up the globals 
if "`c(username)'" == "Sean Hambali" {
	gl do "C:/Users/Sean Hambali/Documents/GitHub/wb_isa_workshop/walkthrough/additional_files/script"
	gl raw_data "C:/Users/Sean Hambali/Documents/GitHub/wb_isa_workshop/walkthrough/113664-V1/AEJApp-2015-0447_Dataset"
	gl graph "C:/Users/Sean Hambali/Documents/GitHub/wb_isa_workshop/walkthrough/additional_files/graphs"
}

/*
	========================================
	FIGURE 1. Reduced form of election years 
	========================================
*/

use "$raw_data/VHeduc_Data", clear

// we set up the data as panel 
xtset v_id year

// first, we generate the election period cohort 
g election_cohort = 1993 if ele1v_post92==1992 | ele1v_post92==1993 
replace election_cohort = 1996 if ele1v_post92==1994 | ele1v_post92==1995  | ele1v_post92==1996
replace election_cohort = 2000 if ele1v_post92==1997 | ele1v_post92==1998 | ele1v_post92==1999

* performing looping across outcome variables and dependent variables 
eststo clear 
foreach y in 1993 1996 2000 {
	foreach v in dum doc safe pos garb yrsedu {
		qui eststo e_c`y'_`v' : xtreg `v' i.year##c.num_dev if ///
		election_cohort == `y', fe i(v_id) vce(cluster idkab_num) dfadj
	}
}

// storing the graph titles in local 
loc ti_doc "Doctors in the village"
loc ti_safe "Access to safe drinking water"
loc ti_dum "Health center"
loc ti_yrsedu "VH years of education"

// storing the x axis cutoff for each treatment period 
loc cutoff_1993 = 2
loc cutoff_1996 = 3 
loc cutoff_2000 = 4

// plotting individual graphs 
foreach y in 1993 1996 2000 {
	foreach v in doc safe dum yrsedu {
		
		#delimit; 
			coefplot 
			(e_c`y'_`v', 
			recast(connected) lc(navy*1.25) mc(navy*1.25)
			ciopts(recast(rcap) lc(navy*1.25) lw(vthin))), 
			keep(*.year#c.num_dev) vertical omitted
			yli(0)
			xli(`cutoff_`y'', lp(solid) lc(red))
			coeflabels(1990.year#c.num_dev = "1990"
					   1993.year#c.num_dev = "1993"
					   1996.year#c.num_dev = "1996"
					   2000.year#c.num_dev = "2000"
					   2003.year#c.num_dev = "2003"
					  )
			ti("`ti_`v''")
			xscale(range(1 5)) xlab(1 "1990" 2 "1993" 3 "1996" 4 "2000" 5 "2003")
			name("fig1_`y'_`v'", replace)
		;
		#delimit cr	
		
		graph save fig1_`y'_`v' "$graph/fig1_`y'_`v'.gph", replace
		graph export "$graph/fig1_`y'_`v'.png", replace
	}
}

// combining the plots 
graph combine 


/*
areg yrsedu i.year##c.num_dev if election_cohort == 2000, abs(v_id) clust(idkab_num)
xtreg yrsedu i.year##c.num_dev if election_cohort == 2000, fe i(v_id) vce(cluster idkab_num) dfadj
*/