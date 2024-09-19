clear all;
STdata1=importdata('CanopyAT_Chlf.txt');
[SimLightDataRow,SimLightDataCol]=size(STdata1);
Ai=zeros(SimLightDataRow,13);
Ai1=zeros(SimLightDataRow,13);
Ai2=zeros(SimLightDataRow,13);
Ai3=zeros(SimLightDataRow,13);
Ai4=zeros(SimLightDataRow,13);


Pi=zeros(SimLightDataRow,13);
Pi1=zeros(SimLightDataRow,13);
Pi2=zeros(SimLightDataRow,13);
Pi3=zeros(SimLightDataRow,13);
Pi4=zeros(SimLightDataRow,13);



Loi=zeros(SimLightDataRow,13);
Loi1=zeros(SimLightDataRow,13);
Loi2=zeros(SimLightDataRow,13);
Loi3=zeros(SimLightDataRow,13);
Loi4=zeros(SimLightDataRow,13);



LAIi=0;
for j=1:13
    j
for i=1:SimLightDataRow
    if STdata1(i,11)~=-10
    if STdata1(i,1)>=20&&STdata1(i,1)<70&&STdata1(i,2)>=19&&STdata1(i,2)<95
        Ai(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+1);
        Ai1(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+3);
        Ai2(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+5);
        Ai3(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+7);    
        Ai4(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+9);

        Pi(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+2);
        Pi1(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+4);
        Pi2(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+6);
        Pi3(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+8);
        Pi4(i,j)=STdata1(i,10)*STdata1(i,(j-1)*10+11+10);


        
        if STdata1(i,(j-1)*10+11+2)>1500
            Loi(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*10+11+4)>1500
            Loi1(i,j)=STdata1(i,10);
        end 
        
        if STdata1(i,(j-1)*10+11+6)>1500
            Loi2(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*10+11+8)>1500
            Loi3(i,j)=STdata1(i,10);
        end 
        if STdata1(i,(j-1)*10+11+10)>1500
            Loi4(i,j)=STdata1(i,10);
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
SumA2=sum(Ai2)/10000/0.5/0.76;
SumA3=sum(Ai3)/10000/0.5/0.76;
SumA4=sum(Ai4)/10000/0.5/0.76;



SumP=sum(Pi)/10000/0.5/0.76;
SumP1=sum(Pi1)/10000/0.5/0.76;
SumP2=sum(Pi2)/10000/0.5/0.76;
SumP3=sum(Pi3)/10000/0.5/0.76;
SumP4=sum(Pi4)/10000/0.5/0.76;


SumLo=sum(Loi)/10000/0.5/0.76;
SumLo1=sum(Loi1)/10000/0.5/0.76;
SumLo2=sum(Loi2)/10000/0.5/0.76;
SumLo3=sum(Loi3)/10000/0.5/0.76;
SumLo4=sum(Loi4)/10000/0.5/0.76;


LAI=LAIi/10000/0.5/0.76

OutPutA=[SumA',SumA1',SumA2',SumA3',SumA4'];
OutPutP=[SumP',SumP1',SumP2',SumP3',SumP4'];
OutPutLo=[SumLo',SumLo1',SumLo2',SumLo3',SumLo4'];

dlmwrite('CanopyAT_Chlf_outA.txt',OutPutA,'delimiter','\t','precision',5);
dlmwrite('CanopyAT_Chlf_outPAR.txt',OutPutP,'delimiter','\t','precision',5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fig 4d %noon AbsNIR=k*RatioNIR/R

SimLightData=STdata1;

for j=1:13
    j

        TAi(:,j)=STdata1(:,(j-1)*10+11+1);
        TAi1(:,j)=STdata1(:,(j-1)*10+11+5);
        TAi2(:,j)=STdata1(:,(j-1)*10+11+9);
        
        TPi(:,j)=STdata1(:,(j-1)*10+11+2);
        TPi1(:,j)=STdata1(:,(j-1)*10+11+6);
        TPi2(:,j)=STdata1(:,(j-1)*10+11+10);
    end

% dP=TPi2(:,7)-TPi(:,7);
% for i=1:SimLightDataRow
%     if dP(i)>150
%         dP(i)=150;
%     end
%     if dP(i)<-100
%         dP(i)=-100;
%     end
% end

dA=TAi1(:,7)-TAi(:,7); %noon %% Fig 4d
%dA=TAi2(:,7)-TAi(:,7); %noon %% Fig 4c
for i=1:SimLightDataRow %Remove several individual maxima and minima from the plot, to keep color differentiation shows major photosynthetic changes
    if dA(i)>4
        dA(i)=4;
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
%set(gcf,'visible','off'); 
zlim([0,100]);
% ylim([-60,180]);
% xlim([-20,90]);
ylim([-76,304]);
xlim([-15,75]);
set(gca,'ZTick',[0:50:100]);
set(gca,'YTick',[-50:50:300]);
set(gca,'XTick',[-20:20:90]);
% colorbar; 
% colorbar('Ticks',[0,log(10),log(100),log(1000)]);
%colormap parula;
% load('mycolor');
% colormap(mycolor);
%set(gcf,'Colormap',mycolormap)
colormap(slanCM('rainbow-kov'))

view(60,20);
%saveas(gcf,'Y6T00.fig');
axis off;
width=1200;%
height=900;%
left=500;%
bottem=10;%
set(gcf,'position',[left,bottem,width,height])
nai='Soy_Chlf_NIRR_dA1_T';
a=12;
nbi=num2str(a);
ni=[nai,nbi];
ni2=[nai,nbi,'tiff'];
% title(ni);
% saveas(gcf,ni,'tiff');
print(ni, '-dtiff','-r600') ;