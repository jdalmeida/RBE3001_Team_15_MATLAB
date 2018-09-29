function [torq] = RawToTorque(raw)
%RAWTOTORQUE input raw ADC values and output the corresponding torques

% offset = [0.5588, 0.7212, 0.5372];
% scale = [0.0001, -0.0669, 0.0003];
% 
% offset = [0.5770, 0.9935, 0.5202];
% % scale = [0.0436, -9.7030e-07, -3.9379e-05];
scale = [0.0436, 0.0436, 0.0436]/1000;
% 
% torq = (raw - offset) ./ scale;


%% try 2

offset = [0.5619, 0.4835, 0.6117];
kTorqL3 = [0.0045, 0.0003, -0.0010];

% scale = [1, -4.5162e-07, -1.8840e-05];

t = (raw - offset - kTorqL3) ./ scale;

torq = [0, t(2), t(3)];
end

