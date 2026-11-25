function [options] = sfvotype(data,options)

options.obsp.gps  = []; options.obsl.gps  = [];
options.obsp.glo  = []; options.obsl.glo  = [];
options.obsp.gal  = []; options.obsl.gal  = [];
options.obsp.bds  = []; options.obsl.bds  = [];

if options.system.gps == 1
    prior = 'PWCSLXYMND';
    for pi = 1:length(prior)
        s1 = strcat('C1',prior(pi));
        l1 = strcat('L1',prior(pi));
        if any(strcmp(data.inf.seq.gps,s1)) && any(strcmp(data.inf.seq.gps,l1))
            options.obsp.gps = find(strcmp(data.inf.seq.gps,s1));
            options.obsl.gps = find(strcmp(data.inf.seq.gps,l1));
            break
        end
    end
end

if options.system.glo == 1
    prior = 'PC';
    for pi = 1:length(prior)
        s1 = strcat('C1',prior(pi));
        l1 = strcat('L1',prior(pi));
        if any(strcmp(data.inf.seq.glo,s1)) && any(strcmp(data.inf.seq.glo,l1))
            options.obsp.glo = find(strcmp(data.inf.seq.glo,s1));
            options.obsl.glo = find(strcmp(data.inf.seq.glo,l1));
            break
        end
    end
end

if options.system.gal == 1
    prior1 = 'BCXAZ';
    for pi = 1:length(prior1)
        s1 = strcat('C1',prior1(pi));
        l1 = strcat('L1',prior1(pi));
        if any(strcmp(data.inf.seq.gal,s1))&& any(strcmp(data.inf.seq.gal,l1))
            options.obsp.gal  = find(strcmp(data.inf.seq.gal,s1));
            options.obsl.gal = find(strcmp(data.inf.seq.gal,l1));
            break
        end
    end
end

if options.system.bds == 1
    prior = 'IQXA';
    for pi = 1:length(prior)
        s1 = strcat('C2',prior(pi));
        l1 = strcat('L2',prior(pi));
        if any(strcmp(data.inf.seq.bds,s1)) && any(strcmp(data.inf.seq.bds,l1))
            options.obsp.bds = find(strcmp(data.inf.seq.bds,s1));
            options.obsl.bds = find(strcmp(data.inf.seq.bds,l1));
            break
        end
    end
end

if isempty(options.obsp.bds) || isempty(options.obsl.bds)
    for pi = 1:length(prior)
        s1 = strcat('C1',prior(pi));
        l1 = strcat('L1',prior(pi));
        if any(strcmp(data.inf.seq.bds,s1)) && any(strcmp(data.inf.seq.bds,l1))
            options.obsp.bds = find(strcmp(data.inf.seq.bds,s1));
            options.obsl.bds = find(strcmp(data.inf.seq.bds,l1));
            break
        end
    end
end

end