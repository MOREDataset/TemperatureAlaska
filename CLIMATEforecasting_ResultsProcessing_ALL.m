%% Read preds and target of NO DECOMPOSITIONS
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3\EXPIII'))
clear
% clc
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'XceptionTimePlus'};%,'mWDNPlus'};,'LSTMPlus'
ind = {''};
indx = 31;
size1 = 30;
mtrcs = {'RMSE','MAPE','CV'};
units = {' ($K$)',' ($\%$)',' ($\%$)'};
cmap = get(0, 'defaultaxescolororder');
clc
for k = 1:1%length(locations)
%     fprintf(' processing results from %s...!',locations{k})
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},'_',ind{:},'_',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    eval(sprintf('%s.%s.noDecomp.Preds_%s = readtable(''%s'',opts);',season{:},mode{:},model{:},path1))

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
%     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.noDecomp.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = mean(1-sum((y_test-y_preds).^2)./sum((y_test-mean(y_test)).^2));
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,R2,mean(DirS))
    
%     %BOXPLOT 
%     eval(sprintf('metric = %s;',mtrcs{k}))
%     figure, boxplot(metric)
%     box(gca,'on');
%     set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
% %     xlabel('No decomposition - InceptionTime','interpreter','latex','FontSize',size1);
%     eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat(mtrcs{k},units{k})));
%     set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%     findobj(gca)
%     all_lines = findobj(gca,'Type','Line');
%     arrayfun( @(x) set(x,'LineStyle','-','Color','k','LineWidth',1), all_lines )
%     myboxes = findobj(gca,'Tag','Box');
%     arrayfun( @(box) patch( box.XData, box.YData, cmap(3,:), 'FaceAlpha', 0.5), myboxes(1:end))
%     outliers = findobj( 'Tag', 'Outliers' );
%     delete( outliers )
%     hold on,
%     scatter(1, metric, 64, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','k', 'MarkerFaceColor', cmap(3,:), 'MarkerFaceAlpha', 0.5 )
%     
    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    figure1 = figure('WindowState','maximized');
    t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
    scatter(tmp1,tmp2, 12, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(1,:), 'MarkerFaceAlpha', 0.5,'DisplayName','InceptionTime forecasts')
    eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    set(gca,'Xlim',[230 300],'Ylim',[230 300])
    legend1 = legend(gca,'show');
    set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
%     %then EXPORT
%     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_noDecomposition.pdf'),'ContentType','image')%
%     fprintf(' done!\n')
%     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_noDecomposition.pdf'),'ContentType','image')%,'ContentType','vector'
%     close(gcf)
end
%% Read preds and target of SINGLE DECOMPOSITIONS -WT
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
clear
clc
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'mWDNPlus'};%,''};,'InceptionTimePlus'
ind = {'InceptionTime_coif63levels'};
indx = 31;
size1 = 30;
mtrcs = {'RMSE','MAPE','CV'};
units = {' ($K$)',' ($\%$)',' ($\%$)'};
cmap = get(0, 'defaultaxescolororder');

clc
for k = 1:length(locations)
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},'_',ind{:},'_',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    eval(sprintf('%s.%s.noDecomp.Preds_%s = readtable(''%s'',opts);',season{:},mode{:},model{:},path1))

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
%     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.noDecomp.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = 1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2);
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,R2,mean(DirS))
%     
    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    figure1 = figure('WindowState','maximized');
    t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
    scatter(tmp1,tmp2, 12, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(1,:), 'MarkerFaceAlpha', 0.5,'DisplayName','WT+InceptionTime forecasts')
    eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    legend1 = legend(gca,'show');
    set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
    set(gca,'Xlim',[230 300],'Ylim',[230 300])
    %then EXPORT
    exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_WT+InceptionTime.pdf'),'ContentType','image')
    fprintf(' done!\n')
    exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_WT+InceptionTime.pdf'),'ContentType','image')
    close(gcf)
end

%% Read preds and target of SINGLE DECOMPOSITIONS -VMD
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
size1 = 30;
clc
locations = {'Utqiagvik'};%'Nome', 'Bethel',%{'Anchorage', 'Fairbanks','Juneau'}
units = {' ($K$)',' ($\%$)',' ($\%$)'};
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'InceptionTimePlus'};%,''};,'InceptionTimePlus'
ind = {'3IMFs'};%'15IMFs'
indx = 31;

for k = 1:length(locations)
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind{:},'__',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    X = readtable(path1,opts);
    col = X.Properties.VariableNames;
    for j = 2 : length(col)
        for i = 1 :length(X.(col{j}))
            eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
        end
    end
    fld = fieldnames(data);
    tempsum=0;
    for i=1:length(fld)
        eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
    end
    eval(sprintf('%s.%s.IMFs15.Preds_%s = table(tempsum);',season{:},mode{:},model{:}))
    clear data tempsum

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
    %     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.IMFs15.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = 1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2);
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,R2,mean(DirS))
    
    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    figure1 = figure('WindowState','maximized');
    t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
    scatter(tmp1,tmp2, 12, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(1,:), 'MarkerFaceAlpha', 0.5,'DisplayName','VMD+InceptionTime forecasts')
    eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    legend1 = legend(gca,'show');
    set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
    set(gca,'Xlim',[230 300],'Ylim',[230 300])
    %then EXPORT
    exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_VMD+InceptionTime.pdf'),'ContentType','image')
    fprintf(' done!\n')
    exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_VMD+InceptionTime.pdf'),'ContentType','image')
    close(gcf)
end

%% Read preds and target of PROPOSED MODEL
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
clear
clc
locations = {'Utqiagvik'};%,'Bethel','Utqiagvik'%{'Anchorage', 'Fairbanks','Juneau'}
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'mWDNPlus'};%,''};,'InceptionTimePlus'
cmap = get(0, 'defaultaxescolororder');
units = {' ($K$)',' ($\%$)',' ($\%$)'};
ind2 = {'InceptionTime_coif63levels'};
ind = {'6IMFs'};%'15IMFs'
indx = 31;
size1 = 30;

for k = 1:1%length(locations)
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind{:},'_',ind2{:},'_',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    X = readtable(path1,opts);
    col = X.Properties.VariableNames;
    for j = 2 : length(col)
        for i = 1 :length(X.(col{j}))
            eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
        end
    end
    fld = fieldnames(data);
    tempsum=0;
    for i=1:length(fld)
        eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
    end
    eval(sprintf('%s.%s.Proposed.Preds_%s = table(tempsum);',season{:},mode{:},model{:}))
    clear data tempsum

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
    %     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.Proposed.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = 1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2);
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,R2,mean(DirS))

