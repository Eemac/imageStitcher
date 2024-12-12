function [final_delta_x, final_delta_y, final_confidence] = custom_sift(input_left, input_right, radius, scale, suppress)
% Run the SIFT and matching algorithms to calculate the transforms between
% two images.
%   Args:
%       input_left: left image (image 1)
%       input_right: right image (image 2)
%       radius: radius of the descriptor
%       scale: scalar for number of points to evaluate
%       suppress: debug printing bool
%   Returns:
%       final_delta_x: per pair x difference
%       final_delta_y: per pair y difference
%       final_confidence: confidence of overall match

    % Set the left image as the smaller one by area
    left = input_left;
    right = input_right;
    area_left = size(left,1)*size(left,2);
    area_right = size(right,1)*size(right,2);
    flipped = false;

    % Compute the quantities of points of interest as a function of scale
    % and area
    if area_left<area_right
        quantity_l = round(scale*sqrt(area_left));
        quantity_r = round(scale*sqrt(area_right));
    else
        temp = left;
        left = right;
        right = temp;
        quantity_l = round(scale*sqrt(area_right));
        quantity_r = round(scale*sqrt(area_left));
        flipped = true;
    end

    % Get and filter the corner points
    [strongest_left, strongest_right, quantity_l, quantity_r, combined] = get_corners(left, right, quantity_l, quantity_r, suppress);
    % Get the image gradients
    [offset_left_horiz,offset_left_vert,offset_right_horiz,offset_right_vert] = get_gradients(left, right, radius, 3, suppress);
    % Get the point descriptors
    [descriptors_right] = get_right_descriptors(strongest_right, offset_right_horiz, offset_right_vert, radius, suppress);
    [descriptors_left] = get_left_descriptors(strongest_left, offset_left_horiz, offset_left_vert, radius);
    % Match the descriptors across points
    [selected_points] = match_descriptors(descriptors_left, descriptors_right, quantity_l, quantity_r, 20, suppress);
    % Extract the matched points
    [x1,y1,x2,y2] = get_match_points(left, strongest_left,strongest_right, combined, selected_points, suppress);
    % Filter the matches based on consensus
    [delta_x, delta_y, inliers] = filter_matches(left, x1, y1, x2, y2, 0.15, 0.15, suppress);
    % Flip the transform back
    final_delta_x = ((-1)^flipped)*mean(delta_x(inliers));
    final_delta_y = ((-1)^flipped)*mean(delta_y(inliers));
    % Calculate the confidence relative to inliers, points of interest, and
    % matches found
    final_confidence = sum(inliers)^2/(min(quantity_l,quantity_r)*length(selected_points));
    % Extract the inlier points
    [x1_filtered,y1_filtered,x2_filtered,y2_filtered] = get_inlier_points(left, strongest_left, strongest_right, selected_points, combined, inliers, suppress);
    if ~suppress
        disp(final_delta_x)
        disp(final_delta_y)
        disp(final_confidence)
    end
end