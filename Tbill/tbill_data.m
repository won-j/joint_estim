%%% 3-month Treasury Bill yields

Z = load('w-gs1yr.txt');
z = Z(:,2); 
z = z(1:1735); % from Jan-05-1962 to Mar-31-1995 (cf. Fan and Yao)
%no_of_pts = size(x,1)-1;

%y = diff(x);

% Following Fan and Yao, fit an AR(5) model and use the residual
yy=z(6:end);
X=[z(5:end-1), z(4:end-2), z(3:end-3), z(2:end-4), z(1:end-5) ];
b = regress(yy,X); % AR coefficients
y = yy-X*b;
x = z(5:end-1);
no_of_pts = size(x,1);

deg = 3;

% select unique values of x for knots
% and normalize range
[sx, sidx] = sort(x(1:no_of_pts));
diffsx = diff(sx);
uniqidx = ~(diffsx < 1e-4);
mindiff = min(diffsx(uniqidx));
xmin = sx(1)-mindiff;
xmax = sx(end)+mindiff;
datax = (sx([true; uniqidx])-xmin)/(xmax-xmin);

% averge out y values for duplicated knots
% normalize range of y
sy = y(sidx);
yavgvec = [];
yavg = sy(1);
runlength=1;
for i=1:length(uniqidx),
    if ( uniqidx(i)==true )
	yavgvec = [yavgvec; yavg];
	yavg = sy(i+1);
	runlength = 1;
    else
	yavg = yavg + (sy(i+1)-yavg)/(runlength+1);
	runlength = runlength + 1;
    end
end
yavgvec = [yavgvec; yavg]; % final wrapup
%datay = yavgvec/(xmax-xmin);
datay = yavgvec;

save('tbill_data.mat', 'datax','datay','xmin','xmax','b');

