%reading the text and converting it to 7 bit array format
fileid = fopen('text.txt'); %open text file
format = '%c';
blockOfText = fscanf(fileid,format) %print the text 
my_text = dec2bin(blockOfText,7); %convert to binary form to obtain an array containing 7bit elements
disp('my_text: ')
my_text %display the array of 7bit elements


%rearranging the above array to single bit elements
my_text_new = reshape(dec2bin(blockOfText,7).'-'0',1,[]);
my_text_new = num2str(my_text_new);
disp('my_text_new: ')
disp(my_text_new) %display my_text_new


%lempel-ziv source encoding
my_text_new = str2num(my_text_new);
[h,~,codelength] = lempelzivEncode(my_text_new);


%computing the approximate compression ratio and diplay it
outputLength = codelength*floor(length(h)/codelength)-floor(length(h)/codelength);
inputLength = length(my_text_new);
compRatio = (outputLength/inputLength)*100;
str1 = sprintf('\nDetails about source encoding: \nInput length is %d',...
    inputLength);
str2 = sprintf('Output length is %d\nApprox. Compression ratio is %f\n\n',...
    outputLength,compRatio);
disp(str1) %display string 1
disp(str2) %display string 2

%display the source encoded sequence
disp('Source Encoded sequence: ')
%converting h into bitstream
ac = num2str(h);
ac = ac(ac~=' ');
disp(ac) 

%Writing the source encoded output in 'Text_0.txt'
fileid = fopen('Text_0.txt' , 'w');
fprintf(fileid,'%i',h);


%channel encoding
e = channelEncoding(h);

%converting the channel encoded array of bits to bitstream  
e = num2str(e);
e = e(e~=' ');

%display channel encoded sequence
disp('Channel encoded sequence: ')
disp(e) 

%writing the channel encoded file
fileid = fopen('Text_1.txt' , 'w');
fprintf(fileid,'%c',e);


%QAM modulation
e = e-'0';
m = qamModfunc(e,4,'false');
c = awgn(m, 15, 'measured', 69);

%constellation diagram
sPlotFig = scatterplot(c,1,0,'g.');
hold on
scatterplot(m,1,0,'k*',sPlotFig)
title('Constellation diagram')

%demodulation
z = qamDemodfunc(c,4, 'false');
z = z'; %converting to column matrix

disp('Demodulated bit sequence: ')
%converting into bitstream
bc = num2str(z);
bc = bc(bc~=' ');
disp(bc) 

%channel Decoding using the developed function
y = channelDecoding(z);

%display channel decoded stream
y_stream = num2str(y);
y_stream = y_stream(y_stream~=' ');
disp('Channel decoded sequence: ')
disp(y_stream)

%source decoding
O = lempelzivDecod(y);

%display source decoded stream
O_stream = num2str(O);
O_stream = O_stream(O_stream~=' ');
disp('Source decoded sequence: ')
disp(O_stream)

%checking the similarity of decoded bits and msg bits
[number, ratio] = biterr(O,my_text_new);
fprintf('\nBit erros between transmitted, received bits = %d' ,number);


%formatting the received bits and writing it in Text_2.txt
receivedText = char(bin2dec(num2str(reshape(O_stream, 7 , [])).'));
receivedText = receivedText';
fileid = fopen('Text_2.txt' , 'w');
fprintf(fileid,'%c',receivedText);

%Multiplexing 

%Illustrating Time division multiplexing
%specifying time 
t = 0:0.1:2*pi;
n = sin(t); %first signal
m = 0.5*cos(t);%second signal
v = triang(length(t)); %third signal
y1 = []; % output
%obtaining the output
for i = 1:length(t)
y1 = [y1 n(i) m(i) v(i)];
end
figure
stem(y1)
ylim([-2 2])
title('Example illustration of 3 multiplexed signals')


%multiplexing 2 blocks of the same text transmitted by 2 users
%--------------------------------------
fprintf('\n\n\nmultiplexing 2 blocks of the same text transmitted by 2 users\n')
fprintf('-----------------------------------------')
OutPut = Time_division_multiplexing(e, e);
OutPutstream = num2str(OutPut);
OutPutstream = OutPutstream(OutPutstream~=' ');
fprintf('\n\nMultiplexed bitstream: ');
disp(OutPutstream)

%------------------------------------------


