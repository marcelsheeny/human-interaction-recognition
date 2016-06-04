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
            shuttleAvi = VideoReader([path sets(set).name '/' interactions(j).name '/' samples(k).name '/video.avi']);
            ii = 1;
            clear mov;
            while hasFrame(shuttleAvi)
               mov(ii) = im2frame(readFrame(shuttleAvi));
               ii = ii+1;
            end
            
            f = figure;
            f.Position = [150 150 shuttleAvi.Width shuttleAvi.Height];

            ax = gca;
            ax.Units = 'pixels';
            ax.Position = [0 0 shuttleAvi.Width shuttleAvi.Height];

            image(mov(1).cdata,'Parent',ax)
            axis off
            
            movie(mov,1,shuttleAvi.FrameRate)
            
            
        end
    end
end