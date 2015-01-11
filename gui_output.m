function varargout = gui_output(varargin)
% GUI_OUTPUT MATLAB code for gui_output.fig
%      GUI_OUTPUT, by itself, creates a new GUI_OUTPUT or raises the existing
%      singleton*.
%
%      H = GUI_OUTPUT returns the handle to a new GUI_OUTPUT or the handle to
%      the existing singleton*.
%
%      GUI_OUTPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OUTPUT.M with the given input arguments.
%
%      GUI_OUTPUT('Property','Value',...) creates a new GUI_OUTPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_output_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_output_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_output

% Last Modified by GUIDE v2.5 18-Mar-2013 20:00:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_output_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_output_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_output is made visible.
function gui_output_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_output (see VARARGIN)

% Choose default command line output for gui_output
handles.output = hObject;
hMainGui = getappdata(0,'hMainGui');
main_handles = guidata(hMainGui);

handles.evs_charging = 0;
handles.nrg_con(1) = Energyconsumers();
handles.nrg_con(2) = Energyconsumers();
handles.num_ap = 0; % Number of Apartments
handles.num_pl = 0; % Number of Parking Lots
handles.num_sm = 0; % Number of Shopping Malls

for i = 1:length(handles.nrg_con)
    if(handles.nrg_con(i).consumer_type == 1)
        handles.num_pl = handles.num_pl + 1;
    % If consumer is parking lot
    
    elseif(handles.nrg_con(i).consumer_type == 2)
        handles.num_sm = handles.num_sm + 1;
    % Elseif consumer is apartment
    
    elseif(handles.nrg_con(i).consumer_type == 3)
        handles.num_ap = handles.num_ap + 1;
    % Elseif consumer if shopping mall
    
    end
end

set(handles.apartments, 'String', num2str(handles.num_ap));
set(handles.parking_lots, 'String', num2str(handles.num_pl));
set(handles.shopping_malls, 'String', num2str(handles.num_sm));

handles.solarPlant = main_handles.solarPlant;
handles.windPlant = main_handles.windPlant;

handles.total_pwr = main_handles.total_pwr;
handles.total_evs = floor(main_handles.total_pwr / 6.6);

handles.num_evs = str2double(get(main_handles.evs_supported,'String'));
set(handles.evs_running, 'String', num2str(handles.num_evs));
set(handles.max_evs, 'String', num2str(handles.total_evs));


for i = 1:handles.num_evs
    handles.ev(i) = EV(handles.nrg_con);
end


handles.scroll = [5:24 1:6];
handles.x_ax = 1:24;
handles.time = 6;
handles.index = 24;


%Annotates axes1
xlabel(handles.axes1,'Time');
ylabel(handles.axes1,'Total Power Available');
title(handles.axes1,'Total Power Availabe vs Time');

%Annotates axes2
xlabel(handles.axes2,'Time');
ylabel(handles.axes2,'Scale');
title(handles.axes2,'Scale of Power Plants vs Time');

% Update handles structure
guidata(hObject, handles);

%Creates timer obj
timer_obj(5, hObject, handles);

% UIWAIT makes gui_output wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure


%Retrieves handle for the main GUI
hMainGui = getappdata(0,'hMainGui');
try
    %Stops all timers
    stop(timerfind);
    %Deletes them
    delete(timerfind);
    %Grabs guidata from main gui
    main_handles = guidata(hMainGui);
    %Changes started variable to 0 as simulation window will be closed
    main_handles.started = 0;
    %Updates guidata in main gui
    guidata(hMainGui,main_handles);
    %Removes subGui object handle
	rmappdata(hMainGui,'subGui');
end
delete(hObject);

%Timer obj that runs the update function every n seconds to run simulation
function timer_obj(n, hObject, handles)
%Creates a timer object
t = timer;
%Sets the timer's StartDelay to 3 seconds
if(n < 1)
    t.StartDelay = 1;
else
    t.StartDelay = n;
end
%Sets the timer's name to subGui timer
t.Name = 'subGui timer';
%Sets period of timer to n
t.Period = n;
%Sets execution mode of timer to fixedRate
t.ExecutionMode = 'fixedRate';
%Sets TimerFcn to update
t.TimerFcn = @(t,e)update;
%Stores timer object handle in handles.timer_obj
handles.timer_obj = t;
%Updates guidata
guidata(hObject,handles);


%Simulation update
function update
%Handles retrieval
hMainGui = getappdata(0,'hMainGui');
hSubGui = getappdata(hMainGui,'hSubGui');
handles = guidata(hSubGui);
main_handles = guidata(hMainGui);

%Plotting
handles.total_pwr_prod = handles.windPlant.tmod_pwr(handles.time)  + handles.solarPlant.tmod_pwr(handles.time);
handles.total_pwr_dem = handles.num_evs * 6.6;
handles.total_pwr_avail = handles.total_pwr_prod - handles.total_pwr_dem;

