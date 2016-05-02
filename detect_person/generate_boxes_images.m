function bboxes = generate_boxes(images, model,opt)

bboxes = cell(1);


for i=1:size(images,2)
   disp(['frame: ' num2str(i) ' out of ' num2str(size(images,2))]);
   frame = images{i};
   boxes = detect_person_faster(frame, model);
   bboxes{i} = boxes;
   
   if (opt.debug == true)
       imshow(frame); hold on;
       for j = 1:size(bboxes{i},1)
          rectangle('Position',  [bboxes{i}(j,1:2) bboxes{i}(j,3:4) - bboxes{i}(j,1:2)]); 
       end
       waitforbuttonpress;
   end

end


