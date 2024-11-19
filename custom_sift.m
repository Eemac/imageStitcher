function [final_slope, final_length, final_confidence] = custom_sift(left,right,radius,suppress)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    % radius = 8;
    % suppress = true;
    [strongest_left, strongest_right, quantity, combined] = get_corners(left, right, 500, suppress);
    [offset_left_horiz,offset_left_vert,offset_right_horiz,offset_right_vert] = get_gradients(left, right, radius, 3);
    [descriptors_right] = get_right_descriptors(strongest_right, offset_right_horiz, offset_right_vert, radius);
    [selected_points] = match_descriptors(descriptors_right, strongest_left, offset_left_horiz, offset_left_vert, quantity, radius, 20, suppress);
    [x1,y1,x2,y2] = get_match_points(left, strongest_left,strongest_right, combined, selected_points, suppress);
    [slopes, lengths, inliers] = filter_matches(x1, y1, x2, y2, 0.25, 0.25, suppress);
    final_slope = mean(slopes(inliers));
    final_length = mean(lengths(inliers));
    final_confidence = sum(inliers)/quantity;
    if ~suppress
        final_slope
        final_length
        final_confidence
    end
    [x1_filtered,y1_filtered,x2_filtered,y2_filtered] = get_inlier_points(left, strongest_left, strongest_right, selected_points, combined, inliers, suppress);
end