function [data] = sfvsysobs(data,options)

sg = size(data.obs.gps,2);
sr = sg + size(data.obs.glo,2);
se = sr + size(data.obs.gal,2);
sc = se + size(data.obs.bds,2);

st   = zeros(1,sc);
cod  =   NaN(1,sc);

if options.system.gps == 1
    nt = vertcat(options.obsp.gps,options.obsl.gps);
    tt = ~isnan(sum(data.obs.gps(nt,:)));
    st(1:sg)    = tt;
    cod(1:sg)   = data.obs.gps(options.obsp.gps,:);
end
if options.system.glo == 1
    nt = vertcat(options.obsp.glo,options.obsl.glo);
    tt = ~isnan(sum(data.obs.glo(nt,:)));
    st(sg+1:sr)  = tt;
    cod(sg+1:sr) = data.obs.glo(options.obsp.glo,:);
end
if options.system.gal == 1
    nt = vertcat(options.obsp.gal,options.obsl.gal);
    tt = ~isnan(sum(data.obs.gal(nt,:)));
    st(sr+1:se)  = tt;
    cod(sr+1:se) = data.obs.gal(options.obsp.gal,:);
end
if options.system.bds == 1
    nt = vertcat(options.obsp.bds,options.obsl.bds);
    tt = ~isnan(sum(data.obs.bds(nt,:)));
    st(se+1:sc)  = tt;
    cod(se+1:sc) = data.obs.bds(options.obsp.bds,:);
end

data.obs.st   = st;
data.obs.cod  = cod;
end