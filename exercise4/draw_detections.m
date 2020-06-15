function draw_detections(imgname, detections, color)
%imshow(imgname/255);
%hold on

if nargin < 3
  color = 'r'
end
 for k = 1:size(detections, 1)
    rectangle('Position', [detections(k,1) - 130,detections(k,2)-55,250,100],'EdgeColor',color, 'LineWidth', 3);
 end
 hold off
 end


