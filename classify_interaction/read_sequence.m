clc;
close all;
clear all;

%num = csvread('../../datasets/human_activities_videos/human_interaction_gt.csv',2,2,[2 2 7 9]);

%structure
%set [1..2]  seq[1..10]  activity[0..6] x y x y mainactor[left=0, right=1]


%0 - handshaking
%1 - hugging
%2 - kicking
%3 - poiting
%4 - punching
%5 - pushing
%6 - nothing

path = '../../datasets/tv_human_interaction_annotations/';

files = dir([path '*.annotations']);

for i=1:length(files)
    disp([num2str(i), ' out of ', num2str(length(files))])
    annotations = read_tv_human_interaction([path files(i).name]);
    save([path files(i).name 'annotations.mat'], 'annotations');
end
