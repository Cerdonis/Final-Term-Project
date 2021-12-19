function[min] = SSD(fix, warp)
    sd = fix - warp;
    min = sum(sd(:).^2);
end