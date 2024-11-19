function [x1,y1,x2,y2] = get_match_points(left, strongest_left,strongest_right, combined, selected_points, suppress)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    x1 = strongest_left.Location(selected_points(:,1),2);
    y1 = strongest_left.Location(selected_points(:,1),1);
    x2 = strongest_right.Location(selected_points(:,2),2)+size(left,2);
    y2 = strongest_right.Location(selected_points(:,2),1);
    if ~suppress
        figure;
        imshow(combined);
        hold on;
        plot([x1,x2]',[y1,y2]',"g-");
    end
end