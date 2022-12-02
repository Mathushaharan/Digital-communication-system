%input: data to be demodulated
%       modulation order 
%       mode (UnitAvgPower or not (true/false))
%output: demodulated bitstream

function d = qamDemodfunc(r,modulation_order, mode)

 if strcmp(mode,'true')
    
    dataSymbolsOut = qamdemod(r,modulation_order,'gray', 'UnitAveragePower' , true);
    dataOutMatrix = de2bi(dataSymbolsOut,log2(4));
    d = dataOutMatrix(:);
    
 elseif strcmp(mode, 'false')
     
     dataSymbolsOut = qamdemod(r,modulation_order,'gray');
     dataOutMatrix = de2bi(dataSymbolsOut,log2(4));
     d = dataOutMatrix(:);
 end
 
end