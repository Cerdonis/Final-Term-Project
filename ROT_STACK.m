function[stack] = ROT_STACK(orig, row, col, rad)

    small_side = rad*2+1;
    big_side = round(rad*2*1.6)+1;

%     H = fspecial('gaussian', 11, 0.5); 
%     img = filter2(H, orig);
% 
%     % Acquiring image gradient
%     [FX,FY] = gradient(img);
%     img = FX+FY;

    stack = zeros(small_side);
    for cnt = 1: 15
        stack = cat(3 , stack , zeros(small_side));    
    end
    
    patch = PATCH(big_side, row, col, orig);
    center = ceil(big_side/2);
    for cnt = 1:16
        % Rotate a temporary bigger patch of 33*33.
        temp = imrotate(patch, cnt*22.5, 'bilinear','crop');
        % Store the central 21*21 patch
        stack(:, :, cnt) = PATCH(small_side,center, center, temp);
%         figure;imshow(stack(:, :, cnt));
    end




end