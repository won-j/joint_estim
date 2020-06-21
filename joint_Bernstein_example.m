%%% example of joint estimation of mean and variance functions
%%% by using linear-fractional parametrization 
rand('seed',1);

%no_of_pts = 10;  	% no. of data points in [0,1]
no_of_pts = 100;  	% no. of data points in [0,1]
deg = 3;
%sub = 2;		% no. of subdivision of [0,1] for g
sub = 10;		% no. of subdivision of [0,1] for g
lam = 0.001;   		% smoothness parameter for f

datax = sort(rand(no_of_pts,1));
datay = rand(no_of_pts,1)*2;
[f_fd,g_fd,q,p]=joint_Bernstein(datax,datay,lam,sub);


% plot fitted f and g
figure;
subplot(2,1,1)
plotfit_fd(datay,datax,f_fd)
subplot(2,1,2)
plotfit_fd(datay,datax,g_fd)
%print -dpdf 'Bernstein_f_g.pdf'

%%% plot mean (=f/g) and standard deviation (1/g)
xvec=linspace(0,1,100);
mean_fn = eval_fd(xvec,f_fd)./eval_fd(xvec,g_fd);
std_fn = 1./eval_fd(xvec,g_fd);
% benchmark: smoothing spline
nbasis = no_of_pts + deg+1;
knots = [0; sort(datax); 1];
smbasis = create_bspline_basis([0,1],nbasis,deg+1,knots);
mu_fdPar = fdPar(smbasis, 2, lam);
mu_fd = smooth_basis(datax, datay, mu_fdPar );
mu_fn = eval_fd(xvec,mu_fd);

figure;
subplot(2,1,1);
plot(xvec,mean_fn)
hold on;
plot(xvec,mu_fn,'m--')  % smoothing spline
plot(datax,datay,'ko')
title('mean function')
legend('joint','mean only')
subplot(2,1,2);
plot(xvec,std_fn);
hold on;
plot(datax,datay,'ko')
title('std function')
%print -dpdf 'Bernstein_mean_std.pdf'
