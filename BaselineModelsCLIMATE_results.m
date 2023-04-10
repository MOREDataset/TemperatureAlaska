%% Compute performance
addpath 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3\BaselineModels'
clear
clc
%Preds
LOC = 'Bethel';%'Bethel';%'Nome';'Utqiagvik'
mdl = {'SARIMAX'};%,'SARIMAX'
for K = 1:length(mdl)
    name = 'BaselineModels_test_predsdata_T2F_';
    filename = strcat(name,mdl{K},'_',LOC,'.csv');

    opts1 = detectImportOptions(filename);
    T2 = readmatrix(filename,opts1);


    %Targets
    name = 'BaselineModels_test_targetdata_T2F';
    filename = strcat(name,LOC,'.csv');

    opts1 = detectImportOptions(filename);
    Target = readmatrix(filename,opts1);

    %Preprocess
    Target(Target==0,1) = 1;
    T2 = T2';
    Target = Target';
    if ~isequal(rem(length(T2),7),0)
        T2(end:end+rem(length(T2),7)-1) = T2(end)*ones(rem(length(T2),7),1);
        Target(end:end+rem(length(Target),7)-1) = Target(end)*ones(rem(length(Target),7),1);
    end
    clear temp_T2 temp_Target
    j=1;
    for i=1:7:length(T2)-6
        temp_T2(j,:) = T2(1,i:i+6);
        temp_Target(j,:) = Target(1,i:i+6);
        j=j+1;
    end

    T2 = temp_T2;
    Target = temp_Target;
    ymean = mean(mean((Target)));

    %Performance
    MAPE = mean(mean(abs((Target-T2)./Target)))*100;
    RMSE = sqrt(mean(mean((Target-T2).^2)));
    R2 = 1-sum((Target-T2).^2)/sum((Target-mean(Target)).^2);
    for i =1:size(Target,2)
        DirS(i) = mean((sign(Target(1:end-1,i)-Target(2:end,i))==sign(T2(1:end-1,i)-Target(2:end,i))))*100;
    end
    fprintf('Short-term-%s, %.3f,%.3f,%.3f,%.3f\n',mdl{K}, RMSE,MAPE,R2,mean(DirS))
end
%% Historical mean
% short term
clear
clc

%read and reshape
LOC = 'Nome';%'Bethel';%'Nome';'Utqiagvik'
filename = strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\T2TimeSeries_',LOC,'.csv');
opts1 = detectImportOptions(filename);
data = readtimetable(filename,opts1);
data = retime(data,"regular","fillwithmissing","TimeStep",caldays(1));
data = fillmissing(data,'constant',1);
data.Properties.VariableNames(1) = "T2";
Test_data = data(data.Time(end-round(height(data)*20/100-2)+1:end),:); %make sure start is 2013-10-21
T2 = Test_data.T2;
TS = datetime(Test_data.Time);
tempTime = TS(end);
TS_L = length(TS);
T2 = T2';
TS = TS';

if ~isequal(rem(length(T2),7),0)
    T2(end:end+rem(length(T2),7)-1) = T2(end)*ones(rem(length(T2),7),1);
    TS(end:end+rem(length(TS),7)-1) = NaT(rem(length(TS),7),1);
end
j=1;
for i=TS_L:TS_L+rem(TS_L,7)-1
    TS(i) = TS(TS_L-1)+caldays(j);
    j=j+1;
end

clear temp_T2
j=1;
for i=1:7:length(T2)-6
    temp_T2(j,:) = T2(1,i:i+6);
    temp_TS(j,:) = TS(1,i:i+6);
    j=j+1;
end
T2_resh = temp_T2;
TS_resh = temp_TS;
clear temp_T2

%whole time series
T2_all = data.T2;
TS_all = datetime(data.Time);
Test_TT = timetable(TS_all,T2_all);
TS_L = height(Test_TT);
if ~isequal(rem(length(Test_TT.T2_all),7),0)
    Test_TT.T2_all(end:end+rem(length(Test_TT.T2_all),7)-1) = Test_TT.T2_all(end)*ones(rem(length(Test_TT.T2_all),7),1);
    %     Test_TT.TS_all(end:end+rem(length(Test_TT.TS_all),7)-1) = NaT(rem(length(Test_TT.TS_all),7),1);
end
j=1;
for i=TS_L:TS_L+rem(TS_L,7)-1
    Test_TT.TS_all(i) = Test_TT.TS_all(TS_L-1)+caldays(j);
    j=j+1;
end


