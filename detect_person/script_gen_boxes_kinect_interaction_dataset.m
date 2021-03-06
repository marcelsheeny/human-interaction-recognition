clc;
close all;
clear all;

[folder, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(fullfile('..','..','libs','faster_rcnn')));
addpath(genpath(fullfile('..','..','libs','caffe-faster-rcnn')));

opt.debug = false;

model = set_up_model();

path = '../../datasets/kinect_interaction/';

sets = dir([path '*/']);

sets(1:2) = [];

%i = 1;
%j = 1;
%k = 1;

for i=1:size(sets,1)
    disp([num2str(i) ' sets ou of ' num2str(size(sets,1))]);
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
               
            bboxes = generate_boxes_images(images, model,opt);
            
            annotation.numFrames = length(file_images);
            annotation.set = sets(i).name;
            annotation.interaction = interactions(j).name;
            annotation.sample = samples(k).name;
            annotation.bboxes = bboxes;
            
            save([path sets(i).name '/' interactions(j).name '/' samples(k).name '/' 'annotations' num2str(i) '_' num2str(j) '_' num2str(k) '.mat'], 'annotation');
           
            
        end
        
    end
end


caffe.reset_all();
clear mex;




