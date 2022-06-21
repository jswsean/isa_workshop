
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Figure A.1: Distribution of Villages by Distance to Nearest Secondary School */


clear all
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set mem 1000m
use dlhs-figure-A.1.dta

/* Command for histogram */

histogram secondarydist if state == 10, width(1) xtitle("Distance to Secondary School (KM)") title("Bihar") name("hist1")
histogram secondarydist if state == 20, width(1) xtitle("Distance to Secondary School (KM)") title("Jharkhand") name("hist2")

graph combine hist1 hist2, rows(1) cols(2) title("Figure A.1: Distribution of Villages by Distance to Nearest Secondary School", size(medium))
graph export "/Users/Levere/Dropbox/LevereDLHS/Charts/dist_histogram_wtitle.pdf", as(pdf) replace

/* title("Figure 2: Distribution of Villages by Distance to Secondary School", size(medium)) */
