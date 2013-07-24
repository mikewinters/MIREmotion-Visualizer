function gomezplotview

load gomezprofs

notes = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};

figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:12 % 24 is the number of major and minor keys
    subplot(4,3,i)
    plot(1:12,gomezprofs(i,:))
    xlim([0 13])
    title([notes{i} ' Major'])
    ticks = get(gca,'XTick');
    set(gca,'XTickLabel',[{[]} notes(ticks(find(ticks)))])
end
[~, h3] = suplabel('Major Keys','t');
set(h3,'FontSize',20) 

figure('units','normalized','outerposition',[0 0 1 1])
for i=1:12 % 24 is the number of major and minor keys
    subplot(4,3,i)
    plot(1:12,gomezprofs(i+12,:))
    xlim([0 13])
    title([notes{i} ' Minor'])
    ticks = get(gca,'XTick');
    set(gca,'XTickLabel',[{[]} notes(ticks(find(ticks)))])
end
[~, h3] = suplabel('Minor Keys','t');
set(h3,'FontSize',20) 