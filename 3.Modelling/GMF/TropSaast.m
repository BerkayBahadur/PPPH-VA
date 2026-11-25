function [Trop,Mwet,Mn,Me,ZHD,ZWD_ap] = TropSaast(options,rec,sat,dmjd,p,ah,aw,Tm,e,la)

[ellp] = xyz2plh(rec,0);
dlat = ellp(1); 
dlon = ellp(2);
hell = ellp(3);

[Az,Elv] = local(rec,sat,0);

f = 0.0022768*p;
k = 1 - (0.00266*cos(2*dlat)) - ((0.28*10^-6)*hell);
ZHD = f/k;

if strcmp(options.Meteo,'GPT3')

    Rd = 287.0464; 
    gm = 9.80665;  
    k1 = 77.6890;  
    k2 = 71.2952;  
    k3 = 375463;

    mw = 18.0152;
    md = 28.9644;
    k2d = k2 - (k1*(mw/md));

    ZWD_ap = (10^-6)*(k2d + (k3/Tm))*((Rd*e)/(gm*(la+1)));% meter
else
    ZWD_ap = 0;
end

if strcmp(options.MapFunction,'GMF')
    [mfh,mfw] = gmf_f_hu(dmjd,dlat,dlon,hell,(pi/2 - Elv));
elseif strcmp(options.MapFunction,'VMF1')
    [mfh,mfw] = vmf1_ht (ah,aw,dmjd,dlat,hell,(pi/2 - Elv));
elseif strcmp(options.MapFunction,'VMF3')
    [mfh,mfw] = vmf3_ht (ah,aw,dmjd,dlat,dlon,hell,(pi/2 - Elv));
end

Trop = mfh*ZHD + mfw*ZWD_ap;
Mwet = mfw;

Mg = 1/((tan(Elv)*sin(Elv))+0.0032);
Mn = Mg*cos(Az);
Me = Mg*sin(Az);
end