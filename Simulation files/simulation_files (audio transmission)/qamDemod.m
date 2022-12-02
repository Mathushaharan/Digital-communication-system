% inputs: r - input symbols
%         M - Mod_Order 
%         mode - Unit average power or not
%output:  d - demodulated sig

function [d] = qamDemod(r, M, mode,normVec )
% const array generated
if nargin == 3
    normVec = 1;
end

if strcmp(mode,'true')
    
  qam_v = (-sqrt(M)+1:2:sqrt(M)-1).';
  Pavg = sum(qam_v.^2)*length(qam_v)/M;
  qam_v = qam_v/sqrt(2*Pavg);
  const = zeros(M,1);
  for ii=1:length(qam_v)
     if mod(ii,2)==0
      const((ii-1)*sqrt(M)+1:ii*sqrt(M))...
          =  flipud((qam_v+1i*qam_v(ii)));
     else 
      const((ii-1)*sqrt(M)+1:ii*sqrt(M))...
          =  (qam_v+1i*qam_v(ii));
     end
  end
 
  num_bit_sym = log2(M);  % number of bits in each symbol 
  numSym = length(r);
  binPowVec = fliplr(2.^(0:log2(M)-1));
 
  DbinVector = logical(dec2bin(0:M-1)-'0');
  dd = [zeros(M,1) DbinVector];    %logical binary numbers
  binVector = xor(dd(:,2:end),dd(:,1:end-1)); % gray coded binary set  
  gray_index = binVector*binPowVec.'+1;  %gray constellation array index
  dummy2 = zeros(M,1);
  for ii = 1:M
      dummy2(ii) = const(gray_index==ii);
  end
  constG= dummy2; 
    
  %hard decision method
  dummy_const...
      = repmat(normVec,[length(const),1]).*repmat(const,[1,length(normVec)]);
  dummy_const...
      = repmat(dummy_const,[1, numSym/length(normVec)]);
 
  %dummy_const = repmat(const,[1,numSym]);
  err_sym = abs(dummy_const-repmat(r,[length(const),1]));
  [~, index]=min(err_sym,[],1);    %find the min distance symbol vector
  %est_sym = const(index);     %estimated symbols
  d = reshape(binVector(index,:).',[1 numSym*num_bit_sym]);  %estimated bits
 
end
  
if strcmp(mode,'false')
    
  qam_v = (-sqrt(M)+1:2:sqrt(M)-1).';
  const = zeros(M,1);
  for ii=1:length(qam_v)
     if mod(ii,2)==0
      const((ii-1)*sqrt(M)+1:ii*sqrt(M))...
          =  flipud((qam_v+1i*qam_v(ii)));
     else 
      const((ii-1)*sqrt(M)+1:ii*sqrt(M))...
          =  (qam_v+1i*qam_v(ii));
     end
  end
 
  num_bit_sym = log2(M);  %number of bits in each symbol 
  numSym = length(r);
  binPowVec = fliplr(2.^(0:log2(M)-1));
 
  DbinVector = logical(dec2bin(0:M-1)-'0');
  dd = [zeros(M,1) DbinVector]; %logical binary numbers
  binVector = xor(dd(:,2:end),dd(:,1:end-1)); %gray coded binary set  
  gray_index = binVector*binPowVec.'+1;  %gray constellation array index
  dummy2 = zeros(M,1);
  for ii = 1:M
      dummy2(ii) = const(gray_index==ii);
  end
  constG= dummy2; 
   
  %hard Decision method
  dummy_const ...
  =repmat(normVec,[length(const),1]).*repmat(const,[1,length(normVec)]);
  dummy_const...
  =repmat(dummy_const,[1, numSym/length(normVec)]);
 
  %dummy_const = repmat(const,[1,numSym]);
  err_sym = abs(dummy_const-repmat(r,[length(const),1]));
  [~, index]=min(err_sym,[],1);    %find the min distance symbol vector
  %est_sym = const(index);  %estimated symbols
  
  %estimated bits
  d = reshape(binVector(index,:).',[1 numSym*num_bit_sym]); 
end
  
end



