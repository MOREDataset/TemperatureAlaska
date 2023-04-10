%% Read data
clear
clc
len = 30 + 7; %30 days + 1 day
LOC = 'Nome';
switch true
    case strcmp(LOC, 'Nome')
        loc_r = 125;
        loc_c = 100;

    case strcmp(LOC, 'Bethel')
        loc_r = 147;
        loc_c = 105;

    case strcmp(LOC, 'Utqiagvik')
        loc_r = 91;
        loc_c = 123;
end

fprintf('-Processing data for %d forecasting horizons!\n',len-30);
% [TS, PCPT] = PCPT_ForecastData_preprocessing(loc,len);
% [~,Q2] = Q2_ForecastData_preprocessing(loc_r,loc_c,len);
[~,T2] = T2_ForecastData_preprocessing(loc_r,loc_c,len);
% S = Season_ForecastData_preprocessing(loc,len);
%% Decompose using VMD and WT
[imf,res] = vmd(T2(1,1:30),'NumIMFs',3);

wt_IMF1 = modwt(imf(:,1),'db4',3)';
wt_IMF2 = modwt(imf(:,2),'db4',3)';
wt_IMF3 = modwt(imf(:,3),'db4',3)';
wt_RES = modwt(res,'db4',3)';
%% PLOT decompositions
size1 = 30;
cmap = get(0, 'defaultaxescolororder');
%ORIGNAL time series
figure1 = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout('flow','TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
plot(categorical(1:30),T2(1,1:30),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color', [0 0 0])
% title("Original temperature sequence")
xlabel("Days",'interpreter','latex','FontSize',size1)
ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%then EXPORT
exportgraphics(t,strcat('Temperature_rawTimeSeries',LOC,'.pdf'),'ContentType','vector')
fprintf(' done!\n')
exportgraphics(t,strcat('Temperature_rawTimeSeries',LOC,'.pdf'),'ContentType','vector')
close(gcf)


%ORIGNAL fft of the time series
figure2 = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout('flow','TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
L = len-7;
Fs = 1/(24*60*60);
X = T2(1,1:30);
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',[0 0 0])
% title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("Frequency (Hz)",'interpreter','latex','FontSize',size1)
ylabel("$\vert P1(f) \vert$",'interpreter','latex','FontSize',size1)
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%then EXPORT
exportgraphics(t,strcat('Temperature_rawFFT',LOC,'.pdf'),'ContentType','vector')
fprintf(' done!\n')
exportgraphics(t,strcat('Temperature_rawFFT',LOC,'.pdf'),'ContentType','vector')
close(gcf)


%VMD IMFs and res: time series
figure4 = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(4,1,'TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
plot(categorical(1:30),imf(:,1),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:))
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
nexttile(2);
plot(categorical(1:30),imf(:,2),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(2,:))
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
nexttile(3);
plot(categorical(1:30),imf(:,3),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(3,:))
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
nexttile(4);
plot(categorical(1:30),res,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(4,:))
xlabel(t, "Days",'interpreter','latex','FontSize',size1)
ylabel(t, "Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%then EXPORT
exportgraphics(t,strcat('Temperature_VMDTimeSeries',LOC,'.pdf'),'ContentType','vector')
fprintf(' done!\n')
exportgraphics(t,strcat('Temperature_VMDTimeSeries',LOC,'.pdf'),'ContentType','vector')
close(gcf)


%VMD IMFs and res: fft of time series
L = len-7;
Fs = 1/(24*60*60);
X = imf(:,1);
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure4 = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(4,1,'TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:))
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);

L = len-7;
Fs = 1/(24*60*60);
X = imf(:,2);
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile(2);
stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(2,:))
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);

L = len-7;
Fs = 1/(24*60*60);
X = imf(:,3);
X = X - mean(X);
Y = fft(X);
Y = fft(imf(:,3));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile(3);
stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(3,:))
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);


