function [offset_left_horiz,offset_left_vert,offset_right_horiz,offset_right_vert] = get_gradients(left, right, radius, sigma)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    sobel = [-1 -2 -1; 0 0 0; 1 2 1];
    offset_left_horiz = zeros(size(left,1:2)+[2*radius,2*radius]);
    offset_left_vert = zeros(size(left,1:2)+[2*radius,2*radius]);
    offset_left_horiz(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(left,sigma)),sobel',"same");
    offset_left_vert(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(left,sigma)),sobel,"same");
    offset_right_horiz = zeros(size(right, 1:2)+[2*radius,2*radius]);
    offset_right_vert = zeros(size(right, 1:2)+[2*radius,2*radius]);
    offset_right_horiz(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(right,sigma)),sobel',"same");
    offset_right_vert(radius+1:end-radius,radius+1:end-radius) = conv2(im2gray(imgaussfilt(right,sigma)),sobel,"same");
end