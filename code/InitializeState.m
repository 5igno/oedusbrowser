function [ data, plotStr ] = InitializeState
% [ handles.data, handles.plot ] = InitializeState

data.choose.id_list = 1;
data.choose.id_measurement = 1;
data.choose.id_stress = 1;
data.roi.choice = 1;
data.roi.slct = 1;
data.color = lines(1);

plotStr.optical.x_type = 'RamanShift';
plotStr.optical.y_type = 'Linear';
plotStr.electrical.type = 'Traces';
plotStr.electrical.differential_range = 5;
