d= daq.getDevices  
%tells the devices you have available to use with your system

d(2)    
%selects the microphone from your list of devices

s = daq.createSession('ni')
%starts to collect data

s.rate = 2000

addAnalogInputChannel(s, 'cDAQ1Mod1', [0 1 2 3],'Voltage')
[data,time] = startForeground(s);


