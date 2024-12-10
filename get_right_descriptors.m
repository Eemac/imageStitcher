function [descriptors_right] = get_right_descriptors(strongest_right, offset_right_horiz, offset_right_vert, radius, suppress)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    minxy = double(uint32(strongest_right.Location));
    maxxy = double(uint32(strongest_right.Location)+2*radius);
    descriptors_right = zeros(128,1,length(minxy));
    for i=1:size(descriptors_right,3)
        descriptors_right(:,:,i) = sift_descriptor(offset_right_horiz, offset_right_vert, minxy, maxxy, i, radius);
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