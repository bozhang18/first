function [ustar,substatus]=solsub(A,b,B,c,ystar)
u=sdpvar(size(A,1),1,'full');
subobj=(b-B*ystar)'*u;
subconst=[A'*u>=c,u>=0];
options=sdpsettings('solver','cplex','verbos',2);
subduresult=optimize(subconst,subobj,options);
display(subduresult);
ustar=value(u); 
display(value(subobj));
substatus=subduresult.problem;
%直接求解原问题的版本
% x=sdpvar(10,1);
% subobj=c'*x;
% subconst=[];
% subconst=[subconst,  A*x+B*ystar<=b];
% subconst=[subconst,  x>=0];
% options=sdpsettings('solver','gurobi','verbos',2);
% subduresult=optimize(subconst,subobj,options);
% % options.gurobi= gurobioptimset('cplex'); 
% options.gurobi.InfUnbdInfo =1; 
% ustar=dual(subconst(1));
% substatus=subduresult.problem;