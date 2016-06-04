function visualize_data(im,joints,conn_joints, colors, joint_numbers,balls)

%imshow(im); hold on;

for i = 1:length(conn_joints)
    if (joints(conn_joints(i,1),1) ~= 0 && joints(conn_joints(i,2),1))
        X = [joints(conn_joints(i,1),1) joints(conn_joints(i,2),1)];
        Y = [joints(conn_joints(i,1),2) joints(conn_joints(i,2),2)];
        line(X,Y,'LineWidth', 3, 'Color', colors(conn_joints(i,3),:));
    end
end

for i = 1 : length(joints)
    if (joint_numbers)
        text(joints(i,1),joints(i,2),num2str(i), 'Color', 'green'); 
    end
    if ( balls)
        plot(joints(i,1),joints(i,2),'g.', 'MarkerSize',20);
        viscircles([joints(i,1),joints(i,2)], 5, 'Color','black', 'LineWidth', 1);
    end
end



    