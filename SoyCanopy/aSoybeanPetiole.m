function [petiolePoints, petioleFacets, PetioIDS] = aSoybeanPetiole(petioleLength, petiole_diameter, petioleAngle, petioleZ)


% petioleAngle unit arc

if petioleLength == 0
    petiolePoints = zeros(0,3);
    petioleFacets = zeros(0,3);
    PetioIDS = zeros(0,7);
    return;
else


petiolePoints =[
    0.25,   0;
    0.125,  0.2165;
    -0.125, 0.2165;
    -0.25,  0;
    -0.125, -0.2165;
    0.125,  -0.2165;
    ] ;
petiolePoints = petiolePoints/0.5*petiole_diameter;

petiolePoints = [
    petiolePoints;
    petiolePoints];
petiolePoints (1:6,3) = 0;
petiolePoints (7:12,3) = petioleLength;


petioleFacets = [
    1 2 8;
    8 7 1;
    2 3 9;
    9 8 2;
    3 4 10;
    10 9 3;
    4 5 11;
    11 10 4;
    5 6 12;
    12 11 5;
    6 1 7;
    7 12 6
    ];
[petio_row, petio_col] = size(petioleFacets);
PetioIDS = zeros(petio_row, 7); 
PetioIDS(:,1) = -10;    % -10 is stem

X = petiolePoints(:,1);
Y = petiolePoints(:,2);
Z = petiolePoints(:,3);
[theta,r,h] = cart2pol(X,Z,Y);
theta = theta - petioleAngle;
[X, Z, Y] = pol2cart(theta, r, h);
Z = Z + petioleZ;
petiolePoints = [X, Y, Z];

end

end


