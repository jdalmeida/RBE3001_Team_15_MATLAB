clear;
[y,Fs] = audioread('Bulbasaur.wav');
sound(y,Fs);
pause(5);
[y,Fs] = audioread('Squirtle.wav');
sound(y,Fs);
pause(4);
[y,Fs] = audioread('poke-who.wav');
sound(y,Fs);