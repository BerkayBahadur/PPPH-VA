function [nav] = readbrod(fname,ep)

[fid,errmsg] = fopen(fname);

if any(errmsg)
    errordlg('NAVIGATION file can not be opened !','Navigation File Error');
    error   ('NAVIGATION file can not be opened !');
end

nav.gps = NaN(32,39);
nav.glo = NaN(26,39);
nav.gal = NaN(36,39);
nav.bds = NaN(61,39);
binf     = struct;

while 1
    line = fgetl(fid);
    tag = strtrim(line(61:end));
    switch tag
        case 'ION ALPHA'
            tline = strrep(line(1:60),'D','e');
            binf.ialfa = sscanf(tline,'%e')';
        case 'ION BETA'
            tline = strrep(line(1:60),'D','e');
            binf.ibeta = sscanf(tline,'%e')';
        case 'DELTA-UTC: A0,A1,T,W'
            tline = strrep(line(1:60),'D','e');
            binf.dutc = sscanf(tline,'%e')';
        case 'LEAP SECONDS'
            binf.leap = sscanf(line(1:60),'%f');
        case 'END OF HEADER'
            break
    end
end

while ~feof(fid)
    line = fgetl(fid);
    if ~isempty(sscanf(line(1),'%c'))
        tline = strrep(line,'D','e');
        if strcmp(tline(1),'G')
            asd = sscanf(tline(2:end),'%e')';
            sno = asd(1);
            te = asd(5)*3600 + asd(6)*60 + asd(7);
            if te<=ep
                nav.gps(sno,1:10) = asd;
                nav.gps(sno,  39) = te;
                for i=1:7
                    line = fgetl(fid);
                    tline = strrep(line,'D','e');
                    s = 11 + (i-1)*4;
                    f = 10 + i*4;
                    ts = sscanf(tline,'%e')';
                    if length(ts)<4
                        nav.gps(sno,s:s+length(ts)-1) = ts;
                    else
                        nav.gps(sno,s:f) = ts;
                    end
                end
            end
        elseif strcmp(tline(1),'R')
            asd = sscanf(tline(2:end),'%e')';
            sno = asd(1);
            [~,mjd] = cal2jul(asd(2),asd(3),asd(4),0);
            [ls] = leapsec(mjd);
            te = asd(5)*3600 + asd(6)*60 + asd(7) + (ls-19);
            if te<=ep
                nav.glo(sno,1:10) = asd;
                nav.glo(sno,  39) = te;
                for i=1:3
                    line = fgetl(fid);
                    tline = strrep(line,'D','e');
                    s = 11 + (i-1)*4;
                    f = 10 + i*4;
                    ts = sscanf(tline,'%e')';
                    if length(ts)<4
                        nav.glo(sno,s:s+length(ts)-1) = ts;
                    else
                        nav.glo(sno,s:f) = ts;
                    end
                end
            end
        elseif strcmp(tline(1),'E')
            asd = sscanf(tline(2:end),'%e')';
            sno = asd(1);
            te = asd(5)*3600 + asd(6)*60 + asd(7);
            if te<=ep
                nav.gal(sno,1:10) = asd;
                nav.gal(sno,  39) = te;
                for i=1:7
                    line = fgetl(fid);
                    tline = strrep(line,'D','e');
                    s = 11 + (i-1)*4;
                    f = 10 + i*4;
                    ts = sscanf(tline,'%e')';
                    if length(ts)<4
                        nav.gal(sno,s:s+length(ts)-1) = ts;
                    else
                        nav.gal(sno,s:f) = ts;
                    end
                end
            end
        elseif strcmp(tline(1),'C')
            asd = sscanf(tline(2:end),'%e')';
            sno = asd(1);
            te = asd(5)*3600 + asd(6)*60 + asd(7) + 14;
            if te<=ep
                nav.bds(sno,1:10) = asd;
                nav.bds(sno,  39) = te;
                for i=1:7
                    line = fgetl(fid);
                    tline = strrep(line,'D','e');
                    s = 11 + (i-1)*4;
                    f = 10 + i*4;
                    ts = sscanf(tline,'%e')';
                    if length(ts)<4
                        nav.bds(sno,s:s+length(ts)-1) = ts;
                    else
                        nav.bds(sno,s:f) = ts;
                    end
                end
            end
        end
    end
end

nav.binf = binf;
nav.ep = ep;

fclose(fid);
end