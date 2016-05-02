clc; 
close all;
clear all;

im = imread('22.png');

points = [103   98;
  115  110;
  115  129;
  115  129;
   99  129;
  103  104;
  121  129;
   81  151;
   81  151;
  103  135;
  156  101;
  115  101;
  184  123;
   49   60;
  115  101];

imshow(im); hold on;

for i=1:size(points,1)
    plot(points(i,1), points(i,2), 'r*');
end