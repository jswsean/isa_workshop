
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Create the dataset containing only Bihar and Jharkhand with the relevant variables */

clear
cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"
set more off

use dlhs_long_wdist.dta

* Will only care about Bihar (code 10), and Jharkhand (code 20)*

keep if state==10|state==20

* Create key indicators *
gen inschool = 1 if school==1
replace inschool = 0 if school ~= 1
label var inschool "Indicator variable for being in school"

gen currgrade = grade + 1 if inschool == 1
label var currgrade "Current grade"

gen enrollment_secschool = 1 if currgrade == 9 | (grade >= 9 & grade ~= .)
replace enrollment_secschool = 0 if enrollment_secschool == .
label var enrollment_secschool "Indicator variable for enrolled in or completed grade 9 (secondary school)"

gen enrollment_middleschool = 1 if currgrade == 8 |(grade >= 8 & grade ~= .) 
replace enrollment_middleschool = 0 if enrollment_middleschool == .
label var enrollment_middleschool "Indicator variable for enrolled in or completed grade 8 (middle school)"

* Create various dummies *

* Female dummy *
gen female = 1 if sex==2
replace female = 0 if sex==1

label var female "Indicator for female dummy"

* Bihar/Jharkhand dummy *
gen bihar = 1 if state==10
replace bihar = 0 if state == 20

label var bihar "Indicator for treatment state bihar, control state is Jharkhand"

* Relationship Indicator *
gen child_sample = 1 if relationship == 3|relationship == 5|relationship == 8|relationship == 10
replace child_sample = 0 if relationship == .
label var child_sample "Indicator for son/daughter/brother/sister/grandson/ grand-daughter"

* Scheduled caste/scheduled tribe *
gen sc = 1 if hv116b == 1
replace sc = 0 if sc == .
label var sc "Dummy for Scheduled caste"

gen st = 1 if hv116b == 2
replace st = 0 if st == .
label var st "Dummy for Scheduled tribe"

gen obc = 1 if hv116b == 3
replace obc = 0 if obc == .
label var obc "Dummy for Other backward caste"

gen highcaste = 1 if hv116b == 4
replace highcaste = 0 if highcaste==.
label var highcaste "Dummy for High caste"

gen scst = 1 if hv116b == 1 | hv116b==2
replace scst = 0 if scst == .

* Dummy for Religion, hindu , muslim and others *
gen hindu = 1 if hv115 == 1
replace hindu = 0 if hindu == .
label var hindu "Dummy for Hindu religion"

gen muslim = 1 if hv115 == 2
replace muslim = 0 if muslim == .
label var muslim "Dummy for Muslim religion"

gen other = 1 if hv115 > 2
replace other = 0 if other == .
label var other "Dummy for non-Hindu/non-Muslim"


// Creating Asset Variables //

* Electricity in the house dummy *
gen electricity = 1 if hv129a == 1
replace electricity = 0 if hv129a == 2
label var electricity "Dummy for electricity"

* Mattress *
gen mattress = 1 if hv129b == 1
replace mattress = 0 if hv129b == 2
label var mattress "Dummy for mattress"

gen cooker = 1 if hv129c == 1
replace cooker = 0 if hv129c == 2
label var cooker "Dummy for pressure cooker"

gen chair = 1 if hv129d ==1 
replace chair = 0 if hv129d == 2
label var chair "Dummy for chair"

gen sofa = 1 if hv129e == 1
replace sofa = 0 if hv129e == 2
label var sofa "Dummy for sofa"

gen bed = 1 if hv129f == 1
replace bed = 0 if hv129f == 2
label var bed "Dummy for bed"

gen table = 1 if hv129g == 1
replace table = 0 if hv129g == 2
label var table "Dummy for table"

gen fan = 1 if hv129h == 1
replace fan = 0 if hv129h ==2
label var fan "Dummy for fan"

