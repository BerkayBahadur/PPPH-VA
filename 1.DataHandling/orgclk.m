function [clk,inf] = orgclk(sat,options,inf,files)

switch options.clock
    case 'Sp3 File'
        n = 86400/inf.time.sp3int;
        clk.gps = reshape(sat.gps(:,4,:),[n,32,1]);
        clk.glo = reshape(sat.glo(:,4,:),[n,26,1]);
        clk.gal = reshape(sat.gal(:,4,:),[n,36,1]);
        clk.bds = reshape(sat.bds(:,4,:),[n,61,1]);
        inf.time.clkint = inf.time.sp3int;
    case 'Clock File'
        [clk] = readclk(files.clock,options);
        inf.time.clkint = options.clck_int;
end

end