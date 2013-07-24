function af = myactivity(thesound)

soundfile = miraudio(thesound);
af=zeros(1,5);
% Directory where your files will go
directory = '~/Desktop/New System/SuperColliderTests/';

% Make the figure window full screen:
set(0,'DefaultFigureWindowStyle','normal')
figure('units','normalized','outerposition',[0 0 1 1]);

% Create some mean buttons
h = uibuttongroup('Units', 'normalized'); 
% Create three radio buttons in the button group. 
u0 = uicontrol('Style','Radio','String','Valence',... 
    'units','normalized','pos',[0 0.9 0.1 0.1],'parent',h,'HandleVisibility','off'); 
u1 = uicontrol('Style','Radio','String','Activity',... 
    'units','normalized','pos',[0 0.8 0.1 0.1],'parent',h,'HandleVisibility','off');


%% RMS

rm = get(mirrms(soundfile,'Frame',.046,.5),'Data');
rmdata = rm{1}{1};
meanrmdata = mean(rmdata);
breakpoint = .0559;
contribution = .0337/.6664;
af(1) = (meanrmdata-breakpoint)/contribution;

% Use this later as it can save a tad on computation.
numframes = length(rmdata);

subplot(3,2,1)
plot(rmdata,'r--','LineWidth',1)
hold on
lenrmdata = length(rmdata);
plot([0 lenrmdata], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
plot([0 lenrmdata], repmat(meanrmdata,1,2), 'b--','LineWidth',3); % plot the horizontal line
title('RMS Activity Contribution')
text(lenrmdata/20,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenrmdata/20,meanrmdata, num2str(round(af(1)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('RMS','Mean RMS')
xlabel('Frame')
hold off

%% Maximum Value of the Summarized Fluctuation

fl = mirfluctuation(soundfile,'Summary');
fldata = get(fl,'Data');
flpos = get(fl,'Pos');
peak = mirpeaks(fl,'Total',1);
peakdata = get(peak,'PeakVal');
peakpos = get(peak,'PeakPosUnit');

breakpoint = 13270.1836;
contribution = 10790.655/.6099;
af(2) = (peakdata{1}{1}{1}-breakpoint)/contribution;

subplot(3,2,3)
plot(flpos{1}{1},fldata{1}{1})
hold on
plot(peakpos{1}{1}{1},peakdata{1}{1}{1}, 'rx','MarkerSize',15,'LineWidth',3)
plot([0 10], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
plot([0 10], repmat(breakpoint+contribution,1,2), 'k:'); % plot the horizontal line
text(max(peakpos{1}{1}{1})/20,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
text(max(peakpos{1}{1}{1})/20,breakpoint+contribution,'+ 1','FontWeight','Bold','BackgroundColor',[1 1 1])
text(peakpos{1}{1}{1}+0.3,peakdata{1}{1}{1},num2str(round(af(2)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
title('Summarized Flucutation Valence Contribution')
xlabel('Frequency (Hz)')
hold off

%% Spectral Centroid

s = mirspectrum(soundfile,'Frame',0.046,0.5);
sc = get(mircentroid(s),'Data');
scdata = cell2mat(sc{1}{1});
meanscdata = mean(scdata);

breakpoint = 1677.7;
contribution = 570.34/.4486;
af(3) = (mean(scdata)-breakpoint)/contribution;

subplot(3,2,5)
plot(scdata,'r--','LineWidth',1)
lenscdata = length(scdata);
hold on
title('Spectral Centroid Activity Contribution')
plot([0 lenscdata], repmat(meanscdata,1,2), '--','LineWidth',3); % plot the horizontal line
plot([0 lenscdata], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
text(lenscdata/20,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenscdata/20,meanscdata,num2str(round(af(3)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('Spectral Centroid','Mean')
xlabel('Frame')
ylabel('Frequency')
hold off

%% Spectral Spread

ss = get(mirspread(s),'Data');
ssdata = cell2mat(ss{1}{1});
meanssdata=mean(ssdata);

breakpoint = 250.5574;
contribution = 205.3147/(-.4639);
af(4) = (meanssdata - breakpoint)/contribution;

subplot(3,2,4)
plot(ssdata,'r--','LineWidth',1)
lenssdata=length(ssdata);
hold on
title('Spectral Spread Activity Contribution')
plot([0 lenssdata], repmat(meanssdata,1,2), '--','LineWidth',3); % plot the horizontal line
plot([0 lenssdata], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
%plot([0 lenssdata], repmat(breakpoint+contribution,1,2), 'k:','LineWidth',1); % plot the horizontal line
text(lenssdata/20,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
%text(lenssdata)/20,breakpoint+contribution,'  + 1','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenssdata/20,meanssdata,num2str(round(af(4)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('Spread','Mean')
xlabel('Frame')
ylabel('Frequency')
hold off

%% Spectral Entropy

se = get(mirentropy(mirspectrum(soundfile,'Collapsed','Min',40,'Smooth',70,'Frame',1.5,0.5)),'Data');
sedata = se{1}{1};
meansedata=mean(sedata);

breakpoint = 0.954;
contribution = 0.0258/(0.7056);
af(5) = (meansedata - breakpoint)/contribution;

subplot(3,2,6)
plot(sedata,'r--','LineWidth',1)
lensedata=length(sedata);
hold on
title('Spectral Entropy Activity Contribution')
plot([0 lensedata], repmat(meansedata,1,2), '--','LineWidth',3); % plot the horizontal line
plot([0 lensedata], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
%plot([0 lenssdata], repmat(breakpoint+contribution,1,2), 'k:','LineWidth',1); % plot the horizontal line
text(lensedata/20,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
%text(lenssdata)/20,breakpoint+contribution,'  + 1','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lensedata/20,meansedata,num2str(round(af(5)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('Entropy','Mean')
xlabel('Frame')
hold off

%% Bar Graph Summary
subplot(3,2,2)
factors = {'RMS', 'MaxFluc', 'Centroid', 'Spread', 'Entropy'};
bar(af)
hold on
plot([0 6], 2, 'k:','LineWidth',1); % plot the horizontal line
plot([0 6], -2, 'k:','LineWidth',1); % plot the horizontal line

colormap(cool)
title(strcat('Activity = ',num2str(round((5.4861+sum(af))*100)/100)),'FontSize', 14,...
    'FontWeight','Bold','HorizontalAlignment','center','BackgroundColor',[1 1 1])
%text(2.6,2.2,strcat('Activity = ',num2str(round((5.4861+sum(af))*100)/100)),'BackgroundColor',[1 1 1])
text(1/6,0,'+ 5.49','BackgroundColor',[1 1 1])
set(gca,'XTickLabel',factors)
hold off

%% Wrap up
mytitle = inputdlg('Please give a title','Title',1,{'untitled'});

[~, h3] = suplabel(mytitle{1},'t');
set(h3,'FontSize',20) 
set(0,'DefaultFigureWindowStyle','docked')