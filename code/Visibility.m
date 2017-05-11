function Visibility( panel_hndls, toggle )

if isstruct( panel_hndls )
    field_name = fieldnames( panel_hndls );
    new_hndls_list = [];
    for id = 1:length(field_name)
        new_hndls_list(id) = eval(['panel_hndls.',field_name{id},';']);
    end
    panel_hndls = new_hndls_list;
end
for id = 1: length( panel_hndls )
    set( panel_hndls(id) , 'Visible', toggle );
end