%     %True vs Predicted scatter plot
%     tmp1 = reshape(y_test,1,[])';
%     tmp2 = reshape(y_preds,1,[])';
%     figure1 = figure('WindowState','maximized');
%     t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
%     nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
%     hold on,
%     scatter(tmp1,tmp2, 12, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(1,:), 'MarkerFaceAlpha', 0.5,'DisplayName','VMD+WT+InceptionTime forecasts')
%     eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
%     eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
%     set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%     legend1 = legend(gca,'show');
%     set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
%     set(gca,'Xlim',[230 300],'Ylim',[230 300])
%     %then EXPORT
%     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_VMD+WT+InceptionTime.pdf'),'ContentType','image')
%     fprintf(' done!\n')
%     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_VMD+WT+InceptionTime.pdf'),'ContentType','image')
%     close(gcf)
end
%% Read preds and target of all cases all in one graph per location
TempCode

%% Read preds and target of PROPOSED MODEL - EXPII
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
% clear
clc
locations = {'Nome','Bethel','Utqiagvik'};%%{'Anchorage', 'Fairbanks','Juneau'}%, 
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'mWDNPlus'};%,''};,'InceptionTimePlus'
ind2 = {'InceptionTime_coif63levels'};
ii = 51:3:51;
ind = cell(1,length(ii));
for i = 1:length(ii)
    ind{i} = strcat('IMFs', num2str(ii(i)));
end
indx = 31;

