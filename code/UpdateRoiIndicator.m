function UpdateRoiIndicator(handles)

switch handles.has_fit
    case 0
        visibility = 'off';
    case 1
        visibility = 'on';
end

set(handles.get_roi_button,'Visible',visibility);
set(handles.fit_roi_button,'Visible',visibility);

