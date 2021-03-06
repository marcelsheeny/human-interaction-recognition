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
opt.numJoints = 7; 			% Number of joints
opt.layerName = 'conv5_fusion'; % Output layer name
opt.modelDefFile = '../../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/matlab.prototxt'; % Model definition
opt.modelFile = '../../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'; % Model weights

%opt.modelFile = '/data/tp/nets/heatmap-flic-fusion/snapshots/heatmap_train_iter_29600.caffemodel';

% Add caffe matlab into path
addpath(genpath('../../../libs/caffe-heatmap-master/matlab'));

path = '../../../datasets/kinect_interaction/';

sets = dir([path '*/']);

sets(1:2) = [];

opt.net = initCaffe(opt);

for i=1:size(sets,1)
    disp([num2str(i) ' sets out of ' num2str(size(sets,1))]);
    interactions = dir([path sets(i).name '/*/']);
    interactions(1:2) = [];
    
    for j=1:size(interactions,1)
       
        samples = dir([path sets(i).name '/' interactions(j).name '/*/']);
        samples(1:2) = [];
        
        for k=1:size(samples,1)
           
            file_images = dir([path sets(i).name '/' interactions(j).name '/' samples(k).name '/rgb*']);
            
            images = cell(1);
            
            for l = 1:length(file_images)
                images{l} = imread([path sets(i).name '/' interactions(j).name '/' samples(k).name '/' file_images(l).name]);
            end
            
            bbox_path = dir([path sets(i).name '/' interactions(j).name '/' samples(k).name '/' 'annotation*.mat']);
            
            load([path sets(i).name '/' interactions(j).name '/' samples(k).name '/' bbox_path(1).name]); 
            
            joints_path = [path sets(i).name '/' interactions(j).name '/' samples(k).name '/' 'skeleton_pos.txt'];
            
            [joints,normalized_joints] = load_skeleton(joints_path);
            
            opt.joints_gt = joints;
            opt.normalized_joints_gt = normalized_joints;
            
            opt.bboxes = annotation.bboxes;
            
            joints = applyNet(images, opt);
            
            annotation.joints = joints;
            
            save([path sets(i).name '/' interactions(j).name '/' samples(k).name '/' 'annotations' num2str(i) '_' num2str(j) '_' num2str(k) '.mat'], 'annotation');
           
            
        end
        
    end
end

caffe.reset_all(); 
clear mex;


%for all videos and boxes

%{

path = '../../datasets/human_activities_videos/';

videos = dir([path '*.avi']);

for i=1:length(videos)
    
    [pa,fi,ex] = fileparts(videos(i).name);
   
    load([path fi 'boxes.mat']);    
    
    disp([videos(i).name , ' ', num2str(i), ' out of ', num2str(length(videos))]);
    %disp([boxes(i).name , ' ', num2str(i), ' out of ', num2str(length(boxes))]);
    video = VideoReader([path videos(i).name]);
    
    opt.bboxes = bboxes;
    % Apply network
    joints = applyNet(video, opt);
    [p,name,ext] = fileparts(videos(i).name);
    save([path name, 'joints.mat'], 'joints');

end
caffe.reset_all(); 
clear mex;

%}