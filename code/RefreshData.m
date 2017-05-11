function handles = RefreshDataList(handles)

% Update the list of spectra with the stuff you found on the workspace
[handles.data_list, handles.spectra_array, handles.spectra_type] = UpdateSpectraList(handles.data_list);

% Update Target
handles.target = UpdateTargetVariable(handles.spectra_array, handles.id_spectra_list);

% Change selector visibility and range of depending on the targeted spectrum
[UIctrl_out] = UpdateSelectors( handles.target, handles.spectra_type, handles.id_spectra_list, ...
    handles.id_measurement, handles.measurement_slider, handles.measurement_label, ...
    handles.id_stress, handles.stress_slider, handles.stress_label);

handles.measurement_slider = UIctrl_out{1};
handles.measurement_label = UIctrl_out{2};
handles.stress_slider = UIctrl_out{3};
handles.stress_label= UIctrl_out{4};

% Update Selected Spectrum
handles.selected_spectrum = UpdateSelectedSpectrum( handles.target, handles.spectra_type, ...
    handles.id_spectra_list, handles.id_stress, handles.id_measurement);

% Plot Updated Spectrum
handles.spectrum_axes = UpdateSpectrumPlot(handles.selected_spectrum, handles.spectrum_axes);
