clear all;
close all;
clc;

path = '../../datasets/kinect_interaction/';

sets = dir([path '*/']);
sets(1:2) = [];

%video_files = dir([dir_path '*.avi']);

for set=1:size(sets,1)
    disp([num2str(set) ' sets out of ' num2str(size(sets,1))]);
    interactions = dir([path sets(set).name '/*/']);
    interactions(1:2) = [];
    
    for j=1:size(interactions,1)
       
        samples = dir([path sets(set).name '/' interactions(j).name '/*/']);
        samples(1:2) = [];
        
        for k=1:size(samples,1)
           
            image_files = dir([path sets(set).name '/' interactions(j).name '/' samples(k).name '/rgb*']);
            
            images = cell(1);
            
            boxes_path = dir([path sets(set).name '/' interactions(j).name '/' samples(k).name  '/annotation*.mat']);

            boxes_path = [path sets(set).name '/' interactions(j).name '/' samples(k).name '/' boxes_path(1).name];


            load(boxes_path);
    
            for image_idx = 1:length(image_files)
                images{image_idx} = imread([path sets(set).name '/' interactions(j).name '/' samples(k).name '/' image_files(image_idx).name]);
                
                imshow(images{image_idx}); hold on;
                
                for rect=1:length(annotation.tracked_bboxes{image_idx})
                    rectangle('Position', annotation.tracked_bboxes{image_idx}{rect}.bbox);
                    text(double(annotation.tracked_bboxes{image_idx}{rect}.bbox(1,1)),double(annotation.tracked_bboxes{image_idx}{rect}.bbox(1,2)),num2str(rect));
                end
                pause(0.00001);
            end

        end
    end
end