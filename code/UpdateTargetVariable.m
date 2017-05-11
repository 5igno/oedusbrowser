function [ target, selected_type, n_measurements, n_stress, max_stress] = UpdateTargetVariable( data_names, data_type, id_data_list )

max_stress = [];
n_measurements = [];
n_stress= [];
if isempty(data_names)
    target = [] ;
    selected_type = 'Unknown' ;
else 
    target = evalin( 'base', data_names{ id_data_list } );
    selected_type = data_type{ id_data_list };
    switch selected_type 
        case 'InstrumentSequence'
            n_measurements = length(target.InstrumentSequence);
        case 'StrainMeasurement'
            n_measurements = length(target.InstrumentSequence);
            n_stress = length(target.InstrumentSequence{1}.StressSequence );
            for ix = 1 : n_stress
                if isempty(max_stress)
                    max_stress = abs( target.InstrumentSequence{1}.StressSequence{ix}.MotorPosition );
                else
                    max_stress = max( max_stress, abs(target.InstrumentSequence{1}.StressSequence{ix}.MotorPosition) );
                end
            end
    end
end

