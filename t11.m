
UserInput = ('What is the correct class for this object?'); 
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj, UserInput);