clc;
close all;
clear all;

path = '../../../datasets/kinect_interaction/';

sets = dir([path '*/']);

keySet =   {'01', '02', '03', '04', '05', '06', '07', '08'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8];

actionsMap = containers.Map(keySet,valueSet);

keySet =   {'set01', 'set02', 'set03', 'set04', 'set05', 'set06', 'set07', 'set08', ... 
            'set09', 'set10', 'set11', 'set12', 'set13', 'set14', 'set15', 'set16', ...
            'set17', 'set18', 'set19', 'set20', 'set21', };
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];

setMap = containers.Map(keySet,valueSet);

train = ones(1,21);
train(1,1:3) = 0; train(1,9:11) = 0; train(1,19:21) = 0;

test = imcomplement(train);

training_label_vector = [];
training_instance_matrix = [];

test_label_vector = [];
test_instance_matrix = [];

sets(1:2) = [];
cnt = 1;

i = 1;
j = 1;
k = 1;

n_frames_train = 20;



for i=1:size(sets,1)
    disp([num2str(i) ' sets out of ' num2str(size(sets,1))]);
    interactions = dir([path sets(i).name '/*/']);
    interactions(1:2) = [];
    
    for j=1:size(interactions,1)
       
        samples = dir([path sets(i).name '/' interactions(j).name '/*/']);
        samples(1:2) = [];
        
        for k=1:size(samples,1)
           
            file_images = dir([path sets(i).name '/' interactions(j).name '/' samples(k).name '/*.mat']);
            
            load([path sets(i).name '/' interactions(j).name '/' samples(k).name '/' file_images(1).name]);
            set = setMap(annotation.set);
            
            p1 = cell(1);
            p2 = cell(1);
            for l = 1:length(annotation.normalized_joints_gt)
               p1{l} =  annotation.normalized_joints_gt{l}{1};
               p2{l} =  annotation.normalized_joints_gt{l}{2};
            end
            
            norm_p1 = interpolate_frames(p1,n_frames_train);
            norm_p2 = interpolate_frames(p2,n_frames_train);
            
            feat = [];
            for l = 1:length(norm_p1)
               temp_p1 = norm_p1{l}(:,1:2);
               feat_p1 =  temp_p1(:)';
               temp_p2 = norm_p2{l}(:,1:2);
               feat_p2 =  temp_p2(:)';
               feat = [feat, feat_p1, feat_p2];
            end
            
            if (train(1,set) == 1)
                
                training_instance_matrix = [training_instance_matrix; feat];
                
                training_label_vector = [training_label_vector; actionsMap(annotation.interaction)];
            else
                test_instance_matrix = [test_instance_matrix; feat];
                
                test_label_vector = [test_label_vector; actionsMap(annotation.interaction)];
                
            end
        end
    end
end

addpath('/home/visionlab/marcel/libs/libsvm/matlab/');

%opts = '-s 0 -t 2 -g 0.001955313 -v 10';
%model = svmtrain(training_label_vector, training_instance_matrix, opts);
%[predicted_label, accuracy, decision_values] = svmpredict(test_label_vector, test_instance_matrix, model);

bestcv = 0;
for log2c = -1:3,
  for log2g = -4:1,
    cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(training_label_vector, training_instance_matrix, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end

opts = '-s 0 -t 2 -g 0.0625 -c 8';

model = svmtrain(training_label_vector, training_instance_matrix, opts);
[predicted_label, accuracy, decision_values] = svmpredict(test_label_vector, test_instance_matrix, model);

%{
f_train = fopen('train.txt','w');
f_test = fopen('test.txt','w');

disp('train...');
for i=1:size(training_instance_matrix,1)
    fprintf(f_train, [num2str(training_label_vector(i)) ' ']);
    for j=1:size(training_instance_matrix,2)
        fprintf(f_train, [num2str(j) ':' num2str(training_instance_matrix(i,j)) ' ']);
    end
    fprintf(f_train,'\n');
end
disp('test...');
for i=1:size(test_instance_matrix,1)
    fprintf(f_test, [num2str(test_label_vector(i)) ' ']);
    for j=1:size(test_instance_matrix,2)
        fprintf(f_test, [num2str(j) ':' num2str(test_instance_matrix(i,j)) ' ']);
    end
    fprintf(f_test,'\n');
end
%}