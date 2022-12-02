%inputs: modulated signal (m)
%        signal with channel noise (c)
%output: percentage error
function pcterr = percentError(m,c)
pcterr = mean(100*(abs(c-m)./abs(m))); %error
fprintf('Percentage error = %f', pcterr);
fprintf('\n\n');
end