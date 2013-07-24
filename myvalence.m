function vf = myvalence(thesound)


soundfile = miraudio(thesound);
vf=zeros(1,5);
% Directory where your files will go
directory = '~/Desktop/New System/SuperColliderTests/';

% Make the figure window full screen:
set(0,'DefaultFigureWindowStyle','normal')
figure('units','normalized','outerposition',[0 0 1 1]);

%% Standard Deviation of the RMS

rm = get(mirrms(soundfile,'Frame',.046,.5),'Data');
rmdata = rm{1}{1};
meanrmdata = mean(rmdata);
stdrmdata = std(rmdata);
breakpoint = .024254;
contribution = .015667/.3161;
vf(1) = -0.3161 * ((std(rmdata) - 0.024254)./0.015667);
maxcont = -0.3161 * ((0 - 0.024254)./0.015667);


subplot(3,2,1)
plot(rmdata,'r--','LineWidth',1)
hold on
lenrmdata = length(rmdata);
plot([0 lenrmdata], repmat(meanrmdata+stdrmdata,1,2), '--','LineWidth',3); % plot the horizontal line
plot([0 lenrmdata], repmat(meanrmdata,1,2), 'r:'); % plot the horizontal line
%plot([0 lenrmdata], repmat(meanrmdata+breakpoint,1,2), 'k--'); % plot the horizontal line
title('RMS Standard Deviation Valence Contribution')
%text(lenrmdata/20, meanrmdata,strcat('+',num2str(round(maxcont*100)/100)),'FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenrmdata/20,meanrmdata+breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenrmdata/20,meanrmdata+stdrmdata, num2str(round(vf(1)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('RMS','Standard Deviation','Mean RMS')
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
vf(2) = (peakdata{1}{1}{1}-breakpoint)/contribution;

subplot(3,2,3)
plot(flpos{1}{1},fldata{1}{1})
hold on
plot(peakpos{1}{1}{1},peakdata{1}{1}{1}, 'rx','MarkerSize',15,'LineWidth',3)
plot([0 10], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
plot([0 10], repmat(breakpoint+contribution,1,2), 'k:'); % plot the horizontal line
text(max(peakpos{1}{1}{1})/10,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
text(max(peakpos{1}{1}{1})/10,breakpoint+contribution,'+ 1','FontWeight','Bold','BackgroundColor',[1 1 1])
text(peakpos{1}{1}{1}+0.3,peakdata{1}{1}{1},num2str(round(vf(2)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
title('Summarized Flucutation Valence Contribution')
xlabel('Frequency (Hz)')
hold off

%% Key Clarity

%soundfile = miraudio('white');
ks = mirkeystrength(mirchromagram(soundfile,'Frame',0.046,0.5,'Wrap',0,'Pitch',0));
[k kc] = mirkey(ks);
kc = get(kc,'Data');
kcdata = kc{1}{1};
breakpoint = 0.5123;
contribution = .091953/0.8802;
vf(3) = (mean(kcdata) - breakpoint)/contribution;

subplot(3,2,4)
plot(kcdata,'r--','LineWidth',1)
lenkcdata = length(kcdata);
hold on
title('Key Clarity Valence Contribution')
plot([0 lenkcdata], repmat(mean(kcdata),1,2), '--','LineWidth',3); % plot the horizontal line
plot([0 lenkcdata], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
plot([0 lenkcdata], repmat(breakpoint+contribution,1,2), 'k:','LineWidth',1); % plot the horizontal line
text(lenkcdata/20,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenkcdata/20,breakpoint+contribution,'  + 1','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenkcdata/20,mean(kcdata),num2str(round(vf(3)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('KeyClarity','Mean')
xlabel('Frame')
hold off

%% Mode

mo = mirmode(ks);
mo = get(mo,'Data');
modata = mo{1}{1};
meanmodata=mean(modata);

breakpoint = -.0019958;
contribution = .048664/.4565;
vf(4) = (meanmodata - breakpoint)/contribution;

subplot(3,2,6)
plot(modata,'r--','LineWidth',1)
lenmodata=length(modata);
hold on
title('Mode Valence Contribution')
plot([0 lenmodata], repmat(meanmodata,1,2), '--','LineWidth',3); % plot the horizontal line
plot([0 lenmodata], repmat(breakpoint,1,2), 'k--'); % plot the horizontal line
plot([0 lenmodata], repmat(breakpoint+contribution,1,2), 'k:','LineWidth',1); % plot the horizontal line
text(lenmodata/20,breakpoint,'+/- 0','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenmodata/20,breakpoint+contribution,'  + 1','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenmodata/20,meanmodata,num2str(round(vf(4)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('Mode','Mean')
xlabel('Frame')
hold off

%% Novelty
%soundfile = miraudio('Money');

ns = mirnovelty(mirspectrum(soundfile,'Frame',.1,.5,'Max',5000),'Normal',0);
ns = get(ns,'Data');
nsdata = ns{1}{1};
lenns=length(nsdata);
% Have to plot first because of NaNs
subplot(3,2,5)
plot(nsdata,'r--','LineWidth',1)
hold on

% Now remove them and find the mean:
nsdata(isnan(nsdata))=[];
breakpoint = 131.9503;
contribution = 47.6463/.4015;
vf(5) = (mean(nsdata) - breakpoint)/contribution;

title('Novelty Valence Contribution')
plot([0 lenns], repmat(mean(nsdata),1,2), '--','LineWidth',3); % plot the horizontal line
plot([0 lenns], repmat(breakpoint+contribution,1,2), 'k:','LineWidth',1); % plot the horizontal line
text(lenns/20,breakpoint+contribution,'  + 1','FontWeight','Bold','BackgroundColor',[1 1 1])
text(lenns/20,mean(nsdata),num2str(round(vf(5)*100)/100),'FontWeight','Bold','BackgroundColor',[1 1 1])
legend('Novelty','Mean')
xlabel('Frame')
hold off

%% Bar Graph Summary
subplot(3,2,2)
factors = {'SdRMS', 'MaxFluc', 'KeyClarity', 'Mode', 'Novelty'};
bar(vf)
hold on
plot([0 6], 2, 'k:','LineWidth',1); % plot the horizontal line
plot([0 6], -2, 'k:','LineWidth',1); % plot the horizontal line
%set(gca,'YLim',[-2.5 2.5])
colormap(cool)
title(strcat('Valence = ',num2str(round((5.2749+sum(vf))*100)/100)),'FontSize', 14,...
    'FontWeight','Bold','HorizontalAlignment','center','BackgroundColor',[1 1 1])
%text(2.6,2.2,strcat('Valence = ',num2str(round((5.2749+sum(vf))*100)/100)),'BackgroundColor',[1 1 1])
text(1/6,0,'+ 5.28','BackgroundColor',[1 1 1])
set(gca,'XTickLabel',factors)
hold off

%% Wrap Up

mytitle = inputdlg('Please give a title','Title',1,{'untitled'});

[~, h3] = suplabel(mytitle{1},'t');
set(h3,'FontSize',20) 
set(0,'DefaultFigureWindowStyle','docked')

if ~strcmp(mytitle{1},'untitled')
    if ~isequal(exist([directory date],'dir'),7)
        mkdir(directory, date)
    end
    saveas(gcf,[directory date '/' mytitle{1} '.fig'],'fig')
    hgexport(gcf,[directory date '/' mytitle{1} '.eps'])
    % Write the soundfile with the new title:
    [samples samplerate]=wavread(thesound);
    wavwrite(samples, samplerate, [directory date '/' mytitle{1} '.wav'])
end