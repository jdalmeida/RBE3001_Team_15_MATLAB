function [torq] = RawToTorque(raw)
%RAWTOTORQUE input raw ADC values and output the corresponding torques

% Given values
offset = [2.285, 1.64, 2.33] * 1000;
scale = [178.5, 1, -0.9];

t = (raw - offset) ./ scale;

torq = [0, 0, t(3)];
end

