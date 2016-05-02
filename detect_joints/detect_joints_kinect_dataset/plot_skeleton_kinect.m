function plot_skeleton_kinect( joints_2d )
%PLOT_SKELETON_KINECT Summary of this function goes here
%   Detailed explanation goes here

SkeletonConnectionMap = [1 2;
                         2 3;
                         3 10;
                         3 13;
                         2 4;
                         4 5;
                         5 6;
                         2 7;
                         7 8;
                         8 9;
                         10 11;
                         11 12;
                         13 14;
                         14 15];

for i = 1:size(SkeletonConnectionMap,1)
   X1 = [joints_2d(SkeletonConnectionMap(i,1),1) joints_2d(SkeletonConnectionMap(i,2),1)];
   Y1 = [joints_2d(SkeletonConnectionMap(i,1),2) joints_2d(SkeletonConnectionMap(i,2),2)];
   line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
end

end

