function [ODF]=mkODF(grad,rho_vec, Lambda)                           
% Lambda=='op'; find the optimal Lambda

V = load('724_shell.txt');
% --- real spherical harmonic reconstruction: parameters definition --- %

[Lmax Nmin] = obtain_Lmax(grad);
if Lmax >= 8
    Lmax = 8;
end
%display(['The maximum order of the spherical harmonics decomposition is Lmax = ' num2str(Lmax) '.']);

[basisG, thetaG, phiG] = construct_SH_basis (Lmax, grad, 2, 'real');
[basisV, thetaV, phiV] = construct_SH_basis (Lmax, V, 2, 'real');
K = []; Laplac2 = [];
for L=0:2:Lmax
    for m=-L:L
        % factor1 = ((-1)^(L/2))*doublefactorial(L+1)./( (L+1)*doublefactorial(L) );
        Pnm = legendre(L,0); factor1 = Pnm(1);
        K = [K; factor1];
        Laplac2 = [Laplac2; (L^2)*(L + 1)^2];
    end
end
Laplac = diag(Laplac2);

%% get optimal Lambda using regu
A=basisG;
b=rho_vec;
if Lambda=='op'
  
    [l1,l2]=size(Laplac);
    L=Laplac(2:l1,:); % Laplac is singular since a_{11}=0
    L=sqrt(L);
    [U,sm,X,V,W] = cgsvd(A,L);
    [reg_min,G,reg_param] = gcv(U,sm,b,'Tikh');
    Lambda=reg_min;
end

%% - Regularized ODF from the noised signal
% Creating the kernel for the reconstruction
IB = recon_matrix(basisG,Laplac,Lambda);
% where IB = inv(Ymatrix'*Ymatrix + Lambda*Laplacian)*Ymatrix';
% and Ymatrix = basisG.
% The matrix, IB, is the same for all the voxels
%a=cond(basisG);
%fprintf('Condition number: %.0f \n', a);
%display('This is the real/effective time required for computing the ODF at each voxel:')

coeff = IB*b; 
ss = coeff.*K;
ODF = basisV*ss;


% %% - ODF from the signal without noise
% A0 = recon_matrix(basisG,Laplac,0);
% coeff0 = A0*S;
% ss0 = coeff0.*K;
% ODFnnoise = basisV*ss0;

