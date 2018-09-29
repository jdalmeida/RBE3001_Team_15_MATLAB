function [position] = Gripper(pp, value)
%GRIPPER takes in the value of the gripper and returns the current position
constants;
packet = zeros(15, 1, 'single');
packet(1) = value;

pp.write(GRIPPER_ID, packet);
pause(0.003);
returnPacket=  pp.read(GRIPPER_ID);

position = returnPacket(1);

end

