%% BMC_PlotACE_SinkAllCondFullTimecourse
%FTC
clear


pre = 100;
post = 800;
TM = [-pre:1:post];
AnalyzeSink = 'upper'; % 'lower' or 'upper'

clrA = [5,113,176]/255; % blue
clrB = [202,0,32]/255;% red
clrC = [123,50,148]/255 ;
clrD = [0,136,55]/255;




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
        titletext = 'CSD of lower sink. Cortical depth of 0 and 0.1 averaged';
    case 'upper'
        sinkAvgAllCSDaligned.biNOsoaPS	= squeeze(cutAllCSDaligned.biNOsoaPS(6,:,:))';
        sinkAvgAllCSDaligned.diNOsoa     = squeeze(cutAllCSDaligned.diNOsoa(6,:,:))';  
        sinkAvgAllCSDaligned.biWsoaPS	= squeeze(cutAllCSDaligned.biWsoaPS(6,:,:))'; 
        sinkAvgAllCSDaligned.diWsoaPS     = squeeze(cutAllCSDaligned.diWsoaPS(6,:,:))';  
        titletext = 'CSD of upper sink. Cortical depth of .7 ';
        
end

%mean acros trials
AVG.biNOsoaPS = mean(sinkAvgAllCSDaligned.biNOsoaPS,1);
AVG.diNOsoa = mean(sinkAvgAllCSDaligned.diNOsoa,1);
AVG.biWsoaPS = mean(sinkAvgAllCSDaligned.biWsoaPS,1);
AVG.diWsoaPS = mean(sinkAvgAllCSDaligned.diWsoaPS,1);


PostStim.BCnosoa = AVG.biNOsoaPS(1:901);
PostStim.BICnosoa = AVG.diNOsoa(1:901);
PostStim.BCsoa = AVG.biWsoaPS(801:1701);
PostStim.BICsoa = AVG.diWsoaPS(801:1701);

    bl = pre-50:pre-1;
    for f = 1:size(PostStim.BCsoa,1)
        blofChan = nanmean(PostStim.BCsoa(f,bl),2);
        PostStim.BCsoa(f,:) = (PostStim.BCsoa(f,:)-blofChan); 
    end
    for h = 1:size(PostStim.BICsoa,1)
        blofChan = nanmean(PostStim.BICsoa(h,bl),2);
        PostStim.BICsoa(h,:) = (PostStim.BICsoa(h,:)-blofChan); 
    end




%% Plot

% plot sinkAvg
figure
subplot(2,1,1)
   a =  plot(TM,PostStim.BCnosoa,'color',clrA,'DisplayName','biNOsoaPS');
    hold on
    b = plot(TM,PostStim.BICnosoa,'color',clrB,'DisplayName','diNOsoa');

    ylim([-6500 4000])
    box off
    subset = [a b];
    vline(0)
    hline(0)
    vline(800)
    legend(subset,'Location','best')
    title(titletext)

subplot(2,1,2)
    c = plot(TM,PostStim.BCsoa,'color',clrC,'DisplayName','biWsoaPS');
    hold on
    d = plot(TM,PostStim.BICsoa,'color',clrD,'DisplayName','diWsoaPS');

    ylim([-6500 4000])
    box off
    subset = [c d];
    vline(0)
    hline(0)
    vline(800)
    legend(subset,'Location','best')
    title(titletext)
    
    cd('E:\LaCie\VSS 2019 figs\190512 Draft 10')

