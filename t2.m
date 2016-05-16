   Fs = 10000;   % Sampling Frequency (Hz)
  Nseconds = 1; % Length of speech signal
  fprintf('say a word immediately after hitting enter: ');
  input('');
  % Get time-domain speech signal from microphone
  y  = audiorecord(Nseconds*Fs, Fs, 'double');
x = fft(y);
% Get response until Fs/2 (for frequency from Fs/2 to Fs, response is repeated)
x = x(1:floor(Nseconds*Fs/2));
% Plot magnitude vs. frequency
m = abs(x);
f = (0:length(x)-1)*(Fs/2)/length(x);
plot(f,m);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
% Get time-domain speech signal already recorded sample
y2=audioread('sample01_6k.wav','double');
x2 = fft(y2);
% Get response until Fs/2 (for frequency from Fs/2 to Fs, response is repeated)
x2 = x2(1:floor(Nseconds*Fs/2));
% Plot magnitude vs. frequency
m2 = abs(x2);
f2 = (0:length(x2)-1)*(Fs/2)/length(x2);