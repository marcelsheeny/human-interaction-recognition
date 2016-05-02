function [ corners ] = compute_candidates( R,n_candidates )
%COMPUTEBESTCORNERS Summary of this function goes here
%   Detailed explanation goes here

%get size
[r,c,~] = size(R);

max_iterations = 100;

%initialize features
features = zeros(n_candidates,2);

%sort values
[values, indices] = sort(R(:),'descend');



%tic;
%window size
window_i = 31;
window_j = 31;

%halfwindow
half_i = floor(window_i/2);
half_j = floor(window_j/2);

%init best corners
corners = [];
[feat_i, feat_j] = ind2sub([r c], indices(1));
corners(1,:) = [feat_j feat_i];

%init counters
cnt = 2;

%logical image
log_img = zeros(r,c);

%avoid borders
max_row = min(corners(1,2) + half_i,r);
min_row = max(corners(1,2) - half_i,1);
max_col = min(corners(1,1) + half_j,c);
min_col = max(corners(1,1) - half_j,1);

%put as visited
log_img(min_row:max_row,min_col:max_col) = 1;

%count number of corners
cnt_corners = 2;

%while not 81 corners computed
while cnt_corners ~= n_candidates+1 || cnt < max_iterations
    %increment
    cnt = cnt + 1;
    
    %get coordinates
    [feat_i, feat_j] = ind2sub([r c], indices(cnt));
    
    %check if the current coordinate is free
    if (log_img(feat_i, feat_j) == 0)
        
       %store coordinate
       corners(cnt_corners,:) = [feat_j, feat_i];
       
       %increment counter of corners
       cnt_corners = cnt_corners + 1;
       
       %avoid borders
       max_row = min(feat_i + half_i,r);
       min_row = max(feat_i - half_i,1);
       max_col = min(feat_j + half_j,c);
       min_col = max(feat_j - half_j,1);
       
       %mark window as visited
       log_img(min_row:max_row,min_col:max_col) = 1;
    end
end
%toc;
%figure; imshow(im_orig); hold on;
%
%for i=1:size(corners,1)
%    plot(corners(i,2), corners(i,1), 'r+');
%end

end

