%% Ensure to put necessary data files and function files in the folders

clear; close all;clc;

%% linking data and function files and loading data

addpath Data 
addpath functions
 
load gdirt
load rho4000

%% selecting a brain slice 

nth_sl=24;

%% choosing locations on qball

t_idx=size(gdirt,1); 

%% creating ODF

% selecting a q-ball location on the selected slice
ii=29; ij=16; 

% selecting a lambda for regularization
Lambda = 0.0001; 

% extracting signal at (ii,jj) for all loactions on q-ball
tS=squeeze(rho4000(ii,ij,nth_sl, 1:t_idx));

% finding ODF values
[ODFtS]=mkODF(gdirt,tS,Lambda); 

% plotting ODF 
figure(2); plotQBI(ODFtS,1);
title('ODF(tS)');

%% Red direction only
idx = 1:2:t_idx; %red 120 directions
red_dir = gdirt(idx, :);
redS = squeeze(rho4000(ii, ij, nth_sl, idx));
[ODFtR] = mkODF(red_dir, redS, Lambda);
figure(3); plotQBI(ODFtR, 1);
title('ODF (tR)')