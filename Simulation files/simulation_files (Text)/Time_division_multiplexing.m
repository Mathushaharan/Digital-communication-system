%inputs: sig1, sig2
%output: multiplexed datastream 
function Out = Time_division_multiplexing(sig1, sig2)

  Out = []; %Output
  %specifying time 
  t = 0:0.1:max(length(sig1),length(sig2))/10 - 1; %total time needed for sending samples
  %obtaining the output
  for i = 1:length(t)
    Out = [Out sig1(i) sig2(i)];
  end
 
 %plotting
 figure
 h = stairs(Out);
 h.LineWidth = 0.1;
 ylim([-2 2])
 title('Multiplexed signal')
end
