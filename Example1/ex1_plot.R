# boxplots for Example 1

library(ggplot2)
library(R.matlab)

fMADdat <- data.frame()

# Our method
for (i in 1:4) {
    Fandat <- readMat(sprintf('ex1_joint%d.mat',i))
    fMAD <- sort(as.numeric(Fandat$fMAD))
    sidx <- floor((length(Fandat$fMAD)-100)/2)
    fMAD <- fMAD[sidx+(1:100)]
    fMADdat <- rbind(fMADdat, data.frame(MAD=fMAD,a=sprintf("a=%g",Fandat$a),method='proposed') )
}

# Method by Fan and Yao
for (i in 1:4) {
    load(sprintf('ex1_Fan%d.Rdata',i))
    fMADdat <- rbind(fMADdat, data.frame(MAD=as.numeric(fMAD),a=sprintf("a=%g",a),method='residual') )
}
# Method by Wang, Brown, Cai, and Levine
for (i in 1:4) {
    load(sprintf('ex1_Wang%d.Rdata',i))
    fMADdat <- rbind(fMADdat, data.frame(MAD=as.numeric(fMAD),a=sprintf("a=%g",a),method='difference') )
}

pdf(file='ex1_comparison.pdf',width=5,height=5)
gg <- ggplot(data=na.omit(fMADdat), aes(x=method, y=MAD) )
gg <- gg + geom_boxplot(aes(fill=method))
gg <- gg + facet_wrap(~a,scales="free_y")
gg <- gg + theme_bw()
gg <- gg + theme(strip.background=element_rect(fill="black"))
gg <- gg + theme(strip.text=element_text(color="white", face="bold"))
gg <- gg + scale_fill_grey(start=0.5, end=1.0)
gg <- gg + theme(legend.position="bottom")
print(gg)
dev.off()

load('ex1_Fan1.Rdata')
# true curves
stdtrue <- 0.4*exp(-2*(4*xvec-2)^2)+0.2
gtrue <- 1/stdtrue
meantrue <- a*(4*xvec-2+2*exp(-16*(4*xvec-2)^2))
ftrue <- meantrue/stdtrue
xeval <- 4*(xvec-0.5)
# formatting
pdf(file='ex1_pair_Fan.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# estimated f
plot(xeval,ftrue,type='n',xlab='x',ylab='f(x)')
for (i in 1:100) lines(xeval,fVal[,i],lty=3,col=alpha("black",0.1))
# highlight f with NA due to negative variance
neg.idx <- which(varVal<0,arr.ind=TRUE)
negvarf <- fVal[,neg.idx[1,2]]
lines(xeval,negvarf,lwd=3,lty=2,col='magenta')
# true f
lines(xeval,ftrue,lwd=2,col='blue')
# estimated variance
plot(xeval,stdtrue^2,type='n',ylim=c(-0.01,1.0),xlab='x',ylab='variance(x)')
for (i in 1:100) lines(xeval,varVal[,i],lty=3,col=alpha("black",0.1))
# highlight negative variance
neg.idx <- which(varVal<0,arr.ind=TRUE)  # nrow(neg.idx) is the no. fns. with <0 values
negvar <- varVal[,neg.idx[1,2]]
lines(xeval,negvar,lwd=3,lty=2,col='magenta')
# true variance function
lines(xeval,stdtrue^2,lwd=2,col='blue')
abline(h=0)
par(p.old)
dev.off()


load('ex1_Wang1.Rdata')
# true curves
stdtrue <- 0.4*exp(-2*(4*xvec-2)^2)+0.2
gtrue <- 1/stdtrue
meantrue <- a*(4*xvec-2+2*exp(-16*(4*xvec-2)^2))
ftrue <- meantrue/stdtrue
xeval <- 4*(xvec-0.5)
# formatting
pdf(file='ex1_pair_Wang.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# estimated f
plot(xeval,ftrue,type='n',xlab='x',ylab='f(x)')
for (i in 1:100) lines(xeval,fVal[,i],lty=3,col=alpha("black",0.1))
# highlight f with NA due to negative variance
neg.idx <- which(varVal<0,arr.ind=TRUE)
negvarf <- fVal[,neg.idx[1,2]]
lines(xeval,negvarf,lwd=3,lty=2,col='magenta')
# true f
lines(xeval,ftrue,lwd=2,col='blue')
# estimated variance
plot(xeval,stdtrue^2,type='n',ylim=c(-0.01,1.0),xlab='x',ylab='variance(x)')
for (i in 1:100) lines(xeval,varVal[,i],lty=3,col=alpha("black",0.1))
# highlight negative variance
neg.idx <- which(varVal<0,arr.ind=TRUE)
negvar <- varVal[,neg.idx[2,2]]
lines(xeval,negvar,lwd=3,lty=2,col='magenta')
# true variance function
lines(xeval,stdtrue^2,lwd=2,col='blue')
abline(h=0)
dev.off()



Fandat <- readMat(sprintf('ex1_joint%d.mat',1))
# true curves
sidx <- floor((length(Fandat$fMAD)-100)/2)
idx <- order(Fandat$fMAD)[sidx+(1:100)]
xvec <- as.numeric(Fandat$xvec)
a <- Fandat$a
fVal <- Fandat$fVal[,idx]
varVal <- Fandat$varVal[,idx]
stdtrue <- 0.4*exp(-2*(4*xvec-2)^2)+0.2
gtrue <- 1/stdtrue
meantrue <- a*(4*xvec-2+2*exp(-16*(4*xvec-2)^2))
ftrue <- meantrue/stdtrue
xeval <- 4*(xvec-0.5)
# formatting
pdf(file='ex1_pair_joint.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# estimated f
plot(xeval,ftrue,type='n',xlab='x',ylab='f(x)')
for (i in 1:100) lines(xeval,fVal[,i],lty=3,col=alpha("black",0.1))
## highlight a random f
ridx <- 1 
ridx <- sample(1:100,1)
anyf <- fVal[,ridx]
lines(xeval,anyf,lwd=3,lty=2,col='magenta')
# true f
lines(xeval,ftrue,lwd=2,col='blue')
# estimated variance
plot(xeval,stdtrue^2,type='n',ylim=c(-0.01,1.0),xlab='x',ylab='variance(x)')
for (i in 1:100) lines(xeval,varVal[,i],lty=3,col=alpha("black",0.1))
# highlight a random variance function
anyvar <- varVal[,ridx]
lines(xeval,anyvar,lwd=3,lty=2,col='magenta')
# true variance function
lines(xeval,stdtrue^2,lwd=2,col='blue')
abline(h=0)
dev.off()

## summary table (mean+i*std of MAD by a and by method)
## see https://stackoverflow.com/questions/42163188/calculate-groups-of-column-means-and-standard-deviations
library(dplyr)
library(tidyr)
library(knitr)
ftab <- fMADdat %>% group_by(a,method) %>% summarise(meanstd_MAD=complex(real=mean(MAD,na.rm=T),imaginary=sd(MAD,na.rm=T))) %>% spread(method,meanstd_MAD) %>% ungroup()
kable(ftab)
