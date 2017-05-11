function handles = MeasurementDialCallback( hObject, handles )

id_candidate = str2num(get(hObject,'String'));

%  handles.data.n_measurements,...
%  handles.data.n_stress,...

if isnumeric(id_candidate) && ~isempty(id_candidate)
    if 1 <= id_candidate  && id_candidate <= handles.data.n_measurements
        handles.data.choose.id_measurement = ceil(id_candidate);
    end
end

% Update Selectors and Selected Spectrum
handles.data = UpdateSelectorsAndData( handles.data );

% Update Plot
UpdatePlot( handles.plot, handles.data );

% Update ROI list
RefreshRoiList( handles.data, handles.roi_list );
