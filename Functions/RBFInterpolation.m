function Pf=RBFInterpolation(dsites, rhs,epoints, rbft,ep, lambda) 

% Input 
% dsites : 주어진 데이터 위치  N* 3
% rhs : 주어진 데이터에서의 함수값
% ep :rbf 의 scale parameter 
% lambda : regularization parameter 
% rbft : rbf 선택 
% epoints : 계산하려는 위치  M*3 

% choose rbf
if strcmpi(rbft,'GA') % Gaussian RBF
    rbf = @(e,r) exp(-(e*r).^2);
elseif strcmpi(rbft,'IMQ') % inverse multiquadric RBF
    rbf = @(e,r) 1./sqrt( 1 + (e*r).^2);
end

% Compute distance matrix between the data sites and centers
ctrs = dsites;
DM_data = DistanceMatrix(dsites,ctrs);
% Compute interpolation matrix
IM = rbf(ep,DM_data) +lambda*eye(size(DM_data));

% Compute distance matrix between evaluation points and centers
DM_eval = DistanceMatrix(epoints,ctrs);
% Compute evaluation matrix
xEM = rbf(ep,DM_eval);

% Compute RBF interpolant
% (evaluation matrix * solution of interpolation system)
Pf = EM * (IM\rhs);

