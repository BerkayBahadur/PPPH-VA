function [model,data] = vds_model(data,options,fi)

if strcmp(options.ProcessMode,'SFV')
    if fi==0
        data.wu = zeros(1,size(data.obs.st,2));
    end
    [model,data] = sfvmodel(data,options);
elseif strcmp(options.ProcessMode,'DFV')
    if fi==0
        data.wu = zeros(2,size(data.obs.st,2));
    end
    [model,data] = dfvmodel(data,options);
end

end