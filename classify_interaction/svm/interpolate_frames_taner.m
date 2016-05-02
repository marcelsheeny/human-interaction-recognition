function [ joints_interpolated ] = interpolate_frames_taner( joints, n_frames )
%INTERPOLATE_FRAMES Summary of this function goes here
%   Detailed explanation goes here

% joints structure = cell with number of frames
% and in each frame it contains all the joints and positions

joints_interpolated = joints;

n_frames_joints = length(joints);

difference = n_frames - n_frames_joints;

if difference > 0

    count = 1;
    jump = round(n_frames / difference);


    % interpolation for the new data
    for i = 1: difference

        index = (count - 1) * jump + count;

        if index >= n_frames
            count = 1;
            index = (count - 1) * jump + count;
        end

        % display([num2str(index) ': add ' num2str(count)]);

        % get the AVERAGE of the previous and next frame
        position = (joints{index}+joints{index+1}) / 2;

        temp = joints_interpolated;

        for aa=1:(length(temp)+1)
            if (aa < index)
               joints_interpolated{aa} = temp{aa};
            elseif(aa == index)
                joints_interpolated{aa} = position;
            else
                joints_interpolated{aa} = temp{aa-1}
            end
        end

        count = count + 1;

    end

else


end

end



