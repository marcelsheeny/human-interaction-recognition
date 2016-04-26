function [ frames ] = read_tv_human_interaction( filename )
%READ_TV_HUMAN_INTERACTION Summary of this function goes here
%   Detailed explanation goes here
f = fopen(filename,'r');

line = fgets(f);
t = textscan(line, '%s %d');
num_frames = t{2};

frames = cell(1);

for fr=1:num_frames 
    line = fgets(f);
    t = textscan(line,'%s %d %s %d %s %d %s %d');
    frame = t{2};
    num_bbxs = t{4};
    disp_str = ['#frame: ', num2str(frame), ' #num_bbxs: ', num2str(num_bbxs)];
    
    frames{fr}.frame = frame;
    frames{fr}.num_bbxs = num_bbxs;
    
    if (~isempty(strfind(line,'#interacting')))
        id_i = t{6};
        id_j = t{8};
        disp_str = [disp_str, ' #interacting: ', num2str(id_i), '-', num2str(id_j)];
        frames{fr}.id_i = id_i;
        frames{fr}.id_j = id_j;
    end

    %disp(disp_str);
    frames{fr}.person = cell(1);
    for b = 1:num_bbxs
        line = fgets(f);
        t = textscan(line,'%d %d %d %d %s %s');
        id = t{1};
        top_left_x = t{2};
        top_left_y = t{3};
        size = t{4};
        label = t{5};
        head_orientation = t{6};
        %disp([num2str(id) num2str(top_left_x) num2str(top_left_y) num2str(size) label head_orientation]);
        frames{fr}.person{b}.id = id;
        frames{fr}.person{b}.top_left_x = top_left_x;
        frames{fr}.person{b}.top_left_y = top_left_y;
        frames{fr}.person{b}.size = size;
        frames{fr}.person{b}.label = label;
        frames{fr}.person{b}.head_orientation = head_orientation;
    end
    
    
    
    
end




end

