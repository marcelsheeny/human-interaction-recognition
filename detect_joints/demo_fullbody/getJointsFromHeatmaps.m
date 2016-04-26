function [ joints ] = getJointsFromHeatmaps( heatmaps, opt )
%GETJOINTSFROMHEATMAPS Summary of this function goes here
%   Detailed explanation goes here

heatmaps = mat2gray(heatmaps);

[r,c,k] = size(heatmaps);

joints = zeros(2,opt.numJoints);

for id = 1:size(opt.relatedJoints,1);
  
    i = opt.relatedJoints(id,1);
    if (id == 3)
        [thres,CC,heatmaps_process] = find_threshold(heatmaps(:,:,i),opt,true);
    else
        [thres,CC,heatmaps_process] = find_threshold(heatmaps(:,:,i),opt,false);
    end

    %heatmaps_process = (heatmaps(:,:,i) > thres);

    numPixels = cellfun(@numel,CC.PixelIdxList);
    [sorted,idx] = sort(numPixels,'descend');

    if (CC.NumObjects > 2)
        for ind=length(sorted):3
            heatmaps_process(CC.PixelIdxList{idx(ind)}) = 0;
        end
    elseif (CC.NumObjects == 1)
        layer = heatmaps(:,:,i);
        vec = layer(:);
        [val,idxs] = max(vec);
        [y,x] = ind2sub([256 256], idxs);
        joints(:,opt.relatedJoints(id,1)) = [x;y];
        joints(:,opt.relatedJoints(id,2)) = [x;y];
        continue;
    end

    heatmaps_process(CC.PixelIdxList{idx(2)}) = 0;

    component1 = heatmaps_process;
    
    heatmaps_process(CC.PixelIdxList{idx(2)}) = 1;
    heatmaps_process(CC.PixelIdxList{idx(1)}) = 0;

    component2 = heatmaps_process;

    component1 = component1.*heatmaps(:,:,i);
    component2 = component2.*heatmaps(:,:,i);

    vec = component2(:);
    [val,idxs] = max(vec);
    [y1,x1] = ind2sub([256 256], idxs);
    
    vec = component1(:);
    [val,idxs] = max(vec);
    [y2,x2] = ind2sub([256 256], idxs);
    
    %figure;
    %imshow(heatmaps(:,:,i),[]); hold on;
    %plot(x1,y1,'r*'); hold on;
    %plot(x2,y2,'r*');
    %waitforbuttonpress
    
    if (x1 < x2)
        joints(:,opt.relatedJoints(id,1)) = [x1;y1];
        joints(:,opt.relatedJoints(id,2)) = [x2;y2];
    else
        joints(:,opt.relatedJoints(id,1)) = [x2;y2];
        joints(:,opt.relatedJoints(id,2)) = [x1;y1];
    end
end

for id = 1:size(opt.independentJoints,1)
    layer = heatmaps(:,:,opt.independentJoints(id,1));
    vec = layer(:);
    [val,idx] = max(vec);
    [y,x] = ind2sub([256 256], idx);
    joints(:,opt.independentJoints(id,1)) = [x;y];
end




end

function [thre,cc,imthres] = find_threshold(heatmap,opt,hips)

    if (hips)
        [thre,cc,imthres] = find_threshold_params(heatmap,opt,0.01,0.3,0.25);
    else
        [thre,cc,imthres] = find_threshold_params(heatmap,opt,0.05,0.3,0.25);

    end
end

function [thre,cc,imthres] = find_threshold_params(heatmap,opt,interval,percent_allowed,dif_thre)
    cc = struct;
    for i=1:-interval:0
        imthres = heatmap>i;
        CC = bwconncomp(imthres);
        if (CC.NumObjects == 1)
           cc = CC;
           thre = i;

        elseif (CC.NumObjects >= 2)
            max_regions = zeros(CC.NumObjects,1);
            for j=1:CC.NumObjects
               temp = zeros(opt.dims);
               [x,y] = ind2sub(opt.dims,round(CC.PixelIdxList{j}));
               temp(x(:,1),y(:,1)) = 1;
               temp = temp.*heatmap;
               vec = temp(:);
               [val,idx] = max(vec);
               max_regions(j,1) = val;
            end
            [max_val, max_ind] = max(max_regions);
            [min_val, min_ind] = min(max_regions);

            dif = max_val - min_val;
            if (dif > dif_thre)
                cc = struct;
                cc.Connectivity = CC.Connectivity;
                cc.ImageSize = CC.ImageSize;
                cc.NumObjects = 0;
                cc.PixelIdxList = {};
                for j=1:CC.NumObjects
                    if (max_regions(j,1) >= (max_val-(dif*percent_allowed)))
                       cc.NumObjects =  cc.NumObjects + 1;
                       cc.PixelIdxList{cc.NumObjects} = CC.PixelIdxList{j};
                    end
                end
                imthres = zeros(opt.dims);
                for j=1:CC.NumObjects
                    [x,y] = ind2sub(opt.dims,round(CC.PixelIdxList{j}));
                    imthres(x(:,1),y(:,1)) = 1;
                end
            else
                cc = CC;
            end
            thre = i;
            break;
        end 
    end
end
