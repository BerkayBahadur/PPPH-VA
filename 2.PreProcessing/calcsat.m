function [data] = calcsat(data,options)

psat.gps = NaN(32,7);
psat.glo = NaN(26,7);
psat.gal = NaN(36,7);
psat.bds = NaN(61,7);

clkint = data.inf.time.clkint;
sp3int = data.inf.time.sp3int;
rec    = data.inf.rec.pos;
if size(rec,1) ~= 1
    rec = rec';
end

if options.system.gps == 1
    st_ls = find(~isnan(data.obs.gps(options.obsp.gps,:)));
    if ~isempty(st_ls)
        for k=st_ls
            obs  = data.obs.gps(options.obsp.gps,k);
            trec = data.obs.ep;
            dclk = data.clk.gps(:,k);
            dxyz = data.sat.gps(:,:,k);
            [pos] = orb_sp3(obs,trec,dclk,dxyz,rec,clkint,sp3int);
            if ~any(isnan(pos))
                psat.gps(k,:) = pos;
            else
                data.obs.gps(options.obsp.gps,k) = NaN;          
            end           
        end
    end
end
if options.system.glo == 1
    st_ls = find(~isnan(data.obs.glo(options.obsp.glo,:)));
    if ~isempty(st_ls)
        for k=st_ls
            obs  = data.obs.glo(options.obsp.glo,k);
            trec = data.obs.ep;
            dclk = data.clk.glo(:,k);
            dxyz = data.sat.glo(:,:,k);
            [pos] = orb_sp3(obs,trec,dclk,dxyz,rec,clkint,sp3int);
            if ~any(isnan(pos))
                psat.glo(k,:) = pos;
            else
                data.obs.glo(options.obsp.glo,k) = NaN;
            end           
        end
    end
end
if options.system.gal == 1
    st_ls = find(~isnan(data.obs.gal(options.obsp.gal,:)));
    if ~isempty(st_ls)
        for k=st_ls
            obs  = data.obs.gal(options.obsp.gal,k);
            trec = data.obs.ep;
            dclk = data.clk.gal(:,k);
            dxyz = data.sat.gal(:,:,k);
            [pos] = orb_sp3(obs,trec,dclk,dxyz,rec,clkint,sp3int);
            if ~any(isnan(pos))
                psat.gal(k,:) = pos;
            else
                data.obs.gal(options.obsp.gal,k) = NaN;
            end      
        end
    end
end
if options.system.bds == 1
    st_ls = find(~isnan(data.obs.bds(options.obsp.bds,:)));
    if ~isempty(st_ls)
        for k=st_ls
            obs  = data.obs.bds(options.obsp.bds,k);
            trec = data.obs.ep;
            dclk = data.clk.bds(:,k);
            dxyz = data.sat.bds(:,:,k);
            [pos] = orb_sp3(obs,trec,dclk,dxyz,rec,clkint,sp3int);
            if ~any(isnan(pos))
                psat.bds(k,:) = pos;
            else
                data.obs.bds(options.obsp.bds,k) = NaN;
            end
        end
    end
end

data.psat = psat;
end

function [pos] = orb_sp3(obs,trec,dclk,dxyz,rec,clkint,sp3int)
c = 299792458;  
we=7.2921151467e-5;
pos = NaN(1,7);

tof = obs./c;
nep = trec - tof;
dt  = entrp(nep,clkint,dclk);
if ~isnan(dt)
    nep = nep - dt;

    [X,VX] = entrp(nep,sp3int,dxyz(:,1));
    [Y,VY] = entrp(nep,sp3int,dxyz(:,2));
    [Z,VZ] = entrp(nep,sp3int,dxyz(:,3));
    [dt,~] = entrp(nep,clkint,dclk);

    R  = [X Y Z];

    tf     = norm(R - rec)./c;
    er_ang = rad2deg(tf*we);
    pos(1,1:3) = rotation(R,er_ang,3);

    pos(1,4:7) = [VX VY VZ dt];
end
end