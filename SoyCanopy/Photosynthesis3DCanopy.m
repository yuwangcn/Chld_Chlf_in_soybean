%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to visualize data for 3D Canopy results
% Author: Venkatraman Srinivasan
% Date created: 3/3/2014
% Date modified: 3/3/2014
% This code uses the model developed by Song et al 2013 to generate output
% of different canopy structures for different parameters.

clear all;
close all;
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate canopy structure for different scenarios

Option = 0;
InputFile = 'SoybeanNormal.txt';
OutFile = 'SoybeanAnglePetioleLeafOut';

z_k = 1; % Plant height
l_k = 1; % Leaf length
w_k = 1; % Leaf width
a_k = 1; % Leaf angle
c_k = 1; % Leaf curvature
k_shape = 1; % Leaf shape

% if Option == 0 % Test case
%     OutFile = 'SoybeanNormalCanopy';
% elseif Option == 1 % Bazse case
%     OutFile = 'CMtest';
% elseif Option == 2 % Tall canopy
%     OutFile = 'CMtest_Tall';
%     z_k = 2;
% elseif Option == 3 % Long leaf canopy
%     OutFile = 'CMtest_LongLeaf';
%     l_k = 2;
% elseif Option == 4 % Wide leaf canopy
%     OutFile = 'CMtest_WideLeaf';
%     w_k = 2;
% elseif Option == 5 % High leaf angle canopy
%     OutFile = 'CMtest_HighAngle';
%     a_k = 2.0;
% elseif Option == 6 % High leaf curvature canopy
%     OutFile = 'CMtest_HighCurvature';
%     c_k = 2.0;
% elseif Option == 7 % High shape adjustment canopy
%     OutFile = 'CMtest_HighShapeAdjustment';
%     k_shape = 2.0;
% end

% M_Canopy = mCanopy(InputFile,z_k, l_k, w_k, a_k, c_k, k_shape,OutFile);
M_Canopy = mCanopy_Soy(InputFile,z_k, l_k, w_k, a_k, c_k, k_shape,OutFile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot figures:
F = 0;
FSize = 12;
FWeight = 'bold';
LWidth = 2.0;
MSize = 5;
FName = 'Ariel';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot canopy structure
F = F+1;
figure(F)
maxfig(F,1)

subplot(1,2,1)
[row3,col3] = size(M_Canopy);
for n2=1:row3
    patch(M_Canopy(n2,[1,4,7]),M_Canopy(n2,[2,5,8]),M_Canopy(n2,[3,6,9]),0.5);
end
axis([-10 30 0 120 0 150])
axis equal
view([30 60])
set(gca,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
xlabel('X axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
ylabel('Y axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
zlabel('Z axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)

subplot(1,2,2)
[row3,col3] = size(M_Canopy);
for n2=1:row3
    patch(M_Canopy(n2,[1,4,7]),M_Canopy(n2,[2,5,8]),M_Canopy(n2,[3,6,9]),0.5);
end
axis([-10 30 0 120 0 150])
axis equal
view([0 0])
set(gca,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
xlabel('X axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
ylabel('Y axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
zlabel('Z axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)

% subplot(1,3,3)
% [row3,col3] = size(M_Canopy);
% for n2=1:row3
%     patch(M_Canopy(n2,[1,4,7]),M_Canopy(n2,[2,5,8]),M_Canopy(n2,[3,6,9]),0.5);
% end
% axis([-10 30 0 120 0 150])
% axis equal
% view([90 90])
% set(gca,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
% xlabel('X axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
% ylabel('Y axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
% zlabel('Z axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot canopy structure
F = F+1;
figure(F)
maxfig(F,1)

writerObj = VideoWriter('SoyBeanVideo');
writerObj.FrameRate = 5; 
open(writerObj);

[row3,col3] = size(M_Canopy);
for n2=1:row3
    patch(M_Canopy(n2,[1,4,7]),M_Canopy(n2,[2,5,8]),M_Canopy(n2,[3,6,9]),0.5);
end
axis([-10 30 0 120 0 150])
axis equal
set(gca,'FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
xlabel('X axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
ylabel('Y axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)
zlabel('Z axis','FontName',FName,'FontSize',FSize,'FontWeight',FWeight)

set(gcf,'Renderer','zbuffer');
% Record the movie
for Loop = 1:1:36
    view([Loop*10 10])
    axis equal
    Frame(Loop) = getframe(gcf);
    pause(0.1);
    writeVideo(writerObj,Frame(Loop));
end

close(writerObj);
% movie(Frame,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save figure
F = 1;
FWidth = 7.25; % 3 columns
set(F,'PaperPosition',[0.1 0.1 FWidth FWidth*8.3/11.7])
FigureName = OutFile;
saveas(F,FigureName);
print (F,'-depsc2',FigureName);
print (F,'-djpeg',FigureName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%