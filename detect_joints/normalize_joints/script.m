clc;
close all
clear all;

model.dims = [256 256];

%                      joint_id    desired_position_x desired_position_y 
model.fixed_joints = [    1               128               30;
                          4               64                60;
                          7               172               60;
                          2               128               60];
path = '../../../datasets/kinect_interaction/set01/01/001/';
                      
annotation_path = dir([path 'annotation*.mat']);
            
load([path annotation_path(1).name]);
imshow(zeros(1000,1000))
plot_skeleton_kinect( annotation.joints_gt{1}{1} )
                      
[normalized_joints, transformation_matrix] = normalize_joints( annotation.joints_gt{1}{1}, model );