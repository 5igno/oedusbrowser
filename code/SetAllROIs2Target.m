function target = SetAllROIs2Target(roi, target, spectra_type, id_data_list, id_measurement)

if not(isempty(target))
    if isempty(roi) % remove ROI field
        switch spectra_type{id_data_list}
            case 'SingleSpectrum'
                if isfield(target,'ROI')
                    target = rmfield(target,'ROI');
                end
                
            case 'InstrumentSequence'
                if isfield(target.InstrumentSequence{id_measurement} ,'ROI')
                    target.InstrumentSequence{id_measurement} =...
                        rmfield(target.InstrumentSequence{id_measurement},'ROI');
                end
            
            case 'StrainMeasurement'
                for id_stress = 1:length(target.InstrumentSequence{id_measurement})
                    if isfield(target.InstrumentSequence{id_measurement}.StressSequence{id_stress},'ROI')
                        target.InstrumentSequence{id_measurement}.StressSequence{id_stress} =...
                            rmfield(target.InstrumentSequence{id_measurement}.StressSequence{id_stress},'ROI');
                    end
                end
        end
    else
        switch spectra_type{id_data_list}
            case 'SingleSpectrum'
                target.ROI = roi;

            case 'InstrumentSequence'
                target.InstrumentSequence{id_measurement}.ROI = roi;

            case 'StrainMeasurement'
                for id_stress = 1:length(target.InstrumentSequence{id_measurement}.StressSequence)
                    target.InstrumentSequence{id_measurement}.StressSequence{id_stress}.ROI = roi;
                end
        end
            
    end
end