clc;
close all;
clear all;

[folder, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(fullfile('..','..','libs','faster_rcnn')));
addpath(genpath(fullfile('..','..','libs','caffe-faster-rcnn')));

model = set_up_model();

path = '../../datasets/tv_human_interaction_videos/tv_human_interactions_videos/';

files = dir([path '*.avi']);

for i = 1:length(files)
   video = VideoReader([path files(i).name]);
   bboxes = generate_boxes(video, model);
   [folder, name, ext] = fileparts(files(i).name);
   save([path name 'boxes.mat'], 'bboxes');
end




