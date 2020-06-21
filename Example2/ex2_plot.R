# boxplots for Example 2

library(ggplot2)
library(R.matlab)

fMADdat <- data.frame()

# Our method
for (i in 1:4) {
    Wangdat <- readMat(sprintf('ex2_joint%d.mat',i))
    fMAD <- sort(as.numeric(Wangdat$fMAD))
    if (length(fMAD)>100) {
        sidx <- floor((length(Wangdat$fMAD)-100)/2)
        fMAD <- fMAD[sidx+(1:100)]
    }
    fMADdat <- rbind(fMADdat, data.frame(MAD=fMAD,a=sprintf("b=%g",Wangdat$a),method='proposed') )
}

# Method by Fan and Yao
for (i in 1:4) {
    load(sprintf('ex2_Fan%d.Rdata',i))
    fMADdat <- rbind(fMADdat, data.frame(MAD=as.numeric(fMAD),a=sprintf("b=%g",a),method='residual') )
}
# Method by Wan, Brown, Cai, and Levine
for (i in 1:4) {
    load(sprintf('ex2_Wang%d.Rdata',i))
    fMADdat <- rbind(fMADdat, data.frame(MAD=as.numeric(fMAD),a=sprintf("b=%g",a),method='difference') )
}
#fMADdat$a <- factor(fMADdat$a)

pdf(file='ex2_comparison.pdf',width=5,height=5)
gg <- ggplot(data=na.omit(fMADdat), aes(x=method, y=MAD) )
gg <- gg + geom_boxplot(aes(fill=method))
gg <- gg + facet_wrap(~a,scales="free_y")
#gg <- gg + labs(x="")
gg <- gg + theme_bw()
gg <- gg + theme(strip.background=element_rect(fill="black"))
gg <- gg + theme(strip.text=element_text(color="white", face="bold"))
gg <- gg + scale_fill_grey(start=0.5, end=1.0)
#gg <- gg + scale_fill_brewer()
gg <- gg + theme(legend.position="bottom")
print(gg)
dev.off()

load('ex2_Fan2.Rdata')
# true curves
stdtrue <- sqrt((xvec-0.5)^2+0.5)
gtrue <- 1/stdtrue
meantrue <- 0.75*sin(a*pi*xvec)
ftrue <- meantrue/stdtrue
xeval <- xvec
# formatting
pdf(file='ex2_pair_Fan.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# estimated f
plot(xeval,ftrue,type='n',xlab='x',ylab='f(x)')
for (i in 1:100) lines(xeval,fVal[,i],lty=3,col=alpha("black",0.1))
# highlight f with NA due to negative variance
#neg.idx <- which(varVal<0,arr.ind=TRUE)
#negvarf <- fVal[,neg.idx[1,2]]
negvarf <- fVal[,1]
lines(xeval,negvarf,lwd=3,lty=2,col='magenta')
# true f
lines(xeval,ftrue,lwd=2,col='blue')
# estimated variance
plot(xeval,stdtrue^2,type='n',ylim=c(-0.01,1.0),xlab='x',ylab='variance(x)')
for (i in 1:100) lines(xeval,varVal[,i],lty=3,col=alpha("black",0.1))
# highlight negative variance
#neg.idx <- which(varVal<0,arr.ind=TRUE)
#negvar <- varVal[,neg.idx[1,2]]
negvar <- varVal[,1]
lines(xeval,negvar,lwd=3,lty=2,col='magenta')
## true variance function
lines(xeval,stdtrue^2,lwd=2,col='blue')
abline(h=0)
par(p.old)
dev.off()


load('ex2_Wang2.Rdata')
# true curves
stdtrue <- sqrt((xvec-0.5)^2+0.5)
gtrue <- 1/stdtrue
meantrue <- 0.75*sin(a*pi*xvec)
ftrue <- meantrue/stdtrue
xeval <- xvec
# formatting
pdf(file='ex2_pair_Wang.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# estimated f
plot(xeval,ftrue,type='n',xlab='x',ylab='f(x)')
for (i in 1:100) lines(xeval,fVal[,i],lty=3,col=alpha("black",0.1))
# highlight f with NA due to negative variance
#neg.idx <- which(varVal<0,arr.ind=TRUE)
#negvarf <- fVal[,neg.idx[1,2]]
negvarf <- fVal[,1]
lines(xeval,negvarf,lwd=3,lty=2,col='magenta')
# true f
lines(xeval,ftrue,lwd=2,col='blue')
# estimated variance
plot(xeval,stdtrue^2,type='n',ylim=c(-0.01,3.0),xlab='x',ylab='variance(x)')
for (i in 1:100) lines(xeval,varVal[,i],lty=3,col=alpha("black",0.1))
# highlight negative variance
#neg.idx <- which(varVal<0,arr.ind=TRUE)
#negvar <- varVal[,neg.idx[2,2]]
negvar <- varVal[,1]
lines(xeval,negvar,lwd=3,lty=2,col='magenta')
# true variance function
lines(xeval,stdtrue^2,lwd=2,col='blue')
abline(h=0)
dev.off()


datno <- 2
Wangdat <- readMat(sprintf('ex2_joint%d.mat',datno))
# true curves
if (length(Wangdat$fMAD)>100) {
    sidx <- floor((length(Wangdat$fMAD)-100)/2)
    idx <- order(Wangdat$fMAD)[sidx+(1:100)]
} else {
    idx <- seq_along(Wangdat$fMAD)
}
xvec <- as.numeric(Wangdat$xvec)
a <- Wangdat$a
fVal <- Wangdat$fVal[, idx]
varVal <- Wangdat$varVal[, idx]
stdtrue <- sqrt((xvec-0.5)^2+0.5)
gtrue <- 1/stdtrue
meantrue <- 0.75*sin(a*pi*xvec)
ftrue <- meantrue/stdtrue
xeval <- xvec
# formatting
pdf(file='ex2_pair_joint.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# estimated f
plot(xeval,ftrue,type='n',xlab='x',ylab='f(x)')
for (i in 1:ncol(varVal)) lines(xeval,fVal[,i],lty=3,col=alpha("black",0.1))
### highlight a random f
ridx <- 1
anyf <- fVal[,ridx]
lines(xeval,anyf,lwd=3,lty=2,col='magenta')
# true f
lines(xeval,ftrue,lwd=2,col='blue')
# estimated variance
plot(xeval,stdtrue^2,type='n',ylim=c(-0.01,3.0),xlab='x',ylab='variance(x)')
for (i in 1:ncol(varVal)) lines(xeval,varVal[,i],lty=3,col=alpha("black",0.1))
# highlight a random variance function
anyvar <- varVal[,ridx]
lines(xeval,anyvar,lwd=3,lty=2,col='magenta')
# true variance function
lines(xeval,stdtrue^2,lwd=2,col='blue')
abline(h=0)
dev.off()

## summary table (mean+i*std of MAD by b and by method)
# see https://stackoverflow.com/questions/42163188/calculate-groups-of-column-means-and-standard-deviations
library(dplyr)
library(tidyr)
library(knitr)
ftab <- fMADdat %>% group_by(a,method) %>% summarise(meanstd_MAD=complex(real=mean(MAD,na.rm=T),imaginary=sd(MAD,na.rm=T))) %>% spread(method,meanstd_MAD) %>% ungroup()
kable(ftab)
