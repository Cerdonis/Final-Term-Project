function[orig1, list1, orig2_rot, list2_rot] = GLOBAL_ROT(fixed, warped)

    [orig1, list1] = CELL_POINTER(fixed);
    title('Fixed')
    [orig2, list2] = CELL_POINTER(warped);
    title('Warped')

    bright1 = imadjust(orig1);
    bright2 = imadjust(orig2);

    % Patch window changes according to the size of detected cells
    rad = ceil(mean(list1(:, 4)));

    % Make fixed image's patch stack
    [r1, c1] = size(list1);
    stack_fix = zeros(rad*2+1);
        for cnt = 1: r1-1
            stack_fix = cat(3 , stack_fix , zeros(rad*2+1));    
        end
        for i = 1 : r1
           stack_fix(:, :, i) =  PATCH(rad*2+1, list1(i,2), list1(i,3), bright1);
    %        figure; imshow(stack_fix(:, :, i))
        end

    [r2, c2] = size(list2);
    ssd_map = zeros(16, r1);
    match_map = zeros(3, r2);
    
    % Purpose: determine best rotation for warped image
    for i = 1:r2 % For every cell points of warped image

        for j = 1:16 % For every rotation of one cell
            stack_warp = ROT_STACK(bright2, list2(i,2), list2(i,3), rad);
        end

        for ang = 1:16 % Find the orientation with best SSD
            for point_fix = 1:r1
                ssd_map(ang, point_fix) = SSD(stack_fix(:,:,point_fix), stack_warp(:,:,ang));
            end
        end

        min_val = min(min(ssd_map));
        [angle, fixed_point] = find(ssd_map==min_val);
        match_map(1, i) = fixed_point;
        match_map(2, i) = min_val;
        match_map(3, i) = angle*22.5; 
    end

    % Remove redundancy in match (make into one-to-one match)
    match_map_unique = match_map;
    for i = 1:r2
        if match_map_unique(1, i) == -1
            continue
        end
        common = match_map_unique(1, i);
        min_index = i;
        min_val = match_map_unique(2, i);
        for j = i+1:r2
            if match_map_unique(1, j) == common
                if match_map_unique(2, j) <= min_val
                    min_val = match_map_unique(2, j);
                    match_map_unique(1, min_index) = -1;
                    match_map_unique(2, min_index) = Inf;
                    match_map_unique(3, min_index) = -rand;
                    min_index = j;
                else
                    match_map_unique(1, j) = -1;
                    match_map_unique(2, j) = Inf;
                    match_map_unique(3, j) = -rand;
                end
            end              
        end
    end
    
    % Find the most frequently appearing orientation
    global_rot = mode(match_map_unique(3,:));    
    if global_rot < 0
        [r, c] = find(match_map_unique(2,:) == min(match_map_unique(2,:)));
        global_rot = match_map_unique(3, c);
    end

    % Rotate image according to the acquired angle
    orig2_rot = imrotate(orig2, global_rot, 'bicubic');
    
    % Rotate cell-center coordinates according to the acquired angle
    RotMatrix = [cosd(-global_rot) -sind(-global_rot); sind(-global_rot) cosd(-global_rot)]; 
    ImCenterA = (size(orig2)/2)';
    ImCenterB = (size(orig2_rot)/2)';

    list2_rot = list2;
    for i = 1:r2
        P = [list2(i, 2); list2(i, 3)];
        RotatedP = RotMatrix*(P-ImCenterA)+ImCenterB;       
        list2_rot(i, 2) = RotatedP(1,1);
        list2_rot(i, 3) = RotatedP(2,1);
    end
    
    c = jet(r2);
    figure; imshow(orig2_rot)
    hold on
    title('Orientation corrected')
    for i = 1: r2
        plot(list2_rot(i,2),list2_rot(i,3),'g*')
        text(list2_rot(i,2), list2_rot(i,3), num2str(i),'color',c(i,:),'fontsize', 20);

    end
    hold off

end
