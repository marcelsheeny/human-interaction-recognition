function c = get_center( box )
%GET_CENTER Summary of this function goes here
%   Detailed explanation goes here

c = [(box(1,1) + (box(1,3) - box(1,1))/2) (box(1,2) + (box(1,4) - box(1,2))/2)];


end

