% Apply network to a single image
function [joints, heatmaps] = applyNetImage(im, opt)

% Read & reformat input image
input_data = prepareImagePose(im, opt);

% Forward pass
%tic
opt.net.forward({input_data});
features = opt.net.blobs(opt.layerName).get_data();
[joints, heatmaps] = processHeatmap(features, opt);
%disp(toc); 

%{
labels = ['1RightAnkle   '; ...
          '2RightKnee    '; ...
          '3RightHip     '; ...
          '4LeftHip      '; ...
          '5LeftKnee     '; ...
          '6LeftAnkle    '; ...
          '7RightWrist   '; ...
          '8RightElbow   '; ...
          '9RightShoulder'; ...
          '10LeftShoulder'; ...
          '11LeftElbow   '; ...
          '12LeftWrist   '; ...
          '13Neck        '; ...
          '14HeadTop     '];
%}   
labels{1} = '1RightAnkle';
labels{2} = '2RightKnee';
labels{3} = '3RightHip';
labels{4} = '4LeftHip';
labels{5} = '5LeftKnee';
labels{6} = '6LeftAnkle';
labels{7} = '7RightWrist';
labels{8} = '8RightElbow';
labels{9} = '9RightShoulder';
labels{10} = '10LeftShoulder';
labels{11} = '11LeftElbow';
labels{12} = '12LeftWrist';
labels{13} = '13Neck';
labels{14} = '14HeadTop';
labels{15} = '15TopLeftCorner';
labels{16} = '16TopRightCorner';
labels{17} = '17BottomLeftCorner';
labels{18} = '18BottomRightCorner';

      


% Visualisation
if opt.visualise
    % Heatmap
    %heatmapVis = getConfidenceImage(heatmaps, im);
    %figure(2),imshow(heatmapVis);

    figure;
    for i=1:opt.numJoints
        subplot(4,5,i);
        imshow(heatmaps(:,:,i),[]);
        title(labels{i});
    end

    % Original image overlaid with joints
    figure;
    imshow(uint8(opt.im_original)), hold on;
    
    plot_fullbody(joints, labels);
    hold off;
    %for i = 1: opt.numJoints
    %    plot(joints(1,i), joints(2,i), 'r*');
    %   text(joints(1,i), joints(2,i), num2str(i), 'Color', 'yellow');
    %end
    %plotSkeleton(joints, [], []);

end

