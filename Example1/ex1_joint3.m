%%% example of joint estimation of mean and variance functions
%%% by using linear-fractional parametrization 

randn('seed',1);
rand('seed',1);
no_of_pts = 200;  	% no. of data points in [0,1]

sub = 6;		% no. of subdivision of [0,1] for g
lam = 0.00001;   		% smoothness parameter for f

xvec=linspace(0,1,101); % evaluation points
xvec=xvec(2:end-1);

stdtrue = 0.4*exp(-2*(4*xvec-2).^2)+0.2;
gtrue = 1./stdtrue;

B=200;

%a=0.5; 
%a=1.0;
a=2.0;
%a=4.0;

meantrue = a*(4*xvec-2+2*exp(-16*(4*xvec-2).^2));
ftrue = meantrue./stdtrue;

dataX = [];
dataY = [];
fcell = cell(B,1);
gcell = cell(B,1);
fMAD = []; fMSE = [];
gMAD = []; gMSE = [];
meanMAD = []; meanMSE = [];
stdMAD = []; stdMSE = [];
fVal = []; gVal = []; meanVal = []; stdVal = []; varVal = [];

cnt=1;
fprintf(1,'Performance analysis (out of %d):', B);
for i=1:B,
    datax = sort(rand(no_of_pts,1));
    datay = a*(4*datax-2+2*exp(-16*(4*datax-2).^2)) + (0.4*exp(-2*(4*datax-2).^2)+0.2).*randn(no_of_pts,1);

    try
    	[f_fd,g_fd,q,p,optval]=joint_Bernstein(datax,datay,lam,sub,false);
    catch
        optval=NaN;
    end
    if ( isnan(optval) ) continue; end

    fval = eval_fd(xvec,f_fd);
    gval = eval_fd(xvec,g_fd);
    meanval = fval./gval;
    stdval = 1./gval;

    fVal = [fVal, fval];
    gVal = [gVal, gval];
    meanVal = [meanVal, meanval];
    stdVal = [stdVal, stdval];
    varVal = [varVal, stdval.^2];

    fMAD = [fMAD, mean(abs(fval-ftrue'))];
    fMSE = [fMSE, mean((fval-ftrue').^2)];
    gMAD = [gMAD, mean(abs(gval-gtrue'))];
    gMSE = [gMSE, mean((gval-gtrue').^2)];
    meanMAD = [meanMAD, mean(abs(meanval-meantrue'))];
    meanMSE = [meanMSE, mean((meanval-meantrue').^2)];
    stdMAD = [stdMAD, mean(abs(stdval-stdtrue'))];
    stdMSE = [stdMSE, mean((stdval-stdtrue').^2)];

    dataX = [dataX, datax];
    dataY = [dataY, datay];
    fcell{cnt} = f_fd;
    gcell{cnt} = g_fd;

    fprintf(1, '\t%d', i);
    cnt = cnt + 1;
end
fprintf(1,'\n');

save('ex1_joint3.mat','fcell','gcell','dataX','dataY','a',...
    'fMAD','fMSE','gMAD','meanMAD','meanMSE','stdMAD','stdMSE',...
    'fVal', 'gVal', 'meanVal', 'varVal', ...
    'xvec','lam','sub');

