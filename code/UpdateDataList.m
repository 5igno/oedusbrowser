function [data_list, data_names, data_type] = UpdateDataList(data_list)

%get variables in workspace that contain spectra
workspace_list = evalin('base', 'whos;');
data_names = cell(0,0);
data_type = cell(0,0);

ix = 1;
for id_var = 1:length(workspace_list)
    if strcmp(workspace_list(id_var).class,'struct') % could be a spectrum
        dummy_variable = evalin('base', workspace_list(id_var).name);
        
        data_type_var = GetDataType( dummy_variable );

        if ~strcmp(data_type_var, 'Unknown')
            data_names{ix,1} = workspace_list(id_var).name;
            data_type{ix,1} = data_type_var;
            ix = ix + 1;
        end
    end
end
set(data_list,'Visible','on');
set(data_list,'String',data_names(:));
set(data_list,'Value',1);
