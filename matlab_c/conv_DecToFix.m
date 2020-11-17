close all;
clear all;
clc;

format longG;
dec = 0.076126 ;
dec_m = dec;
bin = zeros(1, 8);
if dec < 0
    bin(1) = 1;
    dec_m = dec_m+1;
end
for i = 2:8
    dec_m = dec_m*2;
  if dec_m >= 1
      bin(i)= 1;
      dec_m = dec_m-1;
  end 
end
bin
    