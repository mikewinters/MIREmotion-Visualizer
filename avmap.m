function avmap

% To use:
% CD into a directory containing wave files.  This program assumes you have
% numbered them corresponding to a desired position in the activity valence
% space, and they are named like such: V1A1, V2A1, etc..  Where 1-7 are
% likhert values for Activity and Valence.  

% Once you have CDed into this folder, you can run "avmap" in the command
% line and it will analyze all of them, and link them to their desired
% point.

% Hasn't been checked on any computer but my own (RMW 05/16/2013).


handles.figure = figure('units','normalized','position',[0.1185 0.4181 0.7619 0.4914],...
    'Windowstyle','normal','dockcontrols','on','toolbar','figure');

% If opening the .fig file output, you will need to have the pwd saved.
% Other than that, you need to be inside this folder.
handles.directory = pwd;
files = dir('*.wav');
numfiles = length(files);

activityoffset=5.4861;  % From MIREmotion
valenceoffset =5.2749;

% Handling colors and symbols;
mycolors = colormap('hsv(7)');
mysymbs = {'s','^','v','o','p','h','d'};
xindx = 1;
yindx = 1;
prevx = 1;
prevy = 1;

% Used for generation of error metric
distances = zeros(1,numfiles);

% For plotting:
subplot(1,2,1);
hold on;
xlabel('Valence','FontSize', 14,'FontWeight','Bold')
ylabel('Activity','FontSize', 14,'FontWeight','Bold')
plotlims=[-1 9];
set(gca,'YLim',plotlims,'XLim',plotlims)
%title('Activity/Valence Map','FontSize', 18,'FontWeight','Bold')
box on;

for i=1:numfiles
    [path name] = fileparts(files(i).name); % Get name w/o extension
    af = activity(name,'noplot');
    vf = valence(name,'noplot');
    act = sum(af)+activityoffset;
    val = sum(vf)+valenceoffset;
    thedata = struct('name',name,'index',i,'Activity',act,'ActFactors',af,...
                    'Valence',val,'ValFactors',vf,'isPlaying',0);
    
    % Find x and y coordinate based upon filename
    vindex = find(name == 'V');
    aindex = find(name == 'A');
    if vindex < aindex
        x = str2num(name(vindex+1:aindex-1));
        y = str2num(name(aindex+1:length(name)));
    else
        x = str2num(name(vindex+1:length(name)));
        y = str2num(name(aindex+1:vindex-1));
    end
    
    
    handles.thelines(i) = plot([x val],[y act],'LineStyle','-','Color',mycolors(y,:),...
                       'ButtonDownFcn',{@me_callback, handles},'Tag','theline',...
                       'userdata',thedata);
    handles.Dpoints(i) = plot(x, y, 'Color', 'k', 'Marker','*','MarkerSize',10,...
                'LineWidth',1,'ButtonDownFcn',{@me_callback, handles},'Tag','Desired',...
                    'userdata',thedata);
    handles.AVpoints(i) = plot(val, act,'Color', mycolors(y,:),'Marker',mysymbs{x}, ...
                 'MarkerSize',10,'LineWidth',1,'ButtonDownFcn',{@me_callback, handles},...
                 'Tag','AV','userdata',thedata);
    distances(i) = sqrt((val-x)^2 +(act-y)^2);
    
    % Generate Fancy Indexes
    
%     if x > prevx;
%         xindx = xindx +1;
%     elseif x == 1;
%         xindx = 1;
%     end
%     if y > prevy;
%         yindx = yindx+1;
%     elseif y == 1;
%         yindx = 1;
%     end
%     prevx = x;
%     prevy = y;
    
    % Plotting using fancy indexes
%     handles.thelines(i) = plot([x val],[y act],'LineStyle','-','Color',mycolors(yindx,:),...
%                        'ButtonDownFcn',{@me_callback, handles},'Tag','theline',...
%                        'userdata',thedata);
%     handles.Dpoints(i) = plot(x, y, 'Color', 'k', 'Marker','*','MarkerSize',10,...
%                 'LineWidth',1,'ButtonDownFcn',{@me_callback, handles},'Tag','Desired',...
%                     'userdata',thedata);
%     handles.AVpoints(i) = plot(val, act,'Color', mycolors(yindx,:),'Marker',mysymbs{xindx}, ...
%                  'MarkerSize',10,'LineWidth',1,'ButtonDownFcn',{@me_callback, handles},...
%                  'Tag','AV','userdata',thedata);
%     distances(i) = sqrt((val-x)^2 +(act-y)^2);
%     %text(vf-textdisX, af-textdisY, name)
    disp(['%%%%% Finished ' name ' %%%%%'])
end

avgdist = sum(distances)/numfiles;
deviations = distances-avgdist;
stdeviation = std(deviations);

distancetitle = ['D = ' num2str(round(avgdist*100)/100)...
                ' +- ' num2str(round(stdeviation*100)/100)];

title(distancetitle,'FontSize', 18,'FontWeight','Bold')

system('say I am ready');
handles.legend = legend([handles.AVpoints(1),handles.Dpoints(1)] ,'Measured','Desired');
hold off;

%% Initializations
data = get(handles.AVpoints(1),'userdata');
handles.soundfile = data.name;
handles.prevIndex = data.index; % For me_callback
handles.soundfile = data.name;                            
[handles.soundata handles.FS] = wavread(handles.soundfile);
handles.audioplayer = audioplayer(handles.soundata, handles.FS);


%% Bar Graphs
% Activity Bar Graph
subplot(2,2,2)
factors = {'RMS', 'MaxFluc', 'S.Centroid', 'S.Spread', 'S.Entropy'};
handles.actbar = bar(data.ActFactors);
colormap(cool)
handles.actbartitle = title([data.name ' Activity = ' num2str(round(data.Activity*100)/100)] ,'FontSize', 14,...
        'FontWeight','Bold','HorizontalAlignment','center','BackgroundColor',[1 1 1]);
