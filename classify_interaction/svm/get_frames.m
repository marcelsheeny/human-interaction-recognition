function [ joints_interpolated ] = get_frames( joints, stride, n_frames )
%INTERPOLATE_FRAMES Summary of this function goes here
%   Detailed explanation goes here

% joints structure = cell with number of frames
% and in each frame it contains all the joints and positions

joints_interpolated = cell(1,n_frames);

n_frames_joints = length(joints);

a = linspace(1,n_frames_joints,n_frames);

cnt = 1;

if (stride*n_frames+n_frames > n_frames_joints)
   joints_interpolated = [];
   return
end

for i=stride*n_frames+1:(stride*n_frames)+n_frames
    joints_interpolated{1,cnt} = joints{1,i};
    cnt = cnt + 1;
end

    
end
