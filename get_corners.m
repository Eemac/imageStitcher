function [strongest_left, strongest_right, quantity_l, quantity_r, combined] = get_corners(left, right, quantity_l, quantity_r, points, suppress)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    gray_left = im2gray(left);
    gray_right = im2gray(right);
    % corners_left = detectHarrisFeatures(gray_left,"MinQuality",0);
    % corners_right = detectHarrisFeatures(gray_right,"MinQuality",0);

    % NEW
    strongest_left=harriscorners(gray_left, points);
    strongest_right=harriscorners(gray_right, points);
    
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
    
    thresh=1;
    offset=8;
    left_mask = ~logical(ceil(conv2(uint8(gray_left<=thresh),ones(offset),"same")));
    right_mask = ~logical(ceil(conv2(uint8(gray_right<=thresh),ones(offset),"same")));

    % strongest_left = corners_left.selectStrongest(quantity_l);
    % strongest_right = corners_right.selectStrongest(quantity_r);
    strongest_left.Location = fliplr(strongest_left.Location);
    strongest_right.Location = fliplr(strongest_right.Location);

    strongest_left = strongest_left(left_mask(sub2ind(size(left_mask),round(strongest_left.Location(:,1)),round(strongest_left.Location(:,2)))));
    strongest_right = strongest_right(right_mask(sub2ind(size(right_mask),round(strongest_right.Location(:,1)),round(strongest_right.Location(:,2)))));

    inc = 100;
    strongest_left = strongest_left(1:ceil(length(strongest_left)/quantity_l/inc):end);
    strongest_right = strongest_right(1:ceil(length(strongest_right)/quantity_r/inc):end);

    quantity_l = min(quantity_l,length(strongest_left));
    quantity_r = min(quantity_r,length(strongest_right));
    quantity_l = min(quantity_l, quantity_r);

    % NEW
    strongest_left = strongest_left(1:quantity_l,:);
    strongest_right = strongest_right(1:quantity_r,:);

    if ~suppress
        plot(strongest_left.Location(:,2),strongest_left.Location(:,1),"g+");
        plot(strongest_right.Location(:,2)+size(left,2),strongest_right.Location(:,1),"g+");
        disp(quantity_l)
        disp(quantity_r)
    end
end