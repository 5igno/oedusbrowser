function handles = DataListCallback( id_data_list, handles )

if handles.data.choose.id_list ~= id_data_list % if index is different
    
    % Update Data in MATLAB Workspace wit current Target
    UpdateDataInWorkspace( handles.data.target, handles.data.choose.names, handles.data.choose.id_list );
    
    % Initialize Sliders
    handles.data.choose = InitializeSliders( handles.data.choose );
    
    % Update the data list index
    handles.data.choose.id_list = id_data_list;

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

end