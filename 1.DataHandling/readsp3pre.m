function [sat,inf] = readsp3pre(f_orbit,inf)

[fid,errmsg] = fopen(f_orbit);

if any(errmsg)
    errordlg('SP3 file can not be opened.','SP3 file error');
    error   ('SP3 file error');
end

sat.gps = NaN(96,4,32);
sat.glo = NaN(96,4,26);
sat.gal = NaN(96,4,36);
sat.bds = NaN(96,4,61);
sat.eph = NaN(96,6);

ne = 0;
while ~feof(fid)
    line = fgetl(fid);
    if strcmp(line(1),'#') && ~strcmp(line(1:2),'##')
        epno = sscanf(line(36:39),'%f');
        sat.gps = NaN(epno,4,32); 
        sat.glo = NaN(epno,4,26);
        sat.gal = NaN(epno,4,36);
        sat.bds = NaN(epno,4,61);
        sat.eph = NaN(epno,6);
    end
    
    if strcmp(line(1:2),'##')
        sp3int = sscanf(line(25:38),'%f');
        inf.time.sp3int = sp3int;
        epno2   = 86400/sp3int;
        if epno>epno2
            opt = 'Predicted';
        else
            opt = 'NotPredicted';
        end
    end
    
    if line(1)=='+'
        temp = sscanf(line(4:6),'%d');
        if ~isnan(temp)
            NoSat = temp;
        end
    end

    if line(1)=='*'
        ne = ne + 1;
        ep   = sscanf(line(2:end),'%f',[1,6]);
        sat.eph(ne,:) = ep;
        for k=1:NoSat
            line = fgetl(fid);
            if strcmp(line(2),'G')
                sno  = sscanf(line(3:4),'%d');
                if sno>size(sat.gps,3)
                    continue
                else
                    temp = sscanf(line(5:end),'%f',[1,4]);

                    sat.gps(ne,1:3,sno) = temp(1:3)*1000;
                    if ~isempty(temp(4)) && temp(4)~=999999.999999
                        sat.gps(ne,  4,sno) = temp(4)*10^-6;
                    end
                end
            elseif strcmp(line(2),'R')
                sno  = sscanf(line(3:4),'%d');
                if sno>size(sat.glo,3)
                    continue
                else
                    temp = sscanf(line(5:end),'%f',[1,4]);
                    sat.glo(ne,1:3,sno) = temp(1:3)*1000;
                    if ~isempty(temp(4)) && temp(4)~=999999.999999
                        sat.glo(ne,  4,sno) = temp(4)*10^-6;
                    end
                end
            elseif strcmp(line(2),'E')
                sno  = sscanf(line(3:4),'%d');
                if sno>size(sat.gal,3)
                    continue
                else
                    temp = sscanf(line(5:end),'%f',[1,4]);
                    sat.gal(ne,1:3,sno) = temp(1:3)*1000;
                    if ~isempty(temp(4)) && temp(4)~=999999.999999
                        sat.gal(ne,  4,sno) = temp(4)*10^-6;  
                    end
                end
            elseif strcmp(line(2),'C')
                sno  = sscanf(line(3:4),'%d');
                if sno>size(sat.bds,3)
                    continue
                else
                    temp = sscanf(line(5:end),'%f',[1,4]);
                    sat.bds(ne,1:3,sno) = temp(1:3)*1000;
                    if ~isempty(temp(4)) && temp(4)~=999999.999999
                        sat.bds(ne,  4,sno) = temp(4)*10^-6;
                    end
                end
            end        
        end        
    end
end

if strcmp(opt,'Predicted')
    aa = sat.eph(:,3)==inf.time.first(3);
    sat.gps = sat.gps(aa,:,:); 
    sat.glo = sat.glo(aa,:,:);
    sat.gal = sat.gal(aa,:,:);
    sat.bds = sat.bds(aa,:,:);
    sat.eph = sat.eph(aa,:);
end

fclose(fid);
end