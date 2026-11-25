function [sats] = dfvsats(data,options)

ns = size(data.obs.st,2);
p1 = NaN(1,ns); p2 = NaN(1,ns); l1 = NaN(1,ns); l2 = NaN(1,ns);
sq = find(data.obs.st==1)';

for sk=sq'
    if sk<33
        p1(sk) = data.obs.gps(options.obsp.gps,sk);
        p2(sk) = data.obs.gps(options.obsp2.gps,sk);
        l1(sk) = data.obs.gps(options.obsl.gps,sk);
        l2(sk) = data.obs.gps(options.obsl2.gps,sk);
    elseif sk<59
        p1(sk) = data.obs.glo(options.obsp.glo,sk-32);
        p2(sk) = data.obs.glo(options.obsp2.glo,sk-32);
        l1(sk) = data.obs.glo(options.obsl.glo,sk-32);
        l2(sk) = data.obs.glo(options.obsl2.glo,sk-32);
    elseif sk<95
        p1(sk) = data.obs.gal(options.obsp.gal,sk-58);
        p2(sk) = data.obs.gal(options.obsp2.gal,sk-58);
        l1(sk) = data.obs.gal(options.obsl.gal,sk-58);
        l2(sk) = data.obs.gal(options.obsl2.gal,sk-58);
    else
        p1(sk) = data.obs.bds(options.obsp.bds,sk-94);
        p2(sk) = data.obs.bds(options.obsp2.bds,sk-94);
        l1(sk) = data.obs.bds(options.obsl.bds,sk-94);
        l2(sk) = data.obs.bds(options.obsl2.bds,sk-94);
    end
end

nt = vertcat(p1,p2,l1,l2);
st = find(~isnan(sum(nt)));
for s=st
    if s<33
        if any(isnan(data.psat.gps(s,:)))
            st(st(:)==s) = [];
        end
    elseif s<59
        if any(isnan(data.psat.glo(s-32,:)))
            st(st(:)==s) = [];
        end
    elseif s<95
        if any(isnan(data.psat.gal(s-58,:)))
            st(st(:)==s) = [];
        end
    else
        if any(isnan(data.psat.bds(s-94,:)))
            st(st(:)==s) = [];
        end
    end
end

m = length(st);

sno = m;
sls = st;

sats.sno = sno;
sats.sls = sls;
end