function [] = plot_anim(out, stitched)
% Render the current image and the stitch counter.
%   Args:
%       out: image
%       stitched: logical array of whether an image has been stitched
%   Returns:
%       n/a

    imshow(out);
    text(10,10,""+sum(stitched)+"/"+length(stitched),"Color",[1,1,1]);
    drawnow();
end