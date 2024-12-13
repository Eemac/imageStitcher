function [descriptors_left] = get_left_descriptors(strongest_left, left_horiz, left_vert, radius)
% Gets the left (image 1) descriptors.
%   Args:
%       strongest_right: corner points to find the descriptors for
%       left_horiz: horizontal gradients in the image
%       left_vert: vertical gradients in the image
%       radius: radius of the descriptor
%       suppress: debug printing bool
%   Returns:
%       descriptors_right: 128x1 SIFT-like descriptors for all points

    minxy = double(uint32(strongest_left.Location));
    maxxy = double(uint32(strongest_left.Location)+2*radius);
    descriptors_left = zeros(128,1,length(minxy));
    for i=1:size(descriptors_left,3)
        descriptors_left(:,:,i) = sift_descriptor(left_horiz, left_vert, minxy, maxxy, i, radius);
    end
end