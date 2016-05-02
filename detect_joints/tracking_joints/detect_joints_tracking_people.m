% This file uses a FLIC trained model and applies it to a video sequence from Poses in the Wild
%
% Download the model:
%    wget http://tomas.pfister.fi/models/caffe-heatmap-flic.caffemodel -P ../../models/heatmap-flic-fusion/

% Options

clear all;
clc;
close all;

opt.visualise = false;		% Visualise predictions?
opt.debug = true; 
opt.useGPU = true; 			% Run on GPU
opt.dims = [256 256]; 		% Input dimensions (needs to match matlab.txt)
opt.numJoints = 14; 			% Number of joints
opt.layerName = 'conv5_fusion'; % Output layer name
%opt.modelDefFile = '../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/matlab.prototxt'; % Model definition
%opt.modelFile = '../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'; % Model weights
opt.modelDefFile = '../../../libs/caffe-heatmap-master/models/heatmap-fullbody-10/matlab.prototxt'; % Model definition
opt.modelFile = '../../../libs/caffe-heatmap-master/data/tp/nets/heatmap-fullbody-10/snapshots/heatmap_train_iter_274400.caffemodel'; % Model weights

%opt.modelFile = '/data/tp/nets/heatmap-flic-fusion/snapshots/heatmap_train_iter_29600.caffemodel';

% Add caffe matlab into path
addpath(genpath('../../../libs/caffe-heatmap-master/matlab'));


%for all videos and boxes

path = '../../../datasets/human_activities_videos/';

videos = dir([path '*.avi']);

opt.net = initCaffe(opt);

%for i=1:length(videos)
    


    %[pa,fi,ex] = fileparts(videos(i).name);
   
    %load([path fi 'matlabtrack.mat']);    
    load([path 'seq1matlabtrack_processed.mat']);    
    
    
    
    %disp([videos(i).name , ' ', num2str(i), ' out of ', num2str(length(videos))]);
    %disp([boxes(i).name , ' ', num2str(i), ' out of ', num2str(length(boxes))]);
    %video = VideoReader([path videos(i).name]);
    video = VideoReader([path 'seq1.avi']);
    
    opt.bboxes = all_tracks;
    % Apply network
    joints = applyNet(video, opt);
    %[p,name,ext] = fileparts(videos(i).name);
    %save([path name, 'joints.mat'], 'joints');

%end
caffe.reset_all(); 
clear mex;