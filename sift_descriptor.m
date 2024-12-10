function descriptor = sift_descriptor(horiz, vert, minxy, maxxy, idx, rad)
% Extract a SIFT-like descriptor from an image.
%   Args:
%       horiz: horizontal gradients in the image
%       vert: vertical gradients in the image
%       minxy: (locations, 2) vector of the top-left corners of descriptors
%       maxxy: (locations, 2) vector of the bottom-right corners of the
%       descriptors
%       idx: index for the specific location
%       rad: radius of the descriptor
%   Returns:  
%       descriptor: SIFT-like descriptor

    % Extract linearly spaced subpoints for the 4x4 grids
    idcisx = linspace(minxy(idx,1),maxxy(idx,1),5);
    idcisy = linspace(minxy(idx,2),maxxy(idx,2),5);
    % Initialize direction vectors
    angxy = [1 0.70710678118 0 -0.70710678118 -1 -0.70710678118  0  0.70710678118;
             0 0.70710678118 1  0.70710678118  0 -0.70710678118 -1 -0.70710678118];
    % Save descriptor region
    edgexy = zeros([2*rad+1,2*rad+1,2]);
    edgexy(:,:,1) = horiz(idcisx(1):idcisx(end),idcisy(1):idcisy(end));
    edgexy(:,:,2) = vert(idcisx(1):idcisx(end),idcisy(1):idcisy(end));
    % Apply projection onto direction vectors
    gradxy = reshape(reshape(edgexy,[],2)*angxy,2*rad+1,2*rad+1,[]);
    % Shift grid indices to start at 1
    temp_des = zeros(4,4,8);
    idcisx = idcisx+1-idcisx(1);
    idcisy = idcisy+1-idcisy(1);
    % Extract the regional/grid descriptors
    for i=1:4
        for j=1:4
            temp_des(i,j,:) = sum(gradxy(idcisx(i):idcisx(i+1),idcisy(j):idcisy(j+1),:),1:2);
        end
    end
    % Reshape the final descriptor
    descriptor = reshape(temp_des,[],1);
end