function [ssr] = readssra(fname)

[fid,errmsg] = fopen(fname);

if any(errmsg)
    errordlg('SSR file can not be opened !','SSR File Error');
    error   ('SSR file can not be opened !');
end

orb.gps = NaN(32,8);
orb.glo = NaN(26,8);
orb.gal = NaN(36,8);
orb.bds = NaN(61,8);

clk.gps = NaN(32,5);
clk.glo = NaN(26,5);
clk.gal = NaN(36,5);
clk.bds = NaN(61,5);

ssr.iop = 0;

while ~feof(fid)
    line = fgetl(fid);
    if strcmp(line(1),'>')
        if strcmp(line(3:7),'ORBIT')
            tln = sscanf(line(8:35),'%e');
            eph = tln(4)*3600 + tln(5)*60 + tln(6);
            for i=1:tln(8)
                line = fgetl(fid);
                if strcmp(line(1),'G')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    orb.gps(sn,1) = eph;
                    orb.gps(sn,2:8) = ts';
                elseif strcmp(line(1),'R')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    [~,mjd] = cal2jul(tln(1),tln(2),tln(3),0);
                    [ls] = leapsec(mjd);
                    orb.glo(sn,1) = eph + (ls-19);
                    orb.glo(sn,2:8) = ts';
                elseif strcmp(line(1),'E')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    orb.gal(sn,1) = eph;
                    orb.gal(sn,2:8) = ts';
                elseif strcmp(line(1),'C')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    orb.bds(sn,1) = eph + 14;
                    orb.bds(sn,2:8) = ts';
                end
            end
        elseif strcmp(line(3:7),'CLOCK')
            tln = sscanf(line(8:35),'%e');
            eph = tln(4)*3600 + tln(5)*60 + tln(6);
            for i=1:tln(8)
                line = fgetl(fid);
                if strcmp(line(1),'G')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    clk.gps(sn,1) = eph;
                    clk.gps(sn,2:5) = ts';
                elseif strcmp(line(1),'R')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    [~,mjd] = cal2jul(tln(1),tln(2),tln(3),0);
                    [ls] = leapsec(mjd);
                    clk.glo(sn,1) = eph + (ls-19);
                    clk.glo(sn,2:5) = ts';
                elseif strcmp(line(1),'E')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    clk.gal(sn,1) = eph;
                    clk.gal(sn,2:5) = ts';
                elseif strcmp(line(1),'C')
                    sn = sscanf(line(2:3),'%e');
                    ts = sscanf(line(4:end),'%e');
                    clk.bds(sn,1) = eph + 14;
                    clk.bds(sn,2:5) = ts';
                end
            end  
        elseif strcmp(line(3:6),'VTEC')
            tln = sscanf(line(8:35),'%e');
            eph = tln(4)*3600 + tln(5)*60 + tln(6);
            line = fgetl(fid);
            tln = sscanf(line,'%e');
            N = tln(2);
            M = tln(3);
            hgt = tln(4);
            vtec = NaN(N+1,M+1,2);
            for i=1:N+1
                line = fgetl(fid);
                tln = sscanf(line,'%e');
                vtec(i,:,1) = tln';
            end
            for i=1:N+1
                line = fgetl(fid);
                tln = sscanf(line,'%e');
                vtec(i,:,2) = tln';
            end
            ion.eph  = eph;
            ion.hgt  = hgt;
            ion.vtec = vtec;
            ssr.iop = 1;
        end
    end
end

ssr.orb = orb;
ssr.clk = clk;
ssr.ion = ion;
end