%Check to see if power demanded is within 10% of power produced
if(length(handles.ev) * 6.6 >= 0.90 * handles.total_pwr_prod)
    errordlg('The power demanded by the EVs are within 10% of the power being supplied.');
    city_ind = get(main_handles.cities,'Value');
    perc_solar = str2double(get(main_handles.perc_solar,'String')) / 100;
    perc_wind = str2double(get(main_handles.perc_wind,'String')) / 100;
    data = main_handles.data;
    area = (data.area(city_ind)*1000000) * .0000005;
    s_area = area * perc_solar;
  	w_area = area * perc_wind;
    while(length(handles.ev) * 6.6 >= 0.90 * handles.total_pwr_prod)
        if(handles.solarPlant.total_area + handles.windPlant.total_area + area <= (data.area(city_ind)*1000000))
            add_spanel = floor(s_area / handles.solarPlant.size) + handles.solarPlant.num_spanel;
            add_wturbs = floor(w_area / handles.windPlant.wturb_size) + handles.windPlant.num_wturb;
            handles.solarPlant.set_spanel(add_spanel);
            handles.windPlant.set_wturb(add_wturbs);
            handles.total_pwr_prod = handles.windPlant.tmod_pwr(handles.time)  + handles.solarPlant.tmod_pwr(handles.time);
            max_evs = floor(handles.total_pwr_prod/6.6);
            set(handles.max_evs,'String',num2str(max_evs));
        else % If the total area occupied by the solar plant and wind plant is greater than 100% of the land area of the city
            ev_rem_Callback();
        end
    end
end

scale_wind = handles.windPlant.num_wturb;
scale_solar = handles.solarPlant.num_spanel;
%New data at the end of data array
handles.data1(24) = handles.total_pwr_prod;
handles.data2(24) = handles.total_pwr_dem;
handles.data3(24) = handles.total_pwr_avail;

handles.scale_w(24) = scale_wind;
handles.scale_s(24) = scale_solar;

set(handles.scale_wind,'String',num2str(scale_wind));
set(handles.scale_solar,'String',num2str(scale_solar));
set(handles.pwr_prod,'String',num2str(handles.total_pwr_prod));
set(handles.pwr_dem,'String',num2str(handles.total_pwr_dem));
set(handles.pwr_avail,'String',num2str(handles.total_pwr_avail));

%Plots data
plot(handles.axes1,handles.x_ax,handles.data1, handles.x_ax,handles.data2, handles.x_ax,handles.data3);
legend(handles.axes1, 'Total Power Produced', 'Total Power Demanded', 'Total Power Available');

plot(handles.axes2,handles.x_ax,handles.scale_w,handles.x_ax,handles.scale_s);
legend(handles.axes2,'Scale of Wind Plant','Scale of Solar Plant');

%Shifts data for scrolling effect
handles.data1(1:end - 1) = handles.data1(2:end);
handles.data2(1:end - 1) = handles.data2(2:end);
handles.data3(1:end - 1) = handles.data3(2:end);
handles.scale_w(1:end - 1) = handles.scale_w(2:end);
handles.scale_s(1:end - 1) = handles.scale_s(2:end);

%Shifts scroll backwards by putting first element at end and shifting
%everything back
tmp2 = handles.scroll(1);
handles.scroll = handles.scroll(2:end);
handles.scroll(end + 1) = tmp2;

%Converts handles.scroll into a vertical cell array
for i = 1:length(handles.scroll)
    tmp{i,1} = num2str(handles.scroll(i));
end
%Updates the tick labels to emulate scroll effect
set(handles.axes1,'XTickLabel',tmp);
set(handles.axes2,'XTickLabel',tmp);

if(handles.time >= 24)
    handles.time = 1;
else
    handles.time = handles.time + 1;
end

%Updates GUI data
guidata(hSubGui,handles);


% --- Outputs from this function are returned to the command line.
function varargout = gui_output_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in stop_but.
function stop_but_Callback(hObject, eventdata, handles)
% hObject    handle to stop_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_output('figure1_CloseRequestFcn',gcf,[],handles);

% --- Executes on button press in sim_con.
function sim_con_Callback(hObject, eventdata, handles)
% hObject    handle to sim_con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%If timer is running, then stops timer and changes button text to resume
if(strcmp(handles.timer_obj.Running,'on'))
    stop(handles.timer_obj);
    set(handles.sim_con,'String','Resume');
%If not running, then starts timer and changes button text to Pause because
%initial text is start
else
    start(handles.timer_obj);
    set(handles.sim_con,'String','Pause');
end


% --- Executes on button press in pl_add.
function pl_add_Callback(hObject, eventdata, handles)
% hObject    handle to pl_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.nrg_con(length(handles.nrg_con) + 1) = Energyconsumers(1);
handles.num_pl = handles.num_pl + 1;
set(handles.parking_lots, 'String', num2str(handles.num_pl));

guidata(hObject, handles);


% --- Executes on button press in pl_rem.
function pl_rem_Callback(hObject, eventdata, handles)
% hObject    handle to pl_rem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(length(handles.nrg_con) <= 2)
    errordlg('You cannot have less than two energy consumers.');
    
