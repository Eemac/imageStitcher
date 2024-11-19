function [strongest_left, strongest_right, quantity, combined] = get_corners(left, right, qty, suppress)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    corners_left = detectHarrisFeatures(im2gray(left));
    corners_right = detectHarrisFeatures(im2gray(right));
    combined = zeros(size(left));
    combined = [combined combined];
    combined(1:size(left,1),1:size(left,2),1:size(left,3)) = left;
    combined(1:size(right,1),size(left,2):size(left,2)+size(right,2)-1,1:size(right,3)) = right;
    combined = uint8(combined);
    if ~suppress
        figure;
        imshow(combined);
        hold on;
    end
    quantity = qty;%500;
    strongest_left = corners_left.selectStrongest(quantity);
    strongest_right = corners_right.selectStrongest(quantity);
    strongest_left.Location = fliplr(strongest_left.Location);
    strongest_right.Location = fliplr(strongest_right.Location);
    quantity = min(quantity,min(length(strongest_right),length(strongest_left)));
    if ~suppress
        plot(strongest_left.Location(:,2),strongest_left.Location(:,1),"g+");
        plot(strongest_right.Location(:,2)+size(left,2),strongest_right.Location(:,1),"g+");
        disp(quantity)
    end
end