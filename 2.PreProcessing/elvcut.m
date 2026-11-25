function [data] = elvcut(data,options)

r_xyz = data.inf.rec.pos;

loc.gps = NaN(32,2);
loc.glo = NaN(26,2);
loc.gal = NaN(36,2);
loc.bds = NaN(61,2);

if options.system.gps == 1
    st_ls = find(~isnan(data.obs.gps(options.obsp.gps,:)));
    if ~isempty(st_ls)
        for k=st_ls
            s_xyz = data.psat.gps(k,1:3);
            [az,elev] = local(r_xyz,s_xyz,1);
            loc.gps(k,1) = az;
            loc.gps(k,2) = elev;
            if (elev<options.elvangle)
                data.obs.gps(options.obsp.gps,k) = NaN;
            end    
        end
    end
end
if options.system.glo == 1
    st_ls = find(~isnan(data.obs.glo(options.obsp.glo,:)));
    if ~isempty(st_ls)
        for k=st_ls
            s_xyz = data.psat.glo(k,1:3);
            [az,elev] = local(r_xyz,s_xyz,1);
            loc.glo(k,1) = az;
            loc.glo(k,2) = elev;
            if (elev<options.elvangle)
                data.obs.glo(options.obsp.glo,k) = NaN;
            end
        end
    end
end
if options.system.gal == 1
    st_ls = find(~isnan(data.obs.gal(options.obsp.gal,:)));
    if ~isempty(st_ls)
        for k=st_ls
            s_xyz = data.psat.gal(k,1:3);
            [az,elev] = local(r_xyz,s_xyz,1);
            loc.gal(k,1) = az;
            loc.gal(k,2) = elev;
            if (elev<options.elvangle)
                data.obs.gal(options.obsp.gal,k) = NaN;
            end
        end
    end
end
if options.system.bds == 1
    st_ls = find(~isnan(data.obs.bds(options.obsp.bds,:)));
    if ~isempty(st_ls)
        for k=st_ls
            s_xyz = data.psat.bds(k,1:3);
            [az,elev] = local(r_xyz,s_xyz,1);
            loc.bds(k,1) = az;
            loc.bds(k,2) = elev;
            if (elev<options.elvangle)
                data.obs.bds(options.obsp.bds,k) = NaN;
            end
        end
    end
end

data.loc = loc;
end