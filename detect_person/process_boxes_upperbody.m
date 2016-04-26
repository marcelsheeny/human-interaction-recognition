clear all;
close all;
clc;

path = 'human_activities_videos/';

files = dir([ path '*_tracked.mat']);

for i=1:length(files)
   load([path files(i).name]);
   
   disp(files(i).name);
   
   for p=1:size(people,2)
      
       for f=1:size(people{p},2)
           %clc
          %disp(p)
          %disp(f)
          if (~isempty(people{p}{f}))
               box = people{p}{f};
               w = box(1,3) - box(1,1);
               h = (box(1,4) - box(1,2))*0.45;
               people{p}{f} = [box(1,1) box(1,2) box(1,3) box(1,4)-h]; 
          end
       end
       
   end
   
   save([path files(i).name '_upper.mat'],'people');
end