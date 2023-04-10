%% Scatter plots for all cases in one graph
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
clear
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
for k = 1:length(locations)
    %% Read preds and target of NO DECOMPOSITIONS
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
    %     scatter(1, metric, 64, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','k', 'MarkerFaceColor', cmap(3,:), 'MarkerEdgeAlpha', 0.2 )
    %
    %True vs Predicted scatter plot
    tmp1 = reshape(y_test,1,[])';
    tmp2 = reshape(y_preds,1,[])';
    figure1 = figure('WindowState','maximized');
    t = tiledlayout(1,1,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);plot(tmp1,tmp1,'LineWidth',2,'DisplayName','Actual')
    hold on,
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
    %% Read preds and target of SINGLE DECOMPOSITIONS -WT
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

    %% Read preds and target of SINGLE DECOMPOSITIONS -VMD
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

    %% Read preds and target of PROPOSED MODEL
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
