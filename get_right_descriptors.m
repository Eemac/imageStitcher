function [descriptors_right] = get_right_descriptors(strongest_right, right_horiz, right_vert, radius, suppress)
% Gets the right (image 2) descriptors.
%   Args:
%       strongest_right: corner points to find the descriptors for
%       right_horiz: horizontal gradients in the image
%       right_vert: vertical gradients in the image
%       radius: radius of the descriptor
%       suppress: debug printing bool
%   Returns:
%       descriptors_right: 128x1 SIFT-like descriptors for all points

    minxy = double(uint32(strongest_right.Location));
    maxxy = double(uint32(strongest_right.Location)+2*radius);
    descriptors_right = zeros(128,1,length(minxy));
    for i=1:size(descriptors_right,3)
        descriptors_right(:,:,i) = sift_descriptor(right_horiz, right_vert, minxy, maxxy, i, radius);
    end
    if ~suppress
        figure;
        plot(1:128,squeeze(descriptors_right));
        colormap("cool")
        hold on
        plot(1:128,squeeze(descriptors_right(:,1)),"g","LineWidth",2);
        xlim([1,128]);
        title("SIFT Descriptors");
        xlabel("Descriptor Index");
        ylabel("Value");
    end
end