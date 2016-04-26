function val = jaccard_index( box1, box2, sizeImage )
%JACCARD_INDEX Summary of this function goes here
%   Detailed explanation goes here

shapeInserter = vision.ShapeInserter('Fill', 1, 'FillColor', 'Custom', 'CustomFillColor', 1);

wh1 = [box1(1,3) - box1(1,1) box1(1,4) - box1(1,2)];
bbox1 = [box1(1,1) box1(1,2), wh1];

wh2 = [box2(1,3) - box2(1,1) box2(1,4) - box2(1,2)];
bbox2 = [box2(1,1) box2(1,2), wh2];

rectangle1 = int32(ceil(bbox1));
rectangle2 = int32(ceil(bbox2));

im1 = step(shapeInserter, zeros(sizeImage), rectangle1);
im2 = step(shapeInserter, zeros(sizeImage), rectangle2);

val = nnz(im1 & im2)/nnz(im1|im2);

end

