clc;
close all;
clear all;

path = 'human_activities_videos/';

files = dir([path '*.mat']);

min_dist = 0.05;

people = cell(1);


for ind=1:length(files)
    
    load([path files(ind).name]);
    %video = VideoReader([path 'seq1.avi']);
    %sizeImage = [video.Height, video.Width];
    sizeImage = [480, 720];
    %load([path 'seq1boxes.mat']);
    num_people = 1;
    first_box = false;
    
    for i=1:size(bboxes,2)
        clc
        disp(['video: ' num2str(ind) ' out of: ' num2str(length(files))]);
        disp(['frame: ' num2str(i) ' out of: ' num2str(size(bboxes,2))]);
        if (size(bboxes{i},1) == 0 && first_box == true)
            for l=1:num_people
                people{l}{i} = cell(1);
                people{l}{i} = people{l}{i-1};
            end
        end
        
        for j = 1:size(bboxes{i},1)
            
            box1 = bboxes{i}(j,1:4);

            if (first_box == false)
               first_box = true;
               people{num_people} = cell(1);
               people{num_people}{i} = box1;
            else
                
                d = -inf(num_people,1);
                
                for k=1:num_people
                    if (i > 1 )
                        if(~isempty(people{k}{i-1}));
                            box2 = people{k}{i-1};
                            d(k,1) = jaccard_index(box1,box2,sizeImage);
                        end
                    else
                        d(k,1) = -inf;
                    end
                end
                
                [min_val, min_ind] = max(d(:,1));
                
                if (min_val < min_dist)
                    
                    for l=1:num_people
                        if (size(people{l},2) ~= i)
                            people{l}{i} = people{l}{i-1};
                        end
                    end
                    num_people = num_people + 1;
                    people{num_people} = cell(1);
                    people{num_people}{i} = box1;
                else
                    for l=1:num_people
                        if (l==min_ind)
                            people{l}{i} = box1;
                        else
                            if (size(people{l},2) ~= i)
                                people{l}{i} = people{l}{i-1};
                            end
                        end
                    end                  
                end               
            end           
        end
    end  
    
    people2 = people;
    for i=1:size(people,2)
       
        for j = 1:size(people{i},2)
           
            if(~isempty(people2{i}{j}))
                
                box = people2{i}{j};

                w = (box(1,3) - box(1,1))*0.35;
                h = (box(1,4) - box(1,2))*0.1;

                bigger_box = [box(1,1)-w box(1,2)-h box(1,3)+w box(1,4)+h];
                
                if (j > 1)
                    if (isempty(people2{i}{j-1}))

                        people2{i}{j} = bigger_box;

                    else

                        people2{i}{j} = (people2{i}{j-1} + bigger_box)/2;

                    end
                end
                
            end
            
        end
        
    end
    
    %{
    video = VideoReader([path 'seq10.avi']);
    cnt = 1;
    while(hasFrame(video))
       frame = readFrame(video);
       imshow(frame);
       hold on;
       for p=1:num_people
            if (~isempty(people2{p}{cnt}))
                draw_rectangle(people2{p}{cnt});
                text(double(people2{p}{cnt}(1,1)), double(people2{p}{cnt}(1,2)), num2str(p));
            end
       end
       pause(0.01);
       cnt = cnt + 1;
    end
    %}
    
    save([path files(ind).name '_tracked.mat'],'people2');
end

