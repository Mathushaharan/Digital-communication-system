%input: bitstream to be decoded
%output: decoded data 

function h = channelDecoding(e)
    
    %calcuating the no of parity bits
    data_len = length(e); 
    paritybits = floor(log(data_len)/log(2));
    
    %arrays of zeros
    err = zeros(1,paritybits+1);
    
    %calculating even parity and checking for the parity errors
    for i = paritybits:-1:0
        n = 2^i;
        temp = 0;
        
        for m = n:2*n:data_len
            for y = m:1:m+n-1
                if y <= data_len
                    temp = temp + e(1, y);
                end
            end
        end
        
        if mod(temp, 2) == 1
            err(1, x+1) = 1;
        end
    end
    
    %calculating error location
    temp = 0;
    for i = 1:1:paritybits+1
        temp = temp + err(1, i)*2^(i-1);
    end
                                                           
    %if an error exist, the bit at the location is flipped
    if temp > 0
        e(1, temp) = ~e(1, temp);
    end

    %removing the parity bit locations and producing the data stream
    h = [];   %output array
    n = 1;
    for i = 0:1:data_len-1
        
        %calculating the locations to skip
        skip(1, i+1) = 2^i; 
        temp = e(1, i+1);
        
        %if the x+1 is a parity location, it is skipped
        if ~ismember(i+1, skip)
            h(1, n) = temp;
            n = n + 1;
        end
    end
end




