%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to visualize data for 3D Canopy results
% Author: Venkatraman Srinivasan
% Date created: 3/3/2014
% Date modified: 3/3/2014
% This code uses the model developed by Song et al 2013 to generate output
% of light absorbed in a canopy.

clear all;
close all;
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify output file
OutFile = 'PPFD-test';
% Load light absorbed
M_Canopy = load(strcat(OutFile,'.txt'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot figures:
F = 0;
FSize = 6;
FWeight = 'bold';
LWidth = 2.0;
MSize = 5;
FName = 'Ariel';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot canopy light absorption
F = F+1;
figure(F)
% maxfig(F,1)
[row3,col3] = size(M_Canopy);
for n2=1:row3
    patch(M_Canopy(n2,[1,4,7]),M_Canopy(n2,[2,5,8]),M_Canopy(n2,[3,6,9]),M_Canopy(n2,18));
end
axis([-30 80 -30 80 0 125])
view([45 45])
set(gca,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
xlabel('X axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
ylabel('Y axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
zlabel('Z axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
shading flat
caxis([0 2500])
CB = colorbar;
set(CB,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight,'XAxisLocation','bottom');
xlabel(CB,'[\mu moles / m^2 / s]','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save figure

FWidth = 7.25; % 3 columns
set(F,'PaperPosition',[0.1 0.1 FWidth FWidth*8.3/11.7])
FigureName = OutFile;
saveas(F,FigureName);
print (F,'-depsc2',FigureName);
print (F,'-djpeg',FigureName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%