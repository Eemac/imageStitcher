function [corners] = harriscorners(org, points)
    %Part 3
    sobel = [
     -5 -4 0 4 5;
     -8 -10 0 10 8;
    -10 -20 0 20 10;
     -8 -10 0 10 8;
     -5 -4 0 4 5;
    ];
    % sobel = [-1 -2 -1; 0 0 0; 1 2 1];
    b = -1*ones(3);
    b(2,2) = 8;
    org = conv2(org, b, "same");
    bw_org = im2gray(org);
    ix = zeros(size(bw_org));
    iy = zeros(size(bw_org));
    for i=1:size(bw_org,3)
        ix(:,:,i) = conv2(bw_org(:,:,i),sobel,"same");
        iy(:,:,i) = conv2(bw_org(:,:,i),sobel',"same");
    end
    % imshow(uint8(ix))
    % imshow(uint8(iy))
    
    k = 0.04;
    ix2 = ix.^2;
    iy2 = iy.^2;
    ixiy = ix.*iy;
    g = [
        1 4 7 4 1;
        4 20 33 20 4;
        7 33 55 33 7;
        4 20 33 20 4;
        1 4 7 4 1;
        ];
    mix2 = conv2(ix2,g,"same");
    miy2 = conv2(iy2,g,"same");
    mixiy = conv2(ixiy,g,"same");
    m = mix2.*miy2-mixiy.^2 - k*(mix2+miy2).^2;

    % b = -1*ones(7);
    % b(3:5,3:5)=-2*ones(3,3);
    % b(4,4) = 57;
    % % g=-g;
    % % g(3,3) = -sum(g,"all")-55;
    % b = -1*ones(3);
    % b(2,2) = 8;
    % m = conv2(m,b,"same");
    % m=imgaussfilt(m,3);
    % m = conv2(m,b,"same");
    % m = conv2(m,b,"same");

    m(:,1:3) = 0;
    m(:,size(m,2)-2:end) = 0;
    m(1:3,:) = 0;
    m(size(m,1)-2:end,:) = 0;
    idx = [(1:numel(m))',reshape(m,[],1)];
    idx = sortrows(idx,2,"descend");
    % imshow(uint8(255*10*m/max(m,[],"all")))
    % imshow(uint8(m-5*mean(m,"all")))
    % idx = zeros(400,1);
    % mmax = m;
    % mmod = zeros(size(m));
    % deadzone = 30;
    % marker = 3;
    % for i=1:length(idx)
    %     [v,ind]=max(mmax,[],"all");
    %     idx(i)=ind;
    %     [row,col] = ind2sub(size(m),ind);
    %     mmax(max(row-deadzone,1):min(row+deadzone,size(mmax,1)),max(col-deadzone,1):min(col+deadzone,size(mmax,2))) = 0;
    %     mmod(max(row-marker,1):min(row+marker,size(mmod,1)),max(col-marker,1):min(col+marker,size(mmod,2))) = 255;
    % end
    % inc = 1;
    % if points<=1.25
    %     inc = 10;
    % elseif points>=2.5
    %     inc=10;
    % end
    [row,col] = ind2sub(size(m),idx(:,1));
    corners = cornerPoints([col,row]);
end

