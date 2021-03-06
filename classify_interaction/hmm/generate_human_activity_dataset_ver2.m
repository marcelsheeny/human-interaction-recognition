clear all;
close all;
clc;

%{

load('../../../datasets/tv_human_interaction_annotations/highFive_0005.annotationsannotations.mat')

path = '../../../datasets/human_activities_videos/seq1.avi';

video = VideoReader(path);

frame_n = 1300;

video.CurrentTime = frame_n/video.FrameRate;

frame = readFrame(video);

imshow(frame);

x1 = 448; y1 = 120;
x2 = 660; y2 = 400;
w = x2-x1;
h = y2-y1;

rectangle('Position',[x1 y1 w h],'EdgeColor','r');

%}


%0 - hand shaking
%1 - hugging
%2 - kicking
%3 - pointing
%4 - punching
%5 - pushing
%6 - no activity

addpath('../');

path_annotation = '../../../datasets/human_activities_videos/human_interaction_gt_set1.csv';

csv_file = read_mixed_csv(path_annotation,',');

path = '../../../datasets/human_activities_videos/';
%video = VideoReader(path);

keySet = {'seq1','seq2','seq3','seq4','seq5','seq6','seq7','seq8','seq9','seq10' ...
          'seq11','seq12','seq13','seq14','seq15','seq16','seq17','seq18','seq19','seq20'};

valueSet(1:20,1) = cell(1);

seqs = containers.Map(keySet,valueSet);

for seq=keySet
    video = VideoReader(strjoin([path seq '.avi'],''));
    temp = cell(round(video.Duration*video.FrameRate),1);
    for i=1:size(temp,1)
        temp{i} = cell(1);
        temp{i}{1}.activity = 6;
        temp{i}{1}.rect = [1 1 video.Width video.Height];
        temp{i}{1}.main_actor = -1;
    end
    seqs(char(seq)) = temp;
end

for i=3:62
   disp(i)
   seq = char(csv_file(i,2));
   activity = str2num(char(csv_file(i,3)));
   start_f = str2num(char(csv_file(i,4)));
   end_f = str2num(char(csv_file(i,5)));
   x1 = str2num(char(csv_file(i,6)));
   y1 = str2num(char(csv_file(i,7)));
   x2 = str2num(char(csv_file(i,8)));
   y2 = str2num(char(csv_file(i,9)));
   main_actor = str2num(char(csv_file(i,10)));
   
   temp = seqs(seq);
   for f=start_f:end_f
      if (temp{f}{1}.activity == 6)
         temp{f}{1}.activity = activity;
         temp{f}{1}.rect = [x1 y1 x2-x1 y2-y1];
         temp{f}{1}.main_actor = main_actor;
      else
         temp{f}{end+1}.activity = activity;
         temp{f}{end}.rect = [x1 y1 x2-x1 y2-y1];
         temp{f}{end}.main_actor = main_actor;
      end
   end
   seqs(seq) = temp;
end

path_annotation = '../../../datasets/human_activities_videos/human_interaction_gt_set2.csv';
csv_file = read_mixed_csv(path_annotation,',');

for i=3:62
   disp(i)
   seq = char(csv_file(i,1));
   activity = str2num(char(csv_file(i,2)));
   start_f = str2num(char(csv_file(i,3)));
   end_f = str2num(char(csv_file(i,4)));
   x1 = str2num(char(csv_file(i,5)));
   y1 = str2num(char(csv_file(i,6)));
   x2 = str2num(char(csv_file(i,7)));
   y2 = str2num(char(csv_file(i,8)));
   main_actor = str2num(char(csv_file(i,9)));
   
   temp = seqs(seq);
   for f=start_f:end_f
      if (temp{f}{1}.activity == 6)
         temp{f}{1}.activity = activity;
         temp{f}{1}.rect = [x1 y1 x2-x1 y2-y1];
         temp{f}{1}.main_actor = main_actor;
      else
         temp{f}{end+1}.activity = activity;
         temp{f}{end}.rect = [x1 y1 x2-x1 y2-y1];
         temp{f}{end}.main_actor = main_actor;
      end
   end
   seqs(seq) = temp;
end

save('seqs','seqs');