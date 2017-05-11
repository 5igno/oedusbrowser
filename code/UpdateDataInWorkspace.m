function UpdateDataInWorkspace(target,data_names,id_data_list)

if ~isempty(data_names)
    variable_name = data_names{id_data_list};

    if ~isempty(target) && ~isempty(variable_name)
        assignin('base', variable_name, target);
    end
end
