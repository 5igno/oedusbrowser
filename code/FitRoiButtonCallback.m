function handles = FitRoiButtonCallback(handles)

% Fit Current Spectrum
handles.data.selected = OptimizeFit( handles.data.selected, handles.data.roi.slct, 'Define');

handles.data.target = SetSelectedSpectrum2Target( handles.data.target, handles.data.choose.type,...
    handles.data.choose.id_list, handles.data.selected, handles.data.choose.id_measurement, handles.data.choose.id_stress );

% Update Selectors and Selected Spectrum
UpdatePlot( handles.plot, handles.data );

% % Update Selectors and Selected Spectrum
% handles = UpdateSelectorsAndData(handles);

% Update Plot
UpdatePlot( handles.plot, handles.data );
