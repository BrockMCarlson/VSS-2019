% % test
% 
% for i = 1:8 
%    sb(i) = meanOfWindow.d.simultBi(i)- meanOfWindow.d.stimulDi(i);
%    numbersToOperate(i,:) = [meanOfWindow.d.simultBi(i) meanOfWindow.d.stimulDi(i)];
%    ad(i) = meanOfWindow.d.simultBi(i)+ meanOfWindow.d.stimulDi(i);
%    idx(i) = sb(i)/ad(i);
%     
% end


figure
for i = 1:8
    plot(blWin1.biNOsoaPS(i,800:1500))
    hold on
    legend
end
title('biNOsoaPS')
figure
for i = 1:8
    plot(blWin1.diNOsoa(i,800:1500))
    hold on
    legend
end
title('diNOsoa')
figure
for i = 1:8
    plot(blWin2.biWsoaPS(i,stimtm2+250:stimtm2+300))
    hold on
    legend
end
title('biWsoaPS')
figure
for i = 1:8
    plot(blWin2.diWsoaPS(i,stimtm2+250:stimtm2+300))
    hold on
    legend
end
title('diWsoaPS')





figure
plot(mean(blWin2.biWsoaPS(:,stimtm2+250:stimtm2+300),1))
hold on
plot(mean(blWin2.diWsoaPS(:,stimtm2+250:stimtm2+300),1))
legend

figure
for i = 1:8
plot(blWin2.diWsoaPS(i,stimtm2+50:stimtm2+350))
hold on
end




((-800 - -1200) / abs(-1200))*100
figure

