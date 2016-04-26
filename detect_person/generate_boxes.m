function bboxes = generate_boxes(video, model)

bboxes = cell(1);

cnt = 1;

while hasFrame(video)
   disp(['frame: ' num2str(cnt) ' out of ' num2str(video.Duration*video.FrameRate)]);
   frame = readFrame(video);
   boxes = detect_person_faster(frame, model);
   bboxes{cnt} = boxes;
   cnt = cnt + 1;
end
