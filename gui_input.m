function varargout = gui_input(varargin)
% GUI_INPUT MATLAB code for gui_input.fig
%      GUI_INPUT, by itself, creates a new GUI_INPUT or raises the existing
%      singleton*.
%
%      H = GUI_INPUT returns the handle to a new GUI_INPUT or the handle to
%      the existing singleton*.
%
%      GUI_INPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INPUT.M with the given input arguments.
%
%      GUI_INPUT('Property','Value',...) creates a new GUI_INPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_input_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_input_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_input

% Last Modified by GUIDE v2.5 18-Mar-2013 19:20:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_input_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_input_OutputFcn, ...
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


% --- Executes just before gui_input is made visible.
function gui_input_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_input (see VARARGIN)

% Choose default command line output for gui_input
handles.output = hObject;
%Variable to check if simulation started
handles.started = 0;
% Update handles structure
guidata(hObject, handles);
%Stores this GUI's object handle in root, 0
setappdata(0,'hMainGui',gcf);
%Calls update data
update_data;

% UIWAIT makes gui_input wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

%Retrieves handle for the main GUI

%Retrieves handle for this GUI
hMainGui = getappdata(0,'hMainGui');
%If possible & in cases if the fig file is opened
try
    %gets the handle from the sub GUI
    sub_handles = guidata(getappdata(hMainGui,'hSubGui'));
    %calls the close function of the subGUI
    gui_output('figure1_CloseRequestFcn',sub_handles.figure1,[],sub_handles);
    %Cleans up data
    rmappdata(0,'hMainGui');
end
%Delete object
delete(hObject);

%Function to update various data in GUI. This is usually called after 
%changes to selections are made
function update_data
%Retrieves GUI's handle
hMainGui = getappdata(0,'hMainGui');
%Retrieves handles in stored with GUI
handles = guidata(hMainGui);
%Retrieves data stored in handles
data = handles.data;
%Retrieves the percentages of land for each power source that user inputed
perc_solar = str2double(get(handles.perc_solar,'String'));
perc_wind = str2double(get(handles.perc_wind,'String'));
%Retrieves the month
month = get(handles.month,'Value');
%Retrieves the index of the selected city
city_ind = get(handles.cities,'Value');
%Retrieves solar radiation data for a city at a certain month
solar = data.solar(city_ind, month);
%Retrieves wind speed data for a city at a certain month
wind = data.wind(city_ind, month);
%Converts area to squared meters and takes 1% of that area
area = (data.area(city_ind)*1000000) * .00001;

%Create new SolarPlant, a power plant of solar panels at a insolation value
%and area of area * perc_solar
handles.solarPlant = SolarPlant(solar,area*perc_solar);
%Computes the amount of power produced from SolarPlant plus the energy 
%modifier at 6 am
solar_pwr = handles.solarPlant.get_pwr * .10;

%Create new WindPlant, a wind turbines power plant at a wind speed and
%area of area * perc_wind
handles.windPlant = WindPlant(wind,area*perc_wind);
%Computes the amount of power produced from the WindPlant plus the energy 
%modifier at 6 am
wind_pwr = handles.windPlant.get_pwr * .10;

%Computes total power available and store in handles
handles.total_pwr = solar_pwr + wind_pwr;
%Estimated number of supported EVs
num_evs = round((handles.total_pwr / 6.6) * .85);

%Updates String in several objects of the GUI
set(handles.evs_supported,'String',num2str(num_evs));
set(handles.solar_pwr,'String',num2str(solar_pwr));
set(handles.wind_pwr,'String',num2str(wind_pwr));

%Update guidata
guidata(hMainGui,handles);

% --- Outputs from this function are returned to the command line.
function varargout = gui_input_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Asks user to select the database file
[name path] = uigetfile('.mat','Choose database file','weather.mat');

%Regular expression to check whether a file has the right extension
matches = 0;
endi = 0;
if(name ~= 0)
    expr = '.mat';
    [endi matches] = regexp(name,expr,'end','match');
    matches = length(matches);
end
%If user selects a valid file ie. a file that ends with .mat extension
if(matches > 0 && endi == length(name))
    data = load([path name]); %Stores loaded database in handles
    names = fieldnames(data); %Gets the field names
    
    %Correct field names to check
    c_names = {'solar';'wind';'precip';'city';'state';'population';'area'};
    check = 0; %Check variable
    %Checks whether each c_names is a field in the data
    for i = 1:length(names)
        check = check + strcmp(c_names{i},names);
    end
    %If all 7 fields checks out then the data is stored in the GUI
    if(sum(check) == 7)
        %Passes check, stores data
        handles.data = data;
        
        %Updates list box
        set(handles.cities,'String',handles.data.city);
        %Updates GUI handles variable
        guidata(hObject, handles);
    else
        errordlg('The database is incomplete. Refer to instructions in the report.','Load failed');
    end
    %Clears data to save memory
    clear data;
elseif(name ~= 0)
    errordlg('The selected file must be a .mat file.','Load failed');
end


% --- Executes on selection change in cities.
function cities_Callback(hObject, eventdata, handles)
% hObject    handle to cities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cities contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cities

%Updates data
update_data;

% --- Executes during object creation, after setting all properties.
function cities_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Loads default data in weather.mat
data = load('weather.mat');
%Stores data in GUI
handles.data = data;
%Clears data to save memory
clear data;
%Updates handles in gui
guidata(hObject,handles);
%Updates listbox with cities
set(hObject,'String',handles.data.city);



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Retrieves value from slider
value = get(hObject,'Value');
%Changes precision to 1 decimal place
solar = round(1000*(1-value))/10;
%Changes precision to 1 decimal place
wind = round(1000*value)/10;

%Updates the edit boxes' value
set(handles.perc_solar,'String',num2str(solar));
set(handles.perc_wind,'String',num2str(wind));

%Updates data
update_data;


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in set_perc.
function error = set_perc_Callback(hObject, eventdata, handles)
% hObject    handle to set_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Initialize error to 0
error = 0;
%Retrieves user's selection from edit boxes
solar = str2double(get(handles.perc_solar,'String'))/100;
wind = str2double(get(handles.perc_wind,'String'))/100;
%Checks whether input is valid
if(solar + wind > 1 || solar + wind < 1 || isnan(solar)|| isnan(wind))
    errordlg('The sum of the percentages must be 100!','Power Distribution error');
    error = 1;
else
    %Updates the slider to reflect change
    set(handles.slider1,'Value',wind);
    %Updates data
    update_data;
end
    


% --- Executes on selection change in month.
function month_Callback(hObject, eventdata, handles)
% hObject    handle to month (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns month contents as cell array
%        contents{get(hObject,'Value')} returns selected item from month

%Updates data
update_data;

% --- Executes during object creation, after setting all properties.
function month_CreateFcn(hObject, eventdata, handles)
% hObject    handle to month (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Check to see if a simulation started
if(handles.started == 1)
    errordlg('A simulation already started. Stop and close the simulation window before starting a new one.','Start error');
    return
end

%Updates started variable to 1, indicating simulation started
handles.started = 1;
guidata(hObject,handles);

%Calls the Callback of the 'Set' button and stores return value in error
error = set_perc_Callback(handles.set_perc,[],handles);
%If error = 1, an error happened and stops ends execution of function early
if(error == 1)
    return
end

%Gets gui object handle
hMainGui = getappdata(0,'hMainGui');
%Create subGui and store handle in hSubGui variable
hSubGui = gui_output;
%Stores hSubGui in hSubGui of hMainGui
setappdata(hMainGui,'hSubGui',hSubGui);

