clc;
close all;
clear all;

n_sets = 18;
n_actions = 8;

conf_m_total = zeros(n_actions,n_actions);

cv = 1;


acc_total = 0;

for i=1:cv
    
    train_labels = ones(1,n_sets); 
    for i =1:n_sets
        if (rand() < cv/n_sets)
            train_labels(i) = 0;
        end
    end
   
   [acc,conf_m] = train_test_with_pose(train_labels);
   
   conf_m_total = conf_m_total + conf_m;
   acc_total = acc_total + acc;
end