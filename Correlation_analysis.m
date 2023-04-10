%% spearman correlation of inputs with different lengths
clear
clc
size1 = 25;
hrz = 7;
len_in = 5:5:65;
locations = {'Nome', 'Bethel','Utqiagvik'};%{'Anchorage', 'Fairbanks','Juneau'}
figure1 = figure('WindowState','maximized');
t = tiledlayout(1,3,'TileSpacing','tight','Padding','tight');%3,4
for k = 1:3
    nexttile,
    hold on,
    LOC = locations{k};
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
    for i = 1:length(len_in)
        len = len_in(i) + hrz; %30 days + 1 day
        fprintf('\n-Processing input data of %d in length for %d forecasting horizons...', len_in(i), hrz);
        [TS, PCPT] = PCPT_ForecastData_preprocessing(loc_r,loc_c,len);
        [~, Q2]  = Q2_ForecastData_preprocessing(loc_r,loc_c,len);
        [~,T2] = T2_ForecastData_preprocessing(loc_r,loc_c,len);
        %correlation analysis
        %-extract time information variables
        [y, m, d] = ymd(TS);
        mo = month(TS);
        isWinter = ismember(mo, [12,1,2]);
        isWinter = isWinter*1;
        isSpring = ismember(mo, [3,4,5]);
        isSpring = isSpring*2;
        isSummer = ismember(mo, [6,7,8]);   %here you define the seasons by month
        isSummer = isSummer*3;
        isAutumn = ismember(mo, [9,10,11]);
        isAutumn = isAutumn*4;
        S = isWinter + isSpring + isSummer + isAutumn;
        %-compute correlation
        %-- T2
        eval(sprintf('CorrResults.rho_T2_%d = corr(T2(:,1:%d),T2(:,%d+1:end),''Type'',''Spearman'');',len-hrz,len-hrz,len-hrz))
        %-- Q2
        eval(sprintf('CorrResults.rho_Q2_%d = corr(Q2(:,1:%d),T2(:,%d+1:end),''Type'',''Spearman'');',len-hrz,len-hrz,len-hrz))
        %-- PCPT
        eval(sprintf('CorrResults.rho_PCPT_%d = corr(PCPT(:,1:%d),T2(:,%d+1:end),''Type'',''Spearman'');',len-hrz,len-hrz,len-hrz))
        %-- Year
        eval(sprintf('CorrResults.rho_Y_%d = corr(y(:,1:%d),T2(:,%d+1:end),''Type'',''Spearman'');',len-hrz,len-hrz,len-hrz))
        %-- Month
        eval(sprintf('CorrResults.rho_M_%d = corr(m(:,1:%d),T2(:,%d+1:end),''Type'',''Spearman'');',len-hrz,len-hrz,len-hrz))
        %-- Day of month
        eval(sprintf('CorrResults.rho_D_%d = corr(d(:,1:%d),T2(:,%d+1:end),''Type'',''Spearman'');',len-hrz,len-hrz,len-hrz))
        %-- Season
        eval(sprintf('CorrResults.rho_S_%d = corr(S(:,1:%d),T2(:,%d+1:end),''Type'',''Spearman'');',len-hrz,len-hrz,len-hrz))
    end


    inputs = {'T2','Q2','PCPT','Y','M','D','S'};
    for j = 1:length(inputs)
        for i = 1:length(len_in)
            eval(sprintf('%s_avg(i) = mean(mean(CorrResults.rho_%s_%d));',inputs{j},inputs{j},len_in(i)))
        end
    end

    for j = 1:length(inputs)
        eval(sprintf('plot(len_in,%s_avg,''DisplayName'',''%s'',''Marker'',''v'',''LineWidth'',2)',inputs{j},inputs{j}))
    end
    if isequal(k,2)
        legend1 =legend(gca,'show');
        set(legend1,'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
    end
    title(locations{k});
    set(gca,'FontSize',size1,'TickLabelInterpreter','latex');%,'Ylim',[0 500]); just in the case of Household 3
    eval(sprintf('set(gca,''Box'',''on'',''FontSize'',size1,''TickLabelInterpreter'',''latex'',''LineWidth'',0.5,''YMinorGrid'',''on'',''YMinorTick'',''on'',''TickDir'',''in'',''TickLength'',[0.005 0.005],''XTick'',[0 7 14 21 28 35 42 49 56 63],''XTickLabel'',{''0'',''7'',''14'',''21'',''28'',''35'',''42'',''49'',''56'',''63''});'))
end
xlabel(t,'Input length','interpreter','latex','FontSize',size1);
ylabel(t,'Spearman coefficient','interpreter','latex','FontSize',size1);

%then EXPORT
exportgraphics(t, strcat('SpearmanCorrelationAnalysis_all.pdf'),'ContentType','vector')
fprintf(' done!\n')
exportgraphics(t, strcat('SpearmanCorrelationAnalysis_all.pdf'),'ContentType','vector')
close(gcf)