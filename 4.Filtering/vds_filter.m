function [xk,res,sats,sV] = vds_filter(data,options,fi)

if strcmp(options.ProcessMode,'SFV')

    [sats] = sfvsats(data,options);

    [sit,pn,~] = gnssmode(options);

    [xk,res,~,sV] = sfvlsq(data,pn,sit,fi);

    res = res';

elseif strcmp(options.ProcessMode,'DFV')

    [sats] = dfvsats(data,options);

    [sit,pn,~] = gnssmode(options);

    [xk,res,~,sV] = dfvlsq(data,pn,sit,options,fi);

    res = res';
end
end