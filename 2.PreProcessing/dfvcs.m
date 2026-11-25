function [data] = dfvcs(data,options)

dt  = data.inf.time.int;

sig0 = sqrt(2*(0.0027^2 + 0.0017^2));

dl  = (0.4)*(dt/3600);

[sats] = dfvsats(data,options);
for k=sats.sls
    if k<33 
        kk = k;
        elv = data.loc.gps(kk,2);
        l1  = data.obs.gps(options.obsl.gps,kk);
        l2  = data.obs.gps(options.obsl2.gps,kk);
        lp1 = data.pobs.gps(options.obsl.gps,kk);
        lp2 = data.pobs.gps(options.obsl2.gps,kk);

        gfc = l1 - l2;        
        gfp = lp1 - lp2;
        dgf = gfp - gfc;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;
        if abs(dgf)>((4*smg)+dl)
            data.obs.gps(options.obsp.gps,kk) = NaN;
            data.obs.gps(options.obsp2.gps,kk) = NaN;
            data.obs.gps(options.obsl.gps,kk) = NaN;
            data.obs.gps(options.obsl2.gps,kk) = NaN;
        end
    elseif k<59
        kk = k - 32;
        elv = data.loc.glo(kk,2);
        l1  = data.obs.glo(options.obsl.glo,kk);
        l2  = data.obs.glo(options.obsl2.glo,kk);
        lp1 = data.pobs.glo(options.obsl.glo,kk);
        lp2 = data.pobs.glo(options.obsl2.glo,kk);

        gfc = l1 - l2;        
        gfp = lp1 - lp2;
        dgf = gfp - gfc;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;
        if abs(dgf)>((4*smg)+dl)
            data.obs.glo(options.obsp.glo,kk) = NaN;
            data.obs.glo(options.obsp2.glo,kk) = NaN;
            data.obs.glo(options.obsl.glo,kk) = NaN;
            data.obs.glo(options.obsl2.glo,kk) = NaN;
        end
    elseif k<95
        kk = k - 58;
        elv = data.loc.gal(kk,2);
        l1  = data.obs.gal(options.obsl.gal,kk);
        l2  = data.obs.gal(options.obsl2.gal,kk);
        lp1 = data.pobs.gal(options.obsl.gal,kk);
        lp2 = data.pobs.gal(options.obsl2.gal,kk);

        gfc = l1 - l2;        
        gfp = lp1 - lp2;
        dgf = gfp - gfc;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;
        if abs(dgf)>((4*smg)+dl)
            data.obs.gal(options.obsp.gal,kk) = NaN;
            data.obs.gal(options.obsp2.gal,kk) = NaN;
            data.obs.gal(options.obsl.gal,kk) = NaN;
            data.obs.gal(options.obsl2.gal,kk) = NaN;
        end
    else
        kk = k - 94;
        elv = data.loc.bds(kk,2);
        l1  = data.obs.bds(options.obsl.bds,kk);
        l2  = data.obs.bds(options.obsl2.bds,kk);
        lp1  = data.pobs.bds(options.obsl.bds,kk);
        lp2  = data.pobs.bds(options.obsl2.bds,kk);

        gfc = l1 - l2;        
        gfp = lp1 - lp2;
        dgf = gfp - gfc;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;
        if abs(dgf)>((4*smg)+dl)
            data.obs.bds(options.obsp.bds,kk) = NaN;
            data.obs.bds(options.obsp2.bds,kk) = NaN;
            data.obs.bds(options.obsl.bds,kk) = NaN;
            data.obs.bds(options.obsl2.bds,kk) = NaN;
        end
    end
end
end