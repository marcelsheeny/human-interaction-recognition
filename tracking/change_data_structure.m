clc;
close all;
clear all;

path = '../../datasets/human_activities_videos/';

files_to_load = dir([path '*matlabtrack.mat']);

for i=1:size(files_to_load,1)
    disp([num2str(i) ' out of ' num2str(size(files_to_load,1))])
    load([path files_to_load(i).name]);

    all_tracks = cell(1);

    max_n = 0;
    for fr=1:size(tracking,2)
       s = [];
       for p=1:size(tracking{fr},2)
          s = [s, tracking{fr}(1,p).id]; 
       end
       s = max(s);
       if (max_n < s)
          max_n = s;
       end
    end

    for fr=1:size(tracking,2)
       all_tracks{fr} = cell(1,max_n);
       for p=1:size(tracking{fr},2)
          all_tracks{fr}{tracking{fr}(1,p).id} = tracking{fr}(1,p); 
       end
    end
    [pa,fi,ex] = fileparts(files_to_load(i).name);
    save([path fi '_processed.mat'],'all_tracks');
    
end
