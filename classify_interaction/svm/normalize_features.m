function [ norm_feat ] = normalize_features( feat )
%NORMALIZE_FEATURES Summary of this function goes here
%   Detailed explanation goes here
norm_feat = zeros(size(feat,1),size(feat,2));
for i = 1:size(feat,2)
    norm_feat(:,i) = (feat(:,i) - min(feat(:,i)))./(max(feat(:,i)) - min(feat(:,i)));
end
end

