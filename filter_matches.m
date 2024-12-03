function [slopes, lengths, delta_x, delta_y, inliers] = filter_matches(left, x1, y1, x2, y2, slope_dev,length_dev, suppress)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    % slope_dev = 0.25;
    % length_dev = 0.25;
    slopes_modified = atan2(y2-y1,x2-x1);
    slopes = (y2-y1)./(x2-x1);
    delta_x = x2-x1;
    delta_y = y2-y1;
    lengths_modified = sqrt((y2-y1).^2.+(x2+size(left,2)-x1).^2);
    lengths = sqrt((y2-y1).^2.+(x2-x1).^2);

    m=mode(round(slopes_modified,3));
    s=slope_dev*std(slopes_modified);
    if ~suppress
        figure;
        histogram(slopes_modified)
        xline(m+s)
        xline(m-s)
    end
    slope_inliers = (m-s)<slopes_modified & slopes_modified<(m+s);

    m=mode(round(lengths_modified));
    s=length_dev*std(lengths_modified);
    if ~suppress
        figure;
        histogram(lengths_modified)
        xline(m+s)
        xline(m-s)
    end
    length_inliers = (m-s)<lengths_modified & lengths_modified<(m+s);

    inliers = slope_inliers & length_inliers;
end