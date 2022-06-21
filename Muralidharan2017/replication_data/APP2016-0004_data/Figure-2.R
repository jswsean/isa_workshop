install.packages("foreign")
library(foreign)
lest<-read.dta("C:/Users/zwei/Downloads/Cycle-Replication/Replication Files/DATA/ddd_long.dta")
dd10<-lest$dd10
dd10.l<-lest$ci_low10
dd10.h<-lest$ci_high10
dd20<-lest$dd20
dd20.l<-lest$ci_low20
dd20.h<-lest$ci_high20
diff<-lest$diff
diff.l<-lest$ci_low30
diff.h<-lest$ci_high30
tempdist<-lest$longdistgroup

postscript(file="C:/Users/zwei/Downloads/Cycle-Replication/Replication Files/REPLICATION FIGURES/DD_longdist.ps",horizontal=F)
par(oma=c(3,1,5,1), mar=c(2,2,3.5,3))


par(fig=c(0,1,2/3,1),mar=c(4,6,2.5,3))

plot(tempdist,dd10,
     type="l",
     ylim=c(-0.1,0.3),
     xlab="Distance to Secondary School (KM)",
     ylab="Double Difference\nChange in Girls' Enrollment -\nChange in Boys' Enrollment",
     cex.lab=0.7,
     cex.axis=0.7)
title(expression(underline("Panel A: Bihar Double Difference by Distance to Secondary School")),
	  cex.main=1,font.main=1)
	  
polygon(x=c(tempdist,rev(tempdist)),y=c(dd10.l,rev(dd10.h)),col="lightblue1",border=F)
par(new=T)
plot(tempdist,dd10,
     type="l",
     ylim=c(-0.1,0.3),
     xlab="Distance to Secondary School (KM)",
     ylab="Double Difference\nChange in Girls' Enrollment -\nChange in Boys' Enrollment",
     cex.lab=0.7,
     cex.axis=0.7)
abline(h=0)

par(new=T)
par(fig=c(0,1,1/3,2/3),mar=c(4,6,2.5,3))

plot(tempdist,dd20,
     type="l",
     ylim=c(-0.1,0.2),
     xlab="Distance to Secondary School (KM)",
     ylab="Double Difference\nChange in Girls' Enrollment -\nChange in Boys' Enrollment",
     cex.lab=0.7,
     cex.axis=0.7)
title(expression(underline("Panel B: Jharkhand Double Difference by Distance to Secondary School")),
	  cex.main=1, font.main=1)
	  
polygon(x=c(tempdist,rev(tempdist)),y=c(dd20.l,rev(dd20.h)),col="lightblue1",border=F)
par(new=T)
plot(tempdist,dd20,
     type="l",
     ylim=c(-0.1,0.2),
     xlab="Distance to Secondary School (KM)",
     ylab="Double Difference\nChange in Girls' Enrollment -\nChange in Boys' Enrollment",
     cex.lab=0.7,
     cex.axis=0.7)
abline(h=0)

par(new=T)
par(fig=c(0,1,0,1/3),mar=c(4,6,2.5,3))

plot(tempdist,diff,
     type="l",
     ylim=c(-0.25,0.25),
     xlab="Distance to Secondary School (KM)",
     ylab="Triple Difference\nDouble Difference in Bihar -\nDouble Difference in Jharkhand",
     cex.lab=0.7,
     cex.axis=0.7)
title(expression(underline("Panel C: Triple Difference by Distance to Secondary School")),
	  cex.main=1, font.main=1)
	  
polygon(x=c(tempdist,rev(tempdist)),y=c(diff.l,rev(diff.h)),col="lightblue1",border=F)
par(new=T)
plot(tempdist,diff,
     type="l",
     ylim=c(-0.25,0.25),
     xlab="Distance to Secondary School (KM)",
     ylab="Triple Difference\nDouble Difference in Bihar -\nDouble Difference in Jharkhand",
     cex.lab=0.7,
     cex.axis=0.7)
abline(h=0)

mtext("Figure 2: Non-parametric double and triple difference estimates of impact of the cycle program\n(by distance to nearest secondary school)",side=3,line=0,cex=1,outer=T)   


dev.off()
