mass1 = .300; %kilograms
mass2 = .100;
minMass=0.015; %minimal mass from the gripper
maxMass = .300; %maximum mass from weighted base
curMass=maxMass;

g = 9.8;
l2 = .175; %m
l3 = .16928; %m

%90 0 is the highest torque config
q3=90;
q2=0;

torquem1 = l2 * cosd(q2) * mass1 * g;

torquem2 = (l2 * cosd(q2) + l3 * cosd(q3 - 90 + q2)) * (mass2 + curMass) * g;

%joint2 sees the torque of the first and second mass
torquej2 = torquem1 + torquem2;

% Torque = length * effective distacne*  force
torquej3 = (l3 * cosd(q3 - 90 + q2)) * (mass2 + curMass) * g;

maxTorques=[1.8641, .6636];
% want to map from 0->1.8 and 0->.6636 to 0->.1
j2out = j2in/maxTorques(1)/10
j3out = j3in/maxTorques(2)/10
% mapped2 = mapTorque(torquej2);
% 
% mapped3 = mapTorque(torquej3);

% function mapped = mapTorque(torque)
% 
%     mapped = torque * .4/maxTorque + .3;
%     
% end