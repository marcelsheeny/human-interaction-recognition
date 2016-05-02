function [ model_01, model_02 ] = interpolate( model_01, model_02 )

    [h_1, w_1] = size(model_01{1, 3});
    [h_2, w_2] = size(model_02{1, 3});

    difference = h_1 - h_2;

    if difference > 0

        count = 1;
        jump = round(h_2 / difference);

        %% FOR ALL JOINTS
        for j = 1: 25

            % clc;

            % interpolation for the new data
            for i = 1: difference

                index = (count - 1) * jump + count;
                
                [h_2, w_2] = size(model_02{j, 3});
                
                if index >= h_2
                    count = 1;
                    index = (count - 1) * jump + count;
                end
 
                % display([num2str(index) ': add ' num2str(count)]);

                % get the AVERAGE of the previous and next frame
                position = (model_02{j, 3}(index, 1:end) + model_02{j, 3}(index + 1, 1:end)) / 2;

                % insert it to the current position
                model_02{j, 3} = [model_02{j, 3}(1: index, :); position; model_02{j, 3}(index + 1: end, :)];
               
                count = count + 1;

            end

            count = 1;

        end

    else

        count = 1;
        difference = abs(difference);
        jump = round((h_2 - difference) / difference);

        %% FOR ALL JOINTS
        for j = 1: 25

            % clc;

            % interpolation for the new data
            for i = 1: difference
                
                index = i * jump;

                % display([num2str(i) ': delete ' num2str(count)]);

                % insert it to the current position
                model_02{j, 3} = [model_02{j, 3}(1: index - 1, :); model_02{j, 3}(index + 1: end, :)];

                count = count + 1;

            end

            count = 1;

        end
        
    end

end

