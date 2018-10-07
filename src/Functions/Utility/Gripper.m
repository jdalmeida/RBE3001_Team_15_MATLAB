function Gripper(pp, value)
%GRIPPER takes in the value of the gripper and returns the current position
global GRIPPER_ID

packet = zeros(15, 1, 'single');
packet(1) = value;

pp.command(GRIPPER_ID, packet);

end

