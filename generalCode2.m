function [value,R,E,M,MJDstartDif] = generalCode2(MJDstart, dmod, xaxisp, yaxisp, yerrp, toSave, DaysLimit)
[s,~]=size(yaxisp);
valTot=1000000;
tries = [-5:0.5:5];
chosen = 1;
for i=1:length(tries)
    MJDstartDif = MJDstart+tries(i);
    if (xaxisp(1)-MJDstartDif <= 0.01)
        break;
    end
    if (xaxisp(s)-MJDstartDif >= DaysLimit)
        continue;
    end
    arr = xaxisp-MJDstartDif;
    a = toSave(int32(arr.*100),:,:,:)+dmod;
    b=repmat(yaxisp,1,30,30,30);
    sq=(((a-b).^2)./(yerrp.^2));
    answer=sum(sq);
    [value1,indexi]=min(answer);
    [value2,indexj]=min(value1);    
    [value,indexk]=min(value2);
    if (value<valTot)
        valTot = value;
        chosen = i;
    end
end
MJDstartDif = MJDstart+tries(chosen);
arr = xaxisp-MJDstartDif;
a = toSave(int32(arr.*100),:,:,:)+dmod;
b=repmat(yaxisp,1,30,30,30);
sq=(((a-b).^2)./(yerrp.^2));
answer=sum(sq);
[value1,indexi]=min(answer);
[value2,indexj]=min(value1);
[value,indexk]=min(value2);
values=logspace(-3,1,40);
R = values(indexi(:,:,indexj(:,:,:,indexk),indexk));
E = values(indexj(:,:,:,indexk));
M = values(indexk);
return;