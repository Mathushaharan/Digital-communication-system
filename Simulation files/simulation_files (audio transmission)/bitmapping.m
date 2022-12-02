%input: data
%output: bit stream
function [b] = bitmapping(data)
 
    b = zeros(length(data),1);
    %binary encoding
    for i = 1:length(data)
      b(i,1) = str2double(data(i,1));
    end 
    %converting to bit stream
    b = b';
    b = num2str(b);
    b = b(b~=' ');
    fprintf('Bitmapped stream: ')
    disp(b) %display binary stream
  
    b =  b-'0';
    %plotting 
    figure
    stairs(b);
    title('Bit-mapped signal')
    ylim([-2 2])
    
end



