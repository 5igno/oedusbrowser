function RefreshRoiList( data, roi_list_hndl )
% RefreshRoiList( handles.data, handles.roi_list );
if isfield( data,'selected' )
    if isfield( data.selected, 'FittingParameters' )
        if isempty( data.selected.FittingParameters )
            roi_label = {} ;
        else
            roi_label = data.selected.FittingParameters(:,1) ;
        end
        set( roi_list_hndl, 'String', roi_label );
    else
        set( roi_list_hndl, 'String', {} );
    end
    set( roi_list_hndl, 'Value', data.roi.slct );
end