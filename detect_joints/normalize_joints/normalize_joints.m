function [ normalized_joints, transformation_matrix ] = normalize_joints( joints, model )
%NORMALIZE_JOINT Summary of this function goes here
%   Detailed explanation goes here

X = [joints(model.fixed_joints(1,1),1) joints(model.fixed_joints(1,1),2) 1 0 0 0;
     0 0 0 joints(model.fixed_joints(1,1),1) joints(model.fixed_joints(1,1),2) 1;
     joints(model.fixed_joints(2,1),1) joints(model.fixed_joints(2,1),2) 1 0 0 0;
     0 0 0 joints(model.fixed_joints(2,1),1) joints(model.fixed_joints(2,1),2) 1;
     joints(model.fixed_joints(3,1),1) joints(model.fixed_joints(3,1),2) 1 0 0 0;
     0 0 0 joints(model.fixed_joints(3,1),1) joints(model.fixed_joints(3,1),2) 1;
     joints(model.fixed_joints(4,1),1) joints(model.fixed_joints(4,1),2) 1 0 0 0;
     0 0 0 joints(model.fixed_joints(4,1),1) joints(model.fixed_joints(4,1),2) 1];
 
y = [model.fixed_joints(1,2);
     model.fixed_joints(1,3);
     model.fixed_joints(2,2);
     model.fixed_joints(2,3);
     model.fixed_joints(3,2);
     model.fixed_joints(3,3);
     model.fixed_joints(4,2);
     model.fixed_joints(4,3)];
 
T = inv(X'*X)*X'*y;
 
T = reshape(T,[3 2]);

T = [T, [0 0 1]'];

transformation_matrix = T;

tform = affine2d(T);

normalized_joints = [];

for i = 1 : size(joints,1)
    [X,Y] = transformPointsForward(tform,joints(i,1),joints(i,2));
    normalized_joints = [normalized_joints; X, Y];
end

%imshow(zeros(256,256)); hold on;

%plot_skeleton_kinect(normalized_joints);





end

