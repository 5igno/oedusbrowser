function varargout = RamanGUI(varargin)
% RAMANGUI MATLAB code for RamanGUI.fig
%      RAMANGUI, by itself, creates a new RAMANGUI or raises the existing
%      singleton*.
%
%      H = RAMANGUI returns the handle to a new RAMANGUI or the handle to
%      the existing singleton*.
%
%      RAMANGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAMANGUI.M with the given input arguments.
%
%      RAMANGUI('Property','Value',...) creates a new RAMANGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RamanGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RamanGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RamanGUI

% Last Modified by GUIDE v2.5 25-Jul-2016 14:31:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RamanGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RamanGUI_OutputFcn, ...
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
%%%                   STARTUP FUNCTIONS BLOCK                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before RamanGUI is made visible.
function RamanGUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RamanGUI (see VARARGIN)

% handles.output = hObject;

% Initialize the peak list structures:
handles.peaks=[];
N_peaks=0;
peak_pos_list=cell(0,0);
handles.N_peaks = N_peaks;

maybe_selected_spectrum = cell2mat(varargin);

if isempty(maybe_selected_spectrum)
    
    set(handles.Load_spectrum,'Visible','on');
    set(handles.Return_fit,'Visible','off');
    
    % Select the spectrum by User Interface
    handles.Selected_Spectrum = SelectSpectrum;
else
    set(handles.Load_spectrum,'Visible','off');
    set(handles.Return_fit,'Visible','on');
        
    handles.Selected_Spectrum = maybe_selected_spectrum;
end
if isfield(handles.Selected_Spectrum,'RamanShift')
    handles.Range = handles.Selected_Spectrum.RamanShift;
else
    handles.Range = handles.Selected_Spectrum.Energy;
end

Update_plot(hObject,handles);

handles.Updatefittingswitch = get(handles.update_peaklist_radiobotton,'Value');

% Update handles structure
guidata(hObject, handles);


uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                   CLOSING FUNCTIONS BLOCK                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = RamanGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.Fitting.Parameters;
varargout{2} = handles.Fitting.Intensity;
varargout{3} = handles.Fitting.Uncertainty;

delete(hObject);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                       Peak LIST Functions                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in peak_list.
function peak_list_Callback(hObject, eventdata, handles)  %#ok<*DEFNU>
% hObject    handle to peak_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

% make sure that the new peak is the one selected on the list.
handles.current.id_peak = get(hObject,'Value');

handles = Update_current_peak(handles);

% Update all the GUI interfaces;
handles = Update_Peaklist_labels(handles);
handles = UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function peak_list_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to peak_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 Push-buttons Functions                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in update_peaklist_radiobotton.
function update_peaklist_radiobotton_Callback(hObject, eventdata, handles)
% hObject    handle to update_peaklist_radiobotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of update_peaklist_radiobotton

handles.Updatefittingswitch = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in addpeak.
function addpeak_Callback(hObject, eventdata, handles)
% hObject    handle to addpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.peaks)
    % Set the slider pannel to visible in case they are not ()
    set(handles.position_panel,'Visible','on')
    set(handles.height_panel,'Visible','on')
    set(handles.width_panel,'Visible','on')
    set(handles.delete_peak,'Visible','on')
    set(handles.peak_list,'Visible','on')
end

% Get the Position, Width and FWHM from Ginput
title('Click on the maximum of the peak you want to fit');
[ Peak_position , Maximum_intensity ] = ginput(1);
title('Click on the points at half maximum (FWHM)');
[ EWidth , ~ ] = ginput(2);
title(' ');
% Compute the FWHM
Line_broadening = abs(diff(EWidth))/2;

peak_pos_list = get(handles.peak_list,'String');
N_peaks = handles.N_peaks;

id = N_peaks+1;

% add a new peak to the peak list
peak_pos_list{N_peaks+1,1} = num2str(Peak_position);

set(handles.peak_list,'string',peak_pos_list);

% update the handles.current structure
handles.current.id_peak = id;

% Store the new data in the handles structure
handles.peaks(id).position = Peak_position;
handles.peaks(id).height = Maximum_intensity;
handles.peaks(id).width = Line_broadening;

% saving the number of Peaks
handles.N_peaks = N_peaks+1;

% Update
handles = Update_current_peak(handles);

