function handles = OEDUSBrowserOpeningFunction(handles)

movegui(handles.OEDUS_figure,'center');

% Initialize State Variables
[ handles.data, handles.plot ] = InitializeState;

% Set UIcontrol handles in handles.plot
handles.plot.optical.hndl.spectrum_options_panel = handles.spectrum_options_panel;
handles.plot.optical.hndl.roi_panel              = handles.roi_panel;
handles.plot.optical.hndl.spectrum_panel         = handles.spectrum_panel;
handles.plot.optical.hndl.spectrum_axes          = handles.spectrum_axes;
handles.plot.electrical.hndl.iv_panel            = handles.iv_panel;

handles.data.hndl.data_list = handles.data_list;
handles.data.hndl.measurement_label = handles.measurement_label;
handles.data.hndl.measurement_dial = handles.measurement_dial;
handles.data.hndl.measurement_slider = handles.measurement_slider;
handles.data.hndl.stress_label = handles.stress_label;
handles.data.hndl.stress_dial = handles.stress_dial;
handles.data.hndl.stress_slider = handles.stress_slider;

% Update the list of spectra with the stuff you found on the workspace
[handles.data_list, handles.data.choose.names, handles.data.choose.type] = UpdateDataList( handles.data_list );

% Update Target and Selected Spectrum
[handles.data.target,...
 handles.data.type,...
 handles.data.n_measurements,...
 handles.data.n_stress,...
 handles.data.max_stress ] = ...
 UpdateTargetVariable( handles.data.choose.names, handles.data.choose.type, handles.data.choose.id_list );

    
% Update Selectors and Selected Spectrum
handles.data = UpdateSelectorsAndData( handles.data );

% Update Plot 
UpdatePlot( handles.plot, handles.data );

% Update the ROI list
RefreshRoiList( handles.data, handles.roi_list );