%LAST WEEK's MEAN
F1 = zeros(length(TS_resh),7);
for i = 1:length(TS_resh)
    %find start and end dates of sequence i
    Seq_start(i) = TS_resh(i,1);
    Seq_end(i) = TS_resh(i,end);

    %last week's
    Seq_start_MinusWeek = Seq_start(i) - calweeks(1);
    S = timerange(Seq_start_MinusWeek,Seq_start_MinusWeek + calweeks(1),'closedleft');
    F1(i,:) = Test_TT.T2_all(S)';
end

ymean = mean(mean((T2_resh)));

%Performance

MAPE = mean(mean(abs((T2_resh-F1)./T2_resh)))*100;
RMSE = sqrt(mean(mean((T2_resh-F1).^2)));
R2 = 1-sum((T2_resh-F1).^2)/sum((T2_resh-mean(T2_resh)).^2);
for i =1:size(T2_resh,2)
    DirS(i) = mean((sign(T2_resh(1:end-1,i)-T2_resh(2:end,i))==sign(F1(1:end-1,i)-T2_resh(2:end,i))))*100;
end
    fprintf('Short-term-Historical, %.3f,%.3f,%.3f,%.3f\n', RMSE,MAPE,R2,mean(DirS))
%
% %Same Week from last month's MEAN
% F2 = zeros(length(TS_resh),7);
% for i = 1:length(TS_resh)
%     %find start and end dates of sequence i
%     Seq_start(i) = TS_resh(i,1);
%     Seq_end(i) = TS_resh(i,end);
%
%     %last week's
%     Seq_start_MinusWeek = Seq_start(i) - calmonths(1);
%     S = timerange(Seq_start_MinusWeek,Seq_start_MinusWeek + calweeks(1),'closedleft');
%     F2(i,:) = Test_TT.T2_all(S)';
% end
%
% %Performance
% MAPE2 = mean(mean(abs((T2_resh-F2)./T2_resh)))*100;
% RMSE2 = sqrt(mean(mean((T2_resh-F2).^2)));
% CV2 = sqrt((1/size(T2_resh,2))*sum(mean(abs(T2_resh-F2).^2)))/ymean*100;
% fprintf('Short-term-F2, %.3f,%.3f,%.3f\n', RMSE2,MAPE2,CV2)
%
% %last Week from last month's MEAN
% F3 = zeros(length(TS_resh),7);
% for i = 1:length(TS_resh)
%     %find start and end dates of sequence i
%     Seq_start(i) = TS_resh(i,1);
%     Seq_end(i) = TS_resh(i,end);
%
%     %last week's
%     Seq_start_MinusWeek = Seq_start(i) - calmonths(1) - calweeks(1);
%     S = timerange(Seq_start_MinusWeek,Seq_start_MinusWeek + calweeks(1),'closedleft');
%     F3(i,:) = Test_TT.T2_all(S)';
% end
%
% %same week from last year's MEAN
% F4 = zeros(length(TS_resh),7);
% for i = 1:length(TS_resh)
%     %find start and end dates of sequence i
%     Seq_start(i) = TS_resh(i,1);
%     Seq_end(i) = TS_resh(i,end);
%
%     %last week's
%     Seq_start_MinusWeek = Seq_start(i) - calyears(1);
%     S = timerange(Seq_start_MinusWeek,Seq_start_MinusWeek + calweeks(1),'closedleft');
%     F4(i,:) = Test_TT.T2_all(S)';
% end
%
% %same week from two years ago's MEAN
% F5 = zeros(length(TS_resh),7);
% for i = 1:length(TS_resh)
%     %find start and end dates of sequence i
%     Seq_start(i) = TS_resh(i,1);
%     Seq_end(i) = TS_resh(i,end);
%
%     %last week's
%     Seq_start_MinusWeek = Seq_start(i) - calyears(2);
%     S = timerange(Seq_start_MinusWeek,Seq_start_MinusWeek + calweeks(1),'closedleft');
%     F5(i,:) = Test_TT.T2_all(S)';
% end
%
% %same week from three years ago's MEAN
% F6 = zeros(length(TS_resh),7);
% for i = 1:length(TS_resh)
%     %find start and end dates of sequence i
%     Seq_start(i) = TS_resh(i,1);
%     Seq_end(i) = TS_resh(i,end);
%
%     %last week's
%     Seq_start_MinusWeek = Seq_start(i) - calyears(3);
%     S = timerange(Seq_start_MinusWeek,Seq_start_MinusWeek + calweeks(1),'closedleft');
%     F6(i,:) = Test_TT.T2_all(S)';
% end
%
% for i = 1:length(F1)
%     Fx(i,:) = mean([F4(i,:);F5(i,:);F6(i,:)]);
% end
