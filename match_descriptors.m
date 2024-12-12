function [left_matches] = match_descriptors(descriptors_left, descriptors_right, quantity_l, quantity_r, iterations, suppress)
% Matches two sets of descriptors.
%   Args:
%       descriptors_left: left (image 1) descriptors
%       descriptors_right: right (image 2) descriptors
%       quantity_l: quantity of left (image 1) descriptors to use
%       quantity_r: quantity of right (image 2) descriptors to use
%       iterations: maximum number of matching iterations
%       suppress: debug printing bool
%   Returns:
%       left_matches: (left indices, matched right indices) vector

    % Set up selected_points to track matches in left image
    % (left indices, matched right indices)
    left_matches = zeros(quantity_l,2);
    left_matches(:,1) = randperm(quantity_l,size(left_matches,1))';
    remaining_left = true(size(left_matches,1),1);

    % Set up matched_points to track matches in right image
    % (left indices, strength of match)
    right_matches = zeros(quantity_r,2);
    right_matches(:,2) = 10^12;
    remaining_right = true(size(right_matches,1),1);
    
    for j=1:iterations
        for i=1:length(left_matches)
            % Skip point if already mapped
            if ~remaining_left(i)
                continue
            end
            % Find the SSD of the left descriptor against all right
            % descriptors that have not been matched
            descriptor_left = descriptors_left(:,:,left_matches(i,1));
            sd = (descriptors_right(:,:,remaining_right)-descriptor_left).^2;
            ssd = sum(sd,1:2);
            ssd = squeeze(ssd);
            % Find the closest match
            [v,idx] = min(ssd);
            idx = find(remaining_right==1,idx,"first");
            idx = idx(end);
            % If the closest match has a higher match strength, overwrite
            if v<right_matches(idx,2)
                % If the closest match has a left image assignment, remove
                if right_matches(idx,1)>0
                    left_matches(right_matches(idx,1),2) = 0;
                end
                % Save the matches
                left_matches(i,2) = idx;
                right_matches(idx,1) = i;
                right_matches(idx,2) = v;
            end
        end
        % Calculate remaining pairs in both images
        remaining_left = left_matches(:,2)==0;
        remaining_right = right_matches(:,1)==0;
        if ~suppress
            sum(remaining_left)
        end
        % If all are matched, exit
        if sum(remaining_left)==0
            break
        end
    end
    % Choose top 15% of matches and remove blank rows
    thresh = prctile(right_matches(:,2),15);
    mask = right_matches(:,2)<thresh;
    mask_ind = right_matches(mask,1);
    left_matches = left_matches(mask_ind,:);
    left_matches = left_matches(left_matches(:,2)~=0,:);
    if ~suppress
        figure;
        histogram(right_matches(:,2),50)
        xline(thresh)
    end
end