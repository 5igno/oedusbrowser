function UpdateRoiControls(handles)

set(handles.roi_list, 'Value', handles.roi_slct ); 
set(handles.roi_list, 'String', handles.selected_spectrum.FittingParameters(:,1) );
% set(handles.set_roi_button,'Value',handles.has_roi);