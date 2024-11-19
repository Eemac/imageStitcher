function [x1_filtered,y1_filtered,x2_filtered,y2_filtered] = get_inlier_points(left, strongest_left, strongest_right, selected_points, combined, inliers, suppress)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    x1_filtered = strongest_left.Location(selected_points(inliers,1),2);
    y1_filtered = strongest_left.Location(selected_points(inliers,1),1);
    x2_filtered = strongest_right.Location(selected_points(inliers,2),2)+size(left,2);
    y2_filtered = strongest_right.Location(selected_points(inliers,2),1);
    if ~suppress
        figure;
        imshow(im2gray(combined));
        hold on;
        plot([x1_filtered,x2_filtered]',[y1_filtered,y2_filtered]',"-");
        colororder("meadow");
    end
end