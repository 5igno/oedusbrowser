function ix_cell = IndexAtROI( selected_spectrum, roi_type )

roi = selected_spectrum.ROI;

switch roi_type
    case {'Raman', 'Photoluminescence', 'Rayleigh line'}
        selected_roi = find( strcmp( roi(:,1), roi_type ) );
        ix_cell = cell(length(selected_roi),1);
        
        for k = 1:length(selected_roi)
            ix_cell{k} = roi{selected_roi(k),2};
        end
        
    case 'Background'
        selected_roi = find( strcmp( roi(:,1), roi_type ) );
        
        ix = [];
        % Union of the backgrounds
        for k = 1:length(selected_roi)
            ix = union( ix, roi{selected_roi(k),2} );
        end
        ix_cell = {ix};
        
    case 'RawData'
        ix = (1:length(selected_spectrum.Intensity));
        ix_cell = {ix};
        
end