gen sewing = 1 if hv129l == 1
replace sewing = 0 if hv129l ==2
label var sewing "Dummy for sewing machine"

gen phone = 1 if hv129m == 1|hv129n ==1
replace phone = 0 if phone == .
label var phone "Dummy for phone (mobile/other)"

gen computer = 1 if hv129o == 1
replace computer = 0 if hv129o == 2
label var computer "Dummy for computer"

gen fridge = 1 if hv129p == 1
replace fridge = 0 if hv129p == 2
label var fridge "Dummy for fridge"

gen washing_machine = 1 if hv129q == 1
replace washing_machine = 0 if hv129q == 2
label var washing_machine "Dummy for washing machine"

gen watch = 1 if hv129r == 1
replace watch = 0 if hv129r == 2
label var watch "Dummy for watch/clock"

gen motor_cycle = 1 if hv129t == 1
replace motor_cycle = 0 if hv129t == 2
label var motor_cycle "Dummy for motor cycle"

gen animal_cart = 1 if hv129u == 1
replace animal_cart = 0 if hv129u ==2
label var animal_cart "Dummy for animal cart"

gen car = 1 if hv129v == 1
replace car = 0 if hv129v == 2
label var car "Dummy for car"

gen tractor = 1 if hv129w == 1
replace tractor = 0 if hv129w == 2
label var tractor "Dummy for tractor"

gen water_pump = 1 if hv129x == 1
replace water_pump = 0 if hv129x == 2
label var water_pump "Dummy for water pump"

gen thresher = 1 if hv129y == 1
replace thresher = 0 if hv129y == 2
label var thresher "Dummy for thresher"

* Bike ownership *
gen bike = 1 if hv129s == 1
replace bike = 0 if bike == .
label var bike "Dummy for bike ownership in a hh"

* Ownership of radio/tv - idea= access to govt schemes *
gen media = 1 if hv129i==1|hv129j==1|hv129k==1
replace media = 0 if media == .
label var media "Owns tv/radio in a hh"


* Indicator for poor farmers having less than 5 acres of land *
gen land = hv130==2|hv131<5
label var land "If household has less than 5 acres of land"

* Owns BPL card *
gen bpl = 1 if hv134 == 1
replace bpl = 0 if hv134 == 2
label var bpl "Own Below Poverty Line card"


// Creating Distance to School Variables //

* Create indicator variable- if secondary school is present in the village *
gen secschool = v115ca1
replace secschool = 1 if v115ca1 == 1
replace secschool = 0 if v115ca1 == 2
label var secschool "Dummy = 1 if secondary school in village"

* Create the distance variable to the nearest secondary school *
gen secondarydist=v115c2
replace secondarydist=0 if v115ca1==1
replace secondarydist=0 if v115cb1==1

* Long Distance to secondary school  *
gen longdist = 1 if secondarydist > 3
replace longdist = 0 if secondarydist <= 3

* Square of distance to secondary school *
gen secondarydistsq  = secondarydist*secondarydist
label var secondarydistsq "Square of distance to secondary school"

* Distance to the nearest high secondary school *
gen highsecondarydist=v115d2
replace highsecondarydist=0 if v115da1==1
replace highsecondarydist=0 if v115db1==1

* Drop some weird observations - missing distances etc *
replace secondarydist = round(secondarydist, 1)
replace highsecondarydist = round(highsecondarydist, 1)
drop if secondarydist == 99
drop if highsecondarydist == 99

* Generating distance to secondary school in logs and interacting *
gen lsecondarydist = log(secondarydist)

* Access to middle school (govt)- omitted variable, it is possible that a kid wont go to secondary school and up if there is no middle school in the village *
gen middle = v115ba1
replace middle = 1 if v115ba1==1
replace middle = 0 if v115ba1==2

label var middle "Dummy = 1 if middle school in the village"

