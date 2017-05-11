function  target = SelectedSpectrum2Target(spectrum, target, spectra_type, id_stress, id_measurement)

if ~isempty(spectrum)
    % Update target with selected spectrum
    switch spectra_type
        case 'SingleSpectrum'
            target = spectrum;

        case 'InstrumentSequence'
            target.InstrumentSequence{id_measurement} = spectrum;

        case 'StrainMeasurement'
            target.InstrumentSequence{id_measurement}.StressSequence{id_stress} = spectrum;

    end
end


