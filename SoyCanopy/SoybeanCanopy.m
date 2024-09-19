% ############### field diagram ####################
%
% (0, CanopyRowNum*3, 0)                                (100, CanopyRowNum*3, 0)
%  * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
% (Xmin,Ymax,0.1)                                (Xmax,Ymax,0.1)
%        ------------[boundary for ray tracing]----------
%        |                                              |
%        |                  //                          |
%  * * * | * * *  * *  * * //*  * * [plants]* * * * * * | * * * *
%        |                //                            |
%        |               //                             |
%        |              //[PAR sensor]                  |
%        |             //                               |
%  * * * | * * * * * *// * * * * * *   * * * * * * * *  | * * * *
%        |           // (45 degree)                     |
%        |   (sensorX,sensorY,sensorZ)                  |
%        ------------------------------------------------
% (Xmin,Ymin,0.1)                             (Xmax,Ymin,0.1)
%  * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
%(0,0,0)                                                       (100,0,0)
%
%  SoybeanCanopy('M_mean.txt', 'M_Vx.txt', DOY, 1, true)
function SoybeanCanopy(intputMDfile, M_Vx_file, DOY, repeat, isview)

plantDis = 10;%6;  %
CanopyRowNum = 4;  % build a canopy of 4 rows, in each row we have plantDis (5cm) distance plants

% used for ground triangle
Xmin = 26.1 + 0.1;   % X direction is from
Xmax = 102.1 - 0.1;
Ymin = 19 + 0.1;
Ymax = 98 - 0.1;

% parameter for sensor setting
sensorX = 10;
sensorY = 10;
sensorZ = 5 ;

% growing stage determination
m_Vxdata = importdata(M_Vx_file);
m_Vxdata = m_Vxdata.data;

% put input file to different DOY ~ X matrix
m_Vx = m_Vxdata(:,1:3);  % the DOY Vx_mean and Vx_std.
m_Senesense = m_Vxdata(:,[1,4]);  % the DOY Senesense.
m_VcmaxTop = m_Vxdata(:,[1,5]);   % the DOY Vcmax of top leaf.
m_JmaxTop = m_Vxdata(:,[1,6]);    % the DOY Jmax of top leaf.

% for branch Vx branch1 to branch6
m_Br1to6Vx = m_Vxdata(:,7:12);

% input DOY
if DOY<168 || DOY>267
    error = 'Erorr! Day of Year is out of growing season! 168~267';
    error
    return;
end
% get closest DOY that we have data.
DOY = round(DOY/3)*3;   % for current project only. Qingfeng
%

% import MD, measured data, file
md = importdata(intputMDfile);
md = md.data;

% convert unit from mm to cm
md(:,10:18) = md(:,10:18)/10;
md(:,3:9)   = md(:,3:9)  /180*pi;

% modified 2014-11-21, Qingfeng 
if sum( md(:,2)==0 ) == 2  % the C node has two leaves, we need to set this two leaves the same height.
    md(3,10) = 0;           % let the second leaf internode equals to 0.
end

% adjust of input parameters, here
% TODO

%field parameter
bedLength = 100; %135; %cm, use 76cm for simulation, from 12 ~ 88 for X
bedDistance = 38; %76;%cm, for simulation, use from 19 ~ 95 for Y

Sground = bedLength * bedDistance * CanopyRowNum;

%global veriables
N = 3;

PointsPlant = zeros(0,N);
FacetsPlant = zeros(0,N);
PointsCanopy = zeros(0,N);
FacetsCanopy = zeros(0,N);

CanopyIDS = zeros(0,7); %leafID leafLength Position SPAD Kt Kr NitrogenPerArea

%% multi plant
plantNumPerBed = bedLength/plantDis;

% determine the growth stage matrix for a canopy
% for main stem growth and senesence
% for branch1 to branch6, all the growth matrix. (no senesence in branch)
[Vx_matrix S_matrix] = stageDetermine (DOY, m_Vx, m_Senesense, CanopyRowNum, plantNumPerBed);

meanVx = mean(mean(Vx_matrix));

if (meanVx >0)
    Stage = strcat('V',num2str(meanVx));
elseif (meanVx == 0)
    Stage = 'VC';
elseif (meanVx == -1)
    Stage = 'VE';
end

Stage