* Create the distance variable to the nearest middle school *
gen middledist=v115b2
replace middledist=0 if v115ba1==1
replace middledist=0 if v115bb1==1

* Create indicator variable- if primary school is present in the village *
gen primary = v115aa1
replace primary = 1 if v115aa1 == 1
replace primary = 0 if v115aa1 == 2
label var primary "Dummy = 1 if primary school in village"

* Create the distance variable to the nearest primary school *
gen primarydist=v115a2
replace primarydist=0 if v115aa1==1
replace primarydist=0 if v115ab1==1


* Access to college- controlling as this could change incentives in a way that might bias the estimates upwards *
gen pubcollege = v115ea1
replace pubcollege = 1 if v115ea1==1
replace pubcollege = 0 if v115ea1==2

gen pvtcollege = v115eb1
replace pvtcollege = 1 if v115eb1==1
replace pvtcollege = 0 if v115eb1==2

gen college = 1 if pubcollege==1|pvtcollege==1
replace college = 0 if pubcollege==0|pvtcollege==0
label var college "College (pub/pvt) in the village"

* Create variables - facilities available in the village *
gen postoff = v122a
label var postoff "Post/telegraph office in the village"
replace postoff = 1 if v122a==1
replace postoff = 0 if v122a==2

gen bank = v122d
label var bank "Bank in the village"
replace bank = 1 if v122d==1
replace bank = 0 if v122d==2

* Create distance to local facilities by village *
gen towndist = v110
label var towndist "Distance to nearest town"

gen hqdist = v111
label var hqdist "Distance to district hq"

gen railwaydist = v112
label var railwaydist "Distance to nearest railway station"

gen busdist = v113
label var busdist "Distance to nearest bus station"

* Long Distance to different centers *
* Railway Station *
gen longraildist = 1 if railwaydist > 3
replace longraildist = 0 if railwaydist < = 3
label var longraildist "If distance to railway stations > 3 km"

* Bus Station *
gen longbusdist = 1 if busdist > 3
replace longbusdist = 0 if busdist < = 3
label var longbusdist "If distance to bus stations > 3 km"

* Distance to district Headquarter *
gen longhqdist = 1 if hqdist > 3
replace longhqdist = 0 if hqdist < = 3
label var longhqdist "If distance to district hq > 3 km"

* Distance to nearest town *
gen longtowndist = 1 if towndist > 3
replace longtowndist = 0 if towndist < = 3
label var longtowndist "If distance to nearest town > 3 km"

* Create population measures *
gen censuspop = v101a
gen lcensuspop= log(censuspop)
label var censuspop "census pop in the village"
label var lcensuspop "log of census pop in the village"
gen currpop=v101b
gen lcurrpop = log(currpop)
label var currpop "current pop in the village"
label var lcurrpop "log of current pop in the village"

* Create no. of hh in the village *
gen tothhvill=v102
label var tothhvill "Total no. of hh in the village"


* Creating district borders - Bihar (BH) and Jharkhand (JH) *

* BH (District name with district codes) = Katihar = 1010, Bhagalpur= 1022, Banka = 1023, Rohtas =1032, Aurangabad = 1034, Gaya = 1035, Nawada = 1036, Jamui = 1037 *
* JH (District name with district codes) = Garawah =2001, Palamu = 2002, Chatra= 2003, Hazaribagh = 2004, Kodarma = 2005, Giridih = 2006, Deoghar = 2007, Godda= 2008, Sahibganj = 2009, Dumka = 2011 *

gen distborder = 1 if dist==1010|dist==1022|dist==1023|dist==1032|dist==1034|dist==1035|dist==1036|dist==1037|dist==2001|dist==2002|dist==2003|dist==2004|dist==2005|dist==2006|dist==2007|dist==2008|dist==2009|dist==2011
replace distborder = 0 if distborder == .
label var distborder "Indicator for districts sharing border in JH/BH"

