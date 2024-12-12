function [x1,y1,x2,y2] = get_match_points(left, strongest_left, strongest_right, combined, selected_points, suppress)
% Get the x and y coordinates for the paired points.
%   Args:
%       left: left image (image 1)
%       strongest_left: left image corner points
%       strongest_right: right image corner points
%       combined: debug display combined left and right images
%       selected_points: matched points between left and right images
%       suppress: debug printing bool
%   Returns:
%       x1, y1, x2, y2: left and right points respectively

    x1 = strongest_left.Location(selected_points(:,1),2);
    y1 = strongest_left.Location(selected_points(:,1),1);
    x2 = strongest_right.Location(selected_points(:,2),2);
    y2 = strongest_right.Location(selected_points(:,2),1);
    if ~suppress
        figure;
        imshow(combined);
        hold on;
        plot([x1,x2+size(left,2)]',[y1,y2]',"g-");
    end
end