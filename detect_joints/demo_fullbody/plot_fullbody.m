function plot_fullbody( joints, labels )

    s.joints = double(joints');
   
    l = [1, 2];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [2, 3];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [4, 5];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);  
   
    l = [5, 6];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [7, 8];
    color = 'yellow';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [8, 9];
    color = 'yellow';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [10, 11];
    color = 'yellow';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [11, 12];
    color = 'yellow';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [13, 14];
    color = 'red';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [9, 10];
    color = 'blue';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [3, 9];
    color = 'blue';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [4, 10];
    color = 'blue';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
    
    for i=1:size(s.joints,1)
       text(s.joints(i,1), s.joints(i,2), labels{i}, 'Color', 'yellow', 'FontSize', 20);
    end

end