for k = 1:length(locations)
    fprintf('Processing results of %s: ',locations{k})
    for L=1:length(ind) %which IMFs group
        path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},strcat(string(rmmissing(regexp(ind{L},'\D','split'))),'IMFs'),'_',ind2{:},'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        X = readtable(path1,opts);
        col = X.Properties.VariableNames;
        for j = 2 : length(col)
            for i = 1 :length(X.(col{j}))
                eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
            end
        end
        fld = fieldnames(data);
        tempsum=0;
        for i=1:length(fld)
            eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
        end
        eval(sprintf('%s.%s.%s.Proposed.Preds_%s = table(tempsum);',locations{k},mode{:},ind{L},model{:}))
        clear data tempsum

        %Targets
        path1  = strcat('\test_targetdata_TF7d_',mode{:},'_',model{:},strcat(string(rmmissing(regexp(ind{L},'\D','split'))),'IMFs'),'_',ind2{:},'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        T = readtable(path1,opts);
        col = T.Properties.VariableNames;
        for j = 2 : length(col)
            for i = 1 :length(T.(col{j}))
                eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(T.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
            end
        end
        fld = fieldnames(data);
        tempsum=0;
        for i=1:length(fld)
            eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
        end
        eval(sprintf('%s.%s.Targets = tempsum;',locations{k},mode{:}));
        clear data tempsum X T
        fprintf('.')
    end
    fprintf('\n')
end
%% THEN COMPUTE PERFORMANCE of the PROPOSED MODEL - EXPII
load('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\ExpII_CorrectedResults.mat')
clc
ii = 3:3:42;
ind = cell(1,length(ii));
for i = 1:length(ii)
    ind{i} = strcat('IMFs', num2str(ii(i)));
end
locations = {'Nome','Bethel','Utqiagvik'};
mode = {'T2Q2'}; model = {'mWDNPlus'};
for j=1:length(locations)
    fprintf('%s:\n',locations{j});
    fprintf(' -Mode %s:\n',mode{:});
    for H=1:1%length(Horizon)
        for i=1:length(ind)
            eval(sprintf('y_test = (%s.%s.Targets);',locations{j},mode{:}))
            ymean = mean(mean(y_test));
            eval(sprintf('y_preds = table2array(%s.%s.%s.Proposed.Preds_%s);',locations{j},mode{:},ind{i},model{:}))
            Results.(locations{j}).(mode{:}).(ind{i}).MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
            Results.(locations{j}).(mode{:}).(ind{i}).RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
            Results.(locations{j}).(mode{:}).(ind{i}).R2 = (1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2))*100;
            for I =1:size(y_test,2)
                Results.(locations{j}).(mode{:}).(ind{i}).DirS(I) = mean((sign(y_test(1:end-1,I)-y_test(2:end,I))==sign(y_preds(1:end-1,I)-y_test(2:end,I))))*100;
            end
            fprintf('  **%s: %.3f,%.3f,%.4f,%.3f\n',ind{i},Results.(locations{j}).(mode{:}).(ind{i}).RMSE,Results.(locations{j}).(mode{:}).(ind{i}).MAPE,Results.(locations{j}).(mode{:}).(ind{i}).R2,mean(Results.(locations{j}).(mode{:}).(ind{i}).DirS))
        end
    end
end


%% BoxPlot of the PROPOSED MODEL - EXPII
clear
% % load('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\ExpII_results.mat')
load('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\ExpII_CorrectedResults.mat')
clc
size1 = 25;
ii = 3:3:42;
ind = cell(1,length(ii));
for i = 1:length(ii)
    ind{i} = strcat('IMFs', num2str(ii(i)));
end
locations = {'Nome', 'Bethel','Utqiagvik'};%
model = {'mWDNPlus'};
mode = {'T2Q2'};
for j=1:length(locations)
    fprintf('%s:\n',locations{j});
    fprintf(' -Mode %s:\n',mode{:});
    for H=1:1%length(Horizon)
        for i=1:length(ind)
            eval(sprintf('y_test = (%s.%s.Targets);',locations{j},mode{:}))
            ymean = mean(mean(y_test));
            eval(sprintf('y_preds = table2array(%s.%s.%s.Proposed.Preds_%s);',locations{j},mode{:},ind{i},model{:}))
            Results.(locations{j}).(mode{:}).(ind{i}).MAPE = mean((abs((y_test-y_preds)./y_test)))*100;
            Results.(locations{j}).(mode{:}).(ind{i}).RMSE = sqrt((mean((y_test-y_preds).^2)));
            Results.(locations{j}).(mode{:}).(ind{i}).R2 = (1-sum((y_test-y_preds).^2)./sum((y_test-mean(y_test)).^2))*100;
            for I =1:size(y_test,2)
                Results.(locations{j}).(mode{:}).(ind{i}).DA(I) = mean((sign(y_test(1:end-1,I)-y_test(2:end,I))==sign(y_preds(1:end-1,I)-y_test(2:end,I))))*100;
            end
        end
    end
end

mtrcs = {'RMSE','R2','MAPE','DA'};
units = {' ($K$)',' ($\%$)',' ($\%$)',' ($\%$)'};
smbls = {'v','s','o','d'};
cmap = get(0, 'defaultaxescolororder');
cmap(2,:) = [0.9290 0.6940 0.1250];	%;%0.8902    0.6471    0.0627
cmap(3,:) = [0.8500 0.3250 0.0980];

for M = 1:length(locations)
    for k=1:2:length(mtrcs)
        %BOXPLOT 1
        for i =1:length(ii)
            ind{i} = strcat('IMFs', num2str(ii(i)));
            eval(sprintf('metric(i,:) = Results.%s.T2Q2.%s.%s;',locations{M},ind{i},mtrcs{k}))
        end
        figure1 = figure('WindowState','maximized','units','normalized','outerposition',[0 0 1 1]);
        t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
        nexttile,
        yyaxis left
        boxplot(metric')
        box(gca,'on');
        set(gca,'XTickLabel',num2cell(ii),'Units','normalized')
        set(gca,'FontSize',size1,'TickLabelInterpreter','latex');
        xlabel('K','interpreter','latex','FontSize',size1);
        eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat(mtrcs{k},units{k})));
        set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
        set(gca,'Ylim',[0 max(max(metric))+0.2*max(max(metric))])

        %
        %BOXPLOT 2
        for i =1:length(ii)
            ind{i} = strcat('IMFs', num2str(ii(i)));
            eval(sprintf('metric(i,:) = Results.%s.T2Q2.%s.%s;',locations{M},ind{i},mtrcs{k+1}))
        end
        yyaxis right
        eval(sprintf('plot(mean(metric''),''Marker'',smbls{k+1},''MarkerSize'',10,''MarkerFaceColor'',''w'',''LineWidth'',2,''Parent'',gca,''DisplayName'',''%s'',''LineStyle'',''-'',''Color'',cmap(k+1,:))',mtrcs{k+1}))
        box(gca,'on');
        set(gca,'XTickLabel',num2cell(ii),'Units','normalized')
        set(gca,'FontSize',size1,'TickLabelInterpreter','latex');
        xlabel('K','interpreter','latex','FontSize',size1);
        eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat(mtrcs{k+1},units{k+1})));
        set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
        set(gca,'Ylim',[-inf 100]);
        pp = get(gca, 'Position');
        close(gcf)
        
        %
        
        figure1 = figure('WindowState','maximized','units','normalized','outerposition',[0 0 1 1]);
        set(figure1,'defaultAxesColorOrder',[cmap(k,:); cmap(k+1,:)]);
        yyaxis left
        for i =1:length(ii)
            ind{i} = strcat('IMFs', num2str(ii(i)));
            eval(sprintf('metric(i,:) = Results.%s.T2Q2.%s.%s;',locations{M},ind{i},mtrcs{k}))
        end
        boxplot(metric')
        box(gca,'on');
        set(gca,'XTickLabel',num2cell(ii),'Units','normalized','Position',pp)
        set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,
        xlabel('K','interpreter','latex','FontSize',size1);
        eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat(mtrcs{k},units{k})));
        set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
        set(gca,'Ylim',[0 max(max(metric))+0.2*max(max(metric))]);
        findobj(gca);
        all_lines = findobj(gca,'Type','Line');
        arrayfun( @(x) set(x,'LineStyle','-','Color','k','LineWidth',1), all_lines );
        myboxes = findobj(gca,'Tag','Box');
        arrayfun( @(box) patch( box.XData, box.YData, 'w', 'FaceAlpha', 0.5,'EdgeColor','k','LineWidth',1.5), myboxes(1:end));
        outliers = findobj( 'Tag', 'Outliers' );
        delete( outliers );
        hold on,
        scatter(1:size(metric,1),metric', repmat(linspace(32,128,7),[size(metric,1),1])' , 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(k,:), 'MarkerFaceAlpha', 0.5 );
        %
        for i =1:length(ii)
            ind{i} = strcat('IMFs', num2str(ii(i)));
            eval(sprintf('metric(i,:) = Results.%s.T2Q2.%s.%s;',locations{M},ind{i},mtrcs{k+1}))
        end
        yyaxis right
        eval(sprintf('plot(mean(metric''),''Marker'',smbls{k+1},''MarkerSize'',10,''MarkerFaceColor'',''w'',''LineWidth'',2,''Parent'',gca,''DisplayName'',''%s'',''LineStyle'',''-'',''Color'',cmap(k+1,:))',mtrcs{k+1}))
        box(gca,'on');
        set(gca,'XTickLabel',num2cell(ii),'Units','normalized','Position',pp)
        set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,
        xlabel('K','interpreter','latex','FontSize',size1);
        eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat(mtrcs{k+1},units{k+1})));
        set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
        set(gca,'Ylim',[-inf 100]);
        switch M
            case 1
                xregion(9.5,10.5)
            case 2
                xregion(9.5,10.5)
            case 3
                xregion(12.5,13.5)
        end
        %then EXPORT
        exportgraphics(gcf,strcat('ExpII_K_',locations{M},'_',mtrcs{k},mtrcs{k+1},'.pdf'),'ContentType','vector');
        fprintf(' done!\n')
        exportgraphics(gcf,strcat('ExpII_K_',locations{M},'_',mtrcs{k},mtrcs{k+1},'.pdf'),'ContentType','vector');
        close(gcf)
    end
end
%% Read preds and target of PROPOSED MODEL - EXPII-2
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))%\EXPII-2'))
% clear
clc
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'mWDNPlus'};%,''};,'InceptionTimePlus'
ii = 3;%2:1:4;
ind = '30IMFs';
indx = 31;

