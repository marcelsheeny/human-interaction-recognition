close all;
clear all;
clc;


%Human interaction recognition

%for all videos
    %read video

        %for all frames
            %read boxes?

            %read joints

            %add joints in the image

            %get closest joints for pairwise

            %create standard image (512,256)?

            %create grid (10,10)? each grid is an state

            %put joints in the grid

            %for all images of the same action, create a "histogram" with all
            %probabities for emission matrix
            %                  p1,1 p1,2 p1,3 p1,4 ... p100,100
            %emission = hug  [ 0.01  0.2  0.3  0.0 ...  0.0]
            %           kiss [ 0.01  0.2  0.3  0.0 ...  0.0]
            %                             ....

            %                              negative hug kiss                                  
            %Tramission matrix = negative [ 0.90    0.5  0.5  ]
            %                      hug    [ 0.5     0.95 0.0  ]  
            %                      kiss   [  0.5    0.0  0.95 ]

            %create a gaussian probability to create the emission


