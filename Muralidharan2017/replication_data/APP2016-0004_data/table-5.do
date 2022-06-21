
/* Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash */
/* Table 5: Age Distribution of Students Enrolled in Ninth Grade and in Overall Sample */
clear

cd "C:\Dropbox\CycleProject\EMPIRICAL_ANALYSIS\DLHS-AEJ\DATA"

set more off

use dlhs-reg-data.dta

drop if bihar==.

drop if (age < 12 | age > 18)

* Creates Descriptive Stats for Grade/Age Distribution *

* Panel A: Age Distribution of students CURRENTLY enrolled in grade 9 *

* PANEL A: GIRLS SAMPLE BH*

tab age if (state == 10) & currgrade == 9 & female == 1 

* PANEL A: GIRLS SAMPLE JH *

tab age if (state==20) & currgrade == 9 & female == 1 

* PANEL A: GIRLS POOLED SAMPLE BH + JH *

tab age if (state == 10|state==20) & currgrade == 9 & female == 1 

* PANEL A: BOYS SAMPLE BH*

tab age if (state == 10) & currgrade == 9 & female == 0 

* PANEL A: BOYS SAMPLE JH *

tab age if (state==20) & currgrade == 9 & female == 0

* PANEL A: BOYS POOLED SAMPLE BH + JH *

tab age if (state == 10|state==20) & currgrade == 9 & female == 0 

*******************************************************************
*******************************************************************
*******************************************************************
drop if (age == 12 | age == 18)

* Panel B: Age Distribution of 13-17 year olds in the overall sample *

* PANEL B: GIRLS SAMPLE BH *

tab age if (state == 10) & female == 1 

* PANEL B: GIRLS SAMPLE JH *

tab age if (state==20) & female == 1 

* PANEL B: GIRLS POOLED SAMPLE BH + JH *

tab age if (state == 10|state==20) & female == 1 

* PANEL B: BOYS SAMPLE BH*

tab age if (state == 10) & female == 0 

* PANEL B: BOYS SAMPLE JH *

tab age if (state==20) & female == 0

* PANEL B: BOYS POOLED SAMPLE BH + JH *

tab age if (state == 10|state==20) & female == 0 
