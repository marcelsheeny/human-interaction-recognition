%function [acc, conf_m] = train_test_with_pose (train_labels)
close all
clear all
clc;

path = '../../../datasets/ut-interaction/';

sets = dir([path 'set*']);

training_label_vector = [];
training_instance_matrix = [];

test_label_vector = [];
test_instance_matrix = [];

n_frames_train = 10;

conf_m = zeros(6,6);
acc = 0;

sum_test_number = 0;

for fold = 1:10
    
    training_label_vector = [];
    training_instance_matrix = [];

    test_label_vector = [];
    test_instance_matrix = [];
    for i=1:1%size(sets,1)
        disp([num2str(i) ' sets out of ' num2str(size(sets,1))]);
        videos = dir([path sets(i).name '/*/']);
        videos(1:2) = [];

        for j=1:57%size(videos,1)
            disp([num2str(j) ' sets out of ' num2str(size(videos,1))]);
            file_images = dir([path sets(i).name '/' videos(j).name '/rgb*']);
            file_images = [path sets(i).name '/' videos(j).name '/' file_images(1).name];

            im = imread(file_images);
            [resy,resx,resz] = size(im);

            load([path sets(i).name '/' videos(j).name '/annotations.mat']);

            if ( isfield(annotation,'joints_prediction'))
                p1 = cell(1);
                p2 = cell(1);
                for l = 1:length(annotation.joints_prediction)
                   p1{l} =  annotation.joints_prediction{l}{1}/resx;
                   p2{l} =  annotation.joints_prediction{l}{2}/resy;
                end

                norm_p1 = interpolate_frames(p1,n_frames_train);
                norm_p2 = interpolate_frames(p2,n_frames_train);

                feat = [];
                for l = 1:length(norm_p1)
                   % get joints information
                   temp_p1 = norm_p1{l}(:,1:2);

                   temp_p2 = norm_p2{l}(:,1:2);

                   %feature 1 (x,y person 1 joint position)
                   feat_1 =  temp_p1(:)';

                   %feature 2 (x,y person 2 joint position)
                   feat_2 =  temp_p2(:)';

                   %feature 3 (distance between joints)
                   temp = [];
                   for n_j1 = 1:size(temp_p1,1)
                        temp = [temp; norm(temp_p1(1,1:2) - temp_p2(n_j1,1:2))];
                   end
                   
                   feat_3 = temp(:)';
                   
                   for n_j2 = 1:size(temp_p1,1)
                        temp = [temp; norm(temp_p1(n_j1,1:2) - temp_p2(1,1:2))];
                   end
                    
                   feat_5 = temp(:)';
                   

                   %feature 4 difference between joints
                   feat_4 = abs(feat_1 - feat_2);

                   %joint angles
                   %feat_5 = [];
                   %for n_j = 1:size(conn_joints,1)
                   %     deltaY = temp_p1(conn_joints(n_j,1),2) - temp_p1(conn_joints(n_j,2),2);
                   %     deltaX = temp_p1(conn_joints(n_j,1),1) - temp_p1(conn_joints(n_j,2),1);
                   %     feat_5 = [feat_5, atan2(deltaY, deltaX)/pi + pi/2];
                   %end

                   %feat = [feat, feat_4];
                   %feat = [feat, feat_1, feat_2, feat_3];
                   feat = [feat, feat_1, feat_2, feat_3, feat_4, feat_5];
                end

                if (annotation.vid ~= fold)

                    training_instance_matrix = [training_instance_matrix; feat];

                    training_label_vector = [training_label_vector; annotation.interaction+1];
                else
                    test_instance_matrix = [test_instance_matrix; feat];

                    test_label_vector = [test_label_vector; annotation.interaction+1];

                end

            end
        end
    end

    addpath('/home/visionlab/marcel/libs/libsvm/matlab/');


    opts = '-s 0 -t 2 -g 0.0625 -c 8';

    model = svmtrain(training_label_vector, training_instance_matrix, opts);
    [predicted_label, accuracy, decision_values] = svmpredict(test_label_vector, test_instance_matrix, model);

    sum_test_number = sum_test_number + size(predicted_label,1);
    
    for a=1:size(predicted_label,1)
        j = predicted_label(a,1);
        i = test_label_vector(a,1);
        conf_m(i,j) = conf_m(i,j)+1;
    end

    conf_m

    acc = acc+accuracy*size(predicted_label,1);

