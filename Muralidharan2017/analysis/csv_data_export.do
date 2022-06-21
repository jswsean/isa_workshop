
/*  
	Project name	: Cycling to School Replication Files for AEJ: Applied by Muralidharan and Prakash 
	do-file desc.	: extracting data from Github's zipped file into internal directory
	last update		: 2022-06-21
*/

* removing prior work environment 
clear all 
clear matrix
clear mata 
set more off

* setting up the global macros
if "`c(username)'" == "Sean Hambali" {
	gl github_data "C:/Users/Sean Hambali/Documents/GitHub/wb_isa_workshop/Muralidharan2017/replication_data/APP2016-0004_data"
	gl local_data "C:/Users/Sean Hambali/Desktop/DATA/Muralidharan2017"
}

* we change our CD to the local data folder 
cd "$local_data"

* we unzip the large data files into the CD 
* (I'm using WinRAR to unzip the data files below. You'll need to install winRAR as 
* the zipped data is in .rar)
shell set path="C:/Program Files/WinRAR"; %path% & unrar e "$github_data/APP2016-0004_data.rar"
* an extraction prompt should appear upon executing the above command. 
* the relevatn data files should now be in your local_data folder.

* we'll be working simultaneously with the github_data and local_data folder.


