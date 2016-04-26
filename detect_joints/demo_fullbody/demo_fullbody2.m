% This file uses a FLIC trained model and applies it to a video sequence from Poses in the Wild
%
% Download the model:
%    wget http://tomas.pfister.fi/models/caffe-heatmap-flic.caffemodel -P ../../models/heatmap-flic-fusion/

% Options

clear all;
close all;
clc;

opt.visualise = true;		% Visualise predictions?
opt.useGPU = true; 			% Run on GPU
opt.dims = [256 256]; 		% Input dimensions (needs to match matlab.txt)
opt.numJoints = 18; 			% Number of joints
opt.layerName = 'conv5_fusion'; % Output layer name
opt.modelDefFile = '../../../libs/caffe-heatmap-master/models/heatmap-fullbody-2/deploy.prototxt'; % Model definition
%opt.modelFile = '../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'; % Model weights
opt.modelFile = '../../../libs/caffe-heatmap-master/data/tp/nets/heatpmap-fullbody-2/snapshots/heatmap2_train_iter_50000.caffemodel'; % Model weights
opt.relatedJoints = [1 6;
                     2 5;
                     3 4;
                     7 12;
                     8 11;
                     9 10];
opt.independentJoints = [13;
                         14];

opt.process_heatmap = true;
                     
% Add caffe matlab into path
addpath('../../../libs/caffe-heatmap-master/matlab')

%im = imread('im1170.jpg');
im = imread('485631973.jpg');
im = imresize(im, [256 256]);

opt.im_original = im;

%im(:,:,1) = im(:,:,1) - 115.5111;
%im(:,:,2) = im(:,:,2) - 108.4287;
%im(:,:,3) = im(:,:,3) - 100.6613;

% Apply network
[joints,heatmaps] = applyNet(im, opt);

joints