end

acc/sum_test_number;

%{
sets = dir([path '*/']);

keySet =   {'01', '02', '03', '04', '05', '06', '07', '08'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8];

actionsMap = containers.Map(keySet,valueSet);

keySet =   {'set01', 'set02', 'set03', 'set04', 'set05', 'set06', 'set07', 'set08', ... 
            'set09', 'set10', 'set11', 'set12', 'set13', 'set14', 'set15', 'set16', ...
            'set17', 'set18', 'set19', 'set20', 'set21', };
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];

setMap = containers.Map(keySet,valueSet);

%train = train_labels

train = ones(1,21);
train(1,1:3) = 0; train(1,9:11) = 0; train(1,19:21) = 0;
%train(1,11:18) = 0;



%test = imcomplement(train);

training_label_vector = [];
training_instance_matrix = [];

test_label_vector = [];
test_instance_matrix = [];

sets(1:2) = [];
cnt = 1;

n_frames_train = 5;

im = imread('/home/visionlab/marcel/datasets/kinect_interaction/set01/01/001/rgb_000055.png');
[resy,resx,resz] = size(im);

%actions ID

%joints ID

%1 - head
%2 - Neck
%3 - right shoulder
%4 - right elbow
%5 - right wrist
%6 - left shoulder
%7 - left elbow
%8 - left wrist
%9 - right hip
%10 - right knee
%11 - right ankle <- removed
%12 - left hip
%13 - left knee
%14 - left ankle <- removed

conn_joints = [1 2; 3 4; 4 5; 6 7; 7 8; 9 10; 11 12];


for i=1:21%size(train,2)%size(sets,1)
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
            for l = 1:length(annotation.joints_prediction)
               p1{l} =  annotation.joints_prediction{l}{1}/resx;
               p2{l} =  annotation.joints_prediction{l}{2}/resy;
            end
            
            norm_p1 = interpolate_frames(p1,n_frames_train);
            norm_p2 = interpolate_frames(p2,n_frames_train);
            
            feat = [];
            for l = 1:length(norm_p1)
               % get joints information
               temp_p1 = norm_p1{l}(:,1:2);
               
               %remove ankle and knee
               temp_p1(14,:) = [];      %left ankle        
               %temp_p1(13,:) = [];      %left knee         
               temp_p1(11,:) = [];      %right ankle       
               %temp_p1(10,:) = [];      %right knee
               
               temp_p2 = norm_p2{l}(:,1:2);
               
               %remove ankle and knee
               temp_p2(14,:) = [];
               %temp_p2(13,:) = [];
               temp_p2(11,:) = [];
               %temp_p2(10,:) = [];
               
               %feature 1 (x,y person 1 joint position)
               feat_1 =  temp_p1(:)';
               
               %feature 2 (x,y person 2 joint position)
               feat_2 =  temp_p2(:)';
               
               %feature 3 (distance between joints)
               temp = [];
               for n_j = 1:size(temp_p1,1)
                   temp = [temp; norm(temp_p1(n_j,1:2) - temp_p2(n_j,1:2))];
               end
               
               feat_3 = temp(:)';
               
               %feature 4 difference between joints
               feat_4 = abs(feat_1 - feat_2);
               
               %joint angles
               %feat_5 = [];
               %for n_j = 1:size(conn_joints,1)
               %     deltaY = temp_p1(conn_joints(n_j,1),2) - temp_p1(conn_joints(n_j,2),2);
               %     deltaX = temp_p1(conn_joints(n_j,1),1) - temp_p1(conn_joints(n_j,2),1);
               %     feat_5 = [feat_5, atan2(deltaY, deltaX)/pi + pi/2];
               %end
               
               %feat = [feat, feat_4];
               %feat = [feat, feat_1, feat_2, feat_3];
               feat = [feat, feat_1, feat_2, feat_3];
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

%{
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
%}
opts = '-s 0 -t 2 -g 0.0625 -c 8';

model = svmtrain(training_label_vector, training_instance_matrix, opts);
[predicted_label, accuracy, decision_values] = svmpredict(test_label_vector, test_instance_matrix, model);

conf_m = zeros(8,8);
for a=1:size(predicted_label,1)
    i = predicted_label(a,1);
    j = test_label_vector(a,1);
    conf_m(i,j) = conf_m(i,j)+1;
end

conf_m

acc = accuracy;
%}
