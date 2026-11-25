function [data] = sfvcs(data,options)

dt  = data.inf.time.int;

sig0 = sqrt((0.003^2 + 0.3^2));

dl  = (0.4)*(dt/3600);
[sats] = sfvsats(data,options);

for k=sats.sls
    if k<33 
        kk = k;
        p1  = data.obs.gps(options.obsp.gps,kk);
        l1  = data.obs.gps(options.obsl.gps,kk);
        elv = data.loc.gps(kk,2);
        
        pp1  = data.pobs.gps(options.obsp.gps,kk);
        lp1  = data.pobs.gps(options.obsl.gps,kk);

        sgf = l1 - p1; 
        pgf = lp1 - pp1;

        dgf = pgf - sgf;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;

        if abs(dgf)>((4*smg)+dl)
            data.obs.gps(options.obsp.gps,kk) = NaN;
        end
    elseif k<59
        kk = k - 32;
        p1  = data.obs.glo(options.obsp.glo,kk);
        l1  = data.obs.glo(options.obsl.glo,kk);
        elv = data.loc.glo(kk,2);
        
        pp1  = data.pobs.glo(options.obsp.glo,kk);
        lp1  = data.pobs.glo(options.obsl.glo,kk);

        sgf = l1 - p1;
        pgf = lp1 - pp1;

        dgf = pgf - sgf;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;

        if abs(dgf)>((4*smg)+dl)
            data.obs.glo(options.obsp.glo,kk) = NaN;
        end
    elseif k<95
        kk = k - 58;
        p1  = data.obs.gal(options.obsp.gal,kk);
        l1  = data.obs.gal(options.obsl.gal,kk);
        elv = data.loc.gal(kk,2);
        
        pp1  = data.pobs.gal(options.obsp.gal,kk);
        lp1  = data.pobs.gal(options.obsl.gal,kk);

        sgf = l1 - p1; 
        pgf = lp1 - pp1;

        dgf = pgf - sgf;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;

        if abs(dgf)>((4*smg)+dl)
            data.obs.gal(options.obsp.gal,kk) = NaN;
        end
    else
        kk = k - 94;
        p1  = data.obs.bds(options.obsp.bds,kk);
        l1  = data.obs.bds(options.obsl.bds,kk);
        elv = data.loc.bds(kk,2);
        
        pp1  = data.pobs.bds(options.obsp.bds,kk);
        lp1  = data.pobs.bds(options.obsl.bds,kk);

        sgf = l1 - p1;
        pgf = lp1 - pp1;

        dgf = pgf - sgf;
        me  = 1 + (10*exp(-elv/10));
        smg = sig0*me;

        if abs(dgf)>((4*smg)+dl)
            data.obs.bds(options.obsp.bds,kk) = NaN;
        end
    end
end
end