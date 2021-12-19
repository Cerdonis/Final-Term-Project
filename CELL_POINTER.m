function[orig ,cell_list] = CELL_POINTER(filename)

img = imread(filename);
img = img(:,:,1:3);
img = rgb2gray(img);
img = im2double(img);
orig = img;

img = imadjust(img);
% figure;imshow(img)
% title('increase contrast 1')

img = imbinarize(img);
% figure; imshow(img)
% title('Binarize 1')

H = fspecial('gaussian', 60, 6); 
img = filter2(H, img);
% figure;imshow(img)
% title('Blur 1')

img = imadjust(img);
% figure;imshow(img)
% title('increase contrast 2')

img = imbinarize(img, 0.6);
% figure; imshow(img)
% title('Binarize 2')

% Store various info for each polyshape
stats = regionprops(img,'centroid', 'area','MajorAxisLength','MinorAxisLength');
area = cat(1,stats.Area);
coord = cat(1,stats.Centroid);
MaL = cat(1,stats.MajorAxisLength);
MiL = cat(1,stats.MinorAxisLength);
blot_info = [area coord MaL MiL];
blot_info = sortrows(blot_info, 'descend');
TF = ischange(blot_info(:, 1), 'linear');

[r c] = size(blot_info);

% Discard outliers
for i = 0 : r
    if TF(r-i, 1) == 1
        smallest_cell = r-i;
        break
    end
end

% Before discarding outliers
cell_list = blot_info(1:smallest_cell, :);
% figure; imshow(orig)
% hold on
% title('Blob detection')
% plot(blot_info(:,2),blot_info(:,3),'r*')
% hold off

% After discarding outliers
[r, cc] = size(cell_list);
c = jet(r);
figure; imshow(orig)
hold on
title('Cell detection')
for i = 1: r
    plot(cell_list(i,2),cell_list(i,3),'g*')
    text(cell_list(i,2), cell_list(i,3), num2str(i),'color',c(i,:),'fontsize', 20);
           
end
hold off
end
