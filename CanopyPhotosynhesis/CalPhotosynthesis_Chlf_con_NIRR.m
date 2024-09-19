clear all;

WeatherRH=0.6;
WeatherTemperature=25;
WeatherWind=1;
Air_CO2=400;
Vcmax25=100;
Jmax25=180;
CumLAI=0;
Convert=1E6/(2.35E5); %Convert W m^{-2} to u moles m^{-2} s^{-1}

fB=0.266;
fG=0.350;
fR=0.381;
fF1=0.183;
fF2=0.357;
fF3=0.219;
STdata1=importdata('PPFD_V231_R.txt');
CasSTdata1=STdata1.data;
SimLightData=[CasSTdata1(:,6:14),CasSTdata1(:,18),CasSTdata1(:,1)];
[SimLightDataRow,SimLightDataCol]=size(CasSTdata1);
STdata2=importdata('PPFD_V231_G.txt');
CasSTdata2=STdata2.data;
STdata3=importdata('PPFD_V231_B.txt');
CasSTdata3=STdata3.data;
STdata4=importdata('PPFD_V231_F45.txt');
CasSTdata4=STdata4.data;
STdata6=importdata('PPFD_V231_NIRR.txt');
CasSTdata6=STdata6.data;



for i=1:13
 PPFD_R0(:,i)= CasSTdata1(:,18+(i)*7)*fR;
 PPFD_G(:,i)= CasSTdata2(:,18+(i)*7)*fG;
 PPFD_B(:,i)= CasSTdata3(:,18+(i)*7)*fB;
 PPFD_F1(:,i)= CasSTdata6(:,18+(i)*7)*fF3;
 PPFD_F2(:,i)= CasSTdata6(:,18+(i)*7)*fF2;
 PPFD_F3(:,i)= CasSTdata4(:,18+(i)*7)*fF3;
 PPFD_F4(:,i)= CasSTdata4(:,18+(i)*7)*fF2;

end

PPFD=PPFD_G+PPFD_B+PPFD_R0;
PPFD_C1=PPFD_G+PPFD_B+PPFD_F1+PPFD_R0;
PPFD_C2=PPFD_G+PPFD_B+PPFD_F2+PPFD_R0;
PPFD_C3=PPFD_G+PPFD_B+PPFD_F3+PPFD_R0;
PPFD_C4=PPFD_G+PPFD_B+PPFD_F4+PPFD_R0;

for j=1:13
    j
for i=1:SimLightDataRow
       Aleaf=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC1=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C1(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC2=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C2(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC3=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C3(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model
       AleafC4=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,PPFD_C4(i,j)/Convert,0,0,Vcmax25,Jmax25,CumLAI);%C3assi(layer_sunlit_par);%Photosynthesis model

       A_profile(i,(j-1)*10+1) = Aleaf(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*10+2) = PPFD(i,j);
       A_profile(i,(j-1)*10+3) = AleafC1(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*10+4) = PPFD_C1(i,j);
       A_profile(i,(j-1)*10+5) = AleafC2(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*10+6) = PPFD_C2(i,j);
       A_profile(i,(j-1)*10+7) = AleafC3(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*10+8) = PPFD_C3(i,j);
       A_profile(i,(j-1)*10+9) = AleafC4(2); % // micromole / m^2 / s  
       A_profile(i,(j-1)*10+10) = PPFD_C4(i,j);


end
end
Aoutput=[SimLightData,A_profile];
dlmwrite('CanopyAT_Chlf.txt',Aoutput,'delimiter','\t','precision',5);
