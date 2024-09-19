function LeafA=Leaf(WeatherRH,WeatherTemperature,Air_CO2,WeatherWind,Radiation_PAR,Radiation_NIR,Radiation_LW,Vcmax25,Jmax25,CumLAI)
%Result=Leaf(0.6,28,400,5,400,0,0,100,200)
GRNC=0;
PhotosynthesisType=1;
PhotosynthesQ10=0;
R=8.314472E-3;%Gas constant KJ mole^{-1} K^{-1}
Convert=1E6/(2.35E5); %Convert W m^{-2} to u moles m^{-2} s^{-1}
Boltzman=5.6697E-8; % Stefan-Boltzmann constant W m^{-2} K^{-4}
LatentHeatVaporization=44000.0;%J mole^{-1}
Pressure=101325.0; % Standard atmospheric pressure Pa
ConstantsCp=29.3;
PhotosynthesisTheta=0.76;
kn=0.2;
%Rd25=1*exp(-kn*CumLAI);
Rd25=1;
BallBerryIntercept=0.008;
BallBerrySlope=10.5;
Air_O2=210.0;
WaterStressFunction=3;
WaterStressFactor=1.0;
    
MaxError = 0.25; MinError = 0.001;
ErrorCount = 0; MaxErrorCount = 1;
% PreviousLeafState = {0.0, 0.0, 0.0, 0.0};
% ErrorLeafState = {1.0, 1.0, 1.0, 1.0};
Previous2Gs = 0; %Stomatal conductance moles/m2 leaf area/s
% PreviousLeafMassFlux = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
Relax = 0.0; % Relaxation value for oscillation
%Initialize variables
PreviousLeafState_Ci = 0;
Previous2Gs = 0; %Oscillation
PreviousLeafState_Gs = 0;
PreviousLeafState_Temperature =0;
PreviousLeafMassFlux_GrossAssimilation = 0;
PreviousLeafMassFlux_NetAssimilation = 0;
ErrorLeafState_Ci=1;
ErrorLeafState_Gs=1;  
ErrorLeafState_Temperature=1;
LeafTemperature= WeatherTemperature;% Initial Leaf temperature C
Ci = 0.7 * Air_CO2;%Initial Ci u moles/mole
Gs = 0.01; % Initial stomatal conductance moles/m2 leaf area/s
Gb = 10.2; % Initial boundary layer conductance moles/m2 leaf area/s
    %Convergence loop for leaf
	while ((abs(ErrorLeafState_Ci) >= MinError || abs(ErrorLeafState_Gs) >= MinError ||abs(ErrorLeafState_Temperature) >= MinError) && ErrorCount <= MaxErrorCount)
    %Compute photosynthesis
%        if PhotosynthesisType == 1.0%C3 Farquhar model
            PhotosynthesisRate=ComputPhotosynthesisRate(PhotosynthesisType,PhotosynthesQ10,Vcmax25,Jmax25,Rd25,R,LeafTemperature,Convert, Radiation_PAR,PhotosynthesisTheta,Ci,Air_O2,GRNC);
            NetAssimilation=PhotosynthesisRate(1);
            GrossAssimilation=PhotosynthesisRate(2);
            Rd=PhotosynthesisRate(3);
            GammaStar=PhotosynthesisRate(4);
