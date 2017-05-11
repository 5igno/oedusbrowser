function PlotSpectraROI(selected_spectrum, x_type, spectrum_axes)

roi_types = {'RawData', 'Background', 'Raman', 'Photoluminescence', 'Rayleigh line'};
colors = {'k','b','g','r','c'};

for id_type = 1:length(roi_types)
    
    % Define current roi type
    roi_type = roi_types{id_type};
    
    % Add label inthe selected_spectrum structure
    switch roi_type
        case {'Background','Raman', 'Photoluminescence', 'Rayleigh line', 'Background'}
            selected_spectrum.label = roi_type;
        otherwise
            if isfield(selected_spectrum, 'label')
                selected_spectrum = rmfield(selected_spectrum,'label');
            end
    end
    
    % Extract a cell array, containing the indexes of all ROIs of the selected type
    indexes = IndexAtROI( selected_spectrum, roi_type );
    
    % Plot all ranges of this type
    for id_cell = 1:length(indexes)
        PlotSingleSpectrum(selected_spectrum, x_type, spectrum_axes, colors{id_type}, indexes{id_cell});
    end
end
        