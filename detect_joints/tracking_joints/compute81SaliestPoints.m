function [features, indices] = compute81SaliestPoints( im, R )
%COMPUTE81SALIESTPOINTS Summary of this function goes here
%   Detailed explanation goes here

%get size
[r,c] = size(im);

%initialize features
features = zeros(81,2);

%sort values
[values, indices] = sort(R(:),'descend');

%get coordinates
for i=1:81
    features(i,1) = floor(indices(i)/r);
    features(i,2) = mod(indices(i),r);
end

%display
figure; imshow(im); hold on;

for i=1:size(features,1),
    plot(features(i,1), features(i,2), 'r+');
end 



end

