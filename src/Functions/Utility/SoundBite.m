function SoundBite(name)
%SOUNDBITE plays sound

switch name
    case 'Bulbasaur'
        [y,Fs] = audioread('Bulbasaur.wav');
    case 'Squirtle'
        [y,Fs] = audioread('Squirtle.wav');
    case 'I Choose You'
        [y,Fs] = audioread('poke-who.wav');
    
end

sound(y, Fs);

end

