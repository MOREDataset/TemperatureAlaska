%% Read preds and target of VMD-empowered models
clear
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\ClimateDataset\results3'))
season = {'bothSeasonsNome'};%'FallWinter',
mode = {'T2Q2'}; model = {'mWDNPlus'};%'TSTPlus','InceptionTimePlus','LSTMPlus',
ind = {''}; O=1; %O to refer to which element from ind
IMFS={'3IMFs','6IMFs','9IMFs','12IMFs','15IMFs', '18IMFs','21IMFs','24IMFs','27IMFs','30IMFs'};%
adds = '_InceptionTime_coif63levels_';%Change according to the model! .. what can I say, I am lazy!
Horizon = {'TF7d_'};%
indx = 31; 
for Y = 1:length(season)
    fprintf('%s season:\n',season{Y});
    for M=1:length(mode)%which mode
        fprintf(' -Mode %s:\n',mode{M});
        for H=1:length(Horizon)
            fprintf('  -%s horizon:\n',strrep(strrep(Horizon{H},'_',''),'TF',''));
            for L=1:length(IMFS) %which IMFs group
                for k = 1:length(model) %which model
                    model_name = strrep(model{k},'Plus','');
                    fprintf('   *Processing predictions using %s with model: %s...',strcat(IMFS{L}, adds),model{k});
                    path4  = strcat('\test_predsdata_',Horizon{H},mode{M},'_',model{k},ind{O},strcat(IMFS{L}, adds),season{Y},'.csv'); %model_name
                    opts = detectImportOptions(path4);
                    eval(sprintf('X = readtable(''%s'',opts);',path4))
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
                    imf_number = char(IMFS{L});
                    add_char = char(adds);
                    eval(sprintf('%s.%s.%s.Preds_%s = table(tempsum);',season{Y},mode{M},strcat('IMFs',string(rmmissing(regexp(IMFS{L},'\D','split')))),model{k}))
                    clear data tempsum
                    %                         eval(sprintf('%s.%s.%s.noVMD.Preds_%s = readtable(''%s'',opts);',season{Y},mode{M},Horizon{H},model{k},path2))
                    fprintf('finished!\n')
                end
            end
        end
        %Targets
        model_name = strrep(model{1},'Plus','');
        fprintf(' *Importing targets..');
        T = readtable(sprintf('%sT2sequences_%s.csv',Horizon{H},season{Y}));
        Target = table2array(T(round(height(T)*80/100)+2:end,:));%check if the +2 should be +1 due to rounding
        eval(sprintf('%s.%s.Targets = Target(:,indx:end);',season{Y},mode{M}));
        clear dataTarget tempsum Target X
        fprintf('finished!\n')
    end
end

clear path4 path3 path2 opts model_name model M L k j IMFS i mode Horizon H fld col Y indx O ind season T imf_number adds add_char
fprintf('Finished!\n')

%% mean PERFORMANCE 
IMFS={'IMFs3','IMFs6','IMFs9','IMFs12','IMFs15', 'IMFs18','IMFs21','IMFs24','IMFs27','IMFs30'};%
season={'bothSeasons'};%'FallWinter',
mode = {'T2Q2'}; %,
model = {'mWDNPlus'};%,'mWDNPlus'};
adds = 'InceptionTime_coif63levels_';%Change according to the model! .. what can I say, I am lazy!
metric = {'RMSE','MAPE','CV','FS'};
Horizon = {'TF7d_'};%

for j=1:length(season)
    fprintf('%s:\n',season{j});
    for M=1:length(mode)%which mode
        fprintf(' -Mode %s:\n',mode{M});
        for H=1:1%length(Horizon)
            for i=1:length(IMFS)
                fprintf('  *%s:\n',IMFS{i});
                eval(sprintf('y_test = (%s.%s.Targets);',season{j},mode{M}))
                ymean = mean(mean(y_test));
                for k=1:length(model)
                    eval(sprintf('y_preds = table2array(%s.%s.%s.Preds_%s);',season{j},mode{M},IMFS{i},model{k}))
                    Results.(season{j}).(mode{M}).(IMFS{i}).(model{k}).MAPE = mean(mean(abs((y_test-y_preds)./y_test)))*100;
                    Results.(season{j}).(mode{M}).(IMFS{i}).(model{k}).RMSE = sqrt(mean(mean((y_test-y_preds).^2)));
                    Results.(season{j}).(mode{M}).(IMFS{i}).(model{k}).CV = sqrt((1/7)*sum(mean(abs(y_test-y_preds).^2)))/ymean*100;
                    fprintf('  **%s: %.2f,%.2f,%.2f\n',strcat(model{k}),Results.(season{j}).(mode{M}).(IMFS{i}).(model{k}).RMSE,Results.(season{j}).(mode{M}).(IMFS{i}).(model{k}).MAPE,Results.(season{j}).(mode{M}).(IMFS{i}).(model{k}).CV)
                end
            end
        end
    end
