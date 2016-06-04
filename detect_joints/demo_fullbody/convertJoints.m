function c_joints = convertJoints (joints,opt)

c_joints = zeros(size(joints,1),size(joints,2));

for i=1:size(opt.convertJoints,1)
    c_joints(opt.convertJoints(i,1),:) = joints(opt.convertJoints(i,2),:);
end

end