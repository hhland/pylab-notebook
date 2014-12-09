function [k,p,abso,P]=fixedpoint(g,p0,tol,maxi)

P(1)=p0;

for k=2:maxi
	P(k)=feval(g,P(k-1));
	abso=abs(P(k)-P(k-1));
	relat=abso/(abs(P(k))+eps);
	p=P(k);
	if (abso<tol)|(relat<tol) , break ;end
end

if k==maxi
	disp("maximum number of iter exceeded")
end

P=P';