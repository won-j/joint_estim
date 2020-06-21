library(locpol)
library(R.matlab)

# 3-month Treasury Bill yields
Z <- read.table('w-gs1yr.txt')
z <- Z[1:1735,2]     # from Jan-05-1962 to Mar-31-1995 (cf. Fan and Yao)
dates <- as.Date(as.character(Z[1:1735,1]),'%Y%m%d')

# fit AR(5)
yy <- z[6:1735]
X <- cbind(z[5:1734],z[4:1733],z[3:1732],z[2:1731],z[1:1730])
lmfit <- lm(yy~X+0)
x<-z[5:1734]
sidx<-order(x)
tbill.df <- data.frame(x=x[sidx],y=resid(lmfit)[sidx])
#xeval <- seq(0.01,0.99,0.01) # evaluation points
#mean.tbill <- locpol(y~x,tbill.df,xeval=Tbill$xmin+(Tbill$xmax-Tbill$xmin)*xeval)$lpFit

# residuals after fitting AR(5) (cf. Fan and Yao)
Tbill<-readMat('tbill_data.mat')
tbill.df <- data.frame(x=as.numeric(Tbill$xmin)+as.numeric(Tbill$xmax-Tbill$xmin)*as.numeric(Tbill$datax),y=Tbill$datay)
xeval <- Tbill$xmin + (Tbill$xmax-Tbill$xmin)*seq(0.01,0.99,0.01) # evaluation points
# local polynomial fit of the mean function
mean.tbill <- locpol(y~x,tbill.df,xeval=xeval)$lpFit

# formatting
pdf(file='tbill_basic.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# plot interest rates
plot(dates,z,type='l',xlab='year',ylab='interest rate (percent)')
# plot residual
plot(x, resid(lmfit), type='p', cex=0.3, xlab='X(t)', ylab='Y(t)')
lines(mean.tbill, col='blue', lwd=2)
dev.off()


#
# Joint estimation
#
Tbill<-readMat('tbill_data.mat')
Tbillp<-readMat('tbill_joint.mat')

xeval=as.numeric(Tbillp$xvec)
mean_boot <- Tbillp$f.boot/Tbillp$g.boot
var_boot <- 1/Tbillp$g.boot^2
mean_confint <- apply(mean_boot,1,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))
var_confint <- apply(var_boot,1,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))

# formatting
pdf(file='tbill_joint_pair.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# plot Sharpe ratio
xplot <- Tbill$xmin+(Tbill$xmax-Tbill$xmin)*xeval
plot(xplot,Tbillp$f.eval,col='blue',type='l',lwd=2,ylim=c(-2,2),xlab='x',ylab='f(x)')
lines(xplot,Tbillp$f.confint[,1],type='l',lty=3)
lines(xplot,Tbillp$f.confint[,2],type='l',lty=3)
# plot variance function
varcurve <- 1/(Tbillp$g.eval^2)
plot(xplot,varcurve,col='blue',type='l',lwd=2,ylim=c(0,1),xlab='x',ylab='variance(x)')
lines(xplot,var_confint[1,],type='l',lty=3)
lines(xplot,var_confint[2,],type='l',lty=3)
dev.off()



#
# Fan and Yao
#
Tbill<-readMat('tbill_data.mat')
set.seed(911)
tbill.df <- data.frame(x=Tbill$datax,y=Tbill$datay)
xeval=seq(0.01,0.99,0.01) # evaluation points
# local polynomial fit of the mean function
mean.tbill <- locpol(y~x,tbill.df,xeval=xeval)$lpFit
# residual computation
mean.tbillfit <- locpol(y~x,tbill.df,xeval=tbill.df$x)$lpFit
resy <- (tbill.df$y-mean.tbillfit$y)^2
tbill.df$resid <- resy
# local polynomial fit of the variance function
var.tbill <- locpol(resid~x,tbill.df,xeval=xeval)$lpFit
var.tbillfit <- locpol(resid~x,tbill.df,xeval=tbill.df$x)$lpFit
# fits
f_fit <- mean.tbill$y/sqrt(var.tbill$resid)
g_fit <- 1/sqrt(var.tbill$resid)

# bootstrap confidence interval
err <- (tbill.df$y-mean.tbillfit$y)/sqrt(var.tbillfit$resid)
B <- 100
f_boot <- matrix(0,nrow=B,ncol=length(xeval))
g_boot <- matrix(0,nrow=B,ncol=length(xeval))
mean_boot <- matrix(0,nrow=B,ncol=length(xeval))
var_boot <- matrix(0,nrow=B,ncol=length(xeval))
for (b in 1:B) {
    y.b <- mean.tbillfit$y + sqrt(var.tbillfit$resid)*sample(err,length(err),replace=TRUE)
    tbill.df.b <- data.frame(x=tbill.df$x, y=y.b)
    mean.b <- locpol(y~x,tbill.df.b,xeval=xeval)$lpFit
    mean.fit.b <- locpol(y~x,tbill.df.b,xeval=tbill.df$x)$lpFit
    resy.b <- (tbill.df.b$y-mean.fit.b$y)^2
    tbill.df.b$resid <- resy.b
    var.b <- locpol(resid~x,tbill.df.b,xeval=xeval)$lpFit
    f_boot[b,] <- mean.b$y/sqrt(var.b$resid)
    g_boot[b,] <- 1/sqrt(var.b$resid)
    mean_boot[b,] <- mean.b$y
    var_boot[b,] <- var.b$resid
}
f_confint <- apply(f_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))
g_confint <- apply(g_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))
mean_confint <- apply(mean_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))
var_confint <- apply(var_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))

