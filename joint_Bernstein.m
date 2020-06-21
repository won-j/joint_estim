%' Joint estimation of mean and variance functions with support [0, 1].
%'                     Constraints: nonnegative variance
%' @param datax 	vector of predictors to fit the model
%' @param datay 	vector of responses to fit the model
%' @param lam 		regularization parameter for smoothing
%' @param sub 		no. of subdivisions of the [0,1] interval
%' @return
%'  f_fd = function handle for f(x); requires Ramsey's fdaM toolbox
%'  g_fd = function handle for g(x); requires Ramsey's fdaM toolbox
%'  q = length(datax)+deg+1 vector of spline coefficients. deg=3.
%'  p = sub-by-(deg+1) array of spline coefficients. deg=3.
function [f_fd, g_fd, q, p, cvx_optval] = joint_Bernstein(datax,datay,lam,sub,verbose)

if nargin==4, verbose = true; end

deg = 3;					% cubic spline
patches = (1:sub);				% assume uniformly subdivided [0,1] interval

no_of_pts = length(datax);

%%% Smoothing spline for mean-over-std function f.
%%% construct natural B-spline basis matrix and penaly matrix
%%% Requires Ramsey's fdaM toolbox
%%% Boundary condition (stright line) should be 
%%%  separately set as constraints
nbasis = no_of_pts + deg+1;
% datax is a column vector of internal knots
knots = [0; sort(datax); 1];
smbasis = create_bspline_basis([0,1],nbasis,deg+1,knots);
% basis matrix: no_of_pts-by-nbasis sparse
A = eval_basis(knots(2:end-1), smbasis); 
% roughness penalty matrix: nbasis-by-nbasis
Omega = eval_penalty(smbasis, int2Lfd(2) ); % penalize second deriv 2-norm
% 2nd-order derivatives of A: required for boundary condition
A2 = eval_basis(knots, smbasis, int2Lfd(2) );


%%% construct design matrix for inverse standard deviation function g
Ccell = {};
nsub = [];
for i=1:sub,
	ki = (sub*datax >= i-1) & (sub*datax < i);
	cursub = sum(ki);
	nsub = [ nsub cursub ];
	Ccell{i} = zeros(0,deg+1);
	if ( cursub > 0 ),
		Ccell{i} = [ ones(cursub,1), bsxfun(@power, sub*datax(ki)-(i-1), 1:deg ) ];
	end
end
% no_of_pts-by-4*sub block diagonal. to multiply with vec(p');
C = sparse(blkdiag(Ccell{:}));	
B = bsxfun(@times, datay, C); % diag(datay)*C
	
if (verbose)
    cvx_begin
else
    cvx_begin quiet
end
	%%% COEFFICIENTS OF NATURAL B-SPLINE
	variable q(nbasis);
	%%% COEFFICIENTS OF POLYNOMIAL SPLINE
	variable p(sub,deg+1);

	%%% parameters for Bernstein polynomial representation of g
	%%% p(1)+p(2)*x+p(3)*x^2+p(4)*x^3
	%%%  == a*B0(x)+b*B1(x)+c*B2(x)+d*B3(x),
	%%% where Bi(x) = binom(3,i)*x^i*(1-x)^(3-i).
	variable a(sub); 	
	variable b(sub);
	variable c(sub);
	variable d(sub);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%% nonnegativity constraint for Bernstein representation
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  	a >= 0;
  	b >= 0;
	c >= 0;
	d >= 0;
	%%%%%% END OF NONNEGATIVITY

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%% equivalence of Bernstein and monomial representations
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	p(:,1) == a;
	p(:,2) == -3*a + 3*b;
	p(:,3) == 3*a - 6*b + 3*c;
	p(:,4) == -a + 3*b - 3*c + d;
	%%%%%% END OF EQUIVALENCE

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%% NATURAL CUBIC SPLINE CONSTRAINTS
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	dot(q,A2(1,:)) == 0;  % zero 2nd deriv at 0
	dot(q,A2(2,:)) == 0;  % zero 2nd deriv at first knot
	dot(q,A2(end-1,:)) == 0;  % zero 2nd deriv at last knot
	dot(q,A2(end,:)) == 0;  % zero 2nd deriv at 1
	%%%%%% END OF NATURAL SPLINE


	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% CUBIC SPLINE CONSTRAINTS
	%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% continuity
	for i=1:(sub-1), p(i+1,1) == sum(p(i,:)); end;
	% p(2:sub,1) == sum(p(1:(sub-1),:),2);

	% continuous first derivative
	for i=1:(sub-1), p(i+1,2) == sum( (1:deg).*p(i,2:(deg+1)) ); end;
	% p(2:sub,2) == sum( bsxfun(@times, 1:deg, p(1:(sub-1),2:(deg+1)) ), 2 );

	% continuous second derivative
	for i=1:(sub-1), p(i+1,3) == p(i,3) + 3*p(i,4); end;
	% 2*p(2:sub,3) == sum(bsxfun(@times, (2:deg).*(1:deg-1), p(1:(sub-1),3:(deg+1)) ), 2);

	%%%%%%% END OF CUBIC SPLINE

	%%% OBJECTIVE
	%maximize (log_likelihood(p,deg,no_of_pts,datax,sub,cvset));		% defined below
	%maximize (log_likelihood2(p,C,nsub));		% defined below
	minimize ( 0.5*sum_square(A*q-B*vec(p'))+lam*quad_form(q,Omega)-sum(log(C*vec(p') ) ) );

cvx_end

%%% construct fd object for f from coefficent vector anb basis matrix
f_fd = fd(q, smbasis);

%%% convert  polynomial spline to B-spline
cbasis = create_bspline_basis([0,1],sub-1+deg+1,deg+1);
BSmat = eval_basis(datax,cbasis);
v=C*vec(p');
betcoef = BSmat\v;  % exact solution, not least squares approximation
%%% construct fd object for g from coefficent vector anb basis matrix
g_fd = fd(betcoef,cbasis);

end
% end of function

function lik = log_likelihood2(p,X,nsub)
	tol = 1e-5;
	likvec = X*vec(p');
	lik = sum(log(likvec+tol));
end
% end of function


% END OF FILE.
