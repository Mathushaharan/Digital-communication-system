%input: bitstream to be encoded
%output: encoded data 

function e = channelEncoding(h)
     
    %calculating the required number of parity bits
    data_len = length(h);  
    paritybits = 0;
    while ~(2^paritybits >= data_len+paritybits+1)
        paritybits = paritybits+1;
    end

    %creating dummy locations for parity bits
    for i = 0:paritybits-1
        n = 2^i;
        h(n+1:data_len+1) = h(n:data_len);
        data_len = length(h);
        h(1, n) = 0;
    end

    data_len = length(h);
   
    %calculating even parity, filling the parity locations
    for i = paritybits:-1:0
        n = 2^i;
        temp = 0;
        for m = n:2*n:data_len
            for y = m:1:m+n-1
                if y <= data_len
                    temp = temp + h(1, y);
                end
            end
        end
        
       if mod(temp, 2) == 1
            h(1, n) = 1;
       end
    end
    e = h; %output
end