* Generating various treatments and controls *
* Treatment 1 = treat1 = is 14/15 years old, control is 16/17 years old. This is the main treatment variable *
gen treat1 = 1 if age == 14|age==15
replace treat1 = 0 if age==16|age==17
label var treat1 "age 14/15 is treatment/age 16/17 is control/age"

* Treatment 2 = treat2 = is 13/14/15 years old, control is 16/17 years old *
gen treat2 = 1 if age == 13|age == 14|age==15
replace treat2 = 0 if age==16|age==17
label var treat2 "age 13/14/15 is treatment/age 16/17 is control"

* Treatment 3= treat3 = is 14/15 years old, control is 16 years old *
gen treat3 = 1 if age == 14|age==15
replace treat3 = 0 if age==16
label var treat3 "age 14/15 is treatment/age 16 is control/age"

* Treatment 4 = treat4 = is 13/14/15 years old, control is 16 years old *
gen treat4 = 1 if age == 13|age == 14|age==15
replace treat4 = 0 if age==16
label var treat4 "age 13/14/15 is treatment/age 16 is control"

* Treatment 5 = treat5 = is 13/14 years old, control is 15/16 years old. This is for girls in grade 8 *
gen treat5 = 1 if age == 13|age == 14
replace treat5 = 0 if age==15|age==16
label var treat5 "age 13/14 is treatment/age 15/16 is control"

*** Various Interactions needed to perform DD, DDD, DDDD Analysis ***
* DD Interactions *
* Heterogeneity by Caste *
gen treat1_scst = treat1*scst
gen treat1_sc = treat1*sc
gen treat1_st = treat1*st
gen treat1_obc = treat1*obc

gen treat2_scst = treat2*scst
gen treat2_sc = treat2*sc
gen treat2_st = treat2*st
gen treat2_obc = treat2*obc

gen treat3_scst = treat3*scst
gen treat3_sc = treat3*sc
gen treat3_st = treat3*st
gen treat3_obc = treat3*obc

gen treat4_scst = treat4*scst
gen treat4_sc = treat4*sc
gen treat4_st = treat4*st
gen treat4_obc = treat4*obc

gen treat5_scst = treat5*scst
gen treat5_sc = treat5*sc
gen treat5_st = treat5*st
gen treat5_obc = treat5*obc

gen female_sc = female*sc
gen female_st = female*st
gen female_obc = female*obc

gen bihar_sc = bihar*sc
gen bihar_st = bihar*st
gen bihar_obc = bihar*obc


* Various interactions by distance *
gen treat1_longdist = treat1*longdist

gen treat2_longdist = treat2*longdist

gen treat3_longdist = treat3*longdist

gen treat4_longdist = treat4*longdist

gen treat5_longdist = treat5*longdist

gen female_longdist = female*longdist

gen bihar_longdist = bihar*longdist

* DDD Interactions *

* Caste *
gen treat1_bihar_sc = treat1*bihar*sc
gen treat2_bihar_sc = treat2*bihar*sc
gen treat3_bihar_sc = treat3*bihar*sc
gen treat4_bihar_sc = treat4*bihar*sc
gen treat5_bihar_sc = treat5*bihar*sc

gen treat1_bihar_st = treat1*bihar*st
gen treat2_bihar_st = treat2*bihar*st
gen treat3_bihar_st = treat3*bihar*st
gen treat4_bihar_st = treat4*bihar*st
gen treat5_bihar_st = treat5*bihar*st

gen treat1_bihar_obc = treat1*bihar*obc
gen treat2_bihar_obc = treat2*bihar*obc
gen treat3_bihar_obc = treat3*bihar*obc
gen treat4_bihar_obc = treat4*bihar*obc
gen treat5_bihar_obc = treat5*bihar*obc

gen treat1_female_sc = treat1*female*sc
gen treat2_female_sc = treat2*female*sc
gen treat3_female_sc = treat3*female*sc
gen treat4_female_sc = treat4*female*sc
gen treat5_female_sc = treat5*female*sc

