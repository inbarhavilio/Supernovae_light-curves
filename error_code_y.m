function [val,Ravg,Eavg,Mavg,errR,errE,errM,MJDstartAvg,errMJD] = error_code_y (name,MJDstart,z,xaxisp, yaxisp, xerrp, yerrp, toSave, DaysLimit)
[s,~]=size(xaxisp);
errorRun = 100;
errSq = sqrt(errorRun);
errAdd = 0.05;
[~,dmod]=lum_dist(z,'wmap5');
Rarr=zeros(1,errorRun);
Marr=zeros(1,errorRun);
Earr=zeros(1,errorRun);
MJDstartDifArr=zeros(1,errorRun);
for i=1:errorRun
    randErr = yerrp.*randn(s,1);
    yaxisp_rand=yaxisp+randErr;
    yerrp_alt = sqrt(yerrp.^2 + errAdd^2);
    nx = 0.1*randn(); %constant random value for x error
    xerrp_rand=xerrp*nx;
    xerrp_rand = round(xerrp_rand, 2);
    xaxisp_rand=xaxisp+xerrp_rand;
    toFix = find(xaxisp_rand-MJDstart > DaysLimit);
    while(~isempty(toFix)) %checking that all the values are less than 12 days
        nx = 0.1*randn(); %constant random value for x error
        xerrp_rand=xerrp*nx;
        xerrp_rand = round(xerrp_rand, 2);
        xaxisp_rand=xaxisp+xerrp_rand;
        toFix = find(xaxisp_rand-MJDstart > DaysLimit);
    end
    [val,R,E,M,MJDstartDif]=generalCode2(MJDstart, dmod, xaxisp_rand, yaxisp_rand, yerrp_alt, toSave, DaysLimit);
    Rarr(i)=R;
    Earr(i)=E;
    Marr(i)=M;
    MJDstartDifArr(i)=MJDstartDif;
end
errR=std(Rarr)/errSq;
errM=std(Marr)/errSq;
errE=std(Earr)/errSq;
errMJD=std(MJDstartDifArr)/errSq;
Ravg=mean(Rarr);
Mavg=mean(Marr);
Eavg=mean(Earr);
MJDstartAvg=mean(MJDstartDifArr);
return;