elseif(handles.num_pl == 0)
    errordlg('You have no parking lots to remove.');

else
    for i = 1:length(handles.nrg_con)
        if(handles.nrg_con(i).consumer_type == 1)
            handles.nrg_con(i) = [];
            handles.num_pl = handles.num_pl - 1;
            set(handles.parking_lots, 'String', num2str(handles.num_pl));
            guidata(hObject, handles);
            return;
        end
    end
end


% --- Executes on button press in ev_add.
function ev_add_Callback(hObject, eventdata, handles)
% hObject    handle to ev_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ev(length(handles.ev) + 1) = EV(handles.nrg_con);
handles.num_evs = handles.num_evs + 1;
set(handles.evs_running, 'String', num2str(handles.num_evs));


guidata(hObject, handles);


% --- Executes on button press in ev_rem.
function ev_rem_Callback(hObject, eventdata, handles)
% hObject    handle to ev_rem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(length(handles.ev) == 0)
    errordlg('You have no more EVs to remove.');

else
    handles.ev(length(handles.ev)) = [];
    handles.num_evs = handles.num_evs - 1;
    set(handles.evs_running, 'String', num2str(handles.num_evs));
end

guidata(hObject, handles);


% --- Executes on button press in ap_add.
function ap_add_Callback(hObject, eventdata, handles)
% hObject    handle to ap_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.nrg_con(length(handles.nrg_con) + 1) = Energyconsumers(3);
handles.num_ap = handles.num_ap + 1;
set(handles.apartments, 'String', num2str(handles.num_ap));


guidata(hObject, handles);


% --- Executes on button press in ap_rem.
function ap_rem_Callback(hObject, eventdata, handles)
% hObject    handle to ap_rem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(length(handles.nrg_con) <= 2)
    errordlg('You cannot have less than two energy consumers.');
    
elseif(handles.num_ap == 0)
    errordlg('You have no apartments to remove.');
    
else
    for i = 1:length(handles.nrg_con)
        if(handles.nrg_con(i).consumer_type == 3)
            handles.nrg_con(i) = [];
            handles.num_ap = handles.num_ap - 1;
            set(handles.apartments, 'String', num2str(handles.num_ap));
            guidata(hObject, handles);
            return;
        end
    end
end


% --- Executes on button press in sm_add.
function sm_add_Callback(hObject, eventdata, handles)
% hObject    handle to sm_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.nrg_con(length(handles.nrg_con) + 1) = Energyconsumers(2);
handles.num_sm = handles.num_sm + 1;
set(handles.shopping_malls, 'String', num2str(handles.num_sm));

guidata(hObject, handles);


% --- Executes on button press in sm_rem.
function sm_rem_Callback(hObject, eventdata, handles)
% hObject    handle to sm_rem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(length(handles.nrg_con) <= 2)
    errordlg('You cannot have less than two energy consumers.');
    
elseif(handles.num_sm == 0)
    errordlg('You have no shopping malls to remove.');
    
else
    for i = 1:length(handles.nrg_con)
        if(handles.nrg_con(i).consumer_type == 2)
            handles.nrg_con(i) = [];
            handles.num_sm = handles.num_sm - 1;
            set(handles.shopping_malls, 'String', num2str(handles.num_sm));
            guidata(hObject, handles);
            return;
        end
    end
end


% --- Executes on button press in spd_add.
function spd_add_Callback(hObject, eventdata, handles)
% hObject    handle to spd_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
period = str2double(get(handles.period,'String'));
%If the period is less than 1, then the period is doubled in contrast with
%the subtract function
if(period < 1)
    period = period + .125;
else
    %Else period is increased by 1
    period = period + 1;
end
%Updates text
set(handles.period,'String',num2str(period));

%Variable to check if timer is currently running
running = strcmp(handles.timer_obj.Running,'on');
%Updates timer obj by deleting initial one and starting a new one
stop(handles.timer_obj);
delete(handles.timer_obj);
timer_obj(period,hObject,handles);
handles = guidata(hObject); %Updates handles in the function
%Checks if timer was running, if so, starts timer again
if(running)
    start(handles.timer_obj);
end

% --- Executes on button press in spd_sub.
function spd_sub_Callback(hObject, eventdata, handles)
% hObject    handle to spd_sub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Retrieving period from the GUI object
period = str2double(get(handles.period,'String'));
%if the period is .250 prevents user from subtracting more
if(period == .250)
    return
%elseif period is 1, period decreases by half
elseif(period <= 1)
    period = period - .125;
else
    %Else it subtracts period by 1
    period = period - 1;
end
%Updates text
set(handles.period,'String',num2str(period));

%Variable to check if timer is currently running
running = strcmp(handles.timer_obj.Running,'on');
%Updates timer obj by deleting initial one and starting a new one
stop(handles.timer_obj);
delete(handles.timer_obj);
timer_obj(period,hObject,handles);
handles = guidata(hObject); %Updates handles in the function
%Checks if timer was running, if so, starts timer again
if(running)
    start(handles.timer_obj);
end
