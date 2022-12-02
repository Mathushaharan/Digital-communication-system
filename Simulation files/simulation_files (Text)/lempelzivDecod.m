%input: bitstream to be decoded
%output: decoded datastream 

function data_stream = lempelzivDecod(encoded_stream)

    tailLength = 8;   
  
    %removing the tail and calculating the code length
    tail = encoded_stream(end-(tailLength-1):end);
    encoded_stream = encoded_stream(1:end-tailLength);
    code_length = bin_arr2dec (tail);
    
    %building dictionary table
    table = dictionary(encoded_stream, code_length);
    
    data_stream = [];
    for x = 1:1:length(table)
        data_stream = [data_stream table{1, x}];
    end
    
    %sub function to build dictionary table
    function table = dictionary(encoded_stream, code_length)
        table = {}; %declaring a cell array 
        for n = 1:code_length:length(encoded_stream)
           %grabbing the next set of bits
           tab_temp = encoded_stream(n:n+code_length-1);
           
           %calculating the index
           index = bin_arr2dec(tab_temp(1:end-1));
           
           if index == 0
                %0 index means no leading bits, just the data bit
                table{1, end+1} = tab_temp(1, end);
           else
    
                %otherwise the data at the index plus the data bit
                table{1, end+1} = [table{1, index} tab_temp(1, end)];
           end
        end      
    end

    %sub-function for converting binary array to a decimal value
    function dec = bin_arr2dec (bin_arr)
         len = length(bin_arr); %length of the binary array
         dec = 0; 
         %calculating the deciml value
         for n = 0:1:len-1
            dec = dec + bin_arr(1, len-n)*2^n;
         end      
    end
end

