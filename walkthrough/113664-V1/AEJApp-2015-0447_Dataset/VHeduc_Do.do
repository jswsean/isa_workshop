
******************************************************
/*		Monica Martinez-Bravo				   		*/
/* 	THE LOCAL POLITICAL ECONOMY EFFECTS OF SCHOOL	*/ 
/*	 CONSTRUCTION IN INDONESIA						*/
/* 		July 4th, 2016				    			*/
******************************************************
 
clear
clear matrix
clear mata
set matsize 11000
set maxvar 32767 
set emptycells drop 


*cd "Your path"


************************************
* 	TABLE 1. SUMMARY STATISTICS 	**
************************************

use VHeduc_Data.dta, clear

# delimit ;
sum population num_HH sch_rate86_86 percrurHH daerah dist_kab_kotaoffice num_PSINPRES1980_yr86 
dum doc safe pos garb num_pri num_ju 
yrsedu yrsedu25 yrsedu50 yrsedu75 age_VH age25 age50 age75 gender_VH; 
 

************************************************************
*** TABLE 2. DETERMINANTS OF THE TIMING OF THE ELECTIONS *** 
************************************************************

use VHeduc_Data.dta, clear

** Compute Changes between 1986 and 1990 ** 
# delimit; 
foreach var in lpopulation percrurHH daerah share_land_agr num_doctors num_puskesmas safedrink1 criland_dum
 garbage_bin hardroad pedati num_pri num_ju dum_KUD dum_otrocop dum_groupshop churches mosque num_mktper num_bank{; 
 gen xx86= `var' if year==1986;
by v_id, sort: egen yy86=max(xx86);
gen xx90= `var' if year==1990;
by v_id, sort: egen yy90=max(xx90);
gen lyy86=ln(yy86+0.01);
gen lyy90=ln(yy90+0.01);
gen `var'_chg90= lyy90-lyy86;
drop xx86 xx90 yy86 yy90 lyy86 lyy90;
};
# delimit cr 


gen xx90= num_posyandu if year==1990
by v_id, sort: egen yy90=max(xx90)
gen xx93= num_posyandu if year==1993
by v_id, sort: egen yy93=max(xx93)
gen lyy90=ln(yy90+0.01)
gen lyy93=ln(yy93+0.01)
gen num_posyandu_chg90= lyy93-lyy90

drop xx90 xx93 yy93 yy90 lyy93 lyy90

collapse ele1v_post92 *_chg90 idkab_num, by(v_id)



capture erase "T2.xls"
capture erase "T2.txt"



# delimit ; 
foreach var in lpopulation percrurHH daerah share_land_agr num_doctors num_puskesmas num_posyandu safedrink1 criland_dum
 garbage_bin hardroad pedati num_pri num_ju dum_KUD dum_otrocop dum_groupshop churches mosque num_mktper num_bank{; 
	gen regr=`var'_chg90;
	capture	  xi: reg ele1v_post92 regr, cluster(idkab_num); 
	capture	  outreg2  using "T2.xls", bdec(3) ctitle(`var'_chg) keep(regr);
	capture	gen esample=e(sample);
		foreach xx in ele1v_post92 regr {;
			sum `xx' if esample==1;
			local mean = r(mean); 	
			local sd = r(sd); 
			gen `xx'_sd=(`xx'-`mean')/`sd';
        };
	capture	  xi: reg ele1v_post92 regr ,  beta ;
	capture test regr==0;
	capture local pval=r(p);
	capture	  outreg2 using "T2.xls", bdec(3)
		ctitle(`var'_chg) stats(beta) addstat(Pval, `pval')  keep(regr);

	capture	xi: reg ele1v_post92_sd regr_sd , cluster(idkab_num) ;
	capture test regr==0;
	capture local pval=r(p);
	capture	  outreg2  using "T2.xls", bdec(3)
		ctitle(`var'_chg) addstat(Pval, `pval') keep(regr_sd) ;	
	drop regr;
	drop *_sd;
	}; 
# delimit cr 
	


	
*******************************************
** 	TABLE 3. MAIN REDUCED FORM RESULTS	 **
*******************************************


use VHeduc_Data.dta, clear

capture erase "T3_RF.xls"
capture erase "T3_RF.txt"

