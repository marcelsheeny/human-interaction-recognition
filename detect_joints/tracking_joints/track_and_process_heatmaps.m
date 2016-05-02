function [joints] = track_and_process_heatmaps(person,obj,number_previous_frames, frame)
%TRACK_AND_PROCESS_HEATMAPS Summary of this function goes here
%   Detailed explanation goes here

%sumHeatmaps = zeros(size(obj.bboxes{frame}{person},1), size(obj.bboxes{frame}{person},2));

num_candidates = 5;

joints = zeros(obj.numJoints,3);

candidates = zeros(num_candidates,2, obj.numJoints);

for j=1:obj.numJoints
    candidates(:,:,j) = compute_candidates(obj.bboxes{frame}{person}.heatmaps(:,:,j),num_candidates);
end

best_candidate = inf(1,2);

break_flag = 0;

for j=1:obj.numJoints
    if (~isempty(obj.bboxes{frame-1}{person}))
        for c=1:size(candidates,1)
            d = norm(candidates(c,:,j) - obj.bboxes{frame-1}{person}.joints(j,:));
            if ( d  < best_candidate(1,1))
                best_candidate(1,1) = d;
                best_candidate(1,2) = c;
            end
        end
    else
       joints = heatmapToJoints(obj.bboxes{frame}{person}.heatmaps,obj.numJoints);
       break_flag = 1;
       break;
    end
    d = 0;
    total_frames = 0;
    for i=frame-1:-1:frame-number_previous_frames
       if (i > 0 && ~isempty(obj.bboxes{i}{person}))
          d = d + (norm(candidates(best_candidate(1,2),:,j) - obj.bboxes{i}{person}.joints(j,:))); 
          total_frames = total_frames + 1;
       end
    end
    d = d/total_frames
    joints(j,1) = candidates(best_candidate(1,2),1,j);
    joints(j,2) = candidates(best_candidate(1,2),2,j);
    if (d < 15)
        joints(j,3) = 1;
    else
        joints(j,3) = 0;
    end
end

if(break_flag)
    joints(3,:) = zeros(1,obj.numJoints); 
else
    joints = joints';
end
    
                %subplot(3,5,j);
                %imshow(obj.bboxes{i}{person}.heatmaps(:,:,j),[]);hold on;
                %for aa=1:size(candidates,1)
                %   plot(candidates(aa,1),candidates(aa,2), 'r*' );
                %end

    %       waitforbuttonpress;
           %sumHeatmaps = sumHeatmaps + obj.bboxes{i}{person}.heatmaps;
           %for j=1:obj.numJoints
           %   temp = obj.bboxes{i}{person}.heatmaps(:,:,j);
           %   mi = min(temp(:));
           %   ma = max(temp(:));
           %   diff = ma - min;
           %   %sumHeatmaps(:,:,j) = sumHeatmaps(:,:,j) + obj.bboxes{i}{person}.heatmaps(:,:,j);
           %   disp(['person: ' num2str(person) ' min: ' num2str(mi) ' max: ' num2str(ma) ' dif: ' num2str(ma-mi)]);
           %end
        %end
   %end
%end       

%joints = heatmapToJoints(obj.bboxes{i}{person}.heatmaps,obj.numJoints);


end

