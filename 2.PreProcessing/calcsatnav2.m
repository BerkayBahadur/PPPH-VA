function [data,options] = calcsatnav2(data,options)

psat.gps = NaN(32,7);
psat.glo = NaN(26,7);
psat.gal = NaN(36,7);
psat.bds = NaN(61,7);

rec  = data.inf.rec.pos;
if size(rec,1) ~= 1
    rec = rec';
end

if options.system.gps == 1
    st_ls = find(~isnan(data.obs.gps(options.obsp.gps,:)));
    for k=st_ls

        brd = data.nav.gps(k,:);
        if any(isnan(brd(1:7)))
            continue
        end

        trc = data.obs.ep;
        tr2 = data.obs.ep + 0.001;
        obs = data.obs.gps(options.obsp.gps,k);
        [pos] = orb_cal(brd,trc,obs,rec);
        [po2] = orb_cal(brd,tr2,obs,rec);
        Vs = (po2(1:3)-pos(1:3))./0.001;
        d = horzcat(pos(1:3),Vs,pos(1,4));
        psat.gps(k,:) = d;
    end
end

if options.system.glo == 1
    st_ls = find(~isnan(data.obs.glo(options.obsp.glo,:)));
    for k=st_ls

        brd = data.nav.glo(k,:);
        if any(isnan(brd(1:7)))
            continue
        end

        trc = data.obs.ep;
        obs = data.obs.glo(options.obsp.glo,k);
        [pos] = orb_calglo(brd,trc,obs);
        d = pos;
        psat.glo(k,:) = d;
    end
end

if options.system.gal == 1
    st_ls = find(~isnan(data.obs.gal(options.obsp.gal,:)));
    for k=st_ls

        brd = data.nav.gal(k,:);
        if any(isnan(brd(1:7)))
            continue
        end

        trc = data.obs.ep;
        tr2 = data.obs.ep + 0.001;
        obs = data.obs.gal(options.obsp.gal,k);
        [pos] = orb_cal(brd,trc,obs,rec);
        [po2] = orb_cal(brd,tr2,obs,rec);
        Vs = (po2(1:3)-pos(1:3))./0.001;
        d = horzcat(pos(1:3),Vs,pos(1,4));
        psat.gal(k,:) = d;
    end
end

if options.system.bds == 1
    st_ls = find(~isnan(data.obs.bds(options.obsp.bds,:)));
    for k=st_ls

        brd = data.nav.bds(k,:);
        if any(isnan(brd(1:7)))
            continue
        end

        trc = data.obs.ep;
        tr2 = data.obs.ep + 0.001;
        obs = data.obs.bds(options.obsp.bds,k);
        [pos] = orb_cal(brd,trc,obs,rec);
        [po2] = orb_cal(brd,tr2,obs,rec);
        Vs = (po2(1:3)-pos(1:3))./0.001;
        d = horzcat(pos(1:3),Vs,pos(1,4));
        psat.bds(k,:) = d;
    end
end

data.psat = psat;
end

function [pos] = orb_cal(brd,trc,obs,rec)
c = 299792458;           
mu = 3.986005*10^14;     
we = 7.2921151467*10^-5; 
F  = (-2*sqrt(mu))/c^2;  

tt = trc - (obs./c);
dt  = tt - brd(1,39);

a = brd(1,18)^2;              
e = brd(1,16);
n = sqrt(mu/a^3) + brd(1,13); 
Mk = brd(1,14) + n*dt;        
E0 = Mk;
while 1
    Ek = Mk + e*sin(E0);
    dE = abs(Ek - E0);
    if dE<1*10^-15
        break
    else
        E0 = Ek;
    end
end

Dtr = F*brd(1,16)*brd(1,18)*sind(Ek);

cd = brd(1,8) + (brd(1,9)*dt) + (brd(1,10)*(dt^2)) + Dtr;

t = tt - cd;
tk = t - brd(1,39);           

a = brd(1,18)^2;              
e = brd(1,16);
n = sqrt(mu/a^3) + brd(1,13); 
Mk = brd(1,14) + n*tk;        
E0 = Mk;
while 1
    Ek = Mk + e*sin(E0);
    dE = abs(Ek - E0);
    if dE<1*10^-15
        break
    else
        E0 = Ek;
    end
end

Dtr = F*brd(1,16)*brd(1,18)*sind(Ek);

clk = brd(1,8) + (brd(1,9)*tk) + (brd(1,10)*(tk^2)) + Dtr;

vk = atan2((sqrt(1 - e^2)*sin(Ek)),(cos(Ek) - e));
fk = vk + brd(1,25);

cus = brd(1,17);
cuc = brd(1,15);
crs = brd(1,12);
crc = brd(1,24);
cis = brd(1,22);
cic = brd(1,20);

du = cus*sin(2*fk) + cuc*cos(2*fk);
dr = crs*sin(2*fk) + crc*cos(2*fk);
di = cis*sin(2*fk) + cic*cos(2*fk);

uk = fk + du;                
rk = a*(1 - e*cos(Ek)) + dr; 

i0 = brd(1,23);    
id = brd(1,27);    
ik = i0 + di + (id*tk);

xkd = rk*cos(uk);
ykd = rk*sin(uk);

omg0 = brd(1,21);
omgd = brd(1,26);
toe  = brd(1,19);
omg = omg0 + (omgd - we)*tk - (we*toe);

xk  = xkd*cos(omg) - ykd*cos(ik)*sin(omg);
yk  = xkd*sin(omg) + ykd*cos(ik)*cos(omg);
zk  = ykd*sin(ik);

R = [xk yk zk];

tf     = norm(R - rec)./c;
er_ang = rad2deg(tf*we);

pos    = rotation(R,er_ang,3);

pos(1,4) = clk;
end

function [pos] = orb_calglo(brd,trc,obs)

c = 299792458;

tt = trc - (obs./c);
tspan = [brd(39) tt];
y0 = [brd(11) brd(15) brd(19) brd(12) brd(16) brd(20)].*1000;
dd = [brd(13) brd(17) brd(21)].*1000;
[~,y] = ode45(@(t,y) odefun(dd,y), tspan, y0);
pos = y(end,:);
dt  = tt - brd(1,39);

clk = brd(1,8) + (brd(1,9)*dt);
pos(1,7) = clk;
end

function dydt = odefun(dd,y)

a   = 6378136;
GM  = 398600441.8*(10^6);
J02 = 1082625.75*(10^-9);
wE  = 7.2921151467*(10^-5);

r = sqrt(y(1)^2 + y(2)^2 + y(3)^2);
k1 = (-GM)/(r^3);
k2 = (-3/2)*(J02)*((GM*a^2)/(r^5));

dydt = zeros(6,1);
dydt(1) = y(4);
dydt(2) = y(5);
dydt(3) = y(6);
dydt(4) = k1*y(1) + k2*y(1)*(1-5*((y(3)^2)/(r^2))) + wE^2*y(1) + 2*wE*y(5) + dd(1);
dydt(5) = k1*y(2) + k2*y(2)*(1-5*((y(3)^2)/(r^2))) + wE^2*y(2) - 2*wE*y(4) + dd(2);
dydt(6) = k1*y(3) + k2*y(3)*(3-5*((y(3)^2)/(r^2))) + dd(3);
end