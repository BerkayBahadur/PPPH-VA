function [xk,res,sg0,sV] = sfvlsq(data,pn,sit,fi)

pmodel = data.pmodel;
model  = data.model;

xk = NaN(pn,1);
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

            sat = pmodel(k,8:10);

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
                if pmodel(k,4)<111
                    Hk(k,4) = Jdt;
                else
                    Hk(k,5) = Jdt;
                end
            elseif (sit==5) || (sit==6)         
                if pmodel(k,4)<33
                    Hk(k,4) = Jdt;
                else
                    Hk(k,5) = Jdt;
                end
            elseif sit==7                       
                if pmodel(k,4)<59
                    Hk(k,4) = Jdt;
                else
                    Hk(k,5) = Jdt;
                end
            elseif sit==8                       
                if pmodel(k,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<111
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end     
            elseif sit==9                       
                if pmodel(k,4)<59
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<111
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end 
            elseif sit==10                      
                if pmodel(k,4)<95
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<111
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end 
            elseif sit==11                      
                if pmodel(k,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<59
                    Hk(k,5) = Jdt;
                else
                    Hk(k,6) = Jdt;
                end
            elseif sit==12                      
                if pmodel(k,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<59
                    Hk(k,5) = Jdt;
                elseif pmodel(k,4)<111
                    Hk(k,6) = Jdt;
                else
                    Hk(k,7) = Jdt;
                end
            elseif sit==13                      
                if pmodel(k,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<95
                    Hk(k,5) = Jdt;
                elseif pmodel(k,4)<111
                    Hk(k,6) = Jdt;
                else
                    Hk(k,7) = Jdt;
                end
            elseif sit==14                      
                if pmodel(k,4)<59
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<95
                    Hk(k,5) = Jdt;
                elseif pmodel(k,4)<111
                    Hk(k,6) = Jdt;
                else
                    Hk(k,7) = Jdt;
                end
            elseif sit==15                      
                if pmodel(k,4)<33
                    Hk(k,4) = Jdt;
                elseif pmodel(k,4)<59
                    Hk(k,5) = Jdt;
                elseif pmodel(k,4)<95
                    Hk(k,6) = Jdt;
                elseif pmodel(k,4)<111
                    Hk(k,7) = Jdt;
                else
                    Hk(k,8) = Jdt;
                end
            end
            mp  = pmodel(pmodel(:,4)==sls(k),:);
            pl1 = mp(1,6);
            mn  = model(model(:,4)==sls(k),:);
            nl1 = mn(1,6);
            Zk(k,1) = (nl1 - pl1);    

            lc = (mn(1,7) + mn(1,14)) - (mp(1,7) + mp(1,14));
            Ck(k,1) = lc;

            elv = pmodel(k,26);
            if pmodel(k,4)<33
                co = 1;
            elseif pmodel(k,4)<59
                co = 0.25;
            elseif pmodel(k,4)<95
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
        if fi<4 || isnan(data.psV)
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