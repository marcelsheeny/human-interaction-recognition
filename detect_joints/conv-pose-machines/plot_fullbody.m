function plot_fullbody( joints )

    s.joints = double(joints);
    
    connections = [1 2; 3 4; 4 5; 6 7; 7 8; 9 10; 10 11; 12 13; 13 14];
   
    colors = {'red','blue','green', 'yellow', 'magenta', 'cyan', [0.5 0.3 0], [0.8 0.8 0], [1 0.3 0.3]};
    
    for con=1:size(connections,1)
        l = connections(con,:);
        if (s.joints(l(1),3) == 1 && s.joints(l(2),3) == 1)
            color = colors{con};
            line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
        end
    end
    %{
    l = [1, 2];
    color = 'red';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [3, 4];
    color = 'blue';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [4, 5];
    color = 'green';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);  
   
    l = [6,7];
    color = 'yellow';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [7, 8];
    color = 'magenta ';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [9, 10];
    color = 'cyan';
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [10, 11];
    color = [0.5 .3 0];
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [12, 13];
    color = [0.8 0.8 0];
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    l = [13, 14];
    color = [1 0.3 0.3];
    line([s.joints(l(1),1), s.joints(l(2),1)],[s.joints(l(1),2),s.joints(l(2),2)],'Color',color,'LineWidth',4);
   
    %}
    
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
        %for i=1:size(s.joints,1)
        %   text(double(s.joints(i,1)), double(s.joints(i,2)), num2str(i), 'Color', 'yellow', 'FontSize', 20);
        %end
    %end

end


