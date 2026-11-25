function [n,e,u,thrD] = vds_eval(xs,ref)

    [elip] = xyz2plh(ref,1);
    lat = elip(1);
    lon = elip(2);

    A = [-sind(lat)*cosd(lon), -sind(lat)*sind(lon), cosd(lat);...
         -sind(lon),            cosd(lon),           0;...
          cosd(lat)*cosd(lon),  cosd(lat)*sind(lon), sind(lat)];

    loc = zeros(size(xs,1),3);
    for i = 1:size(xs,1)
        loc(i,:) = (A*xs(i,1:3)')';
    end

    n = loc(:,1); e = loc(:,2); u = loc(:,3);
    thrD = sqrt(n.^2 + e.^2 + u.^2);
end