function [patch] = crop2patch(img,box)

  tr = box(1)-box(3)/2;
  br = box(1)+box(3)/2;
  tl = box(2)-box(4)/2;
  bl = box(2)+box(4)/2;
  
  if(tl<1) tl = 1;
  end
  if(bl>size(img,1)) bl = size(img,1);
  end
  if(tr<1) tr = 1;
  end
  if(br>size(img,2)) br = size(img,2);
  end
  
  patch = img(tl:bl,tr:br,:);

end