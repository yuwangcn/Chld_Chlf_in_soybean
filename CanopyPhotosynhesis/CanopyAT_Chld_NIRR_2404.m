clear all;
STdata1=importdata('CanopyAT_Chld_NIRR.txt');
[SimLightDataRow,SimLightDataCol]=size(STdata1);
Ai=zeros(SimLightDataRow,13);
Ai1=zeros(SimLightDataRow,13);

Pi=zeros(SimLightDataRow,13);
Pi1=zeros(SimLightDataRow,13);

Loi=zeros(SimLightDataRow,13);
Loi1=zeros(SimLightDataRow,13);



LAIi=0;
for j=1:13
    j
for i=1:SimLightDataRow
    if STdata1(i,11)~=-10
    if STdata1(i,1)>=20&&STdata1(i,1)<70&&STdata1(i,2)>=19&&STdata1(i,2)<95
        Ai(i,j)=STdata1(i,10)*STdata1(i,(j-1)*4+11+1);
        Ai1(i,j)=STdata1(i,10)*STdata1(i,(j-1)*4+11+3);

        Pi(i,j)=STdata1(i,10)*STdata1(i,(j-1)*4+11+2);
        Pi1(i,j)=STdata1(i,10)*STdata1(i,(j-1)*4+11+4);


        
        if STdata1(i,(j-1)*4+11+2)>1500
            Loi(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*4+11+4)>1500
            Loi1(i,j)=STdata1(i,10);
        end 

          
        if j==1
        LAIi=LAIi+ STdata1(i,10);
        end
    end
    end
end
end
SumA=sum(Ai)/10000/0.5/0.76;
SumA1=sum(Ai1)/10000/0.5/0.76;


SumP=sum(Pi)/10000/0.5/0.76;
SumP1=sum(Pi1)/10000/0.5/0.76;


SumLo=sum(Loi)/10000/0.5/0.76;
SumLo1=sum(Loi1)/10000/0.5/0.76;

LAI=LAIi/10000/0.5/0.76

OutPutA=[SumA',SumA1'];
OutPutP=[SumP',SumP1'];
OutPutLo=[SumLo',SumLo1'];

dlmwrite('CanopyAT_Chld_NIRR_outA.txt',OutPutA,'delimiter','\t','precision',5);
dlmwrite('CanopyAT_Chld_NIRR_outPAR.txt',OutPutP,'delimiter','\t','precision',5);

SimLightData=STdata1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fig 3d %noon AbsNIR=k*RatioNIR/R
for j=1:13
    j

        TAi(:,j)=STdata1(:,(j-1)*4+11+1);
        TAi1(:,j)=STdata1(:,(j-1)*4+11+3);
        
        TPi(:,j)=STdata1(:,(j-1)*4+11+2);
        TPi1(:,j)=STdata1(:,(j-1)*4+11+4);

end


dA=TAi1(:,7)-TAi(:,7);  %noon
for i=1:SimLightDataRow %%Remove several individual maxima and minima from the plot, to keep color differentiation shows major photosynthetic changes
    if dA(i)>3 
        dA(i)=3;
    end
    if dA(i)<0
        dA(i)=0;
    end
end

va1=linspace(1,SimLightDataRow,SimLightDataRow);
va2=linspace(1+SimLightDataRow,2*SimLightDataRow,SimLightDataRow);
va3=linspace(1+2*SimLightDataRow,3*SimLightDataRow,SimLightDataRow);
va1=va1';
va2=va2';
va3=va3';
va=[va1 va2 va3];

figure;
trisurf(va,SimLightData(:,[1,4,7]),SimLightData(:,[2,5,8]),SimLightData(:,[3,6,9]),dA,'FaceAlpha',0.7,'LineStyle','none','LineWidth',0.5);

axis equal;
%set(gcf,'visible','off'); %
zlim([0,100]);
ylim([-76,304]);
xlim([-15,75]);
set(gca,'ZTick',[0:50:100]);
set(gca,'YTick',[-50:50:300]);
set(gca,'XTick',[-20:20:90]);
colormap(slanCM('rainbow-kov'))

view(60,20);
axis off;
width=1200;%
height=900;%
left=500;%
bottem=10;%
set(gcf,'position',[left,bottem,width,height])
nai='Soy_Chld_AbsNIRR_dA1_T';
a=12;
nbi=num2str(a);
ni=[nai,nbi];
ni2=[nai,nbi,'tiff'];
print(ni, '-dtiff','-r600') ;