function [xaxisp, yaxisp, yerrp, xLimits, upperLimits] = plotValues (name, MJDstart, DaysLimit)
file=fullfile('fitgui', name); %retrieving the data
T=readtable(file);
xaxis=T.Var2; %MJD
yaxis=T.Var3; %Mag
yaxis2=T.Var5; %Mag limits
yerr=T.Var4; %y error
istart = find(~isnan(yaxis), 1);
if (isempty(istart))
    xaxisp=[];
    yaxisp=[];
    yerrp=[];
    xLimits=[];
    upperLimits=[];
    return;
end
if (xaxis(istart)<MJDstart && (name == "PTF10abyy" || name == "PTF10rem"))
    disp(name+" probably has a wrong value for t0");
    while(xaxis(istart)<MJDstart)
        istart = find(~isnan(yaxis(istart+1:end)), 1) + istart;
    end
end
findLast = xaxis-MJDstart; %check this part
if (xaxis(length(xaxis))-xaxis(istart)>DaysLimit) %end index - no more than 12 days
    iend = find(findLast>DaysLimit, 1)-1;
else
    iend = length(xaxis);
end
xLimits=xaxis(1:istart-1);
upperLimits=yaxis2(1:istart-1);
yaxisp=yaxis(istart:iend); %Magnitude values for plot
yerrp=yerr(istart:iend); %Mag error values for plot
xaxisp=xaxis(istart:iend); %MJD values for plot
nanVals=find(isnan(yaxisp));
nanVals=flip(nanVals);
yaxisp(nanVals)=[];
yerrp(nanVals)=[];
xaxisp(nanVals)=[];
xaxisp = round(xaxisp, 2);
return;