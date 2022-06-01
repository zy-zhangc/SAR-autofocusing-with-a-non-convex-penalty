function D = D3(f)
[a,b] = size(f);
c = a*b;
D = zeros(c,c);
for i = 1:c
   if (i<=c-a)
        D(i,i+a)=-1;
        D(i,i)=1;
   end
end