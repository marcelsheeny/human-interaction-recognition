clc;
close all;
%clear all;

%load('mpii_human_pose_v1_u12_1.mat');

image_id = 20;

person_id = 1;


image_path =  '../../datasets/lsp_dataset/images/';

images_path = dir([image_path 'im*']);

im = imread([image_path images_path(image_id).name]);

colors = [0 0.5 0;  %1
          0 1 0;    %2
          0 0 1;    %3
          0 0 0.5;  %4
          0 1 0;    %5
          1 1 0;    %6
          1 0 0 ];   %7
          
          
conn_joints = [1 2 3; 2 3 4;
               4 5 1; 5 6 2;
               7 8 3; 8 9 4;
               10 11 1; 11 12 1;
               13 14 7];
           
load('../../datasets/lsp_dataset/joints.mat');


image_joints = joints(1:2,:,image_id)';


visualize_data(im,image_joints,conn_joints,colors,false,false);