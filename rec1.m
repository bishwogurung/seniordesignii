%Takes your voice and plays it
%plots the voice pattern

recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');
play(recObj);
y = getaudiodata(recObj);
plot(y);

