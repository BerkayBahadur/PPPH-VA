function [model,data] = sfvmodel(data,options)

c = 299792458;

mopt = zeros(1,11);

mopt( 1) = options.SatClk;

if strcmp(options.RMode,'URP')
    mopt( 2) = options.SatAPC;
elseif strcmp(options.RMode,'RTS')
    mopt( 2) = 0;
end

mopt( 3) = options.RecAPC;

mopt( 4) = options.RecARP;

mopt( 5) = options.RelClk;

mopt( 6) = options.SatWind;

mopt( 7) = options.AtmTrop;

mopt( 9) = options.RelPath;

mopt(11) = options.Solid;

[sats] = sfvsats(data,options);
model  = zeros(sum(sats.sno),32);

if strcmp(data.inf.time.system,'GPS') || isempty(data.inf.time.system)
    dt = 51.184;
else
    dt  = 32.184 + leap;
end

r_xyz = data.inf.rec.pos;
if size(r_xyz,1)~=1
    r_xyz = r_xyz';
end

[ellp] = xyz2plh(r_xyz,0);
dlat = ellp(1);
dlon = ellp(2);
hell = ellp(3);

if (strcmp(options.TropMod,'Saastamoinen') || strcmp(options.TropMod,'Hopfield')) ...
        && strcmp(options.Meteo,'GPT2')
    grid = load('gpt2_5.mat');
elseif (strcmp(options.TropMod,'Saastamoinen') || strcmp(options.TropMod,'Hopfield'))...
        && strcmp(options.Meteo,'GPT3')
    grid = load('gpt3_5.mat');
elseif strcmp(options.TropMod,'VMF1') 
    [~,mjd] = cal2jul(data.inf.time.first(1),data.inf.time.first(2),data.inf.time.first(3),0);
    [~, zhd1,zhd2,zhd3,zhd4,zwd1,zwd2,zwd3,zwd4] = vmf1_grid (mjd,dlat,dlon,hell);
    grid = load('gpt2_5.mat');
elseif strcmp(options.TropMod,'VMF3') 
    [~,mjd] = cal2jul(data.inf.time.first(1),data.inf.time.first(2),data.inf.time.first(3),0);
    [ ~, zhd1,zhd2,zhd3,zhd4,zwd1,zwd2,zwd3,zwd4 ] = vmf3_grid (mjd,dlat,dlon,hell,5);
    grid = load('gpt3_5.mat');
end

arp = data.inf.ant.hen;
if size(arp,1)~=1
    arp = arp';
end
r_apc = data.atx.rcv;

t = 0;
year = data.inf.time.first(1); 
doy = data.inf.time.doy; 
secod = data.obs.ep;
[~,mjd_tt] = cal2jul(data.inf.time.first(1),data.inf.time.first(2),data.inf.time.first(3),...
             (secod+dt));
[~,mjd] = cal2jul(data.inf.time.first(1),data.inf.time.first(2),data.inf.time.first(3),...
             (secod)); 
sun_xyz = sun(mjd_tt); 
mon_xyz = moon(mjd_tt);

if strcmp(options.Meteo,'GPT2')
    [p,T,~,e,ah,aw,~] = gpt2(mjd,dlat,dlon,hell,1,0,grid.gpt2_5);
elseif strcmp(options.Meteo,'GPT3')
    [p,T,~,Tm,e,ah,aw,la,~,~,~,~,~] = gpt3_5_fast(mjd,dlat,dlon,hell,0,grid.gpt3_grid);
end

if strcmp(options.TropMod,'VMF1') || strcmp(options.TropMod,'VMF3')
    if secod<21600
        c_zhd=zhd1;
        c_zwd=zwd1;
    elseif secod<43200
        c_zhd=zhd2;
        c_zwd=zwd2;
    elseif secod<64800
        c_zhd=zhd3;
        c_zwd=zwd3;
    else
        c_zhd=zhd4;
        c_zwd=zwd4;
    end
end

