function prediction = post_processing(prediction, heatMaps)

    np = size(prediction,1);
    % plot all parts and background
    visible = ones(1,np);
    for part = 1:np
        response = heatMaps{end}(:,:,part);
        max_value = max(max(response));

        if(max_value < 0.15)
            visible(part) = 0;
        end

    end
    
    prediction = [prediction, visible'];
end