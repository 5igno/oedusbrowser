function handles = PasteRoiButtonCallback(handles)

if isfield( handles.data, 'FittingParameters' )
    if ~isempty( handles.data.FittingParameters )

        handles.data.selected.FittingParameters = handles.data.FittingParameters ;

        % Update Target with the selected_data
        data_type = handles.data.choose.type{ handles.data.choose.id_list };
        handles.data.target = SelectedSpectrum2Target( handles.data.selected, handles.data.target , data_type, handles.data.choose.id_stress, handles.data.choose.id_measurement );

        % Update Plot
        UpdatePlot( handles.plot, handles.data );

        % Update the ROI list
        RefreshRoiList( handles.data, handles.roi_list );
    end
end