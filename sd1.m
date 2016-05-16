% a = wavread('answer')
% 
% wavplay(a, 44100)


function playFile(myfile)
   load(myfile);
   
   obj = audioplayer(y, Fs);
   obj.TimerFcn = 'showSeconds';
   obj.TimerPeriod = 1;
   
   play(obj);
end

function showSeconds
   disp('tick')
end

playFile('answer.wav')