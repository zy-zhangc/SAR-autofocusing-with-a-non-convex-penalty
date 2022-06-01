function IM=WAMA(C1,PH,a,M,N,lambda,gamma,betalp,betatv,deltaG,deltaW)

%C1 --- observation matrix
%PH ---- corrupted phase history
%a --- IM will be an image of size axa
%M--- number of cross-range positions
%N--- number of range positions
%lambda--- regularization parameter
%gamma--- an intrinsic parameter for magnitude Cauchy
%betalp--- an intrinsic parameter for the approximated lp norm 
%betatv--- an intrinsic parameter for the approximated TV
%deltaG--- an intrinsic parameter for l2-l0 regularization (Geman-McClure)
%deltaW--- an intrinsic parameter for l2-l0 regularization (Welsh)

p1=1;% for l_1 norm in SDA
e=1e-3;
im=C1'*PH;
PHi=PH;
error=1;
iteration=1;

C2=C1;
Ci=C1'*C1;

while (error>e)&&(iteration<300)
% Image reconstruction step 
%
% magnitude Cauchy gradient computation
s=2./((abs(im).^2)+gamma);
W=spdiags(s,0,length(s),length(s))*lambda;
%
% % approximated lp norm gradient computation (the case of SDA)
% s=p1./(((abs(im).^2)+betalp).^(1-p1/2));
% W=spdiags(s,0,length(s),length(s))*lambda;
% 
% % l2-l0 gradient (Geman-McClure) computation
% s = 4*(deltaG.^2)./(2*deltaG.^2+abs(im).^2).^2;
% W=spdiags(s,0,length(s),length(s))*lambda;
% 
% % l2-l0 gradient (Welsh) computation
% s = exp(-(abs(im).^2)/(2*deltaW.^2));
% W=lambda/(deltaW.^2)*spdiags(s,0,length(s),length(s));
% 
% % approximated TV gradient computation
% imr = reshape(im,a,a);
% tvn1 = 1./sqrt(abs(g_i(imr)).^2+abs(g_j(imr)).^2+betatv);
% tvn2 = 1./sqrt(abs(g_ij1(imr)).^2+abs(g_jj1(imr)).^2+betatv);
% tvn3 = 1./sqrt(abs(g_ii1(imr)).^2+abs(g_ji1(imr)).^2+betatv);
% 
% W1 = spdiags(tvn1(:),0,length(tvn1(:)),length(tvn1(:)));
% W2 = spdiags(tvn2(:),0,length(tvn2(:)),length(tvn2(:)));
% W3 = spdiags(tvn3(:),0,length(tvn3(:)),length(tvn3(:)));
% 
% W = (W1*D1(imr)+W1*D2(imr)+W2*D3(imr)+W3*D4(imr))*lambda;
% 
% solve the resulted linear system of equations
A_l1=2*Ci+W; 
b_l1=2*(C1'*PH);
[im_k1, error1, iter, flag] = cg(A_l1, im, b_l1, speye(a*a), 500, 1e-3);
% im_k1=A_l1\b_l1;

error=norm(im_k1-im)/norm(im)
error_list(iteration)=error;
if error<=e
    break
end

im = im_k1;

% Phase error estimation step
% C1=pe_est_step_mtx(PH,C2,im,M,N); % using matrix update
PH=pe_est_step_ph(PHi,C2,im,M,N); %using data update, since C^(phi^(n))^H*g=C^H*diag(-phi_m^(n))*g

% % compute the values of the cost function after each outer iteration
% DP=conj(PH./PHi);
% CV(iteration)=norm(PHi-diag(DP)*C1*im).^2-lambda*sum(log(gamma./(abs(im).^2+gamma.^2))); 

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
title('WAMA Reconstruction')
axis off

imwrite(X,'WAMA.png');