function handles = SetAllRoiButtonCallback(hObject,handles)

% handles.target = SetAllFittingParameterss2Target(handles.FittingParameters, handles.target,...
%     handles.data.type, handles.id_data_list, handles.id_measurement);

if isfield( handles.data, 'FittingParameters' )
    if ~isempty( handles.data.FittingParameters )
        
        switch handles.data.type
            case 'SingleSpectrum'
                % Message the user
                set( handles.message_text , 'String', 'Setting Region of Interest to single spectrum');

                % Update the Fitting Parameters
                handles.data.target.FittingParameters = handles.data.FittingParameters;

            case 'InstrumentSequence'
                % Message the user
                set( handles.message_text , 'String', 'Setting Region of Interest to Instrument Sequence Step');

                handles.data.target.InstrumentSequence{handles.id_measurement}.FittingParameters = handles.data.FittingParameters;

            case 'StrainMeasurement'
                id_measurement = handles.data.choose.id_measurement;
                L = length( handles.data.target.InstrumentSequence{ id_measurement }.StressSequence );

                for ix_stress = handles.data.choose.id_stress : L

                    % Message the user
                    set( handles.message_text , 'String', ['Setting Region of Interest to Strain Step ',num2str( ix_stress ),' out of ',num2str( L )] );

                    handles.data.target.InstrumentSequence{ id_measurement }.StressSequence{ ix_stress }.FittingParameters = handles.data.FittingParameters;

                    % Update handles structure
                    guidata(hObject, handles);
                end
        end

        % Update Plot
        UpdatePlot( handles.plot, handles.data );

        % Update the ROI list
        RefreshRoiList( handles.data, handles.roi_list );

        % Message the User
        set( handles.message_text , 'String', ' ' );

        % Update handles structure
        guidata(hObject, handles);
    end
end


