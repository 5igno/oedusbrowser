function handles = GetSpectrumRoi(handles)

if isfield(handles.selected_spectrum,'FittignParameters')
    handles.roi_buffered = 1;
    handles.FittingParameters = handles.selected_spectrum.FittingParameters;
end
