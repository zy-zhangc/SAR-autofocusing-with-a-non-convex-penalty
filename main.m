% Scene 1, a 32*32 simulated scene
I=zeros(32,32);
I(10:20,10)=1;
I(10:20,20)=1;
I(10,10:20)=1;
I(20,10:20)=1;
I(4,4)=1;
I(26,26)=1;
I(15,16)=1;
I(17,16)=1;  

% % Scene 2, a 64*64 crop from a real TerraSAR-X image
% I=imread('test_image.png');
% I=double(I);
% I=I/max(I(:));
% I=I(1:64,101:164);%test_image

% % Scene 3, a 64*64 crop from a real Sentinel-1 image
% I=imread('imcrop2.png');
% I=double(I);
% I=I/max(I(:));
% I=I(1:64,1:64);%imcrop2

% % Scene 4, a 128*128 crop from a simulation of sea surface
% load('B1s.mat');
% I=s(1:128,1:128);
% I=I/max(I(:));

% % Scene 5, a 128*128 crop from a simulation of sea surface (with ship wakes)
% load('gr_wake.mat');
% I=gr_wake(21:148,654:781);
% I=I/max(I(:));

% plot the original scene
figure
imagesc(abs(I));
colormap('gray')
title('Original Image')
axis off

imwrite(abs(I),'o.png');

% set parameters
a=32;%image of size axa, change needed for different scenes
M=32; %number of cross-ranges, change needed for different scenes
N=32; % number of ranges, change needed for different scenes 

% parameter settings for WAMA, Scene 1; tuning needed for other scenes
lambda=0.5;  % for magnitude Cauchy; tuning needed for other regularizers
gamma=5e-6;
% betalp=1e-12;
% betatv=5e-9;
% deltaG=0.04;
% deltaW=0.003;

% parameter settings for CFBA, Scene 1; tuning needed for other scenes
lambdaFB=1;
miuFB=2e-4;
gammaFB=7.1e-3;

% % generate the observation matrix
% T=form_SAR_projmtx(1,a,0);    
% D=Sar_FT_matrix(M,N);
% C=D*T;

% load a saved result of the observation matrix C 
% the "C" for a 64*64 scene or a 128*128 scene is too large to be uploaded to Github
load('C_32.mat');

% % generate the simulated corrupted phase history and the result of polar format algorithm
% PH_err=SAR_phase_history(I,C,M,N);

% load a saved result of "SAR_phase_history(I,C,M,N)" to fix the added phase errors and noise 
% for Scene 2, use "load('cph_t.mat');"; for Scene 3, use "load('cph_i.mat');" 
% for scene 4, use "load('cph_B1s.mat');"; for Scene 5, use "load('cph_grw.mat');"
load('cph_sim.mat'); 

% WAMA & CFBA
% IM=WAMA(C,PH_err,a,M,N,lambda,beta,delta,gamma); % WAMA
IM=CFBA(C,PH_err,a,M,N,lambdaFB,miuFB,gammaFB); %CFBA
X=abs(IM);
dif=I-X;
MSE=norm(dif,2).^2/(a*a);
E=entropy(X);