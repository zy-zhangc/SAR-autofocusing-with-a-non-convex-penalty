function PH_err=SAR_phase_history(I,C,M,N)


%I--image(field) size of (a,a)
%C--model matrix size of ((N*M),(a*a))
%The 2D phase history data (iq) are assumed to have the size (N,M)
%M--- number of cross-range positions
%N--- number of range positions

%{
a=32;
I=zeros(a,a);
I(10:20,10)=1;
I(10:20,20)=1;
I(10,10:20)=1;
I(20,10:20)=1;
I(4,4)=1;
I(26,26)=1;
I(15,16)=1;
I(17,16)=1;
I_v=reshape(I,1024,1);
%}
[a,b]=size(I); %a=b since I is a square image
I_v=reshape(I,a*a,1);
PH=C*I_v;
iq=reshape(PH,N,M);

%==========================================================================
%Phase error addition
%============================1D error
RR=abs(iq);
QQ=angle(iq);

load('pe1.mat');
Y=(-pi/2)+pi*Z;

% Y = rand(M,1);
% Y=(-pi/2)+pi*Y;
%% Y=-pi+2*pi*Y;

%x=-1:2/(a-1):1;
%y=3*x.^2; % 12x^2 
%Y=max(y)-y;

for kk=1:M
QQ(:,kk)=QQ(:,kk)+Y(kk);
end

%=============================2D separable error
%{
RR=abs(iq);
QQ=angle(iq);
Y1 = rand(M,1);
Y1=(-3*pi/4)+(3*pi/2)*Y1;
Y2 = rand(N,1);
Y2=(-3*pi/4)+(3*pi/2)*Y2;

for kk=1:M
QQ(:,kk)=QQ(:,kk)+Y1(kk); %cross-range error
end
for kk=1:N
QQ(kk,:)=QQ(kk,:)+Y2(kk);% range error
end
%}
%=============================2D nonseparable error
%{
RR=abs(iq);
QQ=angle(iq);
Y=rand(N,M);
Y=-pi+2*pi*Y;
QQ=QQ+Y;
%}
%================================
iq_err=RR.*exp(1i*QQ);
PH_err=reshape(iq_err,N*M,1);
PH_err=awgn(PH_err,25,'measured'); %noise addition
iq_err=reshape(PH_err,N,M);


IM=ifft2(iq_err);
img=flipud(IM.');
img=fftshift(img,1); % polar_format image

figure
imagesc(abs(img));
colormap('gray')
title('Polarformat Reconstruction')
axis off