function [strongest_left, strongest_right, quantity_l, quantity_r, combined] = get_corners(left, right, quantity_l, quantity_r, suppress)
% Get the corners in the left and right images and filter them.
% descriptor.
%   Args:
%       left: left image (image 1)
%       right: right image (image 2)
%       quantity_l: quantity of left (image 1) descriptors to use
%       quantity_r: quantity of right (image 2) descriptors to use
%       suppress: debug printing bool
%   Returns:
%       strongest_left: left image corner points
%       strongest_right: right image corner points
%       quantity_l: quantity of left (image 1) descriptors to use
%       quantity_r: quantity of right (image 2) descriptors to use
%       combined: debug display combined left and right images

    % Convert to grayscale
    gray_left = im2gray(left);
    gray_right = im2gray(right);

    % Get all corners
    strongest_left=harris_corners(gray_left);
    strongest_right=harris_corners(gray_right);
    
    % Create a mask with an 8 px offset from the edge of the images to
    % avoid issues where the black background and image intersection result
    % in a corner.
    thresh=1;
    offset=8;
    left_mask = ~logical(ceil(conv2(uint8(gray_left<=thresh),ones(offset),"same")));
    right_mask = ~logical(ceil(conv2(uint8(gray_right<=thresh),ones(offset),"same")));

    % Flip the x and y values to match convention in the code
    strongest_left.Location = fliplr(strongest_left.Location);
    strongest_right.Location = fliplr(strongest_right.Location);

    % Apply masks
    strongest_left = strongest_left(left_mask(sub2ind(size(left_mask),round(strongest_left.Location(:,1)),round(strongest_left.Location(:,2)))));
    strongest_right = strongest_right(right_mask(sub2ind(size(right_mask),round(strongest_right.Location(:,1)),round(strongest_right.Location(:,2)))));

    % Filter the corners by traversing with an increment to get lower value
    % corners as well
    inc = 100;
    strongest_left = strongest_left(1:ceil(length(strongest_left)/quantity_l/inc):end);
    strongest_right = strongest_right(1:ceil(length(strongest_right)/quantity_r/inc):end);

    % Recompute quantities after filtering
    quantity_l = min(quantity_l,length(strongest_left));
    quantity_r = min(quantity_r,length(strongest_right));
    quantity_l = min(quantity_l, quantity_r);

    % Cut down one more time to the final sizes
    strongest_left = strongest_left(1:quantity_l,:);
    strongest_right = strongest_right(1:quantity_r,:);

    combined = zeros(size(left));
    combined = [combined combined];
    combined(1:size(left,1),1:size(left,2),1:size(left,3)) = left;
    combined(1:size(right,1),size(left,2):size(left,2)+size(right,2)-1,1:size(right,3)) = right;
    combined = uint8(combined);
    if ~suppress
        figure;
        imshow(combined);
        hold on;
        plot(strongest_left.Location(:,2),strongest_left.Location(:,1),"g+");
        plot(strongest_right.Location(:,2)+size(left,2),strongest_right.Location(:,1),"g+");
        disp(quantity_l)
        disp(quantity_r)
    end
end