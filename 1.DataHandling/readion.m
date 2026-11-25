function [ionex] = readion(fname)

[fid,errmsg] = fopen(fname);

if any(errmsg)
    error('Ionex file cannot be opened!')
end

inf.dcb.gps = NaN(32,1);
inf.dcb.glo = NaN(26,1);
inf.dcb.gal = NaN(36,1);
inf.dcb.bds = NaN(61,1);
inf.nom     = NaN;
inf.int     = 7200; 
while ~feof(fid)
    line = fgetl(fid);
    tag  = strtrim(line(61:end));
    switch tag
        case 'EPOCH OF FIRST MAP'
            inf.tof = sscanf(line(1:60),'%f');
        case 'EPOCH OF LAST MAP'
            inf.tol = sscanf(line(1:60),'%f');
        case 'INTERVAL'
            inf.int = sscanf(line(1:60),'%f');
        case '# OF MAPS IN FILE'
            inf.nom = sscanf(line(1:60),'%f');
        case 'MAPPING FUNCTION'
            inf.maf = sscanf(line(1:60),'%s');
        case 'ELEVATION CUTOFF'
            inf.cut = sscanf(line(1:60),'%f');
        case 'BASE RADIUS'
            inf.bas = sscanf(line(1:60),'%f');
        case 'HGT1 / HGT2 / DHGT'
            inf.hgt = sscanf(line(1:60),'%f');
        case 'LAT1 / LAT2 / DLAT'
            inf.lat = sscanf(line(1:60),'%f');
        case 'LON1 / LON2 / DLON'
            inf.lon = sscanf(line(1:60),'%f');
        case 'PRN / BIAS / RMS'
            if strcmp(line(4),'G')
                prn = sscanf(line(5:6),'%f');
                a = sscanf(line(7:60),'%f');
                inf.dcb.gps(prn,1) = a(1);
            elseif strcmp(line(4),'R')
                prn = sscanf(line(5:6),'%f');
                a = sscanf(line(7:60),'%f');
                inf.dcb.glo(prn,1) = a(1);
            elseif strcmp(line(4),'E')
                prn = sscanf(line(5:6),'%f');
                a = sscanf(line(7:60),'%f');
                inf.dcb.gal(prn,1) = a(1);
            elseif strcmp(line(4),'C')
                prn = sscanf(line(5:6),'%f');
                a = sscanf(line(7:60),'%f');
                inf.dcb.bds(prn,1) = a(1);
            end
        case 'END OF HEADER'
            nla = abs(inf.lat(1) - inf.lat(2))/abs(inf.lat(3)) + 1;
            nlo = abs(inf.lon(1) - inf.lon(2))/abs(inf.lon(3)) + 1;
            if isnan(inf.nom)
                [~,mjdf] = cal2jul(inf.tof(1),inf.tof(2),inf.tof(3),...
                    (inf.tof(4)*3600 + inf.tof(5)*60 + inf.tof(6)));
                [~,mjdl] = cal2jul(inf.tol(1),inf.tol(2),inf.tol(3),...
                    (inf.tol(4)*3600 + inf.tol(5)*60 + inf.tol(6)));
                nom = (mjdl - mjdf)/inf.int + 1;
                tmp = NaN(nla,nlo,nom);
                inf.eps = NaN(nom,6);
            else
                tmp = NaN(nla,nlo,inf.nom);
                inf.eps = NaN(inf.nom,6);
            end
        case 'START OF TEC MAP'
            eno = sscanf(line(1:60),'%f');
            line = fgetl(fid);
            tag  = strtrim(line(61:end));
            if strcmp(tag,'EPOCH OF CURRENT MAP')
                inf.eps(eno,:) = sscanf(line(1:60),'%f')';
            end
            for r=1:nla
                line = fgetl(fid);
                tag  = strtrim(line(61:end));
                if strcmp(tag,'LAT/LON1/LON2/DLON/H')
                    bbi = sscanf(line(1:60),'%f');
                    tno = (bbi(3)-bbi(2))/bbi(4) + 1;
                    ssd = '';
                    for s=1:ceil(tno/16)
                        line = fgetl(fid);
                        ssd = strcat(ssd,sscanf(line,'%c'));
                    end
                    tmp(r,:,eno) = sscanf(ssd,'%f')';
                end
            end
    end
end
ionex.inf = inf;
ionex.tmp = tmp;

fclose(fid);
end