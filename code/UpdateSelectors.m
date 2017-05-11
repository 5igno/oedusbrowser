function [id_measurement, id_stress] = UpdateSelectors(target, data_type, id_data_list, id_measurement, select_measurement, measurement_label, measurement_dial, id_stress, select_stress, stress_label, stress_dial)
% function [UIctrl_out] = UpdateSelectors(target, data_type, id_data_list, id_measurement, select_measurement, measurement_label, id_stress, select_stress, stress_label)
% UPDATESELECTORS updates the visibility and the ranges of the instrument
% sequence and strain sequence selectors depending on the properties of the currently
% selected spectrum

if isempty(target)
       % measurement selector: OFF
       set(select_measurement,'Visible','off');
       set(measurement_label,'Visible','off');
       set(measurement_dial,'Visible','off');
       % strain selector: OFF
       set(select_stress,'Visible','off');
       set(stress_label,'Visible','off');
       set(stress_dial,'Visible','off');

else
    switch data_type{id_data_list}
        case {'SingleSpectrum', 'SingleElectricalMeasurement', 'SingleOptoelectronicMeasurement' }
            
            % measurement selector: OFF
            set(select_measurement,'Visible','off');
            set(measurement_label,'Visible','off');
            set(measurement_dial,'Visible','off');
            % strain selector: OFF
            set(select_stress,'Visible','off');
            set(stress_label,'Visible','off');
            set(stress_dial,'Visible','off');
        
        case 'InstrumentSequence'
            % Switch off Measurement selector if only one measurement
            max_select_measurement = length(target.InstrumentSequence);
            if max_select_measurement > 1
                
                if id_measurement > max_select_measurement
                    id_measurement = 1;
                end
                
                % Multiple measurements
                set(select_measurement,'Visible','on');
                set(measurement_label,'Visible','on');
                set(measurement_dial,'Visible','on');

                % update measurement selectors with current values
                set(select_measurement, 'Value', id_measurement );
                set(select_measurement, 'Min', 1);
                set(select_measurement, 'Max', max_select_measurement);
                set(select_measurement, 'SliderStep', [ 1/(max_select_measurement-1) , 1/(max_select_measurement-1) ] );
                set(measurement_dial, 'String', num2str(id_measurement) );
            else
                % Single measurement
                
                set(select_measurement,'Visible','off');
                set(measurement_label,'Visible','off');
                set(measurement_dial,'Visible','off');
             end
            
            % strain selector: OFF
            set(select_stress,'Visible','off');
            set(stress_label,'Visible','off');
            set(stress_dial,'Visible','off');
        
        case 'StrainMeasurement'
            % Switch off measurement selector if only one measurement
            max_select_measurement = length(target.InstrumentSequence);
            if max_select_measurement > 1
                
                if id_measurement > max_select_measurement
                    id_measurement = max_select_measurement;
                end
                
                % Multiple measurements
                set(select_measurement,'Visible','on');
                set(measurement_label,'Visible','on');
                set(measurement_dial,'Visible','on');

                % update selectors with current values
                set(select_measurement, 'Value', id_measurement);
                set(select_measurement, 'Min', 1);
                set(select_measurement, 'Max', max_select_measurement);
                set(select_measurement, 'SliderStep', [ 1/(max_select_measurement-1) , 1/(max_select_measurement-1) ] );
                set(measurement_dial, 'String', num2str(id_measurement) );
            else
                % Single measurement
                
                set(select_measurement,'Visible','off');
                set(measurement_label,'Visible','off');
                set(measurement_dial,'Visible','off');
            end
            
            current_instrument_sequence = target.InstrumentSequence{id_measurement};
            
            % Switch off strain selector if only one measurement
            max_select_stress = length(current_instrument_sequence.StressSequence);
            if max_select_stress > 1
                
                if id_stress > max_select_stress
                    id_stress = max_select_stress;
                end
                
                % strain selector: ON
                % reset index to 1 if out of bounds
                set(select_stress,'Visible','on');
                set(stress_label,'Visible','on');
                set(stress_dial,'Visible','on');

                % update selectors with current values
                set(select_stress, 'Value', id_stress);
                set(select_stress, 'Min', 1);
                set(select_stress, 'Max', max_select_stress);
                set(select_stress, 'SliderStep', [ 1/(max_select_stress-1) , 1/(max_select_stress-1) ] );
                set(stress_dial, 'String', num2str(id_stress) )
            else
                % Single measurement
                
                % strain selector: OFF
                set(select_stress,'Visible','off');
                set(stress_label,'Visible','off');
                set(stress_dial,'Visible','off');
            end
            
    end
end
 
% UIctrl_out = {id_measurement; select_measurement; measurement_label; id_stress; select_stress; stress_label };

