%loading the audio file to matlab 
load handel.mat
filename = 'handel.wav';
audiowrite(filename,y,Fs);
[y,Fs] = audioread('handel.wav');

%obtaining the time domain signal 
t = linspace(0,length(y)/Fs,length(y));
figure
subplot(211)
plot(t,y)
title('Time domain signal')
xlabel('time')
ylabel('Amplitude')

%Obtaining freq spectrum
n = length(t);
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(fft(y, n));
 
subplot(212)
plot(fshift,abs(yshift))
ylim([0 800])
title('Spectrum of audio signal')
xlabel('Freq')
ylabel('Magnitude')
 
index = 069; %According to the index num
SNR = 0.0004*(index)^2 - 0.02*(index) + 0.25;
z=awgn(y,SNR,'measured');
 
%obtaining the time domain signal 'z'
figure
subplot(211)
plot(t,z)
title('Time domain signal (new input signal)')
xlabel('time')
ylabel('Amplitude')
 
%Obtaining freq spectrum
fshift = (-n/2:n/2-1)*(Fs/n);
yshift = fftshift(fft(z,n));
subplot(212)
plot(fshift,abs(yshift))
title('Spectrum of new input signal')
ylim([0 800])
xlabel('Freq')
ylabel('Magnitude')
 
%writing the new audio as audio_1.wav
audiowrite('audio_1.wav',z,Fs);
 
%sampling 
fs = 10240;  %new sampling frequency 
[n,~] = size(z);
time = (n/Fs);
NumOfSamples = round(fs*time);
 
samples = round(linspace(1,n,NumOfSamples));
s = zeros(1,fs);
Index = 1;
for i = samples
    s(Index) = z(i);
    Index = Index + 1;
end
 
T = linspace(0,length(s)/fs,length(s));
figure
stem (T,s)
xlabel('time')
ylabel('Amplitude')
title('Sampled signal (Fs = 10240 Hz)')
audiowrite('NewSampledAudio.wav', s ,fs);
fprintf('\nNo of samples = %d\n', NumOfSamples)
fprintf('Sampling time = %f sec\n', 1/fs);


Vmax = 1.5; %upper limit 
Vmin = -1.5; %lower limit
quantizingLevel = 64;
scalingfact = (Vmax-Vmin)/(quantizingLevel-1); %scaling factor
BitLength = log2(quantizingLevel);

%quantization
[q,q_Error,data] = Quantization(s,quantizingLevel,Index);

%plotting the quantized signal
figure
plot(T,q);
title('Quantized signal using 64 quantization levels')
xlabel('time')
ylabel('Amplitude')
audiowrite('audio_2.wav', q , fs)
 
%quantization error
figure
plot(T,q_Error)
title('Quantization Error')

%printing quantized values and q_Error
fprintf('[Quantized val, q_Error]\n\n ');
q_Error = q_Error'; %converting it to 1 column array
arr = [q' q_Error] %combine and display the quantized, error val in one array

%bitmapping
b = bitmapping(data);

%modulation
ModOrder = 4; %modulation Order
%getting user input for Unit Average Power = true/false
prompt = ("For UnitAveragePower, type 'true' otherwise type 'false' : ");
inp = input(prompt, "s");
m = qamMod(b, ModOrder, inp);
SNR = 10; %SNR in dB 
c = awgn(m,SNR,'measured',69);


%percentage error between c and m
Percentage_error = percentError(c,m);

%plotting Constellation diagrams
i = 1; %snr
c = awgn(m,i,'measured',69);
scatterplot(c,1,0,'g*')
title('constellation diagram for SNR = 1')

i = 3; %snr
c = awgn(m,i,'measured',69);
scatterplot(c,1,0,'g*')
title('constellation diagram for SNR = 3')

i = 5; %snr
c = awgn(m,i,'measured',69);
scatterplot(c,1,0,'g*')
title('constellation diagram for SNR = 5')

i = 7; %snr
c = awgn(m,i,'measured',69);
scatterplot(c,1,0,'g*')
title('constellation diagram for SNR = 7')
 
i = 9; %snr
c = awgn(m,i,'measured',69);
scatterplot(c,1,0,'g*')
title('constellation diagram for SNR = 9')


fprintf('<<<<<<<Obtaining error percentage for SNR = 1:2:10>>>>>>>>>>\n\n')

%obtaining percentage error for SNR = 1:2:10
Err = []; %arrray to store error value
for i = 1:2:10
      c = awgn(m,i,'measured',69); 
      fprintf('For SNR = %d, ', i) 
      err = percentError(c,m);
      if i ==1   
       Err(1) = err;
      end
      if i == 3 
       Err(2) = err;
      end 
      if i == 5
       Err(3) = err;
      end
      if i == 7 
       Err(4) = err;
      end
      if i == 9
       Err(5) = err;
      end
end
  
%plotting SNR vs error graph
i = 1:2:10;
figure
plot(i,Err, 'Marker' ,'s') %plotting the SNR vs errors graph
title('SNR vs Error graph')
xlabel('SNR'), ylabel('Error percentage')


r = awgn(m, 1.5, 'measured', 69); 
%plotting the constellation diagram
figure
scatterplot(r,1,0,'g*')

fprintf('\n\n')
%finding the num of errors
numOferrors = round((percentError(r,m)/100)*length(m));
fprintf('Num of error = %d\n\n' , numOferrors);

%demodulation 
r = r';
d = qamDemod(r,ModOrder ,inp);
clear inp;
figure
stairs(d)
ylim([-2 2])
title('demodulated signal')
 
%finding percent error after demodulation
[numErrors,BER] = biterr(b,d); 
fprintf('\nPercentage Error after Demodulation = %f \n\n',...
    ((numErrors/length(b))*100));



d = d';
d = reshape(char(d + '0'),length(d), 1);
%reverse bitmapping
k = 1;
levels = Vmin:scalingfact:Vmax; %q-levels
for i = 1:length(b)/BitLength
    for j = 1:BitLength
        bin_rearrange(i,j) = d(k);
        k = k + 1;
    end
end

bin_dec = bin2dec(bin_rearrange);
decoded_val = zeros(length(bin_dec),1);
for i = 1:length(bin_dec)
    decoded_val(i) = levels(bin_dec(i)+1);
end
 
%reconstruction of signal
in = 1; %index
reconstructed_sig = zeros(n,1);
for i = samples
    reconstructed_sig(i,1) = decoded_val(in,1);
    in = in + 1;
end

figure
plot(t,reconstructed_sig)
title('Reconstructed signal "t"')
xlabel('time'), ylabel('Amplitude');
ylim([-2 2])
 
%playing the received music
sound(reconstructed_sig,fs)
%writing the received music
audiowrite('audio_3.wav', reconstructed_sig, fs);
 