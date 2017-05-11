function roi_label_array = RoiLabelArray(ranges)

if isempty(ranges)
    roi_label_array = '';
    
else
    [N_ROI , ~] = size(ranges);
    roi_label_array = cell( N_ROI, 1);

    for id_roi = 1:N_ROI
        roi_label_array{id_roi ,1} = ranges{id_roi,1};
    end
end
