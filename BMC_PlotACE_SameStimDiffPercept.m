%% BMC_PlotACE 
%Same Stim Different Percept
% SSDP
% compares diNOsoa vs diWsoaPS
clear
% close all

% % % ylimit = [-6500 2000];
pre = 100;
post = 1600;
TM = [-pre:1:post];
AnalyzeSink = 'lower'; % 'lower' or 'upper'

color.biNOsoa = [5,113,176]/255; % light purple
color.diNOsoa = [202,0,32]/255;% light green
color.biWsoa = [123,50,148]/255 ; %dark purple
color.diWsoa = [0,136,55]/255; %dark green


% load and create structures based on conditions
cd('E:\LaCie\VSS 2019 figs\190429 figs post MC meeting\filteredMatVar')
    biNOsoaPS	= load('biPSNOsoafiltered.mat');
    diNOsoa     = load('dicopNOsoafiltered.mat');

    biWsoaPS    = load('biPSWsoafiltered.mat');
    diWsoaPS    = load('dichopWsoa_fullTrialPSfiltered.mat');


cutAllCSDaligned.biNOsoaPS	= biNOsoaPS.AllCSDaligned(38:55,:,:);
cutAllCSDaligned.diNOsoa      = diNOsoa.AllCSDaligned(38:55,:,:);  
cutAllCSDaligned.biWsoaPS     = biWsoaPS.AllCSDaligned(38:55,:,:); 
cutAllCSDaligned.diWsoaPS     = diWsoaPS.AllCSDaligned(38:55,:,:);

%% Compare Sink Lineplots,
% cutACE row 13 is sink bottom, cortical depth of 0
% cutACE row 12 is also the sink(??), cortical depth of 0.1
switch AnalyzeSink
    case 'lower'
        sinkAllCSDaligned.biNOsoaPS	= cutAllCSDaligned.biNOsoaPS(12:13,:,:);
        sinkAllCSDaligned.diNOsoa     = cutAllCSDaligned.diNOsoa(12:13,:,:);  
        sinkAllCSDaligned.biWsoaPS	= cutAllCSDaligned.biWsoaPS(12:13,:,:); 
        sinkAllCSDaligned.diWsoaPS     = cutAllCSDaligned.diWsoaPS(12:13,:,:); 
        
        
        
        for i = 1:size(sinkAllCSDaligned.biNOsoaPS,3)
           sinkAvgAllCSDaligned.biNOsoaPS(i,:) = mean(sinkAllCSDaligned.biNOsoaPS(1:2,:,i),1);
           sinkAvgAllCSDaligned.diNOsoa(i,:) = mean(sinkAllCSDaligned.diNOsoa(1:2,:,i),1);
           sinkAvgAllCSDaligned.biWsoaPS(i,:) = mean(sinkAllCSDaligned.biWsoaPS(1:2,:,i),1);
           sinkAvgAllCSDaligned.diWsoaPS(i,:) = mean(sinkAllCSDaligned.diWsoaPS(1:2,:,i),1);
        end        
        titletext = {'CSD of lower sink. Cortical depth of 0 & 0.1 averaged.',' dichoptic simultaneous vs dichoptic with soa.',' Same stimulus different percept.'};
        
    case 'upper'
        sinkAvgAllCSDaligned.biNOsoaPS	= squeeze(cutAllCSDaligned.biNOsoaPS(6,:,:))';
        sinkAvgAllCSDaligned.diNOsoa     = squeeze(cutAllCSDaligned.diNOsoa(6,:,:))';  
        sinkAvgAllCSDaligned.biWsoaPS	= squeeze(cutAllCSDaligned.biWsoaPS(6,:,:))'; 
        sinkAvgAllCSDaligned.diWsoaPS     = squeeze(cutAllCSDaligned.diWsoaPS(6,:,:))';  
        titletext = {'CSD of upper sink. Cortical depth of 0.7.',' dichoptic simultaneous vs dichoptic with soa.',' Same stimulus different percept.'};
end



%% Process

% Pull out timecourse
postStimSink.diNOsoa = sinkAvgAllCSDaligned.diNOsoa(:,1:901);
postStimSink.diWsoaPS = sinkAvgAllCSDaligned.diWsoaPS(:,801:1701);

%bl average each session
    % 3.h. baseline subtract (Chan x timepoints)
    bl = pre-50:pre-1;
    for g = 1:size(postStimSink.diNOsoa,1)
        blofChan = nanmean(postStimSink.diNOsoa(g,bl),2);
        blSink.diNOsoa(g,:) = (postStimSink.diNOsoa(g,:)-blofChan); 
    end
    
    for h = 1:size(postStimSink.diWsoaPS,1)
        blofChan = nanmean(postStimSink.diWsoaPS(h,bl),2);
        blSink.diWsoaPS(h,:) = (postStimSink.diWsoaPS(h,:)-blofChan); 
    end

% Mean across trials
AVG.diNOsoa = mean(blSink.diNOsoa,1);
AVG.diWsoaPS = mean(blSink.diWsoaPS,1);

% bootci across trials
ci.diNOsoa = bootci(4000,@mean,postStimSink.diNOsoa);
ci.diWsoaPS = bootci(4000,@mean,postStimSink.diWsoaPS);



%% plot postSOA timecourse

postStimTM = -100:1:800;


% plot sinkAvg
h = figure;
    plot(postStimTM,ci.diNOsoa(1,:),':','color',color.diNOsoa,'LineWidth',1); hold on
    plot(postStimTM,ci.diNOsoa(2,:),':','color',color.diNOsoa,'LineWidth',1); hold on
    b = plot(postStimTM,AVG.diNOsoa,'color',color.diNOsoa,'DisplayName','diNOsoa');
    hold on
    plot(postStimTM,ci.diWsoaPS(1,:),':','color',color.diWsoa,'LineWidth',1); hold on
    plot(postStimTM,ci.diWsoaPS(2,:),':','color',color.diWsoa,'LineWidth',1); hold on
    d = plot(postStimTM,AVG.diWsoaPS,'color',color.diWsoa,'DisplayName','diWsoaPS');

% % %     ylim(ylimit)
    title(titletext)
    subset = [b d];
    vline(0)
    hline(0)
    legend(subset,'Location','best')
    box off
    ax = gca;
    ax.YRuler.Exponent = 0;

% % %     
% % %     
% % %  cd('E:\LaCie\VSS 2019 figs\190508 Draft 7 figs')  
% % % savefig(h,strcat('SSDP_',AnalyzeSink))
% % % saveas(h,strcat('SSDP_',AnalyzeSink),'svg')