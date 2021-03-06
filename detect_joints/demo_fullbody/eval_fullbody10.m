% This file uses a FLIC trained model and applies it to a video sequence from Poses in the Wild
%
% Download the model:
%    wget http://tomas.pfister.fi/models/caffe-heatmap-flic.caffemodel -P ../../models/heatmap-flic-fusion/

% Options

clear all;
clc;
close all;

opt.visualise = false;		% Visualise predictions?
opt.useGPU = true; 			% Run on GPU
opt.dims = [256 256]; 		% Input dimensions (needs to match matlab.txt)
opt.numJoints = 14; 			% Number of joints
opt.layerName = 'conv5_fusion'; % Output layer name
opt.modelDefFile = '../../../libs/caffe-heatmap-master/models/heatmap-fullbody-10/matlab.prototxt'; % Model definition
%opt.modelFile = '../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'; % Model weights
opt.modelFile = '../../../libs/caffe-heatmap-master/data/tp/nets/heatmap-fullbody-10/snapshots/heatmap_train_iter_341600.caffemodel'; % Model weights
opt.relatedJoints = [1 6;
                     2 5;
                     3 4;
                     7 12;
                     8 11;
                     9 10];
opt.independentJoints = [13;
                         14];
                     
opt.process_heatmap = false;

% Add caffe matlab into path
addpath('../../../libs/caffe-heatmap-master/matlab')

%im = imread('im1170.jpg');
%im = imread('485631973.jpg');
%im = imread('im1424.jpg');
im = imread('im1384.jpg');
im = imresize(im, [256 256]);

opt.im_original = im;

%im(:,:,1) = im(:,:,1) - 115.6997;
%im(:,:,2) = im(:,:,2) - 108.5686;
%im(:,:,3) = im(:,:,3) - 100.8425;

pred = zeros(2,14,1000);

path_images = 'images/';

addpath('/home/visionlab/marcel/code/detect_joints/conv-pose-machines/util/ojwoodford-export_fig-5735e6d/');

file_images = dir([path_images '*.jpg']);

opt.convertJoints =          [1 13;
                          2 11;
                          3 9;
                          4 10;
                          5 12;
                          6 14;
                          7 3;
                          8 5;
                          9 7;
                          10 8;
                          11 6;
                          12 4;
                          13 2;
                          14 1];

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

for i=1:length(file_images)

    im = imread([path_images file_images(i).name]);
    
    [he,wi,de] = size(im);
    
    ratex = wi/256;
    ratey = he/256;
    
    opt.im_original = im;
    im = imresize(im, [256 256]);
    
    % Apply network
    [joints,heatmaps] = applyNet(im, opt);

    joints(1,:) = joints(1,:)*ratex;
    joints(2,:) = joints(2,:)*ratey;
    
    joints = convertJoints (joints',opt);
    
    joints = joints';
    close all;
    figure(1);
    
    visualize_data(opt.im_original,joints',conn_joints,colors,false,false);
    
    export_fig(['preds_fullbody_10/' file_images(i).name]);
    
    caffe.reset_all();
    clear mex;
    i
    
    
    pred(:,:,i) = joints;
end

save('pred_fullbody10_oc.mat','pred');

caffe.reset_all();
clear mex;

caffe.reset_all();
clear mex;