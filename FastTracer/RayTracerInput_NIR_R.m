clear all;
STdata1=importdata('V231_rep1.txt');
%CasSTdata1=STdata1.data;
HeightMax=max(STdata1(:,8));
[DataRow,DataCol]=size(STdata1);
for i=1:DataRow
Height=(STdata1(i,8)+STdata1(i,11)+STdata1(i,14))/3;
%Ref0(i,1)=roundn(0.0325*34.511*exp(-0.04*Height),-2);%1
%Ref0(i,1)=roundn(0.022*53.974*exp(-0.048*Height),-2);%1-2
% Ref0(i,1)=roundn(0.034*53.974*exp(-0.048*Height),-2);%1-3
% Ref0(i,1)=roundn(0.0183*64.749*exp(-0.05*Height),-2);%2-2
 Ref0(i,1)=roundn(0.056*20.06*exp(-0.031*Height),-2);%2-3
if Ref0(i)<=0.02
    Ref0(i)=0;
end
if Ref0(i)>0.86
   Ref0(i)=0.86;
end
end
% for i=1:DataRow
% Ref0(i,1)=0.8-roundn(0.028*34.511*exp(-0.04*STdata1(i,8)),-2);
% if Ref0(i)>=0.75
%     Ref0(i)=0.8;
% end
% if Ref0(i)<0
%    Ref0(i)=0;
% end
% end
Ref=(1-Ref0)/2;
Trans=Ref;
Aoutput=[STdata1(:,1:15),Trans,Ref];
dlmwrite('V231_rep1_NIRR.txt',Aoutput,'delimiter','\t');