t=0;
for n=1:CanopyRowNum    % row number
    plantRotation = 1;
    for m=1:plantNumPerBed
        
        if plantRotation == 0
            plantRotation = 1;
        else
            plantRotation = 0;
        end
        
        % determine the stage of this plant to be generated.
        
        Vx_int = floor(Vx_matrix(n,m));  % the int value of Vx
        Vx_sv = Vx_matrix(n,m) - Vx_int;  % the small value of Vx
        
        %
        S_int = S_matrix(n,m);   % get the number of senensenced leaves
        
        md_1 = md(md(:,2)<= Vx_int & md(:,2)>= S_int & md(:,1)==0, :);  % filter the data of plant structure to get the leaves on stems.
        
        if S_int>=1
            md_1 (1,10) = sum(    md(  md(:,2)<S_int & md(:,1)==0,  10)   ) + md_1 (1,10);  % add all the drop-leaf internode together to the current first internode. 
        end
        % / modified in 2014-11-30
        md_1 = youngLeafModification(md_1, Vx_sv);
        % modified in 2014-12-02
        
        % generate branch data and put together to build a plant
        ind_DOY = (DOY - 168) / 3 +1;
        
        for Br=1:6
            BrnVx = m_Br1to6Vx(ind_DOY,Br);
            md_tmp = md(md(:,1)==1 & md(:,2)<= BrnVx, :);
            md_tmp(:,1) = Br; 
            md_1 = [md_1; md_tmp];
        end
        
     %  md_2 = md_1(:,[1:6,10:18]);
        [PointsPlant, FacetsPlant, PlantIDS] = soybeanPlant(md_1);
        CanopyIDS = [CanopyIDS; PlantIDS];
        
        t = t+1;
        
        X2 = PointsPlant(:,1);
        Y2 = PointsPlant(:,2);
        Z2 = PointsPlant(:,3);
        
        [theta, r, h] = cart2pol(X2, Y2, Z2);
        theta = theta + plantRotation * pi;
        [X2, Y2, Z2] = pol2cart(theta, r, h);
        
        
        % plants not vertical, but -10 to 10 degree normal random,
        % 2014-12-02 Qingfeng and Venkat
        [theta, r, h] = cart2pol(Y2, Z2, X2);
        theta = theta + randn / 3 * (pi/18); % to get the standard normal distribution to -10 to 10 degree. In Y direction
        
        if theta >(pi/18)
            theta  = (pi/18);
        elseif theta < -(pi/18)
            theta = -(pi/18);
        end
        [Y2, Z2, X2] = pol2cart(theta, r, h);
        
        [theta, r, h] = cart2pol(Z2, X2, Y2);
        theta = theta + randn / 3 * (pi/18); % to get the standard normal distribution to -10 to 10 degree. In X direction
        
        if theta > (pi/18)
            theta  = (pi/18);
        elseif theta < -(pi/18)
            theta = -(pi/18);
        end
        [Z2, X2, Y2] = pol2cart(theta, r, h);
        % //
        
        % add random normal locations
        X2 = X2 + (m-1)* plantDis    + randn;          % S-N direction, the plant build from S -> N (x-axis positive)
        Y2 = Y2 + (n-1)* bedDistance + randn;       % W-E direction, the rows build from E -> W (y-axis positive)
        
        Z2 = Z2 + rand * 1;                 % 2cm diff among the plants
        
        PointsPlant2 = [X2,Y2,Z2];
        [row, col] = size(PointsCanopy);
        FacetsPlant2 = FacetsPlant + row;
        PointsCanopy = [PointsCanopy;PointsPlant2];
        FacetsCanopy = [FacetsCanopy;FacetsPlant2];
        
    end
end

% add ground
% % [groundPoints, groundFacets, groundIDS] = aGround(Xmin, Xmax, Ymin, Ymax);
% % [row, col] = size(PointsCanopy);
% % groundFacets = groundFacets + row;
% % PointsCanopy = [PointsCanopy; groundPoints];
% % FacetsCanopy = [FacetsCanopy; groundFacets];
% % CanopyIDS = [CanopyIDS; groundIDS];

% % add sensor
% [sensorPoints, sensorFacets, sensorIDS] = aPPFDsensor(sensorX, sensorY, sensorZ);
% [row, col] = size(PointsCanopy);
% sensorFacets = sensorFacets + row;
% PointsCanopy = [PointsCanopy; sensorPoints];
% FacetsCanopy = [FacetsCanopy; sensorFacets];
% CanopyIDS = [CanopyIDS; sensorIDS];

