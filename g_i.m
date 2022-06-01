function z = g_i(f)
[a,b] = size(f);
z = zeros(a,b);
for i = 1:a
    for j = 1:b
        if (i-1==0)
            z(i,j) = 0;
        else
            z(i,j) = f(i,j)-f(i-1,j);
        end
    end
end