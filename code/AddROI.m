function ranges = AddROI( ranges, roi_choice, spectrum, x_type, message_text_handle )

if not( isempty( spectrum ) ) % You can select a range only if the selected spectrum is not empty
    % Ranges already present
    switch roi_choice
        case 1 % Raman
            ix =  GetRangeFromGraph( message_text_handle , 'Select the ROI containing the Raman signal', x_type, spectrum );
            ranges = UpdateRanges( ranges, ix, 'Raman' );
            
        case 2 % Photoluminescence
            ix =  GetRangeFromGraph( message_text_handle , 'Select the ROI containing the photoluminescence signal', x_type, spectrum );
            ranges = UpdateRanges( ranges, ix, 'Photoluminescence' );
            
        case 3 % Rayliegh line
            ix =  GetRangeFromGraph( message_text_handle , 'Select the ROI containing the Rayleigh line', x_type, spectrum );
            ranges = UpdateRanges( ranges, ix, 'Rayleigh line' );

        case 4 % Background
            ix =  GetRangeFromGraph( message_text_handle , 'Select the ROI containing the significant part of the spectrum', x_type, spectrum );
            ranges = UpdateRanges( ranges, ix, 'Background' );
    end
end

% Clear message bar
set( message_text_handle, 'String', ' ' );

% SingleSpectrumPlot( selected_spectrum, plottype , ix , gcf , gca ,'g');
% ranges = [ranges; {'Raman', ix }];
% 
% selected=[];
% for k=3+israyleigh:N_regions+2+israyleigh
% 	% iteratively take the set union over the selected areas
%     selected = union(selected,ranges{k,2});
% end
% 
% background_id = setdiff(ranges{2,2},selected);   % to obtain the background region we subtract the selected areas to the overview range
% ranges = [ranges; {'Background',background_id }];


