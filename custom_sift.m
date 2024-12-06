function [final_slope, final_length, final_delta_x, final_delta_y, final_confidence] = custom_sift(input_left,input_right,radius,points,suppress)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    % radius = 8;
    % suppress = true;
    left = input_left;
    right = input_right;
    area_left = size(left,1)*size(left,2);
    area_right = size(right,1)*size(right,2);
    flipped = false;
    if area_left<area_right
        quantity_l = round(points*sqrt(area_left));
        quantity_r = round(points*sqrt(area_right));
    else
        temp = left;
        left = right;
        right = temp;
        quantity_l = round(points*sqrt(area_right));
        quantity_r = round(points*sqrt(area_left));
        flipped = true;
    end
    [strongest_left, strongest_right, quantity_l, quantity_r, combined] = get_corners(left, right, quantity_l, quantity_r, suppress);
    [offset_left_horiz,offset_left_vert,offset_right_horiz,offset_right_vert] = get_gradients(left, right, radius, 3);
    [descriptors_right] = get_right_descriptors(strongest_right, offset_right_horiz, offset_right_vert, radius);
    [selected_points] = match_descriptors(descriptors_right, strongest_left, offset_left_horiz, offset_left_vert, quantity_l, quantity_r, radius, 20, suppress);
    [x1,y1,x2,y2] = get_match_points(left, strongest_left,strongest_right, combined, selected_points, suppress);
    [slopes, lengths, delta_x, delta_y, inliers] = filter_matches(left, x1, y1, x2, y2, 0.15, 0.15, suppress);
    final_slope = 0;%mean(slopes(inliers));
    final_length = 0;%mean(lengths(inliers));
    final_delta_x = ((-1)^flipped)*mean(delta_x(inliers));
    final_delta_y = ((-1)^flipped)*mean(delta_y(inliers));
    final_confidence = sum(inliers)^2/(min(quantity_l,quantity_r)*length(selected_points));
    if ~suppress
        final_slope
        final_length
        final_delta_x
        final_delta_y
        final_confidence
    end
    [x1_filtered,y1_filtered,x2_filtered,y2_filtered] = get_inlier_points(left, strongest_left, strongest_right, selected_points, combined, inliers, suppress);
end