# formatting
pdf(file='tbill_Fan_pair.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# plot Sharpe ratio
xplot <- Tbill$xmin+(Tbill$xmax-Tbill$xmin)*xeval
plot(xplot,f_fit,col='blue',type='l',lwd=2,ylim=c(-2,2),xlab='x',ylab='f(x)')
lines(xplot,f_confint[1,],type='l',lty=3)
lines(xplot,f_confint[2,],type='l',lty=3)
# plot variance function
plot(xplot,var.tbill$resid,col='blue',type='l',lwd=2,ylim=c(0,0.5),xlab='x',ylab='variance(x)')
lines(xplot,var_confint[1,],type='l',lty=3)
lines(xplot,var_confint[2,],type='l',lty=3)
dev.off()



#
# Wang et al.
#
Tbill<-readMat('tbill_data.mat')
set.seed(1)
tbill.df <- data.frame(x=Tbill$datax,y=Tbill$datay)
xeval <- seq(0.01,0.99,0.01) # evaluation points
# local polynomial fit of the mean function
mean.tbill <- locpol(y~x,tbill.df,xeval=xeval)$lpFit
# variance function estimation using difference
vx <- tbill.df$x[seq_len(nrow(tbill.df)-1)]
vy <- diff(tbill.df$y)^2
vd <- data.frame(vx,vy)
var.tbill <- locpol(vy~vx,vd,xeval=xeval)$lpFit
var.tbillfit <- locpol(vy~vx,vd,xeval=tbill.df$x)$lpFit
# fits
f_fit <- mean.tbill$y/sqrt(var.tbill$vy)
g_fit <- 1/sqrt(var.tbill$vy)

# bootstrap confidence interval
mean.tbillfit <- locpol(y~x,tbill.df,xeval=tbill.df$x)$lpFit
err <- (tbill.df$y-mean.tbillfit$y)/sqrt(var.tbillfit$vy)
B <- 100
f_boot <- matrix(0,nrow=B,ncol=length(xeval))
g_boot <- matrix(0,nrow=B,ncol=length(xeval))
mean_boot <- matrix(0,nrow=B,ncol=length(xeval))
var_boot <- matrix(0,nrow=B,ncol=length(xeval))
for (b in 1:B) {
    y.b <- mean.tbillfit$y + sqrt(var.tbillfit$vy)*sample(err,length(err),replace=TRUE)
    tbill.df.b <- data.frame(x=tbill.df$x, y=y.b)
    mean.b <- locpol(y~x,tbill.df.b,xeval=xeval)$lpFit
    mean.fit.b <- locpol(y~x,tbill.df.b,xeval=tbill.df$x)$lpFit
    vx.b <- tbill.df.b$x[seq_len(nrow(tbill.df.b)-1)]
    vy.b <-  diff(tbill.df.b$y)^2
    vd.b <- data.frame(vx=vx.b,vy=vy.b)
    var.b <- locpol(vy~vx,vd.b,xeval=xeval)$lpFit
    f_boot[b,] <- mean.b$y/sqrt(var.b$vy)
    g_boot[b,] <- 1/sqrt(var.b$vy)
    mean_boot[b,] <- mean.b$y
    var_boot[b,] <- var.b$vy
}
f_confint <- apply(f_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))
g_confint <- apply(g_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))
mean_confint <- apply(mean_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))
var_confint <- apply(var_boot,2,function(x) quantile(x,p=c(0.025,0.975),na.rm=TRUE))

# formatting
pdf(file='tbill_Wang_pair.pdf',width=10,height=5)
p.old<-par(mfrow=c(1,2))
par(mai=c(1.02,0.82,0.82,0.22))
par(cex.lab=1.5,mgp=c(2.7,1,0))
# plot Sharpe ratio
xplot <- Tbill$xmin+(Tbill$xmax-Tbill$xmin)*xeval
plot(xplot,f_fit,col='blue',type='l',lwd=2,ylim=c(-2,2),xlab='x',ylab='f(x)')
lines(xplot,f_confint[1,],type='l',lty=3)
lines(xplot,f_confint[2,],type='l',lty=3)
# plot variance function
plot(xplot,var.tbill$vy,col='blue',type='l',lwd=2,ylim=c(0,1),xlab='x',ylab='variance')
lines(xplot,var_confint[1,],type='l',lty=3)
lines(xplot,var_confint[2,],type='l',lty=3)
dev.off()