for k = 1:length(locations)
    fprintf('Processing results of %s: ',locations{k})
    for L=1:length(ii) %which IMFs group
        ind2 = strcat('InceptionTime_coif6',num2str(ii(L)),'levels');
        path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind,'_',ind2,'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        X = readtable(path1,opts);
        col = X.Properties.VariableNames;
        for j = 2 : length(col)
            for i = 1 :length(X.(col{j}))
                eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
            end
        end
        fld = fieldnames(data);
        tempsum=0;
        for i=1:length(fld)
            eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
        end
        eval(sprintf('%s.%s.%s.Proposed.Preds_%s = table(tempsum);',locations{k},mode{:},ind2,model{:}))
        clear data tempsum

        %Targets
        path1  = strcat('\test_targetdata_TF7d_',mode{:},'_',model{:},ind,'_',ind2,'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        T = readtable(path1,opts);
        col = T.Properties.VariableNames;
        for j = 2 : length(col)
            for i = 1 :length(T.(col{j}))
                eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(T.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
            end
        end
        fld = fieldnames(data);
        tempsum=0;
        for i=1:length(fld)
            eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
        end
        eval(sprintf('%s.%s.Targets = tempsum;',locations{k},mode{:}));
        clear data tempsum X T
        fprintf('.')
    end
    fprintf('\n')
end
%% Performance ExpII-2
clc
ii = 3;%2:1:4;
ind = '30IMFs';

for j=1:length(locations)
    fprintf('%s:\n',locations{j});
    fprintf(' -Mode %s:\n',mode{:});
    for H=1:1%length(Horizon)
        for i=1:length(ii)
            ind2 = strcat('InceptionTime_coif6',num2str(ii(i)),'levels');
            eval(sprintf('y_test = (%s.%s.Targets);',locations{j},mode{:}))
            ymean = mean(mean(y_test));
            eval(sprintf('y_preds = table2array(%s.%s.%s.Proposed.Preds_%s);',locations{j},mode{:},ind2,model{:}))
            Results.(locations{j}).(mode{:}).(ind2).MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
            Results.(locations{j}).(mode{:}).(ind2).RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
            Results.(locations{j}).(mode{:}).(ind2).R2 = (1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2))*100;
            for I =1:size(y_test,2)
                Results.(locations{j}).(mode{:}).(ind2).DirS(I) = mean((sign(y_test(1:end-1,I)-y_test(2:end,I))==sign(y_preds(1:end-1,I)-y_test(2:end,I))))*100;
            end
            fprintf('  **%s: %.3f,%.3f,%.4f,%.3f\n',ind2,Results.(locations{j}).(mode{:}).(ind2).RMSE,Results.(locations{j}).(mode{:}).(ind2).MAPE,Results.(locations{j}).(mode{:}).(ind2).R2,mean(Results.(locations{j}).(mode{:}).(ind2).DirS))
        end
    end
end
%% Plot error as Yaakko said
ii = 3;
ind = 'IMFs30';
locations = {'Nome', 'Bethel','Utqiagvik'};%
mode = {'T2Q2'}; model = {'mWDNPlus'};%,''};,'InceptionTimePlus'
cmap = get(0, 'defaultaxescolororder');
size1 = 25;

%Actual vs Predicted plot
figure1 = figure('WindowState','maximized');
t = tiledlayout(3,1,'TileSpacing','tight','Padding','tight');%3,4
for j=1:length(locations)
    if j == 3
        ind = 'IMFs39';
    end
    %     fprintf('%s:\n',locations{j});
    %     fprintf(' -Mode %s:\n',mode{:});
    nexttile, hold on

    for H=1:1%length(Horizon)
        for i=1:length(ii)
            ind2 = strcat('InceptionTime_coif6',num2str(ii(i)),'levels');
            eval(sprintf('y_test = (%s.%s.Targets);',locations{j},mode{:}))
%             eval(sprintf('y_preds = table2array(%s.%s.%s.Proposed.Preds_%s);',locations{j},mode{:},ind{i},model{:}))
            eval(sprintf('y_preds = table2array(%s.%s.%s.Proposed.Preds_%s);',locations{j},mode{:},ind,model{:}))
            plt = scatter(1:7,y_test-y_preds, 16, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(j,:), 'MarkerFaceAlpha', 0.8 );
            hold on,
            
            boxplot(y_test-y_preds);
            box(gca,'on');
            set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,
            set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
            maxError = max(max(y_test-y_preds));
            minError = min(min(y_test-y_preds));
            set(gca,'Ylim',[minError maxError]);
            findobj(gca);
            outliers = findobj( 'Tag', 'Outliers' );
            delete( outliers );
            hold on,

            all_lines = findobj(gca,'Type','Line');
            arrayfun( @(x) set(x,'LineStyle','-','Color','k','LineWidth',1.5), all_lines );
            myboxes = findobj(gca,'Tag','Box');
            arrayfun( @(box) patch( box.XData, box.YData, 'w', 'FaceAlpha', 0.5,'EdgeColor','k','LineWidth',1), myboxes(1:end));
            title(gca,locations{j},'FontSize',size1)
        end
    end
end
xlabel(t, 'Days','interpreter','latex','FontSize',size1);
ylabel(t, 'Errors ($K$)','interpreter','latex','FontSize',size1);
%then EXPORT
exportgraphics(t,strcat('TFErrors_allLocations.pdf'),'ContentType','image')
fprintf(' done!\n')
exportgraphics(t,strcat('TFErrors_allLocations.pdf'),'ContentType','image')
% close(gcf)

%% BENCHMARK 3 : Read preds and target of NO DECOMPOSITIONS
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3\EXPIII'))
clear
clc
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'TSTPlus','XCMPlus','LSTMPlus','GRUPlus','MiniRocketPlus'};%,'mWDNPlus'};,'LSTMPlus'
ind = {''};
indx = 31;
size1 = 25;
mtrcs = {'RMSE','MAPE','CV'};
units = {' ($K$)',' ($\%$)',' ($\%$)'};
cmap = get(0, 'defaultaxescolororder');
for M = 1:length(model)
    for k = 1:length(locations)
        %     fprintf(' processing results from %s...!',locations{k})
        path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{M},'_',ind{:},'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        eval(sprintf('%s.%s.noDecomp.Preds_%s = readtable(''%s'',opts);',season{:},mode{:},model{M},path1))

        %Targets
        model_name = strrep(model{1},'Plus','');
        T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
        Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
        eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
        clear dataTarget tempsum Target X
        %     fprintf('finished!\n')

        %Performance
        eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
        ymean = mean(mean(y_test));
        eval(sprintf('y_preds = table2array(%s.%s.noDecomp.Preds_%s);',season{:},mode{:},model{M}))
        MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
        RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
        R2 = 1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2);
        for i =1:size(y_test,2)
            DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
        end
        fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{M}),locations{k},RMSE,MAPE,R2,mean(DirS))
    end
