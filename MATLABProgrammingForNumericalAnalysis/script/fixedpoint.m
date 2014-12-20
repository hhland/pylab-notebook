function [k,p,abso,P]=fixedpoint(g,p0,toler,maxter)

P(1)=p0;

for k=2:maxter
	P(k)=feval(g,P(k-1));
	abso=abs(P(k)-P(k-1));
	relat=abso/(abs(P(k))+eps);
	p=P(k);
	if(abso<toler)|(relat<toler),break;end

end

if k==maxter
	disp("maximum number of iteratoins excessed")
end

P=P';