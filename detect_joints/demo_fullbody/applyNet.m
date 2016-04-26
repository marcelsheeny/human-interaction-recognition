% Wrapper to run network on multiple images
function [joints, heatmaps] = applyNet(im, opt)

fprintf('config:\n\n');
disp(opt)
fprintf('\n');

% Initialise caffe
net = initCaffe(opt); 

% Apply network separately to each image
[joints, heatmaps] = applyNetImage(im, net, opt);

end