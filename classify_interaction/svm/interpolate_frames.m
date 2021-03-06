function [ joints_interpolated ] = interpolate_frames( joints, n_frames )
%INTERPOLATE_FRAMES Summary of this function goes here
%   Detailed explanation goes here

% joints structure = cell with number of frames
% and in each frame it contains all the joints and positions

joints_interpolated = cell(1,n_frames);

n_frames_joints = length(joints);

a = linspace(1,n_frames_joints,n_frames);

for i=1:n_frames
    joints_interpolated{1,i} = joints{1,floor(a(1,i))};
end

    
end