gen treat1_female_st = treat1*female*st
gen treat2_female_st = treat2*female*st
gen treat3_female_st = treat3*female*st
gen treat4_female_st = treat4*female*st
gen treat5_female_st = treat5*female*st

gen treat1_female_obc = treat1*female*obc
gen treat2_female_obc = treat2*female*obc
gen treat3_female_obc = treat3*female*obc
gen treat4_female_obc = treat4*female*obc
gen treat5_female_obc = treat5*female*obc

gen female_bihar_sc = female*bihar*sc
gen female_bihar_st = female*bihar*st
gen female_bihar_obc = female*bihar*obc


* DDDD Interactions *
gen treat1_female_bihar_longdist = treat1*female*bihar*longdist
gen treat2_female_bihar_longdist = treat2*female*bihar*longdist
gen treat3_female_bihar_longdist = treat3*female*bihar*longdist
gen treat4_female_bihar_longdist = treat4*female*bihar*longdist
gen treat5_female_bihar_longdist = treat5*female*bihar*longdist

* DDD by Caste *
gen treat1_female_bihar_sc = treat1*female*bihar*sc
gen treat2_female_bihar_sc = treat2*female*bihar*sc
gen treat3_female_bihar_sc = treat3*female*bihar*sc
gen treat4_female_bihar_sc = treat4*female*bihar*sc
gen treat5_female_bihar_sc = treat5*female*bihar*sc

gen treat1_female_bihar_st = treat1*female*bihar*st
gen treat2_female_bihar_st = treat2*female*bihar*st
gen treat3_female_bihar_st = treat3*female*bihar*st
gen treat4_female_bihar_st = treat4*female*bihar*st
gen treat5_female_bihar_st = treat5*female*bihar*st

gen treat1_female_bihar_obc = treat1*female*bihar*obc
gen treat2_female_bihar_obc = treat2*female*bihar*obc
gen treat3_female_bihar_obc = treat3*female*bihar*obc
gen treat4_female_bihar_obc = treat4*female*bihar*obc
gen treat5_female_bihar_obc = treat5*female*bihar*obc

* DDD by Treatment Age, State and Gender *
gen treat1_female_bihar = treat1*female*bihar
gen treat2_female_bihar = treat2*female*bihar
gen treat3_female_bihar = treat3*female*bihar
gen treat4_female_bihar = treat4*female*bihar
gen treat5_female_bihar = treat5*female*bihar

gen treat1_female = treat1*female
gen treat2_female = treat2*female
gen treat3_female = treat3*female
gen treat4_female = treat4*female
gen treat5_female = treat5*female

gen treat1_bihar = treat1*bihar
gen treat2_bihar = treat2*bihar
gen treat3_bihar = treat3*bihar
gen treat4_bihar = treat4*bihar
gen treat5_bihar = treat5*bihar

gen female_bihar = female*bihar

* Distance *
gen treat1_bihar_longdist = treat1*bihar*longdist
gen treat2_bihar_longdist = treat2*bihar*longdist
gen treat3_bihar_longdist = treat3*bihar*longdist
gen treat4_bihar_longdist = treat4*bihar*longdist
gen treat5_bihar_longdist = treat5*bihar*longdist

gen treat1_female_longdist = treat1*female*longdist
gen treat2_female_longdist = treat2*female*longdist
gen treat3_female_longdist = treat3*female*longdist
gen treat4_female_longdist = treat4*female*longdist
gen treat5_female_longdist = treat5*female*longdist

gen female_bihar_longdist = female*bihar*longdist

* A. Creating Asset Index using PCA - Land, Poverty Status, Access to Radio/TV, and Electricity *
pca land bpl media electricity
predict pca_asset, score

