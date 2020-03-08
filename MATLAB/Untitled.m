x1 = [-5:0.5:5];
x2 = [-5:0.5:5];
[xx1,xx2]=meshgrid(x1,x2);

ggg=1+xx1-exp(2*xx2);
u = exp(2*xx2);
v = 1/2+xx1*0;
% quiver(xx1,xx2,u,v)
% hold on
mesh(xx1,xx2,ggg)
xlabel('xx1')
ylabel('xx2')