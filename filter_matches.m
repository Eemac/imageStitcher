function [slopes, lengths, inliers] = filter_matches(x1, y1, x2, y2, slope_dev,length_dev, suppress)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    % slope_dev = 0.25;
    % length_dev = 0.25;
    slopes = (y2-y1)./(x2-x1);
    lengths = sqrt((y2-y1).^2.+(x2-x1).^2);

    m=mode(round(slopes,1));
    s=slope_dev*std(slopes);
    if ~suppress
        figure;
        histogram(slopes)
        xline(m+s)
        xline(m-s)
    end
    slope_inliers = (m-s)<slopes & slopes<(m+s);

    m=mode(round(lengths,-1));
    s=length_dev*std(lengths);
    if ~suppress
        figure;
        histogram(lengths)
        xline(m+s)
        xline(m-s)
    end
    length_inliers = (m-s)<lengths & lengths<(m+s);

    inliers = slope_inliers & length_inliers;
end