text(0.2,0,'+ 5.49','BackgroundColor',[1 1 1])
ylabel('Contribution','FontSize', 14,'FontWeight','Bold')
set(gca,'YLim',[-6 6],'XLim',[0 6])
set(gca,'XTickLabel',factors)


% Valence Bar Graph
subplot(2,2,4)
factors = {'SdRMS', 'MaxFluc', 'KeyClarity', 'Mode', 'S.Novelty'};
handles.valbar = bar(data.ValFactors);
colormap(cool)
handles.valbartitle = title([data.name ' Valence = ' num2str(round(data.Valence*100)/100)] ,'FontSize', 14,...
        'FontWeight','Bold','HorizontalAlignment','center','BackgroundColor',[1 1 1]);
text(0.2,0,'+ 5.27','BackgroundColor',[1 1 1])
set(gca,'YLim',[-6 6],'XLim',[0 6])
ylabel('Contribution','FontSize', 14,'FontWeight','Bold')
set(gca,'XTickLabel',factors)


toc

%% Buttons

handles.activitybutton = uicontrol('Units', 'normalized','pos',[0.92 0.58 0.06 0.04],...
    'handlevisibility','off','parent',gcf,'tag','myemotionbutton','string','Detail',...
    'style','pushbutton'); %[L B W handles]
set(handles.activitybutton,'Callback',{@activity_callback, handles});

handles.valencebutton = uicontrol('Units', 'normalized','pos',[0.92 0.105 0.06 0.04],...
    'handlevisibility','off','parent',gcf,'tag','myemotionbutton','string','Detail',...
    'style','pushbutton'); %[L B W handles]
set(handles.valencebutton,'Callback',{@valence_callback, handles});


%% Supertitle and Export
% avgdist = sum(distances)/numfiles;
% deviations = distances-avgdist;
% stdeviation = std(deviations);
% 
% 
% supertitle = ['D = ' num2str(round(avgdist*100)/100)...
%                 ' +- ' num2str(round(stdeviation*100)/100)];

[~, handles.supertitle] = suplabel('Arousal/Valence Map','t');
set(handles.supertitle,'FontSize',20,'HandleVisibility','off','Visible','on')

guidata(gcf, handles);

% Save the output figure
hgexport(gcf,[distancetitle '.eps'])
hgsave(gcf, [distancetitle '.fig'])

guidata(gcf, handles);



%% me_callback
    function me_callback(hObject,eventdata,handles)
        handles = guidata(hObject);
        thestruct = get(gcbo,'userdata');
        set(handles.actbar,'YData', thestruct.ActFactors)
        set(handles.valbar,'YData', thestruct.ValFactors)
        set(handles.actbartitle,'String', [thestruct.name ' Activity = ' ...
                            num2str(round(thestruct.Activity*100)/100)])
        set(handles.valbartitle,'String', [thestruct.name ' Valence = ' ...
                            num2str(round(thestruct.Valence*100)/100)])
        
        cd(handles.directory)                        
                        
        if handles.prevIndex == thestruct.index;
            if ~isplaying(handles.audioplayer);
                play(handles.audioplayer)
            else isplaying(handles.audioplayer);
                stop(handles.audioplayer)
            end
        else
            handles.soundfile = thestruct.name;                            
            [handles.soundata handles.FS] = wavread(handles.soundfile);
            handles.audioplayer = audioplayer(handles.soundata, handles.FS);
        end
        
        % Make the markers bigger so it is more clear which one we are
        % considering
        set(handles.Dpoints(handles.prevIndex),'MarkerSize',10,'LineWidth',1)
        set(handles.thelines(handles.prevIndex),'LineWidth',1)  
        set(handles.AVpoints(handles.prevIndex),'MarkerSize',10,'LineWidth',1)
        
        set(handles.Dpoints(thestruct.index),'MarkerSize',15,'LineWidth',2)
        set(handles.thelines(thestruct.index),'LineWidth',2)
        set(handles.AVpoints(thestruct.index),'MarkerSize',15,'LineWidth',2)
        
%         uistack(handles.thelines(thestruct.index),'top');
%         uistack(handles.Dpoints(thestruct.index),'top');
%         uistack(handles.thelines(thestruct.index),'top');
                       
        handles.prevIndex = thestruct.index;
        
        guidata(gcf, handles);
    end

%% Activity and Valence Detail Plots
    function activity_callback(hObject,eventdata,h, handles)
        handles = guidata(hObject);
        thestruct = get(handles.AVpoints(handles.prevIndex),'userdata');
        figure('Windowstyle','normal','units','normalized','dockcontrols','on','toolbar','figure',...
            'position', [0.1887 0.4038 0.5548 0.5057]);
        activity(thestruct.name);
        [~, detitle] = suplabel(thestruct.name,'t');
        set(detitle,'FontSize',20,'HandleVisibility','off','Visible','on')
        hgexport(gcf,[thestruct.name '_activity.eps'])
        guidata(gcf, handles);
    end

    function valence_callback(hObject,eventdata,h, handles)
        handles = guidata(hObject);
        thestruct = get(handles.AVpoints(handles.prevIndex),'userdata');
        figure('Windowstyle','normal','units','normalized','dockcontrols','on','toolbar','figure',...
            'position', [0.1887 0.4038 0.5548 0.5057]);
        valence(thestruct.name);
        [~, detitle] = suplabel(thestruct.name,'t');
        set(detitle,'FontSize',20,'HandleVisibility','off','Visible','on')
        hgexport(gcf,[thestruct.name '_valence.eps'])
        guidata(gcf, handles);
    end

end




