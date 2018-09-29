function [torq] = RawToTorque(raw)
%RAWTOTORQUE input raw ADC values and output the corresponding torques

% offset = [0.5588, 0.7212, 0.5372];
% scale = [0.0001, -0.0669, 0.0003];

offset = [0.5770, 0.9935, 0.5202];
% scale = [0.0436, -9.7030e-07, -3.9379e-05];
scale = [0.4684, 0.4684, 0.4684]/1000;

torq = (raw - offset) ./ scale;

end

