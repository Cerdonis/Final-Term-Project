function[match_pairs] = MATCH_PAIRS(fix, list1, warp_rot, list2)

fix = imadjust(fix);
warp_rot = imadjust(warp_rot);

% Patch window changes according to the size of detected cells
rad = ceil(mean(list1(:, 4)));

[r1, c1] = size(list1);
[r2, c2] = size(list2);

stack_fix = zeros(rad*2+1);
for cnt = 1: r1-1
    stack_fix = cat(3 , stack_fix , zeros(rad*2+1));    
end
% Make fixed image's patch stack
for i = 1 : r1
   stack_fix(:, :, i) =  PATCH(rad*2+1, list1(i,2), list1(i,3), fix);
%        figure; imshow(stack_fix(:, :, i))
end

stack_warp = zeros(rad*2+1);
for cnt = 1: r2-1
    stack_warp = cat(3 , stack_warp , zeros(rad*2+1));    
end
% Make warped image's patch stack
for i = 1 : r2
   stack_warp(:, :, i) =  PATCH(rad*2+1, list2(i,2), list2(i,3), warp_rot);
%        figure; imshow(stack_warp(:, :, i))
end

ssd_map = zeros(r1, r2);

for i = 1:r1
    for j = 1:r2
        ssd_map(i,j) = SSD(stack_fix(:, :, i), stack_warp(:, :, j));            
    end   
end

match_pairs = zeros(min(r1,r2),2);

% Choose best SSD, and let them paired
for i=1:min(r1,r2)
    minval = min(min(ssd_map));
    [f1, f2] = find(ssd_map==minval);
    f1 = f1(1,1);  f2 = f2(1,1);
    match_pairs(i, 1) = f1;
    match_pairs(i, 2) = f2;
    
    x = [list1(f1,1) list1(f1,2)];
    y = [list2(f2,1) list2(f2,2)];
    ssd_map(:,f2) = Inf*ones(size(ssd_map(:,f2)));
    ssd_map(f1,:) = Inf*ones(size(ssd_map(f1,:)));
   
end


end