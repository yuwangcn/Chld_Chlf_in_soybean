function [PointsPlant, FacetsPlant, PlantIDS] = soybeanPlant(md)

% add noise to md by +/- 15%

% did not add noise to leaf horizontal angles, that columns 7 8 9
[row_m, col_m] = size(md);
for m=3:row_m
    for n=[3 4 10 11 12]   % only for angles,  petiol length, and internode length. 
md(m,n) = md(m,n).*(1+0.3*rand-0.15);
    end
    for n=5:6        
md(m,n) = pi - (pi - md(m,n) )* (1+0.3*rand-0.15);  % debug: leaf petiole 2 angle. 

    end
end



%% main stem
N = 3;
PointsStem = zeros(0,N);
FacetsStem = zeros(0,N);
PlantIDS = zeros(0,7); %leafID leafLength Position SPAD Kt Kr NitrogenPerArea

% get the MD data for main stem
md_mainStem = md(md(:,1)==0,:); % the first column equals to 0.
[PointsStem, FacetsStem, StemIDS] = soybeanStem(md_mainStem);
PlantIDS = [PlantIDS; StemIDS];


PointsPlant = PointsStem;
FacetsPlant = FacetsStem;

%% Branches
num_branch = md(end,1);  % total branch number
branchRotation = [-1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1]; % can be used for most 32 branches
for id_stem = 1:num_branch
    md_branchStems = md(md(:,1)==id_stem, :); % all branches
    branchAngle = md_branchStems(1,3); % this column values are the same
    branchBaseHeight = sum(  md_mainStem(  md_mainStem(:,2)<=md_branchStems(1,2)   , 10 )   );
    
    [PointsStem, FacetsStem, StemIDS] = soybeanStem(md_branchStems);
    PlantIDS = [PlantIDS; StemIDS];
    
    [theta, r, h] = cart2pol (PointsStem(:,1),PointsStem(:,2),PointsStem(:,3));
    
  %  theta = theta + pi/2*branchRotation(id_stem);   % do not force the
  %  branch angle turn pi/2. 
    
    [X, Y, Z] = pol2cart(theta, r, h);
    [theta, r, h] = cart2pol (Y, Z, X);
    theta = theta + branchAngle * (-1 + mod(id_stem,2)*2);     % turn branch angle, left or right side of the row
    [Y, Z, X] = pol2cart(theta, r, h);
    Z = Z + branchBaseHeight;        % move the branch to its growing node height
    PointsStem = [X, Y, Z];
    
    [row, col] = size(PointsPlant);
    PointsPlant = [PointsPlant; PointsStem];
    FacetsPlant = [FacetsPlant; FacetsStem + row];
end



