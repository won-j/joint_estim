%' Bootstrapping joint estimation of mean and variance functions 
%'  with support [0, 1].
%'                     Constraints: nonnegative variance
%' @param f_fd 		function handle for f(x); requires Ramsey's fdaM toolbox
%' @param g_fd 		function handle for g(x); requires Ramsey's fdaM toolbox
%' @param datax 	vector of predictors to fit the model
%' @param datay 	vector of responses to fit the model
%' @param lam 		regularization parameter for smoothing
%' @param sub 		no. of subdivisions of the [0,1] interval
%' @param B		no. of bootstrap samples
%' @return
%'  f_confint = 95% pointwise confidence interval (100 pts) for f(x)
%'  g_confint = 95% pointwise confidence interval (100 pts) for g(x)
%'  f_std = pointwise standard error (100 pts) for f(x)
%'  g_std = pointwise standard error (100 pts) for g(x)
function [f_boot, g_boot, mean_boot, var_boot] = joint_Bernstein_boot(f_fd,g_fd,datax,datay,lam,sub,B)

no_of_pts = length(datax);
num_eval_pts = 100;

% standardized residual
f_eval = eval_fd(datax,f_fd);
g_eval = eval_fd(datax,g_fd);
resid = datay.*g_eval - f_eval;
x_eval = linspace(0,1,num_eval_pts);
f_boot = [];
g_boot = [];
mean_boot = [];
var_boot = [];
fprintf(1,'bootstrap sample (of %d):',B);
for b=1:B,
    resid_b = datasample(resid,no_of_pts,'Replace',true);
    datay_b = (f_eval+resid_b)./g_eval;
    num_sample = 0;
    [f_fd,g_fd,q,p,optval]=joint_Bernstein(datax,datay_b,lam,sub,false);
    if ( isnan(optval) ) continue; end
    fval = eval_fd(x_eval,f_fd);
    gval = eval_fd(x_eval,g_fd);
    f_boot = [f_boot, fval];
    g_boot = [g_boot, gval];
    mean_boot = [mean_boot, fval./gval];
    var_boot = [var_boot, 1./gval.^2];
    fprintf(1,'  %d',b);
end
fprintf(1,'\n');
