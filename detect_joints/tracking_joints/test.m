clc;
close all;
clear all;

% INIT PARAMETERS FOR DETECT JOINTS
opt.visualise = false;		% Visualise predictions?
opt.useGPU = true; 			% Run on GPU
opt.dims = [256 256]; 		% Input dimensions (needs to match matlab.txt)
opt.numJoints = 7; 			% Number of joints
opt.layerName = 'conv5_fusion'; % Output layer name
%opt.modelDefFile = '../../libs/caffe-heatmap-master/models/heatmap-fullbody-3/deploy.prototxt'; % Model definition
opt.modelDefFile = '../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/matlab.prototxt'; % Model definition
opt.modelFile = '../../libs/caffe-heatmap-master/models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'; % Model weights
%opt.modelFile = '../../libs/caffe-heatmap-master/data/tp/nets/heatmap-fullbody-3/snapshots/heatmap_train_iter_16800.caffemodel'; % Model weights


% Add caffe matlab into path
addpath('../../libs/caffe-heatmap-master/matlab')

% Initialise caffe
opt.net = initCaffe(opt);

video = VideoReader('../../datasets/tv_human_interaction_videos/highFive_0040.avi');
load('../../datasets/tv_human_interaction_videos/highFive_0040boxes.mat');



for i=1:length(bboxes)
    video.CurrentTime = i/video.FrameRate;
    frame = readFrame(video);
    opt.im_original = frame;
    imshow(frame);
    hold on;
    
    for j=1:size(bboxes{i},1)
       x = bboxes{i}(j,1);
       y = bboxes{i}(j,2);
       w = bboxes{i}(j,3) - x;
       h = bboxes{i}(j,4) - y; 
        
       rect = [x y w h];
       im_crop = imcrop(frame,rect);
       im_resize = imresize(im_crop, opt.dims);
       joints =  detect_joints(im_resize,opt);
       joints = double(joints);
       [row,col,depth] = size(im_crop);
       
       rx = col/opt.dims(1);
       ry = row/opt.dims(2);
       
       joints(1,:) = joints(1,:).*rx;
       joints(2,:) = joints(2,:).*ry;
       
       joints(1,:) = joints(1,:) + x;
       joints(2,:) = joints(2,:) + y;
       
       %imshow(im_resize); hold on;
       plotSkeleton(joints,[],[],[]);
       
       %for aa=1:7
       %   plot(joints(1,aa), joints(2,aa), 'r*');
       %   text(joints(1,aa), joints(2,aa), num2str(aa), 'Color', 'yellow');
       %end
       
       rectangle('Position',rect, 'EdgeColor', 'blue'); 
       
    end
    waitforbuttonpress
    
end



