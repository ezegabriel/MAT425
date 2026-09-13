%% Project:   High Angular Resolution Diffusion Imaging Tools
% Function to compute the hardi-matrix used in the spherical harmonic inversion
% ---------------------
% A = inv(Y'*Y + Lambda*Laplacian)*Y';
% where Y = Ymatrix
% ---------------------
%  Language:  MATLAB(R)
%  Author:  Erick Canales-Rodríguez, Lester Melie-García, Yasser Iturria-Medina, Yasser Alemán-Gómez
%  Date: 2013, Version: 1.2          
% 
% See also test_DSI_example, test_DOT_example, test_QBI_example,
% test_DOT_R1_example, test_DOT_R2_vs_CSA_QBI_example.

function A = recon_matrix(Y,L,Lambda)

YY = Y'*Y;
N = size(Y,1);
I = diag(ones(N,1));
A = (YY + Lambda*L)\Y';
return
