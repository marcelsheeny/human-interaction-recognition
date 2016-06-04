function [ output_args ] = normalize_show_conf_matrix( conf_matrix )
%NORMALIZE_SHOW_CONF_MATRIX Summary of this function goes here
%   Detailed explanation goes here

for i = 1:size(conf_matrix,1)
   sum = 0;
   for j = 1:size(conf_matrix,1)
      sum = sum + conf_matrix(i,j);
   end
   for j = 1:size(conf_matrix,1)
      conf_matrix(i,j) = conf_matrix(i,j)/sum;
   end
end

conf_matrix = conf_matrix';
output_args = conf_matrix;

imshow(imresize(imcomplement(conf_matrix),100,'nearest')); hold on;

for i = 1:size(conf_matrix,1)
   for j = 1:size(conf_matrix,1)
       if(i==j)
            text(i*100-80,j*100-50, num2str(conf_matrix(i,j),'%.2f'), 'Color', 'white', 'FontSize', 20) 
       else
            text(i*100-80,j*100-50, num2str(conf_matrix(i,j),'%.2f'),'FontSize', 20)
       end
   end
end

end

