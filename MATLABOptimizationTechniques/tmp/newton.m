function [res,it]=newton(func,dfunc,x,precis)

	it=0;x0=x;
	d=feval(func,x0)/feval(dfunc,x0)
	while abs(d)>precis
		x1=x0-d;
		it=it+1;
		x0=x1;
		d=feval(func,x0)/feval(dfunc,x0)
	end;
res=x0;

function f=f1(x);
	f=x^2-x-sin(x+0.15);

function d=derf1(x);
	d=2*x-1-cos(x+0.15);