% Update all the GUI interfaces;
handles = Update_Peaklist_labels(handles);
handles = UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);

% Re-plot all data and lineshapes
Update_plot(hObject,handles)

% --- Executes on button press in delete_peak.
function delete_peak_Callback(hObject, eventdata, handles)
% hObject    handle to delete_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

N_peaks = handles.N_peaks;

if  N_peaks > 0

    peak_pos_list = get(handles.peak_list,'String');
    id = handles.current.id_peak;

    % update the handles.current structure
    handles.current.id_peak = max([id-1,1]);


    % Necessary to declare data type: otherwise the function later organizes
    % everthing in a matrix instead of a cell;

    newlist = cell(0,0);

    incremento = 1;
    for k=1:N_peaks
        if k ~= id
            newlist(incremento,1) = peak_pos_list(k);
            newpeaks(incremento) = handles.peaks(k); %#ok<*AGROW>
            incremento = incremento + 1;
        end
    end

    set(handles.peak_list,'Value',max([id-1,1]));
    set(handles.peak_list,'String',newlist);

    if exist('newpeaks','var')
        handles.peaks = newpeaks;
    else
        handles.peaks = [];
    end


    if N_peaks == 1 % Then this is the last peak remained

        % Switch off the slider pannels
        set(handles.position_panel,'Visible','off')
        set(handles.height_panel,'Visible','off')
        set(handles.width_panel,'Visible','off')
        set(handles.peak_list,'Visible','off')
    else
        handles = Update_current_peak(handles);
        handles = UpdateSliders(handles);
    end

    handles.N_peaks = N_peaks-1;

    % Update handles structure
    guidata(hObject, handles);

    % Re-plot all data and lineshapes
    Update_plot(hObject,handles)
end

% --- Executes on button press in Add_baseline_button.
function Add_baseline_button_Callback(hObject, eventdata, handles)
% hObject    handle to Add_baseline_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the Position, Width and FWHM from Ginput
title('Click on two ponts on the background at the extremes');
[ X , Y ] = ginput(2);
title(' ');

Slope = (Y(2)-Y(1))./(X(2)-X(1));
Intercept = Y(1)+ (Y(2)-Y(1))./(X(2)-X(1)).*(-X(1));

handles.Baseline.Slope = Slope;
handles.Baseline.Intercept = Intercept;

% Update handles structure
guidata(hObject, handles);

Update_plot(hObject,handles);

% --- Executes on button press in Delete_Baseline_botton.
function Delete_Baseline_botton_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_Baseline_botton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'Baseline')
    handles = rmfield(handles, 'Baseline');


    % Update handles structure
    guidata(hObject, handles);

    Update_plot(hObject,handles);
end

% --- Executes on button press in Fit.
function Fit_Callback(hObject, eventdata, handles)
% hObject    handle to Fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.N_peaks == 0
    addpeak_Callback(hObject, eventdata, handles)
end

Q(1).label = 'N_peaks';
Q(2).label = 'Maximum_intensity';
Q(3).label = 'Peak_position';
Q(4).label = 'Line_broadening';

for id_peak=1:handles.N_peaks

    Q(2).value(id_peak) = handles.peaks(id_peak).height;
    Q(3).value(id_peak) = handles.peaks(id_peak).position;
    Q(4).value(id_peak) = handles.peaks(id_peak).width;
    P(3*(id_peak-1)+(1:3)) = [ handles.peaks(id_peak).height , handles.peaks(id_peak).position , handles.peaks(id_peak).width ];

end

Q(1).value = handles.N_peaks;


lenght_P = 3.*handles.N_peaks;
lenght_Q=4;

if isfield(handles,'Baseline')
    lenght_Q = lenght_Q+1;
    Q(lenght_Q).label = 'Slope';
    Q(lenght_Q).value = handles.Baseline.Slope;

    lenght_P = lenght_P + 1;
    P(lenght_P) = handles.Baseline.Slope;

    lenght_Q = lenght_Q+1;
    Q(lenght_Q).label = 'Intercept';
    Q(lenght_Q).value = handles.Baseline.Intercept;

    lenght_P = lenght_P + 1;
    P(lenght_P) = handles.Baseline.Intercept;
end

handles.Fitting.Parameters = [];
% % Fill the Fit Parameter cell

