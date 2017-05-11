function varargout = SpectrumSelection(varargin)
% SPECTRUMSELECTION MATLAB code for SpectrumSelection.fig
%      SPECTRUMSELECTION, by itself, creates a new SPECTRUMSELECTION or raises the existing
%      singleton*.
%
%      H = SPECTRUMSELECTION returns the handle to a new SPECTRUMSELECTION or the handle to
%      the existing singleton*.
%
%      SPECTRUMSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTRUMSELECTION.M with the given input arguments.
%
%      SPECTRUMSELECTION('Property','Value',...) creates a new SPECTRUMSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpectrumSelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpectrumSelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpectrumSelection

% Last Modified by GUIDE v2.5 14-Jun-2011 16:21:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpectrumSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @SpectrumSelection_OutputFcn, ...
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


% --- Executes just before SpectrumSelection is made visible.
function SpectrumSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpectrumSelection (see VARARGIN)

% Choose default command line output for SpectrumSelection

workspace_list = evalin('base', 'whos;');
[N_variables,~] = size(workspace_list);

handles.structures_list = cell(0,0);

indice=1;
for k=1:N_variables;
    if strcmp(workspace_list(k).class,'struct')
        handles.structures_list{indice,1} = workspace_list(k).name;
        indice = indice + 1;
    end
end

set(handles.Spectra_listbox,'String',handles.structures_list(:,1));
set(handles.Spectra_listbox,'Value',1);
set(handles.axes1,'Visible','off');
    
% Update handles structure
guidata(hObject, handles);

% % UIWAIT makes SpectrumSelection wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SpectrumSelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

close;


% --- Executes on selection change in Spectra_listbox.
function Spectra_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Spectra_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Spectra_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Spectra_listbox

handles.id_Structure = get(hObject,'Value');

handles.Spectra_structure = evalin('base', handles.structures_list{handles.id_Structure});
[~,N_spectra] = size(handles.Spectra_structure);

if N_spectra >0 && isfield(handles.Spectra_structure(1),'energy')
    set(handles.which_spectrum_botton,'value',1);
    set(handles.which_spectrum_botton,'Visible','on');
    set(handles.axes1,'Visible','on');
    
    spectralist = cell(N_spectra,1);
    for  k = 1: N_spectra
        spectralist{k,1}=num2str(k);
    end
    set(handles.which_spectrum_botton,'String',spectralist);
    handles.id_Spectrum = 1;
    GUIplot(handles.axes1,handles.Spectra_structure,handles.id_Spectrum);
    handles.Selected_spectrum = handles.Spectra_structure(handles.id_Spectrum);

else
    cla
    set(handles.which_spectrum_botton,'Visible','off');
    set(handles.which_spectrum_botton,'value',1);
    set(handles.which_spectrum_botton,'String','No spectrum avaialble');
    set(handles.axes1,'Visible','off');
    
end

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Spectra_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Spectra_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in which_spectrum_botton.
function which_spectrum_botton_Callback(hObject, eventdata, handles)
% hObject    handle to which_spectrum_botton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.id_Spectrum = get(hObject,'Value');

GUIplot(handles.axes1,handles.Spectra_structure,handles.id_Spectrum);

handles.Selected_spectrum = handles.Spectra_structure(handles.id_Spectrum);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Select_Spectrum_Botton.
function Select_Spectrum_Botton_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Spectrum_Botton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = handles.Selected_spectrum;
cla;

% Update handles structure
guidata(hObject, handles);
uiresume(handles.figure1);


function hndl = GUIplot ( axes , Spectra_structure , id )

hndl = plot(axes,Spectra_structure(id).energy,Spectra_structure(id).intensity);
% A couple fo graphical options are set:
set(hndl,'LineWidth',2);
% linewidth in the graph = 2
ylabel('Intensity'), xlabel('Energy [eV]');

axis tight;