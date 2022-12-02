%inputs: b (binary data)
%        M (mod order)
%        mode (UnitAvgPower/not)
%output: M-QAM modulated column vector. 
function [m] = qamMod(b, M, mode)

if strcmp(mode,'true')
    
  %generating constellation points
  qam_v = (-sqrt(M)+1:2:sqrt(M)-1).';
  Pavg = sum(qam_v.^2)*length(qam_v)/M;
  qam_v = qam_v/sqrt(2*Pavg);
  const = zeros(M,1);
    for ii=1:length(qam_v)
      if mod(ii,2)==0
        const((ii-1)*sqrt(M)+1:ii*sqrt(M)) =  flipud((qam_v+1i*qam_v(ii)));
      else 
        const((ii-1)*sqrt(M)+1:ii*sqrt(M)) =  (qam_v+1i*qam_v(ii));
      end
    end

  num_sym = length(b)/log2(M); num_bit_sym = log2(M);
  b = reshape(b, [num_bit_sym, num_sym]);

  %gray_logic = logical(zeros(M,log2(M)));  %character array initialization
  logic_const = [zeros(M,1) logical(dec2bin(0:M-1)-'0')];    %logical binary numbers       
  %gray_logic = mod(logic_const(:,2:end)+logic_const(:,1:end-1),2);
  gray_logic = xor(logic_const(:,2:end),logic_const(:,1:end-1));   
  dummy = fliplr(2.^(0:log2(M)-1));
  gray_index = gray_logic*dummy.'+1;  %gray constellation array index
  dummy2 = zeros(M,1);
  
  for ii = 1:M
     dummy2(ii) = const(gray_index==ii);
  end

  const= dummy2;
  m = const(dummy*b+1); %gray coded symbols
  disp(m)
  
elseif strcmp(mode,'false')
 
  %generating constellation points
  qam_v = (-sqrt(M)+1:2:sqrt(M)-1).';
  const = zeros(M,1);
    for ii=1:length(qam_v)
      if mod(ii,2)==0
       const((ii-1)*sqrt(M)+1:ii*sqrt(M)) =  flipud((qam_v+1i*qam_v(ii)));
      else 
       const((ii-1)*sqrt(M)+1:ii*sqrt(M)) =  (qam_v+1i*qam_v(ii));
      end
    end

  num_sym = length(b)/log2(M); num_bit_sym = log2(M);
  b = reshape(b, [num_bit_sym, num_sym]);

  %gray_logic = logical(zeros(M,log2(M)));    %character array initialization
  logic_const = [zeros(M,1) logical(dec2bin(0:M-1)-'0')];    %logical binary numbers       
  %gray_logic = mod(logic_const(:,2:end)+logic_const(:,1:end-1),2);
  gray_logic = xor(logic_const(:,2:end),logic_const(:,1:end-1));   
  dummy = fliplr(2.^(0:log2(M)-1));
  gray_index = gray_logic*dummy.'+1;  %gray constellation array index
  dummy2 = zeros(M,1);
  for ii = 1:M
   dummy2(ii) = const(gray_index==ii);
  end

  const= dummy2;
  m = const(dummy*b+1); %gray coded symbols
  disp(m)
else
  error('Wrong input!');
end

%plot constellation diagram
scatterplot(m,1,0,'k*'), grid on;
line([0,0], ylim, 'Color' , 'k' , 'LineWidth' , 0.2);
line(xlim, [0,0], 'Color', 'k', 'LineWidth' , 0.2);
end

