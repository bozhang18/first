
clear;clear all;clc;close all;
%���ȶ���ز��������ʼֵ��
ystar=1500;
UB=inf;
LB=-1e23;    %�����½縳���ʼֵ��
%Ԥ����ز���������ֵ��
c=(1.01:0.01:1.10)';
f=1.045;
A=[ones(1,10);diag(ones(1,10))];
B=[1 zeros(1,10)]';
b=[1000;repmat(100,10,1)];
%��ʼ�����������������ĳ�ʼģ�͡�
% % x=sdpvar(10,1);
% y=intvar(1,1);
% z=sdpvar(1,1);
% u=sdpvar(size(A,1),1);
%��ʼ�ֱ��������ģ����ص�Ŀ�꺯����Լ����
% majorobj=z;
% subobj=(b-B*ystar)'*u;
% %����������Ӧ��Լ��������
% majorconst=[];
% majorconst=[majorconst,y>=0];  %�����������ĳ�ʼԼ����
% subconst=[A'*u>=c,u>=0];
% options=sdpsettings('solver','cplex','verbose',0);
%��������Ӧ�Ĳ������ã���ʼ����������ı���
%��ʼ������ı���
%�����������½��gapƫ�
epsilon=0.1;
feasibility_cut=[];
optimality_cut=[];
while  UB-LB>epsilon
%����������Ӧ��Լ��������
% options=sdpsettings('solver','cplex','verbose',0);
% [subconst,subobj]=subest(A,c,b,B,ystar);
       %����ż������õ���Ӧ��ż������ֵ
       [ustar,substatus]=solsub(A,b,B,c,ystar);
       %������ж��������
       if  substatus == 2        %������������ʶ�ж�������������0��ʾ������Ž⣬1��ʾ�޿��н⣬2��ʾ���޽硣
           feasibility_cut=[feasibility_cut;ustar'];
       elseif substatus == 0   %�ж������ż������������Ž�
%            ustar=value(u); %��ȡ��ż��������ֵ��
           %���ȸ������������ṩ���½硣
           LB=max(LB,f*ystar+(b-B.*ystar)'*ustar);
           %������������������Ը�
           optimality_cut=[optimality_cut;ustar'];
       else
           disp('Something wrong happened');
           return;
       end
       %���������
       [ystar,UB]=solmas(f,b,B,feasibility_cut,optimality_cut);
        
       display(ystar);
%        if majorresult.problem == 2  
%            UB=inf;   %�������������Ž�ystar�Լ��Ͻ硣
%             ystar=randi([0 1000],1);
%        else
%             ystar=value(y);
%             UB=value(majorobj);  
%        end
end


