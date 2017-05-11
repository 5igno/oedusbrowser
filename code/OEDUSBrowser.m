function varargout = OEDUSBrowser(varargin)
% OEDUSBROWSER MATLAB code for OEDUSBrowser.fig
%      OEDUSBROWSER, by itself, creates a new OEDUSBROWSER or raises the existing
%      singleton*.
%
%      H = OEDUSBROWSER returns the handle to a new OEDUSBROWSER or the handle to
%      the existing singleton*.
%
%      OEDUSBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OEDUSBROWSER.M with the given input arguments.
%
%      OEDUSBROWSER('Property','Value',...) creates a new OEDUSBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OEDUSBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OEDUSBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OEDUSBrowser

% Last Modified by GUIDE v2.5 25-Apr-2017 00:55:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OEDUSBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @OEDUSBrowser_OutputFcn, ...
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

% --- Executes just before OEDUSBrowser is made visible.
function OEDUSBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OEDUSBrowser (see VARARGIN)

handles = OEDUSBrowserOpeningFunction(handles);

% Choose default command line output for SelectSpectrum
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OEDUSBrowser wait for user response (see UIRESUME)
% uiwait(handles.OEDUS_figure);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Output Function                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object deletion, before destroying properties.
function OEDUS_figure_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to OEDUS_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OEDUSBrowserClosignFunction(handles);

% --- Outputs from this function are returned to the command line.
function varargout = OEDUSBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 DATALIST Callback Functions                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in data_list.
function data_list_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to data_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns data_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from data_list

id_data_list = get(hObject,'Value');

handles = DataListCallback(id_data_list, handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in refresh_data_list_button.
function refresh_data_list_button_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_data_list_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = RefreshDataListCallback(handles);

% Choose default command line output for SelectSpectrum
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                  Slider Callback Functions                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on slider movement.
function measurement_slider_Callback(hObject, eventdata, handles)
% hObject    handle to measurement_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles = MeasurementSliderCallback( hObject, handles );

% Update handles structure
guidata(hObject, handles);

% --- Executes on text edit.
function measurement_dial_Callback(hObject, eventdata, handles)
% hObject    handle to measurement_dial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measurement_dial as text
%        str2double(get(hObject,'String')) returns contents of measurement_dial as a double

handles = MeasurementDialCallback( hObject, handles );

% Update handles structure
guidata(hObject, handles);

% --- Executes on slider movement.
function stress_slider_Callback(hObject, eventdata, handles)
% hObject    handle to stress_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles = StressSliderCallback(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on text edit.
function stress_dial_Callback(hObject, eventdata, handles)
% hObject    handle to stress_dial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stress_dial as text
%        str2double(get(hObject,'String')) returns contents of stress_dial as a double

handles = StressDialCallback( hObject, handles );

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              Plot Option Callback Functions                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in y_axis_menu.
function y_axis_menu_Callback(hObject, eventdata, handles)
% hObject    handle to y_axis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns y_axis_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from y_axis_menu

handles = YAxisMenuCallback(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in x_axis_menu.
function x_axis_menu_Callback(hObject, eventdata, handles)
% hObject    handle to x_axis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns x_axis_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from x_axis_menu

handles = XAxisMenuCallback(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function new_figure_icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to new_figure_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = PlotInNewFigureCallback(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                MODIFY ROI  Callback Functions                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in add_roi_button.
function add_roi_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_roi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = AddRoiCallback(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in roi_list.
function roi_list_Callback(hObject, eventdata, handles)
% hObject    handle to roi_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns roi_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roi_list

handles = RoiListCallback(hObject,handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in roi_choice_menu.
function roi_choice_menu_Callback(hObject, eventdata, handles)
% hObject    handle to roi_choice_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns roi_choice_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roi_choice_menu

handles = RoiChoiceMenuCallback(hObject,handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in delete_slct_roi_button.
function delete_slct_roi_button_Callback(hObject, eventdata, handles)
% hObject    handle to delete_slct_roi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = DeleteSlctRoiButtonCallback(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in delete_all_roi_button.
function delete_all_roi_button_Callback(hObject, eventdata, handles)
% hObject    handle to delete_all_roi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % --- Executes on button press in ROI_applied_checkbox.
% function ROI_applied_checkbox_Callback(hObject, eventdata, handles)
% % hObject    handle to ROI_applied_checkbox (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of ROI_applied_checkbox

handles = DeleteAllRoiButtonCallback(handles);

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              COPY/PASTE ROI   Callback Functions                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in get_roi_button.
function get_roi_button_Callback(hObject, eventdata, handles)
% hObject    handle to get_roi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = CopyRoiButtonCallback(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in set_roi_button.
function set_roi_button_Callback(hObject, eventdata, handles)
% hObject    handle to set_roi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = PasteRoiButtonCallback(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in set_all_roi_button.
function set_all_roi_button_Callback(hObject, eventdata, handles)
% hObject    handle to set_all_roi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = SetAllRoiButtonCallback(hObject,handles);

% Update handles structure
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                  FITTING   Callback Functions                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in fit_roi_button.
function fit_roi_button_Callback(hObject, eventdata, handles)
% hObject    handle to fit_roi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = FitRoiButtonCallback(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in optimize_button.
function optimize_button_Callback(hObject, eventdata, handles)
% hObject    handle to optimize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = OptimizeButtonCallback(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_all_button.
function fit_all_button_Callback(hObject, eventdata, handles)
% hObject    handle to fit_all_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = FitAllButtonCallback(hObject,handles);

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                       Create Functions                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function measurement_slider_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to measurement_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function stress_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stress_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function roi_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function roi_choice_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_choice_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function x_axis_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_axis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function y_axis_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_axis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function data_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function measurement_dial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measurement_dial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function stress_dial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stress_dial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
