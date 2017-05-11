function target = SetSelectedSpectrum2Target(target, spectra_type, id_data_list, selected_spectrum, id_measurement, id_stress)

if not(isempty(target))
    switch spectra_type{id_data_list}
        case 'SingleSpectrum'
            target = selected_spectrum;
        
        case 'InstrumentSequence'
            target.InstrumentSequence{id_measurement} = selected_spectrum;
        
        case 'StrainMeasurement'
            target.InstrumentSequence{id_measurement}.StressSequence{id_stress} = selected_spectrum;
    end
end