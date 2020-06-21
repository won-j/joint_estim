% leave-one-out cross validation for CIR data

load('tbill_data.mat');

% chosen by cross validation
lam=0.0001;
sub=6;

[f_fd,g_fd,q,p,optval]=joint_Bernstein(datax,datay,lam,sub);
% bootstrap confidence interval
[f_boot, g_boot, mean_boot, var_boot] = joint_Bernstein_boot(f_fd,g_fd,datax,datay,lam,sub,100);
% (2.5, 97.5) percentiles
f_confint = quantile(f_boot,[0.025,0.975],2);
g_confint = quantile(g_boot,[0.025,0.975],2);
mean_confint = quantile(mean_boot,[0.025,0.975],2);
var_confint = quantile(var_boot,[0.025,0.975],2);
% standard deviation
f_std = std(f_boot,0,2);
g_std = std(g_boot,0,2);
mean_std = std(f_boot,0,2);
var_std = std(g_boot,0,2);

xvec=linspace(0,1,100);
f_eval = eval_fd(xvec,f_fd);
g_eval = eval_fd(xvec,g_fd);

save('tbill_joint.mat','f_fd','g_fd','q','p','optval',...
	'f_boot','g_boot','f_confint','g_confint','f_std','g_std',...
	'mean_boot','var_boot','mean_confint','var_confint',...
	'mean_std','var_std', ...
        'xvec','f_eval','f_confint',...
	'g_eval','g_confint', 'mean_confint', 'var_confint' );

