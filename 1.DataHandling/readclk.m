function [clk] = readclk(f_clock,options)

[fid,errmsg] = fopen(f_clock);
if any(errmsg)
    errordlg('Clock file can not be opened.','Clock file error');
    error   ('Clock file error');
end

tn = 86400/options.clck_int;
clk.gps = NaN(tn,32);
clk.glo = NaN(tn,26);
clk.gal = NaN(tn,36);
clk.bds = NaN(tn,36);

while ~feof(fid)
    tline = fgetl(fid);
    if strcmp(tline(1:4),'AS G')
        new = sscanf(tline(5:end),'%f',[1,10]);
        sat_no = new(1);
        if sat_no>size(clk.gps,2)
            continue
        else
            if ~isempty(new(9)) && new(9)~=999999.999999
                epoch  = (new(5)*3600 + new(6)*60 + new(7))/options.clck_int + 1;
                clk.gps(epoch,sat_no) = new(9);
            end
        end

    elseif strcmp(tline(1:4),'AS R')
        new = sscanf(tline(5:end),'%f',[1,10]);
        sat_no = new(1);
        if sat_no>size(clk.glo,2)
            continue
        else
            if ~isempty(new(9)) && new(9)~=999999.999999
                epoch  = (new(5)*3600 + new(6)*60 + new(7))/options.clck_int + 1;
                clk.glo(epoch,sat_no) = new(9);
            end
        end

    elseif strcmp(tline(1:4),'AS E')
        new = sscanf(tline(5:end),'%f',[1,10]);
        sat_no = new(1);
        if sat_no>size(clk.gal,2)
            continue
        else
            if ~isempty(new(9)) && new(9)~=999999.999999
                epoch  = (new(5)*3600 + new(6)*60 + new(7))/options.clck_int + 1;
                clk.gal(epoch,sat_no) = new(9);
            end
        end

    elseif strcmp(tline(1:4),'AS C')
        new = sscanf(tline(5:end),'%f',[1,10]);
        sat_no = new(1);
        if sat_no>size(clk.bds,2)
            continue
        else
            if ~isempty(new(9)) && new(9)~=999999.999999
                epoch  = (new(5)*3600 + new(6)*60 + new(7))/options.clck_int + 1;
                clk.bds(epoch,sat_no) = new(9);
            end
        end
    end 
end
fclose(fid);
end