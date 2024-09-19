% Calculate the light absorption and CO2 uptake rate of each leaf piece
% Chld AbsNIR=constant
clear all;

WeatherRH=0.6;
WeatherTemperature=25;
WeatherWind=1;
Air_CO2=400;
Vcmax25=100;
Jmax25=180;
CumLAI=0;
Convert=1E6/(2.35E5); %Convert W m^{-2} to u moles m^{-2} s^{-1}

fB=0.266;% Blue light % of PAR
fG=0.350;% Green light % of PAR
fR=0.381;% % of PAR
fF1=0.183;% % of PAR
fF2=0.357;% % of PAR
STdata1=importdata('PPFD_V231_R.txt');
CasSTdata1=STdata1.data;
SimLightData=[CasSTdata1(:,6:14),CasSTdata1(:,18),CasSTdata1(:,1)];
[SimLightDataRow,SimLightDataCol]=size(CasSTdata1);
STdata2=importdata('PPFD_V231_G.txt');
CasSTdata2=STdata2.data;
STdata3=importdata('PPFD_V231_B.txt');
CasSTdata3=STdata3.data;
STdata4=importdata('PPFD_V231_F1.txt');
CasSTdata4=STdata4.data;
STdata5=importdata('PPFD_V231_F2.txt');
CasSTdata5=STdata5.data;
STdata6=importdata('PPFD_V231_F3.txt');
CasSTdata6=STdata6.data;
STdata7=importdata('PPFD_V231_F4.txt');
CasSTdata7=STdata7.data;
STdata8=importdata('PPFD_V231_F25.txt');
CasSTdata8=STdata8.data;
STdata9=importdata('PPFD_V231_F35.txt');
CasSTdata9=STdata9.data;
STdata10=importdata('PPFD_V231_F45.txt');
CasSTdata10=STdata10.data;


for i=1:13
 PPFD_R0(:,i)= CasSTdata1(:,18+(i)*7)*fR;
 PPFD_G(:,i)= CasSTdata2(:,18+(i)*7)*fG;
 PPFD_B(:,i)= CasSTdata3(:,18+(i)*7)*fB;
 PPFD_F1(:,i)= CasSTdata4(:,18+(i)*7)*fF1;
 PPFD_F2(:,i)= CasSTdata5(:,18+(i)*7)*fF1;
 PPFD_F3(:,i)= CasSTdata6(:,18+(i)*7)*fF1;
 PPFD_F4(:,i)= CasSTdata7(:,18+(i)*7)*fF1;
 PPFD_F25(:,i)= CasSTdata8(:,18+(i)*7)*fF1;
 PPFD_F35(:,i)= CasSTdata9(:,18+(i)*7)*fF1;
 PPFD_F45(:,i)= CasSTdata10(:,18+(i)*7)*fF1;
 PPFD_F15(:,i)= CasSTdata2(:,18+(i)*7)*fF1;
end

PPFD=PPFD_G+PPFD_B+PPFD_R0;
PPFD_C0=PPFD_G+PPFD_B+PPFD_R0;
PPFD_C1=PPFD_G+PPFD_B+PPFD_F45+PPFD_R0;
PPFD_C2=PPFD_G+PPFD_B+PPFD_F4+PPFD_R0;
PPFD_C3=PPFD_G+PPFD_B+PPFD_F35+PPFD_R0;
PPFD_C4=PPFD_G+PPFD_B+PPFD_F3+PPFD_R0;
PPFD_C5=PPFD_G+PPFD_B+PPFD_F25+PPFD_R0;
PPFD_C6=PPFD_G+PPFD_B+PPFD_F2+PPFD_R0;
PPFD_C7=PPFD_G+PPFD_B+PPFD_F15+PPFD_R0;
PPFD_C8=PPFD_G+PPFD_B+PPFD_F1+PPFD_R0;
for j=1:13
    j
for i=1:SimLightDataRow
       Aleaf=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC0=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C0(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC1=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C1(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC2=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C2(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC3=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C3(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC4=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C4(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC5=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C5(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC6=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C6(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC7=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C7(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC8=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C8(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model

       A_profile(i,(j-1)*20+1) = Aleaf(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+2) = PPFD(i,j);
       A_profile(i,(j-1)*20+3) = AleafC0(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+4) = PPFD_C0(i,j);
       A_profile(i,(j-1)*20+5) = AleafC1(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+6) = PPFD_C1(i,j);
       A_profile(i,(j-1)*20+7) = AleafC2(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+8) = PPFD_C2(i,j);
       A_profile(i,(j-1)*20+9) = AleafC3(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+10) = PPFD_C3(i,j);
       A_profile(i,(j-1)*20+11) = AleafC4(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+12) = PPFD_C4(i,j);
       A_profile(i,(j-1)*20+13) = AleafC5(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+14) = PPFD_C5(i,j);
       A_profile(i,(j-1)*20+15) = AleafC6(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+16) = PPFD_C6(i,j);
       A_profile(i,(j-1)*20+17) = AleafC7(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+18) = PPFD_C7(i,j);
       A_profile(i,(j-1)*20+19) = AleafC8(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*20+20) = PPFD_C8(i,j);
end
end
Aoutput=[SimLightData,A_profile];
dlmwrite('CanopyAT_Chld_Abscon.txt',Aoutput,'delimiter','\t','precision',5);