end

%% BAR GRAPH
IMF_names = {'IMFs3','IMFs6','IMFs9','IMFs12','IMFs15', 'IMFs18','IMFs21','IMFs24','IMFs27','IMFs30'};%
season={'bothSeasons'};
mode = {'T2Q2'};
metric = {'RMSE','MAPE','CV'};%,'FS'
model = {'mWDNPlus'};
adds = 'LSTM_coif63levels_';%Change according to the model! .. what can I say, I am lazy!
Horizon = {'TF7d_'};%
indx = {'31'};
lgds = {'Actual','$T_{ICE}$ + Time', '$T_{ICE}^{VMD}$ + Time'};
smbls = {'v','^','d'};
clr = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560];

for j=1:length(season)
    fprintf('%s:\n',season{j});
    for M=1:length(mode)%which mode
        fprintf(' -Mode %s:\n',mode{M});
        for H=1:1%length(Horizon)
            for i=1:length(IMF_names)
%                 fprintf('  *%s:\n',IMFS{i});
                eval(sprintf('y_test = (%s.%s.Targets);',season{j},mode{M}))
                ymean = mean(mean(y_test));
                for k=1:length(model)
                    eval(sprintf('y_preds = table2array(%s.%s.%s.Preds_%s);',season{j},mode{M},IMF_names{i},model{k}))
                    Results.(season{j}).(mode{M}).(IMF_names{i}).(model{k}).MAPE = (mean(abs((y_test-y_preds)./y_test)))*100;
                    Results.(season{j}).(mode{M}).(IMF_names{i}).(model{k}).RMSE = sqrt((mean((y_test-y_preds).^2)));
                    Results.(season{j}).(mode{M}).(IMF_names{i}).(model{k}).CV = sqrt((1/7)*sum((abs(y_test-y_preds).^2)))/ymean*100;
                end
            end
        end
    end
