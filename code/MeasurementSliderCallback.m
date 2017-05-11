function handles = MeasurementSliderCallback( hObject, handles )

handles.data.choose.id_measurement = round(get(hObject,'Value'));

% ShowCurrentIndexes(handles);

% Update Selectors and Selected Spectrum
handles.data = UpdateSelectorsAndData( handles.data );

% Update Plot
UpdatePlot( handles.plot, handles.data );

% Update ROI list
RefreshRoiList( handles.data, handles.roi_list );
