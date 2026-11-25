function [inf,fid] = rnxhead(f_obs)

[fid,errmsg] = fopen(f_obs);

if any(errmsg)
    errordlg('OBSERVATION file can not be opened !','Observation File Error');
    error   ('OBSERVATION file can not be opened !');
end

inf.time.leap = [];

if size(f_obs,2)>28
    inf.time.int = str2double(f_obs(end-9:end-8));
else
    inf.time.int  = 30;
end

inf.time.last = 86400;

inf.seq.gps    = cell(1); 
inf.seq.glo    = cell(1); 
inf.seq.gal    = cell(1); 
inf.seq.bds    = cell(1); 

inf.nob.gps = 1;
inf.nob.glo = 1;
inf.nob.gal = 1;
inf.nob.bds = 1;

while 1
    tline = fgetl(fid);
    tag  = strtrim(tline(61:end));
    switch tag
        case 'RINEX VERSION / TYPE'
            if strcmp(sscanf(tline(21),'%c'),'O')
                inf.rinex.type = sscanf(tline(21),'%c');
            else
                errordlg('It is not a observation file !','Observation file error');
                error   ('It is not a observation file !');
            end
            inf.sat.system = sscanf(tline(41),'%c');
            
        case 'REC # / TYPE / VERS'
            inf.rec.number  = strtrim(tline( 1:20));
            inf.rec.type    = strtrim(tline(21:40));
            inf.rec.version = strtrim(tline(41:60));
            
        case 'ANT # / TYPE'
            inf.ant.number = strtrim(tline( 1:20));
            inf.ant.type   = strtrim(tline(21:40));
            
        case 'APPROX POSITION XYZ'
            inf.rec.pos    = sscanf(tline(1:60),'%f',[1,3]);
            
        case 'ANTENNA: DELTA H/E/N'
            inf.ant.hen = sscanf(tline(1:60),'%f',[1,3]);
            
        case 'SYS / # / OBS TYPES'
            if strcmp(tline(1),'G')
                no = sscanf(tline(5:6),'%d');
                inf.nob.gps = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                elseif no<27
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l3 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2,l3);
                end
                inf.seq.gps = cell(no,1);
                for i=1:no
                    st = (i-1)*3 + 1;
                    fn = (i)*3;
                    inf.seq.gps{i} = lst(st:fn);
                end

            elseif strcmp(tline(1),'R')
                no = sscanf(tline(5:6),'%d');
                inf.nob.glo = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                elseif no<27
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l3 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2,l3);
                end
                inf.seq.glo = cell(no,1);
                for i=1:no
                    st = (i-1)*3 + 1;
                    fn = (i)*3;
                    inf.seq.glo{i} = lst(st:fn);
                end

            elseif strcmp(tline(1),'E')
                no = sscanf(tline(5:6),'%d');
                inf.nob.gal = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                elseif no<27
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l3 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2,l3);
                end
                inf.seq.gal = cell(no,1);
                for i=1:no
                    st = (i-1)*3 + 1;
                    fn = (i)*3;
                    inf.seq.gal{i} = lst(st:fn);
                end

            elseif strcmp(tline(1),'C')
                no = sscanf(tline(5:6),'%d');
                inf.nob.bds = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                elseif no<27
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l3 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2,l3);
                end
                inf.seq.bds = cell(no,1);
                for i=1:no
                    st = (i-1)*3 + 1;
                    fn = (i)*3;
                    inf.seq.bds{i} = lst(st:fn);
                end
            end
            
        case 'INTERVAL'
            inf.time.int = sscanf(tline(1:10),'%f');
            
        case 'TIME OF FIRST OBS'
            inf.time.first  = sscanf(tline( 1:44),'%d');
            inf.time.system = sscanf(tline(45:60),'%s');
            
        case 'TIME OF LAST OBS'
            inf.time.last   = sscanf(tline( 1:44),'%d');
            
        case 'LEAP SECONDS'
            inf.time.leap = sscanf(tline(1:6),'%d');
            
        case 'END OF HEADER'
            break
    end
end

if isempty(inf.time.leap)
    [~,mjd] = cal2jul(inf.time.first(1),inf.time.first(2),inf.time.first(3),...
        (inf.time.first(4)*3600 + inf.time.first(5)*60 + inf.time.first(6)));
    
    inf.time.leap = leapsec(mjd);
    if strcmp(inf.time.system,'GPS')
        inf.time.leap = inf.time.leap - 19;
    end
end

[doy] = clcdoy(inf.time.first(1),inf.time.first(2),inf.time.first(3));
inf.time.doy = doy;
end