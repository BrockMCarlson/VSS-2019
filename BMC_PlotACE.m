%% BMC_PlotACE
clear



corticaldepth = (1.2:-0.1:-0.5);
pre = 100;
post = 1600;
TM = -pre:1:post;

titletxt.biNOsoaPS = 'Binocular PS gratings presented w/o SOA...Filtered';
titletxt.diNOsoa = 'Dichoptic gratings presented w/o SOA...Filtered';
titletxt.biWsoaPS = 'Binocular PS gratings presented w/ 800ms SOA...Filtered';
titletxt.diWsoaPS = 'Dichoptic gratings presented w/ 800ms SOA.NPS adapted.PS is flashed...Filtered.';

% % % % load and create structures based on conditions
% % % cd('E:\LaCie\VSS 2019 figs\190429 figs post MC meeting\filteredMatVar')
% % %     biNOsoaPS	= load('biPSNOsoafiltered.mat');
% % %     diNOsoa     = load('dicopNOsoafiltered.mat');
% % % 
% % %     biWsoaPS    = load('biPSWsoafiltered.mat');
% % %     diWsoaPS    = load('dichopWsoa_fullTrialPSfiltered.mat');


cd('G:\LaCie\VSS 2019 figs\190429 figs post MC meeting\filteredMatVar')
    biNOsoaPS	= load('biPSNOsoafiltered.mat');
    diNOsoa     = load('dicopNOsoafiltered.mat');

cd('G:\LaCie\VSS 2019 figs\190506 RoughDraft2')
    biWsoaPS    = load('dbck_biWsoa.mat');
    diWsoaPS    = load('dbck_diWsoa.mat');
    
cutACE.biNOsoaPS	= biNOsoaPS.ACE(38:55,:);
cutACE.diNOsoa      = diNOsoa.ACE(38:55,:);  
cutACE.biWsoaPS     = biWsoaPS.ACE(38:55,:); 
cutACE.diWsoaPS     = diWsoaPS.ACE(38:55,:);

CSDf.biNOsoaPS  = filterCSD(cutACE.biNOsoaPS);
CSDf.diNOsoa    = filterCSD(cutACE.diNOsoa);
CSDf.biWsoaPS   = filterCSD(cutACE.biWsoaPS);
CSDf.diWsoaPS   = filterCSD(cutACE.diWsoaPS);

cmax(1) = max(max(abs(CSDf.biNOsoaPS)));
cmax(2) = max(max(abs(CSDf.diNOsoa)));
cmax(3) = max(max(abs(CSDf.biWsoaPS)));
cmax(4) = max(max(abs(CSDf.diWsoaPS)));
climit = max(cmax)*.8;


%% Plot
%1.     .biNOsoaPS
figure
    % 7.a. lineplot
% %     subplot(1,2,1)
% %     f_ShadedLinePlotbyDepth(cutACE.biNOsoaPS,corticaldepth,TM,[],1)
% %     title(titletxt.biNOsoaPS,'interpreter','none');
% %     set(gcf,'Position',[1 40 700 1200]); 
% %     v = vline(800); set(v,'linewidth',2,'color','k','linestyle',':');
% %     
% % % % %     % 7.b. filterplot
% % % % %     subplot(1,2,2)
    imagesc(TM,corticaldepth,CSDf.biNOsoaPS); colormap(flipud(jet));
    % % %     climit = max(abs(get(gca,'CLim'))*.8);
    set(gca,'CLim',[-climit climit],'ydir','normal','Box','off','TickDir','out')
    hold on;
        title(titletxt.biNOsoaPS,'interpreter','none');

    plot([0 0], ylim,'k')
    yticks(1.2:.2:-.5)
    c = colorbar;
    
% 2.   .diNOsoa 
 figure(2)
% % %     subplot(1,2,1)
% % %     f_ShadedLinePlotbyDepth(cutACE.diNOsoa,corticaldepth,TM,[],1)
% % %     title(titletxt.diNOsoa,'interpreter','none');
% % %     set(gcf,'Position',[1 40 700 1200]); 
% % %     v = vline(800); set(v,'linewidth',2,'color','k','linestyle',':');
% % %     
% % %     % 7.b. filterplot
% % %     subplot(1,2,2)
    imagesc(TM,corticaldepth,CSDf.diNOsoa); colormap(flipud(jet));
    % % %     climit = max(abs(get(gca,'CLim'))*.8);
    set(gca,'CLim',[-climit climit],'ydir','normal','Box','off','TickDir','out')
    hold on;
            title(titletxt.diNOsoa,'interpreter','none');

    plot([0 0], ylim,'k')
    yticks(1.2:.2:-.5)
    c = colorbar;
    

% 3.   .biWsoaPS 
figure(3)
% %     subplot(1,2,1)
% %     f_ShadedLinePlotbyDepth(cutACE.biWsoaPS,corticaldepth,TM,[],1)
% %     title(titletxt.biWsoaPS,'interpreter','none');
% %     set(gcf,'Position',[1 40 700 1200]); 
% %     v = vline(800); set(v,'linewidth',2,'color','k','linestyle',':');
% %     
% %     % 7.b. filterplot
% %     subplot(1,2,2)
    imagesc(TM,corticaldepth,CSDf.biWsoaPS); colormap(flipud(jet));
    % % %     climit = max(abs(get(gca,'CLim'))*.8);
    set(gca,'CLim',[-climit climit],'ydir','normal','Box','off','TickDir','out')
    hold on;
        title(titletxt.biWsoaPS,'interpreter','none')

    plot([0 0], ylim,'k')
    yticks(1.2:.2:-.5)
    c = colorbar;
    v = vline(800); set(v,'linewidth',2,'color','k','linestyle',':');
    

