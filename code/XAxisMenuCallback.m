function handles = XAxisMenuCallback(hObject, handles)

handles.plot.optical.x_type = GetXaxis(hObject);
UpdatePlot( handles.plot, handles.data );
