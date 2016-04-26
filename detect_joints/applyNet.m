% Wrapper to run network on multiple images
function [all_joints, heatmaps] = applyNet(video, opt)

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
        for i=1:size(opt.bboxes{f},1)

            im_crop = imcrop(im,[opt.bboxes{f}(i,1:2), opt.bboxes{f}(i,3:4) - opt.bboxes{f}(i,1:2)] );
            
            ratex = size(im_crop,2)/opt.dims(1);
            ratey = size(im_crop,1)/opt.dims(2);

            im_resize = imresize(im_crop, opt.dims);

            % Apply network separately to each image
            [joints, heatmaps] = applyNetImage(im_resize, opt);
            
            if (opt.debug)
                figure(1);
                imshow(im); hold on;
                rectangle('Position', [opt.bboxes{f}(i,1:2), opt.bboxes{f}(i,3:4) - opt.bboxes{f}(i,1:2)]);
                str = [];
            end
            temp_joints = [];
            for j = 1: opt.numJoints
                x = double(joints(1,j)*ratex+opt.bboxes{f}(i,1));
                y = double(joints(2,j)*ratey+opt.bboxes{f}(i,2));
                temp_joints = [temp_joints, x,y];
                if (opt.debug)
                    str = [str, num2str(x) ',' num2str(y) ','];
                    plot(x,y, 'r*');
                    text(x,y, num2str(j), 'Color', 'yellow');
                end
            end
            frame_joints = [frame_joints; temp_joints];
        end
        
        if(opt.debug)
            waitforbuttonpress;
        end
        all_joints{f} = frame_joints;

    end
end