handles.Fitting.Parameters = AddFitParameters(handles.Fitting.Parameters,'Trial',Q);

% this should be exactly equal to the User guess:
ITrial = Lorentzian_Lineshape_GUI(handles.Range, Q, P);


%%%%%%%%%%%% HERE WE RUN THE OPTIMIZATION %%%%%%%%%%%%%%%%%
[handles.Fitting.Intensity, P, handles.Fitting.Uncertainty, uncertainty_p] = GIOleasqr(handles.Range',handles.Selected_Spectrum.Intensity', Q, P, 'Lorentzian_Lineshape_GUI');

% Get the new parameters in Q
% function Q=LorentzUpdateQ(P,Q,N_peaks,lQ)
for id_parameter=2:lenght_Q % N_peaks should not be changed
    switch id_parameter
        case{2,3,4}
        indexes = (id_parameter-1)+3*(0:1:handles.N_peaks-1);
        Q(id_parameter).value = P(indexes);
        Q(id_parameter).uncertainty = uncertainty_p(indexes);
        otherwise
        indexes = (id_parameter-1)+3*(handles.N_peaks-1);
        Q(id_parameter).value = P(indexes);
        Q(id_parameter).uncertainty = uncertainty_p(indexes);
    end
end

% Fill the Fit Parameter cell
handles.Fitting.Parameters = AddFitParameters(handles.Fitting.Parameters,'Fitted',Q);

if handles.Updatefittingswitch
    % Update the Fittingposition of the peaks:
    for id_peak=1:handles.N_peaks
        handles.peaks(id_peak).height = Q(2).value(id_peak);
        handles.peaks(id_peak).position = Q(3).value(id_peak);
        handles.peaks(id_peak).width = Q(4).value(id_peak);
    end
    if isfield(handles,'Baseline')
        handles.Baseline.Slope = Q(5).value;
        handles.Baseline.Intercept = Q(6).value;
    end

    handles = Update_current_peak(handles);
    % Update all the GUI interfaces;
    handles = Update_Peaklist_labels(handles);
    handles = UpdateSliders(handles);
end

% Update handles structure
guidata(hObject, handles);

% Update plot
Update_plot(hObject,handles)


function New_Fit_parameters = AddFitParameters(Fit_parameters,label,Q)

    if isempty(Fit_parameters)
        New_Fit_parameters = {label,Q}; 
    else
        New_Fit_parameters = [Fit_parameters;{label,Q}];
    end

% --- Executes on button press in Remove_Fitting.
function Remove_Fitting_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'Fitting')
    handles = rmfield(handles, 'Fitting');

    % Update handles structure
    guidata(hObject, handles);

    Update_plot(hObject,handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 Slider Functions :  Position                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------- Callbacks -----------------------------%

function slider_pos_Callback(hObject, eventdata, handles)
% hObject    handle to slider_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the new position from the slider
handles.current.position.num_pos = get(hObject,'Value');

% Update Sliders with the current data;
handles = UpdateSliders(handles);
% Update the Peak-list with the new position;
handles = Update_Peaklist_labels(handles);
% Update handles.peak
handles = Update_peak_data(handles);

% Update handles structure
guidata(hObject, handles);

% Update the plot
Update_plot_single_peak(hObject,handles);


function text_min_pos_Callback(hObject, eventdata, handles)
% hObject    handle to text_min_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='position';
New_minimo=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_minimum(handles,which_parameter,New_minimo);

% Undate Sliders with the current data;
handles = UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);

function text_max_pos_Callback(hObject, eventdata, handles)
% hObject    handle to text_max_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


which_parameter='position';
New_massimo=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_maximum(handles,which_parameter,New_massimo);

% Undate Sliders with the current data;
handles = UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);

function text_pos_Callback(hObject, eventdata, handles)
% hObject    handle to text_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='position';
New_pos=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_position(handles,which_parameter,New_pos);

% Update Sliders and peaklist with the current data;
handles = UpdateSliders(handles);
handles = Update_Peaklist_labels(handles);
% Update handles.peak
handles = Update_peak_data(handles);

% Update handles structure
guidata(hObject, handles);

% Update the plot
Update_plot_single_peak(hObject,handles);


%----------------------------- Createfcn ----------------------------%

function slider_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function text_min_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_min_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function text_max_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_max_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function text_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 Slider Functions :  Width                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------- Callbacks -----------------------------%

