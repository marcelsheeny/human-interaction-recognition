clc;
close all;
clear all;

[folder, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(fullfile('..','..','libs','faster_rcnn')));
addpath(genpath(fullfile('..','..','libs','caffe-faster-rcnn')));

opt.debug = false;

model = set_up_model();

path = '../../datasets/ut-interaction/';

sets = dir([path 'set*']);

%i = 1;
%j = 1;
%k = 1;

for i=1:size(sets,1)
    disp([num2str(i) ' sets out of ' num2str(size(sets,1))]);
    videos = dir([path sets(i).name '/*/']);
    videos(1:2) = [];
    
    for j=1:size(videos,1)
       
        file_images = dir([path sets(i).name '/' videos(j).name '/rgb*']);
        
        images = cell(1);

        for l = 1:length(file_images)
            images{l} = imread([path sets(i).name '/' videos(j).name '/' file_images(l).name]);
        end

        bboxes = generate_boxes_images(images, model,opt);

        load([path sets(i).name '/' videos(j).name '/annotation.mat']);
        
        annotation.numFrames = length(file_images);
        annotation.interaction = annotation.act;
        annotation = rmfield(annotation,'act');
        annotation.bboxes = bboxes;
%{
        for l = 1:length(file_images)
            imshow(images{l}); hold on;
            for aa = 1:size(bboxes{l},1)
               draw_rectangle(bboxes{l}(aa,1:4)); 
            end
            drawnow;
        end
%}        
        save([path sets(i).name '/' videos(j).name  '/' 'annotation.mat'], 'annotation');
           
        
    end
end


caffe.reset_all();
clear mex;




