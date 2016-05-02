function [joints,normalized_joints] = load_skeleton( txt )
%LOAD_SKELETON Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(txt);

tline = fgets(fid);

normalized_joints = cell(1);

joints = cell(1);

f = 1.094321;

cnt = 1;
while ischar(tline)
    normalized_joints{cnt} = cell(1);
    joints{cnt} = cell(1);
    joint_str_p1 = textscan(tline,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
    joint_str_p1(1) = [];
    normalized_temp_joints = cell2mat(reshape(joint_str_p1,[3,30])');
    original_Z = 1;%(normalized_temp_joints(:,3)./ 30) ;
    
    temp_joints = [640-f*(normalized_temp_joints(:,1).* 640)/original_Z, f*(normalized_temp_joints(:,2) .* 480)/original_Z];
    normalized_joints{cnt}{1} = normalized_temp_joints(1:15,:);
    normalized_joints{cnt}{2} = normalized_temp_joints(16:30,:);
    joints{cnt}{1} = temp_joints(1:15,:);
    joints{cnt}{2} = temp_joints(16:30,:);
    
    cnt = cnt + 1;
    
    tline = fgets(fid);

    
end

end

