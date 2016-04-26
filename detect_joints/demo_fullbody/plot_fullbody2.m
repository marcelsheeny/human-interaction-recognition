function plot_fullbody( joints, labels )

    s.joints = double(joints);
   
    l = [12, 10];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [11, 13];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [11, 9];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);  
   
    l = [14,12];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [3, 5];
    color = [0.8 0.8 0];
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [5, 7];
    color = 'yellow';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [8, 6];
    color = 'yellow';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [6, 4];
    color = [0.8 0.8 0];
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [1, 2];
    color = 'red';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    %{
    l = [9, 7];
    color = 'blue';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [10, 8];
    color = 'blue';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [7, 8];
    color = 'blue';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
    %}
    %if (~isempty(labels))
        for i=1:size(s.joints,1)
           text(double(s.joints(i,1)), double(s.joints(i,2)), num2str(i), 'Color', 'yellow', 'FontSize', 20);
        end
    %end

end


