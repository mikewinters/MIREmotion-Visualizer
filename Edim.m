function [varA varB] = Edim(file, mytitle) 

if ~exist('mytitle')
    mytitle = 'Untitled';
end

data = miremotion(file);

dimdata = get(data,'DimData');
dimdata = num2cell(dimdata{1}{1});
[activity valence tension] = deal(dimdata{:});
varA=activity;
varB=valence;

% Plot the dimension data
% figure
% subplot(1,2,1)
% hold on
% plot3(valence, activity,tension,'bx','MarkerSize',10,'LineWidth',5)
% title('Arousal vs. Valence')
% % set(gca,'XLim',[0 8],'YLim',[0 8])
% % xlabel('Valence')
% % ylabel('Activity')

figure
subplot(1,2,1)
plot3(valence, activity, tension,'bx','MarkerSize',10,'LineWidth',5)
title('Activity, Tension, Valence')
hold on
plot3([1 7], [4 4], [4 4], 'k-'); % plot the horizontal line
plot3([4 4], [1 7], [4 4], 'k-'); % plot the horizontal line
plot3([4 4], [4 4], [1 7], 'k-'); % plot the horizontal line
xlabel('Valence')
ylabel('Activity')
zlabel('Tension')

text(0,0.5,strcat('Act. = ',num2str(round(activity*100)/100)), 'FontSize',12,'FontWeight','bold')
text(3,0.5,strcat('Val. = ',num2str(round(valence*100)/100)), 'FontSize',12,'FontWeight','bold')
text(6,0.5,strcat('Ten. = ',num2str(round(tension*100)/100)), 'FontSize',12,'FontWeight','bold')
box on
axis([ -1 9 -1 9 -1 9])
rotate3d on
% view([0.5 90]) % Pushes it to view just along activity and valence
hold off


% text(1,0.5,'Max A, Max V', 'FontSize',14,'FontWeight','bold')
% text(y(1)-1.4,x(1)-0.5,'Max A, Max V', 'FontSize',14,'FontWeight','bold')
% hold off


% Get and plot activity factors
activitydata = get(data,'ActivityFactors');

activityfactors = num2cell(activitydata{1}{1});
[rms fluctuation centroid spread entropy] = deal(activityfactors{:});


subplot(2,2,2)
factors = {'RMS', 'Max Fluc', 'Cent', 'Spread', 'Entr'};
bar(activitydata{1}{1})
set(gca,'YLim',[-2.5 2.5])
colormap(cool)
title('Activity Factors')
set(gca,'XTickLabel',factors)

% Get and plot valence factors
valencedata = get(data,'ValenceFactors');
valencefactors = num2cell(valencedata{1}{1});
[sdrms fluctuation key mode novel] = deal(valencefactors{:});


subplot(2,2,4)
factors = {'SdRMS', 'MaxFluc', 'KeyClarity', 'Mode', 'Novelty'};
bar(valencedata{1}{1})
set(gca,'YLim',[-2.5 2.5])
colormap(cool)
title('Valence Factors')
set(gca,'XTickLabel',factors)

[~, h3] = suplabel(mytitle,'t');
set(h3,'FontSize',20) 




