function[] = REGISTER_CP(orig1, orig2, list1, list2, match_pairs)

    [r, c] = size(match_pairs);
    tops1 = zeros(r,2);
    tops2 = zeros(r,2);
    for i = 1:r
       tops1(i,:) = list1(match_pairs(i,1), :);   
       tops2(i,:) = list2(match_pairs(i,2), :);
    end

    [tops2,tops1] = cpselect(orig2,orig1,'Wait',true);
    t = fitgeotrans(tops2,tops1,'projective');
    Rfixed = imref2d(size(orig1));
    registered = imwarp(orig2,t,'OutputView',Rfixed);
    
    
    RGB = cat(3, orig1, registered, zeros(size(orig1)));
    figure; imshow(RGB);
    title('Control Points')

end