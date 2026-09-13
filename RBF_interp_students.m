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
idx=1:2:t_idx; % indices for red locations on q-ball (signal measured)
uidx = setdiff(1:size(gdirt,1), idx); % indices for blue locations on q-ball (signal estimated)

vgdirt=gdirt(idx,:); % red locations on q-ball

ugdirt=gdirt(uidx,:); % blue locations on q-ball

set(gcf, 'color', 'white'); % visualizing red/blue locations on q-ball
figure(1);plotSphNodes2(vgdirt,[],ugdirt,[],[],[]);

axis off image;

%% creating ODF

% selecting a q-ball location on the selected slice
ii=23; ij=12; 

% selecting a lambda for regularization (SH)
Lambda = 0.0001; 

% extracting signal at (ii,jj) for all loactions on q-ball
tS=squeeze(rho4000(ii,ij,nth_sl, 1:t_idx));
vS=squeeze(rho4000(ii,ij,nth_sl, idx));
uS=squeeze(rho4000(ii,ij,nth_sl, uidx)); % measured blue signal

% finding ODF values
[ODFtS]=mkODF(gdirt,tS,Lambda); 
[ODFvS]=mkODF(vgdirt,vS,Lambda); 

% plotting ODF 
figure(2); plotQBI(ODFtS,1);
title('ODF(tS)');

figure(3); plotQBI(ODFvS,1);
title('ODF(vS)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% get green data: (x,y,z) of the green dot and corresponding signal

% parameters for cm
irad=1;
cut=0.01;

[cmdirt,cmval]=get_cm(gdirt,idx,rho4000,nth_sl,ii,ij,cut);
fprintf( 'The number of cm at (%d,%d) is %.0f \n', ii, ij, length(cmval));

%% RBF interpolation

% extend/combine directions and signals

rgb_directions = [vgdirt; -vgdirt ; cmdirt ; -cmdirt; ugdirt;-ugdirt];
rg_directions = [vgdirt;-vgdirt ; cmdirt ; -cmdirt];
rg_signal = [vS;vS ; cmval ; cmval];

% parameters for RBF
rbft='GA';  lambda=0.0001; 

K_cm = convhulln(rgb_directions);
RV = ugdirt;
            
%cm
ep_opt01=LOOCV3Dmin(rg_directions, rg_signal, rbft) ;
estimated_bS=RBFInterpolation(rg_directions, rg_signal,RV, rbft,ep_opt01, lambda) ;

trisurf(K_cm, rgb_directions(:,1), rgb_directions(:,2), rgb_directions(:,3));  

%% Quiz 13
dsites = [0 0;1 0; 0 1];
rhs = [1;2;3];
epoints = [.5 .5];
ep = 1;
lambda = 0;
rbft = 'GA';

pf = RBFInterpolation(dsites, rhs, epoints, rbft, ep, lambda)

%% 2 brain locations

l2_error = norm(uS - estimated_bS, 2);
voxels = [23, 12; 30, 18]; % Example locations

for k = 1:size(voxels, 1)
    ii = voxels(k, 1); 
    ij = voxels(k, 2);
    
    % Extract signals for current voxel
    vS = squeeze(rho4000(ii, ij, nth_sl, idx));
    uS = squeeze(rho4000(ii, ij, nth_sl, uidx));
    
    % --- Rest of the existing code (get_cm, RBF interpolation) ---
    [cmdirt, cmval] = get_cm(gdirt, idx, rho4000, nth_sl, ii, ij, cut);
    estimated_bS = RBFInterpolation(rg_directions, rg_signal, ugdirt, rbft, ep_opt01, lambda);
    
    % Compute L2 error
    l2_error = norm(uS - estimated_bS, 2);
    fprintf('L2 error at voxel (%d, %d): %.4f\n', ii, ij, l2_error);
end

%% ODF comparison

stacked_signal = [vS; estimated_bS];
[~, dirs_240] = sphere(240);  

% Construct ODF 
ODF_stacked = mkODF([vgdirt; ugdirt], stacked_signal, Lambda);

ODFtS_resampled = mkODF(dirs_240, tS(1:240), Lambda); 

% Calculate L2 error
odf_l2_error = norm(ODF_stacked - ODFtS_resampled, 2);


figure(4);
subplot(1,2,1); plotQBI(ODF_stacked, 1); 
title('ODF (Stacked Signal)');

subplot(1,2,2); plotQBI(ODFtS, 1); 
title('ODF (Ground Truth: tS)');