function selected_roi = WhereIsTheROI( roi, roi_type )

selected_roi = find( strcmp( roi(:,1), roi_type ));
