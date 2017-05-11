function data = UpdateSelectorsAndData( data )

target = data.target ;
if ~isempty(target)
    type = data.choose.type ;
    id_list = data.choose.id_list ;
    id_measurement = data.choose.id_measurement ;
    id_stress = data.choose.id_stress ;
    measurement_slider_hndl = data.hndl.measurement_slider;
    measurement_label_hndl = data.hndl.measurement_label;
    measurement_dial_hndl = data.hndl.measurement_dial ;
    stress_slider_hndl = data.hndl.stress_slider;
    stress_label_hndl = data.hndl.stress_label;
    stress_dial_hndl = data.hndl.stress_dial ;
    
    % Change selector visibility and range of depending on the targeted spectrum
    [ id_measurement, id_stress ] =  UpdateSelectors( target, type, id_list,...
        id_measurement, measurement_slider_hndl, measurement_label_hndl, measurement_dial_hndl,...
        id_stress, stress_slider_hndl, stress_label_hndl, stress_dial_hndl );
    
    data.choose.id_measurement = id_measurement;
    data.choose.id_stress = id_stress;

    % Update Selected Spectrum
    data.selected = UpdateSelectedData( target, type, id_list, id_stress, id_measurement );
    
    switch type{id_list}
        case {'SingleSpectrum', 'SingleElectricalMeasurement', 'SingleOptoelectronicMeasurement', 'InstrumentSequence' }
            data.color = lines(1);
        case 'StrainMeasurement'
            data.color = TensileCompressionColor( ( data.selected.MotorPosition + data.max_stress )/(2*data.max_stress) );
    end
end

