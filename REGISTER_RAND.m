function[] = REGISTER_RAND(orig1, orig2, list1, list2, match_pairs)

    [r, c] = size(match_pairs);
    
    if r > 4
        rnd = randperm(r);
        rand_match = rnd.';
        rand_match = [rand_match rand_match];
        rand_match(5:end,:) = [];

        % Shuffle the putative matches
        for i = 1:4
           rand_match(i,:) =  match_pairs(rand_match(i,1), :);    
        end

        tops1 = zeros(4,2);
        tops2 = zeros(4,2);
        m = zeros(4, 2);
        % Aquire randomly selected 4 match pairs
        for i = 1:4
           tops1(i,:) = list1(rand_match(i,1), :);   
           tops2(i,:) = list2(rand_match(i,2), :);   
           m(i,:) = [i i];
        end
    else
        tops1 = zeros(r,2);
        tops2 = zeros(r,2);
        m = zeros(r, 2);
        for i = 1:r
           tops1(i,:) = list1(match_pairs(i,1), :);   
           tops2(i,:) = list2(match_pairs(i,2), :);
           m(i,:) = [i i];
        end
    end  

    t = fitgeotrans(tops2,tops1,'projective');
    Rfixed = imref2d(size(orig1));
    registered = imwarp(orig2,t,'OutputView',Rfixed);
   
    RGB = cat(3, orig1, registered, zeros(size(orig1)));
    figure; imshow(RGB);
    title('Random Homography')

end