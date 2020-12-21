
clear;clear all;clc;close all;
%首先对相关参数赋予初始值。
ystar=1500;
UB=inf;
LB=-1e23;    %对上下界赋予初始值。
%预置相关参数矩阵数值。
c=(1.01:0.01:1.10)';
f=1.045;
A=[ones(1,10);diag(ones(1,10))];
B=[1 zeros(1,10)]';
b=[1000;repmat(100,10,1)];
%开始建立主问题和子问题的初始模型。
% % x=sdpvar(10,1);
% y=intvar(1,1);
% z=sdpvar(1,1);
% u=sdpvar(size(A,1),1);
%开始分别编译两个模型相关的目标函数与约束。
% majorobj=z;
% subobj=(b-B*ystar)'*u;
% %下面设置相应的约束函数。
% majorconst=[];
% majorconst=[majorconst,y>=0];  %设置主函数的初始约束。
% subconst=[A'*u>=c,u>=0];
% options=sdpsettings('solver','cplex','verbose',0);
%设置完相应的参数设置，开始进行主程序的编译
%开始主程序的编译
%首先设置上下界的gap偏差。
epsilon=0.1;
feasibility_cut=[];
optimality_cut=[];
while  UB-LB>epsilon
%下面设置相应的约束函数。
% options=sdpsettings('solver','cplex','verbose',0);
% [subconst,subobj]=subest(A,c,b,B,ystar);
       %求解对偶子问题得到相应对偶变量的值
       [ustar,substatus]=solsub(A,b,B,c,ystar);
       %分情况判断求解的情况
       if  substatus == 2        %跟据求解问题标识判断问题求解情况，0表示求得最优解，1表示无可行解，2表示解无界。
           feasibility_cut=[feasibility_cut;ustar'];
       elseif substatus == 0   %判断如果对偶子问题求得最优解
%            ustar=value(u); %获取对偶变量最优值。
           %首先更新主问题所提供的下界。
           LB=max(LB,f*ystar+(b-B.*ystar)'*ustar);
           %向主问题中添加最优性割
           optimality_cut=[optimality_cut;ustar'];
       else
           disp('Something wrong happened');
           return;
       end
       %求解主问题
       [ystar,UB]=solmas(f,b,B,feasibility_cut,optimality_cut);
        
       display(ystar);
%        if majorresult.problem == 2  
%            UB=inf;   %更新主问题最优解ystar以及上界。
%             ystar=randi([0 1000],1);
%        else
%             ystar=value(y);
%             UB=value(majorobj);  
%        end
end


