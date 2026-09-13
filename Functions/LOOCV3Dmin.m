function ep_optimal=LOOCV3Dmin(dsites, rhs, rbft) 
% Script that performs leave-one-out cross-validation
% (Rippa's method) to find a good epsilon for 2D RBF interpolation
% with the help of Matlab's fminbnd
% Calls on: DistanceMatrix
% Requires: CostEpsilon
  
% choose rbf
if strcmpi(rbft,'GA') % Gaussian RBF
    rbf = @(e,r) exp(-(e*r).^2);
elseif strcmpi(rbft,'IMQ') % inverse multiquadric RBF
    rbf = @(e,r) 1./sqrt( 1 + (e*r).^2);
end
% Parameters for shape parameter optimization below
mine = 0; maxe = 40;
% Compute distance matrix between the data sites and centers
ctrs = dsites;   % centers coincide with data sites
% Compute distance matrix between the data sites and centers
DM_data = DistanceMatrix(dsites,ctrs);
[ep_optimal,fval] = fminbnd(@(ep) CostEpsilon(ep,DM_data,rbf,rhs),...
    mine,maxe);
% fprintf('Smallest maximum norm: %e\n', fval)
% fprintf('at epsilon = %f\n', ep_optimal)
 