function handles = UpdateTarget(handles)



% Change selector visibility and range of depending on the targeted spectrum
[UIctrl_out] = UpdateSelectors( handles.target, handles.spectra_type, handles.id_data_list, ...
    handles.id_measurement, handles.measurement_slider, handles.measurement_label, ...
    handles.id_stress, handles.stress_slider, handles.stress_label);

handles.measurement_slider = UIctrl_out{1};
handles.measurement_label = UIctrl_out{2};
handles.stress_slider = UIctrl_out{3};
handles.stress_label= UIctrl_out{4};

% Update Selected Spectrum
handles.selected_spectrum = UpdateSelectedSpectrum( handles.target, handles.spectra_type, ...
    handles.id_data_list, handles.id_stress, handles.id_measurement);
