function IM=CFBA(C1,PH,a,M,N,lambdaFB,miuFB,gammaFB)

%C1 --- observation matrix
%PH ---- corrupted phase history 
%a --- IM will be an image of size axa
%M--- number of cross-range positions
%N--- number of range positions
%lambdaFB--- regularization parameter
%miuFB--- half of the step size for the complex FB splitting algorithm
%gammaFB--- an intrinsic parameter for magnitude Cauchy

e=1e-3;
im=C1'*PH;
PHi=PH;
error=1;
iteration=1;
im_k0=im;
o=im;
oz=im;

C2=C1;
Ci=C1'*C1;

while (error>e)&&(iteration<300)
    
% Image reconstruction step
ro=1;
iterfb=1;
while (ro>e)&&(iterfb<500) 
        gradF1 = @(x) Ci*x-C1'*PH;
        y2 = o - 2*miuFB*gradF1(o);
        rho = abs(y2);
        unc = y2./rho;
        
        % magnitude Cauchy        
        p = gammaFB.^2+2*lambdaFB*miuFB-(rho.^2)/3;
        q = rho*gammaFB.^2+2*(rho.^3)/27-rho*(gammaFB.^2+2*lambdaFB*miuFB)/3;
        cs = q/2+sqrt((p.^3)/27+(q.^2)/4);
        ct = q/2-sqrt((p.^3)/27+(q.^2)/4);
        s = nthroot(cs,3);
        t = nthroot(ct,3);
        xm = rho/3+s+t;
        
        im = xm.*unc; 
        o = im;
        
        ro = norm(o-oz)/norm(oz);
        oz = o;
        
        if ro<=e
         break
        end
        
        clear gradF1;
        clear proxF2;
        iterfb = iterfb+1;
end

error=norm(im-im_k0)/norm(im_k0)
error_list(iteration)=error;
if error<=e
    break
end

im_k0 = im;

% Phase error estimation step
%C1=pe_est_step_mtx(PH,C2,im,M,N); % using matrix update
PH=pe_est_step_ph(PHi,C2,im,M,N); %using data update

% % compute the values of the cost function after each outer iteration
% DP=conj(PH./PHi);
% CV(iteration)=norm(PHi-diag(DP)*C1*im).^2-lambdaFB*sum(log(gamma./(abs(im).^2+gamma.^2)));

iteration=iteration+1;
end

% % plot the values of the cost function
% index=1:(iteration-1);
% plot(index,CV);

% plot the autofocused SAR image
IM=reshape(im,a,a);
X=abs(IM);

figure
imagesc(X);
colormap('gray')
title('CFBA Reconstruction')
axis off

imwrite(X,'CFBA.png');