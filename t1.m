% Define system parameters
framesize = 80;       % Framesize (samples)
Fs = 8000;            % Sampling Frequency (Hz)
RUNNING = 1;          % A flag to continue data capture

% Setup data acquisition from sound card
ai = analoginput('winsound');
addchannel(ai, 1);

% Configure the analog input object.
set(ai, 'SampleRate', Fs);
set(ai, 'SamplesPerTrigger', framesize);
set(ai, 'TriggerRepeat',inf);
set(ai, 'TriggerType', 'immediate');

% Start acquisition
start(ai)

% Keep acquiring data while "RUNNING" ~= 0
while RUNNING
    % Acquire new input samples
    newdata = getdata(ai,ai.SamplesPerTrigger);
    % Do some processing on newdata
     %...
     %<DO _ SOMETHING>
     %...

    % Set RUNNING to zero if we are done
%    if <WE _ ARE _ DONE>
 %        RUNNING = 0;
  %  end

end

% Stop acquisition
stop(ai);

% Disconnect/Cleanup
delete(ai);
clear ai;