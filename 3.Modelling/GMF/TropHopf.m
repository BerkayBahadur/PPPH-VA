function [Trop,Mwet,Mn,Me,ZHD,ZWD_ap] = TropHopf(options,rec,sat,dmjd,p,Ah,Aw,e,T)

[ellp] = xyz2plh(rec,0);
dlat = ellp(1); 
dlon = ellp(2); 
hell = ellp(3); 

[Az,Elv] = local(rec,sat,0);

t = T + 273.1500;
earth_r = 6378137;

hd = 40136 + 148.72*(t-273.16);
Nd = 77.64*p/t;

ad = -cosd(Elv)/hd;
bd = -(sind(Elv))^2/(2*hd*earth_r);

rd = sqrt((earth_r+hd)^2-earth_r^2*(sind(Elv))^2)-earth_r*cosd(Elv);

f1d=1*rd; 
f2d=(4*ad)*rd^2/2;  
f3d=(6*ad^2+4*bd)*rd^3/3; 
f4d=(4*ad*(ad^2+3*bd))*rd^4/4;
f5d=(ad^4+12*ad^2*bd+6*bd^2)*rd^5/5;  
f6d=(4*ad*bd*(ad^2+3*bd))*rd^6/6; 
f7d=(bd^2*(6*ad^2+4*bd))*rd^7/7; 
f8d=(4*ad*bd^3)*rd^8/8; 
f9d=(bd^4)*rd^9/9;
fd = f1d+f2d+f3d+f4d+f5d+f6d+f7d+f8d+f9d;

ZHD = 10^(-6)*Nd*fd;

hw = 11000;
Nw = -12.96*e/t + 371800*e/t^2;

aw = -(cosd(Elv)/hw);
bw = -(sind(Elv)^2/(2*hw*earth_r));

rw = sqrt((earth_r+hw)^2-earth_r^2*sind(Elv)^2)-earth_r*cosd(Elv);

f1w=1*rw;  
f2w=(4*aw)*rw^2/2;   
f3w=(6*aw^2+4*bw)*rw^3/3;  
f4w=(4*aw*(aw^2+3*bw))*rw^4/4;
f5w=(aw^4+12*aw^2*bw+6*bw^2)*rw^5/5; 
f6w=(4*aw*bw*(aw^2+3*bw))*rw^6/6; 
f7w=(bw^2*(6*aw^2+4*bw))*rw^7/7;
f8w=(4*aw*bw^3)*rw^8/8;
f9w=(bw^4)*rw^9/9;
fw = f1w+f2w+f3w+f4w+f5w+f6w+f7w+f8w+f9w;

ZWD_ap = 10^(-6)*Nw*fw;


if strcmp(options.MapFunction,'GMF')
    [mfh,mfw] = gmf_f_hu(dmjd,dlat,dlon,hell,(pi/2 - Elv));
elseif strcmp(options.MapFunction,'VMF1')
    [mfh,mfw] = vmf1_ht (Ah,Aw,dmjd,dlat,hell,(pi/2 - Elv));
elseif strcmp(options.MapFunction,'VMF3')
    [mfh,mfw] = vmf3_ht (Ah,Aw,dmjd,dlat,dlon,hell,(pi/2 - Elv));
end

Trop = mfh*ZHD + mfw*ZWD_ap;
Mwet = mfw;

Mg = 1/((tan(Elv)*sin(Elv))+0.0032);
Mn = Mg*cos(Az);
Me = Mg*sin(Az);
end