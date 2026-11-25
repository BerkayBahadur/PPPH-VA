function [xs,res,sno,eps] = vds_process(files,options)
% results
xs  = NaN(1,8);
eps = NaN(1,1);
sno = NaN(1,1);
% read the header part of observation file
[inf,fid] = rnxhead(files.rinex);
% the part for the single-frequency processes
% if strcmp(options.ProcessMode,'SFV')
%     % read ionex file
%     [ionex] = readion(files.ionex);
%     data.ionex = ionex;
%     % read DCB
%     [DCB] = readmdcb(files.dcb);
%     data.dcb = DCB;
% end
% satellite information from ultra-rapid products
if strcmp(options.RMode,'URP')
    % read the sp3 file
    [sat,inf] = readsp3pre(files.orbit,inf);
    [clk,inf] = orgclk(sat,options,inf,files);
    data.sat = sat;
    data.clk = clk;
end
% read ATX
[atx] = readatx(files.anten,inf);
% data
data.inf = inf;
data.atx = atx;
%
fi = 0;
while ~feof(fid)
    tline = fgetl(fid);
    if strcmp(tline,'END OF FILE')
        break
    else
        [ne,obs] = feedobs(inf,tline,fid);
        if ne==1
            if strcmp(options.RMode,'RTS')
                % satellite information from broadcast ephemeris and IGS-RTS
                % products
                if fi==0 || (fi~=0 && (obs.ep-nav.ep)>300)
                    while 1
                        % read real-time broadcast ephemeris
                        [nav] = readbrod(files.nav,obs.ep);
                        data.nav = nav;
                        if options.RTC==1
                            % read real-time ssr correction
                            [ssr] = readssra(files.ssr);
                            data.ssr = ssr;
                        end
                        if options.RTC==0 || (options.RTC==1 && ssr.iop == 1)
                            break
                        end
                    end
                end
            end
            % fi==1 first epoch
            if fi==0
                % observations
                data.obs = obs;
                % preprocess
                [data,options] = vds_preproces(data,options,fi);
                % model
                [model,data] = vds_model(data,options,fi);
                data.model = model;
                data.psV = NaN;
                fi = fi + 1;
            else % other epochs
                % observations
                data.pobs = data.obs;
                data.obs  = obs;
                % preprocess
                [data,options] = vds_preproces(data,options,fi);
                % model
                data.pmodel = data.model;
                [model] = vds_model(data,options,fi);
                data.model = model;
                % filter
                [xk,res,sats,sV] = vds_filter(data,options,fi);
                data.psV = sV;
                nn = size(xk,1);
                xs(fi,1:nn) = xk';
                eps(fi,1) = data.pobs.ep;
                sno(fi,1) = sats.sno;
                fi = fi + 1;
            end
         end
    end 
end
fclose('all');
end