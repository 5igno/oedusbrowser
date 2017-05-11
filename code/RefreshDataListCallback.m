function handles = RefreshDataListCallback(handles)

% Update Data in MATLAB Workspace wit current Target
UpdateDataInWorkspace( handles.data.target, handles.data.choose.names, handles.data.choose.id_list );

handles.data.choose.id_list = 1;
handles = InitializeSliders( handles );

% Update the list of spectra with the stuff you found on the workspace
[handles.data_list, handles.data.choose.names, handles.data.choose.type ] = UpdateDataList( handles.data_list );

% Update Target
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

% Update ROI list
RefreshRoiList( handles.data, handles.roi_list );
