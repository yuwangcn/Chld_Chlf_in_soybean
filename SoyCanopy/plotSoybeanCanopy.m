% Script to plot results of 3D soybean model
clc
clear all
close all

addpath ('./matlab_Git');

F = 0;
FSize = 12;
FWeight = 'bold';
LWidth = 2.0;
MSize = 5;
FName = 'Ariel';

for DOY = 168:3:168
    % Load data
    FileName = strcat('PPFDCM_V',num2str(DOY),'_rep100','_M_mean_12.txt');
    Data = dlmread(FileName);
    % Plot figure
    % Plot canopy figure
    F = F+1;
    figure(F)
    set(F,'Position',get(0,'Screensize'))
    [Rows,Columns] = size(Data);
    for RowCount=1:Rows
        patch(Data(RowCount,[1,4,7]),Data(RowCount,[2,5,8]),Data(RowCount,[3,6,9]),0.5);
    end
    axis equal
    axis ([-40 120 -40 140 0 150]);
    view(45,45);
    set(gca,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
    xlabel('X axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
    ylabel('Y axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
    zlabel('Z axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
    % Plot light absorbed
    F = F+1;
    figure(F)
    set(F,'Position',get(0,'Screensize'))
    [Rows,Columns] = size(Data);
    for RowCount=1:Rows
        patch(Data(RowCount,[1,4,7]),Data(RowCount,[2,5,8]),Data(RowCount,[3,6,9]),Data(n2,18));
    end
    axis equal
    axis ([-40 120 -40 140 0 150]);
    view(45,45);
    set(gca,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
    xlabel('X axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
    ylabel('Y axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
    zlabel('Z axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
end

