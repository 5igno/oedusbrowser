function varargout = SelectSpectrum(varargin)
% SELECTSPECTRUM MATLAB code for SelectSpectrum.fig
%      SELECTSPECTRUM, by itself, creates a new SELECTSPECTRUM or raises the existing
%      singleton*.
%
%      H = SELECTSPECTRUM returns the handle to a new SELECTSPECTRUM or the handle to
%      the existing singleton*.
%
%      SELECTSPECTRUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTSPECTRUM.M with the given input arguments.
%
%      SELECTSPECTRUM('Property','Value',...) creates a new SELECTSPECTRUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SelectSpectrum_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SelectSpectrum_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SelectSpectrum

% Last Modified by GUIDE v2.5 01-May-2016 20:05:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectSpectrum_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectSpectrum_OutputFcn, ...
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Opening Function                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before SelectSpectrum is made visible.
function SelectSpectrum_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SelectSpectrum (see VARARGIN)

% Initialize Selectors
handles.id_spectra_list = 1;
handles.id_select_measurement = 1;
handles.id_select_stress = 1;

% Update the list of spectra with the stuff you found on the workspace
[handles.spectra_list, handles.spectra_array, handles.spectra_type] = UpdateSpectraList(handles.spectra_list);

% Update Target
handles.target = UpdateTargetVariable(handles.spectra_array, handles.id_spectra_list);

% Change selector visibility and range of depending on the targeted spectrum
[UIctrl_out] = UpdateSelectors( handles.target, handles.spectra_type, handles.id_spectra_list, ...
    handles.id_select_measurement, handles.select_measurement, handles.measurement_label, ...
    handles.id_select_stress, handles.select_stress, handles.stress_label);

handles.select_measurement = UIctrl_out{1};
handles.measurement_label = UIctrl_out{2};
handles.select_stress = UIctrl_out{3};
handles.stress_label= UIctrl_out{4};

% Update Selected Spectrum
handles.selected_spectrum = UpdateSelectedSpectrum( handles.target, handles.spectra_type, ...
    handles.id_spectra_list, handles.id_select_stress, handles.id_select_measurement);

% Plot Updated Spectrum
handles.spectrum_axes = UpdateSpectrumPlot(handles.selected_spectrum, handles.spectrum_axes);

% Choose default command line output for SelectSpectrum
handles.output = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SelectSpectrum wait for user response (see UIRESUME)
uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Output Function                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = SelectSpectrum_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

close;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                       Create Functions                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function spectra_list_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to spectra_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',1);

% --- Executes during object creation, after setting all properties.
function select_stress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_stress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function select_measurement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Callback Functions                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in spectra_list.
function spectra_list_Callback(hObject, eventdata, handles)
% hObject    handle to spectra_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spectra_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spectra_list

handles.id_spectra_list = get(hObject,'Value');
% Update Target
handles.target = UpdateTargetVariable(handles.spectra_array, handles.id_spectra_list);

% Change visibility and range of Sliders depending on the targeted spectrum
[UIctrl_out] = UpdateSelectors( handles.target, handles.spectra_type, handles.id_spectra_list, ...
    handles.id_select_measurement, handles.select_measurement, handles.measurement_label, ...
    handles.id_select_stress, handles.select_stress, handles.stress_label);

handles.select_measurement = UIctrl_out{1};
handles.measurement_label = UIctrl_out{2};
handles.select_stress = UIctrl_out{3};
handles.stress_label= UIctrl_out{4};

% Update Selected Spectrum
handles.selected_spectrum = UpdateSelectedSpectrum( handles.target, handles.spectra_type, ...
    handles.id_spectra_list, handles.id_select_stress, handles.id_select_measurement);


% Update Plot
handles.spectrum_axes = UpdateSpectrumPlot(handles.selected_spectrum, handles.spectrum_axes);

% Update handles structure
guidata(hObject, handles);

% --- Executes on slider movement.
function select_measurement_Callback(hObject, eventdata, handles)
% hObject    handle to select_measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.id_select_measurement = round(get(hObject,'Value'));
% ShowCurrentIndexes(handles);

% Change visibility and range of Sliders depending on the targeted spectrum
[UIctrl_out] = UpdateSelectors( handles.target, handles.spectra_type, handles.id_spectra_list, ...
    handles.id_select_measurement, handles.select_measurement, handles.measurement_label, ...
    handles.id_select_stress, handles.select_stress, handles.stress_label);

handles.select_measurement = UIctrl_out{1};
handles.measurement_label = UIctrl_out{2};
handles.select_stress = UIctrl_out{3};
handles.stress_label= UIctrl_out{4};

% Update Selected Spectrum
handles.selected_spectrum = UpdateSelectedSpectrum( handles.target, handles.spectra_type, ...
    handles.id_spectra_list, handles.id_select_stress, handles.id_select_measurement);

% Update Plot
handles.spectrum_axes = UpdateSpectrumPlot(handles.selected_spectrum, handles.spectrum_axes);

% Update handles structure
guidata(hObject, handles);

% --- Executes on slider movement.
function select_stress_Callback(hObject, eventdata, handles)
% hObject    handle to select_stress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.id_select_stress = round(get(hObject,'Value'));
% ShowCurrentIndexes(handles);

% Change visibility and range of Sliders depending on the targeted spectrum
[UIctrl_out] = UpdateSelectors( handles.target, handles.spectra_type, handles.id_spectra_list, ...
    handles.id_select_measurement, handles.select_measurement, handles.measurement_label, ...
    handles.id_select_stress, handles.select_stress, handles.stress_label);

handles.select_measurement = UIctrl_out{1};
handles.measurement_label = UIctrl_out{2};
handles.select_stress = UIctrl_out{3};
handles.stress_label= UIctrl_out{4};

% Update Selected Spectrum
handles.selected_spectrum = UpdateSelectedSpectrum( handles.target, handles.spectra_type, ...
    handles.id_spectra_list, handles.id_select_stress, handles.id_select_measurement);

% Update Plot
handles.spectrum_axes = UpdateSpectrumPlot(handles.selected_spectrum, handles.spectrum_axes);


% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in select_spectrum.
function select_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to select_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = handles.selected_spectrum;

% Update handles structure
guidata(hObject, handles);
uiresume(handles.figure1);

