
%input: data to be modulated
%       modulation order 
%       mode (UnitAvgPower or not (true/false))
%output: modulated sig

function m = qamModfunc(b,modulation_order, mode)

 if strcmp(mode,'true')
    
   k = log2(modulation_order);
   n = length(b'); %length of binary stream
   numSamplesPerSymbol = 1;
   
   %reshaping the data
   dataInMatrix = reshape(b',length(b')/k,k); 
   dataSymbolsIn = bi2de(dataInMatrix);
   
   %output
   m = qammod(dataSymbolsIn, modulation_order,'gray', 'UnitAveragePower', true);
   
 elseif strcmp(mode, 'false')
    
   k = log2(modulation_order);
   n = length(b'); %length of binary stream
   numSamplesPerSymbol = 1;
   
   %reshaping the data
   dataInMatrix = reshape(b',length(b')/k,k); 
   dataSymbolsIn = bi2de(dataInMatrix);
   
   %output
   m = qammod(dataSymbolsIn, modulation_order,'gray');
 end

end

