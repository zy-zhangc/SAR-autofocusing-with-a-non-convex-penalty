function z = g_ij1(f)
[a,b] = size(f);
z = zeros(a,b);
for i = 1:a
    for j = 1:b
        if (j+1>b)||(i-1==0)
            z(i,j) = 0;
        else
            z(i,j) = f(i,j+1)-f(i-1,j+1);
        end
    end
end