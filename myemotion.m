function myemotion(soundfile,varargin)
% This code generates a figure that displays each of the emotion categories
% and gives the user the opportunity to quickly change views.  It also will
% save a wav file and output the resulting plots in .eps form.  The user
% provides a title after running the script with the knowledge that
% "untitled" results in no save. RMW 04/07/2013

% Make the figure window full screen:
%set(0,'DefaultFigureWindowStyle','normal')
handles.figure = figure('units','normalized','position',[0.1185 0.2181 0.7452 0.6914],...
    'Windowstyle','normal','dockcontrols','on','toolbar','figure');
%handles.figure = figure('units','normalized','outerposition',[0 0 1 1]);

handles.soundfile = soundfile;


if ~isempty(varargin);
    if strcmp(varargin{1},'activity');
        activity(handles.soundfile);
        handles.activityplots = findall(findobj('Parent',gcf,'handlevisibility','on','Visible','on'));
        usrdata = [0 1 0 0 0 0 0 0];
    else strcmp(varargin{1},'valence');
        valence(handles.soundfile);
        handles.valenceplots = findall(findobj('Parent',gcf,'handlevisibility','on','Visible','on'));
        usrdata = [1 0 0 0 0 0 0 0];
    end
else
    valence(handles.soundfile);
    handles.valenceplots = findall(findobj('Parent',gcf,'handlevisibility','on','Visible','on'));
    usrdata = [1 0 0 0 0 0 0 0];
end 


% Get audiodata for playing
[handles.soundata handles.FS] = wavread(handles.soundfile);
handles.audioplayer = audioplayer(handles.soundata, handles.FS);

% Make a play button:
handles.playbutton = uicontrol('Units', 'normalized','pos',[0.01 0.82 0.08 0.08],...
    'handlevisibility','off','parent',gcf,'tag','playbutton','string','play',...
    'style','pushbutton'); %[L B W handles]
set(handles.playbutton,'Callback',{@play_callback, handles});

% Make the button group
handles.buttongroup = uibuttongroup('Units', 'normalized','pos',[0.01 0.1 0.08 0.71],...
    'handlevisibility','off','parent',handles.figure,'tag','buttongroup'); %[L B W handles]
set(handles.buttongroup,'SelectionChangeFcn',{@button_callback, handles});

% Make the radio buttons
emotions = {'Valence','Activity','Tension','Happy','Sad','Tender','Fear','Anger'};
numemotions = length(emotions);
%handles.buttons = cell(1,8);
for i=1:numemotions
    bottom = i/numemotions;
    handles.buttons(i)=uicontrol(handles.buttongroup,'Style','Radio','units','normalized','String',emotions{i},... 
        'pos',[0.1 1-bottom 0.8 1/numemotions],'parent',handles.buttongroup,'tag', emotions{i},...
        'HandleVisibility','off','userdata',usrdata(i),'value',usrdata(i));
end
guidata(gcf, handles);

handles = saveme(handles);

% Update handles structure
guidata(gcf, handles);
end

%% Radiobuttons
% --- Executes when selected object is changed in uipanel1.
function button_callback(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

        set(findall(findobj('Parent',gcf,'handlevisibility','on','visible','on')),'handlevisibility','off','Visible','off') % Clear everything
        switch get(eventdata.NewValue,'Tag')
            case 'Valence',     
                if ~get(eventdata.NewValue,'Userdata')
                    set(eventdata.NewValue,'Userdata',1)
                    valence(handles.soundfile); % Run the function
                    handles.valenceplots = findall(findobj('Parent',gcf,'handlevisibility','on','visible','on'));
                    saveme(handles); % Save it too
                else
                    set(handles.valenceplots,'visible','on','handlevisibility','on') % Just plot the tagged graph
                end
           case 'Activity', 
                if ~get(eventdata.NewValue,'Userdata')
                    set(eventdata.NewValue,'Userdata',1)
                    activity(handles.soundfile); % Run the function
                    handles.activityplots = findall(findobj('Parent',gcf,'handlevisibility','on','visible','on')); % Tag all graphs
                    saveme(handles); % Save it too
                else
                    set(handles.activityplots,'visible','on','handlevisibility','on') % Just plot the tagged graphs
                end
         end
        
% Update handles structure
guidata(gcf, handles);
end

%% Playing
function play_callback(hObject,eventdata,handles)
handles = guidata(hObject);

switch get(hObject,'string')
    case 'play'
        set(hObject,'string','stop')
        play(handles.audioplayer)
    case 'stop'
        set(hObject,'string','play')
        stop(handles.audioplayer)
end

% Update handles structure
guidata(gcf, handles);

end
%% Saving
function handles = saveme(handles)

% Untitled means nothing is saved
if ~isfield(handles,'title')
    handles.directory = '~/Dropbox/Masters Thesis/New System/SuperColliderTests/';
    mytitle = inputdlg('Please give a title','Title',1,{'untitled'});
    handles.mytitle = mytitle{1};
    % What to do if it is not called "Untitled"
    if ~strcmp(handles.mytitle,'untitled')
        if ~isequal(exist([handles.directory date],'dir'),7)
            mkdir(handles.directory, date)
        end
    % Write the soundfile only if this is the first run through
    [samples samplerate]=wavread(handles.soundfile);
    wavwrite(samples, samplerate, [handles.directory date '/' handles.mytitle '.wav'])
    end
end

%Always set the supertitle
[~, handles.title] = suplabel(handles.mytitle,'t');
set(handles.title,'FontSize',20,'HandleVisibility','off','Visible','on') 

% Only save it if it is not untitled
if ~strcmp(handles.mytitle,'untitled')
    theemotion = get(get(handles.buttongroup,'SelectedObject'),'Tag');
    hgexport(gcf,[handles.directory date '/' handles.mytitle '_' theemotion '.eps'])
end


% Turn docking back on
set(0,'DefaultFigureWindowStyle','docked')


% Update handles structure
guidata(gcf, handles);
end

