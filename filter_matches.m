function [delta_x, delta_y, inliers] = filter_matches(x1, y1, x2, y2, slope_dev, length_dev, suppress)
% Filter the matches based on their consensus.
%   Args:
%       left: left image (image 1)
%       x1, y1, x2, y2: left and right points respectively
%       slope_dev: acceptable standard deviation range of slope
%       length_dev: acceptable standard deviation range of length
%       suppress: debug printing bool
%   Returns:
%       delta_x: per pair x difference
%       delta_y: per pair y difference
%       inliers: logical array of inlier matches

    % Calculate slopes and lengths
    delta_x = x2-x1;
    delta_y = y2-y1;
    slopes_modified = atan2(delta_y,delta_x);
    lengths_modified = sqrt(delta_y.^2.+(x2-x1).^2);

    % Calculate the mode to three decimal places for slope and stdev
    mode_slope=mode(round(slopes_modified,3));
    std_slope=slope_dev*std(slopes_modified);
    
    % Calculate the mode to one decimal place for length and stdev
    mode_length=mode(round(lengths_modified,1));
    std_length=length_dev*std(lengths_modified);
    
    % Calculate inliers
    slope_inliers = (mode_slope-std_slope)<slopes_modified & slopes_modified<(mode_slope+std_slope);
    length_inliers = (mode_length-std_length)<lengths_modified & lengths_modified<(mode_length+std_length);
    inliers = slope_inliers & length_inliers;

    if ~suppress
        figure;
        histogram(slopes_modified,30)
        xline(mode_slope+std_slope,"r")
        xline(mode_slope-std_slope,"r")
        title("Slope Filtering")
        xlabel("Slope (rad)")
        figure;
        histogram(lengths_modified, 30)
        xline(mode_length+std_length,"r")
        xline(mode_length-std_length,"r")
        title("Length Filtering")
        xlabel("Length (px)")
    end
end