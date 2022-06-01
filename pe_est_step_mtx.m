function C1=pe_est_step_mtx(PH,C1,im,M,N)

Ct=C1*im;
arg=zeros(M,1);

for k=1:M
    
Mu=Ct(1+N*(k-1):N*k)'*PH(1+N*(k-1):N*k);
Re=real(Mu);
Im=imag(Mu);

arg(k)=atan2(Im,Re);

C1(1+(k-1)*N:k*N,:)=exp(1i*arg(k))*C1(1+(k-1)*N:k*N,:);
end
