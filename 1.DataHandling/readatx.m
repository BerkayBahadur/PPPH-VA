function [atx] = readatx(f_anten,inf)

[fid,errmsg] = fopen(f_anten);

if any(errmsg)
    errordlg('Antex file can not be opened.','Antex file error');
    error   ('Antex file error');
end

type = inf.ant.type;
sat_neu.gps = zeros(32,3,2);
sat_neu.glo = zeros(26,3,2);
sat_neu.gal = zeros(36,3,5);
sat_neu.bds = zeros(61,3,4);

rcv_neu = zeros(1,3,8);
rcv_nad = cell(1,8);
rcv_adp = cell(1,8);
rcv_daz = zeros(1,4);

linenum = 0;
while ~feof(fid)
    
    tline = fgetl(fid);
    linenum = linenum + 1;
    tag   = strtrim(tline(61:end));
    
    if strcmp(tag,'START OF ANTENNA')
        tline = fgetl(fid);
        linenum = linenum + 1;
        tag   = strtrim(tline(61:end));
        if strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'G')
            sat_no = sscanf(tline(22:23),'%d');
            if sat_no>size(sat_neu.gps,1)
                continue
            else
                while ~strcmp(tag,'END OF ANTENNA')
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G01')
                        frq_no = 1;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.gps(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G02')
                        frq_no = 2;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.gps(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    end
                end
            end
   
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'R')
            sat_no = sscanf(tline(22:23),'%d');
            if sat_no>size(sat_neu.glo,1) 
                continue
            else
                while ~strcmp(tag,'END OF ANTENNA')
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R01')
                        frq_no = 1;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.glo(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R02')
                        frq_no = 2;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.glo(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    end
                end
            end
 
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'E')
            sat_no = sscanf(tline(22:23),'%d');
            if sat_no>size(sat_neu.gal,1)
                continue
            else
                while ~strcmp(tag,'END OF ANTENNA')
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E01')
                        frq_no = 1;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.gal(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E05')
                        frq_no = 2;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.gal(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E06')
                        frq_no = 3;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.gal(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E07')
                        frq_no = 4;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.gal(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E08')
                        frq_no = 5;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.gal(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    end
                end
            end
  
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'C')
            sat_no = sscanf(tline(22:23),'%d');
            if sat_no>size(sat_neu.bds,1)
                continue
            else
                while ~strcmp(tag,'END OF ANTENNA')
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C01')
                        frq_no = 1;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.bds(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C02')
                        frq_no = 2;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.bds(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C06')
                        frq_no = 3;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.bds(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C07')
                        frq_no = 4;
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        tag   = strtrim(tline(61:end));
                        if strcmp(tag,'NORTH / EAST / UP')
                            sat_neu.bds(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        end
                    end
                end
            end

        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(strtrim(tline(1:20)),type)
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag   = strtrim(tline(61:end));
                if strcmp(tag,'DAZI')
                    dazi = sscanf(tline(3:8),'%f');
                    rcv_daz(1) = dazi; 
                end
                if strcmp(tag,'ZEN1 / ZEN2 / DZEN')
                    dzen = sscanf(tline(3:20),'%f');
                    rcv_daz(2:4) = dzen';
                    nzen = (dzen(2)-dzen(1))/dzen(3) + 1;
                end
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G01')
                    frq_no = 1;
                    tline = fgetl(fid);
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G02')
                    frq_no = 2;
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R01')
                    frq_no = 3;
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R02')
                    frq_no = 4;
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E01')
                    frq_no = 5;
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E05')
                    frq_no = 6;
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C02')
                    frq_no = 7;
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C06')
                    frq_no = 8;
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        rcv_nad{:,frq_no} = sscanf(tline(9:end),'%f',[1,nzen]);
                        if dazi~=0
                            nn = 360/dazi + 1;
                            adp = NaN(nn,nzen+1);
                            for i=1:nn
                                tline = fgetl(fid);
                                linenum = linenum + 1;
                                adp(i,:) = sscanf(tline,'%f',[1,nzen+1]);
                            end
                            rcv_adp{:,frq_no} = adp;
                        end
                    end
                end
            end 
        end
    else
        continue
    end
end

atx.sat.gps = sat_neu.gps./1000;
atx.sat.glo = sat_neu.glo./1000;
atx.sat.gal = sat_neu.gal./1000;
atx.sat.bds = sat_neu.bds./1000;
atx.rcv.neu = rcv_neu./1000;
atx.rcv.nad = rcv_nad;
atx.rcv.adp = rcv_adp;
atx.rcv.daz = rcv_daz;

fclose(fid);
end