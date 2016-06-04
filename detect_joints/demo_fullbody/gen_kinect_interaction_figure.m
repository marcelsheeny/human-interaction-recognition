clc
clear all
close all;

image_id = 7;

path = 'kinect_interaction/03/001/';

annotation_file = dir([path 'annotation*']);

load([path annotation_file(1).name]);

images_file = dir([path 'rgb*']);

im = imread([path images_file(image_id).name]);

colors = [0 0.5 0;  %1
          0 1 0;    %2
          0 0 1;    %3
          0 0 0.5;  %4
          0 1 0;    %5
          1 1 0;    %6
          1 0 0 ];   %7

conn_joints = [1 2 7;
               3 4 1; 4 5 2;
               6 7 3; 7 8 4;
               9 10 1; %10 11 2;
               12 13 3; 13 14 4];

joints = annotation.joints_prediction{image_id}{1};

imshow(im); hold on;

%visualize_data(im,joints,conn_joints,colors,false);

%joints = annotation.joints_prediction{image_id}{2};

%visualize_data(im,joints,conn_joints,colors,false);
