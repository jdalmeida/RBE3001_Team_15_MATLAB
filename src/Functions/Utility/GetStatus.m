
%% Calls the protocol server on the nucleo and returns 3 matricies with the values
function [pos, vel, force] = GetStatus(pp)
global PROTOCOL_ID
packet = zeros(15, 1, 'single');

returnPacket = pp.command(PROTOCOL_ID, packet);

trans = returnPacket';
pos = trans([1,4,7]);
vel = trans([2,5,8]);
force = trans([3,6,9]);
end
