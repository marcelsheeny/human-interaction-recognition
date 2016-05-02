% Wrapper to run network on multiple images
function [all_joints, heatmaps] = applyNet(images, opt)

%fprintf('config:\n\n');
%disp(opt)
%fprintf('\n');
    all_joints = {};
    %net = initCaffe(opt); 
    
    n_frames = length(images);
    
    for f=1:n_frames
        disp(['frame: ', num2str(f), ' out of: ', num2str(n_frames)]);
        im = images{f};
        
        frame_joints = [];
        for i=1:size(opt.bboxes{f},1)
            x = opt.bboxes{f}(i,1);
            y = opt.bboxes{f}(i,2);
            w = opt.bboxes{f}(i,3) - opt.bboxes{f}(i,1);
            h = opt.bboxes{f}(i,4) - opt.bboxes{f}(i,2);
            
            rate_x = 0.3;
            rate_y = 0.02;
            
            crop_window = [x - w*rate_x y - h*rate_y  w + w*rate_x h-h*rate_y];
            im_crop = imcrop(im,crop_window );
            
            ratex = size(im_crop,2)/opt.dims(1);
            ratey = size(im_crop,1)/opt.dims(2);

            im_resize = imresize(im_crop, opt.dims);

            % Apply network separately to each image
            [joints, heatmaps] = applyNetImage(im_resize, opt);
            
            if (opt.debug)
                figure(1);
                imshow(im); hold on;
                rectangle('Position', crop_window);
                str = [];
                
            end
            temp_joints = [];
            for j = 1: opt.numJoints
                x = double(joints(1,j)*ratex+crop_window(1));
                y = double(joints(2,j)*ratey+crop_window(2));
                temp_joints = [temp_joints, x,y];
                if (opt.debug)
                    %str = [str, num2str(x) ',' num2str(y) ','];
                    %plot(x,y, 'r*');
                    %text(x,y, num2str(j), 'Color', 'yellow');
                    
                end
            end
            
            frame_joints = [frame_joints; temp_joints];
            if(opt.debug)
                temp_joints = reshape(temp_joints, [2,7]);

                hold on
                %plotSkeleton(temp_joints, [], []);
                plot_skeleton_kinect( opt.joints_gt{f}{i} )
                hold off
                waitforbuttonpress;
            end
        end
        
        all_joints{f} = frame_joints;
        

    end
end