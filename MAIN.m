clc 
clear
close all

fixed = '1';
warped = '2-2';
rot_warped = strcat(warped,'r.tif');

[orig1, list1, orig2_rot, list2_rot] = GLOBAL_ROT(strcat(fixed,'.tif'), strcat(warped,'.tif'));

match_pairs = MATCH_PAIRS(orig1, list1, orig2_rot, list2_rot);

[r1, c1] = size(orig1);
[r2, c2] = size(orig2_rot);

global_row = max(r1, r2);
global_col = max(c1, c2);

orig1_eq = zeros(global_row, global_col);
orig2_eq = zeros(global_row, global_col);

eq_rcen = round(global_row/2);
eq_ccen = round(global_col/2);
r1_dif = eq_rcen - round(r1/2);
c1_dif = eq_ccen - round(c1/2);
r2_dif = eq_rcen - round(r2/2);
c2_dif = eq_ccen - round(c2/2);

for i = 1:r1
    for j = 1:c1
        orig1_eq(i+r1_dif,j+c1_dif) = orig1(i,j);
    end
end
    
for i = 1:r2
    for j = 1:c2
        orig2_eq(i+r2_dif,j+c2_dif) = orig2_rot(i,j);
    end
end

[len1, cc] = size(list1);
[len2, cc] = size(list2_rot);
for i = 1:len1
    list1(i,2) = list1(i,2) + r1_dif;
    list1(i,3) = list1(i,3) + c1_dif;
end
for i = 1:len2
    list2_rot(i,2) = list2_rot(i,2) + r2_dif;
    list2_rot(i,3) = list2_rot(i,3) + c2_dif;
end

[m,match_inlier] = showMatching(orig1_eq, orig2_eq, list1(:,2:3), list2_rot(:,2:3), match_pairs(:,1:2));

close all

%%%%%%%%%%%%%%%%% CHOOSE REGISTRATION METHOD %%%%%%%%%%%%%%%%%%%%%%

% Random homography
for i = 1:20
    REGISTER_RAND(orig1_eq, orig2_eq, list1(:,2:3), list2_rot(:,2:3), match_inlier);
end

% Manual CP selection
REGISTER_CP(orig1_eq, orig2_eq, list1(:,2:3), list2_rot(:,2:3), match_inlier);

% TPS registration (Failed)
REGISTER_TPS(orig1_eq, orig2_eq, list1(:,2:3), list2_rot(:,2:3), match_inlier);

% Imregdemons
orig2_eq = imhistmatch(orig2_eq,orig1_eq);
[~,movingReg] = imregdemons(orig2_eq,orig1_eq,[500 400 200], 'AccumulatedFieldSmoothing',1.3);
RGB = cat(3, orig1_eq, movingReg, zeros(size(orig1_eq)));
figure; imshow(RGB);
title('Imregdemons');




