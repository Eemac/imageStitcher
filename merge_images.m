function [out, valid] = merge_images(im1, im2, dx, dy, mismatch)

    if dx>=0
        % im2 moves right
        xbound = max(size(im1,2),dx+size(im2,2));
        originx_im1 = 1;
        originx_im2 = max(1,dx);
        % right_bound_im1_x = size(im2,2);
        % right_bound_im2_x = size(im2,2)+min(-dx,-1)+1;
    else
        % im2 moves left
        xbound = max(abs(dx)+size(im1,2),size(im2,2));
        originx_im1 = abs(dx);
        originx_im2 = 1;
        % right_bound_im1_x = size(im2,2)+dx+1;
        % right_bound_im2_x = size(im2,2);
    end
    if dy>=0
        % im2 moves down
        ybound = max(size(im1,1),dy+size(im2,1));
        originy_im1 = 1;
        originy_im2 = max(1,dy);
        % right_bound_im1_y = size(im2,1);
        % right_bound_im2_y = size(im2,1)+min(-dy,-1)+1;
    else
        % im2 moves up
        ybound = max(abs(dy)+size(im1,1),size(im2,1));
        originy_im1 = abs(dy);
        originy_im2 = 1;
        % right_bound_im1_y = size(im2,1)+dy+1;
        % right_bound_im2_y = size(im2,1);
    end

    %create new image blank
    out = zeros(ybound, xbound, 3, "uint8");
    out1= zeros(ybound, xbound, 3, "uint8");
    out2= zeros(ybound, xbound, 3, "uint8");
    % out2 = zeros(ybound, xbound, 3, "uint8");

    % im1_overlap = im1(originy_im2:right_bound_im1_y,originx_im2:right_bound_im1_x,:);
    % figure;
    % imshow(im1_overlap)
    % im2_overlap = im2(originy_im1:right_bound_im2_y,originx_im1:right_bound_im2_x,:);
    % figure;
    % imshow(im2_overlap)
    
    %add image 1
    out(originy_im1:originy_im1+size(im1,1)-1,originx_im1:originx_im1+size(im1,2)-1, :) = im1(:,:,:);
    out1(originy_im1:originy_im1+size(im1,1)-1,originx_im1:originx_im1+size(im1,2)-1, :) = im1(:,:,:);
    out1_gray = im2gray(out1);

    %add image 2
    out(originy_im2:originy_im2+size(im2,1)-1,originx_im2:originx_im2+size(im2,2)-1, :) = im2(:,:,:);
    out2(originy_im2:originy_im2+size(im2,1)-1,originx_im2:originx_im2+size(im2,2)-1, :) = im2(:,:,:);
    out2_gray = im2gray(out2);

    overlap = uint8(out1_gray~=0).*uint8(out2_gray~=0);
    difference = squeeze(sum(abs(double(out1.*overlap)-double(out2.*overlap)),[1,2]));
    thresh = mismatch*sum(overlap,"all");
    difference/thresh
    valid = all(difference<=thresh);

    if ~valid
        out = im1;
    else
        % out = max(out1,out2);
        out3 = out1.*uint8(out2_gray==0); % image 1 but not 2
        out4 = out2.*uint8(out1_gray==0); % image 2 but not 1
        out5 = out1.*uint8(out1_gray~=0).*uint8(out2_gray~=0); % images 1 and 2
        out = out3+out4+out5;
    end

end
