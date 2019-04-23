


% 6.establish cortical depth
corticaldepth = (1.2:-0.1:-0.5);
TM = [-pre:1:post];
condition = 'NO soa';


% 7. Plot
figure
    % 7.a. lineplot
    subplot(1,2,1)
    f_ShadedLinePlotbyDepth(cutACE_NOsoa,corticaldepth,TM,[],1)
    title(condition,'interpreter','none')
    set(gcf,'Position',[1 40 700 1200]); 
    
    % 7.b. filterplot
    CSDf = filterCSD(cutACE_NOsoa);
    subplot(1,2,2)
    imagesc(TM,corticaldepth,CSDf); colormap(flipud(jet));
    climit = max(abs(get(gca,'CLim'))*.8);
    set(gca,'CLim',[-3160.1 3160.1],'ydir','normal','Box','off','TickDir','out')
    hold on;
    plot([0 0], ylim,'k')
    yticks(1.2:.2:-.5)
    c = colorbar;
    