L = len-7;
Fs = 1/(24*60*60);
X = res;
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile(4);
stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(4,:))
xlabel(t, "Frequency (Hz)",'interpreter','latex','FontSize',size1)
ylabel(t, "$\vert P1(f) \vert$",'interpreter','latex','FontSize',size1)
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%then EXPORT
exportgraphics(t,strcat('Temperature_VMDFFT',LOC,'.pdf'),'ContentType','vector')
fprintf(' done!\n')
exportgraphics(t,strcat('Temperature_VMDFFT',LOC,'.pdf'),'ContentType','vector')
close(gcf)



%WT decompositions: 1 as time series
figure3 = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(4,1,'TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
plt = plot(categorical(1:30),wt_IMF1(:,1),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .8];
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
nexttile(2);
plt = plot(categorical(1:30),wt_IMF1(:,2),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .6];
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
nexttile(3);
plt = plot(categorical(1:30),wt_IMF1(:,3),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .4];
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
nexttile(4);
plt = plot(categorical(1:30),wt_IMF1(:,4),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .2];
xlabel(t, "Days",'interpreter','latex','FontSize',size1)
ylabel(t, "Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%then EXPORT
exportgraphics(t,strcat('Temperature_WTTimeSeries',LOC,'.pdf'),'ContentType','vector')
fprintf(' done!\n')
exportgraphics(t,strcat('Temperature_WTTimeSeries',LOC,'.pdf'),'ContentType','vector')
close(gcf)




%WT decompositions: 1 as fft of time series
L = len-7;
Fs = 1/(24*60*60);
X = wt_IMF1(:,1);
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure4 = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(4,1,'TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
plt = stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .8];
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);

L = len-7;
Fs = 1/(24*60*60);
X = wt_IMF1(:,2);
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile(2);
plt = stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .6];
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);

L = len-7;
Fs = 1/(24*60*60);
X = wt_IMF1(:,3);
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile(3);
plt = stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .4];
% ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
set(gca,'XTick',[])
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);


