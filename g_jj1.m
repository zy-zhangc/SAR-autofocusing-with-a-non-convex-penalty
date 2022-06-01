function z = g_jj1(f)
[a,b] = size(f);
z = zeros(a,b);
for i = 1:a
    for j = 1:b
        if (j+1>b)
            z(i,j) = 0;
        else
            z(i,j) = f(i,j+1)-f(i,j);
        end
    end
end