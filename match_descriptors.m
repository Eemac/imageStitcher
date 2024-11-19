function [selected_points] = match_descriptors(descriptors_right, strongest_left, offset_left_horiz, offset_left_vert, quantity, radius, iterations, suppress)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    selected_points = zeros(quantity,2);
    selected_points(:,1) = randperm(quantity,size(selected_points,1))';
    matched_points = zeros(size(selected_points));
    matched_points(:,2) = 10^12;
    remaining_selected = true(size(selected_points,1),1);
    remaining_matched = true(size(matched_points,1),1);
    
    for j=1:iterations
        for i=1:length(selected_points)
            if ~remaining_selected(i)
                continue
            end
            minxy = double(uint32(strongest_left.Location(selected_points(i,1),:)));
            maxxy = double(uint32(strongest_left.Location(selected_points(i,1),:)+2*radius));
            descriptor_left = sift_descriptor(offset_left_horiz, offset_left_vert, minxy, maxxy, 1, radius);
            sd = (descriptors_right(:,:,remaining_matched)-descriptor_left).^2;
            ssd = sum(sd,1:2);
            ssd = squeeze(ssd);
            [v,idx] = min(ssd);
            idx = find(remaining_matched==1,idx,"first");
            idx = idx(end);
            if v<matched_points(idx,2)
                if matched_points(idx,1)>0
                    selected_points(matched_points(idx,1),2) = 0;
                end
                selected_points(i,2) = idx;
                matched_points(idx,1) = i;
                matched_points(idx,2) = v;
            end
        end
        remaining_selected = selected_points(:,2)==0;
        remaining_matched = matched_points(:,1)==0;
        if ~suppress
            sum(remaining_selected)
        end
        if sum(remaining_selected)==0
            break
        end
    end
    % old_selected_points = selected_points;
    selected_points = selected_points(selected_points(:,2)~=0,:);
end