L = len-7;
Fs = 1/(24*60*60);
X = wt_IMF1(:,4);
X = X - mean(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile(4);
plt = stem(f,P1,'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:));
plt.Color = [0 0.4470 0.7410 .2];
xlabel(t, "Frequency (Hz)",'interpreter','latex','FontSize',size1)
ylabel(t, "$\vert P1(f) \vert$",'interpreter','latex','FontSize',size1)
set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%then EXPORT
exportgraphics(t,strcat('Temperature_WTFFT',LOC,'.pdf'),'ContentType','vector')
fprintf(' done!\n')
exportgraphics(t,strcat('Temperature_WTFFT',LOC,'.pdf'),'ContentType','vector')
close(gcf)





%
%
% %WT decompositions: 2
% figure3 = figure('units','normalized','outerposition',[0 0 1 1]);
% t = tiledlayout(4,1,'TileSpacing','tight','Padding','tight');%3,4
% nexttile(1);
% plot(categorical(1:30),wt_IMF2(:,1),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(2);
% plot(categorical(1:30),wt_IMF2(:,2),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(2,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(3);
% plot(categorical(1:30),wt_IMF2(:,3),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(3,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(4);
% plot(categorical(1:30),wt_IMF2(:,4),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(4,:))
% xlabel(t, "Days",'interpreter','latex','FontSize',size1)
% ylabel(t, "Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%
% %WT decompositions: 3
% figure3 = figure('units','normalized','outerposition',[0 0 1 1]);
% t = tiledlayout(4,1,'TileSpacing','tight','Padding','tight');%3,4
% nexttile(1);
% plot(categorical(1:30),wt_IMF3(:,1),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(2);
% plot(categorical(1:30),wt_IMF3(:,2),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(2,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(3);
% plot(categorical(1:30),wt_IMF3(:,3),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(3,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(4);
% plot(categorical(1:30),wt_IMF3(:,4),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(4,:))
% xlabel(t, "Days",'interpreter','latex','FontSize',size1)
% ylabel(t, "Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
%
% %WT decompositions: 4
% figure3 = figure('units','normalized','outerposition',[0 0 1 1]);
% t = tiledlayout(4,1,'TileSpacing','tight','Padding','tight');%3,4
% nexttile(1);
% plot(categorical(1:30),wt_RES(:,1),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(1,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(2);
% plot(categorical(1:30),wt_RES(:,2),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(2,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(3);
% plot(categorical(1:30),wt_RES(:,3),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(3,:))
% % ylabel("Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'XTick',[])
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);
% nexttile(4);
% plot(categorical(1:30),wt_RES(:,4),'Marker','o','MarkerFaceColor','w','MarkerSize',10,'LineWidth',3.5,'Parent',gca,'DisplayName','Actual','Color',cmap(4,:))
% xlabel(t, "Days",'interpreter','latex','FontSize',size1)
% ylabel(t, "Amplitude (K)",'interpreter','latex','FontSize',size1)
% set(gca,'Box','on','FontSize',size1,'TickLabelInterpreter','latex','LineWidth',0.5,'YMinorGrid','on','YMinorTick','on','TickDir','in','TickLength',[0.005 0.005]);

%% Complexity computation T2
%- read data
clear
clc
len = 30 + 7; %30 days + 1 day

LOC = 'Nome';
fprintf('Location: %s\n',LOC)
switch true
    case strcmp(LOC, 'Nome')
        loc_r = 125;
        loc_c = 100;

    case strcmp(LOC, 'Bethel')
        loc_r = 147;
        loc_c = 105;

    case strcmp(LOC, 'Utqiagvik')
        loc_r = 91;
        loc_c = 123;
end

fprintf('-Processing data for %d forecasting horizons!\n',len-30);
[~,T2] = T2_ForecastData_preprocessing(loc_r,loc_c,len);


% load('rawT2_VMDT2_in30_out7.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Complexity of original T2 sequences
clc
I = T2(:,1:30);
valueT2 = zeros(length(I),1);
for i = 1:length(I)
    valueT2(i) = sampen(I(i,:),2,0.15,'chebychev');%chebychev, spearman, correlation,euclidean
end
fprintf('Whole T2 entropy: %.3f\n',mean(valueT2,'omitnan'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%- VMD T2 decomposition
numberIMFs = 15; %[31 63 127 255];
clear x
for i = 0:len
    x{i+1} = 'Element'+string(i);
end
fprintf('*Extracting VMD features using %d IMFs..\n',numberIMFs);
VMD = table('Size',[length(T2)*(numberIMFs+1),1+len],'VariableNames',string(x),'VariableTypes','double'+strings(1,length(x)));%,'',{'single','double','double','double','double','double','double','double','double','double','double','double','double','double'});
VMD.Properties.VariableNames{1}='SequenceNumber';
TEMT2=ones(length(T2)*(numberIMFs+1),1+len);
for i = 1:1:length(T2)
    [imf,res] = vmd(T2(i,:),'NumIMFs',numberIMFs);
    TEMT2(i+(numberIMFs)*(i-1):i+(numberIMFs)*(i-1)+(numberIMFs),:) = [ones(numberIMFs+1,1)*i,[imf';res']];%
end
VMD_T2 = TEMT2;%array2table(TEMT2,'VariableNames',string(x));
fprintf('finished!\n');
clear TEMT2 len  loc i x

%-Complexity of VMD IMFs
K = numberIMFs+1;
valueVMD = zeros(length(I),K);
for k = 1:K %k is IMF number
    I = (VMD_T2(k:K*k:end,2:31));
    for i = 1:length(I)
        valueVMD(i,k) = sampen(I(i,:),2,0.15,'chebychev');%chebychev, spearman, correlation,euclidean
    end
end
fprintf('All VMD-IMFs entropy: %.3f\n',mean(valueVMD,'omitnan'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Complexity of WT decompositions of VMD T2
numberWTdecomps = 3;
K = numberIMFs+1;
L = numberWTdecomps;
valueWT = zeros(length(I),L+1,2);
for k = 1:K %k is IMF number
    fprintf('IMF%d, ',k);
    I = modwt(VMD_T2(k:K*k:end,2:31),'db4',L);
    for j = 1:L+1
        for i = 1:length(I)
            clear tmp
            tmp = I(j,:,:);
            z = size(tmp);
            squeezed = reshape(tmp,[z(2:end) 1]);
            valueWT(i,j,k) = sampen(squeezed(i,:),2,0.15,'chebychev');%chebychev, spearman, correlation,euclidean
        end
    end
end
fprintf('\n')
for k = 1:K %k is IMF number
    for j = 1:L+1
        tmp2(j,k) = mean(valueWT(:,j,k),'omitnan');
    end
end
for j = 1:L+1
    fprintf('WT decomps.%d entropy: %.4f \n',j,mean(tmp2(j,:)))
end
%% Complexity Computation Q2
clear
clc
%- read data
len = 30 + 7; %30 days + 1 day
numberIMFs = 15; %[31 63 127 255];
LOC = 'Utqiagvik';
switch true
    case strcmp(LOC, 'Nome')
        loc_r = 125;
        loc_c = 100;

    case strcmp(LOC, 'Bethel')
        loc_r = 147;
        loc_c = 105;

    case strcmp(LOC, 'Utqiagvik')
        loc_r = 91;
        loc_c = 123;
end

fprintf('-Processing data for %d forecasting horizons!\n',len-30);
[~, Q2]  = Q2_ForecastData_preprocessing(loc_r,loc_c,len);

%-Complexity of original Q2 sequences
clc
I = Q2(:,1:30);
valueT2 = zeros(length(I),1);
for i = 1:length(I)
    valueT2(i) = sampen(I(i,:),2,0.15,'chebychev');%chebychev, spearman, correlation,euclidean
end
fprintf('Whole Q2 entropy: %.3f\n',mean(valueT2,'omitnan'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%- VMD Q2 decomposition
numberIMFs = 15; %[31 63 127 255];
clear x
for i = 0:len
    x{i+1} = 'Element'+string(i);
end
fprintf('*Extracting VMD features using %d IMFs..\n',numberIMFs);
VMD = table('Size',[length(Q2)*(numberIMFs+1),1+len],'VariableNames',string(x),'VariableTypes','double'+strings(1,length(x)));%,'',{'single','double','double','double','double','double','double','double','double','double','double','double','double','double'});
VMD.Properties.VariableNames{1}='SequenceNumber';
TEMT2=ones(length(Q2)*(numberIMFs+1),1+len);
for i = 1:1:length(Q2)
    [imf,res] = vmd(Q2(i,:),'NumIMFs',numberIMFs);
    TEMT2(i+(numberIMFs)*(i-1):i+(numberIMFs)*(i-1)+(numberIMFs),:) = [ones(numberIMFs+1,1)*i,[imf';res']];%
end
VMD_Q2 = TEMT2;%array2table(TEMT2,'VariableNames',string(x));
fprintf('finished!\n');
clear TEMT2 len  loc i x

%-Complexity of VMD IMFs
K = numberIMFs+1;
valueVMD = zeros(length(I),K);
for k = 1:K %k is IMF number
    I = (VMD_Q2(k:K*k:end,2:31));
    for i = 1:length(I)
        valueVMD(i,k) = sampen(I(i,:),2,0.15,'chebychev');%chebychev, spearman, correlation,euclidean
    end
end
fprintf('All VMD-IMFs entropy: %.3f\n',mean(valueVMD,'omitnan'))

%-Complexity of WT decompositions of VMD Q2
numberWTdecomps = 3;
K = numberIMFs+1;
L = numberWTdecomps;
valueWT = zeros(length(I),L+1,2);
for k = 1:K %k is IMF number
    fprintf('IMF%d, ',k);
    I = modwt(VMD_Q2(k:K*k:end,2:31),'db4',L);
    for j = 1:L+1
        for i = 1:length(I)
            tmp = I(j,:,:);
            z = size(tmp);
            squeezed = reshape(tmp,[z(2:end) 1]);
            valueWT(i,j,k) = sampen(squeezed(i,:),2,0.15,'chebychev');%chebychev, spearman, correlation,euclidean
        end
    end
end
fprintf('\n')
for k = 1:K %k is IMF number
    for j = 1:L+1
        tmp2(j,k) = mean(valueWT(:,j,k),'omitnan');
    end
end
for j = 1:L+1
    fprintf('WT decomps.%d entropy: %.4f \n',j,mean(tmp2(j,:)))
end


%% MAYBE COMPUTE THE FREQUENCIES IN EACH TIME SERIES?
clc

%Decompose using VMD and WT
[imf,res] = vmd(T2(1,1:30),'NumIMFs',3);

wt_IMF1 = modwt(imf(:,1),'db4',3)';
wt_IMF2 = modwt(imf(:,2),'db4',3)';
wt_IMF3 = modwt(imf(:,3),'db4',3)';
wt_RES = modwt(res,'db4',3)';

%Plot raw time series and its fft
Fs = 1/(24*60*60); % sampling frequency 1 kHz
t =  1:30; % time scale
x = T2(1,1:30) ; % time series
x = x - mean(x);                                            % <= ADDED LINE
figure, T = tiledlayout(1,2,'TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
plot(t,x), axis('tight'), grid('on'), title('Raw Time series')

y = fft(x); % Fast Fourier Transform
y = abs(y.^2); % raw power spectrum density
y = y(1:1+length(x)/2); % half-spectrum
[v,k] = max(y); % find maximum
f_scale = (0:length(x)/2)* Fs/length(x); % frequency scale
nexttile(2);
stem(f_scale, y),axis('tight'),grid('on'),title('Single-Sided power spectrum')


%Plot IMFs time series and its fft
for i = 1:3
    x = imf(:,i) ; % time series
    x = x - mean(x);                                            % <= ADDED LINE
    figure, T = tiledlayout(1,2,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);
    plot(t,x), axis('tight'), grid('on'), title(sprintf('IMF%d Time series',i))

    y = fft(x); % Fast Fourier Transform
    y = abs(y.^2); % raw power spectrum density
    y = y(1:1+length(x)/2); % half-spectrum
    [v,k] = max(y); % find maximum
    f_scale = (0:length(x)/2)* Fs/length(x); % frequency scale
    nexttile(2);
    stem(f_scale, y),axis('tight'),grid('on'),title('Single-Sided power spectrum')
end
%RES
x = res(:,1) ; % time series
x = x - mean(x);                                            % <= ADDED LINE
figure, T = tiledlayout(1,2,'TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
plot(t,x), axis('tight'), grid('on'), title('Residual Time series')

y = fft(x); % Fast Fourier Transform
y = abs(y.^2); % raw power spectrum density
y = y(1:1+length(x)/2); % half-spectrum
[v,k] = max(y); % find maximum
f_scale = (0:length(x)/2)* Fs/length(x); % frequency scale
nexttile(2);
stem(f_scale, y),axis('tight'),grid('on'),title('Single-Sided power spectrum')

%Plot VMD2 time series and its fft
[imf1,res1] = vmd(imf(:,1)','NumIMFs',3);
for i = 1:3
    x = imf1(:,i) ; % time series
    x = x - mean(x);                                            % <= ADDED LINE
    figure, T = tiledlayout(1,2,'TileSpacing','tight','Padding','tight');%3,4
    nexttile(1);
    plot(t,x), axis('tight'), grid('on'), title(sprintf('IMF%d(IMF1) Time series',i))

    y = fft(x); % Fast Fourier Transform
    y = abs(y.^2); % raw power spectrum density
    y = y(1:1+length(x)/2); % half-spectrum
    [v,k] = max(y); % find maximum
    f_scale = (0:length(x)/2)* Fs/length(x); % frequency scale
    nexttile(2);
    stem(f_scale, y),axis('tight'),grid('on'),title('Single-Sided power spectrum')
end
%RES
x = res1(:,1) ; % time series
x = x - mean(x);                                            % <= ADDED LINE
figure, T = tiledlayout(1,2,'TileSpacing','tight','Padding','tight');%3,4
nexttile(1);
plot(t,x), axis('tight'), grid('on'), title('Residual(IMF1) Time series')

y = fft(x); % Fast Fourier Transform
y = abs(y.^2); % raw power spectrum density
y = y(1:1+length(x)/2); % half-spectrum
[v,k] = max(y); % find maximum
f_scale = (0:length(x)/2)* Fs/length(x); % frequency scale
nexttile(2);
stem(f_scale, y),axis('tight'),grid('on'),title('Single-Sided power spectrum')

%% Cross Correlation to identify optimal wavelet mother
%- read data 
clear
clc
len = 30 + 7; %30 days + 1 day
hrz = 7;
LOC = 'Utqiagvik';
numberIMFs = 42; %[31 63 127 255];

load(strcat('VMD_T2_',LOC,'.mat'))

% fprintf('Location: %s\n',LOC)
% switch true
%     case strcmp(LOC, 'Nome')
%         loc_r = 125;
%         loc_c = 100;
% 
%     case strcmp(LOC, 'Bethel')
%         loc_r = 147;
%         loc_c = 105;
% 
%     case strcmp(LOC, 'Utqiagvik')
%         loc_r = 91;
%         loc_c = 123;
% end
% 
% fprintf('-Processing data for %d forecasting horizons!\n',len-30);
% [~,T2] = T2_ForecastData_preprocessing(loc_r,loc_c,len);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %- VMD T2 decomposition
% clear x
% for i = 0:len
%     x{i+1} = 'Element'+string(i);
% end
% fprintf('*Extracting VMD features using %d IMFs..\n',numberIMFs);
% VMD = table('Size',[length(T2)*(numberIMFs+1),1+len],'VariableNames',string(x),'VariableTypes','double'+strings(1,length(x)));%,'',{'single','double','double','double','double','double','double','double','double','double','double','double','double','double'});
% VMD.Properties.VariableNames{1}='SequenceNumber';
% TEMT2=ones(length(T2)*(numberIMFs+1),1+len);
% for i = 1:1:length(T2)
%     [imf,res] = vmd(T2(i,:),'NumIMFs',numberIMFs);
%     TEMT2(i+(numberIMFs)*(i-1):i+(numberIMFs)*(i-1)+(numberIMFs),:) = [ones(numberIMFs+1,1)*i,[imf';res']];%
% end
% VMD_T2 = TEMT2;%array2table(TEMT2,'VariableNames',string(x));
% fprintf('finished!\n');
% clear TEMT2 len  loc i x
% 

%-WT decompositions of VMD Q2
numberWTdecomps = 3;
K = 42;
wmother = {'db','sym','coif'};
L = numberWTdecomps;

% I = T2(:,1:30);
% valueWT = zeros(length(I),L+1,2);
for i = 1:length(wmother)
    switch wmother{i}
        case 'db'
            wL = 20;
        case 'sym'
            wL = 20;
        case 'coif'
            wL = 5;
    end
    for l = 1:wL
        wav = strcat(wmother{i},num2str(l));
        valueWT = zeros(L+1,K+1);
        fprintf('*%s: ',wav);
        for k = 1:K+1 %k is IMF number
%             fprintf(' -IMF%d, ',k);
            I = modwt(VMD_T2(k:K*k:end,2:31),wav,L);
            for j = 1:L+1
                tmp = I(j,:,:);
                z = size(tmp);
                squeezed = reshape(tmp,[z(2:end) 1]);
%                 valueWT(j,k) = mean(mean(corr(squeezed,VMD_T2(k:K*k:end,32:end),'Type','Spearman')));
                for o=1:length(VMD_T2(k:K*k:end,32:end))
                    temp(o) = mean(xcorr(squeezed(o,:),VMD_T2(o,32:end)));%,'Type','Spearman'
                end
                valueWT(j,k) = mean(temp);
            end
        end
        fprintf('%.3f\n',mean(mean(valueWT)));
    end
end