* B. Creating Socio-Economic-Status Index using PCA - Caste, Household Head School, Land, Poverty Status, Access to TV/Radio, and Electricity *
pca sc st obc hindu muslim hhheadschool land bpl media electricity
predict pca_ses, score

* With Asset Index defined by "pca_asset" *
* Generating Interactions for Asset Index *
gen treat1_female_bihar_pca_asset = treat1*female*bihar*pca_asset
gen treat1_female_pca_asset = treat1*female*pca_asset
gen female_bihar_pca_asset = female*bihar*pca_asset
gen treat1_bihar_pca_asset = treat1*bihar*pca_asset
gen treat1_pca_asset = treat1*pca_asset
gen female_pca_asset = female*pca_asset
gen bihar_pca_asset = bihar*pca_asset


* With Asset Index defined by "pca_ses" *
* Generating Interactions for SES Index *
gen treat1_female_bihar_pca_ses = treat1*female*bihar*pca_ses
gen treat1_female_pca_ses = treat1*female*pca_ses
gen female_bihar_pca_ses = female*bihar*pca_ses
gen treat1_bihar_pca_ses = treat1*bihar*pca_ses
gen treat1_pca_ses = treat1*pca_ses
gen female_pca_ses = female*pca_ses
gen bihar_pca_ses = bihar*pca_ses

 * Interactions for Muslims versus High Caste *
gen treat1_female_bihar_muslim = treat1*female*bihar*muslim
gen treat1_female_muslim = treat1*female*muslim
gen female_bihar_muslim = female*bihar*muslim
gen treat1_bihar_muslim = treat1*bihar*muslim
gen treat1_muslim = treat1*muslim
gen female_muslim = female*muslim
gen bihar_muslim = bihar*muslim

** Keeping thevariables needed for Cycling to School **

keep state dist vpsu distborder treat1_female_bihar_obc treat1_female_obc female_bihar_obc treat1_bihar_obc treat1_obc female_obc bihar_obc treat1_female_bihar_st treat1_female_st female_bihar_st treat1_bihar_st treat1_st female_st bihar_st treat1_female_bihar_sc treat1_female_sc female_bihar_sc treat1_bihar_sc treat1_sc female_sc bihar_sc pca_asset pca_ses treat1_female_bihar_pca_asset treat1_female_pca_asset female_bihar_pca_asset treat1_bihar_pca_asset treat1_pca_asset female_pca_asset bihar_pca_asset treat1_bihar_pca_ses treat1_pca_ses female_pca_ses bihar_pca_ses treat1_female_bihar_pca_ses treat1_female_pca_ses female_bihar_pca_ses treat1_bihar_pca_ses treat1_pca_ses female_pca_ses bihar_pca_ses treat1_female_bihar_muslim treat1_female_muslim female_bihar_muslim treat1_bihar_muslim treat1_muslim female_muslim bihar_muslim highcaste primary middle secschool treat5_female_bihar treat5_female treat5_bihar treat5 treat4_female_bihar treat4_female treat4_bihar treat4 treat4_female_bihar_longdist treat4_female_longdist treat4_bihar_longdist treat4_longdist treat3_female_bihar treat3_female treat3_bihar treat3 treat3_female_bihar_longdist treat3_female_longdist treat3_bihar_longdist treat3_longdist treat2_female_bihar_longdist treat2_female_longdist treat2_bihar_longdist treat2_longdist treat2_female_bihar treat2_female treat2_bihar female_bihar treat2 enrollment_secschool enrollment_middleschool age currgrade state sc st obc hindu muslim hhheadschool hhheadmale land bpl media electricity middle bank postoff lcurrpop busdist towndist railwaydist hqdist treat1_female_bihar_longdist treat1_female_longdist treat1_female_bihar female_bihar_longdist treat1_bihar_longdist treat1_female treat1_longdist treat1_bihar female_longdist female_bihar bihar_longdist treat1 female bihar longdist hhwt village

save "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA\dlhs-reg-data.dta", replace









