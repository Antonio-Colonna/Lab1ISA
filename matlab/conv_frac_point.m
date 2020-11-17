close all;
clear all;
clc;
bin = [0 0 0 0 1 0 1 0];
sz = size(bin);
dec = 0;
for i = 1:sz(2)
    if i == 1
        dec = -1*bin(1);
    else
    dec = dec + (1/(2^(i-1)))*bin(i);
    end
end
format long;
dec
