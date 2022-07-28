function D=Sar_FT_matrix(M,N)
A=dftmtx(N);
%Ainv = conj(A)/N;
D1=zeros(M*N,M*N);

for i=1:M
    %D1((1+(i-1)*N):N*i,(1+(i-1)*N):N*i)=Ainv;
    D1((1+(i-1)*N):N*i,(1+(i-1)*N):N*i)=A;
end
D=sparse(D1);