st_ls = sats.sls;
for k = st_ls
    t = t + 1;
    model(t,1) = year;
    model(t,2) = doy;
    model(t,3) = secod;
    model(t,4) = k;
    if k<33
        kk = k;

        s_xyz = data.psat.gps(kk,1:3);
        v_xyz = data.psat.gps(kk,4:6);

        s_apc = data.atx.sat.gps(kk,:,:);

        model(t,15) = -(data.psat.gps(kk,7)*c);

        [~,w1] = gnssfreq('G',kk,1);

        azim = data.loc.gps(kk,1); 
        elev = data.loc.gps(kk,2);
        model(t,26) = elev;
        model(t,27) = azim;

        model(t,6 ) = data.obs.gps(options.obsl.gps,kk);

        sdt = -(satapc(s_xyz,r_xyz,sun_xyz,s_apc,1,k));
        if ~isnan(sdt), model(t,16) = sdt; end

        model(t,17) = recapc(s_xyz,r_xyz,r_apc,1,azim,elev);

        prev = data.wu(1,k);
        dwu = ((windup(r_xyz,s_xyz,sun_xyz,prev))/2/pi)*w1;
        model(t,20) = dwu;
        data.wu(1,k) = dwu;
    elseif k<59
        kk = k - 32;

        s_xyz = data.psat.glo(kk,1:3);
        v_xyz = data.psat.glo(kk,4:6);

        s_apc = data.atx.sat.glo(kk,:,:);

        model(t,15) = -(data.psat.glo(kk,7)*c);

        [~,w1] = gnssfreq('R',kk,1);

        azim = data.loc.glo(kk,1); 
        elev = data.loc.glo(kk,2);
        model(t,26) = elev;
        model(t,27) = azim;

        model(t,6 ) = data.obs.glo(options.obsl.glo,kk);

        sdt = -(satapc(s_xyz,r_xyz,sun_xyz,s_apc,1,k));
        if ~isnan(sdt), model(t,16) = sdt; end

        model(t,17) = recapc(s_xyz,r_xyz,r_apc,3,azim,elev);

        prev = data.wu(1,k);
        dwu = ((windup(r_xyz,s_xyz,sun_xyz,prev))/2/pi)*w1;
        model(t,20) = dwu;
        data.wu(1,k) = dwu;
    elseif k<95
        kk = k - 58;

        s_xyz = data.psat.gal(kk,1:3);
        v_xyz = data.psat.gal(kk,4:6);
        s_apc = data.atx.sat.gal(kk,:,:);

        model(t,15) = -(data.psat.gal(kk,7)*c);

        [~,w1] = gnssfreq('E',kk,1);

        azim = data.loc.gal(kk,1); 
        elev = data.loc.gal(kk,2);
        model(t,26) = elev;
        model(t,27) = azim;

        model(t,6 ) = data.obs.gal(options.obsl.gal,kk);

        sdt = -(satapc(s_xyz,r_xyz,sun_xyz,s_apc,1,k));
        if ~isnan(sdt), model(t,16) = sdt; end

        model(t,17) = recapc(s_xyz,r_xyz,r_apc,5,azim,elev);

        prev = data.wu(1,k);
        dwu = ((windup(r_xyz,s_xyz,sun_xyz,prev))/2/pi)*w1;
        model(t,20) = dwu;
        data.wu(1,k) = dwu;
    else
        kk = k - 94;

        s_xyz = data.psat.bds(kk,1:3);
        v_xyz = data.psat.bds(kk,4:6);
        s_apc = data.atx.sat.bds(kk,:,:);

        model(t,15) = -(data.psat.bds(kk,7)*c);

        [~,w1] = gnssfreq('C',kk,2);

        azim = data.loc.bds(kk,1); 
        elev = data.loc.bds(kk,2);
        model(t,26) = elev;
        model(t,27) = azim;

        model(t,6 ) = data.obs.bds(options.obsl.bds,kk);

        sdt = -(satapc(s_xyz,r_xyz,sun_xyz,s_apc,2,k));
        if ~isnan(sdt), model(t,16) = sdt; end

        model(t,17) = recapc(s_xyz,r_xyz,r_apc,7,azim,elev);

        prev = data.wu(1,k);
        dwu = ((windup(r_xyz,s_xyz,sun_xyz,prev))/2/pi)*w1;
        model(t,20) = dwu;
        data.wu(1,k) = dwu;
    end
        
    model(t,14)    = norm(s_xyz - r_xyz);
    model(t,8:10)  = s_xyz;
    model(t,11:13) = v_xyz;
    model(t,18)    = recarp(s_xyz,r_xyz,arp);
    model(t,19)    = -(relclk(s_xyz,v_xyz));
    if strcmp(options.TropMod,'Saastamoinen') && strcmp(options.Meteo,'GPT3')
        [Trop,Mwet,Mn,Me,ZHD,ZWD] = TropSaast(options,r_xyz,s_xyz,mjd,p,ah,aw,Tm,e,la);
    elseif strcmp(options.TropMod,'Saastamoinen') && strcmp(options.Meteo,'MetFile')
        [Trop,Mwet,Mn,Me,ZHD,ZWD] = TropSaast(options,r_xyz,s_xyz,mjd,p);
    elseif strcmp(options.TropMod,'Saastamoinen')
        [Trop,Mwet,Mn,Me,ZHD,ZWD] = TropSaast(options,r_xyz,s_xyz,mjd,p,ah,aw);
    elseif strcmp(options.TropMod,'Hopfield') && strcmp(options.Meteo,'MetFile')
        [Trop,Mwet,Mn,Me,ZHD,ZWD] = TropHopf(options,r_xyz,s_xyz,mjd,p,0,0,0,T);    
    elseif strcmp(options.TropMod,'Hopfield')
        [Trop,Mwet,Mn,Me,ZHD,ZWD] = TropHopf(options,r_xyz,s_xyz,mjd,p,ah,aw,e,T);
    elseif strcmp(options.TropMod,'VMF1') || strcmp(options.TropMod,'VMF3')
        [Trop,Mwet,Mn,Me,ZHD,ZWD] = TropVMFgrid(options,r_xyz,s_xyz,mjd,ah,aw,c_zhd,c_zwd);
    end
    model(t,21) = Trop;
    model(t,28) = Mwet;
    model(t,29) = Mn;
    model(t,30) = Me;
    model(t,31) = ZHD;
    model(t,32) = ZWD;
    model(t,23) = rpath(r_xyz,s_xyz);
    model(t,25) = solid(r_xyz,s_xyz,sun_xyz,mon_xyz);
    full = model(t,15:25);
    if ~any(isnan(full))
        model(t,7) = sum(full(mopt==1));
    end
end

asd = find(data.wu(1,:)~=0);
for u=asd
    if ~any(st_ls==u)
        data.wu(1,u) = 0;
    end
end

end