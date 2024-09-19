%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate and plot the FR/R ratio for each leaf piece
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
fF3=0.219;
f667=0.0436;
f730=0.0378;
STdata1=importdata('PPFD_V231_R.txt');
CasSTdata1=STdata1.data;
SimLightData=[CasSTdata1(:,6:14),CasSTdata1(:,18),CasSTdata1(:,1)];
[SimLightDataRow,SimLightDataCol]=size(CasSTdata1);

STdata4=importdata('PPFD_V231_F45.txt');
CasSTdata4=STdata4.data;



for i=1:13
 PPFD_f667(:,i)= CasSTdata1(:,18+(i)*7)*f667;
 PPFD_f667_i(:,i)=PPFD_f667(:,i)/0.84;
 PPFD_f730(:,i)= CasSTdata4(:,18+(i)*7)*f730;
 PPFD_f730_i(:,i)=PPFD_f730(:,i)/0.1;
end
p_profile=[PPFD_f667,PPFD_f730,PPFD_f667_i,PPFD_f730_i];

Pmean_f667=mean(PPFD_f667,2);
Pmean_f667_i=mean(PPFD_f667_i,2);
Pmean_f730=mean(PPFD_f730,2);
Pmean_f730_i=mean(PPFD_f730_i,2);
p_mean=[Pmean_f667,Pmean_f730,Pmean_f667_i,Pmean_f730_i];
Aoutput=[SimLightData,p_mean];
k=1;
for i=1:168766

    if Aoutput(i,11)~=-10&&Aoutput(i,3)>0&&Aoutput(i,6)>0&&Aoutput(i,9)>0&&Aoutput(i,10)>0.1
        Aoutput_clean(k,:)=Aoutput(i,:);
        k=k+1;
    end 
end



height=(Aoutput_clean(:,3)+Aoutput_clean(:,6)+Aoutput_clean(:,9))./3;
Aoutput_clean_all=[Aoutput_clean,height,Aoutput_clean(:,13)./Aoutput_clean(:,12),Aoutput_clean(:,15)./Aoutput_clean(:,14)];

figure;
plot(Aoutput_clean_all(:,18),height,'.');hold on;
xlabel('FR/R ratio');
ylabel('Height (cm)');
xlim([0,100]);
ylim([0,100])

a=[1.27,	91.17;
1.58,	83.31;
2.01,	75.73;
2.34,	65.26;
3.18,	54.48;
4.21,	44.57;
6.42,	34.47;
10.08,	24.89;
14.28,	15.62;
15.25,	6.30;];

plot(a(:,1),a(:,2),'--.k');%average


b=[1.188221656,	91.17;
1.515865497,	83.31;
1.917409182,	75.73;
2.652740459,	65.26;
3.705074974,	54.48;
5.038202549,	44.57;
6.88984555,	34.47;
9.274229524,	24.89;
12.3609555,	15.62;
16.49909781,	6.30;];

plot(b(:,1),b(:,2),'-r');% fitted curve 



