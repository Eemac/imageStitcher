function [out, valid, normalized_difference] = merge_images(im1, im2, dx, dy, mismatch, suppress)
% Stitch two images together based on a given transform if overlap permits.
%   Args:
%      im1: primary image
%       im2: secondary image
%       dx: x-axis transformation
%       dy: y-axis transformation
%       mismatch: threshold for validity checking
%       suppress: debug printing bool
%   Returns:
%       out: merged image
%       valid: if the merge completed successfully bool
%       normalized_difference: <=1 good (valid) >1 bad (invalid)

    if dx>=0
        % im2 moves right
        xbound = max(size(im1,2),dx+size(im2,2));
        originx_im1 = 1;
        originx_im2 = max(1,dx);
    else
        % im2 moves left
        xbound = max(abs(dx)+size(im1,2),size(im2,2));
        originx_im1 = abs(dx);
        originx_im2 = 1;
    end
    if dy>=0
        % im2 moves down
        ybound = max(size(im1,1),dy+size(im2,1));
        originy_im1 = 1;
        originy_im2 = max(1,dy);
    else
        % im2 moves up
        ybound = max(abs(dy)+size(im1,1),size(im2,1));
        originy_im1 = abs(dy);
        originy_im2 = 1;
    end

    % Create new image blanks
    out = zeros(ybound, xbound, 3, "uint8");
    out1= zeros(ybound, xbound, 3, "uint8");
    out2= zeros(ybound, xbound, 3, "uint8");
    
    % Add image 1
    out(originy_im1:originy_im1+size(im1,1)-1,originx_im1:originx_im1+size(im1,2)-1, :) = im1(:,:,:);
    out1(originy_im1:originy_im1+size(im1,1)-1,originx_im1:originx_im1+size(im1,2)-1, :) = im1(:,:,:);
    out1_gray = im2gray(out1);

    % Add image 2
    out(originy_im2:originy_im2+size(im2,1)-1,originx_im2:originx_im2+size(im2,2)-1, :) = im2(:,:,:);
    out2(originy_im2:originy_im2+size(im2,1)-1,originx_im2:originx_im2+size(im2,2)-1, :) = im2(:,:,:);
    out2_gray = im2gray(out2);

    % Compute overlap difference and validity of merge
    overlap = uint8(out1_gray~=0).*uint8(out2_gray~=0);
    difference = squeeze(mean(abs(double(out1.*overlap)-double(out2.*overlap)),[1,2]));
    thresh = mismatch;
    valid = all(difference<=thresh);
    normalized_difference = difference/thresh;

    if ~suppress
        figure;
        imshow(uint8(abs(double(out1.*overlap)-double(out2.*overlap))))
    end

    % If not valid return im1 image, else merge
    if ~valid
        out = im1;
    else
        out3 = out1.*uint8(out2_gray==0); % Image 1 but not 2
        out4 = out2.*uint8(out1_gray==0); % Image 2 but not 1
        out5 = out1.*uint8(out1_gray~=0).*uint8(out2_gray~=0); % Images 1 and 2
        out = out3+out4+out5; % All regions
        if ~suppress
            figure;
            imshow(out3)
            figure;
            imshow(out4)
            figure;
            imshow(out5)
        end
    end

end
