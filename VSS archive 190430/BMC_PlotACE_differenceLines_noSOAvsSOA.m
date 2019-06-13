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

aligned.biNOsoaPS = biNOsoaPS.AllCSDaligned;
aligned.diNOsoa = diNOsoa.AllCSDaligned;
aligned.biWsoaPS = biWsoaPS.AllCSDaligned;
aligned.diWsoaPS = diWsoaPS.AllCSDaligned;

for i = 1:8
   cutAligned.biNOsoaPS(:,:,i) = aligned.biNOsoaPS(38:55,:,i);
   cutAligned.diNOsoa(:,:,i) = aligned.diNOsoa(38:55,:,i);
   cutAligned.biWsoaPS(:,:,i) = aligned.biWsoaPS(38:55,:,i);
   cutAligned.diWsoaPS(:,:,i) = aligned.diWsoaPS(38:55,:,i);
   
end


% cutACE row 13 is sink bottom, cortical depth of 0
% cutACE row 12 is also the sink(??), cortical depth of 0.1
for j = 1:8 % result is (sessions x CSD at 1701 timepoints)
   sinkAvgAligned.fulltime.biNOsoaPS(j,:)	= mean(cutAligned.biNOsoaPS(12:13,:,j),1); 
   sinkAvgAligned.fulltime.diNOsoa(j,:)	= mean(cutAligned.diNOsoa(12:13,:,j),1); 
   sinkAvgAligned.fulltime.biWsoaPS(j,:)	= mean(cutAligned.biWsoaPS(12:13,:,j),1); 
   sinkAvgAligned.fulltime.diWsoaPS(j,:)	= mean(cutAligned.diWsoaPS(12:13,:,j),1); 
    
end

for k = 1:8 % result is (sessions x CSD at 1701 timepoints)
   sinkAvgAligned.NOsoa.biNOsoaPS(k,:)	= sinkAvgAligned.fulltime.biNOsoaPS(k,1:901); 
   sinkAvgAligned.NOsoa.diNOsoa(k,:)	= sinkAvgAligned.fulltime.diNOsoa(k,1:901);
end

for k = 1:8 % result is (sessions x CSD at 1701 timepoints)
   sinkAvgAligned.Wsoa.biWsoaPS(k,:)	= sinkAvgAligned.fulltime.biWsoaPS(k,800:1700); 
   sinkAvgAligned.Wsoa.diWsoaPS(k,:)	= sinkAvgAligned.fulltime.diWsoaPS(k,800:1700);
end

for m = 1:8
    difference.NOsoa(m,:) = sinkAvgAligned.NOsoa.biNOsoaPS(m,:) - sinkAvgAligned.NOsoa.diNOsoa(m,:);
end
for n = 1:8
    difference.Wsoa(n,:) = sinkAvgAligned.Wsoa.biWsoaPS(n,:) - sinkAvgAligned.Wsoa.diWsoaPS(n,:);
end

difference.avg.NOsoa = mean(difference.NOsoa,1);
difference.avg.Wsoa = mean(difference.Wsoa,1);



%% plot difference

% plot sinkAvg
figure
    plot(TM,difference.avg.NOsoa,'DisplayName','NO soa','color','k')
    hold on
    plot(TM,difference.avg.Wsoa,'DisplayName','W soa','color','r')


    vline(0)
    hline(0)
    legend('Location','best')
    title('difference...filteredData')
