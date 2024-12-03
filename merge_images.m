function out = merge_images(im1, im2, dx, dy)

    if dx>0
        % im2 moves right
        xbound = max(size(im1,2),dx+size(im2,2));
        originx_im1 = 1;
        originx_im2 = dx;
    else
        % im2 moves left
        xbound = max(dx+size(im1,2),size(im2,2));
        originx_im1 = -dx;
        originx_im2 = 1;
    end
    if dy>0
        % im2 moves down
        ybound = max(size(im1,1),dy+size(im2,1));
        originy_im1 = 1;
        originy_im2 = dy;
    else
        % im2 moves up
        ybound = max(dy+size(im1,1),size(im2,1));
        originy_im1 = -dy;
        originy_im2 = 1;
    end

    %create new image blank
    out = zeros(xbound, ybound, 3, "uint8");

    %add image 1
    out(originy_im1:originy_im1+size(im1,1)-1,originx_im1:originx_im1+size(im1,2)-1, :) = im1(:,:,:);

    %add image 2
    out(originy_im2:originy_im2+size(im2,1)-1,originx_im2:originx_im2+size(im2,2)-1, :) = im2(:,:,:);

end
