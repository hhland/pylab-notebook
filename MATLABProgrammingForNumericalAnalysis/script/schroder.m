function [res,it]=schroder(func,dfunc,m,x,precis)

it=0;x0=x;
d=feval(func,x0)/feval(dfunc,x0);

while abs(d)>precis
	x1=x0-m*d;
	it=it+1;
	x0=x1;
	d=feval(func,x0)/feval(dfunc,x0);
end;

res=x0;