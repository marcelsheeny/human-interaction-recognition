% Wrapper to run network on multiple images
function [all_joints, heatmaps, opt] = applyNet(video, opt)

%fprintf('config:\n\n');
%disp(opt)
%fprintf('\n');
    all_joints = {};
    %net = initCaffe(opt); 
    
    n_frames = min(length(opt.bboxes), video.FrameRate*video.Duration);
    
    for f=1:n_frames
        disp(['frame: ', num2str(f), ' out of: ', num2str(video.FrameRate*video.Duration)]);
        im = readFrame(video);
        if (f/video.FrameRate > video.Duration)
            video.CurrentTime = video.Duration;
        else
            video.CurrentTime = f/video.FrameRate;
        end
        frame_joints = [];
        for i=1:size(opt.bboxes{f},2)
            if (~isempty(opt.bboxes{f}{i}))
                bbox = opt.bboxes{f}{i}.bbox;
                im_crop = imcrop(im,bbox);

                ratex = size(im_crop,2)/opt.dims(1);
                ratey = size(im_crop,1)/opt.dims(2);

                im_resize = imresize(im_crop, opt.dims);

                % Apply network separately to each image
                [joints, heatmaps] = applyNetImage(im_resize, opt);
                opt.bboxes{f}{i}.heatmaps = heatmaps;
                %track joints
                %new_joints = zeros(opt.numJoints,3);
                               
                %new_joints = 
                [joints] = track_and_process_heatmaps(i,opt,5,f);
                %opt.bboxes{f}{i}. = candidates;
                if (opt.debug)
                    figure(1);
                    imshow(im); hold on;
                    rectangle('Position', bbox);
                    str = [];

                end
                temp_joints = [];
                joints
                for j = 1: opt.numJoints
                    x = double(joints(1,j)*ratex+double(opt.bboxes{f}{i}.bbox(1,1)));
                    y = double(joints(2,j)*ratey+double(opt.bboxes{f}{i}.bbox(1,2)));
                    temp_joints = [temp_joints, x,y];
                    if (opt.debug)
                        %str = [str, num2str(x) ',' num2str(y) ','];
                        %plot(x,y, 'r*');
                        %text(x,y, num2str(j), 'Color', 'yellow');

                    end
                end
                joints = reshape(temp_joints,[2 14])';
                opt.bboxes{f}{i}.joints = joints;
                
                frame_joints = [frame_joints; temp_joints];
            end
        end
        
        all_joints{f} = frame_joints;
        if(opt.debug)
            for p=1:size(opt.bboxes{f},1)
                if (~isempty(opt.bboxes{f}{p}) && isfield(opt.bboxes{f}{p} ,'joints'))
                    plot_fullbody2(opt.bboxes{f}{p}.joints,[]); hold on;
                end
            end
            waitforbuttonpress;
        end

    end
end