library(foreign)
setwd("C:/Users/zwei/Downloads/Cycle-Replication/Replication Files/")
dist.data<-read.dta("DATA/schooldist.dta")
dist.india<-dist.data$highschool_india
dist.india.male<-dist.data$highschool_india_male
dist.india.female<-dist.data$highschool_india_female
dist.bihar<-dist.data$highschool_bihar
dist.bihar.male<-dist.data$highschool_bihar_male
dist.bihar.female<-dist.data$highschool_bihar_female
dist<-dist.data$secondarydist


age.data<-read.dta("DATA/schoolage.dta")
age.india<-age.data$inschool_india
age.india.male<-age.data$inschool_india_male
age.india.female<-age.data$inschool_india_female
age.bihar<-age.data$inschool_bihar
age.bihar.male<-age.data$inschool_bihar_male
age.bihar.female<-age.data$inschool_bihar_female
age<-age.data$age

postscript(file="REPLICATION FIGURES/gradients.ps",horizontal=F)
par(oma=c(3,1,5,1), mar=c(2,2,3.5,3))

par(fig=c(0,0.5,0.53,1),mar=c(4,4,2.5,3))

plot(age,100*age.india,
     type="l",
     ylim=c(40,100),
     xlab="Age (Years)",
     ylab="Percent",
     cex.lab=0.7,
     cex.axis=0.7
     )
lines(age,100*age.india.male,col="blue",lty=2)
lines(age,100*age.india.female,col="red",lty=3)
title("India",
	  cex.main=0.7)
legend(8.5,65,c("All","Male","Female"),lty=c(1,2,3),col=c("black","blue","red"),cex=0.7)	  
	  
	  
par(new=T)	  
par(fig=c(0.5,1,0.53,1),mar=c(4,4,2.5,3))

plot(age,100*age.bihar,
     type="l",
     ylim=c(40,100),
     xlab="Age (Years)",
     ylab="Percent",
     cex.lab=0.7,
     cex.axis=0.7)
lines(age,100*age.bihar.male,col="blue",lty=2)
lines(age,100*age.bihar.female,col="red",lty=3)
title("Bihar",
	  cex.main=0.7)	 
 
	  
par(new=T)	  
par(fig=c(0,0.5,0,0.47),mar=c(4,4,2.5,3))

plot(dist,100*dist.india,
     type="l",
     ylim=c(10,70),
     xlab="Distance to Secondary School (KM)",
     ylab="Percent",
     cex.lab=0.7,
     cex.axis=0.7)
lines(dist,100*dist.india.male,col="blue",lty=2)
lines(dist,100*dist.india.female,col="red",lty=3)     
title("India",
	  cex.main=0.7)
legend(0.5,25,c("All","Male","Female"),lty=c(1,2,3),col=c("black","blue","red"),cex=0.7)	  	 
	  
	  
par(new=T)	  
par(fig=c(0.5,1,0,0.47),mar=c(4,4,2.5,3))

plot(dist,100*dist.bihar,
     type="l",
     ylim=c(10,70),
     xlab="Distance to Secondary School (KM)",
     ylab="Percent",
     cex.lab=0.7,
     cex.axis=0.7)
lines(dist,100*dist.bihar.male,col="blue",lty=2)
lines(dist,100*dist.bihar.female,col="red",lty=3)     
title("Bihar",
	  cex.main=0.7)	
	  
mtext(expression(underline("Panel B: 16 and 17 Year Olds Enrolled in OR Completed Grade 9 by Distance and Gender")),side=3,line=-26,cex=1,outer=T,adj=0.5)
mtext(expression(underline("Panel A: Enrollment in School by Age and Gender")), side=3,line=-0.5,cex=1,outer=T,adj=0.5,font=0)
mtext("Figure 1",side=3,line=1,cex=1,outer=T)   
mtext("Source: Author's calculations using the 2008 District Level Health Survey (DLHS).",side=1,line=0,outer=T,adj=0,cex=0.7)
mtext("Source: Author's calculations using the 2008 District Level Health Survey (DLHS).",side=1,line=-25.5,outer=T,adj=0,cex=0.7)
	  
dev.off()

#source("C:\Dropbox\CycleProject\Journal Submissions\AEJ-Applied\Replication Files\REPLICATION FIGURES\Figure-1.R”)	  
	  
