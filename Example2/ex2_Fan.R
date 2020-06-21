#
# Example by Wang et al.
#
library(locpol)

no_of_pts <- 200;        # no. of data points in [0,1]

xvec <- seq(0.01,0.99,0.01) # evaluation points

stdtrue <- sqrt((xvec-0.5)^2+0.5)
gtrue <- 1/stdtrue

B <- 100

avec <- c(0,10,20,40)
#a <- 0
#a <- 10
#a <- 20
#a <- 40
for (iter in seq_along(avec)) {
    
set.seed(911)
a <- avec[iter]
meantrue <- 0.75*sin(a*pi*xvec)
ftrue <- meantrue/stdtrue

dataX <- numeric()
dataY <- numeric()
fMAD <- numeric() 
fMSE <- numeric()
gMAD <- numeric()
gMSE <- numeric()
meanMAD <- numeric() 
meanMSE <- numeric()
stdMAD <- numeric() 
stdMSE <- numeric()
fVal <- numeric() 
gVal <- numeric() 
meanVal <- numeric() 
varVal <- numeric()

cat(sprintf('Example 2 -- Fan (out of %d):', B))
for (i in 1:B) {
    datax <- sort(runif(no_of_pts,0,1))
    datay <- 0.75*sin(a*pi*datax) + sqrt((datax-0.5)^2+0.5)*rnorm(no_of_pts)

    fan.df <- data.frame(x=datax,y=datay)
    # local polynomial fit of the mean function
    mean.fit <- locpol(y~x,fan.df,xeval=fan.df$x)$lpFit
    # residual computation
    resy <- (fan.df$y-mean.fit$y)^2
    fan.df$resid <- resy
    # local polynomial fit of the variance function
    varval <- locpol(resid~x,fan.df,xeval=xvec)$lpFit$resid
    
    # fits
    meanval <- locpol(y~x,fan.df,xeval=xvec)$lpFit$y
    stdval <- sqrt(varval)
    fval <- meanval/stdval
    gval <- 1/stdval

    fVal <- cbind(fVal, fval)
    gVal <- cbind(gVal, gval)
    meanVal <- cbind(meanVal, meanval)
    varVal <- cbind(varVal, varval)

    fMAD <- cbind(fMAD, mean(abs(fval-ftrue) ) ) 
    fMSE <- cbind(fMSE, mean((fval-ftrue)^2) ) 
    gMAD <- cbind(gMAD, mean(abs(gval-gtrue ) ) ) 
    gMSE <- cbind(gMSE, mean((gval-gtrue)^2 ) ) 
    meanMAD <- cbind(meanMAD, mean(abs(meanval-meantrue) ) ) 
    meanMSE <- cbind(meanMSE, mean((meanval-meantrue)^2 ) ) 
    stdMAD <- cbind(stdMAD, mean(abs(stdval-stdtrue) ) ) 
    stdMSE <- cbind(stdMSE, mean((stdval-stdtrue)^2 ) ) 

    dataX <- cbind(dataX, datax)
    dataY <- cbind(dataY, datay)
    
    cat(sprintf('\t%d', i))
}
cat(sprintf('\n'))

save(dataX,dataY,a,fMAD,fMSE,gMAD,meanMAD,meanMSE,stdMAD,stdMSE,xvec, 
     fVal, gVal, meanVal, varVal,
     file=sprintf('ex2_Fan%d.Rdata',iter))
} # end iter
