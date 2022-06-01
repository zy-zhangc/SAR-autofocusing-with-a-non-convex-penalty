function z = g_ji1(f)
[a,b] = size(f);
z = zeros(a,b);
for i = 1:a
    for j = 1:b
        if (i+1>a)||(j-1==0)
            z(i,j) = 0;
        else
            z(i,j) = f(i+1,j)-f(i+1,j-1);
        end
    end
end