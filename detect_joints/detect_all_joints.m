% This file uses a FLIC trained model and applies it to a video sequence from Poses in the Wild
%
% Download the model:
%    wget http://tomas.pfister.fi/models/caffe-heatmap-flic.caffemodel -P ../../models/heatmap-flic-fusion/

% Options

clear all;
clc;
close all;

opt.visualise = false;		% Visualise predictions?
opt.debug = false; 
opt.useGPU = true; 			% Run on GPU
opt.dims = [256 256]; 		% Input dimensions (needs to match matlab.txt)
opt.numJoints = 7; 			% Number of joints
opt.layerName = 'conv5_fusion'; % Output layer name
opt.modelDefFile = '../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/matlab.prototxt'; % Model definition
opt.modelFile = '../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'; % Model weights

%opt.modelFile = '/data/tp/nets/heatmap-flic-fusion/snapshots/heatmap_train_iter_29600.caffemodel';

% Add caffe matlab into path
addpath(genpath('../../libs/caffe-heatmap-master/matlab'));

% Image input directory
opt.inputDir = 'caffe-heatmap-master/matlab/pose/sample_images2/';

%for all videos and boxes

path = '../../datasets/tv_human_interaction_videos/';

videos = dir([path '*.avi']);
boxes = dir([path '*boxes.mat']);

opt.net = initCaffe(opt);

for i=189:length(videos)
    disp([videos(i).name , ' ', num2str(i), ' out of ', num2str(length(videos))]);
    disp([boxes(i).name , ' ', num2str(i), ' out of ', num2str(length(boxes))]);
    video = VideoReader([path videos(i).name]);
    load([path boxes(i).name]);
    opt.bboxes = bboxes;
    % Apply network
    joints = applyNet(video, opt);
    [p,name,ext] = fileparts(videos(i).name);
    save([path name, 'joints.mat'], 'joints');

end
caffe.reset_all(); 
clear mex;