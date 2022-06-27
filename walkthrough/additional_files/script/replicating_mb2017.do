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
	gl walkthrough "C:/Users/Sean Hambali/Documents/GitHub/wb_isa_workshop/walkthrough/slides/Walkthrough Slides"
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

// storing the titles for election periods 
loc ti_1993 "1992-1993"
loc ti_1996 "1994-1996"
loc ti_2000 "1997-1999"

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
			ti("`ti_`v''" "`ti_`y'' election cohorts", s(large))
			xscale(range(1 5)) 
			xlab(1 "1990" 2 "1993" 3 "1996" 4 "2000" 5 "2003",
			labs(large))
			ylab(, labs(large))
			name("fig1_`y'_`v'", replace)
		;
		#delimit cr	
		
		graph save fig1_`y'_`v' "$graph/fig1_`y'_`v'.gph", replace
		graph export "$graph/fig1_`y'_`v'.png", replace
	}
}

// combining the plots 
foreach v in doc safe dum yrsedu {
	
	graph combine "$graph/fig1_1993_`v'.gph" ///
				  "$graph/fig1_1996_`v'.gph" ///
				  "$graph/fig1_2000_`v'.gph", ///
				  ycommon iscale(*.8) r(1) ///
				  xsize(8) ysize(3) ///
				  name("fig1_`v'_combined", replace)
	graph save fig1_`v'_combined "$walkthrough/fig1_`v'_combined.gph", replace
	graph export "$walkthrough/fig1_`v'_combined.png", replace	
}

graph combine "$walkthrough/fig1_yrsedu_combined.gph" ///
			  "$walkthrough/fig1_dum_combined.gph" ///
			  "$walkthrough/fig1_doc_combined.gph" ///
			  "$walkthrough/fig1_safe_combined.gph", ///
			  ysize(7) xsize(6) ///
			  iscale(*.7) c(1) ///
			  name("fig1_all", replace)
graph save fig1_all "$walkthrough/fig1_all.gph", replace 
graph export "$walkthrough/fig1_all.png", replace


/*
areg yrsedu i.year##c.num_dev if election_cohort == 2000, abs(v_id) clust(idkab_num)
xtreg yrsedu i.year##c.num_dev if election_cohort == 2000, fe i(v_id) vce(cluster idkab_num) dfadj
*/


/*
	========================================================
	Table 2: Looking at the determinants of timing election
	========================================================
*/

/* first, we load the VHeduc data*/
	use "$raw_data/VHeduc_Data", clear

