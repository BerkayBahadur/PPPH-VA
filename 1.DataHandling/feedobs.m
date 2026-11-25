function [ne,obs] = feedobs(inf,tline,fid)

gobs = NaN(inf.nob.gps,32);
robs = NaN(inf.nob.glo,26);
eobs = NaN(inf.nob.gal,36);
cobs = NaN(inf.nob.bds,61);
epc  = NaN;

try
    if ~isempty(tline) && strcmp(tline(1),'>')
        nep  = sscanf(tline(3:end),'%f');
        epc = nep(4)*3600 + nep(5)*60 + nep(6); 
        for i=1:nep(8)
            tline = fgetl(fid);
            if strcmp(tline(1),'G')
                k   = sscanf(tline(2:3),'%d'); 
                if k>size(gobs,2)
                    continue
                else
                    nu  = 0;
                    for u=4:16:size(tline,2)
                        nu = nu + 1;
                        tls = sscanf(tline(u:u+13),'%f');
                        if numel(tls)>1
                            break
                        elseif ~isempty(tls)
                            if strcmp(inf.seq.gps{nu}(1),'L')
                                ff = str2double(inf.seq.gps{nu}(2));
                                [~,wavl] = gnssfreq('G',k,ff);
                                gobs(nu,k) = tls*wavl;
                            else
                                gobs(nu,k) = tls;
                            end
                        end
                    end
                end

            elseif strcmp(tline(1),'R')
                k   = sscanf(tline(2:3),'%d');
                if k>size(robs,2)
                    continue
                else
                    nu  = 0;
                    for u=4:16:size(tline,2)
                        nu = nu + 1;
                        tls = sscanf(tline(u:u+13),'%f');
                        if numel(tls)>1
                            break
                        elseif ~isempty(tls)
                            if strcmp(inf.seq.glo{nu}(1),'L')
                                ff = str2double(inf.seq.glo{nu}(2));
                                [~,wavl] = gnssfreq('R',k,ff);
                                robs(nu,k) = tls*wavl;
                            else
                                robs(nu,k) = tls;
                            end
                        end
                    end
                end

            elseif strcmp(tline(1),'E')
                k   = sscanf(tline(2:3),'%d');
                if k>size(eobs,2)
                    continue
                else
                    nu  = 0;
                    for u=4:16:size(tline,2)
                        nu = nu + 1;
                        tls = sscanf(tline(u:u+13),'%f');
                        if numel(tls)>1
                            break
                        elseif ~isempty(tls)
                            if strcmp(inf.seq.gal{nu}(1),'L')
                                ff = str2double(inf.seq.gal{nu}(2));
                                [~,wavl] = gnssfreq('E',k,ff);
                                eobs(nu,k) = tls*wavl;
                            else
                                eobs(nu,k) = tls;
                            end
                        end
                    end
                end

            elseif strcmp(tline(1),'C')
                k   = sscanf(tline(2:3),'%d');
                if k>size(cobs,2) || k<6
                    continue
                else
                    nu  = 0;
                    for u=4:16:size(tline,2)
                        nu = nu + 1;
                        tls = sscanf(tline(u:u+13),'%f');
                        if numel(tls)>1
                            break
                        elseif ~isempty(tls)
                            if strcmp(inf.seq.bds{nu}(1),'L')
                                ff = str2double(inf.seq.bds{nu}(2));
                                [~,wavl] = gnssfreq('C',k,ff);
                                cobs(nu,k) = tls*wavl;
                            else
                                cobs(nu,k) = tls;
                            end
                        end
                    end
                end
            end
        end
        ne = 1;
    else
        ne = 0;
    end
catch
    obs.gps = gobs;
    obs.glo = robs;
    obs.gal = eobs;
    obs.bds = cobs;
    obs.ep  = epc;
    ne = 0;
    return
end


obs.gps = gobs;
obs.glo = robs;
obs.gal = eobs;
obs.bds = cobs;
obs.ep  = epc;
end