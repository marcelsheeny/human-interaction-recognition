function bboxes = detect_person_faster(im, model)


%% -------------------- TESTING --------------------
%im_names = {'001763.jpg', '004545.jpg', '000542.jpg', '000456.jpg', '001150.jpg'};
%im_names = {'test.jpg'};
% these images can be downloaded with fetch_faster_rcnn_final_model.m
rpn_net = model.rpn_net;
fast_rcnn_net = model.fast_rcnn_net;
opts = model.opts;
proposal_detection_model = model.proposal_detection_model;

running_time = [];
%for j = 1:length(im_names)
    
    %im = imread(fullfile(pwd, im_names{j}));
    
    if opts.use_gpu
        im = gpuArray(im);
    end
    
    % test proposal
    th = tic();
    [boxes, scores]             = proposal_im_detect(proposal_detection_model.conf_proposal, rpn_net, im);
    t_proposal = toc(th);
    th = tic();
    aboxes                      = boxes_filter([boxes, scores], opts.per_nms_topN, opts.nms_overlap_thres, opts.after_nms_topN, opts.use_gpu);
    t_nms = toc(th);
    
    % test detection
    th = tic();
    if proposal_detection_model.is_share_feature
        [boxes, scores]             = fast_rcnn_conv_feat_detect(proposal_detection_model.conf_detection, fast_rcnn_net, im, ...
            rpn_net.blobs(proposal_detection_model.last_shared_output_blob_name), ...
            aboxes(:, 1:4), opts.after_nms_topN);
    else
        [boxes, scores]             = fast_rcnn_im_detect(proposal_detection_model.conf_detection, fast_rcnn_net, im, ...
            aboxes(:, 1:4), opts.after_nms_topN);
    end
    t_detection = toc(th);
    
    fprintf('%s (%dx%d): time %.3fs (resize+conv+proposal: %.3fs, nms+regionwise: %.3fs)\n', ...
        size(im, 2), size(im, 1), t_proposal + t_nms + t_detection, t_proposal, t_nms+t_detection);
    running_time(end+1) = t_proposal + t_nms + t_detection;
    
    % visualize
    %classes = proposal_detection_model.classes;
    classes = {'person'};
    person_id = 15;
    boxes_cell = cell(length(classes), 1);
    thres = 0.6;
    %for i = 1:length(boxes_cell)
    %    boxes_cell{i} = [boxes(:, (1+(i-1)*4):(i*4)), scores(:, i)];
    %    boxes_cell{i} = boxes_cell{i}(nms(boxes_cell{i}, 0.3), :);
    %    
    %    I = boxes_cell{i}(:, 5) >= thres;
    %    boxes_cell{i} = boxes_cell{i}(I, :);
    %end
    
    boxes_cell{1} = [boxes(:, (1+(person_id-1)*4):(person_id*4)), scores(:, person_id)];
    boxes_cell{1} = boxes_cell{1}(nms(boxes_cell{1}, 0.3), :);
    I = boxes_cell{1}(:, 5) >= thres;
    boxes_cell{1} = boxes_cell{1}(I, :);
    
    %showboxes(im, boxes_cell, classes, 'voc');
    %pause(0.1);
    
    bboxes = boxes_cell{1};
%end
%fprintf('mean time: %.3fs\n', mean(running_time));

%caffe.reset_all(); 
%clear mex;

end


function aboxes = boxes_filter(aboxes, per_nms_topN, nms_overlap_thres, after_nms_topN, use_gpu)
    % to speed up nms
    if per_nms_topN > 0
        aboxes = aboxes(1:min(length(aboxes), per_nms_topN), :);
    end
    % do nms
    if nms_overlap_thres > 0 && nms_overlap_thres < 1
        aboxes = aboxes(nms(aboxes, nms_overlap_thres, use_gpu), :);       
    end
    if after_nms_topN > 0
        aboxes = aboxes(1:min(length(aboxes), after_nms_topN), :);
    end
end
