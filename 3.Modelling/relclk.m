function [rclk] = relclk(s_xyz,v_xyz)

c = 299792458;

rclk = ((-2)*((dot(s_xyz,v_xyz))/(c^2)))*c;

end

