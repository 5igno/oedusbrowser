function  selected_data = UpdateSelectedSpectrum(target, data_type, id_data_list, id_stress, id_measurement)

if isempty(target)
    selected_data = [];
else
    % Get Spectrum Candidate
    switch data_type{id_data_list}
        case 'SingleSpectrum'
            spectrum_candidate = target;
        
        case 'InstrumentSequence'
            spectrum_candidate = target.InstrumentSequence{id_measurement};
            
        case 'StrainMeasurement'
            spectrum_candidate = target.InstrumentSequence{id_measurement}.StressSequence{id_stress};
            
    end
    
    % Confirm if spectrum or set empty
    if isfield(spectrum_candidate ,'OpticalSpectrometer')
        selected_data = spectrum_candidate;
    else
        selected_data = [];
    end
end