function slider_width_Callback(hObject, eventdata, handles)
% hObject    handle to slider_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the new position from the slider
handles.current.width.num_pos = get(hObject,'Value');

% Undate Sliders with the current data;
handles=UpdateSliders(handles);
% Update handles.peak
handles = Update_peak_data(handles);

% Update handles structure
guidata(hObject, handles);

% Update the plot
Update_plot_single_peak(hObject,handles);


function text_min_width_Callback(hObject, eventdata, handles)
% hObject    handle to text_min_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='width';
New_minimo=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_minimum(handles,which_parameter,New_minimo);

% Undate Sliders with the current data;
handles=UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);


function text_max_width_Callback(hObject, eventdata, handles)
% hObject    handle to text_max_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='width';
New_massimo=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_maximum(handles,which_parameter,New_massimo);

% Undate Sliders with the current data;
handles=UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);

function text_width_Callback(hObject, eventdata, handles)
% hObject    handle to text_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='width';
New_pos=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_position(handles,which_parameter,New_pos);

% Update Sliders and peaklist with the current data;
handles = UpdateSliders(handles);
handles = Update_Peaklist_labels(handles);
% Update handles.peak
handles = Update_peak_data(handles);

% Update handles structure
guidata(hObject, handles);

% Update the plot
Update_plot_single_peak(hObject,handles);


%----------------------------- Createfcn ----------------------------%
%                     I didn't put anything here                     %

function slider_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function text_min_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_min_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function text_max_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_max_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function text_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 Slider Functions :  Height                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------- Callbacks -----------------------------%

function slider_height_Callback(hObject, eventdata, handles)
% hObject    handle to slider_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the new position from the slider
handles.current.height.num_pos = get(hObject,'Value');

% Undate Sliders with the current data;
handles=UpdateSliders(handles);
% Update handles.peak
handles = Update_peak_data(handles);

% Update handles structure
guidata(hObject, handles);

% Update the plot
Update_plot_single_peak(hObject,handles);


function text_min_height_Callback(hObject, eventdata, handles)
% hObject    handle to text_min_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='height';
New_minimo=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_minimum(handles,which_parameter,New_minimo);

% Undate Sliders with the current data;
handles=UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);

function text_max_height_Callback(hObject, eventdata, handles)
% hObject    handle to text_max_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='height';
New_massimo=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_maximum(handles,which_parameter,New_massimo);

% Undate Sliders with the current data;
handles=UpdateSliders(handles);

% Update handles structure
guidata(hObject, handles);

function text_height_Callback(hObject, eventdata, handles)
% hObject    handle to text_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

which_parameter='height';
New_pos=str2double(get(hObject,'String'));

% Get the new minimum from the user... if it makes sense
handles = get_new_position(handles,which_parameter,New_pos);

% Update Sliders and peaklist with the current data;
handles = UpdateSliders(handles);
handles = Update_Peaklist_labels(handles);
% Update handles.peak
handles = Update_peak_data(handles);

% Update handles structure
guidata(hObject, handles);

% Update the plot
Update_plot_single_peak(hObject,handles);


%----------------------------- Createfcn ----------------------------%
%                     I didn't put anything here                     %

function slider_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function text_min_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_min_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function text_max_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_max_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function text_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Toolbar callbacks                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Load_spectrum_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Load_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Selected_Spectrum = SelectSpectrum;

% Update handles structure
guidata(hObject, handles);

Update_plot(hObject,handles)

% --------------------------------------------------------------------
function New_Figure_Plot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to New_Figure_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;

Update_plot(hObject,handles, gca);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                  Custom made function:                          %%%
%%%                  all GIO responsibility                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = Update_Peaklist_labels(handles)

id = handles.current.id_peak;

% If the current peak position has changed also its label has to change in the peak list
new_peak_list = get(handles.peak_list,'String');

new_peak_list{id} = num2str(handles.current.position.num_pos);

set(handles.peak_list,'String',new_peak_list);
set(handles.peak_list,'Value',id);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles.peak
function handles = Update_peak_data(handles)

% update the handles.current structure
id = handles.current.id_peak;

