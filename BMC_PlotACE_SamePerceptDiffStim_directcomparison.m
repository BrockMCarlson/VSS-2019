%% BMC_PlotACE 
%Same Percept Different Stim
% SPDS
% compares monocPS vs biWsoaPS vs diWsoaPS
clear

ylimit = [-5000 2000];

pre = 100;
post = 1600;
TM = [-pre:1:post];
AnalyzeSink = 'lower'; % 'lower' or 'upper'


color.biNOsoa = [5,113,176]/255; % blue
color.diNOsoa = [202,0,32]/255;% red
color.biWsoa = [123,50,148]/255 ; %dark purple
color.diWsoa = [0,136,55]/255; %dark green




% load and create structures based on conditions
cd('G:\LaCie\VSS 2019 figs\190429 figs post MC meeting\filteredMatVar')
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
        titletext = {'CSD of lower sink. Cortical depth of 0 & 0.1 averaged.','monoc Vs binocular PS flash Vs dichoptic PS flash.',' Same percept different stim.'};
        
    case 'upper'
        sinkAvgAllCSDaligned.biNOsoaPS	= squeeze(cutAllCSDaligned.biNOsoaPS(6,:,:))';
        sinkAvgAllCSDaligned.diNOsoa     = squeeze(cutAllCSDaligned.diNOsoa(6,:,:))';  
        sinkAvgAllCSDaligned.biWsoaPS	= squeeze(cutAllCSDaligned.biWsoaPS(6,:,:))'; 
        sinkAvgAllCSDaligned.diWsoaPS     = squeeze(cutAllCSDaligned.diWsoaPS(6,:,:))';  
        titletext = {'CSD of upper sink. Cortical depth of 0.7 averaged.','monoc Vs binocular PS flash Vs dichoptic PS flash.',' Same percept different stim.'};      
        
end

%mean acros trials
AVG.biNOsoaPS = mean(sinkAvgAllCSDaligned.biNOsoaPS,1);
AVG.diNOsoa = mean(sinkAvgAllCSDaligned.diNOsoa,1);
AVG.biWsoaPS = mean(sinkAvgAllCSDaligned.biWsoaPS,1);
AVG.diWsoaPS = mean(sinkAvgAllCSDaligned.diWsoaPS,1);

%bootci across trial
ci.biNOsoaPS = bootci(4000,@mean,sinkAvgAllCSDaligned.biNOsoaPS);
ci.diNOsoa = bootci(4000,@mean,sinkAvgAllCSDaligned.diNOsoa);
ci.biWsoaPS = bootci(4000,@mean,sinkAvgAllCSDaligned.biWsoaPS);
ci.diWsoaPS = bootci(4000,@mean,sinkAvgAllCSDaligned.diWsoaPS);








%% Process

% Pull out timecourse
postStimSink.monocularPS	= sinkAvgAllCSDaligned.biWsoaPS(:,1:901);
postStimSink.biWsoaPS       = sinkAvgAllCSDaligned.biWsoaPS(:,801:1701);
postStimSink.diWsoaPS       = sinkAvgAllCSDaligned.diWsoaPS(:,801:1701);

%bl average each session
    bl = pre-50:pre-1;
    for f = 1:size(postStimSink.monocularPS,1)
        blofChan = nanmean(postStimSink.monocularPS(f,bl),2);
        blSink.monocularPS(f,:) = (postStimSink.monocularPS(f,:)-blofChan); 
    end
    for h = 1:size(postStimSink.biWsoaPS,1)
        blofChan = nanmean(postStimSink.biWsoaPS(h,bl),2);
        blSink.biWsoaPS(h,:) = (postStimSink.biWsoaPS(h,:)-blofChan); 
    end
    for h = 1:size(postStimSink.diWsoaPS,1)
        blofChan = nanmean(postStimSink.diWsoaPS(h,bl),2);
        blSink.diWsoaPS(h,:) = (postStimSink.diWsoaPS(h,:)-blofChan); 
    end
    
% Mean across trials
AVG.monocularPS = mean(blSink.monocularPS,1);
AVG.biWsoaPS = mean(blSink.biWsoaPS,1);
AVG.diWsoaPS = mean(blSink.diWsoaPS,1);

% bootci across trials
ci.monocularPS = bootci(4000,@mean,postStimSink.monocularPS);
ci.biWsoaPS = bootci(4000,@mean,postStimSink.biWsoaPS);
ci.diWsoaPS = bootci(4000,@mean,postStimSink.diWsoaPS);

%% plot postSOA timecourse

postStimTM = -100:1:800;

% plot sinkAvg
h = figure;
    m = plot(postStimTM,AVG.monocularPS,'color','k','DisplayName','monocular');
    hold on
%     plot(postStimTM,ci.monocularPS(1,:),'color','k',':')
%     hold on
    a = plot(postStimTM,AVG.biWsoaPS,'color',color.biWsoa,'DisplayName','biWsoaPS');
    hold on
    d = plot(postStimTM,AVG.diWsoaPS,'color',color.diWsoa,'DisplayName','diWsoaPS');

    ylim(ylimit)
    subset = [m a d];
    vline(0)
    hline(0)
    legend(subset,'Location','best')
    title(titletext)
    box off
    ax = gca;
    ax.YRuler.Exponent = 0;

  
%     
% 
% cd('E:\LaCie\VSS 2019 figs\190508 Draft 7 figs')  
% savefig(h,strcat('SPDS_',AnalyzeSink))
% saveas(h,strcat('SPDS_',AnalyzeSink),'svg')
