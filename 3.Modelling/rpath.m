function [rpath] = rpath(r_xyz,s_xyz)

mu=3986004.418*(10^8);
c =2.99792458*(10^8);

rsat = norm(s_xyz);
rrec = norm(r_xyz);
rs   = s_xyz - r_xyz;
rrs  = norm(rs);
rpath = ((2*mu)/(c^2))*log((rsat+rrec+rrs)/(rsat+rrec-rrs));

end

