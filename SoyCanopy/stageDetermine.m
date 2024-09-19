
% this function get a matrix of Vx for all plants in a canopy. 
% Vx is a double value. 



function [Vx_matrix S_matrix] = stageDetermine (DOY, m_Vx, m_Senesense, CanopyRowNum, plantNumPerBed)

% convert DOY to row number of m_Vx matrix
ind_DOY = (DOY - 168) / 3 +1;

% get total senesense leaf number
sens_leaf_num = sum(m_Senesense(1:ind_DOY,2));

b_matrix = rand(int8(CanopyRowNum), int8(plantNumPerBed));  % 0~1 number

% get Vx mean and Vx std for current DOY.
Vx_mean = m_Vx(ind_DOY,2);
Vx_std  = m_Vx(ind_DOY,3);

% randomize a normal distribution for Vx under a certain DOY.
a_matrix = randn(int8(CanopyRowNum), int8(plantNumPerBed));

% initialize a empty matrix for output of all Vx for all the plants in this
% canopy.
Vx_matrix = zeros(int8(CanopyRowNum), int8(plantNumPerBed));

for i = 1:CanopyRowNum
    for j = 1:plantNumPerBed
        a = a_matrix(i,j);
        % get the Vx for each plant
        Vx = Vx_mean + a * Vx_std;
        % put into output matrix
        Vx_matrix (i,j) = Vx;

        
        % Senensence Algorithm: 
        % use random number b to determine weather the leaf drop or not
        % eg. when sens_leaf_num is 2.6, the first two leaves drop and 60%
        % probility drop the third leaf. Here, we rand a value 'b' in uniform
        % distribution between 0 and 1; when b<0.6, drop 2 leaves and when
        % b>0.6, drop 3 leaves. 
        
        b = b_matrix(i,j);
        if (b< (sens_leaf_num - floor(sens_leaf_num)))
            S_matrix(i,j) = floor(sens_leaf_num)+1; 
        else
            S_matrix(i,j) = floor(sens_leaf_num);
        end
        
        
    end
end

Vx_matrix (Vx_matrix<1) = 1;

end

