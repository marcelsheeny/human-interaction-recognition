%% Demo code of "Convolutional Pose Machines", 
% Shih-En Wei, Varun Ramakrishna, Takeo Kanade, Yaser Sheikh
% In CVPR 2016
% Please contact Shih-En Wei at shihenw@cmu.edu for any problems or questions
%%
close all;
addpath('src'); 
addpath('util');
addpath('util/ojwoodford-export_fig-5735e6d/');
param = config();

fprintf('Description of selected model: %s \n', param.model(param.modelID).description);

%% Edit this part
% put your own test image here
%test_image = 'sample_image/singer.jpg';
%test_image = 'sample_image/shihen.png';
%test_image = 'sample_image/roger.png';
test_image = 'test5.png';
%test_image = 'sample_image/nadal.png';
%test_image = 'sample_image/LSP_test/im1640.jpg';
%test_image = 'sample_image/CMU_panoptic/00000998_01_01.png';
%test_image = 'sample_image/CMU_panoptic/00004780_01_01.png';
%test_image = 'sample_image/FLIC_test/princess-diaries-2-00152201.jpg';
interestPart = 'Lwri'; % to look across stages. check available names in config.m

%% core: apply model on the image, to get heat maps and prediction coordinates
%figure(1); 
%imshow(test_image);
%hold on;
%title('Drag a bounding box');
%rectangle = getrect(1);

path = '../../../datasets/kinect_interaction/';

sets = dir([path '*/']);
sets(1:2) = [];

%video_files = dir([dir_path '*.avi']);

for set=1:size(sets,1)
    disp([num2str(set) ' sets out of ' num2str(size(sets,1))]);
    interactions = dir([path sets(set).name '/*/']);
    interactions(1:2) = [];
    if (set == 1)
        ini = 7;
    else
        init = 1;
    end
    for j=ini:size(interactions,1)
       
        samples = dir([path sets(set).name '/' interactions(j).name '/*/']);
        samples(1:2) = [];
        
        for k=1:size(samples,1)
           
            image_files = dir([path sets(set).name '/' interactions(j).name '/' samples(k).name '/rgb*']);
            
            images = cell(1);
            
            boxes_path = dir([path sets(set).name '/' interactions(j).name '/' samples(k).name  '/annotation*.mat']);

            boxes_path = [path sets(set).name '/' interactions(j).name '/' samples(k).name '/' boxes_path(1).name];
            
            load(boxes_path);
            
            joints_prediction = cell(1);
            
            for image_idx = 1:length(image_files)
                images{image_idx} = imread([path sets(set).name '/' interactions(j).name '/' samples(k).name '/' image_files(image_idx).name]);
                
                imshow(images{image_idx}); hold on;
                
                joints_prediction{image_idx} = cell(1);
                
                for rect=1:length(annotation.tracked_bboxes{image_idx})
                    %increase joint siz
                    ratex = 0.15;
                    ratey = 0.1;
                    
                    tracks = annotation.tracked_bboxes{image_idx}{rect};
                    
                    for tr=1:size(tracks,2)
                        wid = tracks(tr).bbox(3)*ratex;
                        hei = tracks(tr).bbox(4)*ratey;
                        tracks(tr).bbox = [tracks(tr).bbox(1) - wid tracks(tr).bbox(2) - hei tracks(tr).bbox(3) + 2*wid tracks(tr).bbox(4) + 2*hei];
                    end
                    
                    annotation.tracked_bboxes{image_idx}{rect} = tracks;
                    annotation.tracked_bboxes{image_idx}{rect}.bbox = double(annotation.tracked_bboxes{image_idx}{rect}.bbox);
                    
                    if (rect == 1)
                        color = [1 0 0];
                    else
                        color = [0 1 0];
                    end
                    
                    rectangle('Position', annotation.tracked_bboxes{image_idx}{rect}.bbox, 'EdgeColor', color, 'LineWidth', 3); hold on;
                    
                    [heatMaps, prediction] = applyModel(images{image_idx}, param, annotation.tracked_bboxes{image_idx}{rect}.bbox);
                    
                    prediction = post_processing(prediction,heatMaps);
                    
                    plot_fullbody(prediction);
                    
                    joints_prediction{image_idx}{rect} = prediction;
                    
                    
                    % clear
                    caffe.reset_all(); 
                    clear mex;
                end
                drawnow;
                
                export_fig([path sets(set).name '/' interactions(j).name '/' samples(k).name '/' 'annotated_' image_files(image_idx).name]);
                
            end
            annotation.joints_prediction = joints_prediction;
            
            save(boxes_path, 'annotation');
            
            % visualize, or extract variable heatMaps & prediction for your use
            %visualize(test_image, heatMaps, prediction, param, rectangle, interestPart);
        end
    end
end



%% clear
caffe.reset_all(); 
clear mex;