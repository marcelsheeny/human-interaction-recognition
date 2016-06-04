clear all;
close all;
clc;

path = '../../datasets/ut-interaction/';

sets = dir([path 'set*']);

%i = 1;
%j = 1;
%k = 1;

for set=1:size(sets,1)
    disp([num2str(set) ' sets out of ' num2str(size(sets,1))]);
    videos = dir([path sets(set).name '/*/']);
    videos(1:2) = [];

    for j=33:size(videos,1)
        
        image_files = dir([path sets(set).name '/' videos(j).name '/rgb*']);


            
            images = cell(1);
            
            boxes_path = [path sets(set).name '/' videos(j).name  '/annotations.mat'];


            load(boxes_path);
        close all
            for image_idx = 1:length(image_files)
                images{image_idx} = imread([path sets(set).name '/' videos(j).name '/' image_files(image_idx).name]);
                
                imshow(images{image_idx}); hold on;
                
                for rect=1:length(annotation.tracked_bboxes{image_idx})
                    rectangle('Position', annotation.tracked_bboxes{image_idx}{rect}.bbox);
                    text(double(annotation.tracked_bboxes{image_idx}{rect}.bbox(1,1)),double(annotation.tracked_bboxes{image_idx}{rect}.bbox(1,2)),num2str(rect));
                end
                drawnow;
            end

    end
end