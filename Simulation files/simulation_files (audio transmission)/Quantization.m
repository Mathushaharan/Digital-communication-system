%inputs: s - signal
%        qlevels - quantization levels
%        ind - index of quantization levels
%output: M-QAM modulated column vector. 

function [q, q_Error, data] = Quantization(s,qlevels, ind)
 
vmax = 1.5; %upper limit 
vmin = -1.5; %lower limit
bitlen = log2(qlevels);
lsb = (vmax-vmin)/(qlevels-1); %scaling factor
levels = vmin:lsb:vmax; %q-levels
 
partition = (vmin - (0.5*lsb)):lsb:(vmax+(0.5*lsb));
[~,index_levels] = size(levels);
 
%generating quantized values
q = zeros(1,ind-1);
 
for i = 1:ind-1
   for j = 1:index_levels
       
      if(s(i)<partition(1))
          q(i) = vmin;
          bin_val = dec2bin(0,bitlen);
          val_rearrange = bin_val(:);
          rearrange_index = ((i-1)*bitlen)+1;
          data(rearrange_index:(rearrange_index + bitlen-1),1) = val_rearrange;
      end
      
      if (s(i)>partition(end))
          q(i) = vmax;
          bin_val = dec2bin((quantizingLevel)-1,bitlen);
          val_rearrange = bin_val(:);
          rearrange_index = ((i-1)*bitlen)+1;
          data(rearrange_index:(rearrange_index+ bitlen-1),1) = val_rearrange;
      end
 
      if (s(i)>=partition(j))
           if(s(i)<partition(j+1))
             q(i) = levels(j);
             bin_val = dec2bin(j-1,bitlen);
             val_rearrange = bin_val(:);
             rearrange_index = ((i-1)*bitlen)+1;
             data(rearrange_index:(rearrange_index+bitlen-1),1) = val_rearrange;
           end
      end
   end
end

%calculating quantization error
q_Error = [];
   for i = 1:length(q)
    q_Error(i) = (q(i) - s(i));
    i = i + 1;
   end
end