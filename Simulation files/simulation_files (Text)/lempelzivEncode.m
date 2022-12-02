%input: bitstream to be encoded
%output: encoded stream 
%        code length
%        dictionary
function [encoded_stream, table, code_length_dec]...
    = lempelzivEncode(data)
    
    table = dictionary(data);    %build dictionary table
    lzw = encoded(table);    %building Lempel-Ziv encoded data table
    
    %adding the tail at the end of the encoded data table
    tailLength = 8;   %length
    tail = zeros(1, tailLength);
    code_length_dec = length(dec2bin(length(table)-1))+1;
    code_length = dec2bin_arr (code_length_dec);
    tail(end-length(code_length)+1:end) = code_length;
    lzw = [lzw tail];
    
    encoded_stream = [];
    for x = 1:1:length(lzw)
        encoded_stream = [encoded_stream lzw{1, x}];
    end
  
 %sub function to build dictionary table
 function table = dictionary (data)
    table = {}; %declaring a cell array to store the dictionary
    tab_temp = [];
    for x = 1:1:length (data)
        tab_temp = [tab_temp data(1, x)]; %grabbing the next bit
        
        %checking if it already exist in the dictionary
        [exist, ~] = check_code(table, tab_temp);
        
        %adding the code to the dictionary if its not there
        if ~exist
            table{1, end+1} = tab_temp;
            tab_temp = [];
        end
    end    
    %bits left at the end are added to the dictionary
    if ~isempty (tab_temp)
        table{1, end+1} = tab_temp;
    end
 end


 %sub function to build encoded data table
 function lzw = encoded(table)
    lzw = {};   %declaring a cell array
    for x = 1:1:length(table)
        
        %declaring a temporary variable of zeros
        temp = zeros(1, length(dec2bin(length(table)-1))+1);
        temp(1,end) = table{1,x}(1,end); %adding data bit
        
        %dictionary position of the set of bits minus the last bit
        [~,index] = check_code (table, table{1,x}(1:end-1));
        index = dec2bin_arr (index); %converting to a bit array
        temp(end-length(index):end-1) = index; %adding index bits
        lzw{1, end+1} = temp;
        
    end
 end

 %sub function to check whether the value is in the dictionary table
 function [exist, index] = check_code (table, value)
    exist = 1;
    index = 0;
    for x = 1:1:length(table)
        if isequal(table{1, x}, value)
            index = x;
            break %if found the value, break from the loop
        end
    end
    if index == 0
        exist = 0;
    end
 end
    
 
 %sub-function for converting decimal value to binary array
 function bin_arr = dec2bin_arr(dec)
   bin_dec = dec2bin(dec); %converting to binary
   len = length(bin_dec); %length of the binary value
   
   %producing the binary array
   bin_arr = zeros(1, len);
   for x = 1:1:len
       bin_arr(1, x) = bin_dec(1, x)-48;
   end
 end

end