end
cmap = get(0, 'defaultaxescolororder');
for k=1:length(season)
    fprintf('%s:\n',season{k});
    perf_CV = [];
    perf_RMSE = [];
    perf_MAPE = [];
    for i=1:length(IMF_names)
        perf_CV = [ perf_CV Results.(season{:}).(mode{:}).(IMF_names{i}).(model{:}).CV' ];
        perf_MAPE = [ perf_MAPE Results.(season{:}).(mode{:}).(IMF_names{i}).(model{:}).MAPE' ];
        perf_RMSE = [ perf_RMSE Results.(season{:}).(mode{:}).(IMF_names{i}).(model{:}).RMSE' ];
    end
    size1=23;
    % Create figure
    figure1 = figure('units','normalized','outerposition',[0 0 1 1]);
    t = tiledlayout(1,3,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);
    boxplot(perf_RMSE,3:3:30)%strcat(string(rmmissing(regexp(IMFS{1},'\D','split'))),'IMFs')
    box(gca,'on');
    set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
    xlabel('Decomposition level ($K$)','interpreter','latex','FontSize',size1);
    ylabel('RMSE ($F$)','interpreter','latex','FontSize',size1);
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    findobj(gca)
    all_lines = findobj(gca,'Type','Line');
    arrayfun( @(x) set(x,'LineStyle','-','Color','k','LineWidth',1), all_lines )
    myboxes = findobj(gca,'Tag','Box');
    arrayfun( @(box) patch( box.XData, box.YData, cmap(1,:), 'FaceAlpha', 0.5), myboxes(1:end))
    outliers = findobj( 'Tag', 'Outliers' );
    delete( outliers )
    hold on,
    scatter(3:3:30, perf_RMSE , 64, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','k', 'MarkerFaceColor', cmap(1,:), 'MarkerFaceAlpha', 0.5 )
%
    nexttile(2)
    boxplot(perf_MAPE,3:3:30)
    box(gca,'on');
    set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
    xlabel('Decomposition level ($K$)','interpreter','latex','FontSize',size1);
    ylabel('MAPE ($\%$)','interpreter','latex','FontSize',size1);
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    findobj(gca)
    all_lines = findobj(gca,'Type','Line');
    arrayfun( @(x) set(x,'LineStyle','-','Color','k','LineWidth',1), all_lines )
    myboxes = findobj(gca,'Tag','Box');
    arrayfun( @(box) patch( box.XData, box.YData, cmap(2,:), 'FaceAlpha', 0.5), myboxes(1:end))
    outliers = findobj( 'Tag', 'Outliers' );
    delete( outliers )
    hold on,
    scatter(3:3:30, perf_MAPE , 64, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','k', 'MarkerFaceColor', cmap(2,:), 'MarkerFaceAlpha', 0.5 )
%
    nexttile(3)
    boxplot(perf_CV,3:3:30)
    box(gca,'on');
    set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
    xlabel('Decomposition level ($K$)','interpreter','latex','FontSize',size1);
    ylabel('CV ($\%$)','interpreter','latex','FontSize',size1);
    set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
    findobj(gca)
    all_lines = findobj(gca,'Type','Line');
    arrayfun( @(x) set(x,'LineStyle','-','Color','k','LineWidth',1), all_lines )
    myboxes = findobj(gca,'Tag','Box');
    arrayfun( @(box) patch( box.XData, box.YData, cmap(3,:), 'FaceAlpha', 0.5), myboxes(1:end))
    outliers = findobj( 'Tag', 'Outliers' );
    delete( outliers )
    hold on,
    scatter(3:3:30, perf_CV , 64, 'Jitter', 'on', 'JitterAmount', 0.1, 'MarkerEdgeColor','k', 'MarkerFaceColor', cmap(3,:), 'MarkerFaceAlpha', 0.5 )
end
%then EXPORT
exportgraphics(t,'EXPII_Performance.pdf','ContentType','vector')
fprintf(' done!\n')
exportgraphics(t,'EXPII_Performance.pdf','ContentType','vector')
close(gcf)

%% graph


IMF_names = {'IMFs27'};%
season={'bothSeasons'};
mode = {'T2Q2'};
metric = {'RMSE','MAPE','CV'};%,'FS'
model = {'mWDNPlus'};
adds = 'InceptionTime_coif63levels_';%Change according to the model! .. what can I say, I am lazy!
Horizon = {'TF7d_'};%
indx = {'31'};
lgds = {'Actual', '$T2^{VMD}_{K=27}+Q2$'};
smbls = {'v','^','d'};
clr = [0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560];
for k=1:length(season)
    fprintf('%s:\n',season{k});
    for H=1:length(Horizon)
        fprintf(' -%s: ...',strrep(strrep(Horizon{H},'_',''),'TF',''));
        size1=23;
        % Create figure
        figure1 = figure('units','normalized','outerposition',[0 0 1 1]);
        t = tiledlayout('flow','TileSpacing','tight','Padding','tight');%3,4
        nexttile([3 3]);
        path5 = sprintf('%sTSsequences_%s.csv',Horizon{H},season{k});
        fprintf(' *Importing targets..');
        if ~exist(path5)
            path5 = strrep(path5,'Vol','ICE');
        end
        T = readtable(path5);
        TS_test_set = table2array(T(round(height(T)*80/100)+1:end,:));
        % % Create axes
        % axes1 = axes('Parent',figure1,'Units','Normalize','Position',[0.05 0.0847457627118644 0.939583333333333 0.897308075772681]);
        % Create multiple lines using matrix input to plot
        eval(sprintf('plt = plot(TS_test_set(1,%s:end), (%s.%s.Targets(1,:)),''Marker'',''o'',''MarkerFaceColor'',''w'',''MarkerSize'',10,''LineWidth'',3.5,''Parent'',gca,''DisplayName'',''Actual'',''Color'',[0 0.4470 0.7410]);',indx{H},season{k},mode{1}))
        box(gca,'on');
        hold on,
        for J = 1:length(IMF_names)
            eval(sprintf('plot(TS_test_set(1,%s:end), table2array(%s.%s.%s.Preds_mWDNPlus(1,:)),''Marker'',smbls{J},''MarkerSize'',10,''MarkerFaceColor'',''w'',''LineWidth'',2,''Parent'',gca,''DisplayName'',''%s'',''LineStyle'','':'',''Color'',clr(1,:))',indx{H},season{k},mode{1},IMF_names{J},lgds{2})) %''Color'',[0.8500 0.3250 0.0980]
        end
        legend1 = legend(gca,'show');
        set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
        set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
        xlabel('Time','interpreter','latex','FontSize',size1);
        ylabel('Amplitude (W/$m^2$)','interpreter','latex','FontSize',size1);
        eval(sprintf('set(gca,''Box'',''on'',''FontSize'',size1,''TickLabelInterpreter'',''latex'',''LineWidth'',0.5,''YMinorGrid'',''on'',''YMinorTick'',''on'',''TickDir'',''in'',''TickLength'',[0.005 0.005]);'))%,''YLim'',[0 max(max(table2array(%s.%s.Targets(k,:))))+(max(max(table2array(%s.%s.Targets(k,:))))*5/100)]',season{k},Horizon{H},season{k},Horizon{H}))
    end
    %then EXPORT
    exportgraphics(t,'Example_Performance_bestmodel.pdf','ContentType','vector')
    fprintf(' done!\n')
    exportgraphics(t,'Example_Performance_bestmodel.pdf','ContentType','vector')
    close(gcf)
end
