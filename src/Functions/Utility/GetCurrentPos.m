function [curPos] = GetCurrentPos(pp)
%GETCURRENTPOS returns current position in angles

[pos, ~, ~] = GetStatus(pp);

curPos = pos * 360.0/4096.0;
end