% convert to CM format
PointsA = PointsCanopy;
FacetsA = FacetsCanopy;


% TEMP
% [PointsA,FacetsA, LeafIDS] = soybeanLeaf(2.5, 7.63, 5.45, 7.63, 5.45, 7.63, 5.45, 0, pi, pi);
% CanopyIDS = LeafIDS;

[row,col] = size(FacetsA);

metrix = zeros(row,16);
% size(CanopyIDS)
metrix(:,10:16) = CanopyIDS;

for n=1:row
    metrix(n,1)= PointsA(FacetsA(n,1),1);
    metrix(n,2)= PointsA(FacetsA(n,1),2);
    metrix(n,3)= PointsA(FacetsA(n,1),3);
    metrix(n,4)= PointsA(FacetsA(n,2),1);
    metrix(n,5)= PointsA(FacetsA(n,2),2);
    metrix(n,6)= PointsA(FacetsA(n,2),3);
    metrix(n,7)= PointsA(FacetsA(n,3),1);
    metrix(n,8)= PointsA(FacetsA(n,3),2);
    metrix(n,9)= PointsA(FacetsA(n,3),3);
    
end


% accumulative LAI
metrix1 = metrix(metrix(:,10)<=0,:);
metrix  = metrix(metrix(:,10)> 0,:);
[row,col] = size(metrix);

x1 = metrix(:,1); y1 = metrix(:,2); z1 = metrix(:,3);
x2 = metrix(:,4); y2 = metrix(:,5); z2 = metrix(:,6);
x3 = metrix(:,7); y3 = metrix(:,8); z3 = metrix(:,9);

len1_sqare = (x2-x1).^2 + (y2-y1).^2 + (z2-z1).^2;
len2_sqare = (x3-x1).^2 + (y3-y1).^2 + (z3-z1).^2;
area = sqrt(len1_sqare.*len2_sqare)/ 2;
z = metrix(:,3);
[zSort, sortIndx] = sort(z,'descend');

area = area(sortIndx); % sorted area
metrix = metrix(sortIndx,:);
cLAI = zeros(row,1);

for n=1:row
    cLAI(n) = sum(area(1:n))/Sground;
end
metrix(:,13) = cLAI;

metrix = [metrix; metrix1];

% accumulative LAI


if (isview)
    %   dx = [PointsA(FacetsA(n,1),1),PointsA(FacetsA(n,2),1),PointsA(FacetsA(n,3),1)];
    %   dy = [PointsA(FacetsA(n,1),2),PointsA(FacetsA(n,2),2),PointsA(FacetsA(n,3),2)];
    %   dz = [PointsA(FacetsA(n,1),3),PointsA(FacetsA(n,2),3),PointsA(FacetsA(n,3),3)];
    
    %   patch(dx,dy,dz,rand,'FaceAlpha',0.6,'FaceColor','g');
    
    [row3,col3] = size(metrix);
    
    for i=1:row3
        va(i,1)=i;
        va(i,2)=row3+i;
        va(i,3)=2*row3+i;
    end
    color1 = zeros(row3,3);
    %     color1(:,1) = 34;
    %     color1(:,2) = 139;
    %     color1(:,3) = 34;
    %    [ 34,139,34 ] …≠¡÷¬Ã
    color1(:,1) = 34/255;
    color1(:,2) =139/255;
    color1(:,3) = 34/255;
    figure;
    trisurf(va,metrix(:,[1,4,7]),metrix(:,[2,5,8]),metrix(:,[3,6,9]),metrix(:,[3,6,9])); %,'FaceAlpha',0.7,'EdgeColor','interp','LineWidth',0.5);
    axis equal;
    
    %  view(-15,20)
    %colormapeditor
    
    view (50,30);
end


file = intputMDfile;
file = strcat('CM_V', num2str(DOY), '_rep', num2str(repeat),'_',file);
dlmwrite(file,metrix,'delimiter', '\t');
file = strcat('CM_V', num2str(DOY), '_rep', num2str(repeat),'_M_mean.mat');
save(file,'repeat','metrix')
%LeafMatrix = metrix;

end




