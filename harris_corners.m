function [corners] = harris_corners(image)
% Matches two sets of descriptors.
%   Args:
%       image: image
%   Returns:
%       corners: cornerPoints object of detected corners

    % Sobel kernel
    sobel = [
     -5 -4 0 4 5;
     -8 -10 0 10 8;
    -10 -20 0 20 10;
     -8 -10 0 10 8;
     -5 -4 0 4 5;
    ];
    % Sharpening kernel
    b = -1*ones(3);
    b(2,2) = 8;

    % Convert image to grayscale and run sharpening and then sobel
    gray_image = im2gray(image);
    gray_image = conv2(gray_image, b, "same");
    ix = zeros(size(gray_image)); % x-gradient
    iy = zeros(size(gray_image)); % y-gradient
    for i=1:size(gray_image,3)
        ix(:,:,i) = conv2(gray_image(:,:,i),sobel,"same");
        iy(:,:,i) = conv2(gray_image(:,:,i),sobel',"same");
    end
    
    k = 0.2; % Strength parameter
    ix2 = ix.^2; % Squared x-gradient
    iy2 = iy.^2; % Squared y-gradient
    ixiy = ix.*iy; % Squared xy-gradient

    % Gaussian kernel
    g = [
        1 4 7 4 1;
        4 20 33 20 4;
        7 33 55 33 7;
        4 20 33 20 4;
        1 4 7 4 1;
        ];

    % Convolve gaussian with gradients to create smoothed region
    mix2 = conv2(ix2,g,"same");
    miy2 = conv2(iy2,g,"same");
    mixiy = conv2(ixiy,g,"same");

    % Harris corner approximation
    m = mix2.*miy2-mixiy.^2 - k*(mix2+miy2).^2;

    % Return cornerpoints
    idx = [(1:numel(m))',reshape(m,[],1)];
    idx = sortrows(idx,2,"descend");
    [row,col] = ind2sub(size(m),idx(:,1));
    corners = cornerPoints([col,row]);
end