% Store the new data in the handles structure
handles.peaks(id).position = handles.current.position.num_pos;
handles.peaks(id).height = handles.current.height.num_pos;
handles.peaks(id).width = handles.current.width.num_pos;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = UpdateSliders(handles)
% Updates all text and sliders to achieve consistence

% Filling the gui datastructure with the current peak position data
set(handles.slider_pos,'Max',handles.current.position.num_massimo);
set(handles.slider_pos,'Min',handles.current.position.num_minimo);
set(handles.slider_pos,'Value',handles.current.position.num_pos);
set(handles.slider_pos,'SliderStep',(handles.current.position.num_massimo-handles.current.position.num_minimo).*[1e-5 1e-4]);

set(handles.text_min_pos,'String',num2str(handles.current.position.num_minimo));
set(handles.text_max_pos,'String',num2str(handles.current.position.num_massimo));
set(handles.text_pos,'String',num2str(handles.current.position.num_pos));

% Filling the gui datastructure with the current peak position data
set(handles.slider_height,'Max',handles.current.height.num_massimo);
set(handles.slider_height,'Min',handles.current.height.num_minimo);
set(handles.slider_height,'Value',handles.current.height.num_pos);
set(handles.slider_height,'SliderStep',(handles.current.height.num_massimo-handles.current.height.num_minimo).*[1e-4 1e-3]);

set(handles.text_min_height,'String',num2str(handles.current.height.num_minimo));
set(handles.text_max_height,'String',num2str(handles.current.height.num_massimo));
set(handles.text_height,'String',num2str(handles.current.height.num_pos));

% Filling the gui datastructure with the current peak width
set(handles.slider_width,'Max',handles.current.width.num_massimo);
set(handles.slider_width,'Min',handles.current.width.num_minimo);
set(handles.slider_width,'Value',handles.current.width.num_pos);
if isfield(handles.Selected_Spectrum,'RamanShift')
    set(handles.slider_width,'SliderStep',handles.current.width.num_pos.*[1e-3 1e-2]);
else
    set(handles.slider_width,'SliderStep',handles.current.width.num_pos.*[1e-3 1e-2]);
end

set(handles.text_min_width,'String',num2str(handles.current.width.num_minimo));
set(handles.text_max_width,'String',num2str(handles.current.width.num_massimo));
set(handles.text_width,'String',num2str(handles.current.width.num_pos));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = get_new_minimum(handles,which_parameter,New_minimo)

Max=eval(['handles.current.',which_parameter,'.num_massimo;']);
Pos=eval(['handles.current.',which_parameter,'.num_pos;']);
Old_minimo=eval(['handles.current.',which_parameter,'.num_minimo;']); %#ok<*NASGU>

if  isnumeric(New_minimo) && New_minimo<Pos && New_minimo<Max
    eval(['handles.current.',which_parameter,'.num_minimo=New_minimo;']);
