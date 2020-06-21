#
# Example 1 by Fan and Yao
#
library(locpol)

no_of_pts <- 200;        # no. of data points in [0,1]

xvec <- seq(0.01,0.99,0.01) # evaluation points

stdtrue <- 0.4*exp(-2*(4*xvec-2)^2)+0.2
gtrue <- 1/stdtrue

B <- 100

avec <- c(0.5, 1.0, 2.0, 4.0)

for (k in seq_along(avec)) {
set.seed(911)  # for reproducibility
#a <- 0.5
#a <- 1.0
#a <- 2.0
#a <- 4.0
a <- avec[k]

meantrue <- a*(4*xvec-2+2*exp(-16*(4*xvec-2)^2))
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

cat(sprintf('Example 1 -- Fan (out of %d):', B))
for (i in 1:B) {
    datax <- sort(runif(no_of_pts,0,1))
    datay <- a*(4*datax-2+2*exp(-16*(4*datax-2)^2)) + (0.4*exp(-2*(4*datax-2)^2)+0.2)*rnorm(no_of_pts)

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

#save(dataX,dataY,a,fMAD,fMSE,gMAD,meanMAD,meanMSE,stdMAD,stdMSE,xvec, 
#     fVal, gVal, meanVal, varVal,
#     file='ex1_Fan1.Rdata')

#save(dataX,dataY,a,fMAD,fMSE,gMAD,meanMAD,meanMSE,stdMAD,stdMSE,xvec, 
#     fVal, gVal, meanVal, varVal,
#     file='ex1_Fan2.Rdata')

#save(dataX,dataY,a,fMAD,fMSE,gMAD,meanMAD,meanMSE,stdMAD,stdMSE,xvec, 
#     fVal, gVal, meanVal, varVal,
#     file='ex1_Fan3.Rdata')

#save(dataX,dataY,a,fMAD,fMSE,gMAD,meanMAD,meanMSE,stdMAD,stdMSE,xvec, 
#     fVal, gVal, meanVal, varVal,
#     file='ex1_Fan4.Rdata')
save(dataX,dataY,a,fMAD,fMSE,gMAD,meanMAD,meanMSE,stdMAD,stdMSE,xvec, 
     fVal, gVal, meanVal, varVal,
     file=sprintf('ex1_Fan%d.Rdata', k) )

}

