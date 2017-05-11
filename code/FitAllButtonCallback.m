function handles = FitAllButtonCallback(hObject,handles)

if ~isempty(handles.data.choose.type)
    switch handles.data.choose.type{ handles.data.choose.id_list }
        case 'SingleSpectrum'

            % Message the user
            set( handles.message_text , 'String', 'Optimizing Fitting to single spectrum');

            % Update handles structure
            guidata(hObject, handles);

            handles.data.selected = OptimizeFit( handles.data.selected, handles.data.roi.slct , 'Optimize');

            handles.data.target  = SetSelectedSpectrum2Target( handles.data.target , handles.data.choose.type ,...
                handles.data.choose.id_list, handles.data.selected, handles.data.choose.id_measurement , handles.data.choose.id_stress);

        case 'InstrumentSequence'
            if isfield( handles.data.target.InstrumentSequence{ handles.data.choose.id_measurement }, 'OpticalSpectrometer' )

                % Message the user
                set( handles.message_text , 'String', 'Optimizing Fitting to Instrument Sequence Step');

                % Update Selected Spectrum
                handles.data.selected = UpdateSelectedSpectrum( handles.data.target , handles.data.choose.type , ...
                    handles.data.choose.id_list, handles.data.choose.id_stress, handles.data.choose.id_measurement );

                % Fit Current Spectrum
                handles.data.selected = OptimizeFit( handles.data.selected, handles.data.roi.slct , 'Optimize');

                % Update Target
                handles.data.target  = SetSelectedSpectrum2Target( handles.data.target , handles.data.choose.type ,...
                    handles.data.choose.id_list, handles.data.selected, handles.data.choose.id_measurement , handles.data.choose.id_stress);

                % Update handles structure
                guidata(hObject, handles);
            end

        case 'StrainMeasurement'
            if isfield(handles.data.target .InstrumentSequence{ handles.data.choose.id_measurement }.StressSequence{ handles.data.choose.id_stress },'OpticalSpectrometer')
                L = length( handles.data.target.InstrumentSequence{ handles.data.choose.id_measurement }.StressSequence);
                for ix_stress = handles.data.choose.id_stress : L

                    % Message the User
                    set( handles.message_text , 'String', ['Optimizing Fitting to Strain Step ', num2str( ix_stress ),' out of ', num2str( L )] );

                    % Update Selected Spectrum
                    handles.data.selected = UpdateSelectedSpectrum( handles.data.target , handles.data.choose.type , ...
                        handles.data.choose.id_list, ix_stress, handles.data.choose.id_measurement );

                    % Fit Current Spectrum
                    handles.data.selected = OptimizeFit( handles.data.selected, handles.data.roi.slct , 'Optimize');

                    % Update Target
                    handles.data.target  = SetSelectedSpectrum2Target(handles.data.target , handles.data.choose.type ,...
                        handles.data.choose.id_list, handles.data.selected, handles.data.choose.id_measurement , ix_stress );

                    % Update Selectors and Selected Spectrum
                    handles.data = UpdateSelectorsAndData( handles.data );

                    % Update Plot
                    UpdatePlot( handles.plot, handles.data );

                    % Update handles structure
                    guidata(hObject, handles);
                end


            end
    end

    % Message the User
    set( handles.message_text , 'String', ' ' );

    % Update handles structure
    guidata(hObject, handles);

    % Update Plot
    UpdatePlot( handles.plot, handles.data );

    % Update the ROI list
    RefreshRoiList( handles.data, handles.roi_list );
end
