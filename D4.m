function D = D4(f)
[a,b] = size(f);
c = a*b;
D = zeros(c,c);
for i = 1:c
   if (rem(i,a))
        D(i,i+1)=-1;
        D(i,i)=1;
   end
end