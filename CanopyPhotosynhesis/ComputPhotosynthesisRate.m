function PhotosynthesisRate=ComputPhotosynthesisRate(PhotosynthesisType,PhotosynthesQ10,Vcmax25,Jmax25,Rd25,R,LeafTemperature,Convert, Radiation_PAR,PhotosynthesisTheta,Ci,Air_O2,GRNC)
%ComputPhotosynthesisRate(1,1,100,180,0.8,8.314472E-3,26,1E6/(2.35E5), 1000,0.76,250,210.0)
%%%%%%ComputeRespiration
%Temporary variables double Q10Temperature;
if (PhotosynthesisType == 1.0 || PhotosynthesisType == 1.1)% C3 Farquhar or Metabolic
    Rd = Rd25 * exp(18.72 - 46.39 / (R * (LeafTemperature + 273.15)));
%  else if (PhotosynthesisType == 2.0)%C4
%      Q10Temperature =PhotosynthesQ10^((LeafTemperature - 25.0) / 10.0);
%      Rd = Rd25 * Q10Temperature / (1.0 + exp(1.3 * (LeafTemperature - 55.0)));
%      end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute C3 photosynthesis
%Constant
if (PhotosynthesisType == 1.0)% C3 Farquhar or Metabolic
Rate_TPu = 23.0; %u moles/m2 leaf area/s
%Temporary variables
LeafTemperatureKelvin = LeafTemperature + 273.15; %Leaf temperature in K
GammaStar = exp(19.02 - 37.83 / (R * LeafTemperatureKelvin));
Ko = exp(20.30 - 36.38 / (R * LeafTemperatureKelvin));
Kc = exp(38.05 - 79.43 / (R * LeafTemperatureKelvin));	
Vcmax = Vcmax25 * exp(26.35 - 65.33 / (R * LeafTemperatureKelvin));
PhiPS2 = 0.385 + 0.02166 * LeafTemperature - 3.37 * LeafTemperature^2.0 / 10000.0;% Match PS_FIT
I = Convert * Radiation_PAR * PhiPS2 * 0.5;
ThetaPS2 = PhotosynthesisTheta + 0.01713 * LeafTemperature - 3.75 * LeafTemperature^2.0 / 10000.0; % Match PS_FIT
Jmax = Jmax25 * exp(17.57 - 43.54 / (R * LeafTemperatureKelvin));
J = (I + Jmax - sqrt((I + Jmax)^2.0 - 4.0 * ThetaPS2 * I * Jmax)) / (2.0 * ThetaPS2);
LeafAc = (1.0 - GammaStar / Ci) * (Vcmax * Ci) /(Ci + Kc * (1.0 + Air_O2 / Ko));%Rubisco limited photosynthesis
LeafAj = (1.0 - GammaStar / Ci) * (J * Ci) /(4.5 * Ci + 10.5 * GammaStar); %Light limited photosynthesis
if (LeafAj < 0.0)
    LeafAj = 0.0;
end
LeafAp = (3.0 * Rate_TPu) / (1.0 - GammaStar /Ci); %TPU limited photosynthesis
if (LeafAp < 0.0)
    LeafAp=0.0;
end
GrossAssimilation=min(min(LeafAc,LeafAj),LeafAp);%Minimum of three limitations
NetAssimilation=GrossAssimilation-Rd;
  
    if (isinf(GrossAssimilation) || isnan(GrossAssimilation))
%         fprintf(LogOutputFile, "Error in ComputeC3Photosynthesis for Leaf ID: %f: GrossAssimilation=%f\n",
%                 Photosynthesis->LeafID, LeafMassFlux->GrossAssimilation);
        GrossAssimilation = 0.0;
        NetAssimilation =-Rd;

    end
end

if (PhotosynthesisType == 1.1)% C3 metabolic
GrossAssimilation=C3MeMLookup(Ci,LeafTemperature,Radiation_PAR,GRNC);
NetAssimilation=GrossAssimilation-Rd;
    if (isinf(GrossAssimilation) || isnan(GrossAssimilation))
%         fprintf(LogOutputFile, "Error in ComputeC3Photosynthesis for Leaf ID: %f: GrossAssimilation=%f\n",
%                 Photosynthesis->LeafID, LeafMassFlux->GrossAssimilation);
        GrossAssimilation = 0.0;
        NetAssimilation =-Rd;

    end
LeafTemperatureKelvin = LeafTemperature + 273.15; %Leaf temperature in K
GammaStar = exp(19.02 - 37.83 / (R * LeafTemperatureKelvin));
end

% if (Photosynthesis->Type == 2.0)%C4
% GammaStar = exp(19.02 - 37.83 / (R * (LeafTemperature + 273.15)));
% Q10Temperature = pow(Photosynthesis->Q10, ((LeafState->Temperature - 25.0) / 10.0));
% VT = Vmax25 * Q10Temperature /((1.0 + exp(0.3 * (13.0 - LeafTemperature))) * (1.0 + exp(0.3 * (LeafTemperature - 36.0))));
% KT = PhotosynthesisK * Q10Temperature;
% 
%     // First quadratic equation
%     MCoefficient[0] = Photosynthesis->Theta;
%     MCoefficient[1] = -(VT + Photosynthesis->Alpha * Constants.Convert * Weather->Radiation.PAR);
%     MCoefficient[2] = VT * Photosynthesis->Alpha * Constants.Convert * Weather->Radiation.PAR;
%     MRoots = rpoly(MCoefficient, 3, MRealRoots, MImaginaryRoots); // Roots will always be real
%     M = fmin(MRealRoots[1], MRealRoots[2]);
% 
%     // Second quadratic equation
%     ACoefficient[0] = Photosynthesis->Beta;
%     ACoefficient[1] = -(M + KT * LeafState->Ci);
%     ACoefficient[2] = M * KT * LeafState->Ci;
%     ARoots = rpoly(ACoefficient, 3, ARealRoots, AImaginaryRoots); // Roots will always be real
% 
%     LeafMassFlux->GrossAssimilation = fmin(ARealRoots[1], ARealRoots[2]);
% 
%     LeafMassFlux->Aj = Photosynthesis->Alpha * Constants.Convert * Weather->Radiation.PAR; // Light limited photosynthesis
%     LeafMassFlux->Ap = KT * LeafState->Ci; // PeP carboxylase limited photosynthesis
%     LeafMassFlux->Ac = VT; // Rubisco limited photosynthesis
%       LeafMassFlux->NetAssimilation = LeafMassFlux->GrossAssimilation - LeafMassFlux->Rd;
% 
%     if (isinf(GrossAssimilation) || isnan(GrossAssimilation))
% %         fprintf(LogOutputFile, "Error in ComputeC3Photosynthesis for Leaf ID: %f: GrossAssimilation=%f\n",
% %                 Photosynthesis->LeafID, LeafMassFlux->GrossAssimilation);
%         GrossAssimilation = 0.0;
%         NetAssimilation =-Rd;
% 
%     end
%end
PhotosynthesisRate(1)=NetAssimilation;
PhotosynthesisRate(2)=GrossAssimilation;
PhotosynthesisRate(3)=Rd;
PhotosynthesisRate(4)=GammaStar;
end