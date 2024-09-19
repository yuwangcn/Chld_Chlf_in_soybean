function [PointsAll,FacetsAll, LeafIDS] = soybeanLeaf(pet2Length, lat1L, lat1W, Lat1_angle, lat2L, lat2W, Lat2_angle, midL, midW, mid_angle, pet1Angle, pet2Angle, mid_ifAngle)

% input parameter with unit of cm.

%% leafRadiusR is the radius of leaf

%one pieace of leaf
% calculate the points x,y position
Points = [0,0;
    1,0;
    2,0;
    3.1547,0;
    4.3094,0;
    5.4641,0;
    0.2588,1;
    1.5,1;
    2.5774,1;
    3.7312,1;
    1.1056,1.7889;
    2,2;
    0.2588,-1;
    1.5,-1;
    2.5774,-1;
    3.7312,-1;
    1.1056,-1.7889;
    2,-2];
Points(:,3)=0;

Facets = [1,7,2;
    2,7,8;
    2,8,3;
    3,8,9;
    3,9,4;
    4,9,10;
    4,10,5;
    5,10,6;
    7,11,8;
    8,11,12;
    8,12,9;
    9,12,10;
    13,1,2;
    13,2,14;
    14,2,3;
    14,3,15;
    15,3,4;
    15,4,16;
    16,4,5;
    16,5,6;
    17,13,14;
    17,14,18;
    18,14,15;
    18,15,16];

Facets_raw = Facets;

%% change mid- lat1 and lat2 leaf size and horizontally angles

if midL>0 && midW>0
    % adjust leaf size
    X2 = Points(:,1)/5.4641 * midL;
    Y2 = Points(:,2)/4      * midW;
    
    % turn leaf horizontal angle
    [theta,r,h] = cart2pol(X2,Y2,Points(:,3));
    
    if rand > 0.5
        theta_mid = theta + mid_angle;
    else
        theta_mid = theta - mid_angle;
    end
    
    [X2,Y2,Z2] = pol2cart(theta_mid,r,h);
    
    % turn vertical leaf angle
    [theta, r1, h1] = cart2pol(X2,Z2,Y2);  % the middel leaf
    theta = theta - (pi-mid_ifAngle);   % turn mid leaf angle to petiol2
    [X, Z, Y] = pol2cart(theta,r1,h1);
    Points1 = [X, Y, Z];
    % length of petile 2 length, Petiole2 is small and igored.
    Points1(:,1)=Points1(:,1)+ pet2Length;
    % Facets is OK
    
else
    Points1 = zeros(0,3);
    Facets = zeros(0,3);
end
FacetsAll = Facets;  % start to addup.
PointsAll = Points1;

if lat1W>0 && lat1L>0
    % adjust leaf size
    X = Points(:,1)/5.4641       * lat1L;
    Y = Points(:,2)/4  * lat1W;
    
    % turn leaf horizontal angle
    [theta,r,h] = cart2pol(X,Y,Points(:,3));
    theta2 = theta + Lat1_angle;
    
    [X2,Y2,Z2] = pol2cart(theta2,r,h);
    Points2 = [X2,Y2,Z2];
    
    [PointsAll_row,PointsAll_col]=size(PointsAll);
    Facets2 = Facets_raw  + PointsAll_row;
else
    Points2 = zeros(0,3);
    Facets2 = zeros(0,3);
end
FacetsAll = [FacetsAll; Facets2];  % addup.
PointsAll = [PointsAll; Points2];


if lat2W>0 && lat2L>0
    % adjust leaf size
    X = Points(:,1)/5.4641       * lat2L;
    Y = Points(:,2)/4  * lat2W;
    
    % turn leaf horizontal angle
    [theta,r,h] = cart2pol(X,Y,Points(:,3));
    theta3 = theta - Lat2_angle;
    
    [X3,Y3,Z3] = pol2cart(theta3,r,h);
    Points3 = [X3,Y3,Z3];

    [PointsAll_row,PointsAll_col] = size(PointsAll);
    Facets3 = Facets_raw  + PointsAll_row;
else
    Points3 = zeros(0,3);
    Facets3 = zeros(0,3);
end
FacetsAll = [FacetsAll; Facets3];  % addup.
PointsAll = [PointsAll; Points3];

%%

% start the LeafIDS for 7 columns.
[PointsAll_row,PointsAll_col] = size(FacetsAll);
LeafIDS = zeros(PointsAll_row, 7);

% add a petile2
[petiolePoints, petioleFacets, PetioIDS] = aSoybeanPetiole(pet2Length, 0.2, pi/2, 0);  % assume the petile2 diameter = 0.2cm
LeafIDS = [LeafIDS; PetioIDS];

% addup all the points to be PointsAll
[PointsAll_row,PointsAll_col] = size(PointsAll);
petioleFacets = petioleFacets + PointsAll_row;

FacetsAll = [FacetsAll;petioleFacets];
PointsAll = [PointsAll;petiolePoints];

% turn pet1Angle
[theta, r, h] = cart2pol(PointsAll(:,1),PointsAll(:,3),PointsAll(:,2));  % the middel leaf
theta = theta + (pi/2 - pet1Angle - (pi-pet2Angle));  % need to check.


[X, Z, Y] = pol2cart(theta,r,h);
PointsAll = [X, Y, Z];


end






