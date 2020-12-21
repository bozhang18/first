function [ystar,UB]=solmas(f,b,B,feasibility_cut,optimality_cut)
y=intvar(1,1,'full');
z=sdpvar(1,1,'full');
majorconst=[];
majorconst=[majorconst,y>=0,z<=1e21];  %设置主函数的初始约束。
%添加相应的可行性割和不可行性割
for i=1:1:size(feasibility_cut,1)
    majorconst=[majorconst,(b-B.*y)'*(feasibility_cut(i,:))'>=0];
end
for j=1:1:size(optimality_cut,1)
    majorconst=[majorconst,f*y+(b-B*y)'*(optimality_cut(j,:))'>=z]; 
end
options=sdpsettings('solver','gurobi','verbos',2);
 majorresult=optimize(majorconst,-z,options);
 ystar=value(y);
 UB=value(z);