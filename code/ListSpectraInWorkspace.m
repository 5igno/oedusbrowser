function [spectra_array, spectra_type] = ListSpectraInWorkspace(workspace_list)
%     LISTSPECTRAINWORKSPACE searches for valid variables containing
%     optical spectra and  returns a list of them with their respective
%     type, which can be 'SingleSpectrum', 'InstrumentSequence' or 'StrainMeasurement'

ix = 1;
spectra_array = cell(0,0);
spectra_type = cell(0,0);
for id_var = 1:length(workspace_list)
    if strcmp(workspace_list(id_var).class,'struct') % could be a spectrum
        dummy_variable = evalin('base', workspace_list(id_var).name);
        
        if isfield(dummy_variable,'OpticalSpectrometer') % single spectrum
            spectra_array{ix,1} = workspace_list(id_var).name;
            spectra_type{ix,1} = 'SingleSpectrum';
            ix = ix + 1;
        end
        
        if isfield(dummy_variable,'InstrumentSequence')
            for id_IS = 1:length(dummy_variable.InstrumentSequence)
                sequence_step = dummy_variable.InstrumentSequence{id_IS};
                if isfield(sequence_step,'OpticalSpectrometer') % optical measurement in instrument sequence
                    spectra_array{ix,1} = workspace_list(id_var).name;
                    spectra_type{ix,1} = 'InstrumentSequence';
                    ix = ix + 1;
                end
                if isfield(sequence_step,'StressSequence')
                    if isfield(sequence_step.StressSequence{1},'OpticalSpectrometer') %optical measurement in strain measurement
                       spectra_array{ix} = workspace_list(id_var).name;
                       spectra_type{ix} = 'StrainMeasurement';
                       ix = ix + 1;
                    end
                end
            end
        end
    end
end
