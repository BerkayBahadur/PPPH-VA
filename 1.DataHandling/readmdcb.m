function [DCB] = readmdcb(fname)

DCB.gps.c1cc1w = zeros(32,1);
DCB.gps.c1wc2w = zeros(32,1);
DCB.glo.c1cc1p = zeros(26,1);
DCB.glo.c1pc2p = zeros(26,1);
DCB.gal.c1cc5q = zeros(36,1);
DCB.bds.c2ic7i = zeros(61,1);
DCB.bds.c2ic6i = zeros(61,1);

fid = fopen(fname);
while ~feof(fid)
    line = fgetl(fid);

    if strcmp(strtrim(line(1:4)),'DSB') && strcmp(line(12),'G')
        k = sscanf(line(13:14),'%d');
        if strcmp(line(26:33),'C1C  C1W')
            tm = sscanf(line(85:91),'%f');
            DCB.gps.c1cc1w(k,1) = tm*10^-9;
        end
        
        if strcmp(line(26:33),'C1W  C2W')
            tm = sscanf(line(85:91),'%f');
            DCB.gps.c1wc2w(k,1) = tm*10^-9;
        end

    elseif strcmp(strtrim(line(1:4)),'DSB') && strcmp(line(12),'R')
        k = sscanf(line(13:14),'%d');
        if strcmp(line(26:33),'C1C  C1P')
            tm = sscanf(line(85:91),'%f');
            DCB.glo.c1cc1p(k,1) = tm*10^-9;
        end
        
        if strcmp(line(26:33),'C1P  C2P')
            tm = sscanf(line(85:91),'%f');
            DCB.glo.c1pc2p(k,1) = tm*10^-9;
        end

    elseif strcmp(strtrim(line(1:4)),'DSB') && strcmp(line(12),'E')
        k = sscanf(line(13:14),'%d');
        if strcmp(line(26:33),'C1C  C5Q')
            tm = sscanf(line(85:91),'%f');
            DCB.gal.c1cc5q(k,1) = tm*10^-9;
        end

    elseif strcmp(strtrim(line(1:4)),'DSB') && strcmp(line(12),'C')
        k = sscanf(line(13:14),'%d');
        if strcmp(line(26:33),'C2I  C7I')
            tm = sscanf(line(85:91),'%f');
            DCB.bds.c2ic7i(k,1) = tm*10^-9;
        end
        if strcmp(line(26:33),'C2I  C6I')
            tm = sscanf(line(85:91),'%f');
            DCB.bds.c2ic6i(k,1) = tm*10^-9;
        end
    end
end

fclose(fid);
end