%         else if PhotosynthesisType == 1.1 %C3 Metabolic model
%             ComputeMeMPhotosynthesis(Photosynthesis, Weather, LeafState, LeafMassFlux, LogOutputFile);
%         else if PhotosynthesisType == 2.0% // C4 model
%             ComputeC4Photosynthesis(Photosynthesis, Weather, LeafState, LeafMassFlux, LogOutputFile);
%             end
%             end
%         end
        %Compute boundary layer conductance
        BoundaryCound=ComputeBoundaryLayerConductance(WeatherTemperature,LeafTemperature,WeatherRH,WeatherWind,Pressure,Gs,NetAssimilation, Air_CO2);
        Gb=BoundaryCound(1);
        Cb=BoundaryCound(2);
        Eb=BoundaryCound(3);
        
        % Compute stomatal conductance
        CalGs=ComputGsBallBerry(BallBerryIntercept,BallBerrySlope,WaterStressFactor,Eb,Cb,Gb,NetAssimilation,LeafTemperature,Air_CO2);
        Gs=CalGs(1);
        Ci=CalGs(2);
        % Compute energy balance
        CalLeafTemperature=ComputeEnergyBalance(Gb,Gs,NetAssimilation,LeafTemperature,WeatherRH,WeatherTemperature,Pressure,Boltzman,ConstantsCp,LatentHeatVaporization,Radiation_PAR,Radiation_NIR,Radiation_LW);
        LeafTemperature=CalLeafTemperature(1);
        Transpiration=CalLeafTemperature(2);
        % Compute convergence error
        ErrorLeafState_Ci = (PreviousLeafState_Ci - Ci) / Ci;
        ErrorLeafState_Gs = (PreviousLeafState_Gs - Gs) / Gs;
        ErrorLeafState_Temperature = (PreviousLeafState_Temperature - LeafTemperature) / LeafTemperature;

        %Check for oscillation and divergence to apply relaxation
        if (abs(Previous2Gs - Gs) < 0.01 && abs(ErrorLeafState_Gs) >= 0.001 && ErrorCount > 1) ||(abs(ErrorLeafState_Ci) > MaxError && ErrorCount > 1) || (abs(ErrorLeafState_Gs) > MaxError && ErrorCount > 1) ||(abs(ErrorLeafState_Temperature) > MaxError && ErrorCount > 1) % Divergence
            Relax = 0.5;
            % fprintf(LogOutputFile,"Relax");
        else if (Relax > 0.0)
            Relax = 0.0;
            end
        end
        %Apply relaxation due to oscillation and divergence
        Ci = Ci - Relax * (Ci - PreviousLeafState_Ci);
        if (Ci <= GammaStar)
            Ci = GammaStar; % ppm
        end
        Gs = Gs - Relax * (Gs - PreviousLeafState_Gs);
        if Gs < BallBerryIntercept
           Gs = BallBerryIntercept;
        end
        GrossAssimilation = GrossAssimilation - Relax *(GrossAssimilation- PreviousLeafMassFlux_GrossAssimilation);
        if (GrossAssimilation < 0.0)
            GrossAssimilation = 0.0;
            NetAssimilation = GrossAssimilation - Rd;
        end

        %Update values
        PreviousLeafState_Ci = Ci;
        Previous2Gs = PreviousLeafState_Gs; %Oscillation
        PreviousLeafState_Gs = Gs;
        PreviousLeafState_Temperature = LeafTemperature;
        PreviousLeafMassFlux_GrossAssimilation = GrossAssimilation;
        PreviousLeafMassFlux_NetAssimilation = NetAssimilation;
        ErrorCount = ErrorCount + 1;
    end

%     if (ErrorCount > MaxErrorCount)
%         disp('Error in ComputeLeaf')
%         %disp('Error in ComputeLeaf',ErrorLeafState_Ci, ErrorLeafState_Gs, ErrorLeafState_Temperature);
% %         fprintf(LogOutputFile, "Error in ComputeLeaf for Leaf ID %f: Leaf not converged \t", Photosynthesis->LeafID);
% %         fprintf(LogOutputFile, "CiError=%f\t GsError=%f\t LeafTemperatureError=%f\n",
% %                 ErrorLeafState.Ci, ErrorLeafState.Gs, ErrorLeafState.Temperature);
%     end
%     // fprintf(LogOutputFile, "LeafID = %f  \t PAR = %f  \t CO2 = %f  \t Aj = %f  \t Ac = %f  \t Ap = %f \n",
%     //        Photosynthesis->LeafID, Weather->Radiation.PAR, Photosynthesis->CO2,
%     //        LeafMassFlux->Aj, LeafMassFlux->Ac, LeafMassFlux->Ap);
LeafA(1)=Ci;
LeafA(2)=NetAssimilation;
LeafA(3)=Gs;
LeafA(4)=LeafTemperature;
LeafA(5)=Transpiration;
end
