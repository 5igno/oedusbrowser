function handles = CopyRoiButtonCallback(handles)

if isfield( handles.data.selected, 'FittingParameters' )
    handles.data.FittingParameters = handles.data.selected.FittingParameters;
end

% UpdateRoiControls(handles);
