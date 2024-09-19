clear all;
STdata1=importdata('CanopyAT_Chld_Abscon.txt');
[SimLightDataRow,SimLightDataCol]=size(STdata1);
Ai=zeros(SimLightDataRow,13);
Ai1=zeros(SimLightDataRow,13);
Ai2=zeros(SimLightDataRow,13);
Ai3=zeros(SimLightDataRow,13);
Ai4=zeros(SimLightDataRow,13);
Ai5=zeros(SimLightDataRow,13);
Ai6=zeros(SimLightDataRow,13);
Ai7=zeros(SimLightDataRow,13);
Ai8=zeros(SimLightDataRow,13);

Pi=zeros(SimLightDataRow,13);
Pi1=zeros(SimLightDataRow,13);
Pi2=zeros(SimLightDataRow,13);
Pi3=zeros(SimLightDataRow,13);
Pi4=zeros(SimLightDataRow,13);
Pi5=zeros(SimLightDataRow,13);
Pi6=zeros(SimLightDataRow,13);
Pi7=zeros(SimLightDataRow,13);
Pi8=zeros(SimLightDataRow,13);



Loi=zeros(SimLightDataRow,13);
Loi1=zeros(SimLightDataRow,13);
Loi2=zeros(SimLightDataRow,13);
Loi3=zeros(SimLightDataRow,13);
Loi4=zeros(SimLightDataRow,13);
Loi5=zeros(SimLightDataRow,13);
Loi6=zeros(SimLightDataRow,13);
Loi7=zeros(SimLightDataRow,13);
Loi8=zeros(SimLightDataRow,13);


LAIi=0;
for j=1:13
    j
for i=1:SimLightDataRow
    if STdata1(i,11)~=-10
    if STdata1(i,1)>=20&&STdata1(i,1)<70&&STdata1(i,2)>=19&&STdata1(i,2)<95
        Ai(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+1);
        Ai1(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+5);
        Ai2(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+7);
        Ai3(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+9);    
        Ai4(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+11);
        Ai5(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+13);
        Ai6(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+15);
        Ai7(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+17);
        Ai8(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+19);
        
        Pi(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+2);
        Pi1(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+6);
        Pi2(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+8);
        Pi3(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+10);
        Pi4(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+12);
        Pi5(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+14);
        Pi6(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+16);
        Pi7(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+18);
        Pi8(i,j)=STdata1(i,10)*STdata1(i,(j-1)*20+11+20);


        
        if STdata1(i,(j-1)*20+11+2)>1500
            Loi(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*20+11+6)>1500
            Loi1(i,j)=STdata1(i,10);
        end 
        
        if STdata1(i,(j-1)*20+11+8)>1500
            Loi2(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*20+11+10)>1500
            Loi3(i,j)=STdata1(i,10);
        end 
        if STdata1(i,(j-1)*20+11+12)>1500
            Loi4(i,j)=STdata1(i,10);
        end 
        if STdata1(i,(j-1)*20+11+14)>1500
            Loi5(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*20+11+16)>1500
            Loi6(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*20+11+18)>1500
            Loi7(i,j)=STdata1(i,10);
        end
        if STdata1(i,(j-1)*20+11+20)>1500
            Loi8(i,j)=STdata1(i,10);
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
SumA5=sum(Ai5)/10000/0.5/0.76;
SumA6=sum(Ai6)/10000/0.5/0.76;
SumA7=sum(Ai7)/10000/0.5/0.76;
SumA8=sum(Ai8)/10000/0.5/0.76;


SumP=sum(Pi)/10000/0.5/0.76;
SumP1=sum(Pi1)/10000/0.5/0.76;
SumP2=sum(Pi2)/10000/0.5/0.76;
SumP3=sum(Pi3)/10000/0.5/0.76;
SumP4=sum(Pi4)/10000/0.5/0.76;
SumP5=sum(Pi5)/10000/0.5/0.76;
SumP6=sum(Pi6)/10000/0.5/0.76;
SumP7=sum(Pi7)/10000/0.5/0.76;
SumP8=sum(Pi8)/10000/0.5/0.76;

SumLo=sum(Loi)/10000/0.5/0.76;
SumLo1=sum(Loi1)/10000/0.5/0.76;
SumLo2=sum(Loi2)/10000/0.5/0.76;
SumLo3=sum(Loi3)/10000/0.5/0.76;
SumLo4=sum(Loi4)/10000/0.5/0.76;
SumLo5=sum(Loi5)/10000/0.5/0.76;
SumLo6=sum(Loi6)/10000/0.5/0.76;
SumLo7=sum(Loi7)/10000/0.5/0.76;
SumLo8=sum(Loi8)/10000/0.5/0.76;

LAI=LAIi/10000/0.5/0.76

OutPutA=[SumA',SumA1',SumA2',SumA3',SumA4',SumA5',SumA6',SumA7',SumA8'];
OutPutP=[SumP',SumP1',SumP2',SumP3',SumP4',SumP5',SumP6',SumP7',SumP8'];
OutPutLo=[SumLo',SumLo1',SumLo2',SumLo3',SumLo4',SumLo5',SumLo6',SumLo7',SumLo8'];

dlmwrite('CanopyAT_Chld_con_outA.txt',OutPutA,'delimiter','\t','precision',5);
dlmwrite('CanopyAT_Chld_con_outPAR.txt',OutPutP,'delimiter','\t','precision',5);

SimLightData=STdata1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fig 3c %noon AbsNIR=0.3
for j=1:13
    j

        TAi(:,j)=STdata1(:,(j-1)*20+11+1);
        TAi1(:,j)=STdata1(:,(j-1)*20+11+9);

        TPi(:,j)=STdata1(:,(j-1)*20+11+2);
        TPi1(:,j)=STdata1(:,(j-1)*20+11+10);
    end


dA=TAi1(:,7)-TAi(:,7); %noon AbsNIR=0.3
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
% ylim([-60,180]);
% xlim([-20,90]);
ylim([-76,304]);
xlim([-15,75]);
set(gca,'ZTick',[0:50:100]);
set(gca,'YTick',[-50:50:300]);
set(gca,'XTick',[-20:20:90]);

% colormap parula;
% load('mycolor');
% colormap(mycolor);
%set(gcf,'Colormap',mycolormap)
colormap(slanCM('rainbow-kov'))

view(60,20);
axis off;
width=1200;%
height=900;%
left=500;%
bottem=10;%
set(gcf,'position',[left,bottem,width,height])
nai='Soy_Chld_Abscon_dA1_T';
a=12;
nbi=num2str(a);
ni=[nai,nbi];
ni2=[nai,nbi,'tiff'];
% title(ni);
% saveas(gcf,ni,'tiff');
print(ni, '-dtiff','-r600') ;