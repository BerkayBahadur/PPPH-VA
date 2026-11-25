function [sit,bp,sno] = gnssmode(options)

if options.system.gps == 1 && options.system.glo == 0 && options.system.gal == 0 &&...
        options.system.bds == 0
    sit =   1;
    bp  =   4;
    sno = 155;

elseif options.system.gps == 0 && options.system.glo == 1 && options.system.gal == 0 &&...
        options.system.bds == 0
    sit =   2;
    bp  =   4;
    sno = 155;

elseif options.system.gps == 0 && options.system.glo == 0 && options.system.gal == 1 &&...
        options.system.bds == 0
    sit =   3;
    bp  =   4;
    sno = 155;

elseif options.system.gps == 0 && options.system.glo == 0 && options.system.gal == 0 &&...
        options.system.bds == 1
    sit =   4;
    bp  =   5;
    sno = 155;

elseif options.system.gps == 1 && options.system.glo == 1 && options.system.gal == 0 &&...
        options.system.bds == 0
    sit =   5;
    bp  =   5;
    sno = 155;

elseif options.system.gps == 1 && options.system.glo == 0 && options.system.gal == 1 &&...
        options.system.bds == 0
    sit =   6;
    bp  =   5;
    sno = 155;

elseif options.system.gps == 0 && options.system.glo == 1 && options.system.gal == 1 &&...
        options.system.bds == 0
    sit =   7;
    bp  =   5;
    sno = 155;

elseif options.system.gps == 1 && options.system.glo == 0 && options.system.gal == 0 &&...
        options.system.bds == 1
    sit =   8;
    bp  =   6;
    sno = 155;

elseif options.system.gps == 0 && options.system.glo == 1 && options.system.gal == 0 &&...
        options.system.bds == 1
    sit =   9;
    bp  =   6;
    sno = 155;

elseif options.system.gps == 0 && options.system.glo == 0 && options.system.gal == 1 &&...
        options.system.bds == 1
    sit =  10;
    bp  =   6;
    sno = 155;

elseif options.system.gps == 1 && options.system.glo == 1 && options.system.gal == 1 &&...
        options.system.bds == 0
    sit =  11;
    bp  =   6;
    sno = 155;

elseif options.system.gps == 1 && options.system.glo == 1 && options.system.gal == 0 &&...
        options.system.bds == 1
    sit =  12;
    bp  =   7;
    sno = 155;

elseif options.system.gps == 1 && options.system.glo == 0 && options.system.gal == 1 &&...
        options.system.bds == 1
    sit =  13;
    bp  =   7;
    sno = 155;

elseif options.system.gps == 0 && options.system.glo == 1 && options.system.gal == 1 &&...
        options.system.bds == 1
    sit =  14;
    bp  =   7;
    sno = 155;

elseif options.system.gps == 1 && options.system.glo == 1 && options.system.gal == 1 &&...
        options.system.bds == 1
    sit =  15;
    bp  =   8;
    sno = 155;
end
end