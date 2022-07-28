function T=form_SAR_projmtx(resol_pixsp_ratio,image_size,approx_level)

% function T=form_SAR_projmtx(resol_pixsp_ratio,image_size,approx_level);
%
% forms a SAR projection operator
%
% resol_pixsp_ratio : ratio of pixel spacing to Rayleigh resolution
%                     (i.e. oversampling ratio)
%                     needs to be >1 when seeking superresoution
% image_size        : integer indicating no. of pixels in each dimension
%                     (so the image is [image_size x image_size] pixels
% approx_level      : neglect elements in T whose magnitudes are less than this 
%                     percentage of the maximum value (in a particular column). 
%                     Lower percentage gives better accuracy, higher percentage
%                     give better sparsity. For exact T, set approx_level=0.
%                     should take values in [0,100]
%
% Mujdat Cetin  -- mcetin@bu.edu
                      

a=resol_pixsp_ratio;

c=3e8; %speed of electromagnetic waves in m/s
w0=2*pi*1e10/a; %chirp carrier frequency in rad/s
Tp=4e-4; %pulse duration in sec
fd=1e12/a; %chirp rate in Hz/sec.
wd=2*pi*fd;
B=fd*Tp; %bandwidth of transmitted chirp in Hz.
rangeres=c/(2*B); %range resolution in meters


%sampling rate of the original field can be controlled by 
%setting the pixel spacing to be a fraction of the resolution 
pixsp=rangeres/a;


D=pixsp*image_size; %patch diameter in meters

r0=D/2; %scene center in meters

%data sampling rate, (sampling in t, equivalently in the spatial 
%frequency) can be controlled by setting fs to be a multiple 
%of 2*D*fd/c. For example if we set this multiple to be 2, the 
%Fourier reconstructed field would have a diameter of 2*D.
fs=2*D*fd/c; %sampling rate in Hz.  

Tsamp=1/fs; 

N=image_size; %number of data samples at each transmission point

Ns=Tp/Tsamp;

Nang=Ns;

%set azimuth resolution equal to range resolution
azres=rangeres;

%ang=0:180/Nang:180;
%ang=-1.17:2.34/Nang:1.17;

angcoverage=180*c/(w0*azres);

ang=-angcoverage/2:angcoverage/Nang:angcoverage/2;
ang=ang(1:Nang);

%change the aspect angle
%ang=ang+30


%azres=2*pi*c/w0/(2*pi/180*(ang(Nang)-ang(1)));


r=-D/2:pixsp:D/2;
r=r+pixsp/2; 
r=r(1:N);

t=-Tp/2:Tsamp:Tp/2;
%t=D/c-Tp/2:Tsamp:Tp/2-D/c;
t=t(1:Ns);

w=2/c*(w0+wd*t);

%x=linspace(D/2-pixsp/2,-D/2+pixsp/2,N);
%y=linspace(D/2-pixsp/2,-D/2+pixsp/2,N);

x=linspace(D/2,-D/2+pixsp,N);
y=linspace(D/2-pixsp,-D/2,N);

[X,Y]=meshgrid(x,y);
rr=[X(:)';Y(:)'];

T=spalloc(Ns*Nang,N*N,ceil(Ns*Nang*N*N*0.07));

for ind=1:length(rr(1,:))
ycTtemp=zeros(Ns,Nang);
 [th,ri]=cart2pol(rr(1,ind),rr(2,ind));
 for k=1:Nang
  phi1d=-w*(ri)*cos(th+ang(k)*pi/180);
  yc1d=exp(sqrt(-1)*phi1d); %1D return at each transmission point
%this conj stuff is just to be consistent with previous weird convention
  yc1d_fft=fftshift(ifft(fftshift(conj(yc1d))));
  ycTtemp(:,k)=conj(yc1d_fft)'; %2D data
end;

Ttempcol=ycTtemp(:);


Ttempcol=approx(Ttempcol,approx_level);

T(:,ind)=Ttempcol;

clc
  disp(['Percent Done: ',int2str(ind/length(rr(1,:))*100)])
end;




