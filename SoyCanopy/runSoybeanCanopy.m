

% script to run soybean model
clc
clear all
close all
clc

addpath ('./matlab_Git');

% SoybeanCanopy(intputMDfile, M_Vx_file, DOY, repeat, isview)
% M_Vx_file is the 'M_mean.txt'
% DOY of a int number
% repeat: a int number
% isview: true or false

% eg. 

for DOY = 168:21:168
    SoybeanCanopy('M_mean.txt', 'M_Vx.txt', DOY, 100, true)
end