/* our goal here is to create a cross-sectional village-level dataset */
	
	/* we compute the change in several variables from 1986 - 1990 */
	* but first, we create those variables for each year of 1986 and 1990
	foreach v in lpopulation percrurHH daerah share_land_agr num_doctors ///
	num_puskesmas safedrink1 criland_dum garbage_bin hardroad pedati ///
	num_pri num_ju dum_KUD dum_otrocop dum_groupshop churches mosque ///
	num_mktper num_bank {
		g `v'1986 = ln(`v'+0.01) if year == 1986
		g `v'1990 = ln(`v'+0.01) if year == 1990
	}
	
	* we give special treatment for posyandu (following MB's original script)
	g posyandu1986 = ln(num_posyandu+0.01) if year==1990
	g posyandu1990= ln(num_posyandu+0.01) if year==1993

	* now, we collapse the village-year data into cross-sectional village data 
	* don't forget to install gtools!
	*ssc install gtools, replace
	gcollapse (firstnm) ele1v_post92 *1986 *1990 idkab_num, by(v_id)

	* for these collapsed variables, we generate the pct change 
	foreach v in lpopulation percrurHH daerah share_land_agr num_doctors ///
	num_puskesmas safedrink1 criland_dum garbage_bin hardroad pedati ///
	num_pri num_ju dum_KUD dum_otrocop dum_groupshop churches mosque ///
	num_mktper num_bank posyandu {
		g `v'_chg90 = `v'1990 - `v'1986
	}	
	
// we store the variable labels for each of the predictors 
	loc ti_lpopulation "Log population"
	loc ti_percrurHH "Percentage of rural HH"
	loc ti_daerah "Urban village"
	loc ti_share_land_agr "Share of land in agriculture"
	loc ti_num_doctors "Number of doctors"
	loc ti_num_puskesmas "Number of health centers"
	loc ti_posyandu "Number of health posts"
	loc ti_safedrink1 "Safe drinking water"
	loc ti_criland_dum "Critical land"
	loc ti_garbage_bin "Bin garbage disposal"
	loc ti_hardroad "Ashpalt/hard road"
	loc ti_pedati "Horse-drawn cart"
	loc ti_num_pri "Number of primary schools"
	loc ti_num_ju "Number of high schools"
	loc ti_dum_KUD "Village cooperative"
	loc ti_dum_otrocop "Other type of village cooperative"
	loc ti_dum_groupshop "Village group shop"
	loc ti_churches "Number of churches"
	loc ti_mosque "Number of mosques"
	loc ti_num_mktper "Number of markets"
	loc ti_num_bank "Number of banks"
	
	
/* now , we run the cross-sectional regressions. */
	
	foreach v in lpopulation percrurHH daerah share_land_agr num_doctors ///
	num_puskesmas safedrink1 criland_dum garbage_bin hardroad pedati ///
	num_pri num_ju dum_KUD dum_otrocop dum_groupshop churches mosque ///
	num_mktper num_bank posyandu {
		
		* using the same indep var for regressions 
		cap drop regressor esample *_sd
		g regressor = `v'_chg90
		
		* we'll run two models; 
		* model#1 : this is the level regs
		tempfile lv_`v'
		qui parmby "reg ele1v_post92 regressor, clust(idkab_num)", ///
		idstr("lv_`ti_`v''") saving(`lv_`v'', replace) level(90)
		
		* model#2 : this is the stdzd regs
		* running the usual regs to obtain e(sample)
		qui reg ele1v_post92 regressor, clust(idkab_num)
		g esample = 1 if e(sample) == 1
		foreach var in ele1v_post92 regressor {
			qui su `var' if esample == 1, d
			loc mean = r(mean)
			loc sd = r(sd)
			g `var'_sd = (`var' - `mean')/`sd'
		}
		tempfile sd_`v'
		qui parmby "reg ele1v_post92_sd regressor_sd, clust(idkab_num)", ///
		idstr("sd_`ti_`v''") saving(`sd_`v'', replace) level(90)
	}
	
/* we append all the parmby data */	
	
	* but first, clear all the existing data 
	drop _all
	
	* appending all data 
	foreach v in lpopulation percrurHH daerah share_land_agr num_doctors ///
	num_puskesmas safedrink1 criland_dum garbage_bin hardroad pedati ///
	num_pri num_ju dum_KUD dum_otrocop dum_groupshop churches mosque ///
	num_mktper num_bank posyandu {
		
		append using `lv_`v''
		append using `sd_`v''
		
	}	
	
	* in the new dataset, we remove the _cons parameter 
	drop if parm == "_cons"
	g type = substr(idstr, 1,2)
	replace idstr = substr(idstr, 4, strlen(idstr))
	
	* keep only select variables 
	keep idstr type estimate stderr t min90 max90
	encode idstr, gen(idstr_code)
	replace idstr_code = idstr_code + .1 if type == "lv"
	replace idstr_code = idstr_code - .1 if type == "sd"
	
/* visualizing the data */	
	#delimit; 
		twoway 
		(scatter idstr_code estimate if type == "sd")
		(rcap min90 max90 idstr_code if type == "sd", horizontal lc(red)),
		ylab(1(1)21, valuelabel)
		xlab(-.1(.02).1)
		leg(off)
		xli(0)
		yti("Characteristics") 
		ti("What determines the election timing?")
		name("fig2", replace)
	;
	#delimit cr

graph save fig2 "$walkthrough/fig2.gph", replace 
graph export "$walkthrough/fig2.png", replace	


/*
	========================================================
	Table 3: Looking at the determinants of timing election
	========================================================
*/


/* first, we load the VHeduc data*/
	use "$raw_data/VHeduc_Data", clear

/* we set the data as panel data */
	xtset v_id year
	
/* labelling the depvars */
	la var dum "Primary health center in the village"
	la var doc "Doctors in the village"
	la var safe "Access to safe drinking water"

/* storing the relevant depvars in a global */
	gl depvars dum doc safe 
	
/* running the regressions */	
	eststo clear
	
	foreach v in $depvars {
		
		* model 1 
		qui eststo m1_`v': xtreg `v' i.post92 i.year if !mi(`v'), ///
		fe i(v_id) vce(cluster idkab_num) dfadj
		
		* adding baseline mean
			qui su `v' if e(sample) == 1 
			loc mean = r(mean)
			qui estadd scalar depvar_mean `mean'
			
			
		* model 2
		qui eststo m2_`v': xtreg `v' i.post92##c.num_dev i.year if !mi(`v'), ///
		fe i(v_id) vce(cluster idkab_num) dfadj
		
		* adding baseline mean
			qui su `v' if e(sample) == 1 
			loc mean = r(mean)
			qui estadd scalar depvar_mean `mean'
			
		
		* model 3
		qui eststo m3_`v': xtreg `v' i.post92##i.inp_pos i.year if !mi(`v'), ///
		fe i(v_id) vce(cluster idkab_num) dfadj
		
		* adding baseline mean
			qui su `v' if e(sample) == 1 
			loc mean = r(mean)
			qui estadd scalar depvar_mean `mean'	
		
		* model 4 
		qui eststo m4_`v': xtreg `v' i.post92##i.num_PSINPRES1980 i.year if !mi(`v'), ///
		fe i(v_id) vce(cluster idkab_num) dfadj
		
		* adding baseline mean
			qui su `v' if e(sample) == 1 
			loc mean = r(mean)
			qui estadd scalar depvar_mean `mean'

		*tabulating the results (I'm not exporting it to .csv or .tex files. Just in the Stata console)
		/*
		#delimit;
		esttab m* using "$walkthrough/table3_`v'.tex", 
		n se ar2 
		keep(1.post92 1.post92#c.num_dev 1.post92#1.inp_pos 
		1.post92#1.num_PSINPRES1980 1.post92#2.num_PSINPRES1980)
		coeflabels(1.post92 "Post first election after 1992"
				   1.post92#c.num_dev "Post X num. INPRES schools"
				   1.post92#1.inp_pos "Post X num. INPRES > 0"
				   1.post92#1.num_PSINPRES1980 "Post x INPRES schools = 1"
				   1.post92#2.num_PSINPRES1980 "Post x INPRES schools = 2"
				  )
		b(%4.3f) se(%4.3f) label
		s(N r2 depvar_mean, 
		fmt(%9.0f %9.3f %3.2f)
		label("Observations" "R-Squared" "Dependent variable mean"))
		;
		#delimit cr	
		*/
		
		#delimit; 
		estout m*, 
		cells(b(star fmt(3)) se(par fmt(3)))
		stats(r2 N depvar_mean, fmt(%9.3f %9.0f %9.3f) 
		labels("R-squared" "Observations" "Mean"))
		keep(1.post92 1.post92#c.num_dev 1.post92#1.inp_pos 
		1.post92#1.num_PSINPRES1980 1.post92#2.num_PSINPRES1980)
		varlabels(1.post92 "Post first election after 1992"
				  1.post92#c.num_dev "Post X num. INPRES schools"
				  1.post92#1.inp_pos "Post X num. INPRES > 0"
				  1.post92#1.num_PSINPRES1980 "Post x INPRES schools = 1"
				  1.post92#2.num_PSINPRES1980 "Post x INPRES schools = 2")
		;
		#delimit cr
		
		eststo clear
	}
	
	
	
/*
	====================================================
	TABLE 4. Heterogenous effects of school construction
	====================================================
*/	
	
	/* first, we load the raw data */
	use "$raw_data/VHeduc_Data", clear
	
	/* setting the panel data */
	xtset v_id year
	
	/* storing the depvars in the global */
	gl depvars dum doc safe 
	
	/* running the regressions */
	eststo clear
	foreach v in $depvars {
		
		* generating dummy for whether bad baseline var/not 
		cap drop badvar
		g badvar = b`v'
		
		* running the first model : c.num_dev as the interaction variable 
		qui eststo m1_`v' : xtreg `v' i.post92##c.num_dev##i.badvar ///
		i.year if !mi(`v'), fe i(v_id) vce(cluster idkab_num) dfadj
		
		* adding baseline mean
			qui su `v' if e(sample) == 1 
			loc mean = r(mean)
			qui estadd scalar depvar_mean `mean'
		
		
		* running the second model : positive inpres dummies as the interaction variable 
		qui eststo m2_`v' : xtreg `v' i.post92##i.inp_pos##i.badvar ///
		i.year if !mi(`v'), fe i(v_id) vce(cluster idkab_num) dfadj
		
		* adding baseline mean
			qui su `v' if e(sample) == 1 
			loc mean = r(mean)
			qui estadd scalar depvar_mean `mean'
	}
	
	#delimit; 
	estout m*, 
	cells(b(star fmt(3)) se(par fmt(3)))
	modelwidth(7)
	stats(r2 N depvar_mean, fmt(%9.3f %9.0f %9.2f) 
	labels("R-squared" "Observations" "Mean"))
	keep(1.post92 1.post92#c.num_dev 1.post92#1.inp_pos 1.post92#1.badvar 
	1.post92#1.badvar#c.num_dev 1.post92#1.inp_pos#1.badvar)
	order(1.post92 1.post92#c.num_dev 1.post92#1.inp_pos 1.post92#1.badvar 
	1.post92#1.badvar#c.num_dev 1.post92#1.inp_pos#1.badvar)
	varlabels(1.post92 "Post first election after 1992"
			  1.post92#c.num_dev "Post X INPRES N"
			  1.post92#1.inp_pos "Post X INPRES > 0"
			  1.post92#1.badvar "Post X bad service"
			  1.post92#1.badvar#c.num_dev "Post x bad service X INPRES intensity"
			  1.post92#1.inp_pos#1.badvar "Post x bad service X INPRES > 0"
			  )
	;
	#delimit cr
	
	
	
	
/*
	=============================================================
	TABLE 5. Robustness checks of the school construction effects
	=============================================================
*/	
	
	/* first, we load the raw data */
	use "$raw_data/VHeduc_Data", clear
	
	/* setting the panel data */
	xtset v_id year
	
	/* storing the depvars in the global */
	gl depvars dum doc safe 
	
	/* looping across the dependent variable and specification */
	foreach v in $depvars {
		
		* spec #1: controlling for log population
		qui eststo m1_`v': xtreg `v' i.post92##c.num_dev i.year lpopulation if !mi(`v'), fe i(v_id) vce(cluster idkab_num) dfadj
		
		* spec #2: controlling for pre-treatment dep var x year FE
		qui eststo m2_`v': xtreg `v' i.post92##c.num_dev i.year i.year#c.`v'_pre if !mi(`v'), fe i(v_id) vce(cluster idkab_num) dfadj
		
		* spec #3: controlling for pre-treatment covariates 
		qui eststo m3_`v': xtreg `v' i.post92##c.num_dev i.year i.year##c.dum_otrocop_pre i.year##c.num_bank_pre i.year##c.pedati_pre if !mi(`v'), fe i(v_id) vce(cluster idkab_num) dfadj
		
		* spec #4: controlling for initial school enrollment and enrollment / water sanitation X year FE
		qui eststo m4_`v': xtreg `v' i.post92##c.num_dev i.year i.year#c.sch_rate86 i.year#i.Inptoil if !mi(`v'), fe i(v_id) vce(cluster idkab_num) dfadj
		
		* spec #5: 
		qui eststo m5_`v': xtreg `v' post92 ye_3_1_num_dev-ye_3_4_num_dev i.year if !mi(`v'), fe i(v_id) vce(cluster idkab_num) dfadj
		
		* estout 
		estout m*, cells(b(star fmt(3)) se(par fmt(3))) modelwidth(7) stats(r2 N, fmt(%9.3f %9.0f) labels("R-squared" "Observations")) keep(1.post92 1.post92#c.num_dev ye_3_1_num_dev ye_3_2_num_dev ye_3_3_num_dev) order(1.post92 1.post92#c.num_dev ye_3_3_num_dev ye_3_2_num_dev ye_3_1_num_dev) varlabels(1.post92 "Post" 1.post92#c.num_dev "Post X INPRES N" ye_3_1_num_dev "3 year before X INPRES N" ye_3_2_num_dev "2 year before X INPRES N" ye_3_3_num_dev "1 year before X INPRES N")
		
		eststo clear 
	}
	
	
	
	