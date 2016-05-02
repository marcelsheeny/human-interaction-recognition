clc;
close all;
clear all;

path_video = '../../datasets/human_activities_videos/seq4.avi';

path_detections = '../../datasets/human_activities_videos/seq4boxes.mat';

video = VideoReader(path_video)

load(path_detections)

str = [];

file = fopen('../../datasets/human_activities_videos/seq4/det.txt','w');

for i=1:size(bboxes,2);
   disp(i)
   video.CurrentTime = i/video.FrameRate;
   
   frame = readFrame(video);
   %imshow(frame);
   
   for j=1:size(bboxes{i},1)
        str = [str, num2str(i) ',-1,' num2str(bboxes{i}(j,1)) ',' num2str(bboxes{i}(j,2)) ',' num2str(bboxes{i}(j,3) - bboxes{i}(j,1)) ...
            ',' num2str(bboxes{i}(j,4) - bboxes{i}(j,2)) ',' num2str(bboxes{i}(j,5)) '\n'];
   end
   if (i<10)
        imwrite(frame,['../../datasets/human_activities_videos/seq4/seq4_000', num2str(i) '.jpg']);
   elseif(i<100)
        imwrite(frame,['../../datasets/human_activities_videos/seq4/seq4_00', num2str(i) '.jpg']);
   elseif(i<1000)
       imwrite(frame,['../../datasets/human_activities_videos/seq4/seq4_0', num2str(i) '.jpg']);
   else
       imwrite(frame,['../../datasets/human_activities_videos/seq4/seq4_', num2str(i) '.jpg']);
   end
end

fprintf(file,str);

