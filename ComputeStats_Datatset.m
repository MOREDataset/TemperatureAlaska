addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month4\daily\ERA-Interim\historical'))
clear
clc
len = 30 + 7; %30 days + 1 day
LOC = 'Nome';%'Nome'
fprintf('Location: %s\n',LOC)
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
%ctrl-F to change all instances of T2 (t2), T2, or T2 to something else
T2_temp2 = table(datetime(0,0,0),0,'VariableNames',{'Time', 'Var1'});

for i = 1979:2015
%     fprintf(' %d',i);
    eval(sprintf('file=''T2_daily_wrf_ERA-Interim_historical_%d.nc'';',i))
    % ncdisp(file)
    Ntime = length(ncread(file, 'time'));
    creation_date = ncreadatt(file,'/','reference_time');
    time = datetime(creation_date) + caldays(0:Ntime-1);

    T2 = ncread(file, 't2');
    temp = (T2(loc_r,loc_c,:));
    %concatenate all in one table
    T2_temp2(end+1:end+Ntime,:) = table(time(:), temp(:));
end
T2_temp2(1,:) = [];
T2_temp = T2_temp2;
clear T2_temp2

% Compute stats
newTable = groupsummary(T2_temp,"Time","dayofweek",["mean","std"],"Var1");%dayofweek%monthofyear%year
newTable.GroupCount = [];

MEAN_val = mean(newTable.mean_Var1);
STD_val =  mean(newTable.std_Var1);
fprintf('DAY: mean %.5f, StD %.5f\n',MEAN_val,STD_val)

% % Compute stats
% newTable = groupsummary(T2_temp,"Time","monthofyear",["mean","std"],"Var1");%dayofweek%monthofyear%year
% newTable.GroupCount = [];
% 
% MEAN_val = mean(newTable.mean_Var1);
% STD_val =  mean(newTable.std_Var1);
% fprintf('Month: mean %.5f, StD %.5f\n',MEAN_val,STD_val)
% 
% % Compute stats
% newTable = groupsummary(T2_temp,"Time","year",["mean","std"],"Var1");%dayofweek%monthofyear%year
% newTable.GroupCount = [];
% 
% MEAN_val = mean(newTable.mean_Var1);
% STD_val =  mean(newTable.std_Var1);
% fprintf('Year: mean %.5f, StD %.5f\n',MEAN_val,STD_val)
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Complexity of original T2 sequences


% fprintf('-Processing data for %d forecasting horizons!\n',len-30);
[~,T2] = T2_ForecastData_preprocessing(loc_r,loc_c,len);

I = T2(:,1:30);
valueT2 = zeros(length(I),1);
for i = 1:length(I)
    valueT2(i) = sampen(I(i,:),2,0.15,'chebychev');%chebychev, spearman, correlation,euclidean
end
fprintf('Whole T2 entropy: %.3f\n',mean(valueT2,'omitnan'))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-ADF TEST
 
[~,data] = T2_ForecastData_preprocessing(loc_r,loc_c,len);
for k = 1:height(data)
    [h(k),pValue(k),stat(k),cValue(k)] = adftest(data(k,1:30),Alpha=0.01);
end
H = mean(h,'omitnan');
PVALUE = mean(pValue,'omitnan');
STAT = mean(stat,'omitnan');
CVALUE = mean(cValue,'omitnan');
fprintf('ADF: pValue, stat, cValue: %.6f, %.6f, %.6f\n',mean(PVALUE,'omitnan'),mean(STAT,'omitnan'),mean(CVALUE,'omitnan'))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KPSS TEST

[~,data] = T2_ForecastData_preprocessing(loc_r,loc_c,len);
for k = 1:height(data)
    [h(k),pValue(k),stat(k),cValue(k)] = kpsstest(data(k,1:30),Alpha=0.01);
end
H = mean(h,'omitnan');
PVALUE = mean(pValue,'omitnan');
STAT = mean(stat,'omitnan');
CVALUE = mean(cValue,'omitnan');
fprintf('KPSS: pValue, stat, cValue: %.6f, %.6f, %.6f\n',mean(PVALUE,'omitnan'),mean(STAT,'omitnan'),mean(CVALUE,'omitnan'))
