function [data,options] = vds_preproces(data,options,fi)

if strcmp(options.ProcessMode,'SFV')

    [options] = sfvotype(data,options);

    if strcmp(options.RMode,'RTS')
        if options.RTC == 1
            [data] = calcsatnav(data,options);
        elseif options.RTC == 0
            [data] = calcsatnav2(data,options);
        end
    elseif strcmp(options.RMode,'URP')
        [data]    = calcsat(data,options);
    end

    [data]    = elvcut(data,options);

    [data]    = sfvsysobs(data,options);

    if options.cycleslip==1 && fi~=0
        [data]    = sfvcs(data,options);
    end
 
elseif strcmp(options.ProcessMode,'DFV')

    [options] = dfvotype(data,options);

    if strcmp(options.RMode,'RTS')
        if options.RTC == 1
            [data] = calcsatnav(data,options);
        elseif options.RTC == 0
            [data] = calcsatnav2(data,options);
        end
    elseif strcmp(options.RMode,'URP')
        [data]    = calcsat(data,options);
    end

    [data]    = elvcut(data,options);

    [data]    = dfvsysobs(data,options);

    if options.cycleslip==1 && fi~=0
        [data]    = dfvcs(data,options);
    end
end
end