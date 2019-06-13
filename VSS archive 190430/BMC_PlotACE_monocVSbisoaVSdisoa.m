%% BMC_PlotACE
clear
close all


corticaldepth = (1.2:-0.1:-0.5);
pre = 100;
post = 800;
TM = -pre:1:post;



%% load
% load and create structures based on conditions
cd('E:\LaCie\VSS 2019 figs\190429 figs post MC meeting\filteredMatVar')
    biNOsoaPS	= load('biPSNOsoafiltered.mat');
    diNOsoa     = load('dicopNOsoafiltered.mat');

    biWsoaPS    = load('biPSWsoafiltered.mat');
    diWsoaPS    = load('dichopWsoa_fullTrialPSfiltered.mat');
%% process

cutACE.biWsoaPS     = biWsoaPS.ACE(38:55,:); 
cutACE.diWsoaPS     = diWsoaPS.ACE(38:55,:);

%% Compare Sink Lineplots,
% cutACE row 13 is sink bottom, cortical depth of 0
% cutACE row 12 is also the sink(??), cortical depth of 0.1

sinkAvg.biWsoaPS	= mean(cutACE.biWsoaPS(12:13,:),1); 
sinkAvg.diWsoaPS     = mean(cutACE.diWsoaPS(12:13,:),1);

sinkBtm.biWsoaPS	= cutACE.biWsoaPS(13,:); 
sinkBtm.diWsoaPS     = cutACE.diWsoaPS(13,:);


%% plot postSOA timecourse

postSOASinkAvg.biWsoaPS = sinkAvg.biWsoaPS(:,800:1700);
postSOASinkAvg.diWsoaPS = sinkAvg.diWsoaPS(:,800:1700);

monocPS = sinkAvg.biWsoaPS(:,1:901);

% plot sinkAvg
figure
    plot(TM,postSOASinkAvg.biWsoaPS,'DisplayName','biWsoaPS','color',[123,50,148]/255)
    hold on
    plot(TM,postSOASinkAvg.diWsoaPS,'DisplayName','diWsoaPS','color',[0,136,55]/255)
    hold on
    plot(TM,monocPS,'DisplayName','monocPS','color','k')
    hold on
    
    

    vline(0)
    hline(0)
    legend('Location','best')
    title('monocVSsoa...FilteredData')
