
%% Calls the protocol server on the nucleo and returns 3 matricies with the values
function [pos, vel, force] = GetStatus(pp)
constants;
packet = zeros(15, 1, 'single');

pp.write(PROTOCOL_ID, packet);
pause(0.003);
returnPacket=  pp.read(PROTOCOL_ID);

%returnPacket = pp.command(PROTOCOL_ID, packet);
trans = returnPacket';
pos = trans([1,4,7]);
vel = trans([2,5,8]);
force = trans([3,6,9]);
end
