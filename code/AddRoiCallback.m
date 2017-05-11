function handles = AddRoiCallback(handles)

if ~isfield( handles.data.selected, 'FittingParameters' )
    handles.data.selected.FittingParameters = {};
end

% Add ROI to the list, in selected spectrum
handles.data.selected.FittingParameters = ...
    AddROI( handles.data.selected.FittingParameters, handles.data.roi.choice,...
    handles.data.selected, handles.plot.optical.x_type, handles.message_text );


[ handles.data.roi.slct , ~ ] = size( handles.data.selected.FittingParameters ); 
% % Update has_roi flag
% handles.has_fit = isfield(handles.data.selected,'FittingParameters');

% Update Target with the selected_data
data_type = handles.data.choose.type{ handles.data.choose.id_list };
handles.data.target = SelectedSpectrum2Target( handles.data.selected, handles.data.target ,...
    data_type, handles.data.choose.id_stress, handles.data.choose.id_measurement );

% Update Selectors and Selected Spectrum
handles.data = UpdateSelectorsAndData( handles.data );

% Update Plot
UpdatePlot( handles.plot, handles.data );

% Update the ROI list
RefreshRoiList( handles.data, handles.roi_list );

% % Update the ROI list
% UpdateRoiIndicator(handles)
