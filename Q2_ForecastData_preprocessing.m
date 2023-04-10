function [TS, Q2] = Q2_ForecastData_preprocessing(loc_r,loc_c,len)% [TS_FallWinter, TS_SpringSummer, Q2_FallWinter, Q2_SpringSummer]
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month4\daily\ERA-Interim\historical'))
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month4\daily\GFDL-CM3\historical'))
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month4\daily\NCAR-CCSM4\historical'))
% loc = 262/2;
% len = 30+7;%input and output size

% %read each file from GFDL-CM3
% % fprintf('\n*Processing temperature -2m height file: ');
% Q2_temp = table(datetime(0,0,0),0,'VariableNames',{'Time', 'Var1'});
% 
% for i = 1970:2005
% %     fprintf(' %d',i);
%     eval(sprintf('file=''q2_daily_wrf_GFDL-CM3_historical_%d.nc'';',i))
%     % ncdisp(file)
%     Ntime = length(ncread(file, 'time'));
%     creation_date = ncreadatt(file,'/','reference_time');
%     time = datetime(creation_date) + caldays(0:Ntime-1);
% 
%     q2 = ncread(file, 'q2');
%     temp = q2(loc,loc,:);
%     %concatenate all in one table
%     Q2_temp(end+1:end+Ntime,:) = table(time(:), temp(:));
% end
% Q2_temp(1,:) = [];
% clear temp creation_date file time i Ntime q2

%read each file from ERA-Interim
% fprintf('\n*Processing temperature -2m height file: ');
Q2_temp2 = table(datetime(0,0,0),0,'VariableNames',{'Time', 'Var1'});

for i = 1979:2015
%     fprintf(' %d',i);
    eval(sprintf('file=''q2_daily_wrf_ERA-Interim_historical_%d.nc'';',i))
    % ncdisp(file)
    Ntime = length(ncread(file, 'time'));
    creation_date = ncreadatt(file,'/','reference_time');
    time = datetime(creation_date) + caldays(0:Ntime-1);

    q2 = (ncread(file, 'q2'));
    temp = q2(loc_r,loc_c,:);
    %concatenate all in one table
    Q2_temp2(end+1:end+Ntime,:) = table(time(:), temp(:));
end
Q2_temp2(1,:) = [];
Q2_temp = Q2_temp2;
clear temp creation_date file time i Ntime q2
% 
% %read each file from NCAR-CCSM4
% % fprintf('\n*Processing temperature -2m height file: ');
% Q2_temp3 = table(datetime(0,0,0),0,'VariableNames',{'Time', 'Var1'});
% 
% for i = 1970:2005
% %     fprintf(' %d',i);
%     eval(sprintf('file=''q2_daily_wrf_NCAR-CCSM4_historical_%d.nc'';',i))
%     % ncdisp(file)
%     Ntime = length(ncread(file, 'time'));
%     creation_date = ncreadatt(file,'/','reference_time');
%     time = datetime(creation_date) + caldays(0:Ntime-1);
% 
%     q2 = ncread(file, 'q2');
%     temp = q2(loc,loc,:);
%     %concatenate all in one table
%     Q2_temp3(end+1:end+Ntime,:) = table(time(:), temp(:));
% end
% Q2_temp3(1,:) = [];
% clear temp creation_date file time i Ntime q2
% Q2_temp = table2timetable(Q2_temp);
% Q2_temp2 = table2timetable(Q2_temp2);
% Q2_temp3 = table2timetable(Q2_temp3);
% 
% for i = 1:height(Q2_temp)
%     if i<=height(Q2_temp2)
%         if isequal(Q2_temp.Time(i),Q2_temp2.Time(i)) && isequal(Q2_temp.Time(i),Q2_temp3.Time(i))
%             Q2_temp.Var1(i) = mean([Q2_temp.Var1(i),Q2_temp2.Var1(i),Q2_temp3.Var1(i)]);
%         else
%             if ~isequal(Q2_temp.Time(i),Q2_temp2.Time(i)) && isequal(Q2_temp.Time(i),Q2_temp3.Time(i))
%                 Q2_temp.Var1(i) = mean([Q2_temp.Var1(i),Q2_temp3.Var1(i)]);
%             end
%         end
%     else
%         if i> height(Q2_temp2) && i<=height(Q2_temp3)
%             if isequal(Q2_temp.Time(i),Q2_temp3.Time(i))
%                 Q2_temp.Var1(i) = mean([Q2_temp.Var1(i),Q2_temp3.Var1(i)]);
%             end
%         end
%     end
% end
% fprintf('\nFinito!\n')

%% Divide into two seasons of the year: 22March-21September : spring/summer | 22September-21March fall/winter
% [~, mm, dd] = ymd(Q2_temp.Time);
% %*spring summer
% mask = ismember(mm, [3:9]);
% Q2_temp_SpringSummer = table2timetable(Q2_temp(mask,:));
% infmt = 'MM/dd/yyyy';
% for i = 1970:2006
%     eval(sprintf('S = timerange(datetime(''03/01/%d'',''InputFormat'',infmt),datetime(''03/21/%d'',''InputFormat'',infmt),''closed'');',i,i));
%     Q2_temp_SpringSummer(S,:)=[];
% end
% 
% %*fall winter
% mask = ismember(mm, [9 10 11 12 1 2 3]);
% Q2_temp_FallWinter = table2timetable(Q2_temp(mask,:));
% for i = 1970:2006
%     eval(sprintf('S = timerange(datetime(''09/22/%d'',''InputFormat'',infmt),datetime(''09/30/%d'',''InputFormat'',infmt),''closed'');',i,i));
%     Q2_temp_FallWinter(S,:)=[];
% end

% % plot data to shocase difference between seasons
% plot(Q2_temp_FallWinter.Time,Q2_temp_FallWinter.Var1,'LineWidth',2,'DisplayName','Fall/Winter','Color',[0 0.663711275482716 1])
% hold on
% plot(Q2_temp_SpringSummer.Time,Q2_temp_SpringSummer.Var1,'LineWidth',2,'DisplayName','Spring/Summer','Color',[0.8500 0.3250 0.0980])
% legend1 = legend(gca,'show');
% set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',21);
% set(gca,'FontSize',21,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
% xlabel('Days of years','interpreter','latex','FontSize',21);
% ylabel('Temperature at 2m height','interpreter','latex','FontSize',21);
% mean(Q2_temp_FallWinter.Var1,'omitnan')
% mean(Q2_temp_SpringSummer.Var1,'omitnan')

%%
% fprintf('*Data splitting started..');
Q2 = zeros(length(1 : 1: length(Q2_temp.Var1)-len+1), len);
TS = NaT(length(1 : 1: length(Q2_temp.Var1)-len+1), len);

for i = 1 : 1: length(Q2_temp.Var1)-len+1
    Q2(i,1:len) = Q2_temp.Var1(i:(i + len-1))';
    TS(i,1:len) = Q2_temp.Time(i:(i + len-1))';
end
dur=TS(:,end)-TS(:,1);
% fprintf(', cleaning data..');
Q2(dur>duration((len-1)*24,0,0),:)=[];
TS(dur>duration((len-1)*24,0,0),:)=[];
[Q2,TF] = rmmissing(Q2,1);
TS = TS(~TF,:);
clear  Q2_temp 

% fprintf('Finito!\n');
% fprintf('\n*SpringSummer Data splitting started..');
% Q2_SpringSummer = zeros(length(1 : 1: length(Q2_temp_SpringSummer.Var1)-len+1), len);
% TS_SpringSummer = NaT(length(1 : 1: length(Q2_temp_SpringSummer.Var1)-len+1), len);
% 
% for i = 1 : 1: length(Q2_temp_SpringSummer.Var1)-len+1
%     Q2_SpringSummer(i,1:len) = Q2_temp_SpringSummer.Var1(i:(i + len-1))';
%     TS_SpringSummer(i,1:len) = Q2_temp_SpringSummer.Time(i:(i + len-1))';
% end
% dur=TS_SpringSummer(:,end)-TS_SpringSummer(:,1);
% fprintf(', cleaning data..');
% Q2_SpringSummer(dur>duration((len-1)*24,0,0),:)=[];
% TS_SpringSummer(dur>duration((len-1)*24,0,0),:)=[];
% [Q2_SpringSummer,TF] = rmmissing(Q2_SpringSummer,1);
% TS_SpringSummer = TS_SpringSummer(~TF,:);
% clear  Q2_temp_SpringSummer 
% 
% fprintf('Finito!\n');
% 
% fprintf('\n*FallWinter Data splitting started..');
% Q2_FallWinter = zeros(length(1 : 1: length(Q2_temp_FallWinter.Var1)-len+1), len);
% TS_FallWinter = NaT(length(1 : 1: length(Q2_temp_FallWinter.Var1)-len+1), len);
% 
% for i = 1 : 1: length(Q2_temp_FallWinter.Var1)-len+1
%     Q2_FallWinter(i,1:len) = Q2_temp_FallWinter.Var1(i:(i + len-1))';
%     TS_FallWinter(i,1:len) = Q2_temp_FallWinter.Time(i:(i + len-1))';
% end
% dur=TS_FallWinter(:,end)-TS_FallWinter(:,1);
% fprintf(', cleaning data..');
% Q2_FallWinter(dur>duration((len-1)*24,0,0),:)=[];
% TS_FallWinter(dur>duration((len-1)*24,0,0),:)=[];
% [Q2_FallWinter,TF] = rmmissing(Q2_FallWinter,1);
% TS_FallWinter = TS_FallWinter(~TF,:);
% clear  Q2_temp_FallWinter 
% 
% fprintf('Finito!\n');