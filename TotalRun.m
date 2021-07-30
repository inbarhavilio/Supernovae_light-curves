zFile=fullfile('fitgui', 'MJDdata2.xlsx');
zTable=readtable(zFile);
names=zTable.Name;
MJDdays=zTable.MJD;
MJDerr=zTable.MJDerror;
zValues=zTable.z;
DaysLimit = 12;
errAdd = 0.05;
VarNames = {'SNe_name', 'R', 'E', 'M', 'R_average', 'R_error', 'E_average', 'E_error', 'M_average', 'M_error', 'MJD_average', 'MJD_error'};
dataTable = table('Size', [10,12], 'VariableTypes', {'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'}, 'VariableNames', VarNames);
for i = 2:2
    name=string(names(i));
    z=zValues(i);
    [~,dmod]=lum_dist(z,'wmap3');
    MJDstart=MJDdays(i); %starting day and error for each supernova
    MJDerror=MJDerr(i);
    [xaxisp, yaxisp, yerrp, xLimits, upperLimits]=plotValues(name, MJDstart, DaysLimit); %values of fitting for each supernova
    s=length(xaxisp);
    yerrp_alt = sqrt(yerrp.^2 + errAdd^2);
    xerrp=zeros(s,1) + MJDerror; %constant error for x axis
    if(isempty(xaxisp))
        continue;
    end
    [val,R,E,M,MJDstartDif]=generalCode2(MJDstart, dmod, xaxisp, yaxisp, yerrp_alt, toAdd, DaysLimit); %calculates the parameters values
    [~,Ravg,Eavg,Mavg,errR,errE,errM,MJDstartAvg,errMJD]=error_code_y(name,MJDstart,z,xaxisp, yaxisp, xerrp, yerrp, toAdd, DaysLimit); %calculates the parameters errors
    MJDstart = MJDstartAvg;
    t=logspace(4.5,log10((xaxisp(s)-MJDstart)*3600*24),100); %to create a smooth plot
    [~,Mnu]=analytic_lc_REM_band_smooth([R,E,M,4.568e14],t);
    dataTable(i,:) = {name, R, E, M, Ravg, errR, Eavg, errE, Mavg, errM,MJDstartAvg,errMJD}; %data to save
    dataMat = [xaxisp-MJDstart, yaxisp, xerrp, yerrp];
    figtosave=figure;
%     set(figtosave, 'Visible', 'off');
    pq_axes();
    errorxy(dataMat, 'ColX', 1, 'ColY', 2, 'ColXe', 3, 'ColYe', 4); %plot error        
    hold on;
%     scatter(xLimits-MJDstart, upperLimits, '^');
    plot(t/3600/24,Mnu+dmod); %plot curve
    set(gca,'ydir','reverse');
    title(name);
    ylabel('Observed Magnitude');
    xlabel('MJD-'+string(MJDstart));
    y_cell = cellstr(num2str(yaxisp));
    yerr_cell = cellstr(num2str(yerrp));
    b = strcat(y_cell, {"±"}, yerr_cell);
    text(xaxisp-MJDstart, yaxisp, b);
    solar = char(9737);
    txt = ['R = ' num2str(Ravg*500) 'R_',solar ', E = ' num2str(Eavg) '\cdot10^{51}erg , M = ' num2str(Mavg*15) 'M_',solar];
    a = annotation('textbox', [0.32, 0.14, 0.1, 0.1], 'string', txt, 'EdgeColor','none');   
    a.FontSize = 14;
    saveas(figtosave, name+" - wrong", 'jpeg');
    disp(name+", "+val);
    hold off;
end
% parametersPlot(dataTable);