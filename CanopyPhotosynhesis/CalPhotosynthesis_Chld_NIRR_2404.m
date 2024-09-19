clear all;

WeatherRH=0.6;
WeatherTemperature=25;
WeatherWind=1;
Air_CO2=400;
Radiation_NIR=0;
Radiation_LW=0;
Vcmax25=100;
Jmax25=180;
CumLAI=0;
Convert=1E6/(2.35E5); %Convert W m^{-2} to u moles m^{-2} s^{-1}

fB=0.266;
fG=0.350;
fR=0.381;
fF1=0.183;
fF2=0.357;
STdata1=importdata('PPFD_V231_R.txt');
CasSTdata1=STdata1.data;
SimLightData=[CasSTdata1(:,6:14),CasSTdata1(:,18),CasSTdata1(:,1)];
[SimLightDataRow,SimLightDataCol]=size(CasSTdata1);
STdata2=importdata('PPFD_V231_G.txt');
CasSTdata2=STdata2.data;
STdata3=importdata('PPFD_V231_B.txt');
CasSTdata3=STdata3.data;
STdata4=importdata('PPFD_V231_NIRR.txt');
CasSTdata4=STdata4.data;




for i=1:13
 PPFD_R0(:,i)= CasSTdata1(:,18+(i)*7)*fR;
 PPFD_G(:,i)= CasSTdata2(:,18+(i)*7)*fG;
 PPFD_B(:,i)= CasSTdata3(:,18+(i)*7)*fB;
 PPFD_F1(:,i)= CasSTdata4(:,18+(i)*7)*fF1;

end

PPFD=PPFD_G+PPFD_B+PPFD_R0;
PPFD_C0=PPFD_G+PPFD_B+PPFD_R0;
PPFD_C1=PPFD_G+PPFD_B+PPFD_F1+PPFD_R0;


for j=1:13
    j
for i=1:SimLightDataRow
       Aleaf=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD(i,j)/Convert,Radiation_NIR,Radiation_LW,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC1=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C1(i,j)/Convert,Radiation_NIR,Radiation_LW,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model

       A_profile(i,(j-1)*4+1) = Aleaf(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*4+2) = PPFD(i,j);
       A_profile(i,(j-1)*4+3) = AleafC1(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*4+4) = PPFD_C1(i,j);
end
end
Aoutput=[SimLightData,A_profile];
dlmwrite('CanopyAT_Chld_NIRR.txt',Aoutput,'delimiter','\t','precision',5);
% % % j=7;
% % % k=(j-1)*14;
% % % % % 
% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % STdata1=importdata('CanopyA.txt');
% % % % % % STdata2=importdata('CanopyAR.txt');
% % % % % % [SimLightDataRow,SimLightDataCol]=size(STdata1);
% % % % % 
% % % for i=1:SimLightDataRow
% % %     A_ratio1(i,1)=A_profile(i,k+3)-A_profile(i,k+1);
% % %     A_ratio2(i,1)=A_profile(i,k+5)-A_profile(i,k+1);
% % % 
% % %     if A_ratio1(i,1)>3
% % %         A_ratio1(i,1)=3;
% % %     end
% % %     if A_ratio2(i,1)>3
% % %         A_ratio2(i,1)=3;
% % %     end
% % %     
% % %     
% % % end
% % % 
% % % % SimLightData=[STdata1(:,6:14),STdata1(:,18)];
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % % 
% % % va1=linspace(1,SimLightDataRow,SimLightDataRow);
% % % va2=linspace(1+SimLightDataRow,2*SimLightDataRow,SimLightDataRow);
% % % va3=linspace(1+2*SimLightDataRow,3*SimLightDataRow,SimLightDataRow);
% % % va1=va1';
% % % va2=va2';
% % % va3=va3';
% % % va=[va1 va2 va3];
% % % 
% % % figure;
% % % %trisurf(va,SimLightData(:,[1,4,7]),SimLightData(:,[2,5,8]),SimLightData(:,[3,6,9]),log10(PPFD_F1(:,i)),'FaceAlpha',0.7,'LineStyle','none','LineWidth',0.5);
% % % %trisurf(va,SimLightData(:,[1,4,7]),SimLightData(:,[2,5,8]),SimLightData(:,[3,6,9]),A_profile(:,1),'FaceAlpha',0.7,'LineStyle','none','LineWidth',0.5);
% % % trisurf(va,SimLightData(:,[1,4,7]),SimLightData(:,[2,5,8]),SimLightData(:,[3,6,9]),A_ratio2(:,1),'FaceAlpha',0.7,'LineStyle','none','LineWidth',0.5);
% % % 
% % % axis equal;
% % % %set(gcf,'visible','off'); %获得当前图形句柄
% % % zlim([0,100]);
% % % % ylim([-60,180]);
% % % % xlim([-20,90]);
% % % ylim([-76,304]);
% % % xlim([-15,75]);
% % % set(gca,'ZTick',[0:50:100]);
% % % set(gca,'YTick',[-50:50:300]);
% % % set(gca,'XTick',[-20:20:90]);
% % % % colorbar; 
% % % % colorbar('Ticks',[0,log(10),log(100),log(1000)]);
% % % %colormap jet;
% % % % % % load('mycolor');
% % % % % % colormap(mycolor);
% % % 
% % % colormap(slanCM('rainbow-kov'))
% % % %set(gcf,'Colormap',mycolormap)
% % % view(60,20);
% % % %saveas(gcf,'Y6T00.fig');
% % % axis off;
% % % width=1200;%宽度，像素数
% % % height=900;%高度
% % % left=500;%距屏幕左下角水平距离
% % % bottem=10;%距屏幕左下角垂直距离
% % % set(gcf,'position',[left,bottem,width,height])
% % % nai='SoySpc_ARatio1_F5T';
% % % a=i+6;
% % % nbi=num2str(a);
% % % ni=[nai,nbi];
% % % ni2=[nai,nbi,'tiff'];
% % % % title(ni);
% % % % saveas(gcf,ni,'tiff');
% % % print(ni, '-dtiff','-r600') ;