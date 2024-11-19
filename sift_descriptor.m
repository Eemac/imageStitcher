function descriptor = sift_descriptor(horiz, vert, minxy, maxxy, idx, rad)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    idcisx = linspace(minxy(idx,1),maxxy(idx,1),5);
    idcisy = linspace(minxy(idx,2),maxxy(idx,2),5);
    angxy = [1 0.70710678118 0 -0.70710678118 -1 -0.70710678118  0  0.70710678118;
             0 0.70710678118 1  0.70710678118  0 -0.70710678118 -1 -0.70710678118];
    edgexy = zeros([2*rad+1,2*rad+1,2]);
    edgexy(:,:,1) = horiz(idcisx(1):idcisx(end),idcisy(1):idcisy(end));
    edgexy(:,:,2) = vert(idcisx(1):idcisx(end),idcisy(1):idcisy(end));
    gradxy = reshape(reshape(edgexy,[],2)*angxy,2*rad+1,2*rad+1,[]);
    temp_des = zeros(4,4,8);
    idcisx = idcisx+1-idcisx(1);
    idcisy = idcisy+1-idcisy(1);
    for i=1:4
        for j=1:4
            temp_des(i,j,:) = sum(gradxy(idcisx(i):idcisx(i+1),idcisy(j):idcisy(j+1),:),1:2);
        end
    end
    descriptor = reshape(temp_des,[],1);
end