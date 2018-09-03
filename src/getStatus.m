function [pos, vel, force] = getStatus(pp)
    PROTOCOL_ID = 36;

    packet = zeros(15, 1, 'single');

    returnPacket = pp.command(PROTOCOL_ID, packet);
    trans = returnPacket';
    pos = trans([1,4,7]);
    vel = trans([2,5,8]);
    force = trans([3,5,9]);
end