end
%% Then plot performance predicted against actual temperature from two Ks of the proposed model, the historical mean, and the InceptionTime only
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
clear
clc
cmap = get(0, 'defaultaxescolororder');
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'mWDNPlus'};model1 = {'InceptionTimePlus'};%,''};,
ind2 = {'InceptionTime_coif63levels'};
ind = {'30IMFs'}; ind1 = {''};
ind_1 = {'3IMFs'};
mrks = {'diamond', '+', 'x', '*'};
indx = 31;
size1 = 25;
ip = [200 42];%292 for transition from below freezing to upper | 42 for otherwise..
%Actual vs Predicted plot
for L = 1:3%number of different figures
    figure1 = figure('WindowState','maximized');
    t = tiledlayout(1,3,'TileSpacing','tight','Padding','tight');%3,4
    for k = 1:length(locations)
        switch k
            case 1
                ind = {'30IMFs'};
            case 2
                ind = {'30IMFs'};
            case 3
                ind = {'39IMFs'};
        end
        %No decomposition
        path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model1{:},'_',ind1{:},'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        eval(sprintf('%s.%s.noDecomp.Preds_%s = readtable(''%s'',opts);',season{:},mode{:},model1{:},path1))

        %first 30IMFs
        path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind{:},'_',ind2{:},'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        X = readtable(path1,opts);
        col = X.Properties.VariableNames;
        for j = 2 : length(col)
            for i = 1 :length(X.(col{j}))
                eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
            end
        end
        fld = fieldnames(data);
        tempsum=0;
        for i=1:length(fld)
            eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
        end
        eval(sprintf('%s.%s.Proposed.Preds_%s = table(tempsum);',season{:},strcat('IMFs',string(rmmissing(regexp(ind{:},'\D','split')))),model{:}))
        clear data tempsum X

        %second 3IMFs
        path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind_1{:},'_',ind2{:},'_',season{:},locations{k},'.csv');
        opts = detectImportOptions(path1);
        X = readtable(path1,opts);
        col = X.Properties.VariableNames;
        for j = 2 : length(col)
            for i = 1 :length(X.(col{j}))
                eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
            end
        end
        fld = fieldnames(data);
        tempsum=0;
        for i=1:length(fld)
            eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
        end
        eval(sprintf('%s.%s.Proposed.Preds_%s = table(tempsum);',season{:},strcat('IMFs',string(rmmissing(regexp(ind_1{:},'\D','split')))),model{:}))
        clear data tempsum

        %Targets
        model_name = strrep(model{1},'Plus','');
        TS = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_TSsequences_%s%s.csv',season{1},locations{k}));
        T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
        Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
        TS_Target = table2array(TS(round(height(TS)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
        eval(sprintf('%s.%s.Targets = Target(:,:);',season{:},mode{:}));
        clear dataTarget tempsum Target X
        %     fprintf('finished!\n')

        %Performance
        eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
        eval(sprintf('y_preds = table2array(%s.%s.Proposed.Preds_%s);',season{:},strcat('IMFs',string(rmmissing(regexp(ind{:},'\D','split')))),model{:}))
        eval(sprintf('y_preds_1 = table2array(%s.%s.Proposed.Preds_%s);',season{:},strcat('IMFs',string(rmmissing(regexp(ind_1{:},'\D','split')))),model{:}))
        eval(sprintf('y_preds_2 = table2array(%s.%s.noDecomp.Preds_%s);',season{:},mode{:},model1{:}))
        %define the index of the best and worst performances
        [~,indMax] = maxk(abs(mean(y_test(:,indx:end)-y_preds,2)),5);
        %     [~,indMin] = mink(abs(mean(y_test-y_preds,2)),3);
        ip(3) = indMax(1);
        %     ip = indMin(3);
        nexttile
        plt = plot(TS_Target(ip(L),:), y_test(ip(L),:),'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:),'Marker','o');
        box(gca,'on');
        hold on,
        plot(plt, TS_Target(ip(L),indx:end), y_test(ip(L)-7,indx:end),'Marker',mrks{4},'MarkerFaceColor','w','MarkerEdgeColor',cmap(5,:),'LineWidth',2,'Parent',gca,'DisplayName','Historical mean','LineStyle',':','Color',cmap(5,:)) %'',[0.8500 0.3250 0.0980]
        plot(plt, TS_Target(ip(L),indx:end), y_preds_2(ip(L),:),'Marker',mrks{3},'MarkerFaceColor','w','MarkerEdgeColor',cmap(4,:),'LineWidth',2,'Parent',gca,'DisplayName','InceptionTime','LineStyle',':','Color',cmap(4,:)) %'',[0.8500 0.3250 0.0980]
        plot(plt, TS_Target(ip(L),indx:end), y_preds_1(ip(L),:),'Marker',mrks{2},'MarkerFaceColor','w','MarkerEdgeColor',cmap(3,:),'LineWidth',2,'Parent',gca,'DisplayName','VMD(3IMFs)-WT-InceptionTime','LineStyle',':','Color',cmap(3,:)) %'',[0.8500 0.3250 0.0980]
        switch k
            case 1
                plot(plt, TS_Target(ip(L),indx:end), y_preds(ip(L),:),'Marker',mrks{1},'MarkerFaceColor','w','MarkerEdgeColor',cmap(2,:),'LineWidth',2,'Parent',gca,'DisplayName','VMD(30IMFs)-WT-InceptionTime','LineStyle','--','Color',cmap(2,:)) %'',[0.8500 0.3250 0.0980]
            case 2
                plot(plt, TS_Target(ip(L),indx:end), y_preds(ip(L),:),'Marker',mrks{1},'MarkerFaceColor','w','MarkerEdgeColor',cmap(2,:),'LineWidth',2,'Parent',gca,'DisplayName','VMD(30IMFs)-WT-InceptionTime','LineStyle','--','Color',cmap(2,:)) %'',[0.8500 0.3250 0.0980]
            case 3
                plot(plt, TS_Target(ip(L),indx:end), y_preds(ip(L),:),'Marker',mrks{1},'MarkerFaceColor','w','MarkerEdgeColor',cmap(2,:),'LineWidth',2,'Parent',gca,'DisplayName','VMD(39IMFs)-WT-InceptionTime','LineStyle','--','Color',cmap(2,:)) %'',[0.8500 0.3250 0.0980]
        end
        xline(TS_Target( ip(L),indx),'-.','Forecasts','HandleVisibility','off','Interpreter','latex','LabelHorizontalAlignment','right','LabelVerticalAlignment','top','FontSize',size1-10)
        xline(TS_Target(ip(L),indx),'','T2 Input','HandleVisibility','off','Interpreter','latex','LabelHorizontalAlignment','left','LabelVerticalAlignment','top','FontSize',size1-10)
%         y_lims = ylim;
%         if 273.15 >= y_lims(1) && 273.15 <= y_lims(2)
        yline(273.15*ones(size(TS_Target(ip(L),indx:end))),':','$0\circ C$','HandleVisibility','off','Interpreter','latex','LabelHorizontalAlignment','left','LabelVerticalAlignment','middle','FontSize',size1-10)
%         end
        set(gca,'Ylim',[235 300]);
        if k==2
            legend1 = legend(gca,'show');
            set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
        end
        title(locations{k});
        set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
        eval(sprintf('set(gca,''Box'',''on'',''FontSize'',size1,''TickLabelInterpreter'',''latex'',''LineWidth'',0.5,''YMinorGrid'',''on'',''YMinorTick'',''on'',''TickDir'',''in'',''TickLength'',[0.005 0.005]);'))%,''YLim'',[0 max(max(table2array(%s.%s.Targets(k,:))))+(max(max(table2array(%s.%s.Targets(k,:))))*5/100)]',season{k},Horizon{H},season{k},Horizon{H}))
    end
    xlabel(t,'Time','interpreter','latex','FontSize',size1);
    ylabel(t,'Amplitude ($K$)','interpreter','latex','FontSize',size1);
    %then EXPORT
    exportgraphics(t,strcat('TFResults_plot_actualVsVMD+WT+InceptionTime_',num2str(L),'.pdf'),'ContentType','vector') %_1
    fprintf(' done!\n')
    exportgraphics(t,strcat('TFResults_plot_actualVsVMD+WT+InceptionTime_',num2str(L),'.pdf'),'ContentType','vector') %_1
    close(gcf)
end
%% Identify top worst performances
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
clear
clc
cmap = get(0, 'defaultaxescolororder');
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
season = {'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; model = {'mWDNPlus'};model1 = {'InceptionTimePlus'};%,''};,
ind2 = {'InceptionTime_coif63levels'};
ind = {'30IMFs'}; ind1 = {''};
% ind_1 = {'15IMFs'};
indx = 31;
size1 = 25;
for k = 1:length(locations)
    fprintf('%s:\n',locations{k});
    switch k
        case 1
            ind = {'30IMFs'};
        case 2
            ind = {'30IMFs'};
        case 3
            ind = {'39IMFs'};
    end
    %first 30IMFs
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind{:},'_',ind2{:},'_',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    X = readtable(path1,opts);
    col = X.Properties.VariableNames;
    for j = 2 : length(col)
        for i = 1 :length(X.(col{j}))
            eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
        end
    end
    fld = fieldnames(data);
    tempsum=0;
    for i=1:length(fld)
        eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
    end
    eval(sprintf('%s.%s.Proposed.Preds_%s = table(tempsum);',season{:},strcat('IMFs',string(rmmissing(regexp(ind{:},'\D','split')))),model{:}))
    clear data tempsum X

    %Targets
    model_name = strrep(model{1},'Plus','');
    TS = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_TSsequences_%s%s.csv',season{1},locations{k}));
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    TS_Target = table2array(TS(round(height(TS)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,:);',season{:},mode{:}));
    clear dataTarget tempsum X
    %     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    eval(sprintf('y_preds = table2array(%s.%s.Proposed.Preds_%s);',season{:},strcat('IMFs',string(rmmissing(regexp(ind{:},'\D','split')))),model{:}))

    fprintf('*Worst 3:\n');
    [worst_errors,indx_worst_errors] = max(abs(y_test(:,indx:end)-y_preds));    
    [~,horizon_worst3] = maxk(worst_errors,3);
    for H = 1:7 %Find out the without abs value of the error
        worst_errors(H) = y_test(indx_worst_errors(H),30+H)-y_preds(indx_worst_errors(H),H);
    end
    for O = 1:3
        actuals_worst = y_test(indx_worst_errors(horizon_worst3(O)),30+horizon_worst3(O));
        actuals_seq = y_test(indx_worst_errors(horizon_worst3(O)),indx:end);
        months_unique = (month(TS_Target(indx_worst_errors(horizon_worst3(O)))));
        fprintf(' Highest error|Horizon|Actual|SequenceRangeActual|MinSequenceActual|MaxSequenceActual|Months|SampleEntropy: %.2f|%d|%.2f|%.2f|%.2f|%.2f|[%s]|%.3f\n',worst_errors(horizon_worst3(O)),horizon_worst3(O),actuals_worst,range(actuals_seq), min(actuals_seq),max(actuals_seq),join(string(months_unique), ','),sampen(actuals_seq,2,0.15,'spearman'))
    end

    fprintf('*Best 3:\n');
    [best_errors,indx_best_errors] = min(abs(y_test(:,indx:end)-y_preds));
    [~,horizon_best3] = maxk(best_errors,3);
    for H = 1:7 %Find out the without abs value of the error
        best_errors(H) = y_test(indx_best_errors(H),30+H)-y_preds(indx_best_errors(H),H); 
    end
    for O = 1:3
        actuals_best(O) = y_test(indx_best_errors(horizon_best3(O)),30+horizon_best3(O));
        actuals_seq = y_test(indx_best_errors(horizon_best3(O)),indx:end);
        months_unique = (month(TS_Target(indx_best_errors(horizon_best3(O)))));
        fprintf(' Lowest error|Horizon|Actual|SequenceRangeActual|MinSequenceActual|MaxSequenceActual|Months|SampleEntropy: %.4f|%d|%.2f|%.2f|%.2f|%.2f|[%s]|%.3f\n',best_errors(horizon_best3(O)),horizon_best3(O),actuals_best(O),range(actuals_seq), min(actuals_seq),max(actuals_seq),join(string(months_unique), ','),sampen(actuals_seq,2,0.15,'spearman'))
    end
    %compute average ranges and min and max values in test target set :
    range_avg = mean(range(Target(:,31:end),2));
    min_avg = mean(min(Target(:,31:end),[],2));
    max_avg = mean(max(Target(:,31:end),[],2));
    fprintf(' Average Range|Min|Max: %.2f|%.2f|%.2f\n',range_avg,min_avg,max_avg)
end


%% Scatter plots for all cases in one graph
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
clear
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
for k = 1:length(locations)
    %********************************** Read preds and target of NO DECOMPOSITIONS
    clc
    season = {'bothSeasons'};%'FallWinter',
    mode = {'T2Q2'}; model = {'InceptionTimePlus'};%,'mWDNPlus'};,'LSTMPlus'
    ind = {''};
    indx = 31;
    size1 = 30;
    mtrcs = {'RMSE','MAPE','CV'};
    units = {' ($K$)',' ($\%$)',' ($\%$)'};
    cmap = get(0, 'defaultaxescolororder');
    clc
    %     fprintf(' processing results from %s...!',locations{k})
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},'_',ind{:},'_',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    eval(sprintf('%s.%s.noDecomp.Preds_%s = readtable(''%s'',opts);',season{:},mode{:},model{:},path1))

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
    %     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.noDecomp.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = 1-sum((y_test-y_preds).^2)./sum((y_test-mean(y_test)).^2);
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,mean(R2),mean(DirS))

    %     %BOXPLOT
    %     eval(sprintf('metric = %s;',mtrcs{k}))
    %     figure, boxplot(metric)
    %     box(gca,'on');
    %     set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
    % %     xlabel('No decomposition - InceptionTime','interpreter','latex','FontSize',size1);
    %     eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat(mtrcs{k},units{k})));
    %     set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    %     findobj(gca)
    %     all_lines = findobj(gca,'Type','Line');
    %     arrayfun( @(x) set(x,'LineStyle','-','Color','k','LineWidth',1), all_lines )
    %     myboxes = findobj(gca,'Tag','Box');
    %     arrayfun( @(box) patch( box.XData, box.YData, cmap(3,:), 'FaceAlpha', 0.5), myboxes(1:end))
    %     outliers = findobj( 'Tag', 'Outliers' );
    %     delete( outliers )
    %     hold on,
    %     scatter(1, metric, 64, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','k', 'MarkerFaceColor', cmap(3,:), 'MarkerEdgeAlpha', 0.2 )
    %
    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    figure1 = figure('WindowState','maximized');
    t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
    yline(273.15*ones(size(tmp1)),':','$0\circ C$','HandleVisibility','off','Interpreter','latex','LabelHorizontalAlignment','left','LabelVerticalAlignment','middle','FontSize',size1-10,'LineWidth',1)
    scatter(tmp1,tmp2, 6, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(4,:), 'MarkerEdgeAlpha', 0.2,'DisplayName','InceptionTime')
    eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    set(gca,'Xlim',[230 300],'Ylim',[230 300])
    legend1 = legend(gca,'show');
    set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
    %     %then EXPORT
    %     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_noDecomposition.pdf'),'ContentType','image')%
    %     fprintf(' done!\n')
    %     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_noDecomposition.pdf'),'ContentType','image')%,'ContentType','vector'
    %     close(gcf)
    % end

    %********************************** Read preds and target of SINGLE DECOMPOSITIONS -WT
    addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))

    clc
    locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
    season = {'bothSeasons'};%'FallWinter',
    mode = {'T2Q2'}; model = {'mWDNPlus'};%,''};,'InceptionTimePlus'
    ind = {'InceptionTime_coif63levels'};
    indx = 31;
    size1 = 30;
    mtrcs = {'RMSE','MAPE','CV'};
    units = {' ($K$)',' ($\%$)',' ($\%$)'};
    cmap = get(0, 'defaultaxescolororder');

    clc
    % for k = 1:length(locations)
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},'_',ind{:},'_',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    eval(sprintf('%s.%s.noDecomp.Preds_%s = readtable(''%s'',opts);',season{:},mode{:},model{:},path1))

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
    %     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.noDecomp.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = 1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2);
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,R2,mean(DirS))
    %
    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    %     figure1 = figure('WindowState','maximized');
    %     t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    %nexttile(1);
    %     plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
    scatter(tmp1,tmp2, 6, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(3,:), 'MarkerEdgeAlpha', 0.2,'DisplayName','WT+InceptionTime')
    yline(273.15*ones(size(tmp1)),':','$0\circ C$','HandleVisibility','off','Interpreter','latex','LabelHorizontalAlignment','left','LabelVerticalAlignment','middle','FontSize',size1-10,'LineWidth',1)
    eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    legend1 = legend(gca,'show');
    set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
    set(gca,'Xlim',[230 300],'Ylim',[230 300])
    %     %then EXPORT
    %     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_WT+InceptionTime.pdf'),'ContentType','image')
    %     fprintf(' done!\n')
    %     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_WT+InceptionTime.pdf'),'ContentType','image')
    %     close(gcf)
    % end

    %********************************** Read preds and target of SINGLE DECOMPOSITIONS -VMD
    addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
    size1 = 30;
    clc
    locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
    units = {' ($K$)',' ($\%$)',' ($\%$)'};
    season = {'bothSeasons'};%'FallWinter',
    mode = {'T2Q2'}; model = {'InceptionTimePlus'};%,''};,'InceptionTimePlus'
    ind = {'15IMFs'};
    indx = 31;

    % for k = 1:length(locations)
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind{:},'__',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    X = readtable(path1,opts);
    col = X.Properties.VariableNames;
    for j = 2 : length(col)
        for i = 1 :length(X.(col{j}))
            eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
        end
    end
    fld = fieldnames(data);
    tempsum=0;
    for i=1:length(fld)
        eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
    end
    eval(sprintf('%s.%s.IMFs15.Preds_%s = table(tempsum);',season{:},mode{:},model{:}))
    clear data tempsum

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
    %     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.IMFs15.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = 1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2);
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,R2,mean(DirS))

    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    %     figure1 = figure('WindowState','maximized');
    %     t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    %     nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
    scatter(tmp1,tmp2, 6, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(2,:), 'MarkerEdgeAlpha', 0.2,'DisplayName','VMD+InceptionTime')
    yline(273.15*ones(size(tmp1)),':','$0\circ C$','HandleVisibility','off','Interpreter','latex','LabelHorizontalAlignment','left','LabelVerticalAlignment','middle','FontSize',size1-10,'LineWidth',1)
    eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    legend1 = legend(gca,'show');
    set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
    set(gca,'Xlim',[230 300],'Ylim',[230 300])
    %     %then EXPORT
    %     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_VMD+InceptionTime.pdf'),'ContentType','image')
    %     fprintf(' done!\n')
    %     exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplot_VMD+InceptionTime.pdf'),'ContentType','image')
    %     close(gcf)
    % end

    %********************************** Read preds and target of PROPOSED MODEL
    addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
    % clear
    clc
    locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
    season = {'bothSeasons'};%'FallWinter',
    mode = {'T2Q2'}; model = {'mWDNPlus'};%,''};,'InceptionTimePlus'
    cmap = get(0, 'defaultaxescolororder');
    units = {' ($K$)',' ($\%$)',' ($\%$)'};
    ind2 = {'InceptionTime_coif63levels'};
    ind = {'15IMFs'};
    indx = 31;
    size1 = 30;

    % for k = 1:length(locations)
    path1  = strcat('\test_predsdata_TF7d_',mode{:},'_',model{:},ind{:},'_',ind2{:},'_',season{:},locations{k},'.csv');
    opts = detectImportOptions(path1);
    X = readtable(path1,opts);
    col = X.Properties.VariableNames;
    for j = 2 : length(col)
        for i = 1 :length(X.(col{j}))
            eval(sprintf('data.%s(i,:) =  cell2mat(textscan(erase(X.%s{i},{''['', '']''}),''%%f''));',(col{j}),(col{j})))
        end
    end
    fld = fieldnames(data);
    tempsum=0;
    for i=1:length(fld)
        eval(sprintf('tempsum=tempsum+data.%s;',fld{i}))
    end
    eval(sprintf('%s.%s.Proposed.Preds_%s = table(tempsum);',season{:},mode{:},model{:}))
    clear data tempsum

    %Targets
    model_name = strrep(model{1},'Plus','');
    T = readtable(sprintf('C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month8\\TF7d_T2sequences_%s%s.csv',season{1},locations{k}));
    Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
    eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{:},mode{:}));
    clear dataTarget tempsum Target X
    %     fprintf('finished!\n')

    %Performance
    eval(sprintf('y_test = (%s.%s.Targets);',season{:},mode{:}))
    ymean = mean(mean(y_test));
    eval(sprintf('y_preds = table2array(%s.%s.Proposed.Preds_%s);',season{:},mode{:},model{:}))
    MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
    RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
    R2 = 1-sum((y_test-y_preds).^2)/sum((y_test-mean(y_test)).^2);
    for i =1:size(y_test,2)
        DirS(i) = mean((sign(y_test(1:end-1,i)-y_test(2:end,i))==sign(y_preds(1:end-1,i)-y_test(2:end,i))))*100;
    end
    fprintf('  **%s in %s: %.3f,%.3f,%.3f, %.3f\n',strcat(model{:}),locations{k},RMSE,MAPE,R2,mean(DirS))

    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    %     figure1 = figure('WindowState','maximized');
    %     t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    %     nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
    yline(273.15*ones(size(tmp1)),':','$0\circ C$','HandleVisibility','off','Interpreter','latex','LabelHorizontalAlignment','left','LabelVerticalAlignment','middle','FontSize',size1-10,'LineWidth',1)
    scatter(tmp1,tmp2, 6, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','w', 'MarkerFaceColor', cmap(1,:), 'MarkerEdgeAlpha', 0.2,'DisplayName','VMD+WT+InceptionTime')
    eval(sprintf('xlabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    eval(sprintf('ylabel(''%s'',''interpreter'',''latex'',''FontSize'',size1);',strcat('Amplitude',units{1})));
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    legend1 = legend(gca,'show');
    set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1-8);
    set(gca,'Xlim',[230 300],'Ylim',[230 300])
    %then EXPORT
    exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplots.pdf'),'ContentType','image')
    fprintf(' done!\n')
    exportgraphics(t,strcat('TFResults_',locations{k},'_Scatterplots.pdf'),'ContentType','image')
    close(gcf)
end






























%% then, plot performance per metric
%METRICS ARE: RMSE, MAPE, FS, CV
clc
clear Results
IMF_names = {'noVMD'};%'',
season={'bothSeasons'};%'FallWinter',
mode = {'Time', 'T2', 'Q2', 'PCPT', 'T2Time', 'T2Q2Time', 'T2PCPTTime', 'T2PCPTQ2Time'}; model = {'mWDNPlus'};%,};'TSTPlus','InceptionTimePlus','LSTMPlus','GRUPlus' 
metric = {'RMSE','MAPE','CV','FS'};
Horizon = {'TF7d_'};%

for j=1:length(season)
    fprintf('%s:\n',season{j});
    for M=1:length(mode)%which mode
        fprintf(' -Mode %s:\n',mode{M});
        for H=1:length(Horizon)
            fprintf(' -%s:\n',strrep(strrep(Horizon{H},'_',''),'TF',''));
            for i=1:length(IMF_names)
                fprintf('  *%s:\n',IMF_names{i});
                eval(sprintf('y_test = (%s.%s.%s.Targets);',season{j},mode{M},Horizon{H}))
                ymean = mean(mean(y_test));
                for k=1:length(model)
                    eval(sprintf('y_preds = table2array(%s.%s.%s.(IMF_names{i}).Preds_%s);',season{j},mode{M},Horizon{H},model{k}))
                    Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
                    Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
                    %         Results.(season{j}).(Horizon{H}).(IMF_names{i}).(model{k}).FS = (1-(Results.(season{j}).(IMF_names{i}).ResNet.RMSE/RMSE_histMean).^2)*100;
                    Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).CV = sqrt((1/7)*sum(mean(abs(y_test-y_preds).^2)))/ymean*100;
                    fprintf('  **%s: %.3f,%.3f,%.3f\n',strcat(model{k}),Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).RMSE,Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).MAPE,Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).CV)
                end
            end
        end
    end