% 4.   .diWsoaPS 
figure(4)
% %     subplot(1,2,1)
% %     f_ShadedLinePlotbyDepth(cutACE.diWsoaPS,corticaldepth,TM,[],1)
% %     title(titletxt.diWsoaPS,'interpreter','none');
% %     set(gcf,'Position',[1 40 700 1200]); 
% %     v = vline(800); set(v,'linewidth',2,'color','k','linestyle',':');
% %     
% %     % 7.b. filterplot
% %     subplot(1,2,2)
    imagesc(TM,corticaldepth,CSDf.diWsoaPS); colormap(flipud(jet));
    % % %     climit = max(abs(get(gca,'CLim'))*.8);
    set(gca,'CLim',[-climit climit],'ydir','normal','Box','off','TickDir','out')
    hold on;
        title(titletxt.diWsoaPS,'interpreter','none');

    plot([0 0], ylim,'k')
    yticks(1.2:.2:-.5)
    c = colorbar;
    v = vline(800); set(v,'linewidth',2,'color','k','linestyle',':');
    
%% Compare Sink Lineplots,
% cutACE row 13 is sink bottom, cortical depth of 0
% cutACE row 12 is also the sink(??), cortical depth of 0.1

% upper sink at cortical depth of .7-.8, which is cutAce 6-5
sinkAvg.biNOsoaPS	= mean(cutACE.biNOsoaPS(12:13,:),1);
sinkAvg.diNOsoa     = mean(cutACE.diNOsoa(12:13,:),1);  
sinkAvg.biWsoaPS	= mean(cutACE.biWsoaPS(12:13,:),1); 
sinkAvg.diWsoaPS     = mean(cutACE.diWsoaPS(12:13,:),1);

upperSinkAvg.biNOsoaPS	= mean(cutACE.biNOsoaPS(5:6,:),1);
upperSinkAvg.diNOsoa     = mean(cutACE.diNOsoa(5:6,:),1);  
upperSinkAvg.biWsoaPS	= mean(cutACE.biWsoaPS(5:6,:),1); 
upperSinkAvg.diWsoaPS     = mean(cutACE.diWsoaPS(5:6,:),1);

upperSinkBtm.biNOsoaPS	= cutACE.biNOsoaPS(6,:);
upperSinkBtm.diNOsoa     = cutACE.diNOsoa(6,:);  
upperSinkBtm.biWsoaPS	= cutACE.biWsoaPS(6,:); 
upperSinkBtm.diWsoaPS     = cutACE.diWsoaPS(6,:);

upperSinkTop.biNOsoaPS	= cutACE.biNOsoaPS(5,:);
upperSinkTop.diNOsoa     = cutACE.diNOsoa(5,:);  
upperSinkTop.biWsoaPS	= cutACE.biWsoaPS(5,:); 
upperSinkTop.diWsoaPS     = cutACE.diWsoaPS(5,:);



% plot sinkAvg
figure(5)
    plot(TM,upperSinkAvg.biNOsoaPS,'LineWidth',1,'DisplayName','biNOsoaPS')
    hold on
    plot(TM,upperSinkAvg.diNOsoa,'LineWidth',1,'DisplayName','diNOsoa')
    hold on
    plot(TM,upperSinkAvg.biWsoaPS,'LineWidth',1,'DisplayName','biWsoaPS')
    hold on
    plot(TM,upperSinkAvg.diWsoaPS,'LineWidth',1,'DisplayName','diWsoaPS')
    
    vline(0)
    hline(0)
    vline(800)
    legend('Location','best')
    title('CSD of Upper sinkAvg. Cortical depth of .7 and .8 averaged...FilteredData')
    
figure(6)
    plot(TM,upperSinkBtm.biNOsoaPS,'LineWidth',1,'DisplayName','biNOsoaPS')
    hold on
    plot(TM,upperSinkBtm.diNOsoa,'LineWidth',1,'DisplayName','diNOsoa')
    hold on
    plot(TM,upperSinkBtm.biWsoaPS,'LineWidth',1,'DisplayName','biWsoaPS')
    hold on
    plot(TM,upperSinkBtm.diWsoaPS,'LineWidth',1,'DisplayName','diWsoaPS')
    
    vline(0)
    hline(0)
    vline(800)
    legend('Location','best')
    title('CSD of Upper sinkbtm. Cortical depth of .7 ...FilteredData')

figure(7)
    plot(TM,upperSinkTop.biNOsoaPS,'LineWidth',1,'DisplayName','biNOsoaPS')
    hold on
    plot(TM,upperSinkTop.diNOsoa,'LineWidth',1,'DisplayName','diNOsoa')
    hold on
    plot(TM,upperSinkTop.biWsoaPS,'LineWidth',1,'DisplayName','biWsoaPS')
    hold on
    plot(TM,upperSinkTop.diWsoaPS,'LineWidth',1,'DisplayName','diWsoaPS')
    
    vline(0)
    hline(0)
    vline(800)
    legend('Location','best')
    title('CSD of Upper sinkTop. Cortical depth of .8 ...FilteredData')
    
figure(8)
    plot(TM,sinkAvg.biNOsoaPS,'LineWidth',1,'DisplayName','biNOsoaPS')
    hold on
    plot(TM,sinkAvg.diNOsoa,'LineWidth',1,'DisplayName','diNOsoa')
    hold on
    plot(TM,sinkAvg.biWsoaPS,'LineWidth',1,'DisplayName','biWsoaPS')
    hold on
    plot(TM,sinkAvg.diWsoaPS,'LineWidth',1,'DisplayName','diWsoaPS')
    
    vline(0)
    hline(0)
    vline(800)
    legend('Location','best')
    title('CSD of lower?? sinkAvg.')
    

    





