clc;
close all;
clear all;

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
           
            image_files = dir([path sets(set).name '/' interactions(j).name '/' samples(k).name '/annotated*']);
            outputVideo = VideoWriter([path sets(set).name '/' interactions(j).name '/' samples(k).name '/video.avi']);
            outputVideo.FrameRate = 10;
            open(outputVideo)
            im = imread([path sets(set).name '/' interactions(j).name '/' samples(k).name '/' image_files(1).name]);
            [sizi,sizj,z] = size(im);
            
            for l=1:length(image_files)
            
                im = imread([path sets(set).name '/' interactions(j).name '/' samples(k).name '/' image_files(l).name]);
                
                im = imresize(im,[sizi, sizj]);
                
                %imshow(im)
                
                %waitforbuttonpress
                
                writeVideo(outputVideo,im)
                
            end
            close(outputVideo);
        end
    end
end
            