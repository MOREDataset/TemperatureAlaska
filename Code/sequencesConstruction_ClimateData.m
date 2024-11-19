function sequencesConstruction_ClimateData(len, LOC, numberIMFs)
%% Construction of PCPT, Q2, Temp, and TS sequences
% numberIMFs = 31; numberIMFs = 3:3:30;
% loc_r = 262/2;
% loc_c = 262/2;
% len = 30 + 7; %30 days + 1 day
LOC = 'Utqiagvik';
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
 
% 
fprintf('-Processing data from %s for %d forecasting horizons!\n',LOC, len-30);
[~, PCPT] = PCPT_ForecastData_preprocessing(loc_r,loc_c,len);
[~, Q2]  = Q2_ForecastData_preprocessing(loc_r,loc_c,len);
[TS,T2] = T2_ForecastData_preprocessing(loc_r,loc_c,len);
S = Season_ForecastData_preprocessing(loc_r,loc_c,len);

% fprintf('-Exporting sequences!\n');
% %both Seasons
writematrix(PCPT,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\TF7d_PCPTsequences_bothSeasons',LOC,'.csv'))
writematrix(TS,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\TF7d_TSsequences_bothSeasons',LOC,'.csv'))
writematrix(Q2,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\TF7d_Q2sequences_bothSeasons',LOC,'.csv'))
writematrix(T2,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\TF7d_T2sequences_bothSeasons',LOC,'.csv'))
writematrix(S,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\TF7d_Seasonsequences_bothSeasons',LOC,'.csv'))

%% Construction of VMD sequences from T2
% numberIMFs = 15; %[31 63 127 255];
%bothSeasons
clear x
for i = 0:len
    x{i+1} = 'Element'+string(i);
end
for L = 1:length(numberIMFs)
    fprintf('*Extracting T2 VMD features using %d IMFs..\n',numberIMFs(L));
    VMD = table('Size',[length(T2)*(numberIMFs(L)+1),1+len],'VariableNames',string(x),'VariableTypes','double'+strings(1,length(x)));%,'',{'single','double','double','double','double','double','double','double','double','double','double','double','double','double'});
    VMD.Properties.VariableNames{1}='SequenceNumber';
    TEMT2=ones(length(T2)*(numberIMFs(L)+1),1+len);
    for i = 1:1:length(T2)
        [imf,res] = vmd(T2(i,:),'NumIMFs',numberIMFs(L));
        TEMT2(i+(numberIMFs(L))*(i-1):i+(numberIMFs(L))*(i-1)+(numberIMFs(L)),:) = [ones(numberIMFs(L)+1,1)*i,[imf';res']];%
    end
    VMD = array2table(TEMT2,'VariableNames',string(x));
    %compute IMFs then save into csv files
    fprintf('-Exporting VMD sequences.., ');
    writetable(VMD,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\TF7d_T2sequences_bothSeasons',LOC,'_',string(numberIMFs(L)),'IMFs.csv'))
    fprintf('finished!\n');
end

%% Construction of VMD sequences from Q2
% numberIMFs = 15; %[31 63 127 255];
%bothSeasons
clear x
for i = 0:len
    x{i+1} = 'Element'+string(i);
end
for L = 1:length(numberIMFs)
    fprintf('*Extracting Q2 VMD features using %d IMFs..\n',numberIMFs(L));
    VMD = table('Size',[length(Q2)*(numberIMFs(L)+1),1+len],'VariableNames',string(x),'VariableTypes','double'+strings(1,length(x)));%,'',{'single','double','double','double','double','double','double','double','double','double','double','double','double','double'});
    VMD.Properties.VariableNames{1}='SequenceNumber';
    TEMT2=ones(length(Q2)*(numberIMFs(L)+1),1+len);
    for i = 1:1:length(Q2)
        [imf,res] = vmd(Q2(i,:),'NumIMFs',numberIMFs(L));
        TEMT2(i+(numberIMFs(L))*(i-1):i+(numberIMFs(L))*(i-1)+(numberIMFs(L)),:) = [ones(numberIMFs(L)+1,1)*i,[imf';res']];%
    end
    VMD = array2table(TEMT2,'VariableNames',string(x));
    %compute IMFs then save into csv files
    fprintf('-Exporting VMD sequences.., ');
    writetable(VMD,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Month8\TF7d_Q2sequences_bothSeasons',LOC,'_',string(numberIMFs(L)),'IMFs.csv'))
    fprintf('finished!\n');
end
