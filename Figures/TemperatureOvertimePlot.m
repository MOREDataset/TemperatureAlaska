%read data
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month4\daily\ERA-Interim\historical'))

clear
locations = {'Nome', 'Bethel', 'Utqiagvik'};

figure('units','normalized','outerposition',[0 0 1 1])
t = tiledlayout(3,3,'TileSpacing','tight','Padding','tight','units','normalized','outerposition',[0 0 1 1]);


latNome = 64.5;
lonNome = -165.4;
latBethel = 60.7;
lonBethel = -161.7;
latUtqiagvik= 71.2;
lonUtqiagvik = -156.7;

labels_loc = {'Nome','Bethel','Utqiagvik'};
cmap = get(0, 'defaultaxescolororder');

nexttile
scatter([1.2 2],[5,3])

nexttile(3,[3,1])
geoscatter([latNome, latBethel, latUtqiagvik], [lonNome, lonBethel, lonUtqiagvik],256,cmap(3,:),"pentagram","filled","MarkerEdgeColor","k");
geobasemap colorterrain
set(gca,'FontSize',21,'FontName','Times','ZoomLevel',4.6128)
geolimits([48.2194,73.1554],[-180.4762,-146.2228])
dx = 0; dy = 1.4; % displacement so the text does not overlay the data points 
for i = 1:3
    eval(sprintf('text(lat%s+dx, lon%s+dy, labels_loc{i},''FontSize'',19,''Interpreter'',''latex'');',locations{i},locations{i})) 
end
%Export
exportgraphics(t,strcat('AlaskaMap.pdf'),'ContentType','image','Resolution',100)
fprintf('Finito!\n')
exportgraphics(t,strcat('AlaskaMap.pdf'),'ContentType','image','Resolution',100)
close(gcf)

figure('units','normalized','outerposition',[0 0 1 1])
t = tiledlayout(3,1,'TileSpacing','tight','Padding','tight','units','normalized','outerposition',[0 0 1 1]);

for p = 1:3
    LOC = locations{p};
    switch true
        case strcmp(LOC, 'Nome')
            loc_r = 100;
            loc_c = 125;

        case strcmp(LOC, 'Bethel')
            loc_r = 105;
            loc_c = 147;

        case strcmp(LOC, 'Utqiagvik')
            loc_r = 123;
            loc_c = 92;
    end
    T2_temp2 = table(datetime(0,0,0),0,'VariableNames',{'Time', 'Var1'});

    for i = 1979:2015
        %     fprintf(' %d',i);
        eval(sprintf('file=''t2_daily_wrf_ERA-Interim_historical_%d.nc'';',i))
        % ncdisp(file)
        Ntime = length(ncread(file, 'time'));
        creation_date = ncreadatt(file,'/','reference_time');
        time = datetime(creation_date) + caldays(0:Ntime-1);

        t2 = (ncread(file, 't2'));
        temp = t2(loc_r,loc_c,:);
        %concatenate all in one table
        T2_temp2(end+1:end+Ntime,:) = table(time(:), temp(:));
    end
    T2_temp2(1,:) = [];
    T2_temp = T2_temp2;

    newTable = groupsummary(T2_temp,"Time","dayofyear","mean");
    mean(newTable.mean_Var1) - 273.15
% 
%     newTable = groupsummary(T2_temp,"Time","dayofyear","max");
%     mean(newTable.max_Var1) - 273.15
% 
%     newTable = groupsummary(T2_temp,"Time","dayofyear","min");
%     mean(newTable.min_Var1) - 273.15

    clear temp creation_date file time i Ntime t2 T2_temp2

    % COLOR based on freezing or thawing seasons
    nexttile%(L(p),[1,2])
    ind1 = find(T2_temp.Var1<273.15);
    ind2 = find(T2_temp.Var1>=273.15);
    scatter(T2_temp.Time(ind1),T2_temp.Var1(ind1),12,'DisplayName','Below freezing point')
    hold on,
    scatter(T2_temp.Time(ind2),T2_temp.Var1(ind2),12,'DisplayName','Above freezing point')
    plot(T2_temp.Time,273.15*ones(length(T2_temp.Time),1),'LineStyle','--','LineWidth',1,'Color','k','HandleVisibility','off')
    set(gca,'FontSize',21,'TickLabelInterpreter','latex','Ylim',[220 300]);
    title(LOC,'Interpreter','latex');
    box("on")
    if p==1
        legend1 = legend(gca,'show');
        set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',21);
    end
end
xlabel(t,'Days','interpreter','latex','FontSize',21);
ylabel(t,'Temperature at 2m height ($K$)','interpreter','latex','FontSize',21);
%Export
exportgraphics(t,strcat('TemperatureOvertime_allLocations.pdf'),'ContentType','image')
fprintf('Finito!\n')
exportgraphics(t,strcat('TemperatureOvertime_allLocations.pdf'),'ContentType','image')