end

%% mWDN performance
IMF_names = {'IMF15'};%,'IMF31'
season={'bothSeasons'};%'FallWinter',
mode = {'T2','T2Time', 'T2Season', 'T2Q2', 'T2Q2Time', 'T2Q2Season', 'T2PCPTTime', 'T2PCPTQ2Time'}; %, 
model = {'mWDNPlus'};%,'mWDNPlus'};
metric = {'RMSE','MAPE','CV','FS'};
Horizon = {'TF7d_'};%

for j=1:length(season)
    fprintf('%s:\n',season{j});
    for M=1:length(mode)%which mode
        fprintf(' -Mode %s:\n',mode{M});
        for H=1:length(Horizon)
            fprintf(' -%s:\n',strrep(strrep(Horizon{H},'_',''),'TF',''));
            for i=1:length(IMF_names)
                fprintf('  *%s:\n',IMF_names{i});
                eval(sprintf('y_test = (%s.%s.%s.Targets);',season{j},mode{M},Horizon{H}))
                ymean = mean(mean(y_test));
                for k=1:length(model)
                    eval(sprintf('y_preds = table2array(%s.%s.%s.(IMF_names{i}).Preds_%s);',season{j},mode{M},Horizon{H},model{k}))
                    Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
                    Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
                    %         Results.(season{j}).(Horizon{H}).(IMF_names{i}).(model{k}).FS = (1-(Results.(season{j}).(IMF_names{i}).ResNet.RMSE/RMSE_histMean).^2)*100;
                    Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).CV = sqrt((1/7)*sum(mean(abs(y_test-y_preds).^2)))/ymean*100;
                    fprintf('  **%s: %.2f,%.2f,%.2f\n',strcat(model{k}),Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).RMSE,Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).MAPE,Results.(season{j}).(mode{M}).(Horizon{H}).(IMF_names{i}).(model{k}).CV)
                end
            end
        end
    end
end
