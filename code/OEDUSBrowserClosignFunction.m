function OEDUSBrowserClosignFunction(handles)

if isfield(handles,'target')
    % Update Data in Workspace wit current Target
    UpdateDataInWorkspace(handles.target,handles.data_names,handles.id_data_list);
end