function  selected_data = UpdateSelectedData(target, data_type, id_data_list, id_stress, id_measurement)

if isempty(target)
    selected_data = [];
else
    % Get Spectrum Candidate
    switch data_type{id_data_list}
        case {'SingleSpectrum', 'SingleElectricalMeasurement', 'SingleOptoelectronicMeasurement' }
            data_candidate = target;
            
        case 'InstrumentSequence'
            data_candidate = target.InstrumentSequence{id_measurement};
            
        case 'StrainMeasurement'
            data_candidate = target.InstrumentSequence{id_measurement}.StressSequence{id_stress};
            
    end
    
    % Confirm if spectrum, IV or set empty
    if isfield( data_candidate, {'OpticalSpectrometer','SwitchingMatrix','ParameterAnalyzer'} )*[1;1;1]
        selected_data = data_candidate;
    else
        selected_data = [];
    end
end



