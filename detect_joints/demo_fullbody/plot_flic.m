function plot_fullbody( joints, labels )

    s.joints = double(joints);
   
    l = [2, 4];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [4, 6];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [3, 5];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);  
   
    l = [5,7];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
   
    plot(joints(1,1),joints(1,2),'r.','MarkerSize',30);

    %if (~isempty(labels))
        for i=1:size(s.joints,1)
           text(double(s.joints(i,1)), double(s.joints(i,2)), num2str(i), 'Color', 'yellow', 'FontSize', 20);
        end
    %end

end