else
    eval(['handles.current.',which_parameter,'.num_minimo=Old_minimo;']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = get_new_maximum(handles,which_parameter,New_massimo)

Min=eval(['handles.current.',which_parameter,'.num_minimo;']);
Pos=eval(['handles.current.',which_parameter,'.num_pos;']);
Old_massimo=eval(['handles.current.',which_parameter,'.num_massimo;']);

if  isnumeric(New_massimo) && New_massimo>Pos && New_massimo>Min
    eval(['handles.current.',which_parameter,'.num_massimo=New_massimo;']);
else
    eval(['handles.current.',which_parameter,'.num_massimo=Old_massimo;']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = get_new_position(handles,which_parameter,New_pos)

Min=eval(['handles.current.',which_parameter,'.num_minimo;']);
Max=eval(['handles.current.',which_parameter,'.num_massimo;']);
Old_pos=eval(['handles.current.',which_parameter,'.num_pos;']);

if  isnumeric(New_pos) &&  New_pos<Max && New_pos>Min
    eval(['handles.current.',which_parameter,'.num_pos=New_pos;']);
else
   eval(['handles.current.',which_parameter,'.num_pos=Old_pos;']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = Update_current_peak(handles)

% update the handles.current structure
id = handles.current.id_peak;

% Get the position, hight and width of peak(id)
Peak_position = handles.peaks(id).position;
Maximum_intensity = handles.peaks(id).height;
Line_broadening = handles.peaks(id).width;

% update the sliders
handles.current.position.num_massimo = Peak_position * (1+0.2);
handles.current.position.num_minimo  = Peak_position * (1-0.2);
handles.current.position.num_pos = Peak_position;

handles.current.height.num_massimo = Maximum_intensity * (1+0.2);
handles.current.height.num_minimo  = Maximum_intensity * (1-0.2);
handles.current.height.num_pos = Maximum_intensity;

handles.current.width.num_massimo = Line_broadening * (1+0.9);
handles.current.width.num_minimo  = Line_broadening * (1-0.9);
handles.current.width.num_pos = Line_broadening;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Update_plot(hObject,handles, varargin)
% this function is called when a new peak is added or deleted:
% it deletes the axes and replots everything from the scratch;

if isempty(varargin)
    current_axis = handles.Axes;
else
    current_axis = varargin{1};
end

% Deleting all the curves in the current axes:
single_curve_handle = get(current_axis,'children');
delete(single_curve_handle);

if isfield(handles,'plot')
    handles = rmfield(handles,'plot');
end

box(current_axis,'on');
hold(current_axis,'on');

N_peaks = handles.N_peaks;

if isfield(handles,'Baseline')
    % Baseline subtraction is available
    Baseline = handles.Baseline.Intercept + handles.Baseline.Slope.*handles.Range;
    if N_peaks > 0
        % At least one peak available with baseline
        % plot the single lorentian contributions, with baseline
        farbe=prism(N_peaks); % Set the color to be used : try also jet(N_peaks);
        for k=1:N_peaks
            Intensity = Lorentian (handles.Range,handles.peaks(k));
            handles.plot(k).handle = plot(current_axis,handles.Range,Intensity + Baseline,'DisplayName',num2str(handles.peaks(k).position));
            set(handles.plot(k).handle,'LineWidth',2,'color',farbe(k,:));
            handles.plot(k).label = num2str(handles.peaks(k).position);
        end
        % plot the sum of all lorentians with baseline
        Intensity = Lorentian (handles.Range,handles.peaks);
        handles.plot(N_peaks+1).handle = plot(current_axis,handles.Range,Intensity + Baseline,'DisplayName','User Guess');
        set(handles.plot(N_peaks+1).handle,'LineWidth',2,'LineWidth',2,'color','black');
        handles.plot(N_peaks+1).label = 'User Guess';
        % plot the raw data
        handles.plot(N_peaks+2).handle = plot(current_axis,handles.Range,handles.Selected_Spectrum.Intensity,'ob','DisplayName','Raw Data');
        handles.plot(N_peaks+2).label = 'Raw Data';
        % plot the baseline
        handles.plot(N_peaks+3).handle = plot(current_axis,handles.Range,Baseline,'--','DisplayName','Baseline');
        set(handles.plot(N_peaks+3).handle,'LineWidth',2,'color',[0.7,0.7,0.7]);
        handles.plot(N_peaks+3).label = 'Baseline';
        % if there's a fitting and you did not update the list, plot also the fitting
        if isfield(handles,'Fitting') && not(handles.Updatefittingswitch)
        	handles.plot(N_peaks+4).handle = plot(current_axis,handles.Range,handles.Fitting.Intensity,'-.','DisplayName','Fitting');
            set(handles.plot(N_peaks+4).handle,'LineWidth',2,'color','green');
            handles.plot(N_peaks+4).label = 'Fitting';
        end
    else
        % No peak available, but baseline
        % no lorentian contributions, with baseline
        % no sum of all lorentians with baseline
        
        % plot the raw data
        handles.plot(1).handle = plot(current_axis,handles.Range,handles.Selected_Spectrum.Intensity,'ob','DisplayName','Raw Data');
        handles.plot(1).label = 'Raw Data';
        % plot the baseline
        handles.plot(2).handle = plot(current_axis,handles.Range,Baseline,'--','DisplayName','Baseline');
        set(handles.plot(2).handle,'LineWidth',2,'color',[0.7,0.7,0.7]);
        handles.plot(2).label = 'Baseline';
        % if there's a fitting and you did not update the list, plot also the fitting
        if isfield(handles,'Fitting') && not(handles.Updatefittingswitch)
        	handles.plot(3).handle = plot(current_axis,handles.Range,handles.Fitting.Intensity,'-.','DisplayName','Fitting');
            set(handles.plot(3).handle,'LineWidth',2,'color','green');
            handles.plot(3).label = 'Fitting';
        end
    end
else
    % No Baseline subtraction 
    if N_peaks > 0
        % At least one peak available without baseline
        % plot the single lorentian contributions
        farbe=prism(N_peaks); % Set the color to be used : try also jet(N_peaks);
        for k=1:N_peaks
            Intensity = Lorentian (handles.Range,handles.peaks(k));
            handles.plot(k).handle = plot(current_axis,handles.Range,Intensity ,'DisplayName',num2str(handles.peaks(k).position));
            set(handles.plot(k).handle,'LineWidth',2,'color',farbe(k,:));
            handles.plot(k).label = num2str(handles.peaks(k).position);
        end
        % plot the sum of all lorentians
        Intensity = Lorentian (handles.Range,handles.peaks);
        handles.plot(N_peaks+1).handle = plot(current_axis,handles.Range,Intensity ,'DisplayName','Fitting');
        set(handles.plot(N_peaks+1).handle,'LineWidth',2,'LineWidth',2,'color','black');
        handles.plot(N_peaks+1).label = 'Fitting';
        % plot the raw data
        handles.plot(N_peaks+2).handle = plot(current_axis,handles.Range,handles.Selected_Spectrum.Intensity,'ob','DisplayName','Raw Data');
        handles.plot(N_peaks+2).label = 'Raw Data';
        % if there's a fitting and you did not update the list, plot also the fitting
        if isfield(handles,'Fitting') && not(handles.Updatefittingswitch)
        	handles.plot(N_peaks+3).handle = plot(current_axis,handles.Range,handles.Fitting.Intensity,'-.','DisplayName','Fitting');
            set(handles.plot(N_peaks+3).handle,'LineWidth',2,'color','green');
            handles.plot(N_peaks+3).label = 'Fitting';
        end
    else
        % No peak available, no baseline
        % no lorentian contributions, no baseline
        % no sum of all lorentians, no baseline
        
        % plot the raw data
        handles.plot(1).handle = plot(current_axis,handles.Range,handles.Selected_Spectrum.Intensity,'ob','DisplayName','Raw Data');
        handles.plot(1).label = 'Raw Data';
        % no baseline

        % if there's a fitting and you did not update the list, plot also the fitting
        if isfield(handles,'Fitting') && not(handles.Updatefittingswitch)
        	handles.plot(2).handle = plot(current_axis,handles.Range,handles.Fitting.Intensity,'-.','DisplayName','Fitting');
            set(handles.plot(2).handle,'LineWidth',2,'color','green');
            handles.plot(2).label = 'Fitting';
        end
        
    end
end

ylabel('Intensity'),
if isfield(handles.Selected_Spectrum,'RamanShift')
    xlabel('Raman Shift (cm^{-1})');
else
    xlabel('Energy (eV)');
end
axis tight

hold(current_axis,'off');

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Update_plot_single_peak(hObject,handles)

% update the handles.current structure
id = handles.current.id_peak;

N_peaks = handles.N_peaks;

if isfield(handles,'Baseline')

    %% modify the selected peak
    % recalculate the single Lorentian which has been modified;
    Intensity = Lorentian (handles.Range,handles.peaks(id));
    Baseline = handles.Baseline.Intercept + handles.Baseline.Slope.*handles.Range;
    
    set(handles.plot(id).handle,'YData',Intensity+Baseline);

    % recalculate the overall Lorentian fitting;
    Intensity = Lorentian (handles.Range,handles.peaks);
    set(handles.plot(N_peaks+1).handle,'YData',Intensity+Baseline);
else
    %% modify the selected peak
    % recalculate the single Lorentian which has been modified;
    Intensity = Lorentian (handles.Range,handles.peaks(id));
    set(handles.plot(id).handle,'YData',Intensity);

    % recalculate the overall Lorentian fitting;
    Intensity = Lorentian (handles.Range,handles.peaks);
    set(handles.plot(N_peaks+1).handle,'YData',Intensity);
end


% --------------------------------------------------------------------
function Return_fit_Clicked_Callback(hObject, eventdata, handles)
% hObject    handle to Return_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'Fitting')
    handles.output = handles.Fitting.Parameters;

    % Update handles structure
    guidata(hObject, handles);

    uiresume(handles.figure1)
end