capture drop esample 
capture drop xx
capture drop yy
# delimit; 
foreach var in dum doc safe pos garb{; 
		areg `var' i.post92  i.year if  `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		gen xx=year if `var'!=.; 
		bys v_id: egen yy= min(xx);
		sum `var' if esample==1 & year==yy;
		local mean86 = r(mean);
		drop xx yy;
		outreg2  
		using "T3_RF.xls", nocons bdec(3) addstat(DepVar Mean, `mean', DepVar Mean86, `mean86') 
		ctitle(RF, `var') keep (1.post92);
		drop esample;

		areg `var' i.post92##c.num_dev  i.year if  `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		gen xx=year if `var'!=.; 
		bys v_id: egen yy= min(xx);
		sum `var' if esample==1 & year==yy;
		local mean86 = r(mean);		
		drop xx yy;
		outreg2 
		using "T3_RF.xls", nocons bdec(3) addstat(DepVar Mean, `mean', DepVar Mean86, `mean86' )
		ctitle(RF, `var')
		keep (1.post92 1.post92#c.num_dev);
		drop esample;

		areg `var' i.post92##i.inp_pos  i.year if  `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		gen xx=year if `var'!=.; 
		bys v_id: egen yy= min(xx);
		sum `var' if esample==1 & year==yy;
		local mean86 = r(mean);		
		drop xx yy;
		outreg2 
		using "T3_RF.xls", nocons bdec(3) addstat(DepVar Mean, `mean', DepVar Mean86, `mean86' )
		ctitle(RF, `var')
		keep (1.post92 1.post92#1.inp_pos);
		drop esample;

		
		areg `var' i.post92##i.num_PSINPRES1980  i.year if  `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		gen xx=year if `var'!=.; 
		bys v_id: egen yy= min(xx);
		sum `var' if esample==1 & year==yy;
		local mean86 = r(mean);		
		drop xx yy;
		outreg2 
		using "T3_RF.xls", nocons bdec(3) addstat(DepVar Mean, `mean', DepVar Mean86, `mean86' )
		ctitle(RF, `var')
		keep (1.post92 1.post92#1.num_PSINPRES1980 1.post92#2.num_PSINPRES1980);
		drop esample;		
	};
# delimit cr 






***************************************************
*** TABLE 4. HETEROGENEOUS RESULTS				*** 
***************************************************

use VHeduc_Data.dta, clear

capture noisily erase "T4_RF_HETER.xls"
capture noisily erase "T4_RF_HETER.txt"

# delimit; 
foreach var in dum doc safe {; 
		areg `var' i.post92##c.num_dev##i.b`var' i.year if `var'!=., 
			abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T4_RF_HETER.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(RF, `var')
		keep (1.post92 1.post92#c.num_dev 1.post92#1.b`var' 1.post92#1.b`var'#c.num_dev);
		drop esample;
		
		areg `var' i.post92##i.inp_pos##i.b`var'  i.year if `var'!=., 
			abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T4_RF_HETER.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(RF, `var')
		keep (1.post92 1.post92#1.inp_pos 1.post92#1.b`var' 1.post92#1.inp_pos#1.b`var');
		drop esample;	
	};
# delimit cr 

	
**********************************************
** TABLE 5. ROBUSTNESS CHECK, REDUCED FORM  ** 
**********************************************

use VHeduc_Data.dta, clear

capture erase "T5_RF_ROB.xls"
capture erase "T5_RF_ROB.txt"

	
# delimit; 
foreach var in dum doc safe{;   
	
		areg `var' i.post92##c.num_dev i.year if `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T5_RF_ROB.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(Base, `var')
		keep (1.post92 1.post92#c.num_dev);
		drop esample;

		areg `var' i.post92##c.num_dev i.year lpopulation if `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T5_RF_ROB.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(Pop, `var')
		keep (1.post92 1.post92#c.num_dev);
		drop esample;		

		areg `var' i.post92##c.num_dev i.year i.year#c.`var'_pre if `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T5_RF_ROB.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(DVtr, `var')
		keep (1.post92 1.post92#c.num_dev);
		drop esample;			
	
		areg `var' i.post92##c.num_dev  i.year i.year##c.dum_otrocop_pre i.year##c.num_bank_pre i.year##c.pedati_pre
			 if `var'!=.,
			abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T5_RF_ROB.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(Pre, `var')
		keep (1.post92 1.post92#c.num_dev);
		drop esample;	

		areg `var' i.post92##c.num_dev i.year i.year#c.sch_rate86 i.year#i.Inptoil if `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T5_RF_ROB.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(Enrol, `var')
		keep (1.post92 1.post92#c.num_dev);
		drop esample;			

	
		xi: areg `var' post92 ye_3_1_num_dev-ye_3_4_num_dev i.year if `var'!=., abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		test ye_3_1_num_dev==ye_3_2_num_dev==ye_3_3_num_dev==0;
		local pval=r(p); 
		outreg2  using "T5_RF_ROB.xls", 
		nocons bdec(3) addstat(DepVar Mean, `mean', Pval, `pval') ctitle(PreTr, `var')
		keep(post92 ye_3_1_num_dev-ye_3_4_num_dev);
		drop esample;

		};
# delimit cr 





***************************************************
*** TABLE 6. FIRST STAGE  *** 
***************************************************

use VHeduc_Data.dta, clear

gen post92_young=post92*young
gen post92_numdev=post92*num_dev
gen post92_numdev_young=post92*num_dev*young


capture erase "T6_FS.xls"
capture erase "T6_FS.txt"


# delimit; 
foreach var in yrsedu {; 
		areg `var' i.post92  i.year, abs(v_id) cluster(idkab_num); 
		capture drop esample;
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2  
		using "T6_FS.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(RF, `var')
		keep (1.post92);
		drop esample;

		areg `var' i.post92##c.num_dev i.year, abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T6_FS.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(RF, `var')
		keep (1.post92 1.post92#c.num_dev);
		drop esample;

		areg `var' i.post92##i.inp_pos i.year, abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T6_FS.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(RF, `var')
		keep (1.post92 1.post92#1.inp_pos);
		drop esample;
		
		areg `var' i.post92##i.num_PSINPRES1980 i.year, abs(v_id) cluster(idkab_num); 
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 
		using "T6_FS.xls", nocons bdec(3) addstat(DepVar Mean, `mean') ctitle(RF, `var')
		keep (1.post92 1.post92#1.num_PSINPRES1980 1.post92#2.num_PSINPRES1980 );
		drop esample;

		xi: areg `var' post92 post92_young i.year, abs(v_id) cluster(idkab_num);
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 using "T6_FS.xls", 
			nocons bdec(3) ctitle(`var', youngINPR) addstat(DepVar Mean, `mean')
			keep (post92 post92_young); 
		drop esample;	
		
		xi: areg `var' post92 post92_numdev post92_young post92_numdev_young i.year, 
			abs(v_id) cluster(idkab_num);
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);
		outreg2 post92 post92_numdev post92_young post92_numdev_young 
			using "T6_FS.xls", nocons bdec(3) ctitle(`var', youngINPR) addstat(DepVar Mean, `mean')
			keep (post92 post92_numdev post92_young post92_numdev_young); 
		drop esample;	
	};
# delimit cr 



	

*********************************************
*** TABLE 7. DEVELOPMENT PROJECTS	 	   ** 
*********************************************

* regressions at the village level 
use projectData.dta, clear
 
duplicates drop v_id, force

capture erase "T7_proj.xls"
capture erase "T7_proj.txt"

#delimit; 
foreach var in numproj num_Vmanag  numproj_vil numproj_Inpres numproj_gov {;
	xi: reg `var' yrsedu i.idprop lpop* percrurHH percrurHH2-percrurHH4, cluster(idkab_num);
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);	 
	outreg2 yrsedu using "T7_proj.xls", nocons bdec(4) 
	ctitle(`var', OLSrur) addstat(DepVar Mean, `mean')
	keep(yrsedu);
	drop esample;
	};
#delimit cr

#delimit; 
foreach var in  numproj num_Vmanag  numproj_vil numproj_Inpres numproj_gov {;
	xi: ivreg2 `var' i.idprop  lpop* percrurHH percrurHH2-percrurHH4 (yrsedu = avg_educinkec), cluster(idkab_num);
	outreg2  using "T7_proj.xls", nocons bdec(4) ctitle(`var', IV)
	keep(yrsedu);
	};
#delimit cr


* regressions at the project level * 
use projectData.dta, clear 

#delimit; 
foreach var in projdur{;
	xi: reg `var' yrsedu i.idprop lpop* percrurHH percrurHH2-percrurHH4, cluster(idkab_num);
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);	 
	outreg2  using "T7_proj.xls", nocons bdec(4) ctitle(`var', OLSperccontr) addstat(DepVar Mean, `mean')
		keep(yrsedu);
	drop esample;
	xi: reg `var' yrsedu i.idprop i.typeproj*i.projperct_round  lpop* percrurHH percrurHH2-percrurHH4 , cluster(idkab_num);
		gen esample=e(sample);
		sum `var' if esample==1;
		local mean = r(mean);	 
	outreg2 using "T7_proj.xls", nocons bdec(4) ctitle(`var', OLStypeperc) addstat(DepVar Mean, `mean')
		keep(yrsedu);
	drop esample;
	};
#delimit cr


#delimit; 
foreach var in projdur{;
	xi: ivreg2 `var' i.idprop  lpop* percrurHH percrurHH2-percrurHH4  (yrsedu = avg_educinkec), cluster(idkab_num);
	outreg2  using "T7_proj.xls", nocons bdec(4) 
		ctitle(`var', IVperccontr) addstat(Cragg-Donald F-Stat, e(widstat)) keep(yrsedu);
	xi: ivreg2 `var' i.idprop i.typeproj*i.projperct_round  lpop*  percrurHH percrurHH2-percrurHH4 (yrsedu = avg_educinkec) , cluster(idkab_num);
	outreg2 using "T7_proj.xls", nocons bdec(4) ctitle(`var', IVtypeperc) 
		addstat(Cragg-Donald F-Stat, e(widstat)) keep(yrsedu);
	};
#delimit cr


	
**************************
** FIGURES 				**
**************************

* Figure 1. Timeline of Events 

* Figure 2. Reduced Form by Election Years  

use VHeduc_Data.dta, clear

** Generating Variables ** 
foreach var in dum doc safe pos garb yrsedu{
	gen `var'_el92_1993i=`var' if ele1v_post92==1992 | ele1v_post92==1993 
	gen `var'_el92_1996i=`var' if ele1v_post92==1994 | ele1v_post92==1995  | ele1v_post92==1996
	gen `var'_el92_2000i=`var' if ele1v_post92==1997 | ele1v_post92==1998 | ele1v_post92==1999
	} 
	
* yrsedu 
capture drop coef_* 
foreach x in 1993 1996 2000{
	foreach var in yrsedu{
	areg `var'_el92_`x'i i.year##c.num_dev, abs(v_id) cluster(idkab_num)
	g coef_`var'_el92_`x'i=.	
	
		foreach i in 1990 1993 1996 2000 2003  {
		replace coef_`var'_el92_`x'i=_b[`i'.year#c.num_dev] if year==`i'
		}
	replace coef_`var'_el92_`x'i=0 if year==1986
	preserve
	duplicates drop year, force
	drop if year==1986
	graph twoway  (connected coef_`var'_el92_`x'i year, sort lwidth(thick) lp(solid) lc(solid) mc(solid) ///
	ytitle("Coef of Year X Number of INPRES schools", size(medlarge)) xtitle(Year, size(medlarge)) ///
	yscale(range(-.3 0.5)) xscale(range(1990 2003.5)) ylabel(-.3 (0.1) 0.5, labsize(medlarge)) xlabel(1990 1993 1996 2000 2003, labsize(large)) xline(`x') title(Years of Education of the VH)) 
	restore 
	graph export `var'_el92_`x'i.pdf, replace
	}
}

** dum 
capture drop coef_* 
foreach x in 1993 1996 2000{
	foreach var in dum{
	areg `var'_el92_`x'i i.year##c.num_dev, abs(v_id) cluster(idkab_num)
	g coef_`var'_el92_`x'i=.	
		foreach i in 1990 1993 1996 2000 2003  {
		replace coef_`var'_el92_`x'i=_b[`i'.year#c.num_dev] if year==`i'
		}
	replace coef_`var'_el92_`x'i=0 if year==1986
	preserve
	duplicates drop year, force
	drop if year==1986
	graph twoway  (connected coef_`var'_el92_`x'i year, sort lwidth(thick) lp(solid) lc(solid) mc(solid) ///
	ytitle("Coef of Year X Number of INPRES schools", size(medlarge)) xtitle(Year, size(medlarge)) ///
	yscale(range(0 0.025)) xscale(range(1990 2003.5)) ylabel(0(0.005)0.025, labsize(medlarge)) xlabel(1990 1993 1996 2000 2003, labsize(large)) xline(`x') title("Health Center")) 
	restore 
	graph export `var'_el92_`x'i.pdf, replace
	}
}

** doc  
capture drop coef_* 
foreach x in 1993 1996 2000{
	foreach var in doc{
	areg `var'_el92_`x'i i.year##c.num_dev, abs(v_id) cluster(idkab_num)
	g coef_`var'_el92_`x'i=.	
		foreach i in 1990 1993 1996 2000 2003  {
		replace coef_`var'_el92_`x'i=_b[`i'.year#c.num_dev] if year==`i'
		}
	replace coef_`var'_el92_`x'i=0 if year==1986
	preserve
	duplicates drop year, force
	drop if year==1986
	graph twoway  (connected coef_`var'_el92_`x'i year, sort lwidth(thick) lp(solid) lc(solid) mc(solid) ///
	ytitle("Coef of Year X Number of INPRES schools", size(medlarge)) xtitle(Year, size(medlarge)) ///
	yscale(range(-0.005 0.025)) xscale(range(1990 2003.5)) ylabel(-0.005 (0.005)0.025, labsize(medlarge)) xlabel(1990 1993 1996 2000 2003, labsize(large)) xline(`x') title(Doctors in the Village)) 
	restore 
	graph export `var'_el92_`x'i.pdf, replace
	}
}


** garb 
capture drop coef_* 
foreach x in 1993 1996 2000{
	foreach var in garb{
	areg `var'_el92_`x'i i.year##c.num_dev, abs(v_id) cluster(idkab_num)
	g coef_`var'_el92_`x'i=.	
	
		foreach i in 1990 1993 1996 2000 2003  {
		replace coef_`var'_el92_`x'i=_b[`i'.year#c.num_dev] if year==`i'
		}
	replace coef_`var'_el92_`x'i=0 if year==1986
	preserve
	duplicates drop year, force
	drop if year==1986
	graph twoway  (connected coef_`var'_el92_`x'i year, sort lwidth(thick) lp(solid) lc(solid) mc(solid) ///
	ytitle("Coef of Year X Number of INPRES schools", size(medlarge)) xtitle(Year, size(medlarge)) ///	
	yscale(range(-0.025 0.05)) xscale(range(1990 2003.5)) ylabel(-0.025 (0.02)0.05, labsize(medlarge)) xlabel(1990 1993 1996 2000 2003, labsize(large)) xline(`x') title(Garbage Disposal)) 
	restore 
	graph export `var'_el92_`x'i.pdf, replace
	}
}


* safe 
capture drop coef_* 

foreach x in 1993 1996 2000{
	foreach var in safe {
	areg `var'_el92_`x'i i.year##c.num_dev if `var'!=., abs(v_id) cluster(idkab_num)
	g coef_`var'_el92_`x'i=.	
		foreach i in 1990 1993 1996 {
		replace coef_`var'_el92_`x'i=_b[`i'.year#c.num_dev] if year==`i'
		}
	replace coef_`var'_el92_`x'i=0 if year==1986
	
	preserve
	drop if year==1986	
	duplicates drop year, force
	graph twoway  (connected coef_`var'_el92_`x'i year, sort lwidth(thick) lp(solid) lc(solid) mc(solid) ///
	ytitle("Coef of Year X Number of INPRES schools", size(medlarge)) xtitle(Year, size(medlarge)) ///
	yscale(range(0 0.04)) xscale(range(1990 2003.5)) ylabel(0 (0.01)0.04, labsize(medlarge)) xlabel(1990 1993 1996 2000 2003, labsize(large)) xline(`x') title(Access to Safe Drinking Water)) 
	restore 
	graph export `var'_el92_`x'i.pdf, replace
	}
}


* pos
capture drop coef_* 

foreach x in 1993 1996 2000{
	foreach var in pos {
	areg `var'_el92_`x'i i.year##c.num_dev if `var'!=., abs(v_id) cluster(idkab_num)
	g coef_`var'_el92_`x'i=.	
		foreach i in 1993 2000 2003 {
		replace coef_`var'_el92_`x'i=_b[`i'.year#c.num_dev] if year==`i'
		}
	replace coef_`var'_el92_`x'i=0 if year==1990
	
	preserve
	drop if year==1986
	duplicates drop year, force
	graph twoway  (connected coef_`var'_el92_`x'i year, sort lwidth(thick) lp(solid) lc(solid) mc(solid) ///
	ytitle("Coef of Year X Number of INPRES schools", size(medlarge)) xtitle(Year, size(medlarge)) ///
	yscale(range(0 0.3)) xscale(range(1990 2003.5)) ylabel(0 (0.05)0.3, labsize(medlarge)) xlabel(1990 1993 1996 2000 2003, labsize(large)) xline(`x') title(Health Posts)) 
	restore 
	graph export `var'_el92_`x'i.pdf, replace
	}
}

	
	
	
	
