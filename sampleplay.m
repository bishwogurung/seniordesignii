%code to play an audio file
%the file name can be replaced with any .wav file
%%
%Version 1
[y,Fs] = audioread('sound.wav');
sound(y,Fs);
%%
%Version 2
%audioread('sound.wav');
%sound(audioread('sound.wav'),50000)
%%
%uncomment either one of them to play the audio file


 



