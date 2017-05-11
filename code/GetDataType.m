function data_type = GetDataType( data )

type_found = 0;

if isfield(data,'OpticalSpectrometer') && ~(isfield(data,{'SwitchingMatrix', 'ParameterAnalyzer'})*[1;1]) % single spectrum
    data_type = 'SingleSpectrum';
    type_found = 1;
end

if ~isfield(data,'OpticalSpectrometer') && (isfield(data,{'SwitchingMatrix', 'ParameterAnalyzer'})*[1;1]) % single spectrum
    data_type = 'SingleElectricalMeasurement';
    type_found = 1;
end

if isfield(data,'OpticalSpectrometer') && isfield(data,{'SwitchingMatrix', 'ParameterAnalyzer'})*[1;1] % single spectrum
    data_type = 'SingleOptoelectronicMeasurement';
    type_found = 1;
end

if isfield(data,'InstrumentSequence')
    sequence_step = data.InstrumentSequence{1} ;
    
    if isfield(sequence_step,'StressSequence')
        data_type = 'StrainMeasurement';
    else
        data_type = 'InstrumentSequence';
    end
    
    type_found = 1;
end

if type_found == 0
    data_type = 'Unknown';
end
