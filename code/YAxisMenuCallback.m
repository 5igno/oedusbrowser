function handles = YAxisMenuCallback(hObject, handles)

handles.plot.optical.y_type = GetYaxis(hObject);
% Update Plot 
UpdatePlot( handles.plot, handles.data );

