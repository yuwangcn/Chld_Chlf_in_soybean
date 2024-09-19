% in this function, construct a stem, the stem can be used as main stem or
% a branch. 

% input of a md data for one stem

function [PointsStem, FacetsStem, StemIDS] = soybeanStem(md_a_Stem)

[N_a_Stem_nodes, col]=size(md_a_Stem);    % get the nodes number in main stem, including C, U, 1, 2, 3, and etc. in data of MD is -1 0 1 2 3 and etc. 
PointsStem = zeros(0,3);
FacetsStem = zeros(0,3);
StemIDS = zeros(0,7);


% for each node, construct the petile, and (petile2, leaf)
for n_node = 1 : N_a_Stem_nodes
    % get the input parameters
    pet1Angle  = md_a_Stem(n_node,4);
    pet2Angle  = md_a_Stem(n_node,5);
    mid_ifAngle= md_a_Stem(n_node,6);
    
    % the leaf horizontal angles
    Lat1_angle = md_a_Stem(n_node,7);
    Lat2_angle = md_a_Stem(n_node,8);
    mid_angle  = md_a_Stem(n_node,9);

    pet1BaseHeight = sum(md_a_Stem(1:n_node,10));  % line number, not the number of second column. 

    pet1Length = md_a_Stem(n_node,11);
    pet2Length = md_a_Stem(n_node,12);
    lat1Length = md_a_Stem(n_node,13);
    lat1Width  = md_a_Stem(n_node,14);
    lat2Length = md_a_Stem(n_node,15);
    lat2Width  = md_a_Stem(n_node,16);
    midLength  = md_a_Stem(n_node,17);
    midWidth   = md_a_Stem(n_node,18);
    
    % construct a leaf with petiel2
    [PointsLeaf,FacetsLeaf,LeafIDS] = soybeanLeaf(pet2Length, lat1Length, lat1Width, Lat1_angle, lat2Length, lat2Width, Lat2_angle, midLength, midWidth, mid_angle, pet1Angle, pet2Angle, mid_ifAngle);  % call soybeanLeaf to get a leaf
    
    % %leafID(node ID, -1,0,1,2 etc) leafLength(0) Position(0) SPAD(0)
    % Kt(0)Kr(0) NitrogenPerArea(0)
    LeafIDS(LeafIDS(:,1)==0,1) = md_a_Stem(n_node,2);  % node ID, -1,0,1,2 and etc, StemIDS 1st column is the node ID. which will be used for differnt leaf reflcetance and transmittance. 
    
    
    
    % construct petile1 and put the leaf to its postion
    pet1Angle_rand = 1+ (rand*0.6 - 0.3);
    
    PointsLeaf(:,1) = PointsLeaf(:,1) + sin(pet1Angle *pet1Angle_rand)*pet1Length;
    PointsLeaf(:,3) = PointsLeaf(:,3) + cos(pet1Angle *pet1Angle_rand)*pet1Length + pet1BaseHeight;
    [petiolePoints, petioleFacets, PetioIDS] = aSoybeanPetiole(pet1Length, 0.3, pet1Angle*pet1Angle_rand, pet1BaseHeight);   % assume the petile2 diameter = 0.3cm
    
    LeafIDS = [LeafIDS; PetioIDS]; 
        
    
    % put petiol1, together with the leaf
    [row, col] = size(PointsLeaf);
    PointsLeaf = [PointsLeaf; petiolePoints]; % here, the leaf includes petieol 1
    FacetsLeaf = [FacetsLeaf; petioleFacets+row];
    
    % horizontal ture a angle = 102 degree, 7 leaves in 720 degree with
    % minimum self shading.  Assumption
    
    [theta,r,h] = cart2pol(PointsLeaf(:,1),PointsLeaf(:,2),PointsLeaf(:,3));
 %   if N_a_Stem_nodes == n_node
 %       theta2 = theta + (n_node-2)*102/180*pi + pi;
 %   else
        theta2 = theta + pi/2 + (n_node-1)*pi + (rand*60-30)/180*pi;
 %   end
    [X2,Y2,Z2] = pol2cart(theta2,r,h);
    PointsLeaf2 = [X2,Y2,Z2];
    [row, col]=size(PointsStem);
    FacetsLeaf2 = FacetsLeaf + row;
    % add up to the stem
    PointsStem = [PointsStem;PointsLeaf2];
    FacetsStem = [FacetsStem;FacetsLeaf2];
    StemIDS = [StemIDS; LeafIDS];
    
end

[petiolePoints, petioleFacets, PetioIDS] = aSoybeanPetiole(sum(md_a_Stem(:,10)), 0.5, 0, 0);
StemIDS = [StemIDS; PetioIDS];
[rowStem, col] = size(PointsStem);
PointsStem = [PointsStem; petiolePoints];
FacetsStem = [FacetsStem; petioleFacets+rowStem];


end

