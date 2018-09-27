function [torq] = rawToTorque(raw)
%RAWTOTORQUE input raw ADC values and output the corresponding torques

offset = [0.5588, 0.7212, 0.5372];
scale = [0.0001, -0.0669, 0.0003]

torq = (raw - offset) / scale;

end

