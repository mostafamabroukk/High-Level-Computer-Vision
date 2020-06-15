function [A] = csvalpha(file); 

fid = fopen(file, 'r');

tline = fgetl(fid);

A(1,:) = regexp(tline, '\,', 'split'); 

%  Parse and read rest of file

ctr = 1;

while(~feof(fid))

if ischar(tline)    

      ctr = ctr + 1;

      tline = fgetl(fid);         

      A(ctr,:) = regexp(tline, '\,', 'split'); 

else

      break;     

end

end

fclose(fid);
