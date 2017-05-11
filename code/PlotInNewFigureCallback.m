function handles = PlotInNewFigureCallback(hObject, handles)

figure

handles.plot.optical.hndl.spectrum_axes          = handles.spectrum_axes;
handles.plot.electrical.hndl.iv_panel            = handles.iv_panel;

handles.plot.optical.x_type = GetXaxis(hObject);
UpdatePlot( handles.plot, handles.data );
