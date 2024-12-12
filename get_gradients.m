function [offset_left_horiz,offset_left_vert,offset_right_horiz,offset_right_vert] = get_gradients(left, right, radius, sigma, suppress)
% Get the left and right image gradients offset by the radius of the
% descriptor.
%   Args:
%       left: left image (image 1)
%       right: right image (image 2)
%       radius: radius of the descriptor
%       sigma: gaussian blur sigma for preprocessing
%       suppress: debug printing bool
%   Returns:
%       offset_(left/right)_(horiz/vert): all four left, right, horizontal,
%       and vertical gradients.

    sobel = [-1 -2 -1; 0 0 0; 1 2 1];
    offset_left_horiz = zeros(size(left,1:2)+[2*radius,2*radius]);
    offset_left_vert = zeros(size(left,1:2)+[2*radius,2*radius]);
    offset_left_horiz(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(left,sigma)),sobel',"same");
    offset_left_vert(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(left,sigma)),sobel,"same");
    offset_right_horiz = zeros(size(right, 1:2)+[2*radius,2*radius]);
    offset_right_vert = zeros(size(right, 1:2)+[2*radius,2*radius]);
    offset_right_horiz(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(right,sigma)),sobel',"same");
    offset_right_vert(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(right,sigma)),sobel,"same");
    if ~suppress
        figure;
        imshow(offset_left_vert)
        figure;
        imshow(offset_left_horiz)
        figure;
        imshow(offset_right_vert)
        figure;
        imshow(offset_right_horiz)
    end
end