function [options] = dfvotype(data,options)

options.obsp.gps  = []; options.obsl.gps  = [];
options.obsp2.gps = []; options.obsl2.gps = [];

options.obsp.glo  = []; options.obsl.glo  = [];
options.obsp2.glo = []; options.obsl2.glo = [];

options.obsp.gal  = []; options.obsl.gal  = [];
options.obsp2.gal = []; options.obsl2.gal = [];

options.obsp.bds  = []; options.obsl.bds  = [];
options.obsp2.bds = []; options.obsl2.bds = [];

options.fs.gps = NaN(1,2); options.fs.glo = NaN(1,2);
options.fs.gal = NaN(1,2); options.fs.bds = NaN(1,2);

if options.system.gps == 1
    prior = 'PWCSLXYMND';
    for pi = 1:length(prior)
        s1 = strcat('C1',prior(pi));
        l1 = strcat('L1',prior(pi));
        if any(strcmp(data.inf.seq.gps,s1)) && any(strcmp(data.inf.seq.gps,l1))
            options.obsp.gps = find(strcmp(data.inf.seq.gps,s1));
            options.obsl.gps = find(strcmp(data.inf.seq.gps,l1));
            options.fs.gps(1) = 1;
            break
        end
    end
    for pi = 1:length(prior)
        s2 = strcat('C2',prior(pi));
        l2 = strcat('L2',prior(pi));    
        if any(strcmp(data.inf.seq.gps,s2)) && any(strcmp(data.inf.seq.gps,l2))
            options.obsp2.gps = find(strcmp(data.inf.seq.gps,s2));
            options.obsl2.gps = find(strcmp(data.inf.seq.gps,l2));
            options.fs.gps(2) = 2;
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
            options.fs.glo(1) = 1;
            break
        end
    end
    for pi = 1:length(prior)
        s2 = strcat('C2',prior(pi));
        l2 = strcat('L2',prior(pi)); 
        if any(strcmp(data.inf.seq.glo,s2)) && any(strcmp(data.inf.seq.glo,l2))
            options.obsp2.glo = find(strcmp(data.inf.seq.glo,s2));
            options.obsl2.glo = find(strcmp(data.inf.seq.glo,l2));
            options.fs.glo(2) = 2;
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
            options.fs.gal(1) = 1;
            break
        end
    end
    prior5 = 'IQX';
    for pi = 1:length(prior5)
        s2 = strcat('C5',prior5(pi));
        l2 = strcat('L5',prior5(pi)); 
        if any(strcmp(data.inf.seq.gal,s2)) && any(strcmp(data.inf.seq.gal,l2))
            options.obsp2.gal = find(strcmp(data.inf.seq.gal,s2));
            options.obsl2.gal = find(strcmp(data.inf.seq.gal,l2));
            options.fs.gal(2) = 5;
            break
        end
    end

    if isempty(options.obsp2.gal) || isempty(options.obsl2.gal)
        prior7 = 'IQX';
        for pi = 1:length(prior7)
            s2 = strcat('C7',prior7(pi));
            l2 = strcat('L7',prior7(pi)); 
            if any(strcmp(data.inf.seq.gal,s2)) && any(strcmp(data.inf.seq.gal,l2))
                options.obsp2.gal = find(strcmp(data.inf.seq.gal,s2));
                options.obsl2.gal = find(strcmp(data.inf.seq.gal,l2));
                options.fs.gal(2) = 7;
                break
            end
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
            options.fs.bds(1) = 2;
            break
        end
    end

    if isempty(options.obsp.bds) || isempty(options.obsl.bds)
        for pi = 1:length(prior)
            s1 = strcat('C1',prior(pi));
            l1 = strcat('L1',prior(pi));
            if any(strcmp(data.inf.seq.bds,s1)) && any(strcmp(data.inf.seq.bds,l1))
                options.obsp.bds = find(strcmp(data.inf.seq.bds,s1));
                options.obsl.bds = find(strcmp(data.inf.seq.bds,l1));
                options.fs.bds(1) = 2;
                break
            end
        end
    end

    for pi = 1:length(prior)
        s2 = strcat('C6',prior(pi));
        l2 = strcat('L6',prior(pi));    
        if any(strcmp(data.inf.seq.bds,s2)) && any(strcmp(data.inf.seq.bds,l2))
            options.obsp2.bds = find(strcmp(data.inf.seq.bds,s2));
            options.obsl2.bds = find(strcmp(data.inf.seq.bds,l2));
            options.fs.bds(2) = 6;
            break
        end
    end

    if isempty(options.obsp2.bds) || isempty(options.obsl2.bds)
        for pi = 1:length(prior)
            s2 = strcat('C7',prior(pi));
            l2 = strcat('L7',prior(pi));    
            if any(strcmp(data.inf.seq.bds,s2)) && any(strcmp(data.inf.seq.bds,l2))
                options.obsp2.bds = find(strcmp(data.inf.seq.bds,s2));
                options.obsl2.bds = find(strcmp(data.inf.seq.bds,l2));
                options.fs.bds(2) = 7;
                break
            end
        end
    end
end

end