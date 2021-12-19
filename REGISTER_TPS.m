function[] = REGISTER_TPS(orig1, orig2, list1, list2, match_pairs)

    [r, c] = size(match_pairs);
    tops1 = zeros(r,2);
    tops2 = zeros(r,2);
    for i = 1:r
       tops1(i,:) = list1(match_pairs(i,1), :);   
       tops2(i,:) = list2(match_pairs(i,2), :);
    end
    
   intrp = interp;
   
   intrp.method = 'none';
   intrp.radius = 100;
   intrp.power = 2;   

    [imgw, imgwr, map] = tpswarp(orig2, size(orig2), tops2, tops1, intrp);
       
    RGB = cat(3, orig1, imgw, zeros(size(orig1)));
    figure; imshow(RGB);
    title('TPS')

end