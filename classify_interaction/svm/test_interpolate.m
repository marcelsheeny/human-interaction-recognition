clc;
close all;
clear all;

siz = 30;

a = cell(1,siz);

for i=1:siz
   a{i} = i; 
end

aa = interpolate_frames(a,10);

aa