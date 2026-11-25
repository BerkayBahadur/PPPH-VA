function [Trop,Mwet,Mn,Me,ZHD,ZWD] = TropVMFgrid(options,rec,sat,dmjd,ah,aw,c_zhd,c_zwd)

[ellp] = xyz2plh(rec,0);
dlat = ellp(1); 
dlon = ellp(2);
hell = ellp(3);

[Az,Elv] = local(rec,sat,0);

if strcmp(options.MapFunction,'GMF')
    [mfh,mfw] = gmf_f_hu(dmjd,dlat,dlon,hell,(pi/2 - Elv));
elseif strcmp(options.MapFunction,'VMF1')
    [mfh,mfw] = vmf1_ht (ah,aw,dmjd,dlat,hell,(pi/2 - Elv));
elseif strcmp(options.MapFunction,'VMF3')
    [mfh,mfw] = vmf3_ht (ah,aw,dmjd,dlat,dlon,hell,(pi/2 - Elv));
end

ZHD  = c_zhd;
Trop = mfh*c_zhd + mfw*c_zwd;
Mwet = mfw;
ZWD = c_zwd;

Mg = 1/((tan(Elv)*sin(Elv))+0.0032);
Mn = Mg*cos(Az);
Me = Mg*sin(Az);
end