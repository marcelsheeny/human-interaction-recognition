function [ output_args ] = plot_joints( joints )
%PLOT_JOINTS Summary of this function goes here
%   Detailed explanation goes here
joints = double(joints)
head = joints(1,:);
r_wr = joints(2,:);
l_wr = joints(3,:);
r_el = joints(4,:);
l_el = joints(5,:);
r_sh = joints(6,:);
l_sh = joints(7,:);


plot(head(1,1),head(1,2),'r.','MarkerSize',30);

draw_line(r_wr,r_el,'r');
draw_line(r_el,r_sh,'g');
draw_line(l_wr,l_el,'r');
draw_line(l_el,l_sh,'g');

for i=2:size(joints,1)
   plot(joints(i,1),joints(i,2),'.','Color','blue','MarkerSize',20);
end


end

function draw_line(p1,p2,color)
    plot([p1(1),p2(1)],[p1(2),p2(2)],'Color',color,'LineWidth',5)
end

