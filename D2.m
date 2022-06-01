function D = D2(f)
[a,b] = size(f);
c = a*b;
D = zeros(c,c);
for i = 1:c
   if (i>a)
       D(i,i) = 1;
       D(i,i-a) = -1;
   end
end