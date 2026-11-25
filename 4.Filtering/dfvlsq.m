function [xk,res,sg0,sV] = dfvlsq(data,pn,sit,options,fi)

pmodel = data.pmodel;
model  = data.model;

xk  = NaN(pn,1);
res = NaN(pn);
sg0 = NaN;
sV  = NaN;

if ~isempty(pmodel) && ~isempty(model)

    while ~isequal(unique(pmodel(:,4)),unique(model(:,4)))
        sp = unique(pmodel(:,4)); sm = unique(model(:,4));
        if length(sp)>length(sm)
            del = setdiff(sp,sm);
            for i=1:length(del)
                dd = del(i);
                pmodel(pmodel(:,4)==dd,:) = [];
            end
        else
            del = setdiff(sm,sp);
            for i=1:length(del)
                dd=del(i);
                model(model(:,4)==dd,:) = [];
            end
        end
        
    end
    sls = unique(pmodel(:,4));
    mno = size(sls, 1);
    Hk  = zeros(mno,pn);
    Zk  = zeros(mno, 1);
    Ck  = zeros(mno, 1); 
    Wk  = eye(mno);

    rec = data.inf.rec.pos;
    if mno>pn

        for k=1:length(sls)

            s = (2*k - 1);

            sat = pmodel(s,8:10);

            los = rec - sat; unt = los./norm(los);

            Jdx = unt(1);
            Jdy = unt(2);
            Jdz = unt(3);
            Jdt = 1;
            Hk(k,1) = Jdx;
            Hk(k,2) = Jdy;
            Hk(k,3) = Jdz;

            if (sit==1) || (sit==2) || (sit==3) 
                Hk(k,4) = Jdt;
            elseif sit==4                       
                if pmodel(s,4)<111
                    Hk(k,4) = Jdt;
                else
                    Hk(k,5) = Jdt;
                end
            elseif (sit==5) || (sit==6)         
                if pmodel(s,4)<33
                    Hk(k,4) = Jdt;
                else
                    Hk(k,5) = Jdt;
                end
            elseif sit==7                       
                if pmodel(s,4)<59
                    Hk(k,4) = Jdt;
                else
                    Hk(k,5) = Jdt;
                end
            elseif sit==8                       
                if pmodel(s,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<111
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end     
            elseif sit==9                       
                if pmodel(s,4)<59
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<111
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end 
            elseif sit==10                      
                if pmodel(s,4)<95
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<111
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end 
            elseif sit==11                      
                if pmodel(s,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<59
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end
            elseif sit==12                      
                if pmodel(s,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<59
                    Hk(k,5) = Jdt;
                elseif pmodel(s,4)<111
                    Hk(k,6) = Jdt;
                else
                    Hk(k,7) = Jdt;
                end
            elseif sit==13                      
                if pmodel(s,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<95
                    Hk(k,5) = Jdt;
                elseif pmodel(s,4)<111
                    Hk(k,6) = Jdt;
                else
                    Hk(k,7) = Jdt;
                end
            elseif sit==14                      
                if pmodel(s,4)<59
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<95
                    Hk(k,5) = Jdt;
                elseif pmodel(s,4)<111
                    Hk(k,6) = Jdt;
                else
                    Hk(k,7) = Jdt;
                end
            elseif sit==15                      
                if pmodel(s,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(s,4)<59
                    Hk(k,5) = Jdt;
                elseif pmodel(s,4)<95
                    Hk(k,6) = Jdt;
                elseif pmodel(s,4)<111
                    Hk(k,7) = Jdt;
                else
                    Hk(k,8) = Jdt;
                end
            end

            if pmodel(s,4)<33
                kk = pmodel(s,4);
                [f1,~] = gnssfreq('G',kk,options.fs.gps(1));
                [f2,~] = gnssfreq('G',kk,options.fs.gps(2));
            elseif pmodel(s,4)<59
                kk = pmodel(s,4) - 32;
                [f1,~] = gnssfreq('R',kk,options.fs.glo(1));
                [f2,~] = gnssfreq('R',kk,options.fs.glo(2));
            elseif pmodel(s,4)<95
                kk = pmodel(s,4) - 56;
                [f1,~] = gnssfreq('E',kk,options.fs.gal(1));
                [f2,~] = gnssfreq('E',kk,options.fs.gal(2));
            else
                kk = pmodel(s,4) - 94;
                [f1,~] = gnssfreq('C',kk,options.fs.bds(1));
                [f2,~] = gnssfreq('C',kk,options.fs.bds(2));
            end
            mp  = pmodel(pmodel(:,4)==sls(k),:);
            pl1 = mp(1,6); pl2 = mp(2,6);
            mn  = model(model(:,4)==sls(k),:);
            nl1 = mn(1,6); nl2 = mn(2,6);
            co1 = (f1^2)/(f1^2 - f2^2); co2 = -(f2^2)/(f1^2 - f2^2);
            Zk(k,1) = co1*(nl1 - pl1) + co2*(nl2 - pl2); 

            c1 = (mn(1,7) + mn(1,14)) - (mp(1,7) + mp(1,14)); 
            c2 = (mn(2,7) + mn(2,14)) - (mp(2,7) + mp(2,14));
            lc = co1*c1 + co2*c2;
            Ck(k,1) = lc;

            elv = pmodel(s,26);
            if pmodel(s,4)<33
                co = 1;
            elseif pmodel(s,4)<59
                co = 0.5;
            elseif pmodel(s,4)<95
                co = 1;
            else
                co = 1;
            end
            Wk(k,k) = co*((cosd(90-elv))^2);
        end

        if any(isnan(Zk)) || any(isnan(Ck))
            [a,~] = find(isnan(Zk));
            for b=a
                Zk(b,:) = [];
                Ck(b,:) = [];
                Hk(b,:) = [];
                sls(b)  = [];
            end
        end

        Vk   = Zk - Ck;
        if fi<4|| isnan(data.psV)
            sV = std(Vk);

                del = isoutlier(Vk);
                if any(del)
                    Vk(del,:) = [];
                    Ck(del,:) = []; 
                    Zk(del,:) = [];
                    Hk(del,:) = [];
                    Wk(del,:) = []; Wk(:,del) = [];

                    sV = std(Vk);
                end
        else
            sV = ((fi-1)/fi)*data.psV + (1/fi)*std(Vk);
            if std(Vk)>(2.5*sV)
                del = isoutlier(Vk);
                if any(del)
                    Vk(del,:) = [];
                    Ck(del,:) = []; 
                    Zk(del,:) = [];
                    Hk(del,:) = [];
                    Wk(del,:) = []; Wk(:,del) = [];
                    sV = ((fi-1)/fi)*data.psV + (1/fi)*std(Vk);
                end
            end
        end
        N1 = Hk.'*(Wk*Hk);
        N2 = Hk.'*(Wk*Vk);
        xk = pinv(N1)*N2; 
        res = Zk - (Ck + Hk*xk);
        sg0 = (res.'*(Wk*res))./(mno-pn);
    end
end

if isnan(sV)
    sV = data.psV;
end
end