function [] = vdsowrite(xs,Option,filename,data,eps)

year = data.inf.time.first(1);
doy  = data.inf.time.doy;

dat = xs;
ref = data.inf.rec.pos;
[no,ea,up,~] = vds_eval(xs,ref);

name = {'Year','DOY','SOD','dX (m)','dY (m)','dZ (m)', 'dN (m)', 'dE (m)', 'dU (m)'};
format1 = '%4s %3s %5s %8s %8s %8s %8s %8s %8s';
format2 = '%4d %3d %5d %8.5f %8.5f %8.5f %8.5f %8.5f %8.5f';

n = 0;
if Option.system.gps==1
    nn = size(name,2);
    name{nn+1} = '(DTG)';
    
    format1 = [format1,' %8s'];
    format2 = [format2,' %8.5f'];
    
    n = n + 1;
end

if Option.system.glo==1
    nn = size(name,2);
    name{nn+1} = '(DTR)';
    
    format1 = [format1,' %8s'];
    format2 = [format2,' %8.5f'];
    
    n = n + 1;
end

if Option.system.gal==1
    nn = size(name,2);
    name{nn+1} = '(DTE)';
    
    format1 = [format1,' %8s'];
    format2 = [format2,' %8.5f'];
    
    n = n + 1;
end

if Option.system.bds==1
    nn = size(name,2);
    name{nn+1} = '(DTB2)';
    
    format1 = [format1,' %8s'];
    format2 = [format2,' %8.5f'];
    
    nn = size(name,2);
    name{nn+1} = '(DTB3)';
    
    format1 = [format1,' %8s'];
    format2 = [format2,' %8.5f'];
    
    n = n + 2;
end

fid = fopen(filename,'wt');

fprintf(fid,[format1,'\n'],name{:});

for i=1:size(dat,1)
    
    fprintf(fid,[format2,'\n'],year,doy,eps(i,1),...
        dat(i,1:3),[no(i),ea(i),up(i)], dat(i,4:n+3));
end

end