function draw_detections(imgname, detections, color)
%imshow(imgname/255);
%hold on

if nargin < 3
  color = 'r'
end
 for k = 1:size(detections, 1)
     %scatter(detections(k, 1), detections(k, 2), 'rx');
     rectangle('Position', [detections(k,1) - 25,detections(k,2)-25,50,50],'EdgeColor',color, 'LineWidth', 3);
     rectangle('Position', [detections(k,1) - 1,detections(k,2)-1,2,2],'EdgeColor',color, 'LineWidth', 3);
 end
 hold off
 end


