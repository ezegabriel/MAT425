clear; close all;clc;

addpath Data 
addpath Functions

%% create images and save

% load('20081006_M025Y_1Shell.mat')
% 
% bsize = size(b_table);  
% for i=1:bsize(2)
% eval(strcat('images(:,:,:,i) = reshape(image',int2str(i-1),',dimension);'));
% end
% 
% 
% fprintf('size of the data \n');
% size(images)
% gdirt=b_table(2:4, 11:250)'; 
% rho4000=images(:,:,:, 11:250); % signal data corresponding to 96, 96, 40
% clear

%% load data

load gdirt
load rho4000

%% step 3: preparing data

num_directions=size(gdirt,1); % Total number of signal directions

vgdirt = gdirt(1:2:63, :);
ugdirt = gdirt(2:2:64, :)


% produce 32 indices array for ugdirt and vgdirt

% extend total directions for complete ball
etgdirt = [vgdirt; -vgdirt; ugdirt; -ugdirt];
% Red and blue directions

set(gcf, 'color', 'white'); 
figure(1);plotSphNodes2(vgdirt,[],ugdirt,[],[],[]);
title('Visualization of Selected Diffusion Directions')
figure(2)
image(rho4000(:, :, 20, 9))


%% step 4: analyzing slices

% signal value corresponding 96x96 20th slice and 9th DG direction
vS=rho4000(:,:,20, 9);



for nsl=1:22
figure(nsl)
image(rho4000(:, :, nsl, 9))
end

%% step 5: preprocession - removing non-brain regions
selected_slice = rho4000(:, :, 20, 9);
threshold = 80; %adjust as necessary
mask = selected_slice < threshold;
selected_slice(mask) = 0;
figure(3)
image(selected_slice)

%%
vS = rho4000(:, :, 20, 9)
