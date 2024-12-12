function [x1_filtered,y1_filtered,x2_filtered,y2_filtered] = get_inlier_points(left, strongest_left, strongest_right, selected_points, combined, inliers, suppress)
% Get the filtered x and y coordinate pairs.
%   Args:
%       left: left image (image 1)
%       strongest_left: corner points
%       strongest_right: corner points
%       combined: debug display combined left and right images
%       selected_points: matched points between left and right images
%       inliers: logical array of inlier matches
%       suppress: debug printing bool
%   Returns:
%       x1, y1, x2, y2 (_